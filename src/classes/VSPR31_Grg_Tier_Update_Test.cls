@isTest
//Test class for VSPR31_Grg_Tier_Update_Batch
public class VSPR31_Grg_Tier_Update_Test {
    @TestSetup
    static void testData(){
        
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
        
        Premier_Tier__c SecondT = new Premier_Tier__c();
        SecondT.Name = 'Second';
        SecondT.Description__c = 'Second Description';
        SecondT.Effective_Date__c = Date.today() - 1;
        SecondT.Hierarchy_Action__c = '<';
        SecondT.Contract_Type__c = 'Contract';
        SecondT.Order__c = 2;
        SecondT.Status__c = 'Active';
        SecondT.Hierarchy_Selection__c = FirstT.Id;
        SecondT.Retinal_Imaging_Indicator__c = true;
        SecondT.Free_Fitting_and_Adjustments__c = false;
        SecondT.Exclusive_VSP_Patient_Offers__c = true;
        SecondT.Total_Purchases_LTM__c = 0;
        SecondT.Eyewear_Minimum__c = 0;
        SecondT.Lens_Minimum__c = 0;
        SecondT.Agreement_Type__c = 'DOLP3';
        
        insert SecondT;
        
        System.debug('Tier Batch Test First Tier + ' + SecondT);
        
        Premier_Tier__c ThirdT = new Premier_Tier__c();  
        ThirdT.Name = 'Third';
        ThirdT.Description__c = 'Third Description';
        ThirdT.Effective_Date__c = Date.today();
        //  ThirdT.End_Date__c = Date.today() - 3;
        ThirdT.Hierarchy_Action__c = '<';
        ThirdT.Contract_Type__c = 'GAP';
        ThirdT.Order__c = 3;
        ThirdT.Status__c = 'Active';
        ThirdT.Hierarchy_Selection__c = SecondT.Id;
        ThirdT.Retinal_Imaging_Indicator__c = true;
        ThirdT.Free_Fitting_and_Adjustments__c = false;
        ThirdT.Exclusive_VSP_Patient_Offers__c = true;
        ThirdT.Total_Purchases_LTM__c = 10;
        ThirdT.Eyewear_Minimum__c = 0;
        ThirdT.Lens_Minimum__c = 0;
        
        insert ThirdT;
        
        ////CC flags all checked
        Premier_Tier__c FirstTCC = new Premier_Tier__c();
        FirstTCC.Name = 'First CC';
        FirstTCC.Description__c = 'First CC Description';
        FirstTCC.Effective_Date__c = Date.today();
        FirstTCC.Hierarchy_Selection__c = ThirdT.Id;
        FirstTCC.Hierarchy_Action__c = '<';
        FirstTCC.Contract_Type__c = 'CC';
        FirstTCC.Order__c = 4;
        FirstTCC.Status__c = 'Active';
        FirstTCC.Retinal_Imaging_Indicator__c = true;
        FirstTCC.Free_Fitting_and_Adjustments__c = true;
        FirstTCC.Exclusive_VSP_Patient_Offers__c = true;
        FirstTCC.Total_Purchases_LTM__c = 100;
        FirstTCC.Eyewear_Minimum__c = 0;
        FirstTCC.Lens_Minimum__c = 0;
        FirstTcc.Contract_Type__c = 'Independent';
        
        insert FirstTCC;
        
        Premier_Tier__c SecondTCC = new Premier_Tier__c();
        SecondTCC.Name = 'Second CC';
        SecondTCC.Description__c = 'Second CC Description';
        SecondTCC.Effective_Date__c = Date.today() - 1;
        SecondTCC.Hierarchy_Action__c = '<';
        SecondTCC.Contract_Type__c = 'CC';
        SecondTCC.Order__c = 5;
        SecondTCC.Status__c = 'Active';
        SecondTCC.Hierarchy_Selection__c = FirstTCC.Id;
        SecondTCC.Retinal_Imaging_Indicator__c = true;
        SecondTCC.Free_Fitting_and_Adjustments__c = true;
        SecondTCC.Exclusive_VSP_Patient_Offers__c = true;
        SecondTCC.Total_Purchases_LTM__c = 50;
        SecondTCC.Eyewear_Minimum__c = 0;
        SecondTCC.Lens_Minimum__c = 0;
        
        insert SecondTCC;
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
    }
    
    @isTest
    public static void testGrgTierUpdateBatch(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c FirstTCC = [SELECT Id, Contract_Type__c FROM Premier_Tier__c WHERE Name = 'First CC' LIMIT 1];
        
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
        //Prac1.Override_Tier_Effective_Date__c = system.today() -3;
        insert Prac1;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 1';
        BusAcc1.ParentId = Prac1.Id;
        BusAcc1.Total_Location_Spend_LTM__c = 100;
        BusAcc1.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc1.Optics_Location_Spend_LTM__c = 100;
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
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = FirstTCC.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 1; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = true;
        grg.Exclusive_VSP_Patient_Offers__c = true;
        grg.Retinal_Imaging_Indicator_Future__c = true;
        grg.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = Prac1.Id;
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
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertEquals('Independent', FirstTcc.Contract_Type__c);
    }
    
    
    @isTest
    public static void testGrgTierUpdateBatch1(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c ThirdT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Third' LIMIT 1];
        
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = ThirdT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = True;
        grg.Start_Date__c = Date.newInstance(2019, 8, 1); 
        grg.Tier_Agreement_Type__c = 'DOLP3';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = Date.newInstance(2019, 8, 1); 
        grg.Override_End_Date__c = Date.newInstance(2019, 8, 1); 
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);        
    }
    @isTest
    public static void testGrgTierUpdateBatch2(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c ThirdT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Third' LIMIT 1];
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = ThirdT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 100;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 100; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = True;
        grg.Start_Date__c = system.today() - 3;
        //grg.Tier_Agreement_Type__c = 'DOLP3';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c =system.today() - 2;
        grg.Override_End_Date__c = system.today()-1;
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
    @isTest
    public static void testGrgTierUpdateBatch3(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = SecondT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 100;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 100; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = True;
        grg.Start_Date__c = Date.newInstance(2019, 7, 25); 
        grg.Tier_Agreement_Type__c = 'DOLP4';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = null;
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
    @isTest
    public static void testGrgTierUpdateBatch4(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = SecondT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 100;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 100; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = True;
        grg.Start_Date__c = Date.newInstance(2019, 7, 1);  
        grg.Tier_Agreement_Type__c = 'DOLP4';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = Date.newInstance(2019, 6, 10); 
        grg.Override_End_Date__c = Date.newInstance(2019, 6, 20); 
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
    @isTest
    public static void testGrgTierUpdateBatch5(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = SecondT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = True;
        grg.Start_Date__c = Date.newInstance(2019, 8, 1);   
        grg.Tier_Agreement_Type__c = 'DOLP3';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
    
    @isTest
    public static void testGrgTierUpdateBatch6(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c FirstTCC = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First CC' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 3 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 39;
        Prac1.Vision_Care_End_Date__c = system.today() - 1;
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
        BusAcc1.Total_Location_Spend_LTM__c = 100;
        BusAcc1.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc1.Optics_Location_Spend_LTM__c = 100;
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
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = FirstTCC.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 1; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = true;
        grg.Exclusive_VSP_Patient_Offers__c = true;
        grg.Retinal_Imaging_Indicator_Future__c = true;
        grg.Start_Date__c = Date.newInstance(2019, 6, 25);  
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = Date.newInstance(2019, 6, 25); 
        grg.Override_End_Date__c = Date.newInstance(2019, 6, 26); 
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
    @isTest
    public static void testGrgTierUpdateBatch7(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c FirstTCC = [SELECT Id, Contract_Type__c FROM Premier_Tier__c WHERE Name = 'First CC' LIMIT 1];
        
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
        BusAcc1.Total_Location_Spend_LTM__c = 100;
        BusAcc1.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc1.Optics_Location_Spend_LTM__c = 100;
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
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = FirstTCC.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 1; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = true;
        grg.Exclusive_VSP_Patient_Offers__c = true;
        grg.Retinal_Imaging_Indicator_Future__c = true;
        grg.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 1, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertEquals('Independent', FirstTcc.Contract_Type__c);
    }
    
    @isTest
    public static void testGrgTierUpdateBatch8(){
        //Group didn't qualify for any tier
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = null; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 1; 
        grg.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = true;
        grg.Exclusive_VSP_Patient_Offers__c = true;
        grg.Retinal_Imaging_Indicator_Future__c = false;
        grg.Start_Date__c = Date.newInstance(2019, 6, 25);  
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = Date.newInstance(2019, 6, 25); 
        grg.Override_End_Date__c = Date.newInstance(2019, 6, 26); 
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertEquals(null, grg.Applied_Tier__c);  
        
    }
    @isTest
    public static void testGrgTierUpdateBatch10(){
        //Group didn't qualify for any tier
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpTaxIdRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = SecondT.Id; 
        //grg.Applied_Tier__r.Order__c =;
        grg.Calculated_Tier__c = null; 
        grg.Premier_Location_Count_Future__c = 3; 
        grg.Average_Tiering_Total_Spend_LTM__c = 100;
        grg.Average_Tiering_Eyewear_Spend_LTM__c = 100; 
        grg.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg.Free_Fitting_and_Adjustments__c = True;
        grg.Exclusive_VSP_Patient_Offers__c = True;
        grg.Retinal_Imaging_Indicator_Future__c = false;
        grg.Start_Date__c = Date.newInstance(2019, 7, 1);  
        grg.Tier_Agreement_Type__c = 'DOLP4';
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        grg.Override_Effective_Date__c = Date.newInstance(2019, 6, 10); 
        grg.Override_End_Date__c = Date.newInstance(2019, 6, 20); 
        insert grg;
        
        Test.startTest();
        VSPR31_Grg_Tier_Update_Batch ba = new VSPR31_Grg_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        Test.stopTest();
        System.assertNotEquals(null, grg.Applied_Tier__c);  
    }
}