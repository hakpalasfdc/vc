<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Qualtrics_Date_Responded</fullName>
        <description>Updates the Date Responded field to Today.</description>
        <field>qualtrics__Date_Responded__c</field>
        <formula>Today()</formula>
        <name>Qualtrics Date Responded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR24_Qualtrics Date Responded</fullName>
        <actions>
            <name>Qualtrics_Date_Responded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>qualtrics__Survey_Response__c.CreatedDate</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Day the survey was completed.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
