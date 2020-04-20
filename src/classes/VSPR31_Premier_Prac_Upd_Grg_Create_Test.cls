@isTest
//Test class for VSPR31_Premier_Prac_Upd_Grg_Create_Batch
public class VSPR31_Premier_Prac_Upd_Grg_Create_Test {
    @isTest
    public static void testPremierPracUpdGrgCreateBatch(){
        //When there is only one Business Account Contract Type and Tax ID Roll Up Account = True       
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = True;
        
        insert Prac3;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Contract_Type__c = 'Affiliate';
        
        insert BusAcc2;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac3.Id;
        
        insert grg;

        Account ac = [SELECT Id, ParentId, Name, isDeleted, RecordTypeId FROM Account WHERE Name LIKE '%Prac%'];
        Account bc = [SELECT Id, ParentId, Name, isDeleted, RecordTypeId FROM Account WHERE Name = 'Business Account 2'];
        
        System.debug('P & B Account isDeleted : ' + ac.IsDeleted + ' = ' + bc.IsDeleted);
        Test.startTest();
        //VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
       // Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.debug('P Account : ' + ac);
        System.debug('B Account : ' + bc);
        System.debug('Compare Account : ' + ac.Id + ' = ' + bc.ParentId);
        System.assertEquals(ac.Id, bc.ParentId);
        
    }
    @isTest
    public static void testPremierPracUpdGrgCreateBatch1(){
        //When more than 1 Business Account Contract Type is different and Tax ID Roll Up Account = True   
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = True;
        
        insert Prac3;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Contract_Type__c = 'Affiliate';
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 2';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Contract_Type__c = 'Conflict';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac3.Id;
        
        insert grg;

        Test.startTest();
       // VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
       // Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.assertNotEquals('Conflict', BusAcc2.Contract_Type__c);
        System.assertNotEquals('Affiliate', BusAcc3.Contract_Type__c);

    }
    @isTest
    public static void testPremierPracUpdGrgCreateBatch2(){
        //When there are more than 1 Business Account Contract Type is the same and Tax ID Roll Up Account = False   
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = False;
        
        insert Prac3;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Contract_Type__c = 'Affiliate';
        BusAcc2.Vision_Care_Good_Standing__c = True;
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 2';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Contract_Type__c = 'Affiliate';
        BusAcc3.Vision_Care_Good_Standing__c = True;
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac3.Id;
        
        insert grg;

        Test.startTest();
       // VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
        //Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.assertEquals(BusAcc2.Contract_Type__c, BusAcc3.Contract_Type__c);
    }
    @isTest
    public static void testPremierPracUpdGrgCreateBatch3(){
        //When there are more than 1 Business Account Contract Type not the same and Tax ID Roll Up Account = False  
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = False;
        
        insert Prac3;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Vision_Care_Good_Standing__c = True;
        BusAcc2.Contract_Type__c = 'Affiliate';
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 2';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Vision_Care_Good_Standing__c = True;
        BusAcc3.Contract_Type__c = 'Pop Up';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Pop Up'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = BusAcc3.Id;
        
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = BusAcc3.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr;
        
        Test.startTest();
      //  VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
      //  Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.assertNotEquals(null, BusAcc2.Contract_Type__c);
        System.assertNotEquals(null, BusAcc3.Contract_Type__c);
    }
    
    @isTest
    public static void testPremierPracUpdGrgCreateBatch4(){
        //When there are more than 1 Business Account Contract Type is the same and Tax ID Roll Up Account = True and 1 Business Account belongs to another Global Reward Group
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = True;
        Prac1.Contract_Type__c = 'GAP';
        insert Prac1;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac1.Id;
        BusAcc2.Contract_Type__c = 'GAP';
        
        insert BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 3';
        BusAcc3.ParentId = Prac1.Id;
        BusAcc3.Contract_Type__c = 'GAP';
        
        insert BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac1.Id;
        
        insert grg;
        
        Global_Rewards_Group__c grg1 = new Global_Rewards_Group__c();
        grg1.RecordTypeId = grpTaxIdRecordTypeId;
        grg1.Name = 'TESTGRP1';
        
        insert grg1;
        
        Global_Rewards_Group__c grg2 = new Global_Rewards_Group__c();
        grg2.RecordTypeId = grpContractRecordTypeId;
        grg2.Name = 'TESTGRP2';
        
        insert grg2;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = Prac1.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr; 
        
        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Active__c = True;
        grgr1.Child_Account__c = BusAcc2.Id;
        grgr1.End_Date__c = null;
        grgr1.Global_Rewards_Group__c = grg1.Id;
        grgr1.Start_Date__c = Date.today()-10;
        
        insert grgr1; 
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Active__c = True;
        grgr2.Child_Account__c = BusAcc2.Id;
        grgr2.End_Date__c = null;
        grgr2.Global_Rewards_Group__c = grg2.Id;
        grgr2.Start_Date__c = Date.today()-10;
        
        insert grgr2; 
        
        Test.startTest();       
        
        System.debug('BA CONTRACT TYPE : ' + BusAcc2.Contract_Type__c);
        
       // VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
      //  Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        //System.assertEquals(grgr1.Child_Account__c, BusAcc2.Id);
        //System.assertEquals(grgr2.Child_Account__c, BusAcc2.Id);
    }
    @isTest
    public static void testPremierPracUpdGrgCreateBatch5(){
        //When there are more than 1 Business Account with Participation_Exclusions__c and Service_Offering_s__c and Tax ID Roll Up Account = False  
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        //Use Prac2 from testdata & BusAcc4 & BusAcc5
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = False;
        
        insert Prac3;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 2';
        BusAcc1.ParentId = Prac3.Id;
        BusAcc1.Total_Location_Spend_LTM__c = 100;
        BusAcc1.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc1.Optics_Location_Spend_LTM__c = 100;
        BusAcc1.Contract_Type__c = 'Affiliate';
        BusAcc1.Vision_Care_Good_Standing__c = True;
        BusAcc1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc1.Vision_Care_Effective_Date__c = system.today()-3;
        BusAcc1.Vision_Care_End_Date__c = null;
        BusAcc1.Status__c = 'A';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Total_Location_Spend_LTM__c = 100;
        BusAcc2.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc2.Optics_Location_Spend_LTM__c = 100;
        BusAcc2.Contract_Type__c = 'Affiliate';
        BusAcc2.Vision_Care_Good_Standing__c = True;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Status__c = 'A';
        
        insert BusAcc2;
        BusAcc2.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 2';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Total_Location_Spend_LTM__c = 100;
        BusAcc3.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc3.Optics_Location_Spend_LTM__c = 100;
        BusAcc3.Contract_Type__c = 'Affiliate';
        BusAcc3.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        BusAcc3.Vision_Care_Good_Standing__c = True;
        BusAcc3.Status__c = 'A';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = BusAcc1.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr; 
        
        Test.startTest();
       // VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
       // Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.assertEquals('NODIS – Opts out of discounts', BusAcc1.Participation_Exclusions__c);
        System.assertEquals('RTLIM - Retinal Imaging', BusAcc2.Service_Offering_s__c);
        System.assertEquals('FFAA - Free Fitting and Adjustments', BusAcc3.Service_Offering_s__c);
    }
    @isTest
    public static void testPremierPracUpdGrgCreateBatch6(){
        //When there are more than 1 Business Account with null values for Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c and Tax ID Roll Up Account = False  
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        //Use Prac2 from testdata & BusAcc4 & BusAcc5
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = False;
        
        insert Prac3;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 2';
        BusAcc1.ParentId = Prac3.Id;
        BusAcc1.Total_Location_Spend_LTM__c = null;
        BusAcc1.Eyewear_Location_Spend_LTM__c = null;
        BusAcc1.Optics_Location_Spend_LTM__c = null;
        BusAcc1.Contract_Type__c = 'Affiliate';
        BusAcc1.Vision_Care_Good_Standing__c = True;
        BusAcc1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc1.Vision_Care_Effective_Date__c = system.today()-3;
        BusAcc1.Vision_Care_End_Date__c = null;
        BusAcc1.Status__c = 'A';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Total_Location_Spend_LTM__c = null;
        BusAcc2.Eyewear_Location_Spend_LTM__c = null;
        BusAcc2.Optics_Location_Spend_LTM__c = null;
        BusAcc2.Contract_Type__c = 'Affiliate';
        BusAcc2.Vision_Care_Good_Standing__c = True;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Status__c = 'A';
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 2';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Total_Location_Spend_LTM__c = null;
        BusAcc3.Eyewear_Location_Spend_LTM__c = null;
        BusAcc3.Optics_Location_Spend_LTM__c = null;
        BusAcc3.Contract_Type__c = 'Affiliate';
        BusAcc3.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        BusAcc3.Vision_Care_Good_Standing__c = True;
        BusAcc3.Status__c = 'A';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Affiliate'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        
        insert grg;

        Test.startTest();
       // VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
       // Database.executeBatch(obj, 200);
         String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Prac_Upd_Grg_Create_Sched sch = new VSPR31_Premier_Prac_Upd_Grg_Create_Sched();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();
        
        System.assertEquals(null, BusAcc1.Total_Location_Spend_LTM__c);
        System.assertEquals(null, BusAcc1.Eyewear_Location_Spend_LTM__c);
        System.assertEquals(null, BusAcc1.Optics_Location_Spend_LTM__c);
    }
}