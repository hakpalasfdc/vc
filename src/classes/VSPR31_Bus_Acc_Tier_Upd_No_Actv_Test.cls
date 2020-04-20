@isTest
//Test class for VSPR31_Bus_Acc_Tier_Upd_Not_Actv_Batch
public class VSPR31_Bus_Acc_Tier_Upd_No_Actv_Test {
    @testSetup
    public static void testdata(){
        Id baRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        
        Test.startTest();
        Account ba1 = new Account();
        ba1.RecordTypeId = baRecordTypeId;
        ba1.Name = 'BA Test 1234';
        //ba1.ParentId = pa1.Id;
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
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpContractRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = ba1.Id;
        
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = ba1.Id;
        grgr.End_Date__c = system.today();
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = system.today()-10;
        
        insert grgr; 
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
    }
    @isTest
    public static void noActiveGRGRTest(){
        Test.startTest();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        Global_Rewards_Group_Relationship__c grgrGet = [SELECT Id, Child_Account__c, Global_Rewards_Group__c, End_Date__c FROM Global_Rewards_Group_Relationship__c
                                                                 WHERE Global_Rewards_Group__c =: grgGet.Id AND Child_Account__c =: baGet.Id];
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Not_Actv_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Not_Actv_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        Date TodayDate = Date.today();
        System.assertEquals(TodayDate, grgrGet.End_Date__c);
    }
}