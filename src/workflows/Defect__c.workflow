<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Defect_Updated</fullName>
        <description>Defect Updated</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melinda.cordell@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>randfl@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shrach@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/Defect_Updated</template>
    </alerts>
    <alerts>
        <fullName>New_Defect_Created</fullName>
        <description>New Defect Created</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>melinda.cordell@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>randfl@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>shrach@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/New_Defect_Created</template>
    </alerts>
    <rules>
        <fullName>Defect Updated</fullName>
        <actions>
            <name>Defect_Updated</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Identifies when a Defect has been updated</description>
        <formula>ISCHANGED( LastModifiedDate )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Defect Created</fullName>
        <actions>
            <name>New_Defect_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Defect__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Identifies when a new Defect has been logged</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
