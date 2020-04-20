<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Badgeville_Email_Alert</fullName>
        <description>Badgeville Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>katherineb@vsp.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Critical_Case_Escalation_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Opportunity_Name_Update</fullName>
        <field>Name</field>
        <formula>OpportunityNameDefault__c</formula>
        <name>Opportunity Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RequestedDeliveryDateUpdate</fullName>
        <description>Updates the Requested Delivery Date on the Opportunity</description>
        <field>Requested_Delivery_Date__c</field>
        <formula>Today() + 3</formula>
        <name>RequestedDeliveryDateUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Division_Brand_Update_Global</fullName>
        <field>Division_Brand__c</field>
        <literalValue>Global</literalValue>
        <name>SA Division Brand Update - Global</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Division_Brand_Update_Optics_Only</fullName>
        <field>Division_Brand__c</field>
        <literalValue>Optics Only</literalValue>
        <name>SA Division Brand Update - Optics Only</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Division_Update_Pathways_Exp</fullName>
        <field>Division_Brand__c</field>
        <literalValue>Pathways Expansion</literalValue>
        <name>SA Division Update - Pathways Exp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Up_Step_3_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 3 - Reject&apos;</formula>
        <name>SA Optics Only Status Up Step 3 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Upd_Step_1_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 1 - Reject&apos;</formula>
        <name>SA Optics Only Status Upd Step 1 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Upd_Step_2_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 2 - Reject&apos;</formula>
        <name>SA Optics Only Status Upd Step 2 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Upd_Step_4_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 4 - Reject&apos;</formula>
        <name>SA Optics Only Status Upd Step 4 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Upd_Step_5_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 5 - Reject&apos;</formula>
        <name>SA Optics Only Status Upd Step 5 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Only_Status_Update_Submitted</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Optics Only - Submitted&apos;</formula>
        <name>SA Optics Only Status Update - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Update_Step_4_Closed_Won</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 4 - Closed/Won&apos;</formula>
        <name>SA Optics Update Step 4 - Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Optics_Update_Step_5_Closed_Won</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Optics Only Step 5 - Closed/Won&apos;</formula>
        <name>SA Optics Update Step 5 - Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Sales_Stage_Optics_Only_Closed_Won</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>SA Sales Stage Optics Only - Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Sales_Stage_Update_Closed_Won</fullName>
        <field>StageName</field>
        <literalValue>Closed Won</literalValue>
        <name>SA Sales Stage Update - Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Sales_Stage_Update_Financial_Analysis</fullName>
        <field>StageName</field>
        <literalValue>Financial Analysis</literalValue>
        <name>SA Sales Stage Update Financial Analysis</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Stage_Update_Approved_Process</fullName>
        <field>StageName</field>
        <literalValue>Approved Process</literalValue>
        <name>SA Stage Update - Approved Process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Stage_Update_Propose</fullName>
        <field>StageName</field>
        <literalValue>Propose</literalValue>
        <name>SA Stage Update - Propose</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Stage_Update_Prospect</fullName>
        <field>StageName</field>
        <literalValue>Prospect</literalValue>
        <name>SA Stage Update - Prospect</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Stage_Update_Qualify</fullName>
        <description>Updates the Sales Stage to Qualify</description>
        <field>StageName</field>
        <literalValue>Qualify</literalValue>
        <name>SA Stage Update - Qualify</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Clear</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <name>SA Status Update Clear</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_1_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 1 - Reject&apos;</formula>
        <name>SA Status Update Step 1 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_2_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 2 - Reject&apos;</formula>
        <name>SA Status Update Step 2 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_3_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 3 - Reject&apos;</formula>
        <name>SA Status Update Step 3 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_4_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 4 - Reject&apos;</formula>
        <name>SA Status Update Step 4 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_5_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 5 - Reject&apos;</formula>
        <name>SA Status Update Step 5 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_6_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 6 - Reject&apos;</formula>
        <name>SA Status Update Step 6 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_7_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 7 - Reject&apos;</formula>
        <name>SA Status Update Step 7 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_8_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 8 - Reject&apos;</formula>
        <name>SA Status Update Step 8 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_9_Closed_Won</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 9 - Closed/Won&apos;</formula>
        <name>SA Status Update Step 9 - Closed Won</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Step_9_Reject</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Strategic Agreement Step 9 - Reject&apos;</formula>
        <name>SA Status Update Step 9 Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SA_Status_Update_Submitted</fullName>
        <field>Strategic_Agreement_Approval__c</field>
        <formula>&apos;Submitted&apos;</formula>
        <name>SA Status Update - Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Shift_Update_Project_Type_on_Opportunity</fullName>
        <field>Project_Type__c</field>
        <literalValue>Shift Series Phase 1</literalValue>
        <name>Shift Update Project Type on Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_SetOpportunityName</fullName>
        <field>Name</field>
        <formula>TEXT(Division_Brand__c) &amp; &quot; - &quot; &amp;  Product_Program__c &amp; &quot; - &quot; &amp;  TEXT(Planned_Closed_Month__c)</formula>
        <name>VSPR1_SetOpportunityName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_SetStartDateOnOpportunity</fullName>
        <field>Start_Date_New__c</field>
        <formula>Today()</formula>
        <name>VSPR1_SetStartDateOnOpportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_SetStartDateToNull</fullName>
        <field>Start_Date_New__c</field>
        <name>VSPR1_SetStartDateToNull</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Update_Program_Status</fullName>
        <field>Program_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>VSPR1_Update Program Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Reward_NBD_Opportunity_Points</fullName>
        <apiVersion>33.0</apiVersion>
        <endpointUrl>http://bvprod.herokuapp.com/applyBehavior?site_id=559ab8fa880af164a20004bd&amp;api_key=7dbbb92700891a2a06bdfcda06a91395&amp;sf_instance=na12&amp;behaviorId=a1CU0000003iMfZMAU;a1CU0000003iMfKMAU</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>Reward NBD Opportunity Points</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>Send_Survey_Upon_Sale_5_20_NBD</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>http://DESf</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>shrach@vsp.com</integrationUser>
        <name>Send Survey Upon Sale - 5/20 NBD</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>VSPR31_OpportunityOutboundMessageSAP</fullName>
        <apiVersion>46.0</apiVersion>
        <description>Outbound message to SAP to order Contact Lens Kits</description>
        <endpointUrl>https://test.com</endpointUrl>
        <fields>Account_Name__c</fields>
        <fields>Account_Phone_Number__c</fields>
        <fields>Account_Physical_City__c</fields>
        <fields>Account_Physical_State__c</fields>
        <fields>Account_Physical_Street_Address__c</fields>
        <fields>Account_Physical_ZIP_Code__c</fields>
        <fields>Contact_Lens_Kit_ID__c</fields>
        <fields>Id</fields>
        <fields>Quantity__c</fields>
        <fields>Requested_Delivery_Date__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR31_OpportunityOutboundMessageSAP</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>qualtrics__Qualtrics_Example_Outbound_Message</fullName>
        <apiVersion>34.0</apiVersion>
        <description>An example of how to setup an outbound message. 
The endpoint url is not valid and needs to be updated to a real out endpoint url.</description>
        <endpointUrl>https://survey.qualtrics.com/WRQualtricsServer/sfApi.php?r=outboundMessage&amp;u=UR_123456789&amp;s=SV_123456789&amp;t=TR_123456789</endpointUrl>
        <fields>Id</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>melinda.cordell@vsp.com</integrationUser>
        <name>Qualtrics Example Outbound Message</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Opportunity Name Update</fullName>
        <actions>
            <name>Opportunity_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Qualtrics Survey - 5%2F20 NBD</fullName>
        <actions>
            <name>Send_Survey_Upon_Sale_5_20_NBD</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Line_of_Business__c</field>
            <operation>equals</operation>
            <value>Optics</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Product_Program_Name__c</field>
            <operation>equals</operation>
            <value>5/20 NBD</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>VSP Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Shift Update Project Type on Closed Won</fullName>
        <actions>
            <name>Shift_Update_Project_Type_on_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>Closed Won</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Shift Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_PopulateStartDateOnOpportunity</fullName>
        <actions>
            <name>VSPR1_SetStartDateOnOpportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISPICKVAL(Product_Program_Name__c, &quot;&quot;))  &amp;&amp;   ISBLANK( Start_Date_New__c )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_SetDefaultOpportunityName</fullName>
        <actions>
            <name>VSPR1_SetOpportunityName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To generate Opportunity Name systematically. The value for this is the combination of Division/Brand + Product/Program + Planned Closed Month</description>
        <formula>NOT( AND( ISPICKVAL( Line_of_Business__c , &quot;&quot;), ISBLANK ( Product_Program__c ), ISPICKVAL(  Planned_Closed_Month__c, &quot;&quot;) )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_UnpopulateStartDate</fullName>
        <actions>
            <name>VSPR1_SetStartDateToNull</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISPICKVAL(Product_Program_Name__c, &quot;&quot;)) &amp;&amp;  OR(ISCHANGED(Product_Program_Name__c), ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_program status to In Progress</fullName>
        <actions>
            <name>VSPR1_Update_Program_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(    AND(    ISPICKVAL(PRIORVALUE(Product_Program_Name__c),&quot;&quot;),    ISCHANGED(Product_Program_Name__c)       ),   NOT(ISPICKVAL(Product_Program_Name__c,&quot;&quot;))   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR31_OpportunityOutboundMessageSAP</fullName>
        <actions>
            <name>VSPR31_OpportunityOutboundMessageSAP</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <description>Generates outbound message to SAP to order contact lens kits</description>
        <formula>AND(NOT(ISBLANK(TEXT(Contact_Lens_Kit__c))),  				ISBLANK(Shipping_Status__c), 				ISBLANK(Tracking_Info__c), 				RecordType.Name = &apos;VSP Opportunity&apos;,  				OR(ISCHANGED(StageName),ISNEW()))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR33_RequestedDeliveryDateDefault</fullName>
        <actions>
            <name>RequestedDeliveryDateUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Division_Brand__c</field>
            <operation>equals</operation>
            <value>Contact Lenses</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Contact_Lens_Kit__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Requested_Delivery_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Shipping_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>VSP Opportunity</value>
        </criteriaItems>
        <description>Defaults the Requested Delivery Date field on the Opportunity</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>qualtrics__Qualtrics Example Survey Rule</fullName>
        <actions>
            <name>qualtrics__Qualtrics_Example_Outbound_Message</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.IsClosed</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>An example of how to setup a rule to trigger a survey using an outbound message. 
In this example when an opportunity is closed we want to email the opportunity and see how their interaction with the sales representative went.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
