<img src="..\Snowflake_Logo.svg" width="200">

# Snow Health Intelligence Agent - Complex Questions

These 10 complex questions demonstrate the intelligence agent's ability to analyze Snow Health's training compliance, credentialing, subscriptions, revenue metrics, and support operations across multiple dimensions.

---

## 1. Training Compliance Risk Analysis

**Question:** "Analyze employees with overdue mandatory training. Show me the total count, breakdown by organization type (HOSPITAL, CLINIC, PRACTICE), employees with multiple overdue courses, and which job titles have the highest non-compliance rates. What is the potential compliance risk?"

**Why Complex:**
- Multi-table joins (EMPLOYEES, COURSE_ENROLLMENTS, ORGANIZATIONS)
- Filtering by mandatory status and due dates
- Multi-dimensional breakdown (org type, job title)
- Aggregation at multiple levels
- Risk assessment calculation

**Data Sources:** EMPLOYEES, COURSE_ENROLLMENTS, COURSES, ORGANIZATIONS

---

## 2. Credential Expiration Risk Tracking

**Question:** "Identify all provider credentials expiring in the next 90 days. Show me breakdown by credential type, organization, and verification status. Which organizations have the most at-risk credentials? Calculate the percentage of credentials that are unverified and expiring soon."

**Why Complex:**
- Time-based filtering (next 90 days)
- Multiple dimension analysis (type, org, status)
- Verification status cross-reference
- Risk prioritization by organization
- Percentage calculations

**Data Sources:** CREDENTIALS, CREDENTIAL_VERIFICATIONS, EMPLOYEES, ORGANIZATIONS

---

## 3. Exclusions Monitoring Alert Analysis

**Question:** "Analyze exclusions monitoring results. Show me total checks performed, number of exclusions found, breakdown by database type (OIG_LEIE, SAM, STATE_MEDICAID), organizations with exclusions, and employees requiring immediate action. What is the exclusion rate?"

**Why Complex:**
- Aggregation across monitoring records
- Multi-dimensional analysis
- Alert prioritization
- Rate calculations
- Organization risk assessment

**Data Sources:** EXCLUSIONS_MONITORING, EMPLOYEES, ORGANIZATIONS

---

## 4. Incident Pattern Analysis and Root Causes

**Question:** "Analyze incident reports over the past year. Show me breakdown by incident type, severity, and resolution speed. Which incident categories have the longest resolution times? Identify common patterns in medication errors and patient safety incidents. Compare incident rates across organization types."

**Why Complex:**
- Time-series analysis (past year)
- Multiple categorical breakdowns
- Resolution time analysis
- Pattern identification
- Comparative analysis across org types

**Data Sources:** INCIDENTS, ORGANIZATIONS

---

## 5. Subscription Health and Renewal Risk Assessment

**Question:** "Identify subscriptions at risk of non-renewal. Show me subscriptions expiring in next 30 days, breakdown by service type and tier, organizations with low course completion rates, and customers with recent support issues. Calculate churn risk score for each at-risk customer."

**Why Complex:**
- Time-based filtering (30 days)
- Multi-dimensional segmentation
- Cross-service analysis (subscriptions + training + support)
- Risk scoring calculation
- Churn prediction factors

**Data Sources:** SUBSCRIPTIONS, ORGANIZATIONS, COURSE_COMPLETIONS, SUPPORT_TICKETS

---

## 6. Revenue Trend Analysis with Product Performance

**Question:** "Analyze revenue trends over the past 12 months by product category (LEARNING, CREDENTIALING, COMPLIANCE, FULL_SUITE). Show me month-over-month growth rates, seasonal patterns, average transaction values, and which products show strongest growth. Compare revenue per organization type."

**Why Complex:**
- Time-series analysis (12 months)
- Growth rate calculations (MoM)
- Seasonal pattern detection
- Product-level breakdown
- Segmentation by customer type

**Data Sources:** TRANSACTIONS, PRODUCTS, ORGANIZATIONS

---

## 7. Course Effectiveness and Completion Analysis

**Question:** "Analyze course completion rates and effectiveness. Show me completion rates by course category, average scores, time spent per course, certificate issuance rates, and employees who failed courses multiple times. Which courses have lowest pass rates and why? Compare performance across different job titles."

**Why Complex:**
- Multiple metric calculations (rates, averages, counts)
- Performance analysis
- Failure pattern identification
- Comparative analysis across dimensions
- Root cause analysis

**Data Sources:** COURSES, COURSE_ENROLLMENTS, COURSE_COMPLETIONS, EMPLOYEES

---

## 8. Cross-Sell Opportunity Identification

**Question:** "Identify cross-sell opportunities. Show me organizations using only Learning services (no Credentialing or Compliance), organizations with credentialing needs (providers requiring licenses) but no credentialing subscription, and organizations with high incident counts but no compliance service. Calculate potential additional revenue for each opportunity."

**Why Complex:**
- Gap analysis across service portfolio
- Multi-dimensional opportunity identification
- Need assessment based on employee data
- Revenue opportunity calculation
- Prioritization by potential value

**Data Sources:** ORGANIZATIONS, SUBSCRIPTIONS, EMPLOYEES, CREDENTIALS, INCIDENTS

---

## 9. Support Efficiency and Agent Performance Benchmarking

**Question:** "Analyze support performance by agent and department. Show me average resolution times, ticket volumes, satisfaction ratings, first response times, and resolution rates. Identify top performers and agents needing additional training. How does performance vary by issue type and channel?"

**Why Complex:**
- Agent-level performance metrics
- Department-level aggregation
- Multiple quality metrics
- Performance ranking
- Multi-dimensional analysis (issue type, channel)

**Data Sources:** SUPPORT_TICKETS, SUPPORT_AGENTS

---

## 10. Policy Compliance and Acknowledgment Tracking

**Question:** "Analyze policy acknowledgment compliance across organizations. Show me policies with lowest acknowledgment rates, employees who have not acknowledged critical policies, time-to-acknowledge metrics, and organizations falling below 90% acknowledgment threshold. Which policy categories have compliance issues?"

**Why Complex:**
- Compliance rate calculations
- Time-based metrics
- Threshold-based filtering
- Policy category analysis
- Organization-level compliance assessment

**Data Sources:** POLICIES, POLICY_ACKNOWLEDGMENTS, EMPLOYEES, ORGANIZATIONS

---

## Cortex Search Questions (Unstructured Data)

These questions test the agent's ability to search and retrieve insights from unstructured data using Cortex Search services.

### 11. Support Issue Pattern Discovery

**Question:** "Search support transcripts for issues related to 'course assignment' and 'bulk enrollment'. What are the most common problems customers face? What resolution procedures were successful?"

**Why Complex:**
- Semantic search over support text
- Pattern extraction from conversations
- Success factor identification
- Resolution procedure analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 12. Incident Investigation Best Practices

**Question:** "Find incident reports about patient falls. What were the common root causes? What corrective actions were most effective? Identify best practices for fall prevention."

**Why Complex:**
- Semantic search over incident documentation
- Root cause extraction
- Effectiveness analysis
- Best practice identification

**Data Source:** INCIDENT_REPORTS_SEARCH

---

### 13. Training Content Retrieval

**Question:** "What does our training material say about proper hand hygiene technique? Provide step-by-step instructions."

**Why Complex:**
- Technical procedure retrieval
- Step-by-step instruction extraction
- Content synthesis from documentation

**Data Source:** TRAINING_MATERIALS_SEARCH

---

### 14. Credentialing Support Analysis

**Question:** "Search support transcripts for credential verification issues. What challenges do customers face? How does our team help them resolve verification delays?"

**Why Complex:**
- Issue pattern identification
- Challenge extraction
- Resolution strategy analysis

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 15. Medication Error Investigation

**Question:** "Find all incident reports involving medication errors. What were the contributing factors? What corrective actions were implemented? Are there recurring patterns?"

**Why Complex:**
- Multi-incident analysis
- Contributing factor extraction
- Corrective action identification
- Pattern recognition

**Data Source:** INCIDENT_REPORTS_SEARCH

---

### 16. HIPAA Compliance Guidance

**Question:** "What guidance does our training material provide about HIPAA privacy violations? What are the penalties and how can employees avoid violations?"

**Why Complex:**
- Compliance information retrieval
- Penalty information extraction
- Prevention guidance synthesis

**Data Source:** TRAINING_MATERIALS_SEARCH

---

### 17. Integration Support Patterns

**Question:** "Search support transcripts for API integration issues. What error messages are most common? How does our support team troubleshoot these problems?"

**Why Complex:**
- Technical issue identification
- Error pattern analysis
- Troubleshooting procedure extraction

**Data Source:** SUPPORT_TRANSCRIPTS_SEARCH

---

### 18. Workplace Injury Prevention

**Question:** "Find incident reports about needlestick injuries and workplace injuries. What safety protocols were violated? What training was recommended as corrective action?"

**Why Complex:**
- Safety incident analysis
- Protocol violation identification
- Training recommendation extraction

**Data Source:** INCIDENT_REPORTS_SEARCH

---

### 19. Infection Control Procedures

**Question:** "What procedures does our training material outline for transmission-based precautions? Specifically, what are the requirements for contact, droplet, and airborne precautions?"

**Why Complex:**
- Multi-topic procedure retrieval
- Requirement extraction by category
- Detailed procedure synthesis

**Data Source:** TRAINING_MATERIALS_SEARCH

---

### 20. Comprehensive Knowledge Synthesis

**Question:** "For a new hospital implementing Snow Health, combine information from: 1) Training materials about setting up courses, 2) Support transcripts showing successful onboarding, and 3) Best practices from organizations with high compliance rates."

**Why Complex:**
- Multi-source information synthesis
- Step-by-step procedure combination
- Best practice integration
- Comprehensive solution assembly

**Data Sources:** TRAINING_MATERIALS_SEARCH, SUPPORT_TRANSCRIPTS_SEARCH, SV_LEARNING_CREDENTIALING_INTELLIGENCE

---

## Question Complexity Summary

These questions test the agent's ability to:

1. **Multi-table joins** - connecting organizations, employees, courses, credentials, subscriptions, support
2. **Temporal analysis** - expiration tracking, trend analysis, time-to-acknowledge
3. **Segmentation & classification** - organization types, job titles, service types
4. **Derived metrics** - rates, percentages, ratios, growth calculations
5. **Risk assessment** - compliance risk, churn risk, credential expiration risk
6. **Pattern recognition** - incident patterns, support issues, training gaps
7. **Comparative analysis** - benchmarking, performance comparison, rankings
8. **Opportunity identification** - cross-sell, at-risk customers, training needs
9. **Aggregation at multiple levels** - employee, organization, course, product
10. **Quality metrics** - satisfaction ratings, completion rates, resolution times
11. **Semantic search** - understanding intent in unstructured data
12. **Information synthesis** - combining insights from multiple sources

These questions reflect realistic business intelligence needs for Snow Health's learning management, credentialing, and compliance operations.

---

**Version:** 1.0  
**Created:** October 2025  
**Based on:** GoDaddy Intelligence Template

