<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>VSP_Premier_Tier_Order_Update</fullName>
        <description>Update the Order # to blank when Status is inactive.</description>
        <field>Order__c</field>
        <name>VSP Premier Tier Order Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>VSPR32_PremierTierToPros</fullName>
        <apiVersion>46.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/PremTier</endpointUrl>
        <fields>Effective_Date__c</fields>
        <fields>End_Date__c</fields>
        <fields>Id</fields>
        <fields>Name</fields>
        <fields>Tier_Name_Id__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>vikhta@vsp.com</integrationUser>
        <name>VSPR32_PremierTierToPros</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>VSP Premier Tier Clear Out Order</fullName>
        <actions>
            <name>VSP_Premier_Tier_Order_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Premier_Tier__c.Status__c</field>
            <operation>notEqual</operation>
            <value>Active</value>
        </criteriaItems>
        <description>Clears out order #</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR32_PremierTier</fullName>
        <actions>
            <name>VSPR32_PremierTierToPros</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to fields on the Premier Tier object to send Outbound Message to PROS tables.</description>
        <formula>AND((ISNEW() || ISCHANGED( Name )|| ISCHANGED( Effective_Date__c ) || ISCHANGED( End_Date__c   ) ||  ISCHANGED( Status__c )),  NOT(ISPICKVAL( Status__c , &apos;Future&apos;)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
