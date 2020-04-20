@isTest
//Test class for VSPR31_Prac_Acc_Tier_Update_Batch
public class VSPR31_Prac_Acc_Tier_Update_Test {
    
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
    //When Practice Account Qualifies for a lower tier OR Same Tier 
    public static void testPracAccTierUpdateBatch(){
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Premier_Tier__c ThirdT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Third' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        Prac1.Applied_Tier__c = ThirdT.Id;
        Prac1.Tier_Agreement_Type__c = null;
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();  
        system.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    @isTest
    //When Practice Account Qualifies doesn't have an applied and calc tier
    public static void testPracAccTierUpdateBatch1(){
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondTCC = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second CC' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        Prac1.Applied_Tier__c = SecondTCC.Id;
        Prac1.Tier_Agreement_Type__c = null;
        Prac1.Override_Tier_Effective_Date__c = system.today()-7;
        Prac1.Override_Tier_End_Date__c = system.today()-5;
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        system.assertNotEquals(null, SecondTCC.Id);
    }
    @isTest
    //When Practice Account Agreement Tier is not null and qualifies for the same or lower tier
    public static void testPracAccTierUpdateBatch2(){
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP3';
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        Prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Retinal_Imaging_Indicator__c = true;
        update Prac1;
        System.debug('Prac Account Applied Tier ' + Prac1.Applied_Tier__c);
        
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
        BusAcc1.Contract_Type__c = 'Conflict'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.debug('Prac Account Applied Tier ' + Prac1.Applied_Tier__c);
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    @isTest
    public static void testPracAccTierUpdateBatch3(){
        //When Practice Account Agreement Tier is not null and GRG doesn't have any applied and calc tier
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c =  Date.newInstance(2019, 7, 1);
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP3';
        Prac1.Override_Tier_Effective_Date__c = Date.newInstance(2019, 6, 24); 
        Prac1.Override_Tier_End_Date__c = Date.newInstance(2019, 6, 27); 
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        Prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Retinal_Imaging_Indicator__c = true;
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.debug('Prac Account Applied Tier ' + Prac1.Applied_Tier__c);
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    @isTest
    public static void testPracAccTierUpdateBatch4(){
        //No Agreement Type Tier was set on Group, then looks at all tiers and GRG now qualifies for lower or same tier
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP1';
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    
    @isTest
    public static void testPracAccTierUpdateBatch5(){
        //No Agreement Type Tier and GRG doesn't have any applied and calc tier

        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = Date.newInstance(2019, 7, 1);//system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP1';
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    
    @isTest
    public static void testPracAccTierUpdateBatch6(){
        //No Agreement Type Tier and GRG doesn't have any applied and calc tier
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = Date.newInstance(2019, 9, 1);//system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Retinal_Imaging_Indicator__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP1';
        Prac1.Override_Tier_Effective_Date__c = Date.newInstance(2019, 6, 25);
        Prac1.Override_Tier_End_Date__c = Date.newInstance(2019, 6, 27); 
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 7, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    @isTest
    public static void testPracAccTierUpdateBatch7(){
        //Account didn't qualify for any tier        
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondTCC = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second CC' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = false;
        Prac1.Retinal_Imaging_Indicator__c = false;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 10;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 10;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 10;
        Prac1.Contract_Type__c = 'GAP';
        Prac1.Applied_Tier__c = SecondTCC.Id;
        Prac1.Tier_Agreement_Type__c = null;
        Prac1.Override_Tier_Effective_Date__c = Date.newInstance(2019, 7, 25);
        Prac1.Override_Tier_End_Date__c = Date.newInstance(2019, 7, 28); 
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        system.assertNotEquals(null, SecondTCC.Id);
    }
    @isTest
    public static void testPracAccTierUpdateBatch8(){
        //Account didn't qualify for any tier  
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = false;
        Prac1.Retinal_Imaging_Indicator__c = false;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP1';
        Prac1.Override_Tier_Effective_Date__c = Date.newInstance(2019, 7, 25);
        Prac1.Override_Tier_End_Date__c = Date.newInstance(2019, 7, 27); 
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
    
    @isTest
    public static void testPracAccTierUpdateBatch9(){
        //NON Qualifying Practice Account
        Test.startTest();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Premier_Tier__c FirstT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c SecondT = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = null;//system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = false;
        Prac1.Free_Fitting_and_Adjustments__c = false;
        Prac1.Retinal_Imaging_Indicator__c = false;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Total_Average_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Frame_Purchases_LTM_Calculated__c = 1000;
        Prac1.Average_Lens_Purchases_LTM_Calculated__c = 1000;
        Prac1.Contract_Type__c = 'GAP';
        prac1.Applied_Tier__c = SecondT.Id;
        Prac1.Tier_Agreement_Type__c = 'DOLP1';
        Prac1.Override_Tier_Effective_Date__c = Date.newInstance(2019, 7, 25);
        Prac1.Override_Tier_End_Date__c = Date.newInstance(2019, 7, 27); 
        
        insert Prac1;
        Prac1.Contract_Type__c = 'GAP';
        update Prac1;
        
        VSPR31_Prac_Acc_Tier_Update_Batch ba = new VSPR31_Prac_Acc_Tier_Update_Batch();
        ba.todayDate = Date.newInstance(2019, 8, 1);    
        Database.executeBatch(ba,10);
        
        Test.stopTest();
        System.assertNotEquals(null, Prac1.Applied_Tier__c);
    }
}