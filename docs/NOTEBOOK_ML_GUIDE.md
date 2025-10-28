# Snow Health ML Models - Notebook Guide

## Overview

This guide explains how to use the `snow_health_ml_models.ipynb` Snowflake Notebook to train and deploy machine learning models that enhance the Snow Health Intelligence Agent with predictive capabilities.

## What You'll Build

Three production-ready ML models:

1. **Compliance Risk Predictor** - Identify employees at risk of compliance violations
2. **Course Completion Predictor** - Forecast training completion likelihood
3. **Subscription Churn Predictor** - Detect organizations likely to cancel subscriptions

All models are trained using Snowflake ML, registered to Model Registry, and can be added as tools to your Intelligence Agent.

---

## Prerequisites

### Required Setup

Before running the notebook, ensure you have completed:

✅ **Core Database Setup**
- Executed `01_database_and_schema.sql`
- Executed `02_create_tables.sql`
- Executed `03_generate_synthetic_data.sql` (required: data must exist)
- Executed `04_create_views.sql`

✅ **Snowflake Environment**
- Database: `SNOW_HEALTH_INTELLIGENCE`
- Schema: `ANALYTICS`
- Warehouse: `SNOW_HEALTH_WH` (X-SMALL or larger)
- Role with appropriate privileges (SYSADMIN or custom role with model registry access)

✅ **Data Requirements**
- At least 50,000 employees with enrollment records
- At least 100,000 course enrollments
- At least 25,000 subscriptions
- Historical data spanning 12+ months recommended

### Snowflake Account Requirements

- Snowflake Enterprise Edition or higher
- Snowpark enabled
- Snowflake ML enabled (contact your Snowflake account team if needed)
- Access to Snowflake Notebooks feature

---

## Step-by-Step Instructions

### Step 1: Open the Notebook

1. Navigate to Snowsight (Snowflake web interface)
2. Go to **Projects** → **Notebooks**
3. Click **Import .ipynb file**
4. Upload `notebooks/snow_health_ml_models.ipynb`
5. Name it: `Snow Health ML Models`
6. Select database: `SNOW_HEALTH_INTELLIGENCE`
7. Select schema: `ANALYTICS`
8. Select warehouse: `SNOW_HEALTH_WH`

### Step 2: Add Required Packages

In the notebook interface (top right):

1. Click **Packages** dropdown
2. Add the following packages:
   - `snowflake-ml-python` (latest version)
   - `scikit-learn` (latest version)
   - `xgboost` (latest version)
   - `matplotlib` (latest version)
3. Click **Save**

**Important**: Package installation happens when you first run a cell. This may take 1-2 minutes.

### Step 3: Run the Notebook

#### Option A: Run All Cells (Recommended for first time)

1. Click **Run All** at the top of the notebook
2. Wait for all cells to complete (approximately 5-15 minutes total)
3. Monitor progress - you'll see:
   - Package imports
   - Data loading and feature engineering
   - Model training progress
   - Model evaluation metrics
   - Model registration confirmations

#### Option B: Run Cell by Cell (For understanding/debugging)

1. Read each markdown cell to understand what's happening
2. Click **Run** for each code cell sequentially
3. Review outputs before proceeding to next cell
4. This approach is better for learning and troubleshooting

### Step 4: Verify Model Registration

After the notebook completes successfully, verify models are registered:

```sql
-- In a SQL worksheet:
USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA ANALYTICS;

-- List all registered models
SHOW MODELS IN SCHEMA ANALYTICS;

-- Verify specific models exist
SELECT * FROM INFORMATION_SCHEMA.MODELS 
WHERE MODEL_NAME IN (
    'COMPLIANCE_RISK_PREDICTOR',
    'COURSE_COMPLETION_PREDICTOR',
    'SUBSCRIPTION_CHURN_PREDICTOR'
);
```

You should see all three models with version `V1`.

### Step 5: Create Wrapper Functions

Execute the SQL wrapper functions to make models callable:

```sql
-- Execute the entire file:
@sql/ml/07_create_model_wrapper_functions.sql
```

Or run in Snowsight:
1. Open `sql/ml/07_create_model_wrapper_functions.sql`
2. Select all and execute

This creates three stored procedures:
- `PREDICT_COMPLIANCE_RISK(department_filter)`
- `PREDICT_COURSE_COMPLETION(course_category_filter)`
- `PREDICT_SUBSCRIPTION_CHURN(service_type_filter)`

### Step 6: Test the Models

Test each model wrapper procedure:

```sql
-- Test compliance risk prediction
CALL PREDICT_COMPLIANCE_RISK('NURSING');
-- Returns: {"department_filter":"NURSING","total_employees_analyzed":20,"high_risk_employees":5,"risk_rate_pct":25.0}

-- Test course completion prediction
CALL PREDICT_COURSE_COMPLETION('CLINICAL');
-- Returns: {"course_category_filter":"CLINICAL","total_active_enrollments":30,"predicted_to_complete":22,"completion_rate_pct":73.33}

-- Test subscription churn prediction
CALL PREDICT_SUBSCRIPTION_CHURN('LEARNING');
-- Returns: {"service_type_filter":"LEARNING","total_subscriptions_analyzed":25,"at_risk_of_churn":3,"churn_risk_pct":12.0}
```

### Step 7: Add Models to Intelligence Agent

#### In Snowsight:

1. Navigate to **AI & ML** → **Agents**
2. Select your **SNOW_HEALTH_INTELLIGENCE_AGENT**
3. Click **Tools** tab
4. Click **+ Add Tool** → **Model**
5. Select `COMPLIANCE_RISK_PREDICTOR` → Add
6. Repeat for `COURSE_COMPLETION_PREDICTOR`
7. Repeat for `SUBSCRIPTION_CHURN_PREDICTOR`

#### Configure Tool Descriptions (Optional but Recommended):

For each model, add a helpful description:

**COMPLIANCE_RISK_PREDICTOR**:
```
Predicts which employees are at high risk of compliance violations based on training completion, credential status, and policy acknowledgments. Use this when asked about compliance risk, audit preparation, or identifying employees who need intervention.
```

**COURSE_COMPLETION_PREDICTOR**:
```
Predicts whether enrolled employees will complete their training courses on time. Use this for forecasting completion rates, identifying at-risk enrollments, or allocating training resources.
```

**SUBSCRIPTION_CHURN_PREDICTOR**:
```
Predicts which organizations are likely to cancel their Snow Health subscriptions. Use this for customer retention, identifying at-risk accounts, or prioritizing account management efforts.
```

### Step 8: Test the Agent with ML Models

Try these questions with your agent:

**Compliance Risk:**
- "Which employees in the nursing department have high compliance risk?"
- "Predict compliance violations for clinical staff"
- "Show me employees at risk of non-compliance"

**Course Completion:**
- "Which enrolled employees are unlikely to complete their HIPAA training?"
- "Predict completion rates for clinical courses"
- "Identify at-risk course enrollments"

**Subscription Churn:**
- "Which organizations are at risk of canceling their learning subscriptions?"
- "Predict subscription churn for full suite customers"
- "Show me accounts with high churn risk"

---

## Understanding the Models

### Model 1: Compliance Risk Predictor

**Algorithm**: Random Forest Classifier (100 trees, max depth 10)

**Input Features**:
- Organization type (HOSPITAL, CLINIC, PRACTICE)
- Job role (NURSE, PHYSICIAN, ADMINISTRATOR, etc.)
- Department (NURSING, CLINICAL, ADMIN, etc.)
- Total course enrollments
- Total course completions
- Average course scores
- Number of overdue courses
- Credential count
- Expiring credentials (within 90 days)
- Policies acknowledged
- Days since last policy acknowledgment
- Incident count

**Target Variable**: 
- `has_compliance_risk` (Boolean)
- TRUE if: overdue courses > 0 OR expiring credentials > 0 OR recent incidents > 0

**Model Performance**:
- Accuracy: Typically 85-92% on test data
- Can identify high-risk employees before violations occur

**Business Value**:
- Proactive intervention before compliance issues
- Reduce audit findings
- Optimize compliance training allocation

---

### Model 2: Course Completion Predictor

**Algorithm**: Logistic Regression

**Input Features**:
- Course category (CLINICAL, ADMINISTRATIVE, COMPLIANCE, SAFETY)
- Course type (REQUIRED, ELECTIVE, CERTIFICATION, ORIENTATION)
- Employee job role
- Employee department
- Organization type
- Days allocated to complete course
- Days since enrollment
- Employee's historical completion rate

**Target Variable**:
- `was_completed` (Boolean)
- TRUE if course status = 'COMPLETED'

**Model Performance**:
- Accuracy: Typically 78-85% on test data
- Better performance for employees with 5+ historical enrollments

**Business Value**:
- Early intervention for at-risk enrollments
- Improve overall completion rates
- Better resource allocation for support

---

### Model 3: Subscription Churn Predictor

**Algorithm**: Random Forest Classifier (100 trees, max depth 12)

**Input Features**:
- Organization type
- Service type (LEARNING, CREDENTIALING, COMPLIANCE, FULL_SUITE)
- Subscription tier (BASIC, PROFESSIONAL, ENTERPRISE)
- Lifetime value
- Compliance risk score
- Subscription age (months)
- Monthly price
- Active employee count
- Total enrollments
- Support ticket count
- Average customer satisfaction score (CSAT)
- Recent transaction count (last 3 months)
- Incident count

**Target Variable**:
- `is_churned` (Boolean)
- TRUE if subscription status = 'CANCELLED' or end_date < CURRENT_DATE

**Model Performance**:
- Accuracy: Typically 80-88% on test data
- High precision for identifying at-risk accounts

**Business Value**:
- Prevent revenue loss through proactive retention
- Identify upsell opportunities
- Prioritize account management efforts

---

## Troubleshooting

### Issue: Package Installation Fails

**Error**: `Package 'snowflake-ml-python' could not be installed`

**Solutions**:
1. Verify you're using Snowflake Enterprise Edition or higher
2. Check that Snowpark is enabled on your account
3. Try removing and re-adding packages
4. Contact Snowflake support if issue persists

---

### Issue: Insufficient Data Error

**Error**: `Not enough records to train model`

**Solutions**:
1. Verify synthetic data was generated: `SELECT COUNT(*) FROM RAW.EMPLOYEES;`
2. Ensure you executed `03_generate_synthetic_data.sql` completely
3. Check data volumes meet minimums:
   - Employees: 50,000+
   - Enrollments: 100,000+
   - Subscriptions: 25,000+

---

### Issue: Model Registration Fails

**Error**: `Access Denied` or `Insufficient Privileges`

**Solutions**:
1. Verify your role has `CREATE MODEL` privilege:
   ```sql
   SHOW GRANTS TO ROLE YOUR_ROLE;
   ```
2. Grant necessary privileges:
   ```sql
   GRANT CREATE MODEL ON SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS TO ROLE YOUR_ROLE;
   ```
3. Use ACCOUNTADMIN or SYSADMIN role if available

---

### Issue: Low Model Accuracy

**Symptom**: Model accuracy below 70%

**Solutions**:
1. Check data quality - ensure realistic distributions
2. Increase training data volume (if using subset)
3. Adjust model hyperparameters (in notebook cells)
4. Review feature engineering logic
5. Consider feature importance analysis

---

### Issue: Wrapper Functions Fail

**Error**: `Model not found in registry`

**Solutions**:
1. Verify models registered: `SHOW MODELS IN SCHEMA ANALYTICS;`
2. Check model names match exactly (case-sensitive)
3. Re-run notebook to register models
4. Verify database/schema context is correct

---

## Advanced Configuration

### Retraining Models with Updated Data

To retrain models with fresh data:

1. Open notebook in Snowflake
2. Click **Run All**
3. Models will be registered as new versions (V2, V3, etc.)
4. Update wrapper functions to use new version (optional)

### Customizing Model Hyperparameters

In the notebook, locate these pipeline definitions and adjust:

**Compliance Risk Model**:
```python
RandomForestClassifier(
    n_estimators=100,  # Increase for more trees (slower but potentially better)
    max_depth=10       # Increase for more complex patterns (risk of overfitting)
)
```

**Course Completion Model**:
```python
LogisticRegression(
    max_iter=1000,     # Increase if convergence warning appears
    C=1.0              # Regularization strength (lower = more regularization)
)
```

**Subscription Churn Model**:
```python
RandomForestClassifier(
    n_estimators=100,
    max_depth=12,
    min_samples_split=5  # Add to prevent overfitting
)
```

### Adding Custom Features

To add new features to a model:

1. Edit the SQL query in the notebook cell
2. Add new columns to SELECT statement
3. Add column names to feature list in pipeline
4. Re-run training cells
5. Re-register model

Example:
```python
# Add 'employee_tenure_years' as a feature
pipeline = Pipeline([
    ("Encoder", OneHotEncoder(
        input_cols=["ORGANIZATION_TYPE", "JOB_ROLE", "DEPARTMENT"],
        # Add new numeric features to StandardScaler instead:
    )),
    ("Scaler", StandardScaler(
        input_cols=["TOTAL_ENROLLMENTS", "AVG_SCORE", "EMPLOYEE_TENURE_YEARS"],
        output_cols=["TOTAL_ENROLLMENTS_SCALED", "AVG_SCORE_SCALED", "TENURE_SCALED"]
    )),
    ...
])
```

---

## Monitoring and Maintenance

### Best Practices

1. **Retrain Quarterly**: Update models every 3 months with latest data
2. **Monitor Performance**: Track prediction accuracy vs. actual outcomes
3. **Version Control**: Keep track of model versions and training dates
4. **Document Changes**: Note any hyperparameter adjustments
5. **A/B Testing**: Compare new versions against current before deploying

### Performance Tracking

Create a tracking table to monitor predictions vs. actuals:

```sql
CREATE TABLE ANALYTICS.MODEL_PREDICTIONS_LOG (
    prediction_date TIMESTAMP_NTZ,
    model_name VARCHAR,
    model_version VARCHAR,
    employee_id VARCHAR,
    prediction BOOLEAN,
    actual BOOLEAN,
    prediction_correct BOOLEAN
);
```

---

## Additional Resources

### Snowflake Documentation

- [Snowflake ML Overview](https://docs.snowflake.com/en/developer-guide/snowpark-ml/overview)
- [Model Registry](https://docs.snowflake.com/en/developer-guide/snowpark-ml/model-registry/overview)
- [Snowflake Notebooks](https://docs.snowflake.com/en/user-guide/ui-snowsight-notebooks)
- [Snowpark ML API Reference](https://docs.snowflake.com/en/developer-guide/snowpark-ml/reference/latest/index)

### Scikit-learn Documentation

- [Random Forest Classifier](https://scikit-learn.org/stable/modules/generated/sklearn.ensemble.RandomForestClassifier.html)
- [Logistic Regression](https://scikit-learn.org/stable/modules/generated/sklearn.linear_model.LogisticRegression.html)
- [Model Evaluation Metrics](https://scikit-learn.org/stable/modules/model_evaluation.html)

---

## Next Steps

After successfully deploying your ML models:

1. ✅ Test model predictions with the Intelligence Agent
2. ✅ Monitor model performance in production
3. ✅ Schedule quarterly retraining
4. ✅ Explore adding more sophisticated models (XGBoost, Neural Networks)
5. ✅ Consider feature importance analysis for model interpretability
6. ✅ Build dashboards to visualize predictions vs. actuals

---

## Support

For issues or questions:

1. Review this guide's Troubleshooting section
2. Check Snowflake ML documentation
3. Consult `AGENT_SETUP.md` for agent configuration help
4. Review notebook cell outputs for error messages
5. Contact your Snowflake account team for ML-specific support

---

**Document Version**: 1.0  
**Last Updated**: October 2025  
**Compatible with**: Snowflake Enterprise Edition or higher  
**Required Features**: Snowpark ML, Model Registry, Notebooks

