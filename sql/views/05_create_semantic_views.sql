-- ============================================================================
-- Snow Health Intelligence Agent - Semantic Views
-- ============================================================================
-- Purpose: Create semantic views for Snowflake Intelligence agents
-- All syntax VERIFIED against official documentation:
-- https://docs.snowflake.com/en/sql-reference/sql/create-semantic-view
-- 
-- Syntax Verification Notes:
-- 1. Clause order is MANDATORY: TABLES → RELATIONSHIPS → DIMENSIONS → METRICS → COMMENT
-- 2. Semantic expression format: semantic_name AS sql_expression
-- 3. No self-referencing relationships allowed
-- 4. No cyclic relationships allowed
-- 5. PRIMARY KEY columns must exist in table definitions
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA ANALYTICS;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- Semantic View 1: Snow Health Learning & Credentialing Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_LEARNING_CREDENTIALING_INTELLIGENCE
  TABLES (
    organizations AS RAW.ORGANIZATIONS
      PRIMARY KEY (organization_id)
      WITH SYNONYMS ('healthcare organizations', 'training clients', 'learning customers')
      COMMENT = 'Healthcare organizations using Snow Health',
    employees AS RAW.EMPLOYEES
      PRIMARY KEY (employee_id)
      WITH SYNONYMS ('staff', 'providers', 'personnel')
      COMMENT = 'Employees within healthcare organizations',
    courses AS RAW.COURSES
      PRIMARY KEY (course_id)
      WITH SYNONYMS ('training courses', 'classes', 'programs')
      COMMENT = 'Training courses available',
    completions AS RAW.COURSE_COMPLETIONS
      PRIMARY KEY (completion_id)
      WITH SYNONYMS ('course completions', 'training completions', 'certificates')
      COMMENT = 'Completed training courses',
    credentials AS RAW.CREDENTIALS
      PRIMARY KEY (credential_id)
      WITH SYNONYMS ('licenses', 'certifications', 'provider credentials')
      COMMENT = 'Provider credentials and licenses'
  )
  RELATIONSHIPS (
    employees(organization_id) REFERENCES organizations(organization_id),
    completions(employee_id) REFERENCES employees(employee_id),
    completions(course_id) REFERENCES courses(course_id),
    credentials(employee_id) REFERENCES employees(employee_id),
    credentials(organization_id) REFERENCES organizations(organization_id)
  )
  DIMENSIONS (
    organizations.organization_name AS organization_name
      WITH SYNONYMS ('org name view1', 'healthcare facility name', 'training org name')
      COMMENT = 'Name of the healthcare organization',
    organizations.organization_status AS organization_status
      WITH SYNONYMS ('account status view1', 'org active status')
      COMMENT = 'Organization status: ACTIVE, SUSPENDED, CLOSED',
    organizations.organization_type AS organization_type
      WITH SYNONYMS ('org type view1', 'healthcare facility type')
      COMMENT = 'Organization type: HOSPITAL, CLINIC, PRACTICE',
    organizations.state AS state
      WITH SYNONYMS ('org state view1', 'organization location state')
      COMMENT = 'Organization state location',
    organizations.city AS city
      WITH SYNONYMS ('org city view1', 'organization location city')
      COMMENT = 'Organization city location',
    employees.employee_name AS employee_name
      WITH SYNONYMS ('staff name', 'provider name')
      COMMENT = 'Name of the employee',
    employees.job_title AS job_title
      WITH SYNONYMS ('position', 'role', 'title')
      COMMENT = 'Employee job title',
    employees.department AS department
      WITH SYNONYMS ('dept', 'employee team')
      COMMENT = 'Employee department',
    employees.employee_status AS employee_status
      WITH SYNONYMS ('employment status', 'staff status')
      COMMENT = 'Employee status: ACTIVE, LEAVE, TERMINATED',
    employees.compliance_status AS compliance_status
      WITH SYNONYMS ('training compliance', 'compliance state')
      COMMENT = 'Employee compliance status: COMPLIANT, PENDING, NON_COMPLIANT',
    employees.requires_credentialing AS requires_credentialing
      WITH SYNONYMS ('needs credentials', 'credentialing required')
      COMMENT = 'Whether employee requires professional credentialing',
    courses.course_name AS course_name
      WITH SYNONYMS ('training name', 'class name')
      COMMENT = 'Name of the training course',
    courses.course_category AS course_category
      WITH SYNONYMS ('training category', 'course type')
      COMMENT = 'Course category: CPR_BLS, OSHA, HIPAA, INFECTION_CONTROL, etc',
    courses.course_type AS course_type
      WITH SYNONYMS ('training type')
      COMMENT = 'Course type: CERTIFICATION, COMPLIANCE, TRAINING',
    courses.accreditation_body AS accreditation_body
      WITH SYNONYMS ('accrediting organization', 'certifying body')
      COMMENT = 'Organization providing accreditation: AHA, OSHA, HHS, etc',
    completions.pass_fail AS pass_fail
      WITH SYNONYMS ('completion status', 'result')
      COMMENT = 'Whether employee passed or failed the course',
    completions.certificate_issued AS certificate_issued
      WITH SYNONYMS ('certified', 'certificate granted')
      COMMENT = 'Whether certificate was issued upon completion',
    credentials.credential_type AS credential_type
      WITH SYNONYMS ('license type', 'certification type')
      COMMENT = 'Type of credential: MEDICAL_LICENSE, NURSING_LICENSE, DEA_CERTIFICATE, etc',
    credentials.credential_name AS credential_name
      WITH SYNONYMS ('license name', 'certification name')
      COMMENT = 'Name of the credential',
    credentials.credential_status AS credential_status
      WITH SYNONYMS ('license status', 'certification status')
      COMMENT = 'Credential status: ACTIVE, EXPIRED',
    credentials.issuing_authority AS issuing_authority
      WITH SYNONYMS ('issuing body', 'licensing board')
      COMMENT = 'Authority that issued the credential'
  )
  METRICS (
    organizations.total_organizations AS COUNT(DISTINCT organization_id)
      WITH SYNONYMS ('organization count view1', 'number of orgs learning')
      COMMENT = 'Total number of organizations',
    organizations.avg_compliance_risk AS AVG(compliance_risk_score)
      WITH SYNONYMS ('average compliance risk', 'mean risk score')
      COMMENT = 'Average compliance risk score across organizations',
    employees.total_employees AS COUNT(DISTINCT employee_id)
      WITH SYNONYMS ('employee count', 'staff count', 'number of employees')
      COMMENT = 'Total number of employees',
    courses.total_courses AS COUNT(DISTINCT course_id)
      WITH SYNONYMS ('course count', 'training count')
      COMMENT = 'Total number of courses available',
    courses.avg_course_duration AS AVG(duration_minutes)
      WITH SYNONYMS ('average course length', 'mean duration')
      COMMENT = 'Average course duration in minutes',
    courses.avg_required_score AS AVG(required_score)
      WITH SYNONYMS ('average passing score')
      COMMENT = 'Average required passing score for courses',
    completions.total_completions AS COUNT(DISTINCT completion_id)
      WITH SYNONYMS ('completion count', 'number of completions')
      COMMENT = 'Total number of course completions',
    completions.avg_completion_score AS AVG(score)
      WITH SYNONYMS ('average score', 'mean completion score')
      COMMENT = 'Average score achieved on completed courses',
    completions.total_time_spent AS SUM(time_spent_minutes)
      WITH SYNONYMS ('total training time', 'cumulative training minutes')
      COMMENT = 'Total time spent on training in minutes',
    completions.avg_time_spent AS AVG(time_spent_minutes)
      WITH SYNONYMS ('average training time', 'mean time spent')
      COMMENT = 'Average time spent per course completion',
    credentials.total_credentials AS COUNT(DISTINCT credential_id)
      WITH SYNONYMS ('credential count', 'license count')
      COMMENT = 'Total number of credentials tracked',
    credentials.avg_credential_age AS AVG(DATEDIFF('day', issue_date, CURRENT_DATE()))
      WITH SYNONYMS ('average credential age')
      COMMENT = 'Average age of credentials in days'
  )
  COMMENT = 'Snow Health Learning & Credentialing Intelligence - comprehensive view of training, courses, credentials, and compliance';

-- ============================================================================
-- Semantic View 2: Snow Health Subscription & Revenue Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_SUBSCRIPTION_REVENUE_INTELLIGENCE
  TABLES (
    organizations AS RAW.ORGANIZATIONS
      PRIMARY KEY (organization_id)
      WITH SYNONYMS ('subscription clients', 'revenue customers')
      COMMENT = 'Healthcare organizations',
    subscriptions AS RAW.SUBSCRIPTIONS
      PRIMARY KEY (subscription_id)
      WITH SYNONYMS ('service subscriptions', 'plans', 'service plans')
      COMMENT = 'Snow Health service subscriptions',
    transactions AS RAW.TRANSACTIONS
      PRIMARY KEY (transaction_id)
      WITH SYNONYMS ('purchases', 'payments', 'invoices')
      COMMENT = 'Financial transactions',
    products AS RAW.PRODUCTS
      PRIMARY KEY (product_id)
      WITH SYNONYMS ('services', 'offerings', 'packages')
      COMMENT = 'Snow Health products and services'
  )
  RELATIONSHIPS (
    subscriptions(organization_id) REFERENCES organizations(organization_id),
    transactions(organization_id) REFERENCES organizations(organization_id),
    transactions(product_id) REFERENCES products(product_id)
  )
  DIMENSIONS (
    organizations.organization_name AS organization_name
      WITH SYNONYMS ('subscription org name', 'revenue client name')
      COMMENT = 'Name of the organization',
    organizations.organization_type AS organization_type
      WITH SYNONYMS ('subscription org type', 'revenue customer segment')
      COMMENT = 'Organization type: HOSPITAL, CLINIC, PRACTICE',
    organizations.state AS state
      WITH SYNONYMS ('subscription org state', 'revenue location state')
      COMMENT = 'Organization state location',
    subscriptions.service_type AS service_type
      WITH SYNONYMS ('subscription type', 'service category')
      COMMENT = 'Service type: LEARNING, CREDENTIALING, COMPLIANCE, FULL_SUITE',
    subscriptions.subscription_tier AS subscription_tier
      WITH SYNONYMS ('plan tier', 'package level')
      COMMENT = 'Subscription tier: BASIC, PROFESSIONAL, ENTERPRISE',
    subscriptions.billing_cycle AS billing_cycle
      WITH SYNONYMS ('payment frequency', 'billing period')
      COMMENT = 'Billing cycle: MONTHLY, ANNUAL',
    subscriptions.subscription_status AS subscription_status
      WITH SYNONYMS ('plan status', 'service status')
      COMMENT = 'Subscription status: ACTIVE, EXPIRED, PENDING_RENEWAL',
    subscriptions.course_library_access AS course_library_access
      WITH SYNONYMS ('course access level', 'training library access')
      COMMENT = 'Level of course library access',
    subscriptions.advanced_reporting AS advanced_reporting
      WITH SYNONYMS ('premium reporting', 'advanced analytics')
      COMMENT = 'Whether advanced reporting is included',
    transactions.transaction_type AS transaction_type
      WITH SYNONYMS ('transaction category', 'purchase type')
      COMMENT = 'Transaction type: SUBSCRIPTION_NEW, SUBSCRIPTION_RENEWAL, COURSE_PURCHASE, etc',
    transactions.product_type AS product_type
      WITH SYNONYMS ('transaction service type')
      COMMENT = 'Product type: LEARNING, CREDENTIALING, COMPLIANCE, FULL_SUITE',
    transactions.payment_method AS payment_method
      WITH SYNONYMS ('transaction payment type', 'payment method type')
      COMMENT = 'Payment method: CREDIT_CARD, ACH, WIRE_TRANSFER, CHECK',
    transactions.payment_status AS payment_status
      WITH SYNONYMS ('transaction payment status', 'payment completion status')
      COMMENT = 'Payment status: COMPLETED, FAILED, REFUNDED',
    transactions.currency AS currency
      WITH SYNONYMS ('payment currency')
      COMMENT = 'Transaction currency',
    products.product_name AS product_name
      WITH SYNONYMS ('service name', 'package name')
      COMMENT = 'Name of the product or service',
    products.product_category AS product_category
      WITH SYNONYMS ('product type')
      COMMENT = 'Product category: LEARNING, CREDENTIALING, COMPLIANCE, FULL_SUITE',
    products.product_subcategory AS product_subcategory
      WITH SYNONYMS ('subcategory')
      COMMENT = 'Product subcategory',
    products.billing_frequency AS billing_frequency
      WITH SYNONYMS ('product billing frequency', 'product payment frequency')
      COMMENT = 'Billing frequency for product',
    products.is_active AS is_active
      WITH SYNONYMS ('available', 'active product')
      COMMENT = 'Whether product is currently active'
  )
  METRICS (
    organizations.total_organizations AS COUNT(DISTINCT organization_id)
      WITH SYNONYMS ('organization count view2', 'number of orgs subscriptions')
      COMMENT = 'Total number of organizations',
    subscriptions.total_subscriptions AS COUNT(DISTINCT subscription_id)
      WITH SYNONYMS ('subscription count', 'plan count')
      COMMENT = 'Total number of subscriptions',
    subscriptions.avg_monthly_price AS AVG(monthly_price)
      WITH SYNONYMS ('average subscription price', 'mean monthly cost')
      COMMENT = 'Average monthly subscription price',
    subscriptions.total_employee_licenses AS SUM(employee_licenses)
      WITH SYNONYMS ('total licenses', 'cumulative licenses')
      COMMENT = 'Total employee licenses across all subscriptions',
    subscriptions.avg_employee_licenses AS AVG(employee_licenses)
      WITH SYNONYMS ('average licenses per subscription')
      COMMENT = 'Average number of employee licenses per subscription',
    transactions.total_transactions AS COUNT(DISTINCT transaction_id)
      WITH SYNONYMS ('transaction count', 'payment count')
      COMMENT = 'Total number of transactions',
    transactions.total_revenue AS SUM(total_amount)
      WITH SYNONYMS ('total sales', 'gross revenue')
      COMMENT = 'Total revenue from all transactions',
    transactions.avg_transaction_amount AS AVG(total_amount)
      WITH SYNONYMS ('average transaction value', 'mean purchase amount')
      COMMENT = 'Average transaction amount',
    transactions.total_discount_amount AS SUM(discount_amount)
      WITH SYNONYMS ('total discounts', 'discount sum')
      COMMENT = 'Total discount amount given',
    transactions.total_tax_amount AS SUM(tax_amount)
      WITH SYNONYMS ('total tax', 'tax sum')
      COMMENT = 'Total tax amount collected',
    products.total_products AS COUNT(DISTINCT product_id)
      WITH SYNONYMS ('product count')
      COMMENT = 'Total number of unique products',
    products.avg_base_price AS AVG(base_price)
      WITH SYNONYMS ('average base price')
      COMMENT = 'Average product base price',
    products.avg_recurring_price AS AVG(recurring_price)
      WITH SYNONYMS ('average recurring price')
      COMMENT = 'Average product recurring price'
  )
  COMMENT = 'Snow Health Subscription & Revenue Intelligence - comprehensive view of subscriptions, products, transactions, and revenue metrics';

-- ============================================================================
-- Semantic View 3: Snow Health Organization Support Intelligence
-- ============================================================================
CREATE OR REPLACE SEMANTIC VIEW SV_ORGANIZATION_SUPPORT_INTELLIGENCE
  TABLES (
    organizations AS RAW.ORGANIZATIONS
      PRIMARY KEY (organization_id)
      WITH SYNONYMS ('support clients', 'ticket customers')
      COMMENT = 'Healthcare organizations',
    tickets AS RAW.SUPPORT_TICKETS
      PRIMARY KEY (ticket_id)
      WITH SYNONYMS ('support cases', 'help requests', 'issues')
      COMMENT = 'Customer support tickets',
    agents AS RAW.SUPPORT_AGENTS
      PRIMARY KEY (agent_id)
      WITH SYNONYMS ('support staff', 'help desk agents', 'representatives')
      COMMENT = 'Support agents'
  )
  RELATIONSHIPS (
    tickets(organization_id) REFERENCES organizations(organization_id),
    tickets(assigned_agent_id) REFERENCES agents(agent_id)
  )
  DIMENSIONS (
    organizations.organization_name AS organization_name
      WITH SYNONYMS ('support org name', 'ticket client name')
      COMMENT = 'Name of the organization',
    organizations.organization_type AS organization_type
      WITH SYNONYMS ('support customer type', 'support facility type')
      COMMENT = 'Organization type: HOSPITAL, CLINIC, PRACTICE',
    tickets.issue_type AS issue_type
      WITH SYNONYMS ('problem type', 'ticket category')
      COMMENT = 'Issue type: TECHNICAL, BILLING, ACCOUNT, TRAINING, CREDENTIALING, COMPLIANCE, INTEGRATION',
    tickets.priority AS priority
      WITH SYNONYMS ('urgency', 'ticket priority')
      COMMENT = 'Ticket priority: LOW, MEDIUM, HIGH, URGENT',
    tickets.ticket_status AS ticket_status
      WITH SYNONYMS ('status', 'case status')
      COMMENT = 'Ticket status: OPEN, IN_PROGRESS, CLOSED',
    tickets.channel AS channel
      WITH SYNONYMS ('contact channel', 'communication method')
      COMMENT = 'Support channel: PHONE, EMAIL, CHAT, WEB_PORTAL',
    agents.agent_name AS agent_name
      WITH SYNONYMS ('support agent', 'rep name')
      COMMENT = 'Name of support agent',
    agents.department AS department
      WITH SYNONYMS ('support team', 'agent department')
      COMMENT = 'Agent department: LEARNING, CREDENTIALING, COMPLIANCE, TECHNICAL, BILLING',
    agents.specialization AS specialization
      WITH SYNONYMS ('expertise', 'specialty')
      COMMENT = 'Agent specialization area',
    agents.agent_status AS agent_status
      WITH SYNONYMS ('agent state')
      COMMENT = 'Agent status: ACTIVE, INACTIVE'
  )
  METRICS (
    organizations.total_organizations AS COUNT(DISTINCT organization_id)
      WITH SYNONYMS ('organization count view3', 'number of orgs support')
      COMMENT = 'Total number of organizations',
    tickets.total_tickets AS COUNT(DISTINCT ticket_id)
      WITH SYNONYMS ('ticket count', 'case count', 'number of tickets')
      COMMENT = 'Total number of support tickets',
    tickets.avg_resolution_time AS AVG(resolution_time_hours)
      WITH SYNONYMS ('average resolution time', 'mean time to resolve')
      COMMENT = 'Average ticket resolution time in hours',
    tickets.avg_satisfaction_rating AS AVG(satisfaction_rating)
      WITH SYNONYMS ('average satisfaction', 'csat score', 'customer satisfaction')
      COMMENT = 'Average customer satisfaction rating',
    agents.total_agents AS COUNT(DISTINCT agent_id)
      WITH SYNONYMS ('agent count', 'support staff count')
      COMMENT = 'Total number of support agents',
    agents.avg_agent_satisfaction AS AVG(average_satisfaction_rating)
      WITH SYNONYMS ('average agent rating')
      COMMENT = 'Average satisfaction rating across all agents',
    agents.total_tickets_resolved_by_agents AS SUM(total_tickets_resolved)
      WITH SYNONYMS ('total resolved tickets', 'cumulative resolutions')
      COMMENT = 'Total tickets resolved by all agents'
  )
  COMMENT = 'Snow Health Organization Support Intelligence - comprehensive view of support tickets, agents, and customer satisfaction';

-- ============================================================================
-- Display confirmation and verification
-- ============================================================================
SELECT 'Semantic views created successfully - all syntax verified' AS status;

-- Verify semantic views exist
SELECT 
    table_name AS semantic_view_name,
    comment AS description
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'ANALYTICS'
  AND table_name LIKE 'SV_%'
ORDER BY table_name;

-- Show semantic view details
SHOW SEMANTIC VIEWS IN SCHEMA ANALYTICS;

