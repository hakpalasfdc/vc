<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>New_Request_has_been_created</fullName>
        <description>New Request has been created.</description>
        <protected>false</protected>
        <recipients>
            <recipient>davime@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>trenag@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PMO/New_Request</template>
    </alerts>
    <fieldUpdates>
        <fullName>Business_Driver_Count_2</fullName>
        <field>Business_Benefit__c</field>
        <literalValue>Medium</literalValue>
        <name>Business Driver Count 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Driver_Count_3</fullName>
        <field>Business_Benefit__c</field>
        <literalValue>High</literalValue>
        <name>Business Driver Count 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Business_Need</fullName>
        <field>Business_Benefit__c</field>
        <literalValue>Low</literalValue>
        <name>Business Need</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOB1</fullName>
        <field>Line_of_Business_Impact__c</field>
        <literalValue>Low</literalValue>
        <name>LOB1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOB_2</fullName>
        <field>Line_of_Business_Impact__c</field>
        <literalValue>Medium</literalValue>
        <name>LOB 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LOB_3</fullName>
        <field>Line_of_Business_Impact__c</field>
        <literalValue>High</literalValue>
        <name>LOB 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Legal_and_Greater_than_2</fullName>
        <field>Total_Priority__c</field>
        <literalValue>High</literalValue>
        <name>Legal and Greater than 2.5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Populate_Non_Contingency_Estimate</fullName>
        <field>Non_Contingency_Estimate__c</field>
        <formula>Req__c + Des__c + BUT__c + SIT__c + UAT__c + TrnDep__c + Adapt__c</formula>
        <name>Populate Non-Contingency Estimate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Priority_2</fullName>
        <field>Total_Priority__c</field>
        <literalValue>Medium</literalValue>
        <name>Total Priority 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Total_Priority_3</fullName>
        <field>Total_Priority__c</field>
        <literalValue>Low</literalValue>
        <name>Total Priority 3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Business Driver Count</fullName>
        <actions>
            <name>Business_Need</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Count_on_Business_Drivers__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Business Driver Count 2</fullName>
        <actions>
            <name>Business_Driver_Count_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Count_on_Business_Drivers__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Business Driver Count 3</fullName>
        <actions>
            <name>Business_Driver_Count_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Count_on_Business_Drivers__c</field>
            <operation>greaterOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LOB 1</fullName>
        <actions>
            <name>LOB1</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Number_Of_LOBs__c</field>
            <operation>equals</operation>
            <value>1</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LOB 3</fullName>
        <actions>
            <name>LOB_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Number_Of_LOBs__c</field>
            <operation>greaterOrEqual</operation>
            <value>3</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>LOB2</fullName>
        <actions>
            <name>LOB_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Number_Of_LOBs__c</field>
            <operation>equals</operation>
            <value>2</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Legal and Greater than 2</fullName>
        <actions>
            <name>Legal_and_Greater_than_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Request__c.Legal_Compliance__c</field>
            <operation>equals</operation>
            <value>High</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Total_Priority_Ranking__c</field>
            <operation>greaterOrEqual</operation>
            <value>2.5</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New Request</fullName>
        <actions>
            <name>New_Request_has_been_created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Request_Title__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Identifies when a new request is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Populate Non-Contingency Estimate</fullName>
        <actions>
            <name>Populate_Non_Contingency_Estimate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>Id &lt;&gt; null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Priority</fullName>
        <actions>
            <name>Total_Priority_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2)</booleanFilter>
        <criteriaItems>
            <field>Request__c.Total_Priority_Ranking__c</field>
            <operation>greaterThan</operation>
            <value>1.5</value>
        </criteriaItems>
        <criteriaItems>
            <field>Request__c.Total_Priority_Ranking__c</field>
            <operation>lessOrEqual</operation>
            <value>2.49</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Total Priority 3</fullName>
        <actions>
            <name>Total_Priority_3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Request__c.Total_Priority_Ranking__c</field>
            <operation>lessOrEqual</operation>
            <value>1.49</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
