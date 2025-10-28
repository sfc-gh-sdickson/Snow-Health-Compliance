-- ============================================================================
-- Snow Health Intelligence Agent - Cortex Search Service Setup
-- ============================================================================
-- Purpose: Create unstructured data tables and Cortex Search services for
--          support transcripts, incident reports, and training materials
-- Syntax verified against: https://docs.snowflake.com/en/sql-reference/sql/create-cortex-search
-- ============================================================================

USE DATABASE SNOW_HEALTH_INTELLIGENCE;
USE SCHEMA RAW;
USE WAREHOUSE SNOW_HEALTH_WH;

-- ============================================================================
-- Step 1: Create table for support transcripts (unstructured text data)
-- ============================================================================
CREATE OR REPLACE TABLE SUPPORT_TRANSCRIPTS (
    transcript_id VARCHAR(30) PRIMARY KEY,
    ticket_id VARCHAR(30),
    organization_id VARCHAR(20),
    agent_id VARCHAR(20),
    transcript_text VARCHAR(16777216) NOT NULL,
    interaction_type VARCHAR(50),
    interaction_date TIMESTAMP_NTZ NOT NULL,
    sentiment_score NUMBER(5,2),
    keywords VARCHAR(500),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (ticket_id) REFERENCES SUPPORT_TICKETS(ticket_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id),
    FOREIGN KEY (agent_id) REFERENCES SUPPORT_AGENTS(agent_id)
);

-- ============================================================================
-- Step 2: Create table for incident reports
-- ============================================================================
CREATE OR REPLACE TABLE INCIDENT_REPORTS (
    report_id VARCHAR(30) PRIMARY KEY,
    incident_id VARCHAR(30),
    organization_id VARCHAR(20),
    report_text VARCHAR(16777216) NOT NULL,
    report_type VARCHAR(50),
    investigation_status VARCHAR(30),
    corrective_actions_taken VARCHAR(5000),
    report_date TIMESTAMP_NTZ NOT NULL,
    created_by VARCHAR(100),
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    FOREIGN KEY (incident_id) REFERENCES INCIDENTS(incident_id),
    FOREIGN KEY (organization_id) REFERENCES ORGANIZATIONS(organization_id)
);

-- ============================================================================
-- Step 3: Create table for training materials
-- ============================================================================
CREATE OR REPLACE TABLE TRAINING_MATERIALS (
    material_id VARCHAR(30) PRIMARY KEY,
    title VARCHAR(500) NOT NULL,
    content VARCHAR(16777216) NOT NULL,
    material_category VARCHAR(50),
    course_category VARCHAR(50),
    tags VARCHAR(500),
    author VARCHAR(100),
    last_updated TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP(),
    view_count NUMBER(10,0) DEFAULT 0,
    helpfulness_score NUMBER(3,2),
    is_published BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()
);

-- ============================================================================
-- Step 4: Enable change tracking (required for Cortex Search)
-- ============================================================================
ALTER TABLE SUPPORT_TRANSCRIPTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE INCIDENT_REPORTS SET CHANGE_TRACKING = TRUE;
ALTER TABLE TRAINING_MATERIALS SET CHANGE_TRACKING = TRUE;

-- ============================================================================
-- Step 5: Generate sample support transcripts
-- ============================================================================
INSERT INTO SUPPORT_TRANSCRIPTS
SELECT
    'TRANS' || LPAD(SEQ4(), 10, '0') AS transcript_id,
    st.ticket_id,
    st.organization_id,
    st.assigned_agent_id AS agent_id,
    CASE (ABS(RANDOM()) % 20)
        WHEN 0 THEN 'Agent: Thank you for contacting Snow Health support. How can I help you today? Customer: Hi, I need help assigning a course to multiple employees at once. Agent: I can walk you through our bulk enrollment feature. Are you in your admin dashboard? Customer: Yes, I am logged in. Agent: Great! Click on Learning Management, then Bulk Enrollment. You can upload a CSV file or select employees from your list. Customer: I see the option now. Can I assign different courses to different groups? Agent: Yes, you can create assignment rules based on department, job title, or location. Would you like me to send you our bulk enrollment guide? Customer: That would be helpful, thank you! Agent: Sent to your email. Let me know if you need any clarification. Customer: This is perfect, thanks!'
        WHEN 1 THEN 'Customer: Our employees are not receiving course completion certificates! This is urgent! Agent: I am sorry to hear that. Let me check your certificate settings immediately. What course are employees completing? Customer: The HIPAA Privacy Fundamentals course. Agent: Thank you. I am pulling up your organization settings now. I can see your certificate template is active. Are employees passing the course with 80% or higher? Customer: Yes, they are all passing. Agent: I found the issue - your certificate email delivery was paused due to a temporary SMTP issue last week. I am re-enabling it now and will manually trigger certificates for the 15 affected employees. Customer: How long will that take? Agent: Certificates are generating now. Employees should receive them within 5 minutes. I am also giving you a credit for this service disruption. Customer: Thank you for the quick resolution!'
        WHEN 2 THEN 'Chat started. Agent: Hello! Welcome to Snow Health support. Customer: Hi, I need to verify provider credentials for new hires. How do I set that up? Agent: I can help you with that. Do you have our Credentialing service active? Customer: Yes, we just purchased the Advanced Credentialing package. Agent: Perfect! Go to Credentialing Dashboard, then Add Provider. Enter their license information and we will automatically verify against primary sources. Customer: What databases do you check? Agent: We verify against State Medical Boards, NPDB, OIG LEIE, SAM, and other primary sources depending on the credential type. Customer: How long does verification take? Agent: Initial verification typically completes within 24-48 hours. You will receive email notification when complete. Customer: Excellent, thank you!'
        WHEN 3 THEN 'Agent: Snow Health Technical Support, this is Mike. How can I assist? Customer: We are trying to integrate Snow Health with our HRIS system but the API is returning errors. Agent: I can help troubleshoot that. What error message are you receiving? Customer: Error 401 - Unauthorized. Agent: That is an authentication issue. Have you generated your API key in Organization Settings? Customer: I thought we did, but maybe it expired? Agent: API keys do not expire, but they can be regenerated. Let me walk you through checking it. Log into your admin account and go to Settings, then API Configuration. Customer: I see it. Should I regenerate the key? Agent: Yes, click Regenerate API Key. Make sure to copy it immediately as it only displays once. Customer: Got it. Should I update this in our HRIS system now? Agent: Yes, update the authentication header in your integration. Test with a simple GET request first. Customer: Testing now... It worked! Thank you! Agent: Great! Let me know if you need help with any specific API endpoints.'
        WHEN 4 THEN 'Email Support Thread. Customer: We were charged twice for our subscription renewal. Can you refund one charge? Agent: I apologize for the duplicate charge. Let me review your account. I can see two charges on [date] for $899 each for your Learning subscription. Customer: Yes, that is correct. Agent: I am processing a refund for the duplicate charge right now. You should see it back in your account within 5-7 business days. Customer: Will this affect our subscription status? Agent: Not at all. Your subscription is properly renewed through [date]. The refund is only for the duplicate charge. I have also added a note to prevent this from happening again. Customer: I appreciate your help. Is there anything else I need to do? Agent: Nothing on your end. I have sent you a confirmation email with the refund details. If you do not see the credit within 7 days, please contact us back. Customer: Thank you!'
        WHEN 5 THEN 'Agent: Thank you for calling Snow Health. Customer: Hi, I want to upgrade our subscription to include credentialing services. Agent: Great! I can help you with that. What subscription do you currently have? Customer: We have the Professional Learning Package. Agent: And you want to add our Credentialing service? What size organization are you? Customer: We have about 85 employees, including 30 providers who need credential tracking. Agent: I recommend our Advanced Credentialing Service which supports up to 100 providers. It includes verification, exclusions monitoring, and expiration tracking. Customer: That sounds perfect. What is the additional cost? Agent: It is $799 per month added to your current subscription. I can process the upgrade now and it will be prorated for this month. Customer: Let us do it. Agent: Processing now... Your upgrade is complete! You will see the Credentialing Dashboard in your account within 5 minutes. I am also sending you our credentialing setup guide. Customer: Thank you!'
        WHEN 6 THEN 'Customer: I need help running a compliance report for our JCAHO accreditation survey. Agent: I can walk you through that. Do you have Advanced Reporting enabled? Customer: Yes, we have the Enterprise Compliance Platform. Agent: Perfect! Go to Reports, then Compliance Reports. You will see our JCAHO Readiness Report template. Customer: I found it. What does this report include? Agent: It shows training completion rates, policy acknowledgment status, incident reports, credential status, and identified gaps. You can customize the date range and departments. Customer: Can I export this? Agent: Yes! Once you generate the report, click Export. You can get it as PDF for surveyors or Excel for further analysis. Customer: This is exactly what we need. One more question - can I schedule this to run monthly? Agent: Absolutely! After generating, click Schedule Report. You can set it to run monthly and email to your compliance team. Customer: Perfect, setting that up now. Thank you! Agent: You are welcome! Good luck with your accreditation survey!'
        WHEN 7 THEN 'Agent: Snow Health Credentialing Support. Customer: We received an alert that one of our providers has an expiring license! Agent: I can help you check that. What is the provider name? Customer: Dr. Sarah Johnson. Agent: Let me pull up her credential file... I see her DEA registration expires in 45 days on [date]. Customer: Is that automatically monitored? Agent: Yes, our system sends alerts at 90, 60, 45, and 30 days before expiration. Have you received the renewal documentation from Dr. Johnson? Customer: Not yet. What should we do? Agent: I recommend contacting Dr. Johnson today to initiate the renewal process. Once she provides the new documentation, upload it to her profile and we will verify it. Customer: Can we track renewal status in the system? Agent: Yes! In her credential profile, you will see a Renewal Status field. You can update it to In Progress, then Renewed once complete. Customer: Great. We will handle that today. Thanks for the alert! Agent: You are welcome! Let me know if you need help with the verification process.'
        WHEN 8 THEN 'Chat. Customer: Our compliance officer is out sick and we need to respond to a policy update request today! Agent: I can help guide you through that. What policy needs to be updated? Customer: Our Infection Control Policy. We need to add new COVID protocols. Agent: Go to Compliance Management, then Policies. Find your Infection Control Policy and click Edit. Customer: Okay, I am in the editor now. Agent: Make your content changes, then update the version number at the top. Customer: Do I need to republish this? Agent: Yes, after saving changes, click Publish. This will create a new version and notify affected employees. Customer: Will they need to acknowledge the updated policy? Agent: Yes, if you have acknowledgment enabled. Employees will receive notification and must acknowledge within your configured timeframe. Customer: Perfect. Publishing now... Done! How do I track who has acknowledged it? Agent: Go back to Policies, click on your Infection Control Policy, then View Acknowledgments. You will see a real-time status dashboard. Customer: This is great. Thank you so much! Agent: You are welcome! Hope your compliance officer feels better soon.'
        WHEN 9 THEN 'Agent: Thank you for contacting Snow Health billing support. Customer: I want to cancel our credentialing service. We are moving to another vendor. Agent: I am sorry to hear you are leaving. May I ask why you are switching? Customer: The other vendor offered a lower price. Agent: I understand. Before you cancel, let me see if I can offer you a retention discount. How much time is left on your contract? Customer: 6 months. Agent: I can offer you 25% off your credentialing service for the next year if you stay with us. That would bring your monthly cost to $599 instead of $799. Customer: That is actually competitive with the other quote we got. Agent: Plus you would avoid the hassle of migrating all your credential data and re-verifying everything. Customer: That is a good point. How do I accept this offer? Agent: I am applying the discount to your account right now. You will see the reduced rate on your next invoice. Customer: Okay, we will stay. Thanks for working with us on this. Agent: Thank you for staying with Snow Health! Let me know if there is anything else we can do to improve your experience.'
        WHEN 10 THEN 'Customer inquiry via email: I enrolled 50 employees in a course yesterday but now I need to unenroll 10 of them who took it last year. How do I do that? Agent response: Thank you for contacting us! To unenroll employees from a course, go to Learning Management > Enrollments. Use the filter to find the specific course enrollment. Select the 10 employees you want to unenroll and click the Unenroll button. Their enrollment will be cancelled and they will not receive any notifications. Customer reply: Will this affect their completion records from last year? Agent: No, historical completion records are permanently retained in their training transcript. The unenrollment only cancels the current enrollment. Customer: Perfect, thank you!'
        WHEN 11 THEN 'Phone support. Agent: Snow Health Learning Support, how may I help you? Customer: I created a custom course but employees say they cannot access it. Agent: Let me help you troubleshoot that. When did you create the course? Customer: This morning, about 2 hours ago. Agent: And have you published the course? Customer: I thought I did. Let me check... Oh, it says Draft status. Agent: That is the issue! Draft courses are only visible to administrators. Click on your course, then click Publish in the top right. Customer: I see it. Do I need to assign it to employees first? Agent: You can assign before or after publishing. Once published, assigned employees will be able to access it immediately. Customer: Publishing now... Done! I will assign it to my team. Agent: Perfect! Let me know if they have any issues accessing it. Customer: They can see it now. Thanks! Agent: Great! If you need help with course content or assessments, we have video tutorials in your Help section.'
        WHEN 12 THEN 'Agent: Welcome to Snow Health chat support! Customer: I want to track continuing education credits for our nurses. Can Snow Health do that? Agent: Absolutely! Our system automatically tracks CE credits for completed courses. Are you looking to track external CE credits as well? Customer: Yes, nurses often attend conferences and external training. Agent: You can manually add external CE credits to employee profiles. Go to their training transcript and click Add External Training. Customer: What information do I need to enter? Agent: Course name, provider, completion date, and credit hours. You can also upload certificates as attachments. Customer: Can employees submit their own external training? Agent: Yes! If you enable self-service in your settings, employees can submit external training for approval. You would then review and approve them. Customer: That would save us a lot of time. How do I enable that? Agent: Go to Organization Settings > Learning Management > Employee Self-Service and toggle on External Training Submissions. Customer: Done! This is going to help our nurses stay organized. Thank you!'
        WHEN 13 THEN 'Customer: We need to run background checks on new hires. Does Snow Health do that? Agent: Snow Health does not directly perform background checks, but we do offer exclusions monitoring which checks federal databases. What type of background screening are you looking for? Customer: OIG and SAM database checks. Agent: Perfect! That is included in our Credentialing service. We automatically check OIG LEIE and SAM databases monthly for all your providers. Customer: What happens if someone is found on those lists? Agent: You receive an immediate alert via email and in your dashboard. The provider profile is flagged and you can take appropriate action. Customer: Can we check someone before hiring? Agent: Yes! You can add a pending provider to the system and run an initial exclusions check before their start date. Customer: Great. Is there a per-check fee? Agent: No, exclusions monitoring is unlimited for all providers in your credentialing subscription. Customer: Perfect. We will use this for all new clinical hires. Thank you!'
        WHEN 14 THEN 'Email support. Customer: I accidentally deleted an important incident report. Can you restore it? Agent: I understand your concern. Let me check our backup system. When did you delete the report? Customer: About 30 minutes ago. Agent: Great! We keep deleted items for 30 days in a recycle bin. Log into your account, go to Compliance Management, and look for the Recycle Bin link at the bottom of the page. Customer: I found it! I can see the deleted report. Agent: Click on it and then click Restore. It will go back to its original location in your incident reports. Customer: It is back! Thank you so much! Agent: You are welcome! Pro tip: You can permanently delete items from the recycle bin if needed, or they auto-delete after 30 days. Customer: Good to know. Thanks again!'
        WHEN 15 THEN 'Agent: Snow Health Integration Support. Customer: We use ADP for payroll. Can Snow Health sync employee data automatically? Agent: Yes! We have a pre-built integration with ADP. Do you have our Integration module? Customer: I am not sure. How do I check? Agent: Go to Organization Settings and look for Integrations. If you see it, you have access. If not, I can help you add it to your subscription. Customer: I see it! There is an ADP connector option. Agent: Perfect! Click on ADP, then Connect. You will need your ADP API credentials. Customer: Where do I get those? Agent: You will need to generate them in your ADP account. I can send you our step-by-step ADP integration guide that walks through the credential generation. Customer: Please send that. Agent: Sent! Once you have your credentials, the integration takes about 5 minutes to set up. Customer: What data gets synced? Agent: Employee demographics, job titles, departments, and termination dates. New employees auto-sync daily and you can manually assign training based on their role. Customer: This will save us hours of manual data entry. Thanks! Agent: You are welcome! Let me know if you hit any issues during setup.'
        WHEN 16 THEN 'Customer: How do I add custom fields to track additional credential information? Agent: Great question! Go to Credentialing Settings, then Custom Fields. You can add text fields, dates, dropdowns, or file uploads. Customer: I need to track DEA expiration dates separately from licenses. Agent: You can create a custom date field called DEA Expiration. Do you want the system to send expiration alerts for it? Customer: Yes! Can it do that? Agent: Absolutely! When creating the custom field, enable expiration tracking. You can set alert thresholds just like standard credentials. Customer: Where do I enter the data for each provider? Agent: Once you create the custom field, it will appear in every provider profile under the Credentials section. Customer: Perfect. Can I run reports on custom fields? Agent: Yes, custom fields are included in all credentialing reports and you can filter by them. Customer: This is exactly what we needed. Setting it up now. Thanks! Agent: You are welcome! Let me know if you need help with anything else.'
        WHEN 17 THEN 'Chat support. Customer: I forgot my password and the reset email is not coming through. Agent: I can help you with that. Have you checked your spam folder? Customer: Yes, nothing there. Agent: Let me check your account settings... I see your email address is outdated. Did you recently change your work email? Customer: Oh yes! I changed it last month but did not update it in Snow Health. Agent: That is why the reset email is not reaching you. I can update your email address. What is your new email? Customer: It is sarah.jones@newemail-hospital.com Agent: Updated! Now try the password reset again. You should receive it at your new email within 1 minute. Customer: Got it! Resetting now... All set. Thank you! Agent: Great! For security, I recommend enabling two-factor authentication in your profile settings. Customer: I will do that. Thanks for the suggestion! Agent: You are welcome!'
        WHEN 18 THEN 'Agent: Snow Health compliance support. Customer: We need to prepare for an OSHA inspection next week. What reports should we run? Agent: I can help you get ready! You will want several key reports. First, run the Training Compliance Report filtered for OSHA courses. Customer: What else? Agent: Pull the Incident Reports summary for the past year, Policy Acknowledgment status, and Employee Training Transcripts for your safety team. Customer: Can I bundle all these reports together? Agent: Yes! Use our Inspection Readiness package in the Reports section. It generates all required OSHA documentation in one bundle. Customer: Where do I find that? Agent: Go to Reports > Regulatory Compliance > OSHA Inspection Readiness. Customer: Found it! This includes everything? Agent: Yes, plus corrective action tracking and hazard assessment records. You can export as a single PDF or individual files. Customer: Running it now... This is comprehensive! Thank you so much! Agent: You are welcome! Good luck with your inspection. Feel free to reach out if you need anything else.'
        WHEN 19 THEN 'Customer: Can employees access training courses from their mobile phones? Agent: Yes! We have a fully responsive mobile interface and also native mobile apps for iOS and Android. Customer: Do they need to download an app? Agent: The mobile website works great in any browser, but the app provides offline course access which is helpful for field staff. Customer: How do they download the app? Agent: Search for Snow Health in the App Store or Google Play. They log in with their same credentials. Customer: Can they complete courses offline? Agent: Yes, with the app! They can download courses, complete them offline, and results sync when they reconnect. Customer: That is perfect for our EMS staff. Do all course types work offline? Agent: Most do, except courses with video streaming or live assessments. Those require internet connection. Customer: Understood. I will let our team know. Thanks! Agent: You are welcome! The app also sends push notifications for new assignments and expiring credentials.'
    END AS transcript_text,
    ARRAY_CONSTRUCT('PHONE', 'EMAIL', 'CHAT')[UNIFORM(0, 2, RANDOM())] AS interaction_type,
    st.created_date AS interaction_date,
    (UNIFORM(-50, 100, RANDOM()) / 1.0)::NUMBER(5,2) AS sentiment_score,
    CASE (ABS(RANDOM()) % 5)
        WHEN 0 THEN 'course,assignment,enrollment'
        WHEN 1 THEN 'credential,verification,license'
        WHEN 2 THEN 'compliance,policy,reporting'
        WHEN 3 THEN 'technical,integration,api'
        WHEN 4 THEN 'billing,subscription,payment'
    END AS keywords,
    st.created_date AS created_at
FROM RAW.SUPPORT_TICKETS st
WHERE st.ticket_id IS NOT NULL
LIMIT 25000;

-- ============================================================================
-- Step 6: Generate sample incident reports
-- ============================================================================
INSERT INTO INCIDENT_REPORTS
SELECT
    'RPT' || LPAD(SEQ4(), 10, '0') AS report_id,
    i.incident_id,
    i.organization_id,
    CASE (ABS(RANDOM()) % 15)
        WHEN 0 THEN 'INCIDENT REPORT: Patient Fall in Room 412. Date: ' || i.incident_date::VARCHAR || '. Description: Patient attempted to get out of bed without assistance despite call light instructions. Patient slipped and fell, sustaining minor bruising to left hip. Staff responded immediately. Vitals stable. Physician notified. Family contacted. Investigation: Bed alarm was not activated. Nurse was responding to another patient emergency. Root Cause: Inadequate fall prevention protocol adherence. Corrective Actions: Mandatory fall prevention refresher training for all nursing staff. Bed alarm protocols reinforced. Additional bed checks implemented during shift changes.'
        WHEN 1 THEN 'MEDICATION ERROR REPORT: Wrong dose administered. Date: ' || i.incident_date::VARCHAR || '. Description: Patient received 20mg of medication when prescribed dose was 10mg. Error discovered during next medication round. Physician immediately notified. Patient monitored for adverse effects. No complications observed. Investigation: Pharmacist prepared correct dose but nurse misread label. Contributing factors: High patient volume, staffing shortage, poor lighting in medication room. Corrective Actions: Enhanced barcode scanning implementation. Medication administration training module developed. Improved lighting in medication preparation areas.'
        WHEN 2 THEN 'HIPAA BREACH INCIDENT: Unauthorized PHI disclosure. Date: ' || i.incident_date::VARCHAR || '. Description: Employee accidentally emailed patient lab results to wrong patient. Breach discovered when recipient called to report error. Both patients notified per HIPAA requirements. OCR notification filed. Investigation: Email auto-complete feature selected wrong recipient with similar name. Employee was rushing due to end-of-shift workload. Corrective Actions: Email verification protocols implemented. Mandatory HIPAA training refresher scheduled. Patient identity verification procedures strengthened. Auto-complete feature disabled for PHI communications.'
        WHEN 3 THEN 'WORKPLACE INJURY: Needlestick incident. Date: ' || i.incident_date::VARCHAR || '. Description: Nurse sustained needlestick injury while disposing of used needle. Immediate first aid applied. Employee health consulted. Baseline labs drawn. Source patient tested (consent obtained). Post-exposure prophylaxis initiated per protocol. Investigation: Sharps container was overfilled. Employee was distracted during disposal. Root cause: Inadequate sharps container replacement schedule. Corrective Actions: Sharps container monitoring improved. Visual fill-line indicators added. Staff training on safe needle disposal reinforced.'
        WHEN 4 THEN 'EQUIPMENT FAILURE: Ventilator malfunction. Date: ' || i.incident_date::VARCHAR || '. Description: Ventilator alarm indicated pressure sensor failure during patient care. Backup ventilator immediately deployed. Patient stable throughout transition. Biomedical engineering notified. Failed unit removed from service. Investigation: Equipment passed last maintenance check 3 months ago. Internal sensor component failure. Manufacturer notified. Corrective Actions: Ventilator maintenance schedule reduced to monthly. Backup equipment positioning optimized. Emergency equipment response protocol tested and confirmed effective.'
        WHEN 5 THEN 'PATIENT IDENTIFICATION ERROR: Wrong patient nearly received procedure. Date: ' || i.incident_date::VARCHAR || '. Description: Two patients with same last name scheduled for procedures in adjacent rooms. Staff nearly performed procedure on wrong patient. Error caught during final verification using two patient identifiers. No harm to either patient. Investigation: Reliance on room number instead of patient identifiers. Workflow shortcuts during high-volume day. Corrective Actions: Enhanced patient identification protocols. Mandatory two-identifier verification at every step. Electronic verification system implemented. Team huddle procedures reinforced.'
        WHEN 6 THEN 'SECURITY INCIDENT: Unauthorized access to restricted area. Date: ' || i.incident_date::VARCHAR || '. Description: Visitor found in medication storage area. Security responded within 2 minutes. Visitor claimed to be lost looking for restroom. All medications accounted for. No theft occurred. Investigation: Door to medication room left propped open by staff for convenience during restocking. Badge access logs reviewed. Corrective Actions: Automatic door-close mechanisms installed. Staff reminded of security protocols. Visitor escort policy reinforced. Additional signage added.'
        WHEN 7 THEN 'ADVERSE DRUG REACTION: Allergic reaction to antibiotic. Date: ' || i.incident_date::VARCHAR || '. Description: Patient developed rash and respiratory difficulty 30 minutes after receiving antibiotic. Rapid response team activated. Antihistamine and steroids administered. Patient stabilized. Physician notified. Allergy added to patient record. Investigation: Patient reported no known drug allergies during admission screening. Previous exposure to medication was tolerated. This was first documented allergic reaction. Corrective Actions: Enhanced allergy screening protocols. Electronic allergy alerts verified functional. Documentation procedures reviewed with admissions staff.'
        WHEN 8 THEN 'ELOPEMENT INCIDENT: Patient left facility against medical advice. Date: ' || i.incident_date::VARCHAR || '. Description: Patient on psychiatric hold left unit during shift change. Exit doors alarmed but patient bypassed through emergency exit during fire alarm test. Patient found 2 hours later unharmed. Returned to facility voluntarily. Investigation: Communication breakdown during shift change. Fire alarm test not coordinated with security. Exit monitoring lapsed during drill. Corrective Actions: Elopement risk assessment enhanced. Alarm system upgraded. Shift change protocols revised. Security notification procedures for drills implemented.'
        WHEN 9 THEN 'INFECTION CONTROL BREACH: Improper PPE use observed. Date: ' || i.incident_date::VARCHAR || '. Description: Staff member observed entering isolation room without proper gown and gloves. Infection control immediately notified. Staff member removed from unit. No patient contamination occurred. Investigation: New staff member inadequately trained on isolation precautions. Signage at room entrance unclear. Supervisor oversight insufficient. Corrective Actions: Isolation precautions training made mandatory before unit assignment. Enhanced signage installed. Buddy system implemented for new staff in isolation care. Competency verification required.'
        WHEN 10 THEN 'DOCUMENTATION ERROR: Critical lab result not documented. Date: ' || i.incident_date::VARCHAR || '. Description: Abnormal lab result received but not documented in patient chart for 6 hours. Result indicated elevated potassium requiring immediate intervention. When discovered, physician notified and treatment initiated. Patient outcome favorable. Investigation: Lab notification went to wrong provider inbox. Manual documentation step missed. Electronic interface error. Corrective Actions: Lab interface reprogrammed for correct routing. Automatic escalation for critical results implemented. Backup notification system activated. Documentation audit procedures enhanced.'
        WHEN 11 THEN 'SURGICAL INSTRUMENT COUNT DISCREPANCY: Instrument count incorrect at case closure. Date: ' || i.incident_date::VARCHAR || '. Description: Final instrument count showed one missing sponge. Surgical site re-explored. Sponge found in irrigation basin, never entered patient. Extended OR time but patient outcome unaffected. Investigation: Distraction during count procedure. Verbal count not matching visual verification. Corrective Actions: Electronic counting system implemented. Mandatory stop-work for count discrepancies. Dual-person verification required. Team training on count procedures conducted.'
        WHEN 12 THEN 'RESTRAINT INCIDENT: Improper restraint application. Date: ' || i.incident_date::VARCHAR || '. Description: Patient in physical restraints found with excessive tightness on left wrist causing skin redness. Restraints immediately loosened and repositioned. Wound care provided. Physician and family notified. Investigation: Staff applied restraints during emergency situation without proper training. Assessment and monitoring protocols not followed. Corrective Actions: Restraint training certification made mandatory. 15-minute monitoring requirement enforced via electronic documentation. Alternative de-escalation techniques training provided.'
        WHEN 13 THEN 'PATIENT PROPERTY LOSS: Valuables missing from patient belongings. Date: ' || i.incident_date::VARCHAR || '. Description: Patient reported wedding ring missing from belongings bag upon transfer to new unit. Extensive search conducted. Ring not located. Patient and family extremely upset. Security investigation initiated. Investigation: Property documentation incomplete at admission. Bag not sealed properly. Chain of custody unclear during transfers. Corrective Actions: Property management protocol revised. Sealed bags mandatory for all valuables. Electronic tracking system for patient belongings implemented. Staff training on property documentation completed.'
        WHEN 14 THEN 'FIRE SAFETY VIOLATION: Blocked fire exit discovered. Date: ' || i.incident_date::VARCHAR || '. Description: Fire marshal inspection found supply cart blocking emergency exit in East Wing. Violation cited. Cart immediately removed. No patients at risk. Investigation: Supply delivery protocol allows temporary placement during restocking. Staff failed to remove cart after completing work. Inadequate supervision of supply vendors. Corrective Actions: Supply delivery routes redesigned. Vendor protocols updated. Hourly fire exit checks implemented. Staff accountability measures enhanced.'
    END AS report_text,
    ARRAY_CONSTRUCT('INITIAL_REPORT', 'INVESTIGATION_COMPLETE', 'ROOT_CAUSE_ANALYSIS', 'CORRECTIVE_ACTION_PLAN')[UNIFORM(0, 3, RANDOM())] AS report_type,
    ARRAY_CONSTRUCT('PENDING', 'INVESTIGATING', 'COMPLETE')[UNIFORM(0, 2, RANDOM())] AS investigation_status,
    'Corrective actions implemented and effectiveness to be monitored over next 90 days' AS corrective_actions_taken,
    DATEADD('day', UNIFORM(1, 14, RANDOM()), i.incident_date) AS report_date,
    'Risk Manager ' || UNIFORM(1, 5, RANDOM())::VARCHAR AS created_by,
    DATEADD('day', UNIFORM(1, 14, RANDOM()), i.incident_date) AS created_at
FROM RAW.INCIDENTS i
WHERE UNIFORM(0, 100, RANDOM()) < 50
LIMIT 15000;

-- ============================================================================
-- Step 7: Generate sample training materials
-- ============================================================================
INSERT INTO TRAINING_MATERIALS VALUES
('MAT001', 'HIPAA Privacy Rule: Complete Guide',
$$HIPAA PRIVACY RULE - COMPREHENSIVE TRAINING GUIDE

INTRODUCTION
The Health Insurance Portability and Accountability Act (HIPAA) Privacy Rule establishes national standards for protecting patient health information. All healthcare organizations and employees must comply with these regulations.

WHAT IS PROTECTED HEALTH INFORMATION (PHI)?
PHI includes any individually identifiable health information transmitted or maintained in any form:
- Patient names, addresses, phone numbers, email addresses
- Medical record numbers, account numbers
- Social security numbers, dates of birth
- Photographs, fingerprints, voice recordings
- Diagnoses, treatment information, test results
- Billing and payment information

PERMITTED USES AND DISCLOSURES
PHI may be used and disclosed WITHOUT patient authorization for:
1. Treatment - providing, coordinating, or managing healthcare
2. Payment - obtaining reimbursement for healthcare services
3. Healthcare Operations - quality assessment, training, accreditation

MINIMUM NECESSARY STANDARD
When using or disclosing PHI, use only the minimum amount necessary to accomplish the intended purpose.

PATIENT RIGHTS UNDER HIPAA
Patients have the right to:
- Access their medical records
- Request corrections to their records
- Receive notice of privacy practices
- Request restrictions on uses and disclosures
- Request confidential communications
- Receive an accounting of disclosures

BREACH NOTIFICATION REQUIREMENTS
If PHI is accessed, used, or disclosed improperly:
- Notify patients within 60 days
- Document the breach
- Report to OCR if affecting 500+ individuals
- Notify media if affecting 500+ individuals in a jurisdiction

SECURITY SAFEGUARDS
Physical safeguards:
- Lock medical records storage areas
- Position computer screens away from public view
- Escort visitors in clinical areas
- Secure mobile devices

Technical safeguards:
- Use strong passwords
- Enable automatic logoff
- Encrypt electronic PHI
- Use secure messaging systems

Administrative safeguards:
- Train all staff on HIPAA policies
- Implement access controls
- Document privacy incidents
- Conduct regular risk assessments

PENALTIES FOR VIOLATIONS
- Civil penalties: $100 - $50,000 per violation
- Criminal penalties: up to $250,000 and 10 years imprisonment
- Loss of professional license
- Termination of employment

COMMON HIPAA VIOLATIONS TO AVOID
1. Discussing patients in public areas (elevators, cafeteria)
2. Accessing records of patients you are not treating
3. Sharing passwords or leaving computers unlocked
4. Disposing of PHI in regular trash
5. Texting or emailing PHI without encryption
6. Taking photos of patients without consent
7. Posting patient information on social media

SOCIAL MEDIA AND HIPAA
Never post:
- Patient information, even without names
- Photos or videos from clinical areas
- Complaints about patients
- Details that could identify a patient

Remember: If you can identify a patient from the information, it is a HIPAA violation!

HIPAA IN EMERGENCY SITUATIONS
HIPAA allows disclosure of PHI without authorization during:
- Public health emergencies
- To family members involved in patient care
- To law enforcement for certain purposes
- For national security purposes

QUESTIONS AND SCENARIOS
Test your knowledge with these scenarios in the assessment section.

For questions contact your Privacy Officer or Compliance Department.$$,
'COMPLIANCE', 'HIPAA', 'hipaa,privacy,phi,compliance', 'Compliance Team', CURRENT_TIMESTAMP(), 5234, 4.8, TRUE, CURRENT_TIMESTAMP()),

('MAT002', 'Infection Control and Prevention Best Practices',
$$INFECTION CONTROL AND PREVENTION - HEALTHCARE GUIDE

STANDARD PRECAUTIONS
Standard precautions apply to ALL patients regardless of infection status:

HAND HYGIENE
Most important infection prevention measure!
When to perform hand hygiene:
- Before and after patient contact
- Before aseptic procedures
- After body fluid exposure
- After touching patient surroundings

Hand washing technique:
- Wet hands with water
- Apply soap and lather for 20 seconds
- Rinse thoroughly
- Dry with disposable towel
- Use towel to turn off faucet

Alcohol-based hand sanitizer:
- Apply to palm of one hand
- Rub hands together covering all surfaces
- Continue until hands are dry (20 seconds)
- Use when hands not visibly soiled

PERSONAL PROTECTIVE EQUIPMENT (PPE)
Selection based on anticipated exposure:

Gloves:
- When touching blood, body fluids, or contaminated items
- When touching mucous membranes or non-intact skin
- Change between tasks and patients
- Remove before touching clean surfaces

Gowns:
- When clothing may become contaminated
- During procedures likely to generate splashes
- Cover arms fully and close in back
- Remove before leaving patient area

Masks and Eye Protection:
- When splashes or sprays are anticipated
- During aerosol-generating procedures
- Ensure proper fit
- Do not reuse

RESPIRATORY HYGIENE/COUGH ETIQUETTE
- Cover nose and mouth when coughing/sneezing
- Use tissues and dispose immediately
- Perform hand hygiene
- Wear mask if coughing
- Maintain 3-foot distance when possible

TRANSMISSION-BASED PRECAUTIONS

Contact Precautions (C.diff, MRSA, VRE):
- Private room or cohorting
- Gown and gloves for all patient contact
- Dedicated equipment
- Enhanced environmental cleaning

Droplet Precautions (Influenza, Pertussis):
- Private room or cohorting
- Mask within 3 feet of patient
- Patient wears mask during transport

Airborne Precautions (TB, Measles, Varicella):
- Airborne infection isolation room
- N95 respirator required
- Keep door closed
- Limit patient movement

SHARPS SAFETY
- Never recap needles
- Dispose immediately in sharps container
- Do not overfill containers
- Use safety devices when available
- Report needlestick injuries immediately

ENVIRONMENTAL CLEANING
High-touch surfaces cleaned daily:
- Bed rails, call buttons
- Door knobs, light switches
- IV poles, bedside tables
- Bathroom surfaces

Spill management:
- Isolate area
- Wear appropriate PPE
- Clean from outside toward center
- Use EPA-approved disinfectant
- Follow contact time requirements

MANAGING MULTI-DRUG RESISTANT ORGANISMS (MDROs)
- Strict contact precautions
- Enhanced environmental cleaning
- Antibiotic stewardship
- Surveillance cultures when indicated
- Patient and family education

COVID-19 SPECIFIC PROTOCOLS
- Universal masking in healthcare settings
- Eye protection for patient care
- Appropriate isolation precautions
- Vaccination strongly recommended
- Testing protocols per facility policy

BLOODBORNE PATHOGEN EXPOSURE
If exposure occurs:
1. Immediately wash area with soap and water
2. Report to supervisor
3. Seek medical evaluation
4. Complete incident report
5. Follow post-exposure prophylaxis protocol

PREVENTING HEALTHCARE-ASSOCIATED INFECTIONS

Central Line-Associated Bloodstream Infections:
- Hand hygiene before access
- Disinfect hubs before access
- Assess need for line daily
- Remove promptly when not needed

Catheter-Associated Urinary Tract Infections:
- Use only when necessary
- Maintain closed drainage system
- Keep bag below bladder
- Remove catheter as soon as possible

Ventilator-Associated Pneumonia:
- Elevate head of bed 30-45 degrees
- Perform oral care every 4 hours
- Assess daily for readiness to extubate
- Maintain endotracheal cuff pressure

Surgical Site Infections:
- Appropriate antibiotic prophylaxis
- Proper skin preparation
- Maintain normothermia
- Control blood glucose

Remember: Preventing infections protects patients, staff, and the community!$$,
'TRAINING', 'INFECTION_CONTROL', 'infection control,ppe,hand hygiene,isolation', 'Infection Control Team', CURRENT_TIMESTAMP(), 8921, 4.9, TRUE, CURRENT_TIMESTAMP()),

('MAT003', 'CPR and Basic Life Support Quick Reference',
$$CPR AND BASIC LIFE SUPPORT - QUICK REFERENCE GUIDE

ASSESS THE SITUATION
- Check for scene safety
- Check for responsiveness - tap and shout
- Call for help - activate emergency response
- Get AED if available

CHECK FOR PULSE AND BREATHING
- Check carotid pulse for no more than 10 seconds
- Look for chest rise and fall
- Listen for breath sounds

ADULT CPR (> 8 years old)
Compression-Only CPR if untrained or uncomfortable with rescue breaths

CHEST COMPRESSIONS
- Hand placement: Center of chest between nipples
- Hand position: Heel of hand, other hand on top, fingers interlaced
- Depth: At least 2 inches (5 cm)
- Rate: 100-120 compressions per minute
- Allow complete chest recoil between compressions
- Minimize interruptions in compressions

COMPRESSION-VENTILATION RATIO
- 30 compressions : 2 breaths
- Continue until:
  * Person starts breathing
  * AED arrives and is ready to use
  * EMS personnel take over
  * You are too exhausted to continue

RESCUE BREATHS
- Open airway using head-tilt/chin-lift
- Pinch nose closed
- Make complete seal over person's mouth
- Give 1 breath over 1 second
- Watch for chest rise
- Give second breath if first was successful
- If chest does not rise, reposition airway and try again

AUTOMATED EXTERNAL DEFIBRILLATOR (AED)
1. Turn on AED (follows voice prompts)
2. Expose chest and wipe dry
3. Attach electrode pads as shown on pads
4. Ensure no one touching person
5. Press "Analyze" button if prompted
6. If shock advised:
   - Ensure no one touching person
   - Press "Shock" button
   - Resume CPR immediately after shock
7. If no shock advised:
   - Resume CPR immediately
8. Continue until EMS arrives or person starts breathing

CHILD CPR (1-8 years old)
Same as adult CPR except:
- Use one or two hands for compressions
- Compression depth: At least 2 inches (5 cm)
- Same ratio: 30 compressions to 2 breaths
- If alone, perform 2 minutes of CPR before calling 911

INFANT CPR (< 1 year old)
- Check brachial pulse (inside of upper arm)
- Two-finger compression technique
- Compression depth: 1.5 inches (4 cm)
- Cover infant's mouth and nose with your mouth for breaths
- Give small puffs of air - just enough to make chest rise
- If alone, perform 2 minutes of CPR before calling 911
- 30:2 ratio for single rescuer
- 15:2 ratio for two healthcare provider rescuers

CHOKING ADULT/CHILD (CONSCIOUS)
- Ask "Are you choking?"
- If YES and cannot speak/cough:
  1. Stand behind person
  2. Make a fist above belly button
  3. Grasp fist with other hand
  4. Give quick upward thrusts
  5. Repeat until object expelled or person becomes unconscious

CHOKING INFANT (CONSCIOUS)
1. Support infant face down on your forearm
2. Give 5 back blows between shoulder blades
3. Turn infant face up
4. Give 5 chest thrusts with 2 fingers
5. Alternate back blows and chest thrusts
6. Continue until object expelled or infant becomes unconscious

IF PERSON BECOMES UNCONSCIOUS
- Lower to ground carefully
- Call 911 if not already done
- Begin CPR starting with compressions
- Look in mouth before giving breaths
- Remove object if visible and easy to reach
- Never do blind finger sweep

OPIOID OVERDOSE RESPONSE
If suspected opioid overdose:
- Check for responsiveness
- Call 911
- Administer naloxone (Narcan) if available
- Begin rescue breathing or CPR
- Place in recovery position if breathing

RECOVERY POSITION
Once person has pulse and is breathing:
- Roll onto side
- Extend bottom arm above head
- Bend top knee for stability
- Tilt head back to keep airway open
- Monitor until EMS arrives

SPECIAL CONSIDERATIONS
Pregnant woman:
- Position hands slightly higher on chest
- After 20 weeks, if possible position slightly to left side

Trauma:
- Use jaw-thrust maneuver instead of head-tilt/chin-lift

This is a quick reference only. Certification required for healthcare providers.$$,
'TRAINING', 'CPR_BLS', 'cpr,bls,emergency,aed,choking', 'Clinical Education', CURRENT_TIMESTAMP(), 12453, 4.7, TRUE, CURRENT_TIMESTAMP());

-- ============================================================================
-- Step 8: Create Cortex Search Service for Support Transcripts
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE SUPPORT_TRANSCRIPTS_SEARCH
  ON transcript_text
  ATTRIBUTES organization_id, agent_id, interaction_type, interaction_date
  WAREHOUSE = SNOW_HEALTH_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for customer support transcripts - enables semantic search across support interactions'
AS
  SELECT
    transcript_id,
    transcript_text,
    ticket_id,
    organization_id,
    agent_id,
    interaction_type,
    interaction_date,
    sentiment_score,
    keywords,
    created_at
  FROM RAW.SUPPORT_TRANSCRIPTS;

-- ============================================================================
-- Step 9: Create Cortex Search Service for Incident Reports
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE INCIDENT_REPORTS_SEARCH
  ON report_text
  ATTRIBUTES organization_id, report_type, investigation_status, report_date
  WAREHOUSE = SNOW_HEALTH_WH
  TARGET_LAG = '1 hour'
  COMMENT = 'Cortex Search service for incident reports - enables semantic search across incident documentation'
AS
  SELECT
    report_id,
    report_text,
    incident_id,
    organization_id,
    report_type,
    investigation_status,
    corrective_actions_taken,
    report_date,
    created_by,
    created_at
  FROM RAW.INCIDENT_REPORTS;

-- ============================================================================
-- Step 10: Create Cortex Search Service for Training Materials
-- ============================================================================
CREATE OR REPLACE CORTEX SEARCH SERVICE TRAINING_MATERIALS_SEARCH
  ON content
  ATTRIBUTES material_category, course_category, title
  WAREHOUSE = SNOW_HEALTH_WH
  TARGET_LAG = '24 hours'
  COMMENT = 'Cortex Search service for training materials - enables semantic search across training documentation'
AS
  SELECT
    material_id,
    title,
    content,
    material_category,
    course_category,
    tags,
    author,
    last_updated,
    view_count,
    helpfulness_score,
    created_at
  FROM RAW.TRAINING_MATERIALS;

-- ============================================================================
-- Step 11: Verify Cortex Search Services Created
-- ============================================================================
SHOW CORTEX SEARCH SERVICES IN SCHEMA RAW;

-- ============================================================================
-- Display success message
-- ============================================================================
SELECT 'Cortex Search services created successfully' AS status,
       COUNT(*) AS service_count
FROM (
  SELECT 'SUPPORT_TRANSCRIPTS_SEARCH' AS service_name
  UNION ALL
  SELECT 'INCIDENT_REPORTS_SEARCH'
  UNION ALL
  SELECT 'TRAINING_MATERIALS_SEARCH'
);

-- ============================================================================
-- Display data counts
-- ============================================================================
SELECT 'SUPPORT_TRANSCRIPTS' AS table_name, COUNT(*) AS row_count FROM SUPPORT_TRANSCRIPTS
UNION ALL
SELECT 'INCIDENT_REPORTS', COUNT(*) FROM INCIDENT_REPORTS
UNION ALL
SELECT 'TRAINING_MATERIALS', COUNT(*) FROM TRAINING_MATERIALS
ORDER BY table_name;

