<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_GAAT_Members</fullName>
        <description>Email to GAAT Members</description>
        <protected>false</protected>
        <recipients>
            <recipient>gaat.member@vsp.production.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/Account_Approval</template>
    </alerts>
    <alerts>
        <fullName>VSPR1_Email_Account_Owner_if_Account_is_Approved</fullName>
        <description>VSPR1_Email Account Owner if Account is Approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR1_Approved_Account_Email</template>
    </alerts>
    <alerts>
        <fullName>VSPR1_Email_Account_Owner_if_Account_is_not_Approved</fullName>
        <description>VSPR1_Email Account Owner if Account is not Approved</description>
        <protected>false</protected>
        <recipients>
            <type>accountOwner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/VSPR1_Not_Approved_Account_Email</template>
    </alerts>
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
        <fullName>CopyTaxIDtoIRSTaxID</fullName>
        <field>IRS_Tax_ID__c</field>
        <formula>Tax_ID__c</formula>
        <name>CopyTaxIDtoIRSTaxID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PopulateIRSName</fullName>
        <field>IRS_Name__c</field>
        <formula>Name</formula>
        <name>PopulateIRSName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingCity</fullName>
        <description>Copy Physical Address to Vision Care Mailing Address fields</description>
        <field>BillingCity</field>
        <formula>ShippingCity</formula>
        <name>UpdateMailingCity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingState</fullName>
        <field>BillingState</field>
        <formula>ShippingState</formula>
        <name>UpdateMailingState</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingStreet</fullName>
        <field>BillingStreet</field>
        <formula>ShippingStreet</formula>
        <name>UpdateMailingStreet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateMailingZipcode</fullName>
        <field>BillingPostalCode</field>
        <formula>ShippingPostalCode</formula>
        <name>UpdateMailingZipcode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Friday_Business_Hours</fullName>
        <field>Friday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Friday_Open__c)), &apos;Fri Closed,&apos;, &apos;Fri &apos; + TEXT(Friday_Open__c) + &apos;-&apos; + TEXT(Friday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Friday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Monday_Business_Hours</fullName>
        <field>Monday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Monday_Open__c)), &apos;Mon Closed,&apos;, &apos;Mon &apos; + TEXT(Monday_Open__c) + &apos;-&apos; + TEXT(Monday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Monday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Saturday_Business_Hours</fullName>
        <field>Saturday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Saturday_Open__c)), &apos;Sat Closed,&apos;, &apos;Sat &apos; + TEXT(Saturday_Open__c) + &apos;-&apos; + TEXT(Saturday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Saturday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Sunday_Business_Hours</fullName>
        <field>Sunday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Sunday_Open__c)), &apos;Sun Closed&apos;, &apos;Sun &apos; + TEXT(Sunday_Open__c) + &apos;-&apos; + TEXT(Sunday_Close__c))</formula>
        <name>Update Sunday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Thursday_Business_Hours</fullName>
        <field>Thursday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Thursday_Open__c)), &apos;Thu Closed,&apos;, &apos;Thu &apos; + TEXT(Thursday_Open__c) + &apos;-&apos; + TEXT(Thursday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Thursday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Tuesday_Business_Hours</fullName>
        <field>Tuesday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Tuesday_Open__c)), &apos;Tue Closed,&apos;, &apos;Tue &apos; + TEXT(Tuesday_Open__c) + &apos;-&apos; + TEXT(Tuesday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Tuesday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Wednesday_Business_Hours</fullName>
        <field>Wednesday_Business_Hours__c</field>
        <formula>IF (ISBLANK(TEXT(Wednesday_Open__c)), &apos;Wed Closed,&apos;, &apos;Wed &apos; + TEXT(Wednesday_Open__c) + &apos;-&apos; + TEXT(Wednesday_Close__c)+&apos;,&apos;)</formula>
        <name>Update Wednesday Business Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VC_Identifying_City_Update</fullName>
        <field>Vision_Care_Identifying_City__c</field>
        <formula>ShippingCity</formula>
        <name>VC Identifying City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VC_Identifying_State</fullName>
        <field>Vision_Care_Identifying_State__c</field>
        <formula>ShippingState</formula>
        <name>VC Identifying State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VC_Identifying_Street_Update</fullName>
        <field>Vision_Care_Identifying_Street__c</field>
        <formula>ShippingStreet</formula>
        <name>VC Identifying Street Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VC_Identifying_Zip_Code</fullName>
        <field>Vision_Care_Identifying_Zip_Code__c</field>
        <formula>ShippingPostalCode</formula>
        <name>VC Identifying Zip Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR10_UpdateVCNetworkAdmin</fullName>
        <description>Updates Vision Care Network Administrator field on Account with specific User Territory Code based on Physical (Shipping) State or Zip Code on Account.</description>
        <field>VC_EDS_NA__c</field>
        <formula>/*****************IF Parent Company is Blank *****************/
IF(ISBLANK(TEXT(Parent_Company__c)), 
CASE(ShippingState, 
&quot;AK&quot;, &quot;PSPND1A010&quot;,
&quot;AL&quot;, &quot;PSPND1A003&quot;,
&quot;AR&quot;, &quot;PSPND1A014&quot;,
&quot;AZ&quot;, &quot;PSPND1A004&quot;,
&quot;CO&quot;, &quot;PSPND1A004&quot;,
&quot;CT&quot;, &quot;PSPND1A014&quot;,
&quot;DC&quot;, &quot;PSPND1A006&quot;,
&quot;DE&quot;, &quot;PSPND1A006&quot;,
&quot;FL&quot;, &quot;PSPND1A003&quot;,
&quot;GA&quot;, &quot;PSPND1A003&quot;,
&quot;GU&quot;, &quot;PSPND1A010&quot;,
&quot;HI&quot;, &quot;PSPND1A010&quot;,
&quot;IA&quot;, &quot;PSPND1A008&quot;,
&quot;ID&quot;, &quot;PSPND1A010&quot;,
&quot;IL&quot;, &quot;PSPND1A004&quot;,
&quot;IN&quot;, &quot;PSPND1A013&quot;,
&quot;KS&quot;, &quot;PSPND1A004&quot;,
&quot;KY&quot;, &quot;PSPND1A009&quot;,
&quot;LA&quot;, &quot;PSPND1A014&quot;,
&quot;MA&quot;, &quot;PSPND1A014&quot;,
&quot;MD&quot;, &quot;PSPND1A009&quot;,
&quot;ME&quot;, &quot;PSPND1A013&quot;,
&quot;MI&quot;, &quot;PSPND1A005&quot;,
&quot;MN&quot;, &quot;PSPND1A007&quot;,
&quot;MO&quot;, &quot;PSPND1A004&quot;,
&quot;MS&quot;, &quot;PSPND1A014&quot;,
&quot;MT&quot;, &quot;PSPND1A008&quot;,
&quot;NC&quot;, &quot;PSPND1A007&quot;,
&quot;ND&quot;, &quot;PSPND1A008&quot;,
&quot;NE&quot;, &quot;PSPND1A008&quot;,
&quot;NH&quot;, &quot;PSPND1A006&quot;,
&quot;NJ&quot;, &quot;PSPND1A007&quot;,
&quot;NM&quot;, &quot;PSPND1A008&quot;,
&quot;NV&quot;, &quot;PSPND1A001&quot;,
&quot;NY&quot;, &quot;PSPND1A013&quot;,
&quot;OH&quot;, &quot;PSPND1A005&quot;,
&quot;OK&quot;, &quot;PSPND1A006&quot;,
&quot;OR&quot;, &quot;PSPND1A015&quot;,
&quot;PA&quot;, &quot;PSPND1A014&quot;,
&quot;PR&quot;, &quot;PSPND1A003&quot;,
&quot;RI&quot;, &quot;PSPND1A013&quot;,
&quot;SC&quot;, &quot;PSPND1A007&quot;,
&quot;SD&quot;, &quot;PSPND1A008&quot;,
&quot;TN&quot;, &quot;PSPND1A013&quot;,
&quot;TX&quot;, &quot;PSPND1A006&quot;,
&quot;VI&quot;, &quot;PSPND1A003&quot;,
&quot;UT&quot;, &quot;PSPND1A010&quot;,
&quot;VA&quot;, &quot;PSPND1A009&quot;,
&quot;VT&quot;, &quot;PSPND1A007&quot;,
&quot;WA&quot;, &quot;PSPND1A010&quot;,
&quot;WI&quot;, &quot;PSPND1A007&quot;,
&quot;WV&quot;, &quot;PSPND1A009&quot;,
&quot;WY&quot;, &quot;PSPND1A008&quot;,
&quot;CA&quot;, (IF(LEFT(ShippingPostalCode, 2) = &quot;90&quot;, &quot;PSPND1A001&quot;,
IF(LEFT(ShippingPostalCode, 2) = &quot;91&quot;, &quot;PSPND1A001&quot;,
IF(LEFT(ShippingPostalCode, 2) = &quot;92&quot;, &quot;PSPND1A001&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;93&quot;, &quot;PSPND1A001&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;94&quot;, &quot;PSPND1A015&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;95&quot;, &quot;PSPND1A015&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;96&quot;, &quot;PSPND1A015&quot;,&quot;&quot;)))))))),
&quot;&quot; ), 
/***********IF Parent Company is PERL - Pearle Vision Location ***************************/
			IF(ISPICKVAL(Parent_Company__c, &quot;PERL - Pearle Vision Location&quot;),
					CASE(ShippingState, 
&quot;AK&quot;, &quot;PSPND1A001&quot;, 
&quot;AL&quot;, &quot;PSPND1A014&quot;, 
&quot;AR&quot;, &quot;PSPND1A001&quot;, 
&quot;AZ&quot;, &quot;PSPND1A001&quot;, 
&quot;CO&quot;, &quot;PSPND1A001&quot;, 
&quot;CT&quot;, &quot;PSPND1A014&quot;, 
&quot;DC&quot;, &quot;PSPND1A014&quot;, 
&quot;DE&quot;, &quot;PSPND1A014&quot;, 
&quot;FL&quot;, &quot;PSPND1A014&quot;, 
&quot;GA&quot;, &quot;PSPND1A014&quot;, 
&quot;GU&quot;, &quot;PSPND1A001&quot;, 
&quot;HI&quot;, &quot;PSPND1A001&quot;, 
&quot;IA&quot;, &quot;PSPND1A001&quot;, 
&quot;ID&quot;, &quot;PSPND1A001&quot;, 
&quot;IL&quot;, &quot;PSPND1A001&quot;, 
&quot;IN&quot;, &quot;PSPND1A001&quot;, 
&quot;KS&quot;, &quot;PSPND1A001&quot;, 
&quot;KY&quot;, &quot;PSPND1A001&quot;, 
&quot;LA&quot;, &quot;PSPND1A001&quot;, 
&quot;MA&quot;, &quot;PSPND1A014&quot;, 
&quot;MD&quot;, &quot;PSPND1A014&quot;, 
&quot;ME&quot;, &quot;PSPND1A014&quot;, 
&quot;MI&quot;, &quot;PSPND1A014&quot;, 
&quot;MN&quot;, &quot;PSPND1A001&quot;, 
&quot;MO&quot;, &quot;PSPND1A001&quot;, 
&quot;MS&quot;, &quot;PSPND1A001&quot;, 
&quot;MT&quot;, &quot;PSPND1A001&quot;, 
&quot;NC&quot;, &quot;PSPND1A014&quot;, 
&quot;ND&quot;, &quot;PSPND1A001&quot;, 
&quot;NE&quot;, &quot;PSPND1A001&quot;, 
&quot;NH&quot;, &quot;PSPND1A014&quot;, 
&quot;NJ&quot;, &quot;PSPND1A014&quot;, 
&quot;NM&quot;, &quot;PSPND1A001&quot;, 
&quot;NV&quot;, &quot;PSPND1A001&quot;, 
&quot;NY&quot;, &quot;PSPND1A014&quot;, 
&quot;OH&quot;, &quot;PSPND1A014&quot;, 
&quot;OK&quot;, &quot;PSPND1A001&quot;, 
&quot;OR&quot;, &quot;PSPND1A001&quot;, 
&quot;PA&quot;, &quot;PSPND1A014&quot;, 
&quot;PR&quot;, &quot;PSPND1A014&quot;, 
&quot;RI&quot;, &quot;PSPND1A014&quot;, 
&quot;SC&quot;, &quot;PSPND1A014&quot;, 
&quot;SD&quot;, &quot;PSPND1A001&quot;, 
&quot;TN&quot;, &quot;PSPND1A001&quot;, 
&quot;TX&quot;, &quot;PSPND1A001&quot;, 
&quot;VI&quot;, &quot;PSPND1A014&quot;, 
&quot;UT&quot;, &quot;PSPND1A001&quot;, 
&quot;VA&quot;, &quot;PSPND1A014&quot;, 
&quot;VT&quot;, &quot;PSPND1A014&quot;, 
&quot;WA&quot;, &quot;PSPND1A001&quot;, 
&quot;WI&quot;, &quot;PSPND1A001&quot;, 
&quot;WV&quot;, &quot;PSPND1A014&quot;, 
&quot;WY&quot;, &quot;PSPND1A001&quot;, 
&quot;CA&quot;, (IF(LEFT(ShippingPostalCode, 2) = &quot;90&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) = &quot;91&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) = &quot;92&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) =&quot;93&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) =&quot;94&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) =&quot;95&quot;, &quot;PSPND1A001&quot;, 
IF(LEFT(ShippingPostalCode, 2) =&quot;96&quot;, &quot;PSPND1A001&quot;,&quot;&quot;)))))))), 
&quot;&quot; ),
				&quot;&quot;))</formula>
        <name>VSPR10_UpdateVCNetworkAdmin</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR19_TaxIDLastFour</fullName>
        <field>Tax_ID_Last_4__c</field>
        <formula>TRIM(RIGHT( Tax_ID__c, 4))</formula>
        <name>VSPR19_TaxIDLastFour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR19b_TaxIDLastFour</fullName>
        <field>Tax_ID_Last_4__c</field>
        <formula>TRIM(RIGHT( Tax_ID__c, 4))</formula>
        <name>VSPR19b_TaxIDLastFour</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_10_to_25000_Marchon_Target</fullName>
        <field>Accounts_within_10_of_Target__c</field>
        <literalValue>1</literalValue>
        <name>VSPR1_10% to 25000 Marchon Target</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_EHM_less</fullName>
        <field>EHM_5_or_Greater__c</field>
        <literalValue>0</literalValue>
        <name>VSPR1_EHM % less</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_EHM_or_greater</fullName>
        <field>EHM_5_or_Greater__c</field>
        <literalValue>1</literalValue>
        <name>VSPR1_EHM % or greater</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Set_Status_to_Active</fullName>
        <description>Update Account status field into Active</description>
        <field>Status__c</field>
        <literalValue>A</literalValue>
        <name>VSPR1 Set Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Set_Status_to_Not_Approved</fullName>
        <description>Update Account status field into Not Approved</description>
        <field>Status__c</field>
        <literalValue>Not Approved</literalValue>
        <name>VSPR1 Set Status to Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Set_Status_to_Submit_for_Approval</fullName>
        <description>Update Account status field into Submit for Approval</description>
        <field>Status__c</field>
        <literalValue>Submit for Approval</literalValue>
        <name>VSPR1 Set Status to Submit for Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_UpdateActiveLOBsPicklist</fullName>
        <field>Active_LOBs_Text__c</field>
        <formula>Active_LOBs_Group__c</formula>
        <name>VSPR1_UpdateActiveLOBsPicklist</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Update_10_to_50000</fullName>
        <field>X10_to_Marchon_50000_target__c</field>
        <literalValue>1</literalValue>
        <name>VSPR1_Update 10% to 50000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_Update_not_10_to_50000</fullName>
        <field>X10_to_Marchon_50000_target__c</field>
        <literalValue>0</literalValue>
        <name>VSPR1_Update not 10% to 50000</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR1_not_10_to_25000_Marchon_Target</fullName>
        <field>Accounts_within_10_of_Target__c</field>
        <literalValue>0</literalValue>
        <name>VSPR1_not 10%  to 25000 Marchon Target</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR24_UpdateLocationDescriptionDBA</fullName>
        <description>Populates the Location Description DBA field with the Common Account Name</description>
        <field>Location_Description_DBA__c</field>
        <formula>Name</formula>
        <name>VSPR24_UpdateLocationDescriptionDBA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR28_UpdateVCNetworkAdmin_Parent_Comp</fullName>
        <field>VC_EDS_NA__c</field>
        <formula>/*****************IF Parent Company is AEHG- Acuity Eyecare Holding Group , CLRK - Clarkson Eyecare Location, GRRA - Grand Rapids Ophthalmology, MEDR - MyEyeDr. Location , PRIT - Pritchett Eye Care Location, TECP - Total Eyecare Partners *****************/ 
IF(AND(OR( 
ISPICKVAL(Parent_Company__c, &quot;AEHG- Acuity Eyecare Holding Group&quot;), 
ISPICKVAL(Parent_Company__c, &quot;CLRK - Clarkson Eyecare Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;GRRA - Grand Rapids Ophthalmology&quot;), 
ISPICKVAL(Parent_Company__c, &quot;MEDR - MyEyeDr. Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;PRIT - Pritchett Eye Care Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;TECP - Total Eyecare Partners&quot;) 
), 
CONTAINS(&quot;AK,AL,AR,AZ,CO,CT,DC,DE,FL,GA,GU,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,PR,RI,SC,SD,TN,TX,VI,UT,VA,VT,WA,WI,WV,WY,CA&quot;, ShippingState) 
), &quot;PSPND2A004&quot;, 
			
/*****************IF Parent Company is COHN - Cohen&apos;s Fashion Optical , COST - Costco Location, CVS - CVS Location, ECCA - ECCA or Visionworks Location , FEGV - For Eyes Grand Vision, OPTX - Optyx Location, RXOP - Rx Optical Location, SHOP - Shopko Location, WALM - Walmart Location, WVIS - Wisconsin Vision Location *****************/ 
IF(AND(OR( 
ISPICKVAL(Parent_Company__c, &quot;COHN - Cohen&apos;s Fashion Optical&quot;), 
ISPICKVAL(Parent_Company__c, &quot;COST - Costco Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;CVS - CVS Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;ECCA - ECCA or Visionworks Location&quot;), 
ISPICKVAL(Parent_Company__c, &quot;FEGV - For Eyes Grand Vision&quot;), 
ISPICKVAL(Parent_Company__c, &quot;OPTX - Optyx Location&quot;),
ISPICKVAL(Parent_Company__c, &quot;RXOP - Rx Optical Location&quot;),
ISPICKVAL(Parent_Company__c, &quot;SHOP - Shopko Location&quot;),
ISPICKVAL(Parent_Company__c, &quot;WALM - Walmart Location&quot;),
ISPICKVAL(Parent_Company__c, &quot;WVIS - Wisconsin Vision Location&quot;)
),
CONTAINS(&quot;AK,AL,AR,AZ,CO,CT,DC,DE,FL,GA,GU,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,PR,RI,SC,SD,TN,TX,VI,UT,VA,VT,WA,WI,WV,WY,CA&quot;, ShippingState) 
), &quot;PSPND2A001&quot;,
			
/*****************IF Parent Company is OCNB - Near-site Clinic Location, VSP , OCSI - Onsite Clinic Location, VSP, POP - Pop-Up Clinic Location, VSP *****************/ 
IF(AND(OR( 
ISPICKVAL(Parent_Company__c, &quot;OCNB - Near-site Clinic Location, VSP&quot;), 
ISPICKVAL(Parent_Company__c, &quot;OCSI - Onsite Clinic Location, VSP&quot;), 
ISPICKVAL(Parent_Company__c, &quot;POP - Pop-Up Clinic Location, VSP&quot;)
),
CONTAINS(&quot;AK,AL,AR,AZ,CO,CT,DC,DE,FL,GA,GU,HI,IA,ID,IL,IN,KS,KY,LA,MA,MD,ME,MI,MN,MO,MS,MT,NC,ND,NE,NH,NJ,NM,NV,NY,OH,OK,OR,PA,PR,RI,SC,SD,TN,TX,VI,UT,VA,VT,WA,WI,WV,WY,CA&quot;, ShippingState) 
), &quot;PSPND1A015&quot;,

&quot;&quot;)))</formula>
        <name>VSPR28_UpdateVCNetworkAdmin_Parent_Comp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR2_All_Emails_Field_Update_Account</fullName>
        <field>All_Emails__pc</field>
        <formula>PersonEmail &amp; &apos;-&apos; &amp; Eyeconic_Email__pc  &amp; &apos;-&apos; &amp; Other_Email__pc &amp; &apos;-&apos; &amp; Personal_Email__pc</formula>
        <name>VSPR2_All_Emails_Field_Update_Account</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR31_Update_Eye_Outside_Sales</fullName>
        <field>Eyefinity_Outside_Sales__c</field>
        <formula>CASE(ShippingState, 
&quot;AK&quot;, &quot;EYEOS1A003&quot;,
&quot;AL&quot;, &quot;EYEOS1A001&quot;,
&quot;AR&quot;, &quot;EYEOS1A001&quot;,
&quot;AZ&quot;, &quot;EYEOS1A001&quot;,
&quot;CO&quot;, &quot;EYEOS1A002&quot;,
&quot;CT&quot;, &quot;EYEOS1A004&quot;,
&quot;DC&quot;, &quot;EYEOS1A004&quot;,
&quot;DE&quot;, &quot;EYEOS1A004&quot;,
&quot;FL&quot;, &quot;EYEOS1A005&quot;,
&quot;GA&quot;, &quot;EYEOS1A002&quot;,
&quot;HI&quot;, &quot;EYEOS1A003&quot;,
&quot;IA&quot;, &quot;EYEOS1A007&quot;,
&quot;ID&quot;, &quot;EYEOS1A001&quot;,
&quot;IL&quot;, &quot;EYEOS1A007&quot;,
&quot;IN&quot;, &quot;EYEOS1A007&quot;,
&quot;KS&quot;, &quot;EYEOS1A007&quot;,
&quot;KY&quot;, &quot;EYEOS1A007&quot;,
&quot;LA&quot;, &quot;EYEOS1A001&quot;,
&quot;MA&quot;, &quot;EYEOS1A004&quot;,
&quot;MD&quot;, &quot;EYEOS1A004&quot;,
&quot;ME&quot;, &quot;EYEOS1A004&quot;,
&quot;MI&quot;, &quot;EYEOS1A006&quot;,
&quot;MN&quot;, &quot;EYEOS1A006&quot;,
&quot;MO&quot;, &quot;EYEOS1A007&quot;,
&quot;MS&quot;, &quot;EYEOS1A001&quot;,
&quot;MT&quot;, &quot;EYEOS1A006&quot;,
&quot;NC&quot;, &quot;EYEOS1A002&quot;,
&quot;ND&quot;, &quot;EYEOS1A006&quot;,
&quot;NE&quot;, &quot;EYEOS1A006&quot;,
&quot;NH&quot;, &quot;EYEOS1A004&quot;,
&quot;NJ&quot;, &quot;EYEOS1A006&quot;,
&quot;NM&quot;, &quot;EYEOS1A001&quot;,
&quot;NV&quot;, &quot;EYEOS1A001&quot;,
&quot;NY&quot;, &quot;EYEOS1A004&quot;,
&quot;OH&quot;, &quot;EYEOS1A006&quot;,
&quot;OK&quot;, &quot;EYEOS1A007&quot;,
&quot;OR&quot;, &quot;EYEOS1A001&quot;,
&quot;PA&quot;, &quot;EYEOS1A004&quot;,
&quot;RI&quot;, &quot;EYEOS1A004&quot;,
&quot;SC&quot;, &quot;EYEOS1A007&quot;,
&quot;SD&quot;, &quot;EYEOS1A006&quot;,
&quot;TN&quot;, &quot;EYEOS1A007&quot;,
&quot;TX&quot;, &quot;EYEOS1A002&quot;,
&quot;UT&quot;, &quot;EYEOS1A002&quot;,
&quot;VA&quot;, &quot;EYEOS1A004&quot;,
&quot;VT&quot;, &quot;EYEOS1A004&quot;,
&quot;WA&quot;, &quot;EYEOS1A001&quot;,
&quot;WI&quot;, &quot;EYEOS1A006&quot;,
&quot;WV&quot;, &quot;EYEOS1A007&quot;,
&quot;WY&quot;, &quot;EYEOS1A006&quot;,
&quot;CA&quot;, (IF(LEFT(ShippingPostalCode, 2) = &quot;90&quot;, &quot;EYEOS1A006&quot;,
IF(LEFT(ShippingPostalCode, 2) = &quot;91&quot;, &quot;EYEOS1A006&quot;,
IF(LEFT(ShippingPostalCode, 2) = &quot;92&quot;, &quot;EYEOS1A006&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;93&quot;, &quot;EYEOS1A006&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;94&quot;, &quot;EYEOS1A003&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;95&quot;, &quot;EYEOS1A003&quot;,
IF(LEFT(ShippingPostalCode, 2) =&quot;96&quot;, &quot;EYEOS1A003&quot;,&quot;&quot;)))))))),
&quot;&quot; )</formula>
        <name>VSPR31 Update Eye Outside Sales</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR3_1_UpdateMonthWebAdded</fullName>
        <field>New_Web_Address_Added__c</field>
        <formula>TODAY()</formula>
        <name>VSPR3.1_UpdateMonthWebAdded</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR4_Update_Account_Status_to_Active</fullName>
        <description>Field update to be used with workflow to change the account Status to Active when any &quot;Current Customer&quot; LOB check boxes are checked on account.</description>
        <field>Status__c</field>
        <literalValue>A</literalValue>
        <name>VSPR4_Update Account Status to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR4_Update_Account_Status_to_Inactive</fullName>
        <description>Field update to be used with workflow to change the account Status to Inactive when all &quot;Current Customer&quot; LOB checkboxes are unchecked on accounts created more than 30 days ago.</description>
        <field>Status__c</field>
        <literalValue>Inactive</literalValue>
        <name>VSPR4_Update Account Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>VSPR19b_Business_Account</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/BusiAcct</endpointUrl>
        <fields>Acquisition_Date__c</fields>
        <fields>Bank_Account_Number__c</fields>
        <fields>Bank_Account_Type__c</fields>
        <fields>Bank_Routing_Number__c</fields>
        <fields>BillingCity</fields>
        <fields>BillingPostalCode</fields>
        <fields>BillingState</fields>
        <fields>BillingStreet</fields>
        <fields>Dispense_Materials__c</fields>
        <fields>Email__c</fields>
        <fields>Eyefinity_Access__c</fields>
        <fields>Fax</fields>
        <fields>IOF_Uncut_Pilot_Program__c</fields>
        <fields>IRS_Tax_ID__c</fields>
        <fields>Id</fields>
        <fields>Location_Description_DBA__c</fields>
        <fields>Location_Medicaid_Number_1__c</fields>
        <fields>Location_Medicaid_Number_2__c</fields>
        <fields>Location_Medicaid_Number_3__c</fields>
        <fields>Location_Medicaid_State_1__c</fields>
        <fields>Location_Medicaid_State_2__c</fields>
        <fields>Location_Medicaid_State_3__c</fields>
        <fields>Location_Type__c</fields>
        <fields>Name</fields>
        <fields>No_Sales_Tax__c</fields>
        <fields>OON_Eligibility_Coverage__c</fields>
        <fields>Parent_Company__c</fields>
        <fields>Physical_County_Code__c</fields>
        <fields>Practice_IRS_Tax_ID__c</fields>
        <fields>Previous_IRS_Tax_ID__c</fields>
        <fields>Service_Type__c</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <fields>Store_Number__c</fields>
        <fields>Vision_Care_Effective_Date__c</fields>
        <fields>Vision_Care_End_Date__c</fields>
        <fields>Vision_Care_Identifying_City__c</fields>
        <fields>Vision_Care_Identifying_State__c</fields>
        <fields>Vision_Care_Identifying_Street__c</fields>
        <fields>Vision_Care_Identifying_Zip_Code__c</fields>
        <fields>Vision_Care_Location_Key__c</fields>
        <fields>Vision_Care_Location_Phone_Number__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR19b_Business Account</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>VSPR19b_Practice_Account</fullName>
        <apiVersion>39.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/PracAcct</endpointUrl>
        <fields>Bank_Account_Number__c</fields>
        <fields>Bank_Account_Type__c</fields>
        <fields>Bank_Routing_Number__c</fields>
        <fields>BillingCity</fields>
        <fields>BillingPostalCode</fields>
        <fields>BillingState</fields>
        <fields>BillingStreet</fields>
        <fields>CreatedDate</fields>
        <fields>Diverse_Business_Owner__c</fields>
        <fields>Explanation_Of_Payment_Distribution__c</fields>
        <fields>Fee_Calculation_Code__c</fields>
        <fields>IRS_Name__c</fields>
        <fields>IRS_Tax_ID__c</fields>
        <fields>Id</fields>
        <fields>Lab_Network_Opt_Out__c</fields>
        <fields>MDM_Account_Keys__c</fields>
        <fields>MDM_Location_Keys__c</fields>
        <fields>No_Sales_Tax__c</fields>
        <fields>Opt_Out_of_Choice_Network__c</fields>
        <fields>Payment_Distribution__c</fields>
        <fields>Payment_Method__c</fields>
        <fields>Phone</fields>
        <fields>Practice_Business_Type__c</fields>
        <fields>Previous_IRS_Tax_ID__c</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <fields>Vision_Care_Effective_Date__c</fields>
        <fields>Vision_Care_End_Date__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR19b_Practice Account</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>VSPR23_RewardsManagement</fullName>
        <apiVersion>42.0</apiVersion>
        <description>Outbound Message containing fields related to the Rewards Management Category data to populate PRS1209T</description>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/RwrdMgmt</endpointUrl>
        <fields>IRS_Tax_ID__c</fields>
        <fields>Id</fields>
        <fields>Rewards_Category_Effective_Date__c</fields>
        <fields>Rewards_Category_End_Date__c</fields>
        <fields>Rewards_Category__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR23_RewardsManagement</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>VSPR24_Business_Account_Physical_Address</fullName>
        <apiVersion>43.0</apiVersion>
        <endpointUrl>https://api.vspglobal.com/wisd-txhttp/SalesforceIntegration/SfToProsUpd/NtwkAddr</endpointUrl>
        <fields>Id</fields>
        <fields>ShippingCity</fields>
        <fields>ShippingPostalCode</fields>
        <fields>ShippingState</fields>
        <fields>ShippingStreet</fields>
        <fields>Vision_Care_Location_Key__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>katherineb@vsp.com</integrationUser>
        <name>VSPR24_Business Account Physical Address</name>
        <protected>false</protected>
        <useDeadLetterQueue>true</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Business Account Manual Trigger</fullName>
        <actions>
            <name>VSPR19b_Business_Account</name>
            <type>OutboundMessage</type>
        </actions>
        <active>false</active>
        <formula>OR(RecordType.Name == &apos;Business Account&apos;, RecordType.Name == &apos;Practice Account&apos;)  
&amp;&amp; 
NOT(ISBLANK( Vision_Care_Effective_Date__c ))
&amp;&amp; 
OR(ISCHANGED(Vision_Care_Effective_Date__c), ISCHANGED(Vision_Care_End_Date__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR10_AutoAssignTerritoryCodes</fullName>
        <actions>
            <name>VSPR10_UpdateVCNetworkAdmin</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically assigns Network Administrator codes when an Account is created or the (Physical) Shipping State or Zip Code is updated.</description>
        <formula>OR(ISCHANGED(ShippingState), ISCHANGED(ShippingPostalCode), ISCHANGED(Parent_Company__c))  &amp;&amp;  OR(ISBLANK(TEXT(Parent_Company__c)), ISPICKVAL(Parent_Company__c, &quot;PERL - Pearle Vision Location&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR11_UpdateBusinessHours</fullName>
        <actions>
            <name>Update_Friday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Monday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Saturday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Sunday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Thursday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Tuesday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Wednesday_Business_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Account</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_AutoPopulate_Identifying_Address</fullName>
        <actions>
            <name>VC_Identifying_City_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VC_Identifying_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VC_Identifying_Street_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VC_Identifying_Zip_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically copies the Physical Address to the Identifying Address on Business Accounts when a Vision Care Effective Date is populated.</description>
        <formula>AND( NOT(ISBLANK(Vision_Care_Effective_Date__c)), Vision_Care_Identifying_Street__c == NULL, Vision_Care_Identifying_City__c == NULL, Vision_Care_Identifying_State__c == NULL, Vision_Care_Identifying_Zip_Code__c == NULL, RecordType.Name = &apos;Business Account&apos;)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_AutoPopulate_VCMailing_Address</fullName>
        <actions>
            <name>UpdateMailingCity</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingState</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingStreet</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateMailingZipcode</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically copies the Physical Address to the Vision Care Mailing Address on Business and Practice Accounts when a Vision Care Effective Date is populated.</description>
        <formula>AND( NOT(ISBLANK(Vision_Care_Effective_Date__c)), BillingStreet == NULL,  BillingCity == NULL, BillingState == NULL, BillingPostalCode == NULL, RecordType.Name = &apos;Business Account&apos; || RecordType.Name = &apos;Practice Account&apos; )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_Business Account</fullName>
        <actions>
            <name>VSPR19b_Business_Account</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to Vision Care fields on the Business Account to send Outbound Message to PROS tables.</description>
        <formula>RecordType.Name == &apos;Business Account&apos;   &amp;&amp;      NOT(ISBLANK( Vision_Care_Effective_Date__c ))  &amp;&amp;    OR(Vision_Care_End_Date__c &gt;= TODAY(), ISBLANK(Vision_Care_End_Date__c))  &amp;&amp; (ISNEW()|| 	ISCHANGED(Bank_Account_Number__c)|| 	ISCHANGED(Bank_Account_Type__c) || 	ISCHANGED(Bank_Routing_Number__c) || 	ISCHANGED(BillingStreet)|| 	ISCHANGED(BillingCity)|| 	ISCHANGED(BillingState)|| 	ISCHANGED(BillingPostalCode)|| 	ISCHANGED(Dispense_Materials__c)|| 	ISCHANGED(Email__c)|| 	ISCHANGED(Eyefinity_Access__c)|| 	ISCHANGED(Fax) || 	ISCHANGED(Location_Type__c )|| 	ISCHANGED(Location_Description_DBA__c)|| 	ISCHANGED(Name)|| 	ISCHANGED(No_Sales_Tax__c )|| ISCHANGED(OON_Eligibility_Coverage__c)||	 	ISCHANGED(Parent_Company__c )|| 	ISCHANGED(Physical_County_Code__c )|| 	ISCHANGED(IRS_Tax_ID__c)|| 	ISCHANGED(Service_Type__c)|| 	ISCHANGED(ShippingStreet)|| 	ISCHANGED(ShippingCity)|| 	ISCHANGED(ShippingState)|| 	ISCHANGED(ShippingPostalCode)|| 	ISCHANGED(Vision_Care_Effective_Date__c) || 	ISCHANGED(Vision_Care_End_Date__c)|| 	ISCHANGED(Vision_Care_Identifying_Street__c )|| 	ISCHANGED(Vision_Care_Identifying_City__c )|| 	ISCHANGED(Vision_Care_Identifying_State__c )|| 	ISCHANGED(Vision_Care_Identifying_Zip_Code__c )|| 	ISCHANGED(Vision_Care_Location_Key__c )|| 	ISCHANGED(Vision_Care_Location_Phone_Number__c )|| 	ISCHANGED(Update_Account__c)  ||  ISCHANGED( Acquisition_Date__c ) ||  ISCHANGED( Store_Number__c ) ||  ISCHANGED( IOF_Uncut_Pilot_Program__c )   	)</formula>
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
            <field>Account.Bypass_VC_Validation_Rules__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Deletes the checkbox set by Apex classes that bypasses custom validation rules</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_PopulateVisionCarePracticeInfo</fullName>
        <actions>
            <name>CopyTaxIDtoIRSTaxID</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PopulateIRSName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Vision_Care_Effective_Date__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Practice Account</value>
        </criteriaItems>
        <description>Automatically populate Vision Care fields when Vision Care Practice Account is created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_Practice Account</fullName>
        <actions>
            <name>VSPR19b_Practice_Account</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to Vision Care fields on the Practice Account to send Outbound Message to PROS tables</description>
        <formula>RecordType.Name == &apos;Practice Account&apos; 
&amp;&amp;  

NOT(ISBLANK( Vision_Care_Effective_Date__c ))
&amp;&amp;  
OR(
Vision_Care_End_Date__c &gt;=TODAY(), ISBLANK(Vision_Care_End_Date__c)
)

&amp;&amp;
(ISNEW() ||
ISCHANGED(Bank_Account_Number__c)||   
ISCHANGED(Bank_Account_Type__c) ||  
ISCHANGED(Bank_Routing_Number__c) ||  
ISCHANGED(BillingCity)||  
ISCHANGED(BillingPostalCode)||  
ISCHANGED(BillingState)||  
ISCHANGED(BillingStreet)||  
ISCHANGED(Explanation_Of_Payment_Distribution__c) ||  
ISCHANGED(Fee_Calculation_Code__c) ||  
ISCHANGED(IRS_Name__c) ||  
ISCHANGED(IRS_Tax_ID__c) ||  
ISCHANGED(Lab_Network_Opt_Out__c) ||  
ISCHANGED(No_Sales_Tax__c) ||  
ISCHANGED(Opt_Out_of_Choice_Network__c) ||  
ISCHANGED(Payment_Distribution__c) ||  
ISCHANGED(Payment_Method__c) ||  
ISCHANGED(Phone)||  
ISCHANGED(Practice_Business_Type__c) ||  
ISCHANGED(Previous_IRS_Tax_ID__c) ||  
ISCHANGED(ShippingCity)||
ISCHANGED(ShippingPostalCode) ||
ISCHANGED(ShippingState) ||
ISCHANGED(ShippingStreet) ||
ISCHANGED(Vision_Care_Effective_Date__c) ||  
ISCHANGED(Vision_Care_End_Date__c) ||
ISCHANGED( Update_Account__c )
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR19b_TaxIDLastFour</fullName>
        <actions>
            <name>VSPR19_TaxIDLastFour</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>VSPR19b_TaxIDLastFour</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED( Tax_ID__c ) || ISBLANK( Tax_ID__c ) ||  NOT(ISNULL( Tax_ID__c ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_Accounts not within 10%25 of %2450000 Marchon sales target</fullName>
        <actions>
            <name>VSPR1_Update_not_10_to_50000</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>lessThan</operation>
            <value>45000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>greaterThan</operation>
            <value>49999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_Sales_Target__c</field>
            <operation>equals</operation>
            <value>50000</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_Accounts not within 10%25 of 25000 Marchon Target</fullName>
        <actions>
            <name>VSPR1_not_10_to_25000_Marchon_Target</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>lessThan</operation>
            <value>22500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>greaterThan</operation>
            <value>24999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_Sales_Target__c</field>
            <operation>equals</operation>
            <value>25000</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_Accounts within 10%25 of %2450000 Marchon sales target</fullName>
        <actions>
            <name>VSPR1_Update_10_to_50000</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>greaterOrEqual</operation>
            <value>45000</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>lessOrEqual</operation>
            <value>49999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_Sales_Target__c</field>
            <operation>equals</operation>
            <value>50000</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_Accounts within 10%25 of 25000 Marchon Target</fullName>
        <actions>
            <name>VSPR1_10_to_25000_Marchon_Target</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>greaterOrEqual</operation>
            <value>22500</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_and_Altair_Net_Sales_LTM__c</field>
            <operation>lessOrEqual</operation>
            <value>24999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon_Sales_Target__c</field>
            <operation>equals</operation>
            <value>25000</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_EHM Rate</fullName>
        <actions>
            <name>VSPR1_EHM_or_greater</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Vision_Care_EHM_Rate__c</field>
            <operation>greaterOrEqual</operation>
            <value>5</value>
        </criteriaItems>
        <description>Field will be populated if Account has EHM Rate of 5 or above.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_EHM Rate_less than 5</fullName>
        <actions>
            <name>VSPR1_EHM_less</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Vision_Care_EHM_Rate__c</field>
            <operation>lessThan</operation>
            <value>5</value>
        </criteriaItems>
        <description>Field will be unpopulated if Account has EHM Rate of less than 5</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR1_UpdateActiveLOBs</fullName>
        <actions>
            <name>VSPR1_UpdateActiveLOBsPicklist</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR23_RewardsManagementOutboundMsg</fullName>
        <actions>
            <name>VSPR23_RewardsManagement</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Sends outbound message when Rewards Management fields are added or changed.</description>
        <formula>RecordType.Name == &quot;Practice Account&quot; &amp;&amp; NOT(ISBLANK(IRS_Tax_ID__c)) &amp;&amp; NOT(ISBLANK(TEXT( Rewards_Category__c ))) &amp;&amp; (ISNEW()|| ISCHANGED(Rewards_Category__c)|| ISCHANGED(Rewards_Category_Effective_Date__c)|| ISCHANGED(Rewards_Category_End_Date__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR24_AutoPopulateLocationDescriptionDBA</fullName>
        <actions>
            <name>VSPR24_UpdateLocationDescriptionDBA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically copies the Common Account Name to the Location Description DBA on Business Accounts when a Vision Care Effective Date is populated.</description>
        <formula>AND(NOT(ISBLANK(Vision_Care_Effective_Date__c )), 				Location_Description_DBA__c  == null, 				RecordType.Name == &apos;Business Account&apos; 				)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>VSPR24_Business Account Physical Address</fullName>
        <actions>
            <name>VSPR24_Business_Account_Physical_Address</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Workflow rule fired by specific changes to Physical Address fields on the Business Account to send Outbound Message to PROS table.</description>
        <formula>RecordType.Name == &apos;Business Account&apos;  &amp;&amp;     NOT(ISBLANK( Vision_Care_Effective_Date__c )) &amp;&amp;   OR(Vision_Care_End_Date__c &gt;= TODAY(), ISBLANK(Vision_Care_End_Date__c)) &amp;&amp;   			(ISNEW()||  				ISCHANGED(ShippingStreet)||   				ISCHANGED(ShippingCity)||   				ISCHANGED(ShippingState)||   				ISCHANGED(ShippingPostalCode)   				)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR28_AutoAssignTerritoryCodes_Parent_Company</fullName>
        <actions>
            <name>VSPR28_UpdateVCNetworkAdmin_Parent_Comp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Automatically assigns Network Administrator codes when an Account is created or the (Physical) Shipping State or Zip Code is updated and Provider Category is PEARL - License Operator Pearle Vision</description>
        <formula>OR(ISCHANGED(ShippingState), ISCHANGED(ShippingPostalCode), ISCHANGED(Parent_Company__c))   &amp;&amp;   NOT(ISBLANK(TEXT(Parent_Company__c)))  &amp;&amp;  NOT(ISPICKVAL(Parent_Company__c, &quot;PERL - Pearle Vision Location&quot;))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR2_Concatenate_All_Email_Fields_Account</fullName>
        <actions>
            <name>VSPR2_All_Emails_Field_Update_Account</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.IsPersonAccount</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Update All_Emails__pc field when email address on Account object is created or updated</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR3%2E1_UpdateMonthWebAdded</fullName>
        <actions>
            <name>VSPR3_1_UpdateMonthWebAdded</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update field with the date every time a new web address is added to the Account record. For Reporting.</description>
        <formula>(  (ISCHANGED(Website) &amp;&amp; ISBLANK(PRIORVALUE(Website)))  || (ISNEW() &amp;&amp; NOT(ISBLANK(Website)))  )  &amp;&amp;  ( ISNULL(New_Web_Address_Added__c) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR31_EyefinityAssignTerritoryCodes</fullName>
        <actions>
            <name>VSPR31_Update_Eye_Outside_Sales</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(ShippingState)  ||  ISCHANGED(ShippingPostalCode)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR4 Change Account Status to Active</fullName>
        <actions>
            <name>VSPR4_Update_Account_Status_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7 OR 8) AND 9 AND 10</booleanFilter>
        <criteriaItems>
            <field>Account.Unity__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Altair_Customer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Eyefinity_Customer__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.VSPOne__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Network_Provider__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Affiliate__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Other__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed,Archive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Account,Practice Account</value>
        </criteriaItems>
        <description>Workflow to be used with field update to change the account Status back to Active when any &quot;Current Customer&quot; LOB check boxes are checked on account.  Applies to Business and Practice Account record types.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR4 Change Account Status to Inactive</fullName>
        <actions>
            <name>VSPR4_Update_Account_Status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 8 AND 9 AND 10 AND 11</booleanFilter>
        <criteriaItems>
            <field>Account.Unity__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Altair_Customer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Eyefinity_Customer__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Marchon__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.VSPOne__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Network_Provider__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Affiliate__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Vision_Care_VSP_Other__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Status__c</field>
            <operation>notEqual</operation>
            <value>Closed,Archive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CreatedDate</field>
            <operation>notEqual</operation>
            <value>LAST 30 DAYS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Business Account,Practice Account</value>
        </criteriaItems>
        <description>Workflow to be used with field update to change the account Status to Inactive when all &quot;Current Customer&quot; LOB checkboxes are unchecked on accounts created more than 30 days ago.  Excludes Person Accounts.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
