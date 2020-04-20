<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Email_to_Owner_on_Milestone_Assignment</fullName>
        <description>Send Email to Owner on Milestone Assignment</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/New_Milestone_Assigned</template>
    </alerts>
    <rules>
        <fullName>Send Email to Owner on Milestone Assignment</fullName>
        <actions>
            <name>Send_Email_to_Owner_on_Milestone_Assignment</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>ISNEW()||ISCHANGED(  OwnerId  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
