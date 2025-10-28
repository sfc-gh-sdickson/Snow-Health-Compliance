-- ============================================================================
-- Snow Health Intelligence Agent - Model Registry Wrapper Functions
-- ============================================================================
-- Purpose: Create SQL functions that wrap Model Registry models
--          so they can be added as tools to the Intelligence Agent
-- Based on: Model Registry integration pattern
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- Procedure 1: Compliance Risk Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_COMPLIANCE_RISK(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_COMPLIANCE_RISK(
    DEPARTMENT_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_compliance_risk'
COMMENT = 'Calls COMPLIANCE_RISK_PREDICTOR model from Model Registry to identify at-risk employees'
AS
$$
def predict_compliance_risk(session, department_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model from registry
    reg = Registry(session)
    model = reg.get_model("COMPLIANCE_RISK_PREDICTOR").default
    
    # Build query with optional filter
    dept_filter = f"AND e.department = '{department_filter}'" if department_filter else ""
    
    query = f"""
    SELECT
        o.organization_type,
        e.job_role,
        e.department,
        COUNT(DISTINCT ce.enrollment_id)::FLOAT AS total_enrollments,
        COUNT(DISTINCT cc.completion_id)::FLOAT AS total_completions,
        AVG(CASE WHEN cc.completion_status = 'COMPLETED' THEN cc.score ELSE 0 END)::FLOAT AS avg_score,
        COUNT(DISTINCT CASE WHEN ce.due_date < CURRENT_DATE() 
                           AND cc.completion_id IS NULL 
                           THEN ce.enrollment_id END)::FLOAT AS overdue_courses,
        COUNT(DISTINCT cr.credential_id)::FLOAT AS credential_count,
        COUNT(DISTINCT CASE WHEN cr.expiration_date < DATEADD('day', 90, CURRENT_DATE())
                           THEN cr.credential_id END)::FLOAT AS expiring_credentials,
        COUNT(DISTINCT pa.acknowledgment_id)::FLOAT AS policies_acknowledged,
        AVG(DATEDIFF('day', pa.acknowledgment_date, CURRENT_DATE()))::FLOAT AS avg_days_since_ack,
        COUNT(DISTINCT i.incident_id)::FLOAT AS incident_count,
        FALSE::BOOLEAN AS has_compliance_risk
    FROM RAW.EMPLOYEES e
    JOIN RAW.ORGANIZATIONS o ON e.organization_id = o.organization_id
    LEFT JOIN RAW.COURSE_ENROLLMENTS ce ON e.employee_id = ce.employee_id
    LEFT JOIN RAW.COURSE_COMPLETIONS cc ON ce.enrollment_id = cc.enrollment_id
    LEFT JOIN RAW.CREDENTIALS cr ON e.employee_id = cr.employee_id
    LEFT JOIN RAW.POLICY_ACKNOWLEDGMENTS pa ON e.employee_id = pa.employee_id
    LEFT JOIN RAW.INCIDENTS i ON e.employee_id = i.reported_by_employee_id
    WHERE e.employee_status = 'ACTIVE' {dept_filter}
    GROUP BY e.employee_id, o.organization_type, e.job_role, e.department
    HAVING COUNT(DISTINCT ce.enrollment_id) > 2
    LIMIT 20
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Count high-risk employees
    result = predictions.select("COMPLIANCE_RISK_PREDICTION").to_pandas()
    high_risk_count = int(result['COMPLIANCE_RISK_PREDICTION'].sum())
    total_count = len(result)
    
    return json.dumps({
        "department_filter": department_filter or "ALL",
        "total_employees_analyzed": total_count,
        "high_risk_employees": high_risk_count,
        "risk_rate_pct": round(high_risk_count / total_count * 100, 2) if total_count > 0 else 0
    })
$$;

-- ============================================================================
-- Procedure 2: Course Completion Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_COURSE_COMPLETION(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_COURSE_COMPLETION(
    COURSE_CATEGORY_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_course_completion'
COMMENT = 'Calls COURSE_COMPLETION_PREDICTOR model to predict enrollment completion likelihood'
AS
$$
def predict_course_completion(session, course_category_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("COURSE_COMPLETION_PREDICTOR").default
    
    # Build query
    category_filter = f"AND c.course_category = '{course_category_filter}'" if course_category_filter else ""
    
    query = f"""
    SELECT
        c.course_category,
        c.course_type,
        e.job_role,
        e.department,
        o.organization_type,
        DATEDIFF('day', ce.enrollment_date, ce.due_date)::FLOAT AS days_to_complete,
        DATEDIFF('day', ce.enrollment_date, CURRENT_DATE())::FLOAT AS days_since_enrollment,
        (SELECT COUNT(DISTINCT cc2.completion_id)::FLOAT / NULLIF(COUNT(DISTINCT ce2.enrollment_id)::FLOAT, 0)
         FROM RAW.COURSE_ENROLLMENTS ce2
         LEFT JOIN RAW.COURSE_COMPLETIONS cc2 ON ce2.enrollment_id = cc2.enrollment_id
         WHERE ce2.employee_id = e.employee_id
           AND ce2.enrollment_date < ce.enrollment_date) AS historical_completion_rate,
        FALSE::BOOLEAN AS was_completed
    FROM RAW.COURSE_ENROLLMENTS ce
    JOIN RAW.COURSES c ON ce.course_id = c.course_id
    JOIN RAW.EMPLOYEES e ON ce.employee_id = e.employee_id
    JOIN RAW.ORGANIZATIONS o ON e.organization_id = o.organization_id
    WHERE ce.enrollment_date >= DATEADD('month', -3, CURRENT_DATE())
      AND ce.due_date > CURRENT_DATE()
      AND NOT EXISTS (SELECT 1 FROM RAW.COURSE_COMPLETIONS cc WHERE cc.enrollment_id = ce.enrollment_id)
      {category_filter}
    LIMIT 30
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate likely completion rate
    result = predictions.select("COMPLETION_PREDICTION").to_pandas()
    likely_to_complete = int(result['COMPLETION_PREDICTION'].sum())
    total_enrollments = len(result)
    
    return json.dumps({
        "course_category_filter": course_category_filter or "ALL",
        "total_active_enrollments": total_enrollments,
        "predicted_to_complete": likely_to_complete,
        "completion_rate_pct": round(likely_to_complete / total_enrollments * 100, 2) if total_enrollments > 0 else 0
    })
$$;

-- ============================================================================
-- Procedure 3: Subscription Churn Prediction Wrapper
-- ============================================================================

-- Drop if exists (in case it was created as FUNCTION before)
DROP FUNCTION IF EXISTS PREDICT_SUBSCRIPTION_CHURN(STRING);

CREATE OR REPLACE PROCEDURE PREDICT_SUBSCRIPTION_CHURN(
    SERVICE_TYPE_FILTER STRING
)
RETURNS STRING
LANGUAGE PYTHON
RUNTIME_VERSION = '3.10'
PACKAGES = ('snowflake-ml-python', 'scikit-learn')
HANDLER = 'predict_subscription_churn'
COMMENT = 'Calls SUBSCRIPTION_CHURN_PREDICTOR model to identify subscriptions at risk of cancellation'
AS
$$
def predict_subscription_churn(session, service_type_filter):
    from snowflake.ml.registry import Registry
    import json
    
    # Get model
    reg = Registry(session)
    model = reg.get_model("SUBSCRIPTION_CHURN_PREDICTOR").default
    
    # Build query
    service_filter = f"AND s.service_type = '{service_type_filter}'" if service_type_filter else ""
    
    query = f"""
    SELECT
        o.organization_type,
        s.service_type,
        s.subscription_tier,
        o.lifetime_value::FLOAT AS lifetime_value,
        o.compliance_risk_score::FLOAT AS compliance_risk_score,
        DATEDIFF('month', s.start_date, CURRENT_DATE())::FLOAT AS subscription_age_months,
        s.monthly_price::FLOAT AS monthly_price,
        COUNT(DISTINCT e.employee_id)::FLOAT AS active_employees,
        COUNT(DISTINCT ce.enrollment_id)::FLOAT AS total_enrollments,
        COUNT(DISTINCT st.ticket_id)::FLOAT AS support_tickets,
        AVG(st.customer_satisfaction_score)::FLOAT AS avg_csat,
        COUNT(DISTINCT CASE WHEN t.transaction_date >= DATEADD('month', -3, CURRENT_DATE())
                           THEN t.transaction_id END)::FLOAT AS recent_transactions,
        COUNT(DISTINCT i.incident_id)::FLOAT AS incident_count,
        FALSE::BOOLEAN AS is_churned
    FROM RAW.ORGANIZATIONS o
    JOIN RAW.SUBSCRIPTIONS s ON o.organization_id = s.organization_id
    LEFT JOIN RAW.EMPLOYEES e ON o.organization_id = e.organization_id AND e.employee_status = 'ACTIVE'
    LEFT JOIN RAW.COURSE_ENROLLMENTS ce ON e.employee_id = ce.employee_id
    LEFT JOIN RAW.SUPPORT_TICKETS st ON o.organization_id = st.organization_id
    LEFT JOIN RAW.TRANSACTIONS t ON s.subscription_id = t.subscription_id
    LEFT JOIN RAW.INCIDENTS i ON o.organization_id = i.organization_id
    WHERE s.subscription_status = 'ACTIVE' {service_filter}
    GROUP BY o.organization_id, o.organization_type, s.service_type, s.subscription_tier,
             o.lifetime_value, o.compliance_risk_score, s.start_date, s.monthly_price
    HAVING COUNT(DISTINCT e.employee_id) > 5
    LIMIT 25
    """
    
    input_df = session.sql(query)
    
    # Get predictions
    predictions = model.run(input_df, function_name="predict")
    
    # Calculate churn risk
    result = predictions.select("CHURN_PREDICTION").to_pandas()
    at_risk_count = int(result['CHURN_PREDICTION'].sum())
    total_subscriptions = len(result)
    
    return json.dumps({
        "service_type_filter": service_type_filter or "ALL",
        "total_subscriptions_analyzed": total_subscriptions,
        "at_risk_of_churn": at_risk_count,
        "churn_risk_pct": round(at_risk_count / total_subscriptions * 100, 2) if total_subscriptions > 0 else 0
    })
$$;

-- ============================================================================
-- Test the wrapper functions
-- ============================================================================

SELECT 'ML model wrapper functions created successfully' AS status;

-- Test each procedure (uncomment after models are registered via notebook)
/*
CALL PREDICT_COMPLIANCE_RISK('NURSING');
CALL PREDICT_COURSE_COMPLETION('CLINICAL');
CALL PREDICT_SUBSCRIPTION_CHURN('LEARNING');
*/

SELECT 'Execute notebook first to register models, then uncomment tests above' AS instruction;

