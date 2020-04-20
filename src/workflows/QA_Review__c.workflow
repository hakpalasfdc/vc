<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Clinical_Auditor_Assign_Date</fullName>
        <description>Updates the Clinical Auditor Assign Date field to the date when Clinical Auditor was set.</description>
        <field>Clinical_Auditor_Assign_Date__c</field>
        <formula>TODAY()</formula>
        <name>Update Clinical Auditor Assign Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR28_Update_QA_Review_Status_Closed</fullName>
        <field>QA_Review_Status__c</field>
        <literalValue>Closed - Non-responder</literalValue>
        <name>VSPR28 Update QA Review Status Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR28_QA Review Status 45 Days No Response</fullName>
        <active>true</active>
        <formula>NOT(ISBLANK(Original_DocuSign_Sent_Date__c))  		 		&amp;&amp; 		 		ISBLANK(DocuSign_Completion_Date__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>VSPR28_Update_QA_Review_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>45</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>VSPR33_QA_Review_Clinical_Auditor_Assign_Date</fullName>
        <actions>
            <name>Update_Clinical_Auditor_Assign_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Clinical Auditor Assign Date to today&apos;s date when Clinical Auditor is set. This rule will set the date and won&apos;t allow it to be updated.</description>
        <formula>AND( 				NOT(ISBLANK(Clinical_Auditor__c)), 				 				ISBLANK(Clinical_Auditor_Assign_Date__c) ) 			 				||  				AND(ISCHANGED(Clinical_Auditor__c), 								ISBLANK(PRIORVALUE(Clinical_Auditor__c)), 								ISBLANK(PRIORVALUE(Clinical_Auditor_Assign_Date__c)) 							)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
