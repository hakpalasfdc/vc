/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class VSPR19_ChangeTaxIDCtrlTest {
  
  static testMethod void myUnitTest0() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
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
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        account acc1 = new account();
        acc1.name='test';
        acc1.recordTypeId = recordtype;
        acc1.email__c='abc@gmail.com';
        acc1.Tax_ID__c = '345433589';
        acc1.Fax = '223456';
        acc1.Phone = '96532';
        acc1.shippingStreet = '11US';
        acc1.Account_Type__c = 'Business Account';
        acc1.Zipcode__c= '01001' ;
        acc1.Account_Group_Sub_Type__c='ab';
        acc1.ParentId=acc.id;
        acc1.Vision_Care_Location_Key__c='371580129635 2';
        acc.Vision_Care_End_Date__c=date.today().adddays(-3);
        insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'test5107';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            nr.Program_End_Date__c = date.newInstance(2018,12,31);
            insert nr;
        
        
        PageReference pageRef = Page.VSPR19_ChangeTaxID;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR19_ChangeTaxIDCtrl controller = new VSPR19_ChangeTaxIDCtrl(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        controller.validateVCEndDate();
        controller.createtaxId();
    }

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
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
        acc.Vision_Care_End_Date__c=date.today().adddays(-10);
        insert acc;
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.ParentId=acc.id;
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc1.Vision_Care_End_Date__c=date.today().adddays(-3);
                insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'test5107';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            nr.Program_End_Date__c = date.newInstance(2018,12,31);
            insert nr;
        
        
        PageReference pageRef = Page.VSPR19_ChangeTaxID;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR19_ChangeTaxIDCtrl controller = new VSPR19_ChangeTaxIDCtrl(sc);
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        controller.createtaxId();
    }
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
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
        acc.Vision_Care_End_Date__c=date.today().adddays(-10);
        acc.Vision_Care_Effective_Date__c = Date.today().adddays(-10);
        insert acc;
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.ParentId=acc.id;
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc1.Vision_Care_End_Date__c=date.today().adddays(-3);
                acc1.Vision_Care_Effective_Date__c = Date.today().adddays(-3);
                //acc1.Vision_Care_Effective_Date__c = date.today();
                insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'ADVTG';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            insert nr;
            
            NetworkRelTriggerForProgramIdHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr.id});
            NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr.id});
        
        
        PageReference pageRef = Page.VSPR19_ChangeTaxID;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR19_ChangeTaxIDCtrl controller = new VSPR19_ChangeTaxIDCtrl(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        
        controller.validateVCEndDate();
        controller.createtaxId();
        controller.doCancel();
    }
    
 /*   static testMethod void myUnitTest8() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Optics_VSPOne__c = '001'; 
        acc.Optics_Brand__c = '002'; 
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
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.ParentId=acc.id;
                acc1.Location_type__c='M - VSP Member Location';
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc.Vision_Care_End_Date__c=date.today().adddays(-3);
                insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            c.doctor_type__c='M - VSP Member Doctor';
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            insert nr;
            
            NetworkRelationshipsHandler obj=new NetworkRelationshipsHandler();
            obj.restrictOverlapNetworkRelationShip(new list<Network_Relationship__c>{nr});
            
    }*/
    
  /*  static testMethod void myUnitTest7() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Optics_VSPOne__c = '001'; 
        acc.Optics_Brand__c = '002'; 
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
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.ParentId=acc.id;
                acc1.Location_type__c='M - VSP Member Location';
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc.Vision_Care_End_Date__c=date.today().adddays(-3);
          VSPUtility.stopAccountTrigger=true;
            
                insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            c.doctor_type__c='M - VSP Member Doctor';
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'COSTA';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            insert nr;
            
            NetworkRelationshipsHandler obj=new NetworkRelationshipsHandler();
            obj.restrictOverlapNetworkRelationShip(new list<Network_Relationship__c>{nr});
            
    }*/
    
  /*  static testMethod void myUnitTest9() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Optics_VSPOne__c = '001'; 
        acc.Optics_Brand__c = '002'; 
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
        VSPUtility.stopAccountTrigger=true;
        insert acc;
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.ParentId=acc.id;
                acc1.Location_type__c='M - VSP Member Location';
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc.Vision_Care_End_Date__c=date.today().adddays(-3);
                insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            c.doctor_type__c='M - VSP Member Doctor';
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VWRK';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            insert nr;
            
            NetworkRelationshipsHandler obj=new NetworkRelationshipsHandler();
            obj.restrictOverlapNetworkRelationShip(new list<Network_Relationship__c>{nr});
            
    }*/

    static testMethod void myUnitTest10() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
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
        acc.Vision_Care_End_Date__c=date.today().adddays(-10);
        insert acc;
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        account acc1 = new account();
        acc1.name='test';
        acc1.recordTypeId = recordtype;
        acc1.email__c='abc@gmail.com';
        acc1.Tax_ID__c = '345433589';
        acc1.Fax = '223456';
        acc1.Phone = '96532';
        acc1.shippingStreet = '11US';
        acc1.Account_Type__c = 'Business Account';
        acc1.Zipcode__c= '01001' ;
        acc1.Account_Group_Sub_Type__c='ab';
        acc1.ParentId=acc.id;
        acc1.Vision_Care_Location_Key__c='371580129635 2';
        acc1.Vision_Care_Effective_Date__c = Date.today().adddays(-1);
       // acc1.Vision_Care_End_Date__c=date.today().adddays(-1);
        insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'ADVTG';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            insert nr;
            
            NetworkRelTriggerForProgramIdHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr.id});
            NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr.id});
        
        
        PageReference pageRef = Page.VSPR19_ChangeTaxID;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR19_ChangeTaxIDCtrl controller = new VSPR19_ChangeTaxIDCtrl(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        
        controller.validateVCEndDate();
        controller.createtaxId();
        controller.doCancel();
    }
    
    static testMethod void myUnitTest110() {
        // TO DO: implement unit test
        
        
        Account acc = new Account();
        acc.Name = 'Sample Account';
        acc.Status__c = 'New';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
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
        
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        account acc1 = new account();
        acc1.name='test';
        acc1.recordTypeId = recordtype;
        acc1.email__c='abc@gmail.com';
        acc1.Tax_ID__c = '345433589';
        acc1.Fax = '223456';
        acc1.Phone = '96532';
        acc1.shippingStreet = '11US';
        acc1.Account_Type__c = 'Business Account';
        acc1.Zipcode__c= '01001' ;
        acc1.Account_Group_Sub_Type__c='ab';
        acc1.ParentId=acc.id;
        acc1.Vision_Care_Location_Key__c='371580129635 2';
        acc1.Vision_Care_Effective_Date__c = Date.today().adddays(-1);
        //acc.Vision_Care_End_Date__c=date.today().adddays(-3);
        insert acc1;
        
       // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;

            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'test5107';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = acc1.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().adddays(-2);
            nr.Program_End_Date__c = date.newInstance(2018,12,31);
            insert nr;
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.EndPoint_Sandbox__c = 'https://api-staging.vspglobal.com==';
        dviWeb.Prod_Org_ID__c = '' ;
        dviWeb.Fee_Token_Header_Sandbox__c = 'EGVrgXfOYlVOm88C63xET6L3TxcxZ8PK9mxt3tzqVvVssgoh7pshfhR8k4YDCkiU';
        dviWeb.Name = 'Fee_Web';
        
        insert dviWeb;
        
        PageReference pageRef = Page.VSPR19_ChangeTaxID;     
        
        pageRef.getParameters().put('id',acc.id);
        
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(acc);
        // create an instance of the controller
        VSPR19_ChangeTaxIDCtrl controller = new VSPR19_ChangeTaxIDCtrl(sc);
        
        //controller.sapNumberSet.add(accRep.Sales_Rep__c);
        controller.validateVCEndDate();
        controller.createtaxId();
        
     //   VSPR19_ChangeTaxIDCtrl.executeWebService(acc1.Id, String.valueOf(Date.today().adddays(-1)), String.valueOf(Date.today().adddays(-1)), String.valueOf(acc1.Id));
        
      //  Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
    }
}