<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateRolePhone</fullName>
        <field>Contact_Role_Phone__c</field>
        <formula>CASE(Type__c, 
&quot;Optician&quot;, IF(NOT(ISBLANK(Account__r.Optical_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Optician&quot;)), Account__r.Optical_Department_Phone__c ,Account__r.Phone) , 
&quot;Optical Manager&quot;, IF(NOT(ISBLANK(Account__r.Optical_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Optical Manager&quot;)), Account__r.Optical_Department_Phone__c, Account__r.Phone), 
&quot;Optical Buyer&quot;, IF(NOT(ISBLANK(Account__r.Optical_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Optical Buyer&quot;)), Account__r.Optical_Department_Phone__c, Account__r.Phone),
&quot;Optician-Owner&quot;, IF(NOT(ISBLANK(Account__r.Optical_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Optician-Owner&quot;)), Account__r.Optical_Department_Phone__c, Account__r.Phone), 
&quot;Accounting&quot;, IF(NOT(ISBLANK(Account__r.Accounting_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Accounting&quot;)), Account__r.Accounting_Department_Phone__c, Account__r.Phone), 
&quot;Lab Technician&quot;, IF(NOT(ISBLANK( Account__r.Lab_Department_Phone__c)&amp;&amp; (TEXT(Type__c) = &quot;Lab Technician&quot;)), Account__r.Lab_Department_Phone__c, Account__r.Phone) , 
&quot;Doctor-Employee&quot;, Account__r.Phone , 
&quot;Doctor-Owner&quot;, Account__r.Phone , 
&quot;Office Administration&quot;, Account__r.Phone , 
&quot;Office Manager&quot;, Account__r.Phone , 
&quot;Owner&quot;, Account__r.Phone , 
&quot;Student&quot;, Account__r.Phone , 
&quot;Member&quot;, Account__r.Phone , 
&quot;Board Member/ Officer&quot;, Account__r.Phone , 
&quot;Group Administrator&quot;, Account__r.Phone , 
&quot;Dean&quot;, Account__r.Phone , 
&quot;Buyer&quot;, Account__r.Phone , 
&quot;Unspecified&quot;,Account__r.Phone, 
&quot;Doctor-Unspecified&quot;,Account__r.Phone, 
Account__r.Phone)</formula>
        <name>UpdateRolePhone</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR28_PopulateNPI</fullName>
        <description>Populates the NPI on the Contact Role from the associated Contact</description>
        <field>Provider_NPI__c</field>
        <formula>Contact__r.NPI__c</formula>
        <name>VSPR28_PopulateNPI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR2_Set_Contact_Role_to_Active</fullName>
        <description>Set Is Active Role to 1.</description>
        <field>Is_Active_Role__c</field>
        <formula>1</formula>
        <name>VSPR2_Set Contact Role to Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR2_Set_Contact_Role_to_Inactive</fullName>
        <description>Set Is Active Role to 0.</description>
        <field>Is_Active_Role__c</field>
        <formula>0</formula>
        <name>VSPR2_Set Contact Role to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>VSPR5_Update_Contact_Role_Contact_Name</fullName>
        <field>Contact_Name__c</field>
        <formula>Name_of_Contact__c</formula>
        <name>VSPR5_Update Contact Role Contact Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>VSPR19_UpdateRolePhone</fullName>
        <actions>
            <name>UpdateRolePhone</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow Rule to update the Contact Role Phone whenever the Role Type changes.</description>
        <formula>ISCHANGED( Type__c ) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR28_PopulateNPIfromContact</fullName>
        <actions>
            <name>VSPR28_PopulateNPI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.NPI__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Populates the NPI from the associated Contact record</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>VSPR2_Check if Role is Active</fullName>
        <actions>
            <name>VSPR2_Set_Contact_Role_to_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Role__c.Status_Formula__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR2_Check if Role is Inactive</fullName>
        <actions>
            <name>VSPR2_Set_Contact_Role_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact_Role__c.Status_Formula__c</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>VSPR5_Populate Contact Name</fullName>
        <actions>
            <name>VSPR5_Update_Contact_Role_Contact_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update the Contact Name field on the Contact Role</description>
        <formula>Contact_Name__c &lt;&gt;  Name_of_Contact__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
