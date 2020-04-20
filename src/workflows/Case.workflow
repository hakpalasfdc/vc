<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Case_Comment_Added</fullName>
        <description>New Case Comment Added</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Case_Comment_Added</template>
    </alerts>
    <alerts>
        <fullName>VSPR16_Case_has_Missed_SLA</fullName>
        <description>VSPR16_Case has Missed SLA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR16_Case_has_missed_the_SLA</template>
    </alerts>
    <alerts>
        <fullName>VSPR16_Case_in_Danger_of_Missing_SLA</fullName>
        <description>VSPR16_Case in Danger of Missing SLA</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR16_Case_In_danger_of_missing_the_SLA</template>
    </alerts>
    <alerts>
        <fullName>VSPR29_Case_Optics_Doctor_Queue_Workflow_Email_Alert</fullName>
        <description>VSPR29_Case_Optics_Doctor_Queue_Workflow_Email_Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR29_Case_Optics_Doctor_Queue_Alert</template>
    </alerts>
    <alerts>
        <fullName>VSPR3_Optics_Critical_Case_Email_Notification_on_VSP_Board_Member_and_SPR_Accoun</fullName>
        <description>Optics Critical Case Email Notification on VSP Board Member and SPR Accounts</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Critical_Case_Opened_on_Board_Member_or_SPR_Account</template>
    </alerts>
    <alerts>
        <fullName>VSPR3_Vision_Care_Critical_Case_Email_Notification_on_VSP_Board_Member_and_SPR_A</fullName>
        <description>Vision Care Critical Case Email Notification on VSP Board Member and SPR Accounts</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Critical_Case_Opened_on_Board_Member_or_SPR_Account</template>
    </alerts>
    <fieldUpdates>
        <fullName>HighPriority</fullName>
        <description>Update Case:Priority to HIGH</description>
        <field>Priority</field>
        <literalValue>High</literalValue>
        <name>HighPriority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LowPriority</fullName>
        <description>Update Case:Priority to LOW</description>
        <field>Priority</field>
        <literalValue>Low</literalValue>
        <name>LowPriority</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Changed_to_False</fullName>
        <field>Owner_Changed__c</field>
        <literalValue>0</literalValue>
        <name>Owner Changed to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Owner_Changed_to_true</fullName>
        <field>Owner_Changed__c</field>
        <literalValue>1</literalValue>
        <name>Owner Changed to true</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Subject</fullName>
        <field>Subject</field>
        <formula>TEXT(CallerType__c) + &quot; &quot; + IVR_Call_Type__c + &quot; &quot; + Caller_Intent__c + &quot; &quot; + TEXT(TODAY())</formula>
        <name>Populate Subject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Auto_Close_Start_Date_Time</fullName>
        <description>Removes the Auto-Close Start Date/Time</description>
        <field>Auto_Close_Start_Date_Time__c</field>
        <name>Remove Auto-Close Start Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Auto_Close_Start_Date_Time</fullName>
        <description>Sets the Auto-Close Start Date/Time field to current date and time.</description>
        <field>Auto_Close_Start_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Auto-Close Start Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_LOB_to_Global_Customer_Care</fullName>
        <description>Set the Line of Business to Global Customer Care</description>
        <field>Line_of_Business__c</field>
        <literalValue>Global Customer Care</literalValue>
        <name>Set Case LOB to Global Customer Care</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Topic_to_Written_Inquiries</fullName>
        <description>Set the Topic field on the Case to Written Inquiries</description>
        <field>Product__c</field>
        <literalValue>Written Inquiries</literalValue>
        <name>Set Case Topic to Written Inquiries</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Case_Type_to_Request</fullName>
        <description>Set the Type field to Request</description>
        <field>Type</field>
        <literalValue>Request</literalValue>
        <name>Set Case Type to Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Milestone_Start_Time</fullName>
        <field>Milestone_Start_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Milestone Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_New_Case_Comment_to_False</fullName>
        <field>New_Case_Comment__c</field>
        <literalValue>0</literalValue>
        <name>Set New Case Comment to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Image_to_Green</fullName>
        <field>Status_Number__c</field>
        <formula>1</formula>
        <name>Set Status Image to Green</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Image_to_Red</fullName>
        <field>Status_Number__c</field>
        <formula>3</formula>
        <name>Status Image to Red</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Status_Image_to_Yellow</fullName>
        <field>Status_Number__c</field>
        <formula>2</formula>
        <name>Status Image to Yellow</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Status_to_Closed</fullName>
        <description>Updates Case Status to Closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>Update Case Status to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Date_Time_Accepted</fullName>
        <field>Date_Time_Accepted__c</field>
        <formula>NOW()</formula>
        <name>Update Date/Time Accepted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Resolution_to_Phone_Call</fullName>
        <field>Resolution__c</field>
        <formula>&quot;Phone Call&quot;</formula>
        <name>Update Resolution to Phone Call</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Status_to_InProgress</fullName>
        <field>Status</field>
        <literalValue>In Progress</literalValue>
        <name>Update Status to InProgress</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Survey_Sent_field</fullName>
        <field>Survey_Sent__c</field>
        <literalValue>1</literalValue>
        <name>Update Survey Sent field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_Update_CC_Eyeconic_Case_to_Closed</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>VSPR23_Update CC Eyeconic Case to Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_Update_Case_Status_to_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>VSPR23_Update Case Status to New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_Update_Case_Topic_to_Eyeconic_Ops</fullName>
        <field>Product__c</field>
        <literalValue>Eyeconic Ops</literalValue>
        <name>VSPR23_Update Case Topic to Eyeconic Ops</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_Update_Case_Topic_to_Eyeconic_USC</fullName>
        <field>Product__c</field>
        <literalValue>Eyeconic USC</literalValue>
        <name>VSPR23_Update Case Topic to Eyeconic USC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR33_VBCaseStatusClosed</fullName>
        <description>Set the status of the case to Closed</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>VSPR33_VBCaseStatusClosed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR3Auto_Case_Closure_for_Non_SFDC_LOBs</fullName>
        <description>Automatic case closure for non SFDC LOBs after case is created. Report is sent to each LOB weekly to include any cases opened in prior week.</description>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>VSPR3Auto Case Closure for Non SFDC LOBs</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Client_Delivery_Billing_Survey</fullName>
        <apiVersion>42.0</apiVersion>
        <description>Email with Qualtrics survey for Client Delivery Billing Closed Cases.</description>
        <endpointUrl>https://sjc1.qualtrics.com/triggers/api/v1/event?eventType=SalesforceOutboundMessage&amp;s=SV_9zZAIHRPmxgoF7L&amp;u=UR_eo1NdvujdQmwckJ&amp;t=OC_3CWayJto1BO2hP2&amp;b=vsp</endpointUrl>
        <fields>ContactId</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>qualtrics@vsp.com</integrationUser>
        <name>Client Delivery Billing Survey</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Case Owner Changed</fullName>
        <actions>
            <name>Owner_Changed_to_true</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Priority to High</fullName>
        <actions>
            <name>HighPriority</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Contact Us Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Private Regence Medicare Reimbursement</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>RSECURE(Visionworks claim refunds)</value>
        </criteriaItems>
        <description>Updates Case:Priority to High if subject contains: Contact Us Request, Private Regence Medicare Reimbursement or RSECURE(Visionworks claim refunds)</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Priority to Low</fullName>
        <actions>
            <name>LowPriority</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Email</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>Undeliverable</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Subject</field>
            <operation>contains</operation>
            <value>SPAM Trigger Words</value>
        </criteriaItems>
        <description>Updates Case:Priority to Low if subject contains: Undeliverable or SPAM Trigger Words</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Send Email Alert when Case Comment Added</fullName>
        <actions>
            <name>New_Case_Comment_Added</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Set_New_Case_Comment_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.New_Case_Comment__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Date%2FTime Accepted</fullName>
        <actions>
            <name>Owner_Changed_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Date_Time_Accepted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Owner_Changed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR16_Email Alert for SLA Flag Turns Red</fullName>
        <actions>
            <name>VSPR16_Case_has_Missed_SLA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4) AND (5 AND 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Case_Age_2__c</field>
            <operation>equals</operation>
            <value>24</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Priority__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Age_2__c</field>
            <operation>equals</operation>
            <value>48</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Priority__c</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <description>When SLA Case Age/SLA Flag turns Red at 24 for High Priority Cases and 48 hours for Medium, an email alert is sent to the Case Owner (unless the Owner is a Queue). Only Customer Care Record Types.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR16_Email Alert for SLA Flag Turns Yellow</fullName>
        <actions>
            <name>VSPR16_Case_in_Danger_of_Missing_SLA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) OR (3 AND 4) AND (5 AND 6) AND 7</booleanFilter>
        <criteriaItems>
            <field>Case.Case_Age_2__c</field>
            <operation>equals</operation>
            <value>21</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Priority__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Age_2__c</field>
            <operation>equals</operation>
            <value>45</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Case_Priority__c</field>
            <operation>equals</operation>
            <value>Medium</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notContain</operation>
            <value>Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.IsClosed</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Customer Care</value>
        </criteriaItems>
        <description>When SLA Case Age/SLA Flag turns yellow at 21 for High Priority Cases and 45 hours for Medium, an email alert is sent to the Case Owner (unless the Owner is a Queue). Customer Care Cases only.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR21_CC Auto Case Closure</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) AND 4</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC Spam Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC Undeliverable Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC No Reply Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Start_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatically closes cases assigned to the CC Spam Queue or CC Undeliverable Queue 48 hours after the case is assigned to the queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Auto_Close_Start_Date_Time__c</offsetFromField>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>VSPR21_CD Auto Case Closure</fullName>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CD SPAM Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CD No Reply Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Auto_Close_Start_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Automatically closes cases assigned to the CD SPAM Queue 24 hours after the case is assigned to the queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Case_Status_to_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.Auto_Close_Start_Date_Time__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>VSPR21_Remove Auto-Close Start Date%2FTime</fullName>
        <actions>
            <name>Remove_Auto_Close_Start_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.Auto_Close_Start_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>CC Undeliverable Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>CC Spam Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>CD SPAM Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>CC No Reply Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>notEqual</operation>
            <value>CD No Reply Queue</value>
        </criteriaItems>
        <description>Remove Auto-Close Start Date/Time when a case is removed from a Spam or Undeliverable queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR21_Set Auto-Close Start Date%2FTime</fullName>
        <actions>
            <name>Set_Auto_Close_Start_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5</booleanFilter>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC Spam Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC Undeliverable Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CD SPAM Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CC No Reply Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CD No Reply Queue</value>
        </criteriaItems>
        <description>Update Auto-Close Start Date/Time when a case enters a Spam or Undeliverable queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Eyeconic Ops Case Status Update</fullName>
        <actions>
            <name>VSPR23_Update_Case_Status_to_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId ) 
&amp;&amp;  
(  Owner:Queue.QueueName = &quot;Eyeconic Queue&quot;) 
||  
( Owner:Queue.QueueName = &quot;Eyeconic Work Queue&quot;)
&amp;&amp;
ISPICKVAL(PRIORVALUE(Status), &quot;Closed&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Eyeconic Ops Case Topic Update</fullName>
        <actions>
            <name>VSPR23_Update_Case_Topic_to_Eyeconic_Ops</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId ) &amp;&amp;  (  Owner:Queue.QueueName = &quot;Eyeconic Queue&quot;) ||  ( Owner:Queue.QueueName = &quot;Eyeconic Work Queue&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Eyeconic USC Case Topic Update</fullName>
        <actions>
            <name>VSPR23_Update_Case_Topic_to_Eyeconic_USC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( OwnerId ) &amp;&amp;  (  Owner:Queue.QueueName = &quot;CC Eyeconic Main Queue&quot;) ||  ( Owner:Queue.QueueName = &quot;CC Eyeconic Work Queue&quot;)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Update CC %26 Eyeconic Case Status to Closed</fullName>
        <actions>
            <name>VSPR23_Update_CC_Eyeconic_Case_to_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Case.Reason_for_Contact__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Caller_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Eyeconic,Customer Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Product__c</field>
            <operation>notEqual</operation>
            <value>Eyeconic Ops</value>
        </criteriaItems>
        <description>For CC and Eyeconic Case Record Types</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR24 ReOpenCases</fullName>
        <actions>
            <name>Set_Milestone_Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_Image_to_Green</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(Status),   NOT(ISBLANK(TEXT(Status))),  NOT( ISPICKVAL(Status, &quot;Closed&quot;) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR24_Qualtrics Survey Client Delivery Cases</fullName>
        <actions>
            <name>Update_Survey_Sent_field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Client_Delivery_Billing_Survey</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Client Delivery Billing Closed Case survey email rule.</description>
        <formula>ISPICKVAL(Line_of_Business__c , &quot;Vision Care&quot;) &amp;&amp;  ISPICKVAL(Division__c, &quot;Client Delivery&quot;) &amp;&amp;  ISPICKVAL(Status, &quot;Closed&quot;) &amp;&amp;  ISPICKVAL(Product__c , &quot;Billing&quot;) &amp;&amp;  (  ISPICKVAL(CD_Category__c , &quot;5500 Request&quot;) ||  ISPICKVAL(CD_Category__c , &quot;Billing Audit&quot;) ||  ISPICKVAL(CD_Category__c , &quot;Billing Inquiry&quot;) ||  ISPICKVAL(CD_Category__c , &quot;Contact Updates&quot;) ||  ISPICKVAL(CD_Category__c , &quot;Copy of Bill&quot;) ||  ISPICKVAL(CD_Category__c , &quot;Membership Updates&quot;)  )  &amp;&amp;  NOT(ISBLANK(TEXT(CD_Category__c))) &amp;&amp;  Contact.Do_Not_Send_Survey__c = false &amp;&amp;  Survey_Sent__c = false</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR29_Case_Optics_Doctor_Queue_Alert</fullName>
        <actions>
            <name>VSPR29_Case_Optics_Doctor_Queue_Workflow_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email Alert sent to Optics Doctor Service Queue when Severity is critical or major</description>
        <formula>Owner:Queue.DeveloperName = &apos;Optics_Doctor_Service_Queue&apos; 	 &amp;&amp; 	 (ISCHANGED(Severity__c) || ISCHANGED(OwnerId))   		 &amp;&amp; 	 (ISPICKVAL(Severity__c, &apos;Critical&apos;) || ISPICKVAL(Severity__c, &apos;Major&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR29_UpdateCDCaseWhenOriginIsPhone</fullName>
        <actions>
            <name>Update_Resolution_to_Phone_Call</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Delivery</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR29_UpdateCDCaseWhenOriginIsPhoneNotClosed</fullName>
        <actions>
            <name>Update_Status_to_InProgress</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.Origin</field>
            <operation>equals</operation>
            <value>Phone</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>notEqual</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Client Delivery</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR2_PopulateSubject</fullName>
        <actions>
            <name>Populate_Subject</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(RecordType.Name = &quot;Vision Benefits&quot;, ISPICKVAL(Origin, &quot;Phone&quot;))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR3 Automatic Case Closure for Non SFDC LOBs</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.Line_of_Business__c</field>
            <operation>equals</operation>
            <value>Eyefinity</value>
        </criteriaItems>
        <description>Automatic case closure for non SFDC LOBs after case is created. Report is sent to each LOB weekly to include any cases opened in prior week.</description>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>VSPR3Auto_Case_Closure_for_Non_SFDC_LOBs</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>VSPR3 Optics Notification if Case is Created on SPR_Board Member Contact_Account</fullName>
        <actions>
            <name>VSPR3_Optics_Critical_Case_Email_Notification_on_VSP_Board_Member_and_SPR_Accoun</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.Vision_Care_State_Professional_Rep__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Board_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Severity__c</field>
            <operation>equals</operation>
            <value>Critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Line_of_Business__c</field>
            <operation>equals</operation>
            <value>Optics Group</value>
        </criteriaItems>
        <description>Rule to send email alert to specified individuals in Optics LOB when a Critical severity case is opened on a contact or account marked as State Professional Rep or Board Member.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR3 Vision Care Notification if Case is Created on SPR_Board Member Contact_Account</fullName>
        <actions>
            <name>VSPR3_Vision_Care_Critical_Case_Email_Notification_on_VSP_Board_Member_and_SPR_A</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>Account.Vision_Care_State_Professional_Rep__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Board_Member__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Severity__c</field>
            <operation>equals</operation>
            <value>Critical</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Line_of_Business__c</field>
            <operation>equals</operation>
            <value>Vision Care</value>
        </criteriaItems>
        <description>Rule to send email alert to specified individuals in Vision Care LOB when a Critical severity case is opened on a contact or account marked as State Professional Rep or Board Member.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR33_VBCaseClose</fullName>
        <actions>
            <name>VSPR33_VBCaseStatusClosed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Vision Benefits</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>New</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Reason_Details__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
