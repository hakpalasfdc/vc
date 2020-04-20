<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Owner_on_Risk_Assignment</fullName>
        <description>Send Email to Owner on Risk Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Owner__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Risk_Assigned</template>
    </alerts>
    <rules>
        <fullName>Send Email to Owner on Risk Assignment</fullName>
        <actions>
            <name>Send_Email_to_Owner_on_Risk_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISNEW() || ISCHANGED(  Owner__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
