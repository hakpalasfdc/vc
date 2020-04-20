@isTest
//Test class for VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch
public class VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Test {
    @testSetup
    public static void testdata(){
        Id baRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        
        Premier_Tier__c FirstT = new Premier_Tier__c();
        FirstT.Name = 'First';
        FirstT.Description__c = 'First Description';
        FirstT.Effective_Date__c = Date.today();
        FirstT.Hierarchy_Action__c = 'Top_Tier';
        FirstT.Contract_Type__c = 'Contract';
        FirstT.Order__c = 1;
        FirstT.Status__c = 'Active';
        FirstT.Retinal_Imaging_Indicator__c = true;
        FirstT.Free_Fitting_and_Adjustments__c = false;
        FirstT.Exclusive_VSP_Patient_Offers__c = true;
        FirstT.Total_Purchases_LTM__c = 0;
        FirstT.Eyewear_Minimum__c = 0;
        FirstT.Lens_Minimum__c = 0;
        
        insert FirstT;
        System.debug('Tier Batch Test First Tier + ' + FirstT);
        
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
        //ba1.Vision_Care_End_Date__c = null;
        
        insert ba1;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpContractRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = ba1.Id;
        
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
    public static void visionCareGoodStandingFalseTest(){
        Test.startTest();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        baGet.Vision_Care_Good_Standing__c = False;
        
        update baGet;
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        
        System.assertEquals(False, baGet.Vision_Care_Good_Standing__c);
    }
    
    @isTest
    public static void visionCareGoodStandingTrueTest(){
        Test.startTest();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        
        System.assertEquals(True, baGet.Vision_Care_Good_Standing__c);
    }
    
    @isTest
    public static void grgTaxIdRollUpContractTypeTest(){
        Test.startTest();
        Id grpTaxIdRollUpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        Premier_Tier__c FirstTCC = [SELECT Id, Contract_Type__c FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c, Contract_Type__c, Applied_Tier__c 
                                          FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        
        grgGet.Applied_Tier__c = FirstTCC.Id;
        grgGet.RecordTypeId = grpTaxIdRollUpContractRecordTypeId;
        update grgGet;
        
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        
        System.assertNotEquals(null, grgGet.Applied_Tier__c);
    }
    @isTest
    public static void grgTaxIdRollUpTest(){
        Test.startTest();
        Id grpTaxIdRollUpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        Premier_Tier__c FirstTCC = [SELECT Id, Contract_Type__c FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c, Contract_Type__c, Applied_Tier__c 
                                          FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        
        grgGet.Applied_Tier__c = FirstTCC.Id;
        grgGet.RecordTypeId = grpTaxIdRollUpContractRecordTypeId;
        update grgGet;
        
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        
        System.assertNotEquals(null, grgGet.Applied_Tier__c);
    }
    @isTest
    public static void grgContractTypeTest(){
        Test.startTest();
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        Premier_Tier__c FirstTCC = [SELECT Id, Contract_Type__c FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        
        Global_Rewards_Group__c grgGet = [SELECT Id, RecordTypeId, Name, Parent_Account__c, Contract_Type__c, Applied_Tier__c 
                                          FROM Global_Rewards_Group__c WHERE Parent_Account__c =: baGet.Id LIMIT 1];
        
        grgGet.Applied_Tier__c = FirstTCC.Id;
        update grgGet;
        
        Set<Id> grgIdSet = new Set<Id>();
        grgIdSet.add(grgGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(grgIdSet);  
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        
        System.assertNotEquals(null, grgGet.Applied_Tier__c);
    }
}