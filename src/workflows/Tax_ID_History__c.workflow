<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>VSPR19b_TaxIDHistory</fullName>
        <apiVersion>42.0</apiVersion>
        <description>Outbound Message for Tax ID History for PROS Data Integration</description>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/TaxIdUpd</endpointUrl>
        <fields>End_Date__c</fields>
        <fields>Id</fields>
        <fields>Tax_ID__c</fields>
        <fields>Vision_Care_Key__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR19b_TaxIDHistory</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>VSPR19b_TaxIDHistoryOutboundMsg</fullName>
        <actions>
            <name>VSPR19b_TaxIDHistory</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Tax_ID_History__c.Tax_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Tax_ID_History__c.Vision_Care_Key__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Sends outbound message when a Tax ID Change record is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
