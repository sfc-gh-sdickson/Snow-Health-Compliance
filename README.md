<img src="Snowflake_Logo.svg" width="200">

# Snow Health Intelligence Agent Solution

## About Snow Health

Snow Health provides comprehensive healthcare compliance software solutions, including learning management systems, credentialing services, and compliance management tools. Their platform is designed to automate and streamline processes for healthcare organizations of all sizes.

### Key Business Lines

- **Learning Management**: CPR/BLS training, custom courses, continuing education, onboarding paths
- **Credentialing Services**: Provider credential management, exclusions monitoring, verification, enrollment
- **Compliance Management**: Policy/document management, incident reporting, contract management, accreditation support

### Market Position

- Leading healthcare compliance and training platform
- Serving hospitals, clinics, and healthcare practices nationwide
- Comprehensive solution for healthcare regulatory compliance

## Project Overview

This Snowflake Intelligence solution demonstrates how Snow Health can leverage AI agents to analyze:

- **Training & Learning**: Course completion rates, employee compliance, certification tracking
- **Credentialing**: License verification, exclusions monitoring, expiration tracking
- **Compliance**: Incident reports, policy acknowledgments, accreditation status
- **Subscription Analytics**: Service utilization, renewal rates, customer health
- **Revenue Intelligence**: Transaction trends, product performance, pricing optimization
- **Support Operations**: Ticket resolution, agent performance, customer satisfaction
- **Unstructured Data Search**: Semantic search over support transcripts, incident reports, and training materials using Cortex Search

## Database Schema

The solution includes:

1. **RAW Schema**: Core business tables
   - ORGANIZATIONS: Healthcare organization master data
   - EMPLOYEES: Staff and providers within organizations
   - COURSES: Training courses and certifications
   - COURSE_ENROLLMENTS: Employee course assignments
   - COURSE_COMPLETIONS: Completed training with scores and certificates
   - CREDENTIALS: Provider licenses and certifications
   - CREDENTIAL_VERIFICATIONS: Verification records and status
   - EXCLUSIONS_MONITORING: OIG/SAM database monitoring
   - SUBSCRIPTIONS: Snow Health service subscriptions
   - TRANSACTIONS: Financial transactions
   - SUPPORT_TICKETS: Customer support cases
   - INCIDENTS: Safety and compliance incidents
   - POLICIES: Organizational policies and procedures
   - POLICY_ACKNOWLEDGMENTS: Employee policy acknowledgments
   - ACCREDITATIONS: Organization accreditations (JCAHO, etc.)
   - SUPPORT_AGENTS: Support team data
   - PRODUCTS: Snow Health product catalog
   - MARKETING_CAMPAIGNS: Campaign tracking
   - SUPPORT_TRANSCRIPTS: Unstructured support interaction records (25K transcripts)
   - INCIDENT_REPORTS: Unstructured incident investigation documentation (15K reports)
   - TRAINING_MATERIALS: Course content and compliance guides

2. **ANALYTICS Schema**: Curated views and semantic models
   - Organization 360 views
   - Employee training analytics
   - Credential compliance metrics
   - Subscription and revenue analytics
   - Support efficiency metrics
   - Incident tracking and analysis
   - Semantic views for AI agents

3. **Cortex Search Services**: Semantic search over unstructured data
   - SUPPORT_TRANSCRIPTS_SEARCH: Search customer support interactions
   - INCIDENT_REPORTS_SEARCH: Search incident investigation documentation
   - TRAINING_MATERIALS_SEARCH: Search training content and compliance guides

4. **ML Models (Optional)**: Predictive analytics models
   - COMPLIANCE_RISK_PREDICTOR: Identify employees at risk of non-compliance
   - COURSE_COMPLETION_PREDICTOR: Predict training completion likelihood
   - SUBSCRIPTION_CHURN_PREDICTOR: Forecast subscription cancellation risk

## Files

### Core Files
- `README.md`: This comprehensive solution documentation
- `MAPPING_DOCUMENT.md`: Entity mapping from GoDaddy template to Snow Health
- `docs/AGENT_SETUP.md`: Configuration instructions for Snowflake agents
- `docs/questions.md`: 10 complex questions the agent can answer

### SQL Files
- `sql/setup/01_database_and_schema.sql`: Database and schema creation
- `sql/setup/02_create_tables.sql`: Table definitions with proper constraints
- `sql/data/03_generate_synthetic_data.sql`: Realistic sample data generation
- `sql/views/04_create_views.sql`: Analytical views
- `sql/views/05_create_semantic_views.sql`: Semantic views for AI agents (verified syntax)
- `sql/search/06_create_cortex_search.sql`: Unstructured data tables and Cortex Search services
- `sql/ml/07_create_model_wrapper_functions.sql`: ML model wrapper functions (optional)

### ML Models (Optional)
- `notebooks/snow_health_ml_models.ipynb`: Snowflake Notebook for training ML models
- `docs/NOTEBOOK_ML_GUIDE.md`: Guide for using the ML notebook

## Setup Instructions

### Core Setup (Required)
1. Execute SQL files in order (01 through 06)
   - 01: Database and schema setup
   - 02: Create tables
   - 03: Generate synthetic data (5-15 min)
   - 04: Create analytical views
   - 05: Create semantic views
   - 06: Create Cortex Search services (3-5 min)
2. Follow AGENT_SETUP.md for agent configuration
3. Test with questions from questions.md
4. Test Cortex Search with sample queries in AGENT_SETUP.md Step 5

### ML Models Setup (Optional)
5. Open `notebooks/snow_health_ml_models.ipynb` in Snowflake Notebooks
6. Add required packages: snowflake-ml-python, scikit-learn, xgboost, matplotlib
7. Run all cells to train and register 3 ML models
8. Execute `sql/ml/07_create_model_wrapper_functions.sql` to create wrapper procedures
9. Add models to Intelligence Agent as tools
10. See `docs/NOTEBOOK_ML_GUIDE.md` for detailed instructions

## Data Model Highlights

### Structured Data
- Realistic healthcare training scenarios across CPR, OSHA, HIPAA, infection control
- Multi-tier service subscriptions (Learning, Credentialing, Compliance, Full Suite)
- Comprehensive organization segments (HOSPITAL, CLINIC, PRACTICE)
- Provider credential tracking with verification workflows
- Exclusions monitoring for OIG/SAM databases
- Incident reporting and investigation workflows
- Policy management with acknowledgment tracking

### Unstructured Data
- 25,000 customer support transcripts with realistic interactions
- 15,000 incident investigation reports with root cause analysis
- 3 comprehensive training materials (HIPAA, Infection Control, CPR/BLS)
- Semantic search powered by Snowflake Cortex Search
- RAG (Retrieval Augmented Generation) ready for AI agents

## Key Features

✅ **Hybrid Data Architecture**: Combines structured tables with unstructured text data  
✅ **Semantic Search**: Find similar issues and solutions by meaning, not just keywords  
✅ **RAG-Ready**: Agent can retrieve context from support transcripts and training materials  
✅ **Production-Ready Syntax**: All SQL verified against Snowflake documentation  
✅ **Comprehensive Demo**: 1.5M+ transactions, 500K employees, 25K support transcripts  
✅ **Verified Syntax**: CREATE SEMANTIC VIEW and CREATE CORTEX SEARCH SERVICE syntax verified against official Snowflake documentation  
✅ **Predictive ML Models**: Optional models for compliance risk, course completion, and churn prediction

## Complex Questions Examples

The agent can answer sophisticated questions like:

1. **Training Compliance Analysis**: Identify employees overdue on mandatory training
2. **Credential Expiration Risk**: Track licenses expiring in next 90 days
3. **Exclusions Monitoring**: Providers with OIG/SAM alerts requiring action
4. **Incident Pattern Analysis**: Common incident types and root causes
5. **Subscription Health**: Customers at risk of churn based on usage patterns
6. **Revenue Trend Analysis**: Monthly patterns with seasonality detection
7. **Support Efficiency Metrics**: Resolution times by issue type and channel
8. **Policy Compliance**: Organizations with low policy acknowledgment rates
9. **Cross-Sell Opportunities**: Customers using only one service type
10. **Course Effectiveness**: Training completion rates and score analysis

Plus unstructured data questions for semantic search over transcripts, incidents, and training materials.

### ML Model Predictions (Optional)

With the optional ML models, the agent can also:

11. **Compliance Risk Scoring**: Predict which employees are at risk of compliance violations
12. **Course Completion Forecasting**: Identify enrolled employees likely to complete training on time
13. **Subscription Churn Prevention**: Flag organizations at risk of canceling their subscriptions

## Semantic Views

The solution includes three verified semantic views:

1. **SV_LEARNING_CREDENTIALING_INTELLIGENCE**: Comprehensive view of training, courses, credentials, and compliance
2. **SV_SUBSCRIPTION_REVENUE_INTELLIGENCE**: Subscriptions, products, transactions, and revenue metrics
3. **SV_ORGANIZATION_SUPPORT_INTELLIGENCE**: Support tickets, agents, and customer satisfaction

All semantic views follow the verified syntax structure:
- TABLES clause with PRIMARY KEY definitions
- RELATIONSHIPS clause defining foreign keys
- DIMENSIONS clause with synonyms and comments
- METRICS clause with aggregations and calculations
- Proper clause ordering (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT)

## Cortex Search Services

Three Cortex Search services enable semantic search over unstructured data:

1. **SUPPORT_TRANSCRIPTS_SEARCH**: Search 25,000 customer support interactions
   - Find similar issues by description, not exact keywords
   - Retrieve resolution procedures from past successful cases
   - Analyze support patterns and best practices

2. **INCIDENT_REPORTS_SEARCH**: Search 15,000 incident investigation reports
   - Find similar incidents and root causes
   - Identify effective corrective actions
   - Retrieve investigation procedures

3. **TRAINING_MATERIALS_SEARCH**: Search training content and guides
   - Retrieve training procedures and protocols
   - Find compliance guidance
   - Access technical documentation

All Cortex Search services use verified syntax:
- ON clause specifying search column
- ATTRIBUTES clause for filterable columns
- WAREHOUSE assignment
- TARGET_LAG for refresh frequency
- AS clause with source query

## ML Models (Optional Enhancement)

The solution includes three optional predictive ML models trained using Snowflake ML:

### 1. Compliance Risk Predictor
- **Model Type**: Random Forest Classifier
- **Purpose**: Identify employees at high risk of compliance violations
- **Features**: Training completion, credential status, policy acknowledgments, incident history
- **Output**: Binary classification (high risk / low risk)
- **Use Cases**: Proactive compliance intervention, audit preparation, risk mitigation

### 2. Course Completion Predictor
- **Model Type**: Logistic Regression
- **Purpose**: Predict which enrolled employees will complete training on time
- **Features**: Course characteristics, employee history, department, organization type
- **Output**: Binary classification (will complete / won't complete)
- **Use Cases**: Early intervention, resource allocation, completion rate forecasting

### 3. Subscription Churn Predictor
- **Model Type**: Random Forest Classifier
- **Purpose**: Identify organizations likely to cancel their subscriptions
- **Features**: Usage patterns, support tickets, transaction activity, engagement metrics
- **Output**: Binary classification (will churn / won't churn)
- **Use Cases**: Customer retention, upsell opportunities, account health monitoring

### Model Integration

Models are registered to Snowflake Model Registry and exposed via stored procedures:
- `PREDICT_COMPLIANCE_RISK(department_filter)`
- `PREDICT_COURSE_COMPLETION(course_category_filter)`
- `PREDICT_SUBSCRIPTION_CHURN(service_type_filter)`

These can be added as tools to the Intelligence Agent for predictive analytics capabilities.

## Syntax Verification

All SQL syntax has been verified against official Snowflake documentation:

- **CREATE SEMANTIC VIEW**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **CREATE CORTEX SEARCH SERVICE**: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
- **Cortex Search Overview**: https://docs.snowflake.com/en/user-guide/snowflake-cortex/cortex-search/cortex-search-overview

Key verification points:
- ✅ Clause order is mandatory (TABLES → RELATIONSHIPS → DIMENSIONS → METRICS)
- ✅ PRIMARY KEY columns must exist in source tables
- ✅ No self-referencing or cyclic relationships
- ✅ Semantic expression format: `name AS expression`
- ✅ Change tracking enabled for Cortex Search tables
- ✅ Correct ATTRIBUTES syntax for filterable columns

## Getting Started

### Prerequisites
- Snowflake account with Cortex Intelligence enabled
- ACCOUNTADMIN or equivalent privileges
- X-SMALL or larger warehouse

### Quick Start
```sql
-- 1. Create database and schemas
@sql/setup/01_database_and_schema.sql

-- 2. Create tables
@sql/setup/02_create_tables.sql

-- 3. Generate sample data (5-15 minutes)
@sql/data/03_generate_synthetic_data.sql

-- 4. Create analytical views
@sql/views/04_create_views.sql

-- 5. Create semantic views
@sql/views/05_create_semantic_views.sql

-- 6. Create Cortex Search services (3-5 minutes)
@sql/search/06_create_cortex_search.sql
```

### Configure Agent
Follow the detailed instructions in `docs/AGENT_SETUP.md` to:
1. Create the Snowflake Intelligence Agent
2. Add semantic views as data sources
3. Configure Cortex Search services
4. Set up system prompts
5. Test with sample questions

## Testing

### Verify Installation
```sql
-- Check semantic views
SHOW SEMANTIC VIEWS IN SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS;

-- Check Cortex Search services
SHOW CORTEX SEARCH SERVICES IN SCHEMA SNOW_HEALTH_INTELLIGENCE.RAW;

-- Test Cortex Search
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'SNOW_HEALTH_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{"query": "course enrollment help", "limit":5}'
  )
)['results'] as results;
```

### Sample Test Questions
1. "How many employees have overdue mandatory training?"
2. "Which providers have credentials expiring in the next 90 days?"
3. "Show me incident reports about medication errors"
4. "Find support transcripts about credentialing verification issues"

## Data Volumes

- **Organizations**: 50,000
- **Employees**: 500,000
- **Courses**: 20
- **Course Enrollments**: 1,000,000
- **Course Completions**: 750,000
- **Credentials**: 100,000
- **Subscriptions**: 75,000
- **Transactions**: 1,500,000
- **Support Tickets**: 75,000
- **Incidents**: 50,000
- **Support Transcripts**: 25,000 (unstructured)
- **Incident Reports**: 15,000 (unstructured)
- **Training Materials**: 3 comprehensive guides

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                   Snowflake Intelligence Agent                   │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │              Semantic Views (Structured Data)              │ │
│  │  • SV_LEARNING_CREDENTIALING_INTELLIGENCE                  │ │
│  │  • SV_SUBSCRIPTION_REVENUE_INTELLIGENCE                    │ │
│  │  • SV_ORGANIZATION_SUPPORT_INTELLIGENCE                    │ │
│  └────────────────────────────────────────────────────────────┘ │
│                                                                  │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │          Cortex Search (Unstructured Data)                 │ │
│  │  • SUPPORT_TRANSCRIPTS_SEARCH                              │ │
│  │  • INCIDENT_REPORTS_SEARCH                                 │ │
│  │  • TRAINING_MATERIALS_SEARCH                               │ │
│  └────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
        ┌──────────────────────────────────────────┐
        │         RAW Schema (Source Data)         │
        │  • Organizations, Employees, Courses     │
        │  • Credentials, Subscriptions            │
        │  • Transactions, Support Tickets         │
        │  • Incidents, Policies, Accreditations   │
        │  • Support Transcripts (Unstructured)    │
        │  • Incident Reports (Unstructured)       │
        │  • Training Materials (Unstructured)     │
        └──────────────────────────────────────────┘
```

## Support

For questions or issues:
- Review `docs/AGENT_SETUP.md` for detailed setup instructions
- Check `docs/questions.md` for example questions
- Consult Snowflake documentation for syntax verification
- Contact your Snowflake account team for assistance

## Version History

- **v1.0** (October 2025): Initial release
  - Verified semantic view syntax
  - Verified Cortex Search syntax
  - 50K organizations, 500K employees, 1.5M transactions
  - 25K support transcripts with semantic search
  - 10 complex test questions
  - Comprehensive documentation

## License

This solution is provided as a template for building Snowflake Intelligence agents. Adapt as needed for your specific use case.

---

**Created**: October 2025  
**Template Based On**: GoDaddy Intelligence Demo  
**Snowflake Documentation**: Syntax verified against official documentation  
**Target Use Case**: Snow Health learning, credentialing, and compliance intelligence

**NO GUESSING - ALL SYNTAX VERIFIED** ✅

