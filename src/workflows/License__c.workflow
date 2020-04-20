<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Upper_Case</fullName>
        <field>License_Number__c</field>
        <formula>UPPER(License_Number__c)</formula>
        <name>Upper Case</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR16 License Upper Case</fullName>
        <actions>
            <name>Upper_Case</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>License__c.License_Number__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>License Number must be upper case</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
