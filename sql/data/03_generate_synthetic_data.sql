-- ============================================================================
-- Snow Health Intelligence Agent - Synthetic Data Generation
-- ============================================================================
-- Purpose: Generate realistic sample data for Snow Health business operations
-- Volume: ~50K organizations, 500K employees, 1M enrollments, 1.5M transactions
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- Step 1: Generate Support Agents
-- ============================================================================
INSERT INTO SUPPORT_AGENTS
SELECT
    'AGT' || LPAD(SEQ4(), 5, '0') AS agent_id,
    ARRAY_CONSTRUCT('John Smith', 'Sarah Johnson', 'Michael Chen', 'Emily Williams', 'David Martinez',
                    'Jessica Brown', 'Christopher Lee', 'Amanda Garcia', 'Matthew Rodriguez', 'Ashley Lopez')[UNIFORM(0, 9, RANDOM())] 
        || ' ' || ARRAY_CONSTRUCT('A', 'B', 'C', 'D', 'E')[UNIFORM(0, 4, RANDOM())] AS agent_name,
    'agent' || SEQ4() || '@snow_health.com' AS email,
    ARRAY_CONSTRUCT('LEARNING', 'CREDENTIALING', 'COMPLIANCE', 'TECHNICAL', 'BILLING')[UNIFORM(0, 4, RANDOM())] AS department,
    ARRAY_CONSTRUCT('Course Setup', 'Credential Verification', 'Policy Management', 'System Training', 'Account Support')[UNIFORM(0, 4, RANDOM())] AS specialization,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_DATE()) AS hire_date,
    (UNIFORM(35, 50, RANDOM()) / 10.0)::NUMBER(3,2) AS average_satisfaction_rating,
    UNIFORM(100, 5000, RANDOM()) AS total_tickets_resolved,
    'ACTIVE' AS agent_status,
    DATEADD('day', -1 * UNIFORM(30, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 100));

-- ============================================================================
-- Step 2: Generate Products
-- ============================================================================
INSERT INTO PRODUCTS VALUES
-- Learning Products
('PROD001', 'Basic Learning Package', 'LEARNING', 'BASIC', NULL, 299.00, 'MONTHLY', 'Essential training courses for up to 50 employees', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD002', 'Professional Learning Package', 'LEARNING', 'PROFESSIONAL', NULL, 599.00, 'MONTHLY', 'Comprehensive training library for up to 200 employees', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD003', 'Enterprise Learning Package', 'LEARNING', 'ENTERPRISE', NULL, 1299.00, 'MONTHLY', 'Unlimited training courses with custom content creation', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD004', 'CPR/BLS Training Course', 'LEARNING', 'COURSE', 49.00, NULL, 'ONE_TIME', 'CPR and Basic Life Support certification course', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD005', 'OSHA Safety Training', 'LEARNING', 'COURSE', 89.00, NULL, 'ONE_TIME', 'OSHA compliance and workplace safety training', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Credentialing Products
('PROD010', 'Basic Credentialing Service', 'CREDENTIALING', 'BASIC', NULL, 399.00, 'MONTHLY', 'Credential tracking for up to 25 providers', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD011', 'Advanced Credentialing Service', 'CREDENTIALING', 'ADVANCED', NULL, 799.00, 'MONTHLY', 'Full credentialing with verification and monitoring', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD012', 'Full Credentialing Suite', 'CREDENTIALING', 'ENTERPRISE', NULL, 1599.00, 'MONTHLY', 'Enterprise credentialing with automated verification', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD013', 'Exclusions Monitoring', 'CREDENTIALING', 'ADDON', NULL, 199.00, 'MONTHLY', 'Monthly OIG and SAM exclusion database monitoring', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Compliance Products
('PROD020', 'Basic Compliance Manager', 'COMPLIANCE', 'BASIC', NULL, 349.00, 'MONTHLY', 'Policy management and incident reporting', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD021', 'Professional Compliance Suite', 'COMPLIANCE', 'PROFESSIONAL', NULL, 699.00, 'MONTHLY', 'Comprehensive compliance with accreditation tracking', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD022', 'Enterprise Compliance Platform', 'COMPLIANCE', 'ENTERPRISE', NULL, 1399.00, 'MONTHLY', 'Full compliance suite with audit support', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Full Suite
('PROD030', 'Snow Health Full Suite - Small', 'FULL_SUITE', 'SMALL', NULL, 899.00, 'MONTHLY', 'Learning + Credentialing + Compliance for small organizations', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD031', 'Snow Health Full Suite - Medium', 'FULL_SUITE', 'MEDIUM', NULL, 1799.00, 'MONTHLY', 'Learning + Credentialing + Compliance for medium organizations', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('PROD032', 'Snow Health Full Suite - Large', 'FULL_SUITE', 'LARGE', NULL, 2999.00, 'MONTHLY', 'Learning + Credentialing + Compliance for large organizations', TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 3: Generate Organizations
-- ============================================================================
INSERT INTO ORGANIZATIONS
SELECT
    'ORG' || LPAD(SEQ4(), 10, '0') AS organization_id,
    ARRAY_CONSTRUCT('General', 'Regional', 'Community', 'Memorial', 'St.', 'University', 'County', 'City')[UNIFORM(0, 7, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Hospital', 'Medical Center', 'Health System', 'Clinic', 'Healthcare', 'Surgery Center', 'Urgent Care', 'Wellness Center')[UNIFORM(0, 7, RANDOM())] AS organization_name,
    'contact' || SEQ4() || '@' || ARRAY_CONSTRUCT('hospital', 'healthcare', 'medical', 'clinic')[UNIFORM(0, 3, RANDOM())] || '.com' AS contact_email,
    CONCAT('+1-', UNIFORM(200, 999, RANDOM()), '-', UNIFORM(100, 999, RANDOM()), '-', UNIFORM(1000, 9999, RANDOM())) AS contact_phone,
    'USA' AS country,
    ARRAY_CONSTRUCT('CA', 'TX', 'FL', 'NY', 'IL', 'PA', 'OH', 'GA', 'NC', 'MI', 'WA', 'AZ', 'MA', 'VA', 'CO')[UNIFORM(0, 14, RANDOM())] AS state,
    ARRAY_CONSTRUCT('Los Angeles', 'Houston', 'Miami', 'New York', 'Chicago', 'Philadelphia', 'Phoenix', 'Seattle', 'Boston', 'Denver')[UNIFORM(0, 9, RANDOM())] AS city,
    DATEADD('day', -1 * UNIFORM(1, 3650, RANDOM()), CURRENT_DATE()) AS signup_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 95 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 3 THEN 'SUSPENDED'
         ELSE 'CLOSED' END AS organization_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 30 THEN 'HOSPITAL'
         WHEN UNIFORM(0, 100, RANDOM()) < 60 THEN 'CLINIC'
         ELSE 'PRACTICE' END AS organization_type,
    (UNIFORM(5000, 100000, RANDOM()) / 1.0)::NUMBER(12,2) AS lifetime_value,
    (UNIFORM(10, 90, RANDOM()) / 1.0)::NUMBER(5,2) AS compliance_risk_score,
    UNIFORM(10, 500, RANDOM()) AS total_employees,
    DATEADD('day', -1 * UNIFORM(1, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM TABLE(GENERATOR(ROWCOUNT => 50000));

-- ============================================================================
-- Step 4: Generate Courses
-- ============================================================================
INSERT INTO COURSES VALUES
-- CPR/BLS Courses
('CRS001', 'CPR for Healthcare Providers', 'CPR_BLS', 'CERTIFICATION', 180, 80.00, 730, 'American Heart Association CPR certification for healthcare professionals', 'AHA', 2.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS002', 'Basic Life Support (BLS)', 'CPR_BLS', 'CERTIFICATION', 240, 80.00, 730, 'BLS Provider course with hands-on skills training', 'AHA', 2.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS003', 'Advanced Cardiovascular Life Support (ACLS)', 'CPR_BLS', 'CERTIFICATION', 480, 84.00, 730, 'Advanced cardiac life support for emergency situations', 'AHA', 8.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- OSHA Courses
('CRS010', 'OSHA Bloodborne Pathogens', 'OSHA', 'COMPLIANCE', 60, 80.00, 365, 'OSHA-required training on bloodborne pathogen exposure', 'OSHA', 1.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS011', 'OSHA Hazard Communication', 'OSHA', 'COMPLIANCE', 90, 80.00, 365, 'Understanding and managing workplace hazards', 'OSHA', 1.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS012', 'OSHA Emergency Action Plan', 'OSHA', 'COMPLIANCE', 45, 80.00, 365, 'Emergency preparedness and response planning', 'OSHA', 0.75, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- HIPAA Courses
('CRS020', 'HIPAA Privacy Fundamentals', 'HIPAA', 'COMPLIANCE', 120, 85.00, 365, 'Understanding HIPAA privacy rules and patient rights', 'HHS', 2.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS021', 'HIPAA Security Rule', 'HIPAA', 'COMPLIANCE', 90, 85.00, 365, 'Technical and physical safeguards for PHI', 'HHS', 1.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS022', 'HIPAA Breach Notification', 'HIPAA', 'COMPLIANCE', 60, 80.00, 365, 'Requirements for breach assessment and notification', 'HHS', 1.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Infection Control
('CRS030', 'Infection Control Basics', 'INFECTION_CONTROL', 'COMPLIANCE', 90, 80.00, 365, 'Standard precautions and infection prevention', 'CDC', 1.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS031', 'Hand Hygiene and PPE', 'INFECTION_CONTROL', 'COMPLIANCE', 45, 80.00, 365, 'Proper hand hygiene techniques and PPE usage', 'CDC', 0.75, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS032', 'COVID-19 Infection Prevention', 'INFECTION_CONTROL', 'COMPLIANCE', 75, 80.00, 180, 'COVID-19 prevention protocols for healthcare settings', 'CDC', 1.25, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Clinical Skills
('CRS040', 'Medication Administration Safety', 'CLINICAL', 'TRAINING', 120, 85.00, 730, 'Safe medication administration practices', 'Internal', 2.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS041', 'Patient Transfer Techniques', 'CLINICAL', 'TRAINING', 90, 80.00, 365, 'Safe patient handling and mobility', 'Internal', 1.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS042', 'Wound Care Management', 'CLINICAL', 'TRAINING', 150, 80.00, 730, 'Assessment and treatment of various wound types', 'Internal', 2.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Compliance & Ethics
('CRS050', 'Healthcare Compliance Fundamentals', 'COMPLIANCE', 'COMPLIANCE', 120, 80.00, 365, 'Overview of healthcare regulations and compliance', 'Internal', 2.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS051', 'Anti-Kickback and Stark Law', 'COMPLIANCE', 'COMPLIANCE', 90, 85.00, 365, 'Understanding fraud and abuse regulations', 'Internal', 1.5, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS052', 'Corporate Compliance and Ethics', 'COMPLIANCE', 'COMPLIANCE', 60, 80.00, 365, 'Ethical decision-making in healthcare', 'Internal', 1.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),

-- Workplace Safety
('CRS060', 'Fire Safety and Prevention', 'SAFETY', 'COMPLIANCE', 45, 80.00, 365, 'Fire safety protocols and evacuation procedures', 'Internal', 0.75, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS061', 'Workplace Violence Prevention', 'SAFETY', 'COMPLIANCE', 60, 80.00, 365, 'Recognizing and preventing workplace violence', 'Internal', 1.0, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP()),
('CRS062', 'Ergonomics and Injury Prevention', 'SAFETY', 'COMPLIANCE', 75, 80.00, 365, 'Preventing musculoskeletal injuries', 'Internal', 1.25, TRUE, CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 5: Generate Employees
-- ============================================================================
INSERT INTO EMPLOYEES
SELECT
    'EMP' || LPAD(SEQ4(), 10, '0') AS employee_id,
    o.organization_id,
    ARRAY_CONSTRUCT('John', 'Jane', 'Michael', 'Sarah', 'David', 'Emily', 'Robert', 'Lisa', 'James', 'Mary')[UNIFORM(0, 9, RANDOM())]
        || ' ' ||
    ARRAY_CONSTRUCT('Smith', 'Johnson', 'Williams', 'Brown', 'Jones', 'Garcia', 'Miller', 'Davis', 'Rodriguez', 'Martinez')[UNIFORM(0, 9, RANDOM())] AS employee_name,
    'employee' || SEQ4() || '@' || LOWER(REPLACE(o.organization_name, ' ', '')) || '.com' AS email,
    ARRAY_CONSTRUCT('Registered Nurse', 'Physician', 'Medical Assistant', 'Nurse Practitioner', 'Physical Therapist', 
                    'Respiratory Therapist', 'Radiologic Technologist', 'Laboratory Technician', 'Administrative Staff', 'Billing Specialist')[UNIFORM(0, 9, RANDOM())] AS job_title,
    ARRAY_CONSTRUCT('Emergency', 'Surgery', 'Cardiology', 'Pediatrics', 'Oncology', 'Administration', 'Laboratory', 'Radiology', 'Pharmacy', 'IT')[UNIFORM(0, 9, RANDOM())] AS department,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_DATE()) AS hire_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 92 THEN 'ACTIVE'
         WHEN UNIFORM(0, 100, RANDOM()) < 5 THEN 'LEAVE'
         ELSE 'TERMINATED' END AS employee_status,
    UNIFORM(0, 100, RANDOM()) < 60 AS requires_credentialing,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 85 THEN 'COMPLIANT'
         WHEN UNIFORM(0, 100, RANDOM()) < 10 THEN 'PENDING'
         ELSE 'NON_COMPLIANT' END AS compliance_status,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_DATE()) AS last_training_date,
    DATEADD('day', -1 * UNIFORM(30, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM ORGANIZATIONS o
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 10))
WHERE UNIFORM(0, 100, RANDOM()) < 20
LIMIT 500000;

-- ============================================================================
-- Step 6: Generate Subscriptions
-- ============================================================================
INSERT INTO SUBSCRIPTIONS
SELECT
    'SUB' || LPAD(SEQ4(), 10, '0') AS subscription_id,
    o.organization_id,
    ARRAY_CONSTRUCT('LEARNING', 'CREDENTIALING', 'COMPLIANCE', 'FULL_SUITE')[UNIFORM(0, 3, RANDOM())] AS service_type,
    ARRAY_CONSTRUCT('BASIC', 'PROFESSIONAL', 'ENTERPRISE')[UNIFORM(0, 2, RANDOM())] AS subscription_tier,
    o.signup_date AS start_date,
    DATEADD('year', 1, o.signup_date) AS end_date,
    ARRAY_CONSTRUCT('MONTHLY', 'ANNUAL')[UNIFORM(0, 1, RANDOM())] AS billing_cycle,
    (UNIFORM(299, 2999, RANDOM()) / 1.0)::NUMBER(10,2) AS monthly_price,
    UNIFORM(10, 500, RANDOM()) AS employee_licenses,
    ARRAY_CONSTRUCT('BASIC', 'STANDARD', 'PREMIUM', 'UNLIMITED')[UNIFORM(0, 3, RANDOM())] AS course_library_access,
    UNIFORM(0, 100, RANDOM()) < 60 AS advanced_reporting,
    CASE WHEN DATEADD('year', 1, o.signup_date) > CURRENT_DATE() THEN 'ACTIVE'
         ELSE ARRAY_CONSTRUCT('EXPIRED', 'PENDING_RENEWAL')[UNIFORM(0, 1, RANDOM())] END AS subscription_status,
    o.created_at AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM ORGANIZATIONS o
WHERE UNIFORM(0, 100, RANDOM()) < 90
LIMIT 75000;

-- ============================================================================
-- Step 7: Generate Marketing Campaigns
-- ============================================================================
INSERT INTO MARKETING_CAMPAIGNS VALUES
('CAMP001', 'Healthcare Compliance Made Easy', 'AWARENESS', '2024-01-01', '2024-12-31', 'HOSPITALS', 75000, 'DIGITAL', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP002', 'Credentialing Automation Promotion', 'PRODUCT_LAUNCH', '2024-03-01', '2024-06-30', 'LARGE_PRACTICES', 50000, 'EMAIL', 'COMPLETED', CURRENT_TIMESTAMP()),
('CAMP003', 'Annual Training Subscription Sale', 'SEASONAL', '2024-11-01', '2024-12-31', 'ALL_CUSTOMERS', 100000, 'MULTI_CHANNEL', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP004', 'JCAHO Accreditation Support', 'EDUCATION', '2024-02-01', '2024-12-31', 'HOSPITALS', 40000, 'WEBINAR', 'ACTIVE', CURRENT_TIMESTAMP()),
('CAMP005', 'New Customer Onboarding Program', 'ONBOARDING', '2024-01-01', '2024-12-31', 'NEW_CUSTOMERS', 30000, 'EMAIL', 'ACTIVE', CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 8: Generate Organization Campaign Interactions
-- ============================================================================
INSERT INTO ORGANIZATION_CAMPAIGN_INTERACTIONS
SELECT
    'INT' || LPAD(SEQ4(), 10, '0') AS interaction_id,
    o.organization_id,
    mc.campaign_id,
    DATEADD('day', UNIFORM(0, 300, RANDOM()), mc.start_date) AS interaction_date,
    ARRAY_CONSTRUCT('EMAIL_OPEN', 'CLICK', 'WEBINAR_ATTEND', 'DEMO_REQUEST', 'PURCHASE')[UNIFORM(0, 4, RANDOM())] AS interaction_type,
    UNIFORM(0, 100, RANDOM()) < 20 AS conversion_flag,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN (UNIFORM(3000, 50000, RANDOM()) / 1.0)::NUMBER(12,2) ELSE 0.00 END AS revenue_generated,
    DATEADD('day', UNIFORM(0, 300, RANDOM()), mc.start_date) AS created_at
FROM ORGANIZATIONS o
CROSS JOIN MARKETING_CAMPAIGNS mc
WHERE UNIFORM(0, 100, RANDOM()) < 3
LIMIT 30000;

-- ============================================================================
-- Step 9: Generate Transactions
-- ============================================================================
INSERT INTO TRANSACTIONS
SELECT
    'TXN' || LPAD(SEQ4(), 12, '0') AS transaction_id,
    o.organization_id,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS transaction_date,
    ARRAY_CONSTRUCT('SUBSCRIPTION_NEW', 'SUBSCRIPTION_RENEWAL', 'COURSE_PURCHASE', 'ADDON_SERVICE', 'SETUP_FEE')[UNIFORM(0, 4, RANDOM())] AS transaction_type,
    ARRAY_CONSTRUCT('LEARNING', 'CREDENTIALING', 'COMPLIANCE', 'FULL_SUITE')[UNIFORM(0, 3, RANDOM())] AS product_type,
    'PROD' || LPAD(UNIFORM(1, 32, RANDOM()), 3, '0') AS product_id,
    (UNIFORM(299, 2999, RANDOM()) / 1.0)::NUMBER(12,2) AS amount,
    'USD' AS currency,
    ARRAY_CONSTRUCT('CREDIT_CARD', 'ACH', 'WIRE_TRANSFER', 'CHECK')[UNIFORM(0, 3, RANDOM())] AS payment_method,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 97 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 2 THEN 'FAILED'
         ELSE 'REFUNDED' END AS payment_status,
    (UNIFORM(0, 500, RANDOM()) / 1.0)::NUMBER(10,2) AS discount_amount,
    (UNIFORM(0, 200, RANDOM()) / 1.0)::NUMBER(10,2) AS tax_amount,
    (UNIFORM(299, 2999, RANDOM()) / 1.0)::NUMBER(12,2) AS total_amount,
    DATEADD('day', -1 * UNIFORM(0, 1095, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM ORGANIZATIONS o
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 30))
WHERE UNIFORM(0, 100, RANDOM()) < 20
LIMIT 1500000;

-- ============================================================================
-- Step 10: Generate Course Enrollments
-- ============================================================================
INSERT INTO COURSE_ENROLLMENTS
SELECT
    'ENR' || LPAD(SEQ4(), 12, '0') AS enrollment_id,
    e.employee_id,
    c.course_id,
    e.organization_id,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS enrollment_date,
    DATEADD('day', UNIFORM(7, 90, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP())) AS due_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'COMPLETED'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'IN_PROGRESS'
         ELSE 'NOT_STARTED' END AS enrollment_status,
    'System Auto-Assign' AS assigned_by,
    UNIFORM(0, 100, RANDOM()) < 60 AS is_mandatory,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM EMPLOYEES e
CROSS JOIN COURSES c
WHERE UNIFORM(0, 100, RANDOM()) < 4
  AND e.employee_status = 'ACTIVE'
LIMIT 1000000;

-- ============================================================================
-- Step 11: Generate Course Completions
-- ============================================================================
INSERT INTO COURSE_COMPLETIONS
SELECT
    'CMP' || LPAD(SEQ4(), 12, '0') AS completion_id,
    en.enrollment_id,
    en.employee_id,
    en.course_id,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), en.enrollment_date) AS completion_date,
    (UNIFORM(70, 100, RANDOM()) / 1.0)::NUMBER(5,2) AS score,
    CASE WHEN (UNIFORM(70, 100, RANDOM()) / 1.0) >= 80 THEN 'PASS' ELSE 'FAIL' END AS pass_fail,
    UNIFORM(30, 300, RANDOM()) AS time_spent_minutes,
    CASE WHEN (UNIFORM(70, 100, RANDOM()) / 1.0) >= 80 THEN TRUE ELSE FALSE END AS certificate_issued,
    CASE WHEN (UNIFORM(70, 100, RANDOM()) / 1.0) >= 80 THEN 'CERT' || LPAD(SEQ4(), 10, '0') ELSE NULL END AS certificate_number,
    CASE WHEN (UNIFORM(70, 100, RANDOM()) / 1.0) >= 80 THEN DATEADD('day', 365, DATEADD('day', UNIFORM(1, 30, RANDOM()), en.enrollment_date)) ELSE NULL END AS expiration_date,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), en.enrollment_date) AS created_at
FROM COURSE_ENROLLMENTS en
WHERE en.enrollment_status = 'COMPLETED'
  AND UNIFORM(0, 100, RANDOM()) < 80
LIMIT 750000;

-- ============================================================================
-- Step 12: Generate Credentials
-- ============================================================================
INSERT INTO CREDENTIALS
SELECT
    'CRED' || LPAD(SEQ4(), 10, '0') AS credential_id,
    e.employee_id,
    e.organization_id,
    ARRAY_CONSTRUCT('MEDICAL_LICENSE', 'NURSING_LICENSE', 'DEA_CERTIFICATE', 'BOARD_CERTIFICATION', 'STATE_LICENSE')[UNIFORM(0, 4, RANDOM())] AS credential_type,
    ARRAY_CONSTRUCT('RN License', 'MD License', 'NP Certification', 'PA License', 'RT License', 'DEA Registration')[UNIFORM(0, 5, RANDOM())] AS credential_name,
    ARRAY_CONSTRUCT('State Medical Board', 'State Nursing Board', 'DEA', 'ABMS', 'Professional Board')[UNIFORM(0, 4, RANDOM())] AS issuing_authority,
    'LIC' || LPAD(UNIFORM(100000, 999999, RANDOM()), 10, '0') AS license_number,
    DATEADD('day', -1 * UNIFORM(365, 3650, RANDOM()), CURRENT_DATE()) AS issue_date,
    DATEADD('day', UNIFORM(365, 1825, RANDOM()), CURRENT_DATE()) AS expiration_date,
    CASE WHEN DATEADD('day', UNIFORM(365, 1825, RANDOM()), CURRENT_DATE()) > CURRENT_DATE() THEN 'ACTIVE'
         ELSE 'EXPIRED' END AS credential_status,
    TRUE AS verification_required,
    DATEADD('day', -1 * UNIFORM(365, 3650, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYEES e
WHERE e.requires_credentialing = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 35
LIMIT 100000;

-- ============================================================================
-- Step 13: Generate Credential Verifications
-- ============================================================================
INSERT INTO CREDENTIAL_VERIFICATIONS
SELECT
    'VER' || LPAD(SEQ4(), 10, '0') AS verification_id,
    cr.credential_id,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS verification_date,
    ARRAY_CONSTRUCT('PRIMARY_SOURCE', 'ONLINE_VERIFICATION', 'THIRD_PARTY', 'MANUAL_REVIEW')[UNIFORM(0, 3, RANDOM())] AS verification_method,
    ARRAY_CONSTRUCT('VERIFIED', 'PENDING', 'FAILED')[UNIFORM(0, 2, RANDOM())] AS verification_status,
    'Verification Team' AS verified_by,
    ARRAY_CONSTRUCT('State Board Database', 'NPDB', 'Professional Organization', 'Direct Contact')[UNIFORM(0, 3, RANDOM())] AS verification_source,
    'Verification completed successfully' AS notes,
    DATEADD('day', 180, DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP())) AS next_verification_date,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM CREDENTIALS cr
WHERE UNIFORM(0, 100, RANDOM()) < 80
LIMIT 150000;

-- ============================================================================
-- Step 14: Generate Exclusions Monitoring
-- ============================================================================
INSERT INTO EXCLUSIONS_MONITORING
SELECT
    'MON' || LPAD(SEQ4(), 10, '0') AS monitoring_id,
    e.employee_id,
    e.organization_id,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS monitoring_date,
    ARRAY_CONSTRUCT('OIG_LEIE', 'SAM', 'STATE_MEDICAID')[UNIFORM(0, 2, RANDOM())] AS database_checked,
    UNIFORM(0, 1000, RANDOM()) < 5 AS exclusion_found,
    CASE WHEN UNIFORM(0, 1000, RANDOM()) < 5 THEN 'Exclusion found - immediate action required' ELSE NULL END AS exclusion_details,
    CASE WHEN UNIFORM(0, 1000, RANDOM()) < 5 THEN 'ACTION_REQUIRED' ELSE 'CLEAR' END AS monitoring_status,
    DATEADD('day', 30, DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP())) AS next_check_date,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at
FROM EMPLOYEES e
WHERE e.requires_credentialing = TRUE
  AND UNIFORM(0, 100, RANDOM()) < 40
LIMIT 200000;

-- ============================================================================
-- Step 15: Generate Support Tickets
-- ============================================================================
INSERT INTO SUPPORT_TICKETS
SELECT
    'TIX' || LPAD(SEQ4(), 10, '0') AS ticket_id,
    o.organization_id,
    ARRAY_CONSTRUCT('Course Assignment Issue', 'Login Problem', 'Credential Verification Delay', 'Report Not Generating', 
                    'Billing Question', 'Employee Import Failed', 'Certificate Not Issued', 'System Performance',
                    'Integration Support', 'Feature Request')[UNIFORM(0, 9, RANDOM())] AS subject,
    ARRAY_CONSTRUCT('TECHNICAL', 'BILLING', 'ACCOUNT', 'TRAINING', 'CREDENTIALING', 'COMPLIANCE', 'INTEGRATION')[UNIFORM(0, 6, RANDOM())] AS issue_type,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'URGENT')[UNIFORM(0, 3, RANDOM())] AS priority,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 15 THEN 'IN_PROGRESS'
         ELSE 'OPEN' END AS ticket_status,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'CHAT', 'WEB_PORTAL')[UNIFORM(0, 3, RANDOM())] AS channel,
    'AGT' || LPAD(UNIFORM(1, 100, RANDOM()), 5, '0') AS assigned_agent_id,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_date,
    DATEADD('hour', UNIFORM(1, 4, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP())) AS first_response_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 
         THEN DATEADD('hour', UNIFORM(4, 48, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL END AS resolved_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 
         THEN DATEADD('hour', UNIFORM(4, 72, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL END AS closed_date,
    (UNIFORM(2, 48, RANDOM()) / 1.0)::NUMBER(10,2) AS resolution_time_hours,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 75 THEN UNIFORM(1, 5, RANDOM()) ELSE NULL END AS satisfaction_rating,
    DATEADD('day', -1 * UNIFORM(0, 365, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM ORGANIZATIONS o
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 2))
WHERE UNIFORM(0, 100, RANDOM()) < 25
LIMIT 75000;

-- ============================================================================
-- Step 16: Generate Incidents
-- ============================================================================
INSERT INTO INCIDENTS
SELECT
    'INC' || LPAD(SEQ4(), 10, '0') AS incident_id,
    e.organization_id,
    e.employee_id AS reported_by_employee_id,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS incident_date,
    ARRAY_CONSTRUCT('PATIENT_SAFETY', 'WORKPLACE_INJURY', 'MEDICATION_ERROR', 'HIPAA_BREACH', 'EQUIPMENT_FAILURE')[UNIFORM(0, 4, RANDOM())] AS incident_type,
    ARRAY_CONSTRUCT('CLINICAL', 'SAFETY', 'COMPLIANCE', 'OPERATIONAL', 'SECURITY')[UNIFORM(0, 4, RANDOM())] AS incident_category,
    ARRAY_CONSTRUCT('LOW', 'MEDIUM', 'HIGH', 'CRITICAL')[UNIFORM(0, 3, RANDOM())] AS severity,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'CLOSED'
         WHEN UNIFORM(0, 100, RANDOM()) < 20 THEN 'INVESTIGATING'
         ELSE 'OPEN' END AS incident_status,
    'Main Hospital - Floor ' || UNIFORM(1, 10, RANDOM())::VARCHAR AS location,
    'Incident reported and documented per protocol' AS description,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'COMPLETE' ELSE 'IN_PROGRESS' END AS investigation_status,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 
         THEN DATEADD('day', UNIFORM(1, 30, RANDOM()), DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()))
         ELSE NULL END AS resolved_date,
    CASE WHEN UNIFORM(0, 100, RANDOM()) < 70 THEN 'Incident resolved with corrective actions implemented' ELSE NULL END AS resolution_notes,
    DATEADD('day', -1 * UNIFORM(0, 730, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM EMPLOYEES e
WHERE e.employee_status = 'ACTIVE'
  AND UNIFORM(0, 100, RANDOM()) < 5
LIMIT 50000;

-- ============================================================================
-- Step 17: Generate Policies
-- ============================================================================
INSERT INTO POLICIES
SELECT
    'POL' || LPAD(SEQ4(), 8, '0') AS policy_id,
    o.organization_id,
    ARRAY_CONSTRUCT('Infection Control Policy', 'HIPAA Privacy Policy', 'Code of Conduct', 'Safety Protocols', 
                    'Emergency Response Plan', 'Medication Administration Policy', 'Patient Rights Policy')[UNIFORM(0, 6, RANDOM())] AS policy_name,
    ARRAY_CONSTRUCT('SAFETY', 'COMPLIANCE', 'CLINICAL', 'HR', 'OPERATIONS')[UNIFORM(0, 4, RANDOM())] AS policy_category,
    'v' || UNIFORM(1, 5, RANDOM())::VARCHAR || '.' || UNIFORM(0, 9, RANDOM())::VARCHAR AS policy_version,
    DATEADD('day', -1 * UNIFORM(180, 1825, RANDOM()), CURRENT_DATE()) AS effective_date,
    DATEADD('day', UNIFORM(365, 730, RANDOM()), CURRENT_DATE()) AS review_date,
    'ACTIVE' AS policy_status,
    TRUE AS requires_acknowledgment,
    'Compliance Officer' AS policy_owner,
    DATEADD('day', -1 * UNIFORM(180, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM ORGANIZATIONS o
CROSS JOIN TABLE(GENERATOR(ROWCOUNT => 1))
WHERE UNIFORM(0, 100, RANDOM()) < 15
LIMIT 10000;

-- ============================================================================
-- Step 18: Generate Policy Acknowledgments
-- ============================================================================
INSERT INTO POLICY_ACKNOWLEDGMENTS
SELECT
    'ACK' || LPAD(SEQ4(), 12, '0') AS acknowledgment_id,
    p.policy_id,
    e.employee_id,
    e.organization_id,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), p.effective_date) AS acknowledgment_date,
    ARRAY_CONSTRUCT('ELECTRONIC_SIGNATURE', 'WEB_PORTAL', 'MOBILE_APP')[UNIFORM(0, 2, RANDOM())] AS acknowledgment_method,
    UNIFORM(1, 255, RANDOM()) || '.' || UNIFORM(1, 255, RANDOM()) || '.' || UNIFORM(1, 255, RANDOM()) || '.' || UNIFORM(1, 255, RANDOM()) AS ip_address,
    DATEADD('day', UNIFORM(1, 30, RANDOM()), p.effective_date) AS created_at
FROM POLICIES p
JOIN EMPLOYEES e ON p.organization_id = e.organization_id
WHERE e.employee_status = 'ACTIVE'
  AND UNIFORM(0, 100, RANDOM()) < 70
LIMIT 300000;

-- ============================================================================
-- Step 19: Generate Accreditations
-- ============================================================================
INSERT INTO ACCREDITATIONS
SELECT
    'ACC' || LPAD(SEQ4(), 8, '0') AS accreditation_id,
    o.organization_id,
    ARRAY_CONSTRUCT('Joint Commission', 'NCQA', 'AAAHC', 'DNV', 'CARF')[UNIFORM(0, 4, RANDOM())] AS accreditation_body,
    ARRAY_CONSTRUCT('Hospital Accreditation', 'Primary Care Certification', 'Specialty Certification', 'Quality Recognition')[UNIFORM(0, 3, RANDOM())] AS accreditation_type,
    'ACC' || UNIFORM(100000, 999999, RANDOM())::VARCHAR AS accreditation_number,
    DATEADD('day', -1 * UNIFORM(365, 1825, RANDOM()), CURRENT_DATE()) AS issue_date,
    DATEADD('day', UNIFORM(730, 1095, RANDOM()), CURRENT_DATE()) AS expiration_date,
    CASE WHEN DATEADD('day', UNIFORM(730, 1095, RANDOM()), CURRENT_DATE()) > CURRENT_DATE() THEN 'ACTIVE'
         ELSE 'EXPIRED' END AS accreditation_status,
    DATEADD('day', UNIFORM(365, 730, RANDOM()), CURRENT_DATE()) AS next_review_date,
    DATEADD('day', -1 * UNIFORM(365, 1825, RANDOM()), CURRENT_TIMESTAMP()) AS created_at,
    CURRENT_TIMESTAMP() AS updated_at
FROM ORGANIZATIONS o
WHERE o.organization_type = 'HOSPITAL'
  AND UNIFORM(0, 100, RANDOM()) < 30
LIMIT 5000;

-- ============================================================================
-- Display summary statistics
-- ============================================================================
SELECT 'Data generation completed successfully' AS status;

SELECT 'ORGANIZATIONS' AS table_name, COUNT(*) AS row_count FROM ORGANIZATIONS
UNION ALL
SELECT 'EMPLOYEES', COUNT(*) FROM EMPLOYEES
UNION ALL
SELECT 'COURSES', COUNT(*) FROM COURSES
UNION ALL
SELECT 'SUBSCRIPTIONS', COUNT(*) FROM SUBSCRIPTIONS
UNION ALL
SELECT 'COURSE_ENROLLMENTS', COUNT(*) FROM COURSE_ENROLLMENTS
UNION ALL
SELECT 'COURSE_COMPLETIONS', COUNT(*) FROM COURSE_COMPLETIONS
UNION ALL
SELECT 'CREDENTIALS', COUNT(*) FROM CREDENTIALS
UNION ALL
SELECT 'CREDENTIAL_VERIFICATIONS', COUNT(*) FROM CREDENTIAL_VERIFICATIONS
UNION ALL
SELECT 'EXCLUSIONS_MONITORING', COUNT(*) FROM EXCLUSIONS_MONITORING
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM TRANSACTIONS
UNION ALL
SELECT 'SUPPORT_TICKETS', COUNT(*) FROM SUPPORT_TICKETS
UNION ALL
SELECT 'INCIDENTS', COUNT(*) FROM INCIDENTS
UNION ALL
SELECT 'POLICIES', COUNT(*) FROM POLICIES
UNION ALL
SELECT 'POLICY_ACKNOWLEDGMENTS', COUNT(*) FROM POLICY_ACKNOWLEDGMENTS
UNION ALL
SELECT 'ACCREDITATIONS', COUNT(*) FROM ACCREDITATIONS
UNION ALL
SELECT 'SUPPORT_AGENTS', COUNT(*) FROM SUPPORT_AGENTS
UNION ALL
SELECT 'PRODUCTS', COUNT(*) FROM PRODUCTS
UNION ALL
SELECT 'MARKETING_CAMPAIGNS', COUNT(*) FROM MARKETING_CAMPAIGNS
UNION ALL
SELECT 'ORGANIZATION_CAMPAIGN_INTERACTIONS', COUNT(*) FROM ORGANIZATION_CAMPAIGN_INTERACTIONS
ORDER BY table_name;

