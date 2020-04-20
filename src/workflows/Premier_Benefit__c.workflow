<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <outboundMessages>
        <fullName>VSPR32_PremierBenefitToPros</fullName>
        <apiVersion>46.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/PremBnft</endpointUrl>
        <fields>Benefit_Amount__c</fields>
        <fields>Benefit_Category__c</fields>
        <fields>Benefit_Checkbox__c</fields>
        <fields>Benefit_Discount__c</fields>
        <fields>Benefit_Type__c</fields>
        <fields>Description__c</fields>
        <fields>Effective_Date__c</fields>
        <fields>End_Date__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>vikhta@vsp.com</integrationUser>
        <name>VSPR32_PremierBenefitToPros</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>VSPR32_PremierBenefit</fullName>
        <actions>
            <name>VSPR32_PremierBenefitToPros</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to fields on the Premier Benefit object to send Outbound Message to PROS tables.</description>
        <formula>AND(OR( ISNEW(), ISCHANGED( End_Date__c ),  ISCHANGED( Status__c )),  NOT(ISPICKVAL( Status__c , &apos;Future&apos;)  ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
