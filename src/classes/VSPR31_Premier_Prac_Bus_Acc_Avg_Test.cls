@isTest
//Test class for VSPR31_Premier_Prac_Bus_Acc_Avg_Batch
public class VSPR31_Premier_Prac_Bus_Acc_Avg_Test {
    @testSetup
    public static void testData(){
        Test.startTest();
        Id paRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id baRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecordTypeId;
        pa1.Name = 'PA Test 1234';
        pa1.Status__c = 'A';
        pa1.Vision_Care_Effective_Date__c = system.today() - 3;
        pa1.Vision_Care_End_Date__c = null;//system.today() + 1;
        pa1.Vision_Care_Good_Standing__c = true;
        pa1.Tax_ID__c = '123456789';
        pa1.Premier_Tax_ID_Roll_Up_Account__c = false;
        
        insert pa1;
        
        Account ba1 = new Account();
        ba1.RecordTypeId = baRecordTypeId;
        ba1.Name = 'BA Test 1234';
        ba1.ParentId = pa1.Id;
        ba1.Contract_Type__c = 'Affiliate';
        ba1.Vision_Care_Good_Standing__c = True;
        ba1.Total_Location_Spend_LTM__c = 100;
        ba1.Eyewear_Location_Spend_LTM__c = 100;
        ba1.Optics_Location_Spend_LTM__c = 100;
        ba1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //VC__C is a formula field on the Account
        //IF( Vision_Care_Effective_Date__c <= TODAY() && (Vision_Care_End_Date__c >=TODAY() || ISBLANK(Vision_Care_End_Date__c)) , TRUE, FALSE)
        ba1.Vision_Care_Effective_Date__c = system.today() - 3; 
        
        insert ba1;
        
        Account ba2 = new Account();
        ba2.RecordTypeId = baRecordTypeId;
        ba2.Name = 'BA2 Test 1234';
        ba2.ParentId = pa1.Id;
        ba2.Total_Location_Spend_LTM__c = 100;
        ba2.Eyewear_Location_Spend_LTM__c = 100;
        ba2.Optics_Location_Spend_LTM__c = 100;
        ba2.Contract_Type__c = 'Affiliate';
        ba2.Vision_Care_Good_Standing__c = True;
        ba2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        //VC__C is a formula field on the Account
        //IF( Vision_Care_Effective_Date__c <= TODAY() && (Vision_Care_End_Date__c >=TODAY() || ISBLANK(Vision_Care_End_Date__c)) , TRUE, FALSE)
        ba2.Vision_Care_Effective_Date__c = system.today() - 3; 
        
        insert ba2;
        
        Account ba3 = new Account();
        ba3.RecordTypeId = baRecordTypeId;
        ba3.Name = 'BA3 Test 1234';
        ba3.ParentId = pa1.Id;
        ba3.Total_Location_Spend_LTM__c = 100;
        ba3.Eyewear_Location_Spend_LTM__c = 100;
        ba3.Optics_Location_Spend_LTM__c = 100;
        ba3.Contract_Type__c = 'Affiliate';
        //ba3.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        ba3.Vision_Care_Good_Standing__c = True;
        //VC__C is a formula field on the Account
        //IF( Vision_Care_Effective_Date__c <= TODAY() && (Vision_Care_End_Date__c >=TODAY() || ISBLANK(Vision_Care_End_Date__c)) , TRUE, FALSE)
        ba3.Vision_Care_Effective_Date__c = system.today() - 3; 
        
        insert ba3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpContractRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = pa1.Id;
        
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = ba1.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr; 
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
    }
    
    @isTest
    public static void pabaAccAvgTest(){ 
        Test.startTest();
        Account paGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'PA Test 1234' LIMIT 1];
        List<Account> baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name LIKE '%BA%' LIMIT 5];
        
        for(Account ac : baGet){
            ac.Contract_Type__c = 'Affiliate';
        }
        update baGet;
        
        Set<Id> Prac1IdSet = new Set<Id>();
        Prac1IdSet.add(paGet.Id);
        
        VSPR31_Premier_Prac_Bus_Acc_Avg_Batch ba = new VSPR31_Premier_Prac_Bus_Acc_Avg_Batch(Prac1IdSet);
        Database.executeBatch(ba,10);
        
        Test.stopTest();  
        Account ba1Get = [SELECT Id, Name, Vision_Care_Good_Standing__c, VC__c, Contract_Type__c FROM Account WHERE Id IN: baGet Limit 1];
        system.debug('ba Contract Type : ' + ba1Get.Contract_Type__c);
        system.assertEquals(True, ba1Get.VC__c);
        
    }
    @isTest
    public static void pabaAccAvgNullTest(){ 
        Test.startTest();
        Account paGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'PA Test 1234' LIMIT 1];
        List<Account> baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name LIKE '%BA%' LIMIT 5];
        
        for(Account ac : baGet){
            ac.Contract_Type__c = 'Affiliate';
            ac.Total_Location_Spend_LTM__c = null;
            ac.Eyewear_Location_Spend_LTM__c = null;
            ac.Optics_Location_Spend_LTM__c = null;
        }
        update baGet;
        
        Set<Id> Prac1IdSet = new Set<Id>();
        Prac1IdSet.add(paGet.Id);
        
        VSPR31_Premier_Prac_Bus_Acc_Avg_Batch ba = new VSPR31_Premier_Prac_Bus_Acc_Avg_Batch(Prac1IdSet);
        Database.executeBatch(ba,10);
        
        Test.stopTest();  
        Account ba1Get = [SELECT Id, Name, Vision_Care_Good_Standing__c, VC__c, Contract_Type__c, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c 
                          FROM Account WHERE Id IN: baGet Limit 1];
        system.debug('ba Contract Type : ' + ba1Get.Contract_Type__c);
        system.assertEquals('Affiliate', ba1Get.Contract_Type__c);
        system.assertNotEquals(1000, ba1Get.Total_Location_Spend_LTM__c);
        system.assertNotEquals(1000, ba1Get.Eyewear_Location_Spend_LTM__c);
        system.assertNotEquals(1000, ba1Get.Optics_Location_Spend_LTM__c);
        
    }
}