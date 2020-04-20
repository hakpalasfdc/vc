<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>All_emails_field_update</fullName>
        <field>All_Emails__c</field>
        <formula>Email &amp; &apos;-&apos; &amp; Eyeconic_Email__c  &amp; &apos;-&apos; &amp; Other_Email__c &amp; &apos;-&apos; &amp; Personal_Email__c</formula>
        <name>All emails field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ClearBypassValidationRules</fullName>
        <field>Bypass_VC_Validation_Rules__c</field>
        <literalValue>0</literalValue>
        <name>ClearBypassValidationRules</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Eyeconic_Email_to_Lowercase</fullName>
        <field>Eyeconic_Email__c</field>
        <formula>LOWER( Eyeconic_Email__c )</formula>
        <name>Eyeconic Email to Lowercase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Email_to_Lowercase</fullName>
        <field>Other_Email__c</field>
        <formula>LOWER( Other_Email__c )</formula>
        <name>Other Email to Lowercase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Personal_Email_to_Lowercase</fullName>
        <field>Personal_Email__c</field>
        <formula>LOWER( Personal_Email__c )</formula>
        <name>Personal Email to Lowercase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Primary_Contact_Email_to_Lowercase</fullName>
        <field>Email</field>
        <formula>LOWER( Email )</formula>
        <name>Primary Contact Email to Lowercase</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR19b_CheckVisionCareProviderContact</fullName>
        <field>Vision_Care_Network_Provider__c</field>
        <literalValue>1</literalValue>
        <name>VSPR19b_CheckVisionCareProviderContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR19b_UncheckVisionCareProviderContact</fullName>
        <field>Vision_Care_Network_Provider__c</field>
        <literalValue>0</literalValue>
        <name>VSPR19b_UncheckVisionCareProviderContact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_All_Emails_Field_Update</fullName>
        <field>All_Emails__c</field>
        <formula>Email &amp; &apos;-&apos; &amp; Eyeconic_Email__c  &amp; &apos;-&apos; &amp; Other_Email__c &amp; &apos;-&apos; &amp; Personal_Email__c</formula>
        <name>VSPR23_All_Emails_Field_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR23_Update_Contact_Custom_Birthdate</fullName>
        <field>Birthdate__c</field>
        <formula>DATEVALUE(DOB_Text__c)</formula>
        <name>VSPR23_Update Contact Custom Birthdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR3_1_UpdateMonthEmailAdded</fullName>
        <field>New_Email_Address_Added__c</field>
        <formula>TODAY()</formula>
        <name>VSPR3.1_UpdateMonthEmailAdded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>VSPR19b_Contact</fullName>
        <apiVersion>40.0</apiVersion>
        <description>Outbound Message for Contacts for PROS Data Integration</description>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/Contact</endpointUrl>
        <fields>CAQH_ID__c</fields>
        <fields>Committee_Date__c</fields>
        <fields>Degree__c</fields>
        <fields>Doctor_ID__c</fields>
        <fields>Doctor_Type__c</fields>
        <fields>Email</fields>
        <fields>Facility_Type__c</fields>
        <fields>FirstName</fields>
        <fields>Id</fields>
        <fields>LastName</fields>
        <fields>Middle_Initial__c</fields>
        <fields>NPI__c</fields>
        <fields>Previous_Doctor_ID_1__c</fields>
        <fields>Previous_Doctor_ID_2__c</fields>
        <fields>Previous_Effective_Date_1__c</fields>
        <fields>Previous_Effective_Date_2__c</fields>
        <fields>Previous_End_Date_1__c</fields>
        <fields>Previous_End_Date_2__c</fields>
        <fields>VSP_Term_Reason_Code__c</fields>
        <fields>Vision_Care_Effective_Date__c</fields>
        <fields>Vision_Care_End_Date__c</fields>
        <fields>Vision_Care_Primary_Location_Key__c</fields>
        <fields>Vision_Care_Provider_Advocate__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR19b_Contact</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Convert Emails to Lowercase</fullName>
        <actions>
            <name>Eyeconic_Email_to_Lowercase</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Email_to_Lowercase</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Personal_Email_to_Lowercase</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Primary_Contact_Email_to_Lowercase</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4</booleanFilter>
        <criteriaItems>
            <field>Contact.Email</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Other_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Personal_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Eyeconic_Email__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Converts all email address fields on Contact to lowercase when created or edited.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_CheckVisionCareProvideronContact</fullName>
        <actions>
            <name>VSPR19b_CheckVisionCareProviderContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>VC__c = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_Contact</fullName>
        <actions>
            <name>VSPR19b_Contact</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to Vision Care fields on the Contact record to send Outbound Message to PROS tables.</description>
        <formula>RecordType.Name == &apos;Eye Care Professional&apos; &amp;&amp;  NOT(ISBLANK(Vision_Care_Effective_Date__c))  &amp;&amp;  OR(Vision_Care_End_Date__c &gt;=TODAY(), ISBLANK(Vision_Care_End_Date__c)) &amp;&amp;  ( ISNEW()|| ISCHANGED( AccountId ) ||   ISCHANGED(Account_Vision_Care_Location_Key__c) ||  ISCHANGED( CAQH_ID__c )||    ISCHANGED( Committee_Date__c )||    ISCHANGED( Degree__c ) ||   ISCHANGED( Doctor_ID__c )||    ISCHANGED( Doctor_Type__c )||    ISCHANGED( Email )||    ISCHANGED( Facility_Type__c)||   ISCHANGED( FirstName )||    ISCHANGED( LastName )||    ISCHANGED( Middle_Initial__c )||    ISCHANGED( NPI__c )||    ISCHANGED( Previous_Doctor_ID_1__c )||   ISCHANGED( Previous_Effective_Date_1__c )||    ISCHANGED( Previous_End_Date_1__c )||   ISCHANGED( Previous_Doctor_ID_2__c )||   ISCHANGED( Previous_Effective_Date_2__c )||   ISCHANGED( Previous_End_Date_2__c )||   ISCHANGED( Vision_Care_Effective_Date__c )||    ISCHANGED( Vision_Care_End_Date__c )  ||  ISCHANGED( Vision_Care_Provider_Advocate__c )||    ISCHANGED( Vision_Care_Term_Reason__c )|| ISCHANGED( Update__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_DeleteValidationRuleBypass</fullName>
        <actions>
            <name>ClearBypassValidationRules</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.Bypass_VC_Validation_Rules__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Deletes the checkbox set by Apex classes that bypasses custom validation rules</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_UncheckVisionCareProvideronContact</fullName>
        <actions>
            <name>VSPR19b_UncheckVisionCareProviderContact</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>VC__c = FALSE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Concatenate_All_Emails_Fields</fullName>
        <actions>
            <name>VSPR23_All_Emails_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(Id))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_Populate Contact Birthdate</fullName>
        <actions>
            <name>VSPR23_Update_Contact_Custom_Birthdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(DOB_Text__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR3%2E1_UpdateMonthEmailAdded</fullName>
        <actions>
            <name>VSPR3_1_UpdateMonthEmailAdded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update field with the date every time a new email address is added to the Account record. For Reporting.</description>
        <formula>( (ISCHANGED(Email) &amp;&amp; ISBLANK(PRIORVALUE(Email))) || (ISNEW() &amp;&amp; NOT(ISBLANK(Email))) ) &amp;&amp; (  ISNULL(New_Email_Address_Added__c)  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
