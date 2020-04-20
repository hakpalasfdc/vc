@isTest
//Test class for VSPR31_Grg_Path_To_Premier_Batch
public class VSPR31_Grg_Path_To_Premier_Test {
    @isTest
    public static void testGrgPathToPremierBatch(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Test.startTest();
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac3.Vision_Care_End_Date__c = system.today() + 1;
        Prac3.Vision_Care_Good_Standing__c = true;
        Prac3.Free_Fitting_and_Adjustments__c = true;
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = True;
        //Prac3.Contract_Type__c = 'Conflict';
        insert Prac3;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 1';
        BusAcc1.ParentId = Prac3.Id;
        BusAcc1.Total_Location_Spend_LTM__c = 100;
        BusAcc1.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc1.Optics_Location_Spend_LTM__c = 100;
        BusAcc1.Contract_Type__c = 'Conflict';
        BusAcc1.Vision_Care_Good_Standing__c = True;
        BusAcc1.Status__c = 'A';
        BusAcc1.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc1.Vision_Care_End_Date__c = null;
        BusAcc1.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        //BusAcc1.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc1;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Total_Location_Spend_LTM__c = 100;
        BusAcc2.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc2.Optics_Location_Spend_LTM__c = 100;
        BusAcc2.Contract_Type__c = 'Conflict';
        BusAcc2.Vision_Care_Good_Standing__c = True;
        BusAcc2.Status__c = 'A';
        BusAcc2.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc2.Vision_Care_End_Date__c = null;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc2.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 3';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Total_Location_Spend_LTM__c = 100;
        BusAcc3.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc3.Optics_Location_Spend_LTM__c = 100;
        BusAcc3.Contract_Type__c = 'Independent';
        BusAcc3.Vision_Care_Good_Standing__c = True;
        BusAcc3.Status__c = 'A';
        BusAcc3.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc3.Vision_Care_End_Date__c = null;
        BusAcc3.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc3.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //BusAcc3.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac3.Id;
        grg.Start_Date__c = Date.today();
        //grg.Parent_Account__c = BusAcc1.Id;
        insert grg;

        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = Prac3.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr;  
        
        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Active__c = True;
        grgr1.Child_Account__c = BusAcc1.Id;
        grgr1.End_Date__c = null;
        grgr1.Global_Rewards_Group__c = grg.Id;
        grgr1.Start_Date__c = Date.today()-10;
        
        insert grgr1;  
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Active__c = True;
        grgr2.Child_Account__c = BusAcc2.Id;
        grgr2.End_Date__c = null;
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Start_Date__c = Date.today()-10;
        
        insert grgr2;  
        
        Global_Rewards_Group_Relationship__c grgr3 = new Global_Rewards_Group_Relationship__c();
        grgr3.Active__c = True;
        grgr3.Child_Account__c = BusAcc3.Id;
        grgr3.End_Date__c = null;
        grgr3.Global_Rewards_Group__c = grg.Id;
        grgr3.Start_Date__c = Date.today()-10;
        
        insert grgr3;  
        
        Database.executeBatch(new VSPR31_Grg_Path_To_Premier_Batch());
        
        Test.stopTest();
        
        System.assertNotEquals(null, BusAcc1.Contract_Type__c);
        System.assertNotEquals(null, BusAcc2.Contract_Type__c);
        System.assertNotEquals(null, BusAcc3.Contract_Type__c);
    }
    @isTest
    public static void testGrgPathToPremierBatch1(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Test.startTest();
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac3.Vision_Care_End_Date__c = system.today() + 1;
        Prac3.Vision_Care_Good_Standing__c = true;
        Prac3.Free_Fitting_and_Adjustments__c = true;
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = True;
        //Prac3.Contract_Type__c = 'Conflict';
        insert Prac3;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 1';
        BusAcc1.ParentId = Prac3.Id;
        BusAcc1.Total_Location_Spend_LTM__c = null;
        BusAcc1.Eyewear_Location_Spend_LTM__c = null;
        BusAcc1.Optics_Location_Spend_LTM__c = null;
        BusAcc1.Contract_Type__c = 'Conflict';
        BusAcc1.Vision_Care_Good_Standing__c = True;
        BusAcc1.Status__c = 'A';
        BusAcc1.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc1.Vision_Care_End_Date__c = null;
        //BusAcc1.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        //BusAcc1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        //BusAcc1.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc1;
   
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac3.Id;
        BusAcc2.Total_Location_Spend_LTM__c = null;
        BusAcc2.Eyewear_Location_Spend_LTM__c = null;
        BusAcc2.Optics_Location_Spend_LTM__c = null;
        BusAcc2.Contract_Type__c = 'Conflict';
        BusAcc2.Vision_Care_Good_Standing__c = True;
        BusAcc2.Status__c = 'A';
        BusAcc2.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc2.Vision_Care_End_Date__c = null;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc2.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc2;
        //BusAcc2.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc2;
        
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 3';
        BusAcc3.ParentId = Prac3.Id;
        BusAcc3.Total_Location_Spend_LTM__c = null;
        BusAcc3.Eyewear_Location_Spend_LTM__c = null;
        BusAcc3.Optics_Location_Spend_LTM__c = null;
        BusAcc3.Contract_Type__c = 'Independent';
        BusAcc3.Vision_Care_Good_Standing__c = True;
        BusAcc3.Status__c = 'A';
        BusAcc3.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc3.Vision_Care_End_Date__c = null;
        BusAcc3.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc3.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //BusAcc3.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc3;
        //BusAcc3.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        //update BusAcc3;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        grg.Parent_Account__c = Prac3.Id;
        grg.Start_Date__c = Date.today();
        //grg.Parent_Account__c = BusAcc1.Id;
        insert grg;

        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = Prac3.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr;  
        
        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Active__c = True;
        grgr1.Child_Account__c = BusAcc1.Id;
        grgr1.End_Date__c = null;
        grgr1.Global_Rewards_Group__c = grg.Id;
        grgr1.Start_Date__c = Date.today()-10;
        
        insert grgr1;  
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Active__c = True;
        grgr2.Child_Account__c = BusAcc2.Id;
        grgr2.End_Date__c = null;
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Start_Date__c = Date.today()-10;
        
        insert grgr2;  
        
        Global_Rewards_Group_Relationship__c grgr3 = new Global_Rewards_Group_Relationship__c();
        grgr3.Active__c = True;
        grgr3.Child_Account__c = BusAcc3.Id;
        grgr3.End_Date__c = null;
        grgr3.Global_Rewards_Group__c = grg.Id;
        grgr3.Start_Date__c = Date.today()-10;
        
        insert grgr3;  
                
        
        VSPR31_Grg_Path_To_Premier_Batch obj = new VSPR31_Grg_Path_To_Premier_Batch();
        Database.executeBatch(obj, 200);        
        Test.stopTest();
        
        System.assertNotEquals(null, BusAcc1.Contract_Type__c);
        System.assertNotEquals(null, BusAcc2.Contract_Type__c);
        System.assertNotEquals(null, BusAcc3.Contract_Type__c);
        System.assertEquals(null, BusAcc1.Total_Location_Spend_LTM__c);
        System.assertEquals(null, BusAcc1.Eyewear_Location_Spend_LTM__c);
        System.assertEquals(null, BusAcc1.Optics_Location_Spend_LTM__c);
    }
}