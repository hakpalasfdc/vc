<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Contact_Next_Recred_Date</fullName>
        <field>Next_Recred_Date__c</field>
        <formula>IF(
  AND(
    MONTH(  Committee_Date__c ) = 2,
    DAY(  Committee_Date__c ) = 29,
    NOT( 
      OR( 
        MOD( YEAR(  Committee_Date__c ), 400 ) = 0, 
        AND( 
          MOD( YEAR(  Committee_Date__c ), 4 ) = 0,
          MOD( YEAR(  Committee_Date__c ), 100 ) != 0
        )
      )
    ) 
  ),
  DATE( YEAR(  Committee_Date__c ) + 3, 3, 1),
  DATE( YEAR(  Committee_Date__c ) + 3, MONTH(  Committee_Date__c ), DAY(  Committee_Date__c ) )
)</formula>
        <name>Update Contact Next Recred Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Provider_Name__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credentialing_Instance_Status</fullName>
        <description>Update the Credentialing Instance Status to Closed</description>
        <field>Credentialing_Instance_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Update Credentialing Instance Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credentialing_Next_Recred_Date</fullName>
        <description>Update Next Recred Date on Credentialing Instance.</description>
        <field>Next_Recred_Date__c</field>
        <formula>IF(
AND(
MONTH( Committee_Date__c ) = 2,
DAY( Committee_Date__c ) = 29,
NOT(
OR(
MOD( YEAR( Committee_Date__c ), 400 ) = 0,
AND(
MOD( YEAR( Committee_Date__c ), 4 ) = 0,
MOD( YEAR( Committee_Date__c ), 100 ) != 0
)
)
)
),
DATE( YEAR( Committee_Date__c ) + 3, 3, 1),
DATE( YEAR( Committee_Date__c ) + 3, MONTH( Committee_Date__c ), DAY( Committee_Date__c ) )
)</formula>
        <name>Update Credentialing Next Recred Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Credentialing_Status</fullName>
        <description>Change Credentialing Status to Committee Complete</description>
        <field>Credentialing_Status__c</field>
        <literalValue>Committee Complete</literalValue>
        <name>Update Credentialing Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR12_Update Credentialing Data</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Credentialing__c.Credentialing_Status__c</field>
            <operation>equals</operation>
            <value>Committee</value>
        </criteriaItems>
        <description>Update Credentialing Data Elements once Committee Date has passed.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Update_Contact_Next_Recred_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Credentialing_Instance_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Credentialing_Next_Recred_Date</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Update_Credentialing_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Credentialing__c.Committee_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>VSPR15_Update Credentialing Term Reason</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Credentialing__c.Committee_Status__c</field>
            <operation>equals</operation>
            <value>Recommend Denial</value>
        </criteriaItems>
        <description>Update Credentialing Term Reason if Committee Status is changed to &quot;Recommended Denial&quot;</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
