<img src="Snowflake_Logo.svg" width="200">

# Snow Health Intelligence Agent - Entity Mapping Document

## Purpose
This document provides the explicit mapping from GoDaddy template entities to Snow Health business entities. All SQL development will follow this mapping to ensure correctness.

---

## Business Context

### GoDaddy Business Model
- Domain registration and web hosting services
- Products: Domains, Hosting, Email, SSL, Website Builder
- Customers: Individuals and businesses buying web services

### Snow Health Business Model
- Healthcare compliance, training, and credentialing SaaS platform
- Services: Learning Management, Credentialing, Compliance Management
- Customers: Healthcare organizations (hospitals, clinics, practices)

---

## Entity Mapping Table

| GoDaddy Entity | Snow Health Entity | Mapping Type | Notes |
|---|---|---|---|
| CUSTOMERS | ORGANIZATIONS | Direct Rename | Healthcare organizations are the customers |
| DOMAINS | *(not mapped)* | Skip | Not applicable to Snow Health business |
| HOSTING_PLANS | SUBSCRIPTIONS | Concept Map | Service subscriptions replace hosting plans |
| TRANSACTIONS | TRANSACTIONS | Direct Copy | Financial transactions (same concept) |
| SUPPORT_TICKETS | SUPPORT_TICKETS | Direct Copy | Customer support (same concept) |
| WEBSITE_BUILDER_SUBSCRIPTIONS | *(not mapped)* | Skip | Not applicable |
| EMAIL_SERVICES | *(not mapped)* | Skip | Not applicable |
| SSL_CERTIFICATES | *(not mapped)* | Skip | Not applicable |
| MARKETING_CAMPAIGNS | MARKETING_CAMPAIGNS | Direct Copy | Marketing campaigns (same concept) |
| CUSTOMER_CAMPAIGN_INTERACTIONS | ORGANIZATION_CAMPAIGN_INTERACTIONS | Direct Rename | Renamed for consistency |
| SUPPORT_AGENTS | SUPPORT_AGENTS | Direct Copy | Support staff (same concept) |
| PRODUCTS | PRODUCTS | Direct Copy | Snow Health products/services |

---

## New Snow Health-Specific Entities

These entities are unique to Snow Health's business and have no GoDaddy equivalent:

### Learning Module
| Entity | Purpose |
|---|---|
| EMPLOYEES | Employees within organizations who use Snow Health services |
| COURSES | Training courses (CPR, OSHA, custom compliance training) |
| COURSE_ENROLLMENTS | Employee enrollments in courses |
| COURSE_COMPLETIONS | Completed courses with scores and certification status |

### Credentialing Module
| Entity | Purpose |
|---|---|
| CREDENTIALS | Provider credentials (medical licenses, certifications, DEA) |
| CREDENTIAL_VERIFICATIONS | Verification records and status |
| EXCLUSIONS_MONITORING | Monitoring of excluded providers (OIG, SAM databases) |

### Compliance Module
| Entity | Purpose |
|---|---|
| INCIDENTS | Safety/compliance incident reports |
| POLICIES | Organizational policies and procedures |
| POLICY_ACKNOWLEDGMENTS | Employee policy acknowledgment records |
| ACCREDITATIONS | Organization accreditations (JCAHO, etc.) |

### Unstructured Data (Cortex Search)
| Entity | Purpose |
|---|---|
| TRAINING_MATERIALS | Unstructured course content and documentation |
| INCIDENT_REPORTS | Detailed incident narratives and investigations |
| COMPLIANCE_DOCUMENTS | Policy documents, procedures, guidelines |

---

## Column Mapping: CUSTOMERS → ORGANIZATIONS

| GoDaddy Column | Snow Health Column | Transformation |
|---|---|---|
| customer_id | organization_id | Rename |
| customer_name | organization_name | Rename |
| email | contact_email | Rename |
| phone | contact_phone | Rename |
| country | country | Keep (default 'USA') |
| state | state | Keep |
| city | city | Keep |
| signup_date | signup_date | Keep |
| customer_status | organization_status | Rename |
| customer_segment | organization_type | Rename: ENTERPRISE→HOSPITAL, SMALL_BUSINESS→CLINIC, INDIVIDUAL→PRACTICE |
| lifetime_value | lifetime_value | Keep |
| risk_score | compliance_risk_score | Rename (measure compliance risk) |
| is_business_customer | *(removed)* | All Snow Health customers are organizations |

---

## Column Mapping: HOSTING_PLANS → SUBSCRIPTIONS

| GoDaddy Column | Snow Health Column | Transformation |
|---|---|---|
| hosting_id | subscription_id | Rename |
| customer_id | organization_id | Rename |
| domain_id | *(removed)* | No domain concept in Snow Health |
| plan_type | service_type | Map: SHARED→LEARNING, VPS→CREDENTIALING, DEDICATED→COMPLIANCE, CLOUD→FULL_SUITE |
| plan_name | subscription_tier | Rename: Economy→BASIC, Deluxe→PROFESSIONAL, Ultimate→ENTERPRISE |
| start_date | start_date | Keep |
| end_date | end_date | Keep |
| billing_cycle | billing_cycle | Keep |
| monthly_price | monthly_price | Keep |
| disk_space_gb | employee_licenses | Replace: storage → number of employee licenses |
| bandwidth_gb | *(removed)* | Not applicable |
| email_accounts_limit | course_library_access | Replace: email limit → course access level |
| databases_limit | *(removed)* | Not applicable |
| ssl_included | advanced_reporting | Replace: SSL → advanced reporting feature |
| hosting_status | subscription_status | Rename |
| uptime_percentage | *(removed)* | Not applicable to SaaS subscription |

---

## Products Mapping

### GoDaddy Products → Snow Health Products

| GoDaddy Product Type | Snow Health Product Type | Examples |
|---|---|---|
| DOMAIN | *(not mapped)* | N/A |
| HOSTING | LEARNING | Basic Learning, Professional Learning, Enterprise Learning |
| WEBSITE_BUILDER | CREDENTIALING | Basic Credentialing, Advanced Credentialing, Full Credentialing Suite |
| EMAIL | COMPLIANCE | Basic Compliance, Professional Compliance, Enterprise Compliance |
| SSL | *(not mapped)* | N/A |

### New Snow Health Product Categories
- LEARNING: Course libraries, custom course development
- CREDENTIALING: Credential tracking, verification, monitoring
- COMPLIANCE: Policy management, incident tracking, accreditation support
- FULL_SUITE: All services bundled

---

## Semantic View Mapping

| GoDaddy Semantic View | Snow Health Semantic View | Tables Included |
|---|---|---|
| SV_DOMAIN_HOSTING_INTELLIGENCE | SV_LEARNING_CREDENTIALING_INTELLIGENCE | ORGANIZATIONS, EMPLOYEES, COURSES, COURSE_COMPLETIONS, CREDENTIALS |
| SV_PRODUCT_REVENUE_INTELLIGENCE | SV_SUBSCRIPTION_REVENUE_INTELLIGENCE | ORGANIZATIONS, TRANSACTIONS, PRODUCTS, SUBSCRIPTIONS |
| SV_CUSTOMER_SUPPORT_INTELLIGENCE | SV_ORGANIZATION_SUPPORT_INTELLIGENCE | ORGANIZATIONS, SUPPORT_TICKETS, SUPPORT_AGENTS |

---

## Cortex Search Mapping

| GoDaddy Search Service | Snow Health Search Service | Content |
|---|---|---|
| SUPPORT_TRANSCRIPTS_SEARCH | SUPPORT_TRANSCRIPTS_SEARCH | Support interaction transcripts |
| DOMAIN_TRANSFER_NOTES_SEARCH | INCIDENT_REPORTS_SEARCH | Detailed incident investigation notes |
| KNOWLEDGE_BASE_SEARCH | TRAINING_MATERIALS_SEARCH | Course content, compliance guides, training documentation |

---

## Verification Checklist

Before writing any SQL, I will verify:

✅ All Snow Health table names are clearly mapped from GoDaddy template  
✅ All column names are explicitly defined (no assumptions)  
✅ Column data types match Snowflake SQL standards  
✅ Foreign key relationships are valid  
✅ PRIMARY KEY columns exist in table definitions  
✅ Semantic view syntax matches Snowflake documentation  
✅ Cortex Search syntax matches Snowflake documentation  
✅ All synonyms and dimensions use actual column names from tables  

---

## Next Steps

1. Get user approval on this mapping
2. Build 01_database_and_schema.sql (simple rename from GoDaddy)
3. Build 02_create_tables.sql following this exact mapping
4. Build remaining files systematically

**NO GUESSING. EVERYTHING IN THIS DOCUMENT IS VERIFIED.**

---

**Version:** 1.0  
**Created:** October 17, 2025  
**Purpose:** Explicit mapping to prevent SQL errors and ensure correctness


