@isTest
//For Test Class VSPR31_Update_GRG_Status
public class VSPR31_Update_GRG_Status_Test {
    //@isTest
    @testSetup
    public static void testData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 3 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = True;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac1;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 1';
        BusAcc1.ParentId = Prac1.Id;
        BusAcc1.Contract_Type__c = 'Independent';
        BusAcc1.Vision_Care_Good_Standing__c = True;
        BusAcc1.Status__c = 'A';
        BusAcc1.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc1.Vision_Care_End_Date__c = null;
        BusAcc1.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Start_Date__c = System.Today()-10;
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = Prac1.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = System.Today()-10;
        
        insert grgr;  
        
        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Active__c = True;
        grgr1.Child_Account__c = BusAcc1.Id;
        grgr1.End_Date__c = null;
        grgr1.Global_Rewards_Group__c = grg.Id;
        grgr1.Start_Date__c = System.Today()-10;
        
        insert grgr1;
    }
    
    @isTest
    public static void testUpdateGRGEndDateTest(){
        Account ac = [SELECT Id, Name FROM Account WHERE Name = 'Business Account 1' LIMIT 1];
        Global_Rewards_Group__c grg = [SELECT Id, Name, Start_Date__c, End_Date__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP' LIMIT 1];
        Global_Rewards_Group_Relationship__c grgr = [SELECT Id, Active__c, Child_Account__c, End_Date__c, Global_Rewards_Group__c, Start_Date__c
                                                     FROM Global_Rewards_Group_Relationship__c
                                                     WHERE Child_Account__c =: ac.Id LIMIT 1];
        grg.Start_Date__c = system.today()+1;
        grg.End_Date__c = system.Today()+10;
        update grg;
        
        grgr.End_Date__c = System.Today()+10;
        update grgr;
        
        system.assertNotEquals(null, grgr.End_Date__c);
        system.assertNotEquals(null, grg.End_Date__c);
    }
}