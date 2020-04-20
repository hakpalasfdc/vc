/* 
* Class Name: VSPR3_NetworkRecruitmentControllerTest
* Created By: Amit Shinde, 09/15/2015
* Description: Test Class for VSPR3_NetworkRecruitmentController
* Updates:
*/

@isTest(SeeAllData = false)
public class VSPR3_NetworkRecruitmentControllerTest {
    static testMethod void unitTest(){   
        
        // Insert sample Account with email
        Account acc0 = new Account();
        acc0.Name = 'Sample Account 0';
        acc0.Status__c = 'New';
        acc0.Account_Type__c = 'Business Account';
        acc0.Email__c = 'vsp@vsp.com';
        acc0.Fax = '1112223333';
        acc0.Phone = '111223333';
        acc0.Altair_Standard__c = '001';
        acc0.Altair_Field_Rep__c = '001'; 
        acc0.Altair_Key_Account__c = '001';
        acc0.Altair_Exception__c = '001'; 
        acc0.Altair_Hybrid_Bebe__c = '001'; 
        acc0.Ophthalmic_Business_Consultant__c = '001'; 
        acc0.Optics_Contact_Lens_Consultant__c = '001'; 
        acc0.Marchon_Key_Account__c = '001'; 
        acc0.Marchon_Close_Out__c = '001'; 
        acc0.Marchon_Optical__c = '001'; 
        acc0.Marchon_Retail__c = '001';
        acc0.VC_EDS_NA__c = '001'; 
        acc0.Global_Business_Development_Manager__c = '001';
        acc0.Global_Business_Development_Partner__c = '001';
        acc0.VC_Relationship_Manager__c = '001'; 
        acc0.Optics_Wholesale__c = '001'; 
        acc0.Eyefinity_Inside_Sales__c = '001'; 
        acc0.Eyefinity_Outside_Sales__c = '002';
        insert acc0;
        
        // Insert sample Account without email
        Account acc1 = new Account();
        acc1.Name = 'Sample Account 0';
        acc1.Status__c = 'New';
        acc1.Account_Type__c = 'Business Account';
        acc1.Email__c = null;
        acc1.Altair_Standard__c = '001';
        acc1.Altair_Field_Rep__c = '001'; 
        acc1.Altair_Key_Account__c = '001';
        acc1.Altair_Exception__c = '001'; 
        acc1.Altair_Hybrid_Bebe__c = '001'; 
        acc1.Ophthalmic_Business_Consultant__c = '001'; 
        acc1.Optics_Contact_Lens_Consultant__c = '001'; 
        acc1.Marchon_Key_Account__c = '001'; 
        acc1.Marchon_Close_Out__c = '001'; 
        acc1.Marchon_Optical__c = '001'; 
        acc1.Marchon_Retail__c = '001';
        acc1.VC_EDS_NA__c = '001'; 
        acc1.Global_Business_Development_Manager__c = '001';
        acc1.Global_Business_Development_Partner__c = '001';
        acc1.VC_Relationship_Manager__c = '001'; 
        acc1.Optics_Wholesale__c = '001'; 
        acc1.Eyefinity_Inside_Sales__c = '001'; 
        acc1.Eyefinity_Outside_Sales__c = '002';
        insert acc1;
        
        //Insert Sample address
        Address__c address = new Address__c();
        address.Street__c = '111 Sample St';
        address.City__c = 'Rancho Cordova';
        address.State__c = 'CA';
        address.Zip__c = '95670';
        address.Country__c = 'USA';
        insert address;
        
        //Associate account with address 
        Address_Relationship__c accaddressrel = new Address_Relationship__c();
        accaddressrel.Account__c = acc0.id;
        accaddressrel.Address__c = address.Id;
        accaddressrel.Address_Type__c = 'Physical';
        insert accaddressrel;
        
        //Contact where CAQH_ID__c is not null
        Contact con0 = new Contact();
        con0.LastName = 'Text0000';
        con0.FirstName = 'Sample0000';
        con0.CAQH_ID__c = '000';
        con0.Marketing_Name__c = '000';
        con0.AccountId = acc0.id;
        con0.Birthdate__c = date.newInstance(1979, 3, 21);
        con0.Degree__c = 'MD';
        insert con0;
        
        //Contact where CAQH_ID__c is null
        Contact con1 = new Contact();
        con1.LastName = 'Text00001';
        con1.FirstName = 'Sample00001';
        con1.Marketing_Name__c = '001';
        con1.AccountId = acc0.id;
        con1.Birthdate__c = date.newInstance(1979, 3, 21);
        insert con1;
        
        //Contact where CAQH_ID__c is null and date of birth is null
        Contact con2 = new Contact();
        con2.LastName = 'Text00002';
        con2.FirstName = 'Sample00002';
        con2.Marketing_Name__c = '002';
        con2.AccountId = acc0.id;
        con2.Birthdate__c = null;
        insert con2;
        
        // Contact Role with account, contact with CAQH_ID__c
        Contact_Role__c conrole0 = New Contact_Role__c();
        conrole0.Account__c = acc0.Id;
        conrole0.Contact__c = con0.Id;
        conrole0.Type__c = 'Accounting';
        insert conrole0;
        
        // Contact Role with account, contact without CAQH_ID__c
        Contact_Role__c conrole1 = New Contact_Role__c();
        conrole1.Account__c = acc0.Id;
        conrole1.Contact__c = con1.Id;
        conrole1.Type__c = 'Accounting';
        insert conrole1;
        
        // Contact Role with account with no email, contact without CAQH_ID__c
        Contact_Role__c conrole2 = New Contact_Role__c();
        conrole2.Account__c = acc1.Id;
        conrole2.Contact__c = con1.Id;
        conrole2.Type__c = 'Accounting';
        insert conrole2;
        
        // Contact Role with account with no email, contact without CAQH_ID__c and DOB
        Contact_Role__c conrole3 = New Contact_Role__c();
        conrole3.Account__c = acc0.Id;
        conrole3.Contact__c = con2.Id;
        conrole3.Type__c = 'Accounting';
        insert conrole3;
        
        // Contact Role with account, contact with CAQH_ID__c
        PageReference pageRef0 = Page.VSPR3_NetworkRecruitment;   
        pageRef0.getParameters().put('cRoleid',conrole0.Id);    
        pageRef0.getParameters().put('dob',con0.Birthdate__c.format());
        System.Test.setCurrentPage(pageRef0); 
        ApexPages.StandardController sc0 = new ApexPages.standardController(conrole0);
        VSPR3_NetworkRecruitmentController controller0 = new VSPR3_NetworkRecruitmentController(sc0);
        controller0.getRawDetails();
        
        // Contact Role with account with email, contact without CAQH_ID__c
        PageReference pageRef1 = Page.VSPR3_NetworkRecruitment;   
        pageRef1.getParameters().put('cRoleid',conrole1.Id);    
        pageRef1.getParameters().put('dob',con1.Birthdate__c.format());
        System.Test.setCurrentPage(pageRef1); 
        ApexPages.StandardController sc1 = new ApexPages.standardController(conrole1);
        VSPR3_NetworkRecruitmentController controller1 = new VSPR3_NetworkRecruitmentController(sc1);
        controller1.getRawDetails();
        
        // Contact ROle with Account without email, without CAQH_ID__c
        PageReference pageRef2 = Page.VSPR3_NetworkRecruitment;   
        pageRef2.getParameters().put('cRoleid',conrole2.Id);    
        pageRef2.getParameters().put('dob','');
        System.Test.setCurrentPage(pageRef2); 
        ApexPages.StandardController sc2 = new ApexPages.standardController(conrole2);
        VSPR3_NetworkRecruitmentController controller2 = new VSPR3_NetworkRecruitmentController(sc2);
        controller2.getRawDetails();
        
    }
}