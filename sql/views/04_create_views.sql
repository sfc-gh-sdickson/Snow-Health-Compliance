-- ============================================================================
-- Snow Health Intelligence Agent - Analytical Views
-- ============================================================================
-- Purpose: Create curated analytical views for business intelligence
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- Organization 360 View
-- ============================================================================
CREATE OR REPLACE VIEW V_ORGANIZATION_360 AS
SELECT
    o.organization_id,
    o.organization_name,
    o.contact_email,
    o.contact_phone,
    o.country,
    o.state,
    o.city,
    o.signup_date,
    o.organization_status,
    o.organization_type,
    o.lifetime_value,
    o.compliance_risk_score,
    o.total_employees,
    COUNT(DISTINCT e.employee_id) AS active_employees,
    COUNT(DISTINCT s.subscription_id) AS total_subscriptions,
    COUNT(DISTINCT t.transaction_id) AS total_transactions,
    SUM(t.total_amount) AS total_revenue,
    COUNT(DISTINCT st.ticket_id) AS total_support_tickets,
    AVG(st.satisfaction_rating) AS avg_satisfaction_rating,
    COUNT(DISTINCT ce.enrollment_id) AS total_course_enrollments,
    COUNT(DISTINCT cc.completion_id) AS total_course_completions,
    COUNT(DISTINCT cr.credential_id) AS total_credentials,
    COUNT(DISTINCT i.incident_id) AS total_incidents,
    o.created_at,
    o.updated_at
FROM RAW.ORGANIZATIONS o
LEFT JOIN RAW.EMPLOYEES e ON o.organization_id = e.organization_id AND e.employee_status = 'ACTIVE'
LEFT JOIN RAW.SUBSCRIPTIONS s ON o.organization_id = s.organization_id
LEFT JOIN RAW.TRANSACTIONS t ON o.organization_id = t.organization_id
LEFT JOIN RAW.SUPPORT_TICKETS st ON o.organization_id = st.organization_id
LEFT JOIN RAW.COURSE_ENROLLMENTS ce ON o.organization_id = ce.organization_id
LEFT JOIN RAW.COURSE_COMPLETIONS cc ON ce.enrollment_id = cc.enrollment_id
LEFT JOIN RAW.CREDENTIALS cr ON o.organization_id = cr.organization_id
LEFT JOIN RAW.INCIDENTS i ON o.organization_id = i.organization_id
GROUP BY
    o.organization_id, o.organization_name, o.contact_email, o.contact_phone, 
    o.country, o.state, o.city, o.signup_date, o.organization_status, 
    o.organization_type, o.lifetime_value, o.compliance_risk_score, 
    o.total_employees, o.created_at, o.updated_at;

-- ============================================================================
-- Employee Training Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_EMPLOYEE_TRAINING_ANALYTICS AS
SELECT
    e.employee_id,
    e.organization_id,
    o.organization_name,
    e.employee_name,
    e.email,
    e.job_title,
    e.department,
    e.employee_status,
    e.compliance_status,
    e.last_training_date,
    COUNT(DISTINCT ce.enrollment_id) AS total_enrollments,
    COUNT(DISTINCT CASE WHEN ce.enrollment_status = 'COMPLETED' THEN ce.enrollment_id END) AS completed_enrollments,
    COUNT(DISTINCT CASE WHEN ce.enrollment_status = 'IN_PROGRESS' THEN ce.enrollment_id END) AS in_progress_enrollments,
    COUNT(DISTINCT CASE WHEN ce.enrollment_status = 'NOT_STARTED' THEN ce.enrollment_id END) AS not_started_enrollments,
    COUNT(DISTINCT CASE WHEN ce.is_mandatory = TRUE AND ce.enrollment_status != 'COMPLETED' THEN ce.enrollment_id END) AS overdue_mandatory_courses,
    COUNT(DISTINCT cc.completion_id) AS total_completions,
    AVG(cc.score) AS avg_course_score,
    SUM(cc.time_spent_minutes) AS total_training_minutes,
    COUNT(DISTINCT CASE WHEN cc.certificate_issued = TRUE THEN cc.completion_id END) AS certificates_earned,
    e.created_at,
    e.updated_at
FROM RAW.EMPLOYEES e
JOIN RAW.ORGANIZATIONS o ON e.organization_id = o.organization_id
LEFT JOIN RAW.COURSE_ENROLLMENTS ce ON e.employee_id = ce.employee_id
LEFT JOIN RAW.COURSE_COMPLETIONS cc ON ce.enrollment_id = cc.enrollment_id
GROUP BY
    e.employee_id, e.organization_id, o.organization_name, e.employee_name, 
    e.email, e.job_title, e.department, e.employee_status, e.compliance_status, 
    e.last_training_date, e.created_at, e.updated_at;

-- ============================================================================
-- Credential Compliance Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_CREDENTIAL_COMPLIANCE_ANALYTICS AS
SELECT
    e.employee_id,
    e.organization_id,
    o.organization_name,
    e.employee_name,
    e.job_title,
    e.department,
    e.requires_credentialing,
    e.compliance_status,
    COUNT(DISTINCT cr.credential_id) AS total_credentials,
    COUNT(DISTINCT CASE WHEN cr.credential_status = 'ACTIVE' THEN cr.credential_id END) AS active_credentials,
    COUNT(DISTINCT CASE WHEN cr.credential_status = 'EXPIRED' THEN cr.credential_id END) AS expired_credentials,
    COUNT(DISTINCT CASE WHEN cr.expiration_date BETWEEN CURRENT_DATE() AND DATEADD('day', 90, CURRENT_DATE()) THEN cr.credential_id END) AS credentials_expiring_soon,
    COUNT(DISTINCT cv.verification_id) AS total_verifications,
    COUNT(DISTINCT CASE WHEN cv.verification_status = 'VERIFIED' THEN cv.verification_id END) AS verified_credentials,
    COUNT(DISTINCT CASE WHEN cv.verification_status = 'PENDING' THEN cv.verification_id END) AS pending_verifications,
    COUNT(DISTINCT em.monitoring_id) AS total_exclusion_checks,
    COUNT(DISTINCT CASE WHEN em.exclusion_found = TRUE THEN em.monitoring_id END) AS exclusions_found,
    MAX(em.monitoring_date) AS last_exclusion_check_date,
    e.created_at,
    e.updated_at
FROM RAW.EMPLOYEES e
JOIN RAW.ORGANIZATIONS o ON e.organization_id = o.organization_id
LEFT JOIN RAW.CREDENTIALS cr ON e.employee_id = cr.employee_id
LEFT JOIN RAW.CREDENTIAL_VERIFICATIONS cv ON cr.credential_id = cv.credential_id
LEFT JOIN RAW.EXCLUSIONS_MONITORING em ON e.employee_id = em.employee_id
GROUP BY
    e.employee_id, e.organization_id, o.organization_name, e.employee_name, 
    e.job_title, e.department, e.requires_credentialing, e.compliance_status,
    e.created_at, e.updated_at;

-- ============================================================================
-- Subscription Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUBSCRIPTION_ANALYTICS AS
SELECT
    s.subscription_id,
    s.organization_id,
    o.organization_name,
    o.organization_type,
    s.service_type,
    s.subscription_tier,
    s.start_date,
    s.end_date,
    DATEDIFF('day', CURRENT_DATE(), s.end_date) AS days_until_expiration,
    s.billing_cycle,
    s.monthly_price,
    s.employee_licenses,
    s.course_library_access,
    s.advanced_reporting,
    s.subscription_status,
    CASE
        WHEN s.subscription_status = 'ACTIVE' AND DATEDIFF('day', CURRENT_DATE(), s.end_date) <= 30 THEN 'RENEWAL_RISK'
        WHEN s.subscription_status = 'ACTIVE' THEN 'HEALTHY'
        WHEN s.subscription_status = 'EXPIRED' THEN 'EXPIRED'
        ELSE 'PENDING_RENEWAL'
    END AS subscription_health,
    s.created_at,
    s.updated_at
FROM RAW.SUBSCRIPTIONS s
JOIN RAW.ORGANIZATIONS o ON s.organization_id = o.organization_id;

-- ============================================================================
-- Revenue Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_REVENUE_ANALYTICS AS
SELECT
    t.transaction_id,
    t.organization_id,
    o.organization_name,
    o.organization_type,
    t.transaction_date,
    DATE_TRUNC('MONTH', t.transaction_date) AS transaction_month,
    DATE_TRUNC('QUARTER', t.transaction_date) AS transaction_quarter,
    DATE_TRUNC('YEAR', t.transaction_date) AS transaction_year,
    DAYOFWEEK(t.transaction_date) AS day_of_week,
    HOUR(t.transaction_date) AS hour_of_day,
    t.transaction_type,
    t.product_type,
    t.product_id,
    p.product_name,
    p.product_category,
    t.amount,
    t.currency,
    t.payment_method,
    t.payment_status,
    t.discount_amount,
    t.tax_amount,
    t.total_amount,
    CASE
        WHEN t.discount_amount > 0 THEN (t.discount_amount / t.amount * 100)
        ELSE 0
    END AS discount_percentage,
    t.created_at
FROM RAW.TRANSACTIONS t
JOIN RAW.ORGANIZATIONS o ON t.organization_id = o.organization_id
LEFT JOIN RAW.PRODUCTS p ON t.product_id = p.product_id;

-- ============================================================================
-- Support Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_SUPPORT_ANALYTICS AS
SELECT
    st.ticket_id,
    st.organization_id,
    o.organization_name,
    o.organization_type,
    st.subject,
    st.issue_type,
    st.priority,
    st.ticket_status,
    st.channel,
    st.assigned_agent_id,
    sa.agent_name,
    sa.department,
    sa.specialization,
    st.created_date,
    st.first_response_date,
    st.resolved_date,
    st.closed_date,
    st.resolution_time_hours,
    CASE
        WHEN st.resolution_time_hours <= 4 THEN 'FAST'
        WHEN st.resolution_time_hours <= 24 THEN 'MODERATE'
        WHEN st.resolution_time_hours <= 72 THEN 'SLOW'
        ELSE 'VERY_SLOW'
    END AS resolution_speed,
    st.satisfaction_rating,
    CASE
        WHEN st.satisfaction_rating >= 4 THEN 'SATISFIED'
        WHEN st.satisfaction_rating >= 3 THEN 'NEUTRAL'
        ELSE 'DISSATISFIED'
    END AS satisfaction_category,
    DATEDIFF('hour', st.created_date, st.first_response_date) AS first_response_time_hours,
    st.created_at,
    st.updated_at
FROM RAW.SUPPORT_TICKETS st
JOIN RAW.ORGANIZATIONS o ON st.organization_id = o.organization_id
LEFT JOIN RAW.SUPPORT_AGENTS sa ON st.assigned_agent_id = sa.agent_id;

-- ============================================================================
-- Marketing Campaign Performance View
-- ============================================================================
CREATE OR REPLACE VIEW V_CAMPAIGN_PERFORMANCE AS
SELECT
    mc.campaign_id,
    mc.campaign_name,
    mc.campaign_type,
    mc.start_date,
    mc.end_date,
    mc.target_audience,
    mc.budget,
    mc.channel,
    mc.campaign_status,
    COUNT(DISTINCT oci.interaction_id) AS total_interactions,
    COUNT(DISTINCT oci.organization_id) AS unique_organizations,
    SUM(CASE WHEN oci.conversion_flag = TRUE THEN 1 ELSE 0 END) AS total_conversions,
    (SUM(CASE WHEN oci.conversion_flag = TRUE THEN 1 ELSE 0 END)::FLOAT / 
     NULLIF(COUNT(DISTINCT oci.interaction_id), 0) * 100) AS conversion_rate,
    SUM(oci.revenue_generated) AS total_revenue,
    (SUM(oci.revenue_generated) / NULLIF(mc.budget, 0)) AS roi,
    mc.created_at
FROM RAW.MARKETING_CAMPAIGNS mc
LEFT JOIN RAW.ORGANIZATION_CAMPAIGN_INTERACTIONS oci ON mc.campaign_id = oci.campaign_id
GROUP BY
    mc.campaign_id, mc.campaign_name, mc.campaign_type, mc.start_date, mc.end_date,
    mc.target_audience, mc.budget, mc.channel, mc.campaign_status, mc.created_at;

-- ============================================================================
-- Incident Analytics View
-- ============================================================================
CREATE OR REPLACE VIEW V_INCIDENT_ANALYTICS AS
SELECT
    i.incident_id,
    i.organization_id,
    o.organization_name,
    o.organization_type,
    i.reported_by_employee_id,
    e.employee_name AS reported_by_name,
    e.department AS reporter_department,
    i.incident_date,
    DATE_TRUNC('MONTH', i.incident_date) AS incident_month,
    DATE_TRUNC('QUARTER', i.incident_date) AS incident_quarter,
    i.incident_type,
    i.incident_category,
    i.severity,
    i.incident_status,
    i.location,
    i.investigation_status,
    i.resolved_date,
    DATEDIFF('day', i.incident_date, i.resolved_date) AS days_to_resolution,
    CASE
        WHEN i.resolved_date IS NULL THEN 'OPEN'
        WHEN DATEDIFF('day', i.incident_date, i.resolved_date) <= 7 THEN 'RESOLVED_QUICKLY'
        WHEN DATEDIFF('day', i.incident_date, i.resolved_date) <= 30 THEN 'RESOLVED_NORMALLY'
        ELSE 'RESOLVED_SLOWLY'
    END AS resolution_speed,
    i.created_at,
    i.updated_at
FROM RAW.INCIDENTS i
JOIN RAW.ORGANIZATIONS o ON i.organization_id = o.organization_id
LEFT JOIN RAW.EMPLOYEES e ON i.reported_by_employee_id = e.employee_id;

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All analytical views created successfully' AS status;

SELECT 
    table_name AS view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'V_%'
ORDER BY table_name;

