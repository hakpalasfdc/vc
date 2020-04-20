<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Inactivate_User</fullName>
        <field>IsActive</field>
        <literalValue>0</literalValue>
        <name>Inactivate User</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Last_Name</fullName>
        <field>LastName</field>
        <formula>PRIORVALUE(LastName)+ &quot;-INACTIVE&quot;</formula>
        <name>Update Last Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Terminated User Update FUTURE</fullName>
        <active>true</active>
        <description>Inactivates User and adds &quot;-INACTIVE&quot; following last name for individuals with a  Termination Effective Date/Times that is in the FUTURE</description>
        <formula>AND(  Termination_Effective_Date_Time__c &gt; NOW(), NOT(CONTAINS( LastName , &quot;-INACTIVE&quot;)  )  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Inactivate_User</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Last_Name</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>User.Termination_Effective_Date_Time__c</offsetFromField>
            <timeLength>0</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Terminated User Update PRIOR</fullName>
        <actions>
            <name>Inactivate_User</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Last_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Inactivates User and adds &quot;-INACTIVE&quot; following last name for individuals with a  Termination Effective Date/Times that is PRIOR to current date/time</description>
        <formula>AND( Termination_Effective_Date_Time__c &lt; NOW(), NOT(CONTAINS( LastName , &quot;-INACTIVE&quot;) ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
