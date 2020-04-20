<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>VSPR7_Notify_Recruitment_Owner_Episoded_Rostered_Status_60_Days</fullName>
        <description>VSPR7_Notify Recruitment Owner Episoded/Rostered Status &gt; 60 Days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR7_Notify_Recruitment_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>VSPR34_Net_Recruitment_Set_Rostered_Date</fullName>
        <field>Rostered_Date__c</field>
        <formula>TODAY()</formula>
        <name>VSPR34 Net Recruitment Set Rostered Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR34_Set_Closed_Date</fullName>
        <description>Set the Closed Date to Today once it the Recruitment Status changes to Closed OR Completed/Committee OR Completed/No Committee OR Completed/Denied at Committee.</description>
        <field>Closed_Date__c</field>
        <formula>TODAY()</formula>
        <name>VSPR34 Set Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR3_Set_Opened_Date</fullName>
        <field>Opened_Date__c</field>
        <formula>TODAY()</formula>
        <name>VSPR3_Set Opened Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR3_Update_Status_Change_Date</fullName>
        <field>Status_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>VSPR3_Update Status Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR3 Set Opened Date</fullName>
        <actions>
            <name>VSPR3_Set_Opened_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Network_Recruitment__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR3 Update Status Change Date on Recruitment Status Change</fullName>
        <actions>
            <name>VSPR3_Update_Status_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Status Change Date field on Recruitment record to Today&apos;s date every time the Recruitment Status field is changed.</description>
        <formula>ISCHANGED( Recruitment_Status__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR34 Net Recruitment - Set Rostered Date</fullName>
        <actions>
            <name>VSPR34_Net_Recruitment_Set_Rostered_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISBLANK(Rostered_Date__c) , ISPICKVAL(Recruitment_Status__c, &apos;Episoded/Rostered&apos;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR34 Set Closed Date on Recruitment Status Change</fullName>
        <actions>
            <name>VSPR34_Set_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2</booleanFilter>
        <criteriaItems>
            <field>Network_Recruitment__c.Closed_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Network_Recruitment__c.Recruitment_Status__c</field>
            <operation>equals</operation>
            <value>Completed/Committee,Completed/No Committee,Completed/Denied at Committee,Closed</value>
        </criteriaItems>
        <description>Set the Closed Date Today when Recruitment Status Field changes to Closed, Completed/Committee, Completed/No Committee, Completed/Denied at Committee. Once a date is entered the field can not be changed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR7_Notify Recruitment Owner Episoded%2FRostered Status %3E 60 Days</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Network_Recruitment__c.Recruitment_Status__c</field>
            <operation>equals</operation>
            <value>Episoded/Rostered</value>
        </criteriaItems>
        <description>Workflow and email alert to notify owner of recruitment record when the status has been in Episoded/Rostered status for more than 60 days.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>VSPR7_Notify_Recruitment_Owner_Episoded_Rostered_Status_60_Days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Network_Recruitment__c.Status_Change_Date__c</offsetFromField>
            <timeLength>60</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
