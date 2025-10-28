<img src="..\Snowflake_Logo.svg" width="200">

# Snow Health Intelligence Agent - Setup Guide

This guide walks through configuring a Snowflake Intelligence agent for Snow Health's learning management, credentialing, and compliance intelligence solution.

---

## Prerequisites

1. **Snowflake Account** with:
   - Snowflake Intelligence (Cortex) enabled
   - Appropriate warehouse size (recommended: X-SMALL or larger)
   - Permissions to create databases, schemas, tables, and semantic views

2. **Roles and Permissions**:
   - `ACCOUNTADMIN` role or equivalent for initial setup
   - `CREATE DATABASE` privilege
   - `CREATE SEMANTIC VIEW` privilege
   - `CREATE CORTEX SEARCH SERVICE` privilege
   - `USAGE` on warehouses

---

## Step 1: Execute SQL Scripts in Order

Execute the SQL files in the following sequence:

### 1.1 Database Setup
```sql
-- Execute: sql/setup/01_database_and_schema.sql
-- Creates database, schemas (RAW, ANALYTICS), and warehouse
-- Execution time: < 1 second
```

### 1.2 Create Tables
```sql
-- Execute: sql/setup/02_create_tables.sql
-- Creates all table structures with proper relationships
-- Tables: ORGANIZATIONS, EMPLOYEES, COURSES, COURSE_ENROLLMENTS, COURSE_COMPLETIONS,
--         CREDENTIALS, CREDENTIAL_VERIFICATIONS, EXCLUSIONS_MONITORING, SUBSCRIPTIONS,
--         TRANSACTIONS, SUPPORT_TICKETS, INCIDENTS, POLICIES, POLICY_ACKNOWLEDGMENTS,
--         ACCREDITATIONS, SUPPORT_AGENTS, PRODUCTS, MARKETING_CAMPAIGNS, etc.
-- Execution time: < 5 seconds
```

### 1.3 Generate Sample Data
```sql
-- Execute: sql/data/03_generate_synthetic_data.sql
-- Generates realistic sample data:
--   - 50,000 organizations
--   - 500,000 employees
--   - 1,000,000 course enrollments
--   - 750,000 course completions
--   - 100,000 credentials
--   - 1,500,000 transactions
--   - 75,000 support tickets
-- Execution time: 10-20 minutes (depending on warehouse size)
```

### 1.4 Create Analytical Views
```sql
-- Execute: sql/views/04_create_views.sql
-- Creates curated analytical views:
--   - V_ORGANIZATION_360
--   - V_EMPLOYEE_TRAINING_ANALYTICS
--   - V_CREDENTIAL_COMPLIANCE_ANALYTICS
--   - V_SUBSCRIPTION_ANALYTICS
--   - V_REVENUE_ANALYTICS
--   - V_SUPPORT_ANALYTICS
--   - V_CAMPAIGN_PERFORMANCE
--   - V_INCIDENT_ANALYTICS
-- Execution time: < 5 seconds
```

### 1.5 Create Semantic Views
```sql
-- Execute: sql/views/05_create_semantic_views.sql
-- Creates semantic views for AI agents (VERIFIED SYNTAX):
--   - SV_LEARNING_CREDENTIALING_INTELLIGENCE
--   - SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
--   - SV_ORGANIZATION_SUPPORT_INTELLIGENCE
-- Execution time: < 5 seconds
```

### 1.6 Create Cortex Search Services
```sql
-- Execute: sql/search/06_create_cortex_search.sql
-- Creates tables for unstructured text data:
--   - SUPPORT_TRANSCRIPTS (25,000 support interactions)
--   - INCIDENT_REPORTS (15,000 investigation reports)
--   - TRAINING_MATERIALS (3 training guides)
-- Creates Cortex Search services for semantic search:
--   - SUPPORT_TRANSCRIPTS_SEARCH
--   - INCIDENT_REPORTS_SEARCH
--   - TRAINING_MATERIALS_SEARCH
-- Execution time: 5-10 minutes (data generation + index building)
```

---

## Step 2: Grant Cortex Analyst Permissions

Before creating the agent, ensure proper permissions are configured:

### 2.1 Grant Database Role for Cortex Analyst

```sql
USE ROLE ACCOUNTADMIN;

-- Grant Cortex Analyst user role to your role
GRANT DATABASE ROLE SNOWFLAKE.CORTEX_ANALYST_USER TO ROLE <your_role>;

-- Grant usage on the database and schemas
GRANT USAGE ON DATABASE SNOW_HEALTH_INTELLIGENCE TO ROLE <your_role>;
GRANT USAGE ON SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS TO ROLE <your_role>;
GRANT USAGE ON SCHEMA SNOW_HEALTH_INTELLIGENCE.RAW TO ROLE <your_role>;

-- Grant privileges on semantic views
GRANT REFERENCES, SELECT ON SEMANTIC VIEW SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_LEARNING_CREDENTIALING_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_SUBSCRIPTION_REVENUE_INTELLIGENCE TO ROLE <your_role>;
GRANT REFERENCES, SELECT ON SEMANTIC VIEW SNOW_HEALTH_INTELLIGENCE.ANALYTICS.SV_ORGANIZATION_SUPPORT_INTELLIGENCE TO ROLE <your_role>;

-- Grant usage on warehouse
GRANT USAGE ON WAREHOUSE SNOW_HEALTH_WH TO ROLE <your_role>;

-- Grant usage on Cortex Search services
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH TO ROLE <your_role>;
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.TRAINING_MATERIALS_SEARCH TO ROLE <your_role>;
```

---

## Step 3: Create Snowflake Intelligence Agent

### Step 3.1: Create the Agent

1. In Snowsight, click on **AI & ML** > **Agents**
2. Click on **Create Agent**
3. Select **Create this agent for Snowflake Intelligence**
4. Configure:
   - **Agent Object Name**: `SNOW_HEALTH_INTELLIGENCE_AGENT`
   - **Display Name**: `Snow Health Intelligence Agent`
5. Click **Create**

### Step 3.2: Add Description and Instructions

1. Click on **SNOW_HEALTH_INTELLIGENCE_AGENT** to open the agent
2. Click **Edit** on the top right corner
3. In the **Description** section, add:
   ```
   This agent orchestrates between Snow Health training, credentialing, and compliance data 
   for analyzing structured metrics using Cortex Analyst (semantic views) and unstructured 
   content using Cortex Search services (support transcripts, incident reports, training materials).
   ```

### Step 3.3: Configure Response Instructions

1. Click on **Instructions** in the left pane
2. Enter the following **Response Instructions**:
   ```
   You are a specialized analytics assistant for Snow Health, a healthcare compliance and 
   training platform. Your primary objectives are:

   For structured data queries (metrics, KPIs, compliance figures):
   - Use the Cortex Analyst semantic views for training compliance, credentialing, subscriptions, 
     and revenue analysis
   - Provide direct, numerical answers with minimal explanation
   - Format responses clearly with relevant units and time periods
   - Only include essential context needed to understand the metric

   For unstructured content (support transcripts, incident reports, training materials):
   - Use Cortex Search services to find similar cases, procedures, and documentation
   - Extract relevant information from past interactions and reports
   - Summarize findings in brief, focused responses
   - Maintain context from the original source documents

   Operating guidelines:
   - Always identify whether you're using Cortex Analyst or Cortex Search for each response
   - Keep responses under 3-4 sentences when possible
   - Present numerical data in a structured format
   - Don't speculate beyond available data
   - Highlight compliance risks and credential expirations prominently
   - For training compliance, always check due dates and mandatory status
   ```

3. **Add Sample Questions** (click "Add a question" for each):
   - "How many employees have overdue mandatory training?"
   - "Which providers have credentials expiring in the next 90 days?"
   - "Search support transcripts for credential verification issues"

---

### Step 3.4: Add Cortex Analyst Tools (Semantic Views)

1. Click on **Tools** in the left pane
2. Find **Cortex Analyst** and click **+ Add**

**Add Semantic View 1: Learning & Credentialing Intelligence**

1. **Name**: `Learning_Credentialing_Intelligence`
2. Click on **Semantic view** radio button
3. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.ANALYTICS`
4. Click on the semantic view to highlight it: `SV_LEARNING_CREDENTIALING_INTELLIGENCE`
5. Select **Warehouse**: `SNOW_HEALTH_WH`
6. **Query timeout (seconds)**: `60`
7. **Description** (or click generate):
   ```
   Analyzes training compliance, course completions, employee credentials, and 
   credentialing verification. Use for questions about employee training status, 
   credential expirations, course effectiveness, and compliance tracking.
   ```
8. Once the **Add** button is highlighted blue, click **Add**

**Add Semantic View 2: Subscription & Revenue Intelligence**

1. Click **+ Add** again under Cortex Analyst
2. **Name**: `Subscription_Revenue_Intelligence`
3. Click on **Semantic view** radio button
4. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.ANALYTICS`
5. Click on the semantic view to highlight it: `SV_SUBSCRIPTION_REVENUE_INTELLIGENCE`
6. Select **Warehouse**: `SNOW_HEALTH_WH`
7. **Query timeout (seconds)**: `60`
8. **Description**:
   ```
   Analyzes subscription health, revenue trends, transaction patterns, and product
   performance. Use for questions about subscription renewals, revenue analysis,
   product adoption, and customer lifetime value.
   ```
9. Click **Add**

**Add Semantic View 3: Organization Support Intelligence**

1. Click **+ Add** again under Cortex Analyst
2. **Name**: `Organization_Support_Intelligence`
3. Click on **Semantic view** radio button
4. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.ANALYTICS`
5. Click on the semantic view to highlight it: `SV_ORGANIZATION_SUPPORT_INTELLIGENCE`
6. Select **Warehouse**: `SNOW_HEALTH_WH`
7. **Query timeout (seconds)**: `60`
8. **Description**:
   ```
   Analyzes support ticket resolution, agent performance, and customer satisfaction.
   Use for questions about support efficiency, ticket trends, agent productivity,
   and customer satisfaction metrics.
   ```
9. Click **Add**

---

### Step 3.5: Add Cortex Search Services

Still in the **Tools** section:

**Add Cortex Search Service 1: Support Transcripts Search**

1. Find **Cortex Search Services** and click **+ Add**
2. **Name**: `Support_Transcripts_Search`
3. **Description**:
   ```
   Search 25,000 customer support transcripts to find similar issues, resolution 
   procedures, and support best practices. Use for questions about customer service 
   patterns, technical troubleshooting, feature usage, and common support scenarios.
   ```
4. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `SUPPORT_TRANSCRIPTS_SEARCH`
6. For **ID Column**: `transcript_id` (used to generate hyperlink to source)
7. For **Title Column**: `transcript_text` (the search field)
8. Click **Add**

**Add Cortex Search Service 2: Incident Reports Search**

1. Click **+ Add** again under Cortex Search Services
2. **Name**: `Incident_Reports_Search`
3. **Description**:
   ```
   Search 15,000 incident investigation reports to find similar incidents, root 
   causes, and effective corrective actions. Use for questions about patient safety, 
   medication errors, HIPAA breaches, workplace injuries, and incident patterns.
   ```
4. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `INCIDENT_REPORTS_SEARCH`
6. For **ID Column**: `report_id`
7. For **Title Column**: `report_text`
8. Click **Add**

**Add Cortex Search Service 3: Training Materials Search**

1. Click **+ Add** again under Cortex Search Services
2. **Name**: `Training_Materials_Search`
3. **Description**:
   ```
   Search training materials and compliance guides for procedures, protocols, and 
   best practices. Use for questions about HIPAA privacy, infection control, 
   CPR/BLS procedures, and regulatory compliance guidance.
   ```
4. Click on **Database** dropdown and choose `SNOW_HEALTH_INTELLIGENCE.RAW`
5. Choose the search service from the dropdown: `TRAINING_MATERIALS_SEARCH`
6. For **ID Column**: `material_id`
7. For **Title Column**: `title`
8. Click **Add**

---

### Step 3.6: Configure Orchestration

1. Click on **Orchestration** in the left pane
2. **Orchestration model**: Leave as **Auto** (or select a specific model like `mistral-large2`)
3. In the **Planning instructions**, add:
   ```
   If a query spans both structured and unstructured data, clearly separate the sources.
   
   For any query, first determine whether it requires:
   (a) Structured data analysis → Use Cortex Analyst semantic views
   (b) Report content/context → Use Cortex Search
   (c) Both → Combine both services with clear source attribution
   
   Please confirm which approach you'll use before providing each response.
   
   For training compliance queries, always check due dates and mandatory status.
   For credential queries, highlight expiration risks.
   For incident queries, search for similar past cases and corrective actions.
   ```
4. Click **Save** on the top right

---

### Step 3.7: Set Up Access to the Agent

1. Click on **Access** in the left pane
2. Click **Add role**
3. Select the role(s) that should have access to the agent
4. Click **Save** on the top right

---

### Step 3.8: Test the Agent

1. Return to the agent details page (if you clicked Save, you should be back at the main agent view)
2. Use the agent playground at the bottom
3. Ask a simple question: **"How many organizations are in the system?"**
4. Verify the agent:
   - Identifies it will use Cortex Analyst
   - Selects the appropriate semantic view
   - Generates a SQL query
   - Returns the correct count (~50,000 organizations)
5. Review the generated SQL to ensure it's correct

---

## Step 4: Test the Complete Agent

### 4.1 Simple Test Questions

Start with simple questions to verify connectivity:

1. **"How many healthcare organizations are using Snow Health?"**
   - Should query SV_LEARNING_CREDENTIALING_INTELLIGENCE
   - Expected: ~50,000 organizations

2. **"What is the total number of employees in the system?"**
   - Should query SV_LEARNING_CREDENTIALING_INTELLIGENCE
   - Expected: ~500,000 employees

3. **"How many support tickets are currently open?"**
   - Should query SV_ORGANIZATION_SUPPORT_INTELLIGENCE
   - Expected: Count of tickets with status = 'OPEN'

### 4.2 Complex Test Questions

Test with the 10 complex questions provided in `docs/questions.md`, including:

1. Training Compliance Risk Analysis
2. Credential Expiration Tracking
3. Exclusions Monitoring Alerts
4. Incident Pattern Analysis
5. Subscription Health Assessment
6. Revenue Trend Analysis
7. Course Effectiveness Metrics
8. Cross-Sell Opportunity Identification
9. Support Efficiency Benchmarking
10. Policy Compliance Tracking

### 4.3 Cortex Search Test Questions

Test unstructured data search:

1. **"Search support transcripts for course enrollment issues"**
2. **"Find incident reports about medication errors"**
3. **"What does our training material say about HIPAA privacy?"**

---

## Step 5: Query Cortex Search Services Directly (Optional)

You can also query Cortex Search services directly using SQL for testing:

### Query Support Transcripts
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'SNOW_HEALTH_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH',
      '{
        "query": "credential verification help",
        "columns":["transcript_text", "interaction_type"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Incident Reports
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'SNOW_HEALTH_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH',
      '{
        "query": "patient fall prevention",
        "columns":["report_text", "investigation_status"],
        "limit":10
      }'
  )
)['results'] as results;
```

### Query Training Materials
```sql
SELECT PARSE_JSON(
  SNOWFLAKE.CORTEX.SEARCH_PREVIEW(
      'SNOW_HEALTH_INTELLIGENCE.RAW.TRAINING_MATERIALS_SEARCH',
      '{
        "query": "infection control hand hygiene",
        "columns":["title", "content"],
        "limit":5
      }'
  )
)['results'] as results;
```

---

## Step 6: Additional Access Control (Optional)

### Create Role for Agent Users

If you need to create additional roles for other users:
```sql
CREATE ROLE IF NOT EXISTS SNOW_HEALTH_AGENT_USER;

-- Grant necessary privileges
GRANT USAGE ON DATABASE SNOW_HEALTH_INTELLIGENCE TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT USAGE ON SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT USAGE ON SCHEMA SNOW_HEALTH_INTELLIGENCE.RAW TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT SELECT ON ALL VIEWS IN SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT USAGE ON WAREHOUSE SNOW_HEALTH_WH TO ROLE SNOW_HEALTH_AGENT_USER;

-- Grant Cortex Search usage
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.SUPPORT_TRANSCRIPTS_SEARCH TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.INCIDENT_REPORTS_SEARCH TO ROLE SNOW_HEALTH_AGENT_USER;
GRANT USAGE ON CORTEX SEARCH SERVICE SNOW_HEALTH_INTELLIGENCE.RAW.TRAINING_MATERIALS_SEARCH TO ROLE SNOW_HEALTH_AGENT_USER;

-- Grant to specific user
GRANT ROLE SNOW_HEALTH_AGENT_USER TO USER your_username;
```

---

## Troubleshooting

### Issue: Semantic views not found

**Solution:**
```sql
-- Verify semantic views exist
SHOW SEMANTIC VIEWS IN SCHEMA SNOW_HEALTH_INTELLIGENCE.ANALYTICS;

-- Check permissions
SHOW GRANTS ON SEMANTIC VIEW SV_LEARNING_CREDENTIALING_INTELLIGENCE;
```

### Issue: Cortex Search returns no results

**Solution:**
```sql
-- Verify service exists and is populated
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- Check data in source table
SELECT COUNT(*) FROM RAW.SUPPORT_TRANSCRIPTS;

-- Verify change tracking is enabled
SHOW TABLES LIKE 'SUPPORT_TRANSCRIPTS';
```

### Issue: Slow query performance

**Solution:**
- Increase warehouse size (MEDIUM or LARGE)
- Check for missing filters on date columns
- Review query execution plan
- Consider materializing frequently-used aggregations

---

## Success Metrics

Your agent is successfully configured when:

✅ All 6 SQL scripts execute without errors  
✅ All semantic views are created and validated  
✅ All 3 Cortex Search services are created and indexed  
✅ Agent can answer simple test questions  
✅ Agent can answer complex analytical questions  
✅ Cortex Search returns relevant results  
✅ Query performance is acceptable (< 30 seconds for complex queries)  
✅ Results are accurate and match expected business logic  

---

## Support Resources

- **Snowflake Documentation**: https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
- **Snow Health Website**: https://www.snow_health.com
- **Snowflake Community**: https://community.snowflake.com

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** GoDaddy Intelligence Template

