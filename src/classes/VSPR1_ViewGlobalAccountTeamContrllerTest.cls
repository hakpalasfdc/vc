/** 
     * Class Name: VSPR1_ViewGlobalAccountTeamContrllerTest
     * @author: Jinky M. N. Salvador
     * Date: 12.JUL.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR1_ViewGlobalAccountTeamController.  
     */
@isTest(SeeAllData = true)
public class VSPR1_ViewGlobalAccountTeamContrllerTest {
    
    static testMethod void unitTest() {
        
        Profile profile = [Select id from Profile where Name =: 'System Administrator'];
        
        Account_Rep_Assignment__c rep = new Account_Rep_Assignment__c();
        rep.Marketing_Group_Description__c = 'CALVIN KLEIN';
        rep.Sales_Org__c = '2010';
        rep.Sales_Rep__c = 'DAVID PINA';
        insert rep;        
        
        List<Account_Rep_Assignment__c> lst = new List<Account_Rep_Assignment__c>();
        Map<String, User> userMap = new Map<String, User>();
        
        User user = new User();
        user.LastName = 'Sample User';
        user.Alias = 'sample';
        user.Email = 'sample@sample.com';
        user.Phone = '5129277151';
        user.Username = 'sampleUsername@sample.com';
        user.CommunityNickname = 'sampleNickname';
        user.ProfileId = profile.id;
        user.MarketingID__c = '001';
        user.MarketingID2__c = '002';
        user.TimeZoneSidKey = 'America/Chicago';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.Marchon_SAP_Number__c = '1808733';
        user.Altair_SAP_Number__c = '2237728';
        insert user;
        
        User user2 = new User();
        user2.LastName = 'Sample User2';
        user2.Alias = 'sample2';
        user2.Email = 'sample2@sample2.com';
        user2.Phone = '5129277152';
        user2.Username = 'sampleUsername2@sample.com';
        user2.CommunityNickname = 'sampleNickname2';
        user2.ProfileId = profile.id;
        user2.MarketingID__c = '001';
        user2.MarketingID2__c = '002';
        user2.TimeZoneSidKey = 'America/Chicago';
        user2.LocaleSidKey = 'en_US';
        user2.EmailEncodingKey = 'UTF-8';
        user2.LanguageLocaleKey = 'en_US';
        user2.Marchon_SAP_Number__c = '1808733';
        user2.Altair_SAP_Number__c = '22377282';
        insert user2;
        
        Account_Rep_Assignment__c accRep = new Account_Rep_Assignment__c();
        userMap.put(accRep.Sales_Rep__c, user);
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
//        acc.Ophthalmic_Business_Consultant__c = '001'; 
        acc.Optics_Contact_Lens_Consultant__c = '002'; 
        acc.Marchon_Key_Account__c = '001'; 
        acc.Marchon_Close_Out__c = '001'; 
        acc.Marchon_Optical__c = '001'; 
        acc.Marchon_Retail__c = '001';
        acc.VC_EDS_NA__c = '001'; 
        acc.Global_Business_Development_Manager__c = '001';
        acc.Global_Business_Development_Partner__c = '001';
        acc.VC_Relationship_Manager__c = '001'; // AMITSH 07/09/2015. Request # 1342. Added new field.
        acc.Optics_Wholesale__c = '001'; 
        acc.Eyefinity_Inside_Sales__c = '001'; 
        acc.Eyefinity_Outside_Sales__c = '002';
        insert acc;
        
        Account_Rep_Assignment__c obj1 = new Account_Rep_Assignment__c();
        obj1.Account_ID__c = acc.Id;
        obj1.Sales_Org__c='2110';
        obj1.Sales_Rep__c = '2237728';
        insert obj1;
        
        Account_Rep_Assignment__c obj2 = new Account_Rep_Assignment__c();
        obj2.Account_ID__c = acc.Id;
        obj2.Sales_Org__c='2010';
        obj2.Sales_Rep__c = '22377282';
        insert obj2;
        
        VSPR1_ViewGlobalAccountTeamController.DataWrapper dw = new VSPR1_ViewGlobalAccountTeamController.DataWrapper('abc','abc','abc','abc');
        dw.name = 'abc';
        dw.email = 'abc';
        dw.phone = 'abc';
        dw.mgDesc = 'abc';
        
        PageReference pageRef = Page.VSPR1_ViewGlobalAccountTeam;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR1_ViewGlobalAccountTeamController controller = new VSPR1_ViewGlobalAccountTeamController(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        
        controller.Initialize();
        controller.getUsers();     
    }
    
     static testMethod void unitTestallure() {
        
        Profile profile = [Select id from Profile where Name =: 'System Administrator'];
        
        Account_Rep_Assignment__c rep = new Account_Rep_Assignment__c();
        rep.Marketing_Group_Description__c = 'CALVIN KLEIN';
        rep.Sales_Org__c = '2050';
        rep.Sales_Rep__c = 'DAVID PINA';
        insert rep;        
        
        List<Account_Rep_Assignment__c> lst = new List<Account_Rep_Assignment__c>();
        Map<String, User> userMap = new Map<String, User>();
        
        User user = new User();
        user.LastName = 'Sample User';
        user.Alias = 'sample';
        user.Email = 'sample@sample.com';
        user.Phone = '5129277151';
        user.Username = 'sampleUsername@sample.com';
        user.CommunityNickname = 'sampleNickname';
        user.ProfileId = profile.id;
        user.MarketingID__c = '001';
        user.MarketingID2__c = '002';
        user.TimeZoneSidKey = 'America/Chicago';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.Marchon_SAP_Number__c = '1808733';
        user.Altair_SAP_Number__c = '2237728';
        insert user;
        
        User user2 = new User();
        user2.LastName = 'Sample User2';
        user2.Alias = 'sample2';
        user2.Email = 'sample2@sample2.com';
        user2.Phone = '5129277152';
        user2.Username = 'sampleUsername2@sample.com';
        user2.CommunityNickname = 'sampleNickname2';
        user2.ProfileId = profile.id;
        user2.MarketingID__c = '001';
        user2.MarketingID2__c = '002';
        user2.TimeZoneSidKey = 'America/Chicago';
        user2.LocaleSidKey = 'en_US';
        user2.EmailEncodingKey = 'UTF-8';
        user2.LanguageLocaleKey = 'en_US';
        user2.Marchon_SAP_Number__c = '1808733';
        user2.Altair_SAP_Number__c = '22377282';
        insert user2;
        
        Account_Rep_Assignment__c accRep = new Account_Rep_Assignment__c();
        userMap.put(accRep.Sales_Rep__c, user);
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
//        acc.Ophthalmic_Business_Consultant__c = '001'; 
        acc.Optics_Contact_Lens_Consultant__c = '002'; 
        acc.Marchon_Key_Account__c = '001'; 
        acc.Marchon_Close_Out__c = '001'; 
        acc.Marchon_Optical__c = '001'; 
        acc.Marchon_Retail__c = '001';
        acc.VC_EDS_NA__c = '001'; 
        acc.Global_Business_Development_Manager__c = '001';
        acc.Global_Business_Development_Partner__c = '001';
        acc.VC_Relationship_Manager__c = '001'; // AMITSH 07/09/2015. Request # 1342. Added new field.
        acc.Optics_Wholesale__c = '001'; 
        acc.Eyefinity_Inside_Sales__c = '001'; 
        acc.Eyefinity_Outside_Sales__c = '002';
        insert acc;
        
        Account_Rep_Assignment__c obj1 = new Account_Rep_Assignment__c();
        obj1.Account_ID__c = acc.Id;
        obj1.Sales_Org__c='2050';
        obj1.Sales_Rep__c = '2237728';
        insert obj1;
        
        Account_Rep_Assignment__c obj2 = new Account_Rep_Assignment__c();
        obj2.Account_ID__c = acc.Id;
        obj2.Sales_Org__c='2050';
        obj2.Sales_Rep__c = '22377282';
        insert obj2;
        
        VSPR1_ViewGlobalAccountTeamController.DataWrapper dw = new VSPR1_ViewGlobalAccountTeamController.DataWrapper('abc','abc','abc','abc');
        dw.name = 'abc';
        dw.email = 'abc';
        dw.phone = 'abc';
        dw.mgDesc = 'abc';
        
        PageReference pageRef = Page.VSPR1_ViewGlobalAccountTeam;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR1_ViewGlobalAccountTeamController controller = new VSPR1_ViewGlobalAccountTeamController(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        
        controller.Initialize();
        controller.getUsers();     
    }
    
       static testMethod void unitTestaltair() {
        
        Profile profile = [Select id from Profile where Name =: 'System Administrator'];
        
        Account_Rep_Assignment__c rep = new Account_Rep_Assignment__c();
        rep.Marketing_Group_Description__c = 'CALVIN KLEIN';
        rep.Sales_Org__c = '2050';
        rep.Sales_Rep__c = 'DAVID PINA';
        insert rep;        
        
        List<Account_Rep_Assignment__c> lst = new List<Account_Rep_Assignment__c>();
        Map<String, User> userMap = new Map<String, User>();
        
        User user = new User();
        user.LastName = 'Sample User';
        user.Alias = 'sample';
        user.Email = 'sample@sample.com';
        user.Phone = '5129277151';
        user.Username = 'sampleUsername@sample.com';
        user.CommunityNickname = 'sampleNickname';
        user.ProfileId = profile.id;
        user.MarketingID__c = '001';
        user.MarketingID2__c = '002';
        user.TimeZoneSidKey = 'America/Chicago';
        user.LocaleSidKey = 'en_US';
        user.EmailEncodingKey = 'UTF-8';
        user.LanguageLocaleKey = 'en_US';
        user.Marchon_SAP_Number__c = '1808733';
        user.Altair_SAP_Number__c = '2237728';
        insert user;
        
        User user2 = new User();
        user2.LastName = 'Sample User2';
        user2.Alias = 'sample2';
        user2.Email = 'sample2@sample2.com';
        user2.Phone = '5129277152';
        user2.Username = 'sampleUsername2@sample.com';
        user2.CommunityNickname = 'sampleNickname2';
        user2.ProfileId = profile.id;
        user2.MarketingID__c = '001';
        user2.MarketingID2__c = '002';
        user2.TimeZoneSidKey = 'America/Chicago';
        user2.LocaleSidKey = 'en_US';
        user2.EmailEncodingKey = 'UTF-8';
        user2.LanguageLocaleKey = 'en_US';
        user2.Marchon_SAP_Number__c = '1808733';
        user2.Altair_SAP_Number__c = '22377282';
        insert user2;
        
        Account_Rep_Assignment__c accRep = new Account_Rep_Assignment__c();
        userMap.put(accRep.Sales_Rep__c, user);
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
//        acc.Ophthalmic_Business_Consultant__c = '001'; 
        acc.Optics_Contact_Lens_Consultant__c = '002'; 
        acc.Marchon_Key_Account__c = '001'; 
        acc.Marchon_Close_Out__c = '001'; 
        acc.Marchon_Optical__c = '001'; 
        acc.Marchon_Retail__c = '001';
        acc.VC_EDS_NA__c = '001'; 
        acc.Global_Business_Development_Manager__c = '001';
        acc.Global_Business_Development_Partner__c = '001';
        acc.VC_Relationship_Manager__c = '001'; // AMITSH 07/09/2015. Request # 1342. Added new field.
        acc.Optics_Wholesale__c = '001'; 
        acc.Eyefinity_Inside_Sales__c = '001'; 
        acc.Eyefinity_Outside_Sales__c = '002';
        insert acc;
        
        Account_Rep_Assignment__c obj1 = new Account_Rep_Assignment__c();
        obj1.Account_ID__c = acc.Id;
        obj1.Sales_Org__c='2050';
        obj1.Marketing_Group_Code__c = 'ALT';
        obj1.Sales_Rep__c = '2237728';
        insert obj1;
        
        Account_Rep_Assignment__c obj2 = new Account_Rep_Assignment__c();
        obj2.Account_ID__c = acc.Id;
        obj2.Sales_Org__c='2050';
        obj2.Marketing_Group_Code__c = 'ALT';
        obj2.Sales_Rep__c = '22377282';
        insert obj2;
        
        VSPR1_ViewGlobalAccountTeamController.DataWrapper dw = new VSPR1_ViewGlobalAccountTeamController.DataWrapper('abc','abc','abc','abc');
        dw.name = 'abc';
        dw.email = 'abc';
        dw.phone = 'abc';
        dw.mgDesc = 'abc';
        
        PageReference pageRef = Page.VSPR1_ViewGlobalAccountTeam;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR1_ViewGlobalAccountTeamController controller = new VSPR1_ViewGlobalAccountTeamController(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        
        controller.Initialize();
        controller.getUsers();     
    }
}