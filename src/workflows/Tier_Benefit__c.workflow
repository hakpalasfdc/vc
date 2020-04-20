<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>VSPR32_TierBenefitToPros</fullName>
        <apiVersion>46.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/TierBnft</endpointUrl>
        <fields>Benefit__c</fields>
        <fields>Id</fields>
        <fields>Premier_Tier__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>vikhta@vsp.com</integrationUser>
        <name>VSPR32_TierBenefitToPros</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>VSPR32_TierBenefit</fullName>
        <actions>
            <name>VSPR32_TierBenefitToPros</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to fields on the Tier Benefit object to send Outbound Message to PROS tables.</description>
        <formula>AND(OR( ISNEW() , ISCHANGED(Send_Outbound_Message__c )  ),  Send_Outbound_Message__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
