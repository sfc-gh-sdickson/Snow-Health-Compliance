-- ============================================================================
-- Snow Health Intelligence Agent - Table Definitions
-- ============================================================================
-- Purpose: Create all necessary tables for the Snow Health business model
-- Based on verified GoDaddy template structure
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- ORGANIZATIONS TABLE (from CUSTOMERS)
-- ============================================================================
CREATE OR REPLACE TABLE ORGANIZATIONS (
    organization_id VARCHAR(20) PRIMARY KEY,
    organization_name VARCHAR(200) NOT NULL,
    contact_email VARCHAR(200) NOT NULL,
    contact_phone VARCHAR(20),
    country VARCHAR(50) DEFAULT 'USA',
    state VARCHAR(50),
    city VARCHAR(100),
    signup_date DATE NOT NULL,
    organization_status VARCHAR(20) DEFAULT 'ACTIVE',
    organization_type VARCHAR(30),
    lifetime_value NUMBER(12,2) DEFAULT 0.00,
    compliance_risk_score NUMBER(5,2),
    total_employees NUMBER(10,0) DEFAULT 0,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- SUBSCRIPTIONS TABLE (from HOSTING_PLANS)
-- ============================================================================
CREATE OR REPLACE TABLE SUBSCRIPTIONS (
    subscription_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    service_type VARCHAR(50) NOT NULL,
    subscription_tier VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    billing_cycle VARCHAR(20),
    monthly_price NUMBER(10,2),
    employee_licenses NUMBER(10,0),
    course_library_access VARCHAR(50),
    advanced_reporting BOOLEAN DEFAULT FALSE,
    subscription_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- EMPLOYEES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE EMPLOYEES (
    employee_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    employee_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    job_title VARCHAR(100),
    department VARCHAR(100),
    hire_date DATE,
    employee_status VARCHAR(20) DEFAULT 'ACTIVE',
    requires_credentialing BOOLEAN DEFAULT FALSE,
    compliance_status VARCHAR(30) DEFAULT 'COMPLIANT',
    last_training_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- COURSES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE COURSES (
    course_id VARCHAR(30) PRIMARY KEY,
    course_name VARCHAR(200) NOT NULL,
    course_category VARCHAR(50) NOT NULL,
    course_type VARCHAR(50),
    duration_minutes NUMBER(10,0),
    required_score NUMBER(5,2),
    renewal_frequency_days NUMBER(10,0),
    course_description VARCHAR(1000),
    accreditation_body VARCHAR(100),
    credits_awarded NUMBER(5,2),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- COURSE_ENROLLMENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE COURSE_ENROLLMENTS (
    enrollment_id VARCHAR(30) PRIMARY KEY,
    employee_id VARCHAR(30) NOT NULL,
    course_id VARCHAR(30) NOT NULL,
    organization_id VARCHAR(20) NOT NULL,
    enrollment_date TIMESTAMP_NTZ NOT NULL,
    due_date DATE,
    enrollment_status VARCHAR(30) DEFAULT 'ENROLLED',
    assigned_by VARCHAR(100),
    is_mandatory BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- COURSE_COMPLETIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE COURSE_COMPLETIONS (
    completion_id VARCHAR(30) PRIMARY KEY,
    enrollment_id VARCHAR(30) NOT NULL,
    employee_id VARCHAR(30) NOT NULL,
    course_id VARCHAR(30) NOT NULL,
    completion_date TIMESTAMP_NTZ NOT NULL,
    score NUMBER(5,2),
    pass_fail VARCHAR(10),
    time_spent_minutes NUMBER(10,0),
    certificate_issued BOOLEAN DEFAULT FALSE,
    certificate_number VARCHAR(50),
    expiration_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (enrollment_id) REFERENCES COURSE_ENROLLMENTS(enrollment_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (course_id) REFERENCES COURSES(course_id)
);

-- ============================================================================
-- CREDENTIALS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE CREDENTIALS (
    credential_id VARCHAR(30) PRIMARY KEY,
    employee_id VARCHAR(30) NOT NULL,
    organization_id VARCHAR(20) NOT NULL,
    credential_type VARCHAR(50) NOT NULL,
    credential_name VARCHAR(200) NOT NULL,
    issuing_authority VARCHAR(200),
    license_number VARCHAR(100),
    issue_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    credential_status VARCHAR(30) DEFAULT 'ACTIVE',
    verification_required BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- CREDENTIAL_VERIFICATIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE CREDENTIAL_VERIFICATIONS (
    verification_id VARCHAR(30) PRIMARY KEY,
    credential_id VARCHAR(30) NOT NULL,
    verification_date TIMESTAMP_NTZ NOT NULL,
    verification_method VARCHAR(50),
    verification_status VARCHAR(30) NOT NULL,
    verified_by VARCHAR(100),
    verification_source VARCHAR(200),
    notes VARCHAR(1000),
    next_verification_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (credential_id) REFERENCES CREDENTIALS(credential_id)
);

-- ============================================================================
-- EXCLUSIONS_MONITORING TABLE
-- ============================================================================
CREATE OR REPLACE TABLE EXCLUSIONS_MONITORING (
    monitoring_id VARCHAR(30) PRIMARY KEY,
    employee_id VARCHAR(30) NOT NULL,
    organization_id VARCHAR(20) NOT NULL,
    monitoring_date TIMESTAMP_NTZ NOT NULL,
    database_checked VARCHAR(50) NOT NULL,
    exclusion_found BOOLEAN DEFAULT FALSE,
    exclusion_details VARCHAR(1000),
    monitoring_status VARCHAR(30) DEFAULT 'CLEAR',
    next_check_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- INCIDENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE INCIDENTS (
    incident_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    reported_by_employee_id VARCHAR(30),
    incident_date TIMESTAMP_NTZ NOT NULL,
    incident_type VARCHAR(50) NOT NULL,
    incident_category VARCHAR(50),
    severity VARCHAR(20) DEFAULT 'MEDIUM',
    incident_status VARCHAR(30) DEFAULT 'OPEN',
    location VARCHAR(200),
    description VARCHAR(5000),
    investigation_status VARCHAR(30),
    resolved_date TIMESTAMP_NTZ,
    resolution_notes VARCHAR(5000),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id),
    FOREIGN KEY (reported_by_employee_id) REFERENCES EMPLOYEES(employee_id)
);

-- ============================================================================
-- POLICIES TABLE
-- ============================================================================
CREATE OR REPLACE TABLE POLICIES (
    policy_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    policy_name VARCHAR(200) NOT NULL,
    policy_category VARCHAR(50) NOT NULL,
    policy_version VARCHAR(20),
    effective_date DATE NOT NULL,
    review_date DATE,
    policy_status VARCHAR(30) DEFAULT 'ACTIVE',
    requires_acknowledgment BOOLEAN DEFAULT TRUE,
    policy_owner VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- POLICY_ACKNOWLEDGMENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE POLICY_ACKNOWLEDGMENTS (
    acknowledgment_id VARCHAR(30) PRIMARY KEY,
    policy_id VARCHAR(30) NOT NULL,
    employee_id VARCHAR(30) NOT NULL,
    organization_id VARCHAR(20) NOT NULL,
    acknowledgment_date TIMESTAMP_NTZ NOT NULL,
    acknowledgment_method VARCHAR(50),
    ip_address VARCHAR(50),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (policy_id) REFERENCES POLICIES(policy_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- ACCREDITATIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE ACCREDITATIONS (
    accreditation_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    accreditation_body VARCHAR(200) NOT NULL,
    accreditation_type VARCHAR(100) NOT NULL,
    accreditation_number VARCHAR(100),
    issue_date DATE NOT NULL,
    expiration_date DATE NOT NULL,
    accreditation_status VARCHAR(30) DEFAULT 'ACTIVE',
    next_review_date DATE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- TRANSACTIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE TRANSACTIONS (
    transaction_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    transaction_date TIMESTAMP_NTZ NOT NULL,
    transaction_type VARCHAR(50) NOT NULL,
    product_type VARCHAR(50),
    product_id VARCHAR(30),
    amount NUMBER(12,2) NOT NULL,
    currency VARCHAR(10) DEFAULT 'USD',
    payment_method VARCHAR(30),
    payment_status VARCHAR(30) DEFAULT 'COMPLETED',
    discount_amount NUMBER(10,2) DEFAULT 0.00,
    tax_amount NUMBER(10,2) DEFAULT 0.00,
    total_amount NUMBER(12,2) NOT NULL,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- SUPPORT_TICKETS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TICKETS (
    ticket_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    subject VARCHAR(500) NOT NULL,
    issue_type VARCHAR(50) NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM',
    ticket_status VARCHAR(30) DEFAULT 'OPEN',
    channel VARCHAR(30),
    assigned_agent_id VARCHAR(20),
    created_date TIMESTAMP_NTZ NOT NULL,
    first_response_date TIMESTAMP_NTZ,
    resolved_date TIMESTAMP_NTZ,
    closed_date TIMESTAMP_NTZ,
    resolution_time_hours NUMBER(10,2),
    satisfaction_rating NUMBER(3,0),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- SUPPORT_AGENTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_AGENTS (
    agent_id VARCHAR(20) PRIMARY KEY,
    agent_name VARCHAR(200) NOT NULL,
    email VARCHAR(200) NOT NULL,
    department VARCHAR(50),
    specialization VARCHAR(100),
    hire_date DATE,
    average_satisfaction_rating NUMBER(3,2),
    total_tickets_resolved NUMBER(10,0) DEFAULT 0,
    agent_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- PRODUCTS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE PRODUCTS (
    product_id VARCHAR(30) PRIMARY KEY,
    product_name VARCHAR(200) NOT NULL,
    product_category VARCHAR(50) NOT NULL,
    product_subcategory VARCHAR(50),
    base_price NUMBER(10,2),
    recurring_price NUMBER(10,2),
    billing_frequency VARCHAR(20),
    product_description VARCHAR(1000),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    updated_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- MARKETING_CAMPAIGNS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE MARKETING_CAMPAIGNS (
    campaign_id VARCHAR(30) PRIMARY KEY,
    campaign_name VARCHAR(200) NOT NULL,
    campaign_type VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    target_audience VARCHAR(100),
    budget NUMBER(12,2),
    channel VARCHAR(50),
    campaign_status VARCHAR(30) DEFAULT 'ACTIVE',
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- ORGANIZATION_CAMPAIGN_INTERACTIONS TABLE
-- ============================================================================
CREATE OR REPLACE TABLE ORGANIZATION_CAMPAIGN_INTERACTIONS (
    interaction_id VARCHAR(30) PRIMARY KEY,
    organization_id VARCHAR(20) NOT NULL,
    campaign_id VARCHAR(30) NOT NULL,
    interaction_date TIMESTAMP_NTZ NOT NULL,
    interaction_type VARCHAR(50) NOT NULL,
    conversion_flag BOOLEAN DEFAULT FALSE,
    revenue_generated NUMBER(12,2) DEFAULT 0.00,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id),
    FOREIGN KEY (campaign_id) REFERENCES MARKETING_CAMPAIGNS(campaign_id)
);

-- ============================================================================
-- Display confirmation
-- ============================================================================
SELECT 'All tables created successfully' AS status;

