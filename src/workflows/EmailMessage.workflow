<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>First_Email_Response_On_Case_to_False</fullName>
        <field>First_Email_Response__c</field>
        <literalValue>0</literalValue>
        <name>First Email Response On Case to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Date_Time_of_First_Email_Response</fullName>
        <field>Date_Time_First_Email_Response__c</field>
        <formula>NOW()</formula>
        <name>Set Date/Time of First Email Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR2UncheckOriginalEmailField</fullName>
        <description>Uncheck Original Email field on Case when first Email reply is changed to Read Status.</description>
        <field>Original_Email__c</field>
        <literalValue>0</literalValue>
        <name>VSPR2UncheckOriginalEmailField</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>First Email Response On Case</fullName>
        <actions>
            <name>First_Email_Response_On_Case_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Date_Time_of_First_Email_Response</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.First_Email_Response__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>equals</operation>
            <value>Sent</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR2_Uncheck Original Email Field on Case</fullName>
        <actions>
            <name>VSPR2UncheckOriginalEmailField</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>EmailMessage.Status</field>
            <operation>notEqual</operation>
            <value>New</value>
        </criteriaItems>
        <description>Uncheck Original Email field on Case when the Email Status is not New.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
