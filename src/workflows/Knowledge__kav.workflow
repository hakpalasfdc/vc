<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Article_Revision_Request</fullName>
        <description>Article Revision Request</description>
        <protected>false</protected>
        <recipients>
            <recipient>Knowledge_Authors</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Article_Update_Approval</template>
    </alerts>
    <fieldUpdates>
        <fullName>Feedback_Not_Submitted</fullName>
        <field>Feedback_Submitted__c</field>
        <literalValue>0</literalValue>
        <name>Feedback Not Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Feedback_Submitted</fullName>
        <field>Feedback_Submitted__c</field>
        <literalValue>1</literalValue>
        <name>Feedback Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Chat_Answers</fullName>
        <field>Chat_Answer__c</field>
        <formula>Article_Details__c</formula>
        <name>Populate Chat Answers</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <knowledgePublishes>
        <fullName>Publish_Revision</fullName>
        <action>PublishAsNew</action>
        <label>Publish Revision</label>
        <language>en_US</language>
        <protected>false</protected>
    </knowledgePublishes>
    <rules>
        <fullName>VSPR17_PopulateChatAnswers</fullName>
        <actions>
            <name>Populate_Chat_Answers</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will be used to populate the Chat Answers field when the Article Details field is edited</description>
        <formula>AND(  RecordType.Name  == &apos;Universal Service&apos;,OR(ISNEW(), ISCHANGED( Article_Details__c)))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
