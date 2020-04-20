@isTest
private class VSPR32_Override_Tier_Update_Sch_Test {
    
    @TestSetup
    public static void testData(){
        
         
        Premier_Tier__c FirstTHi = new Premier_Tier__c();
        FirstTHi.Name = 'First with High';
        FirstTHi.Description__c = 'First Description';
        FirstTHi.Effective_Date__c = Date.today();
        FirstTHi.Hierarchy_Action__c = 'Top_Tier';
        FirstTHi.Contract_Type__c = 'Independent';
        FirstTHi.Agreement_Type__c = 'DOLP1';
        FirstTHi.Retinal_Imaging_Indicator__c = false;
        FirstTHi.Free_Fitting_and_Adjustments__c = false;
        FirstTHi.Exclusive_VSP_Patient_Offers__c = false;
        FirstTHi.Total_Purchases_LTM__c = 1000;
        FirstTHi.Eyewear_Minimum__c = 100;
        FirstTHi.Lens_Minimum__c = 100;
        FirstTHi.Status__c = 'Active';
        FirstTHi.Order__c = 1;
        
        insert FirstTHi;
        
        
        Premier_Tier__c FirstT = new Premier_Tier__c();
        FirstT.Name = 'First';
        FirstT.Description__c = 'First Description';
        FirstT.Effective_Date__c = Date.today();
        FirstT.Hierarchy_Action__c = '<';
        FirstT.Contract_Type__c = 'Independent';
        FirstT.Hierarchy_Selection__c = FirstTHi.Id;
        FirstT.Retinal_Imaging_Indicator__c = false;
        FirstT.Free_Fitting_and_Adjustments__c = false;
        FirstT.Exclusive_VSP_Patient_Offers__c = false;
        FirstT.Total_Purchases_LTM__c = 1000;
        FirstT.Eyewear_Minimum__c = 100;
        FirstT.Lens_Minimum__c = 100;
        FirstT.Status__c = 'Active';
        FirstT.Order__c = 2;
        
        insert FirstT;
        
        Premier_Tier__c SecondT = new Premier_Tier__c();
        SecondT.Name = 'Second';
        SecondT.Description__c = 'Second Description';
        SecondT.Effective_Date__c = Date.today();
        SecondT.Hierarchy_Action__c = '<';
        SecondT.Contract_Type__c = 'Independent';
        SecondT.Hierarchy_Selection__c = FirstT.Id;
        SecondT.Retinal_Imaging_Indicator__c = false;
        SecondT.Free_Fitting_and_Adjustments__c = false;
        SecondT.Exclusive_VSP_Patient_Offers__c = false;
        SecondT.Total_Purchases_LTM__c = 500;
        SecondT.Eyewear_Minimum__c = 500;
        SecondT.Lens_Minimum__c = 500;
        SecondT.Status__c = 'Active';
        SecondT.Order__c = 3;
        
        insert SecondT;
        
        SecondT.Status__c = 'Inactive';
        update SecondT;
        
        Premier_Tier__c ThirdT = new Premier_Tier__c();
        ThirdT.Name = 'Third';
        ThirdT.Description__c = 'Third Description';
        ThirdT.Effective_Date__c = Date.today();
        ThirdT.Hierarchy_Action__c = '<';
        ThirdT.Contract_Type__c = 'Independent';
        ThirdT.Hierarchy_Selection__c = SecondT.Id;
        ThirdT.Retinal_Imaging_Indicator__c = false;
        ThirdT.Free_Fitting_and_Adjustments__c = false;
        ThirdT.Exclusive_VSP_Patient_Offers__c = false;
        ThirdT.Total_Purchases_LTM__c = Null;
        ThirdT.Eyewear_Minimum__c = Null;
        ThirdT.Lens_Minimum__c = Null;
        ThirdT.Status__c = 'Active';
        ThirdT.Order__c = 4;
        
        insert ThirdT;
        
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        
        
    }
    public static testmethod void PracBusOverrideStart(){
        VSPUtility.stopAccountTrigger=true;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
      //  Set<Id> PracIdSet = new Set<Id>();
        
        Premier_Tier__c First = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c Second = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 3 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Contract_Type__c = 'Independent';
        Prac1.Applied_Tier__c = Second.Id;
        Prac1.Calculated_Tier__c = Second.Id;
        Prac1.Override_Tier_Effective_Date__c = Date.today();
        Prac1.Override_Tier_Reason__c = 'Testing';
        Prac1.VC__c = True;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac1;
        
     //   PracIdSet.add(Prac1.Id);
        
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
        BusAcc1.Applied_Tier__c = First.Id;
        BusAcc1.Calculated_Tier__c = First.Id;
        BusAcc1.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        
        
        
        Account Prac2 = new Account();
        Prac2.RecordTypeId = accRecordTypeId;
        Prac2.Name = 'Practice 3 Account';
        Prac2.Status__c = 'A';
        Prac2.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac2.Vision_Care_End_Date__c = system.today() + 1;
        Prac2.Vision_Care_Good_Standing__c = True;
        Prac2.Free_Fitting_and_Adjustments__c = true;
        Prac2.Tax_ID__c = '123456789';
        Prac2.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac2.Contract_Type__c = 'Independent';
        Prac2.Applied_Tier__c = Second.Id;
        Prac2.Calculated_Tier__c = Second.Id;
        Prac2.Override_Tier_Effective_Date__c = Date.today();
        Prac2.Override_Tier_Reason__c = 'Testing';
        Prac2.VC__c = True;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac2;
        
     //   PracIdSet.add(Prac2.Id);
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac2.Id;
        BusAcc2.Total_Location_Spend_LTM__c = 100;
        BusAcc2.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc2.Optics_Location_Spend_LTM__c = 100;
        BusAcc2.Contract_Type__c = 'Independent';
        BusAcc2.Vision_Care_Good_Standing__c = False;
        BusAcc2.Status__c = 'A';
        BusAcc2.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc2.Vision_Care_End_Date__c = null;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc2.Applied_Tier__c = First.Id;
        BusAcc2.Calculated_Tier__c = First.Id;
        BusAcc2.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc2;
        BusAcc2.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc2;
        
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac3.Vision_Care_End_Date__c = system.today() + 1;
        Prac3.Vision_Care_Good_Standing__c = true;
        Prac3.Free_Fitting_and_Adjustments__c = true;
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac3.Contract_Type__c = 'Independent';
        Prac3.Applied_Tier__c = Null;
        Prac3.Calculated_Tier__c = Null;
        Prac3.Override_Tier_Effective_Date__c = Date.today();
        Prac3.Override_Tier_Reason__c = 'Testing';
        Prac3.VC__c = True;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac3;
        
      //  PracIdSet.add(Prac3.Id);
        
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
        BusAcc3.Applied_Tier__c = First.Id;
        BusAcc3.Calculated_Tier__c = First.Id;
        BusAcc3.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc3;
        BusAcc3.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc3;
        
        VSPR32_Override_Bus_Acc_Tier_Prac_Batch job = new VSPR32_Override_Bus_Acc_Tier_Prac_Batch();
        Test.startTest();
        Id jobId1 = Database.executeBatch(job);
        Test.stopTest();
        BusAcc1 = [SELECT Id, Applied_Tier__c FROM Account WHERE Name = 'Business Account 1' LIMIT 1];
        system.assertEquals(Second.Id, BusAcc1.Applied_Tier__c);
    }
    
/*    public static testmethod void PracBusOverrideEnd(){
        VSPUtility.stopAccountTrigger=true;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        
        Premier_Tier__c First = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c Second = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 1 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Contract_Type__c = 'Independent';
        Prac1.Applied_Tier__c = Second.Id;
        Prac1.Calculated_Tier__c = Second.Id;
        Prac1.Override_Tier_Effective_Date__c = Date.today();
        Prac1.Override_Tier_Reason__c = 'Testing';
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac1;
        
        Prac1.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac1;
        
        
        Account Prac2 = new Account();
        Prac2.RecordTypeId = accRecordTypeId;
        Prac2.Name = 'Practice 2 Account';
        Prac2.Status__c = 'A';
        Prac2.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac2.Vision_Care_End_Date__c = system.today() + 1;
        Prac2.Vision_Care_Good_Standing__c = true;
        Prac2.Free_Fitting_and_Adjustments__c = true;
        Prac2.Tax_ID__c = '123456789';
        Prac2.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac2.Contract_Type__c = 'Independent';
        Prac2.Applied_Tier__c = Second.Id;
        Prac2.Calculated_Tier__c = Second.Id;
        Prac2.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac2.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac2.Override_Tier_Reason__c = 'Testing';
        Prac2.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac2.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac2.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac2;
        
        Prac2.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac2;
        
        Account BusAcc1 = new Account();
        BusAcc1.RecordTypeId = accBusRecordTypeId;
        BusAcc1.Name = 'Business Account 1';
        BusAcc1.ParentId = Prac2.Id;
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
        BusAcc1.Applied_Tier__c = First.Id;
        BusAcc1.Calculated_Tier__c = First.Id;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        Account Prac3 = new Account();
        Prac3.RecordTypeId = accRecordTypeId;
        Prac3.Name = 'Practice 3 Account';
        Prac3.Status__c = 'A';
        Prac3.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac3.Vision_Care_End_Date__c = system.today() + 1;
        Prac3.Vision_Care_Good_Standing__c = true;
        Prac3.Free_Fitting_and_Adjustments__c = true;
        Prac3.Tax_ID__c = '123456789';
        Prac3.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac3.Contract_Type__c = 'CAT2';
        Prac3.Applied_Tier__c = Second.Id;
        Prac3.Calculated_Tier__c = Second.Id;
        Prac3.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac3.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac3.Override_Tier_Reason__c = 'Testing';
        Prac3.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac3.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac3.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac3;
        
        Prac3.Contract_Type__c = 'CAT2'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac3;
        
        Account Prac4 = new Account();
        Prac4.RecordTypeId = accRecordTypeId;
        Prac4.Name = 'Practice 4 Account';
        Prac4.Status__c = 'A';
        Prac4.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac4.Vision_Care_End_Date__c = system.today() + 1;
        Prac4.Vision_Care_Good_Standing__c = true;
        Prac4.Free_Fitting_and_Adjustments__c = true;
        Prac4.Tax_ID__c = '123456789';
        Prac4.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac4.Contract_Type__c = 'Independent';
        Prac4.Tier_Agreement_Type__c = 'DOLP1';
        Prac4.Applied_Tier__c = Second.Id;
        Prac4.Calculated_Tier__c = Second.Id;
        Prac4.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac4.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac4.Override_Tier_Reason__c = 'Testing';
        Prac4.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac4.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac4.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac4;
        
        Prac4.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac4;
        
        Account Prac5 = new Account();
        Prac5.RecordTypeId = accRecordTypeId;
        Prac5.Name = 'Practice 5 Account';
        Prac5.Status__c = 'A';
        Prac5.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac5.Vision_Care_End_Date__c = system.today() + 1;
        Prac5.Vision_Care_Good_Standing__c = true;
        Prac5.Free_Fitting_and_Adjustments__c = true;
        Prac5.Tax_ID__c = '123456789';
        Prac5.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac5.Contract_Type__c = 'Independent';
        Prac5.Tier_Agreement_Type__c = 'DOLP111';
        Prac5.Applied_Tier__c = Second.Id;
        Prac5.Calculated_Tier__c = Second.Id;
        Prac5.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac5.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac5.Override_Tier_Reason__c = 'Testing';
        Prac5.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac5.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac5.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac5;
        
        Prac5.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac5;
        
        Account Prac6 = new Account();
        Prac6.RecordTypeId = accRecordTypeId;
        Prac6.Name = 'Practice 6 Account';
        Prac6.Status__c = 'A';
        Prac6.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac6.Vision_Care_End_Date__c = system.today() + 1;
        Prac6.Vision_Care_Good_Standing__c = true;
        Prac6.Free_Fitting_and_Adjustments__c = true;
        Prac6.Tax_ID__c = '123456789';
        Prac6.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac6.Contract_Type__c = 'CAT2';
        Prac6.Tier_Agreement_Type__c = 'DOLP111';
        Prac6.Applied_Tier__c = Second.Id;
        Prac6.Calculated_Tier__c = Second.Id;
        Prac6.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac6.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac6.Override_Tier_Reason__c = 'Testing';
        Prac6.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac6.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac6.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac6;
        
        Prac6.Contract_Type__c = 'CAT2'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac6;
        
        Account Prac7 = new Account();
        Prac7.RecordTypeId = accRecordTypeId;
        Prac7.Name = 'Practice 7 Account';
        Prac7.Status__c = 'A';
        Prac7.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac7.Vision_Care_End_Date__c = system.today() + 1;
        Prac7.Vision_Care_Good_Standing__c = false;
        Prac7.Free_Fitting_and_Adjustments__c = true;
        Prac7.Tax_ID__c = '123456789';
        Prac7.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac7.Contract_Type__c = 'CAT2';
        Prac7.Tier_Agreement_Type__c = 'DOLP111';
        Prac7.Applied_Tier__c = Second.Id;
        Prac7.Calculated_Tier__c = Second.Id;
        Prac7.Override_Tier_Effective_Date__c = Date.today().addDays(-2);
        Prac7.Override_Tier_End_Date__c = Date.today().addDays(-1);
        Prac7.Override_Tier_Reason__c = 'Testing';
        Prac7.Total_Average_Purchases_LTM_Calculated__c = 10000;
        Prac7.Average_Lens_Purchases_LTM_Calculated__c = 10000;
        Prac7.Average_Frame_Purchases_LTM_Calculated__c = 10000;
        //Prac1.Contract_Type__c = 'Conflict';
        insert Prac7;
        
        Prac7.Contract_Type__c = 'CAT2'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update Prac7;
        
        VSPR32_Override_Prac_Acc_Tier_Batch job = new VSPR32_Override_Prac_Acc_Tier_Batch();
        Test.startTest();
        Id jobId1 = Database.executeBatch(job);
        Test.stopTest();
        BusAcc1 = [SELECT Id, Applied_Tier__c FROM Account WHERE Name = 'Business Account 1' LIMIT 1];
        Prac2 = [SELECT Id, Override_Tier_Effective_Date__c, Override_Tier_End_Date__c, Override_Tier_Reason__c FROM Account WHERE Name = 'Practice 2 Account' LIMIT 1];
        system.assertEquals(First.Id, BusAcc1.Applied_Tier__c);
        system.assertEquals(Null, Prac2.Override_Tier_Effective_Date__c);
        system.assertEquals(Null, Prac2.Override_Tier_End_Date__c);
        system.assertEquals(Null, Prac2.Override_Tier_Reason__c);     
    } */
    
    public static testMethod void grgBusAccUpd_VSPR32_Override_Bus_Acc_Tier_Grg_Batch(){
        
        VSPUtility.stopAccountTrigger=true;
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id grpRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Contract_Type').getRecordTypeId();
        Id grpRecordTypeId2 = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Tax_ID_Rollup_Contract_Type').getRecordTypeId();
        Id grpRecordTypeId3 = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Tax_ID_Rollup').getRecordTypeId();
        
    //    Set<Id> GrgIdSet = new Set<Id>();
        
        Premier_Tier__c First = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c Second = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        
        Account Prac1 = new Account();
        Prac1.RecordTypeId = accRecordTypeId;
        Prac1.Name = 'Practice 3 Account';
        Prac1.Status__c = 'A';
        Prac1.Vision_Care_Effective_Date__c = system.today() - 3;
        Prac1.Vision_Care_End_Date__c = system.today() + 1;
        Prac1.Vision_Care_Good_Standing__c = true;
        Prac1.Free_Fitting_and_Adjustments__c = true;
        Prac1.Tax_ID__c = '123456789';
        Prac1.Premier_Tax_ID_Roll_Up_Account__c = false;
        Prac1.Contract_Type__c = 'Independent';
        Prac1.Applied_Tier__c = Second.Id;
        Prac1.Calculated_Tier__c = Second.Id;
        Prac1.Override_Tier_Effective_Date__c = Date.today();
        Prac1.VC__c = True;
        Prac1.Override_Tier_Reason__c = 'Testing';
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
        BusAcc1.Applied_Tier__c = First.Id;
        BusAcc1.Calculated_Tier__c = First.Id;
        BusAcc1.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc1;
        BusAcc1.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc1;
        
        Account BusAcc2 = new Account();
        BusAcc2.RecordTypeId = accBusRecordTypeId;
        BusAcc2.Name = 'Business Account 2';
        BusAcc2.ParentId = Prac1.Id;
        BusAcc2.Total_Location_Spend_LTM__c = 100;
        BusAcc2.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc2.Optics_Location_Spend_LTM__c = 100;
        BusAcc2.Contract_Type__c = 'Independent';
        BusAcc2.Vision_Care_Good_Standing__c = false;
        BusAcc2.Status__c = 'A';
        BusAcc2.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc2.Vision_Care_End_Date__c = null;
        BusAcc2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc2.Applied_Tier__c = First.Id;
        BusAcc2.Calculated_Tier__c = First.Id;
        BusAcc2.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc2;
        BusAcc2.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc2;
        
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpRecordTypeId;
        grg.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg.Applied_Tier__c = Second.Id; 
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
        grg.Override_Effective_Date__c = Date.today();
        grg.Override_Tier_Reason__c = 'Testing';
        insert grg;
        
    //    GrgIdSet.add(grg.Id);
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = BusAcc1.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today()-10;
        
        insert grgr; 
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Active__c = True;
        grgr2.Child_Account__c = BusAcc2.Id;
        grgr2.End_Date__c = null;
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Start_Date__c = Date.today()-10;
        
        insert grgr2; 
        
        
        //////////////////////////////////////////////////////////
        //
        //
        Account BusAcc3 = new Account();
        BusAcc3.RecordTypeId = accBusRecordTypeId;
        BusAcc3.Name = 'Business Account 3';
        BusAcc3.ParentId = Prac1.Id;
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
        BusAcc3.Applied_Tier__c = First.Id;
        BusAcc3.Calculated_Tier__c = First.Id;
        BusAcc3.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc3;
        BusAcc3.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc3;
        
        
        Global_Rewards_Group__c grg2 = new Global_Rewards_Group__c();
        grg2.RecordTypeId = grpRecordTypeId;
        grg2.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg2.Applied_Tier__c = Null; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg2.Calculated_Tier__c = null; 
        grg2.Premier_Location_Count_Future__c = 1; 
        grg2.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg2.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg2.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg2.Free_Fitting_and_Adjustments__c = true;
        grg2.Exclusive_VSP_Patient_Offers__c = true;
        grg2.Retinal_Imaging_Indicator_Future__c = true;
        grg2.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg2.Tier_Agreement_Type__c = null;
        grg2.End_Date__c = null;
        grg2.Contract_Type__c = 'Independent';
        grg2.Override_Effective_Date__c = Date.today();
        grg2.Override_Tier_Reason__c = 'Testing';
        insert grg2;
        
   //     GrgIdSet.add(grg2.Id);
        
        
        Global_Rewards_Group_Relationship__c grgr3 = new Global_Rewards_Group_Relationship__c();
        grgr3.Active__c = True;
        grgr3.Child_Account__c = BusAcc3.Id;
        grgr3.End_Date__c = null;
        grgr3.Global_Rewards_Group__c = grg2.Id;
        grgr3.Start_Date__c = Date.today()-10;
        
        insert grgr3; 
        
        
        
        ///////////////////////////////////////////////////////
        //
        //
        
        Account BusAcc4 = new Account();
        BusAcc4.RecordTypeId = accBusRecordTypeId;
        BusAcc4.Name = 'Business Account 4';
        BusAcc4.ParentId = Prac1.Id;
        BusAcc4.Total_Location_Spend_LTM__c = 100;
        BusAcc4.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc4.Optics_Location_Spend_LTM__c = 100;
        BusAcc4.Contract_Type__c = 'Independent';
        BusAcc4.Vision_Care_Good_Standing__c = True;
        BusAcc4.Status__c = 'A';
        BusAcc4.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc4.Vision_Care_End_Date__c = null;
        BusAcc4.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc4.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc4.Applied_Tier__c = First.Id;
        BusAcc4.Calculated_Tier__c = First.Id;
        BusAcc4.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc4;
        BusAcc4.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc4;
        
        
        Global_Rewards_Group__c grg3 = new Global_Rewards_Group__c();
        grg3.RecordTypeId = grpRecordTypeId2;
        grg3.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg3.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg3.Calculated_Tier__c = Second.Id; 
        grg3.Premier_Location_Count_Future__c = 1; 
        grg3.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg3.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg3.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg3.Free_Fitting_and_Adjustments__c = true;
        grg3.Exclusive_VSP_Patient_Offers__c = true;
        grg3.Retinal_Imaging_Indicator_Future__c = true;
        grg3.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg3.Tier_Agreement_Type__c = null;
        grg3.End_Date__c = null;
        grg3.Contract_Type__c = 'Independent';
        grg3.Override_Effective_Date__c = Date.today();
        grg3.Override_Tier_Reason__c = 'Testing';
        insert grg3;
        
     //   GrgIdSet.add(grg3.Id);
        
        
        Global_Rewards_Group_Relationship__c grgr4 = new Global_Rewards_Group_Relationship__c();
        grgr4.Active__c = True;
        grgr4.Child_Account__c = BusAcc4.Id;
        grgr4.End_Date__c = null;
        grgr4.Global_Rewards_Group__c = grg3.Id;
        grgr4.Start_Date__c = Date.today()-10;
        
        insert grgr4; 
        
        
        
        ///////////////////////////////////////////////////////
        //
        //
        
        Account BusAcc5 = new Account();
        BusAcc5.RecordTypeId = accBusRecordTypeId;
        BusAcc5.Name = 'Business Account 5';
        BusAcc5.ParentId = Prac1.Id;
        BusAcc5.Total_Location_Spend_LTM__c = 100;
        BusAcc5.Eyewear_Location_Spend_LTM__c = 100;
        BusAcc5.Optics_Location_Spend_LTM__c = 100;
        BusAcc5.Contract_Type__c = 'Independent';
        BusAcc5.Vision_Care_Good_Standing__c = True;
        BusAcc5.Status__c = 'A';
        BusAcc5.Vision_Care_Effective_Date__c = system.today() - 3;
        BusAcc5.Vision_Care_End_Date__c = null;
        BusAcc5.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        BusAcc5.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        BusAcc5.Applied_Tier__c = First.Id;
        BusAcc5.Calculated_Tier__c = First.Id;
        BusAcc5.VC__c = True;
        //BusAcc1.Service_Offering_s__c = 'FFAA - Free Fitting and Adjustments';
        
        insert BusAcc5;
        BusAcc5.Contract_Type__c = 'Independent'; //Need to update because VSPR31_ContractTypeCalculation nulls it out.
        update BusAcc5;
        
        
        Global_Rewards_Group__c grg4 = new Global_Rewards_Group__c();
        grg4.RecordTypeId = grpRecordTypeId3;
        grg4.Name = 'TESTGRP';
        //grg.Parent_Account__c = Prac3.Id;
        grg4.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg4.Calculated_Tier__c = Second.Id; 
        grg4.Premier_Location_Count_Future__c = 1; 
        grg4.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg4.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg4.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg4.Free_Fitting_and_Adjustments__c = true;
        grg4.Exclusive_VSP_Patient_Offers__c = true;
        grg4.Retinal_Imaging_Indicator_Future__c = true;
        grg4.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg4.Tier_Agreement_Type__c = null;
        grg4.End_Date__c = null;
        grg4.Contract_Type__c = 'Independent';
        grg4.Override_Effective_Date__c = Date.today();
        grg4.Override_Tier_Reason__c = 'Testing';
        insert grg4;
        
     //   GrgIdSet.add(grg4.Id);
        
        
        Global_Rewards_Group_Relationship__c grgr5 = new Global_Rewards_Group_Relationship__c();
        grgr5.Active__c = True;
        grgr5.Child_Account__c = BusAcc5.Id;
        grgr5.End_Date__c = null;
        grgr5.Global_Rewards_Group__c = grg4.Id;
        grgr5.Start_Date__c = Date.today()-10;
        
        insert grgr5; 
        
        VSPR32_Override_Bus_Acc_Tier_Grg_Batch job = new VSPR32_Override_Bus_Acc_Tier_Grg_Batch();
        Test.startTest();
        Id jobId1 = Database.executeBatch(job);
        Test.stopTest();
        BusAcc1 = [SELECT Id, Applied_Tier__c FROM Account WHERE Name = 'Business Account 1' LIMIT 1];
        BusAcc2 = [SELECT Id, Applied_Tier__c FROM Account WHERE Name = 'Business Account 2' LIMIT 1];
        system.assertEquals(Second.Id, BusAcc1.Applied_Tier__c);
        system.assertEquals(Null, BusAcc2.Applied_Tier__c);////vision care good standing is false
    }
    
    
 /*   public static testMethod void grgOverride_VSPR32_Override_Grg_Tier_Batch(){
        
        Id grpRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Contract_Type').getRecordTypeId();
        Id grpRecordTypeId2 = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Tax_ID_Rollup_Contract_Type').getRecordTypeId();
        Id grpRecordTypeId3 = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByDeveloperName().get('Tax_ID_Rollup').getRecordTypeId();
        
        Premier_Tier__c First = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        Premier_Tier__c Second = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Second' LIMIT 1];
        Premier_Tier__c FirstTHi = [SELECT Id FROM Premier_Tier__c WHERE Name = 'First with High' LIMIT 1];
        
        Global_Rewards_Group__c grg1 = new Global_Rewards_Group__c();
        grg1.RecordTypeId = grpRecordTypeId;
        grg1.Name = 'TESTGRP1';
        //grg.Parent_Account__c = Prac3.Id;
        grg1.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg1.Calculated_Tier__c = Second.Id; 
        grg1.Premier_Location_Count_Future__c = 1; 
        grg1.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg1.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg1.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg1.Free_Fitting_and_Adjustments__c = true;
        grg1.Exclusive_VSP_Patient_Offers__c = true;
        grg1.Retinal_Imaging_Indicator_Future__c = true;
        grg1.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg1.Tier_Agreement_Type__c = null;
        grg1.End_Date__c = null;
        grg1.Contract_Type__c = 'Independent';
        grg1.Override_Effective_Date__c = Date.today();
        grg1.Override_Tier_Reason__c = 'Testing';
        insert grg1;
        
        
        Global_Rewards_Group__c grg2 = new Global_Rewards_Group__c();
        grg2.RecordTypeId = grpRecordTypeId;
        grg2.Name = 'TESTGRP2';
        //grg.Parent_Account__c = Prac3.Id;
        grg2.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg2.Calculated_Tier__c = Second.Id; 
        grg2.Premier_Location_Count_Future__c = 1; 
        grg2.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg2.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg2.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg2.Free_Fitting_and_Adjustments__c = true;
        grg2.Exclusive_VSP_Patient_Offers__c = true;
        grg2.Retinal_Imaging_Indicator_Future__c = true;
        grg2.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg2.Tier_Agreement_Type__c = null;
        grg2.End_Date__c = null;
        grg2.Contract_Type__c = 'Independent';
        grg2.Override_Effective_Date__c = Date.today().addDays(-3);
        grg2.Override_End_Date__c = Date.today().addDays(-1);
        grg2.Override_Tier_Reason__c = 'Testing';
        insert grg2;
        
         Global_Rewards_Group__c grg3 = new Global_Rewards_Group__c();
        grg3.RecordTypeId = grpRecordTypeId;
        grg3.Name = 'TESTGRP3';
        //grg.Parent_Account__c = Prac3.Id;
        grg3.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg3.Calculated_Tier__c = Second.Id; 
        grg3.Premier_Location_Count_Future__c = 1; 
        grg3.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg3.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg3.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg3.Free_Fitting_and_Adjustments__c = true;
        grg3.Exclusive_VSP_Patient_Offers__c = true;
        grg3.Retinal_Imaging_Indicator_Future__c = true;
        grg3.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg3.Tier_Agreement_Type__c = null;
        grg3.End_Date__c = null;
        grg3.Contract_Type__c = 'CAT2';
        grg3.Override_Effective_Date__c = Date.today().addDays(-3);
        grg3.Override_End_Date__c = Date.today().addDays(-1);
        grg3.Override_Tier_Reason__c = 'Testing';
        insert grg3;
        
        
        Global_Rewards_Group__c grg4 = new Global_Rewards_Group__c();
        grg4.RecordTypeId = grpRecordTypeId;
        grg4.Name = 'TESTGRP4';
        //grg.Parent_Account__c = Prac3.Id;
        grg4.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg4.Calculated_Tier__c = Second.Id; 
        grg4.Premier_Location_Count_Future__c = 1; 
        grg4.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg4.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg4.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg4.Free_Fitting_and_Adjustments__c = true;
        grg4.Exclusive_VSP_Patient_Offers__c = true;
        grg4.Retinal_Imaging_Indicator_Future__c = true;
        grg4.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg4.Tier_Agreement_Type__c = null;
        grg4.End_Date__c = null;
        grg4.Contract_Type__c = 'Independent';
        grg4.Tier_Agreement_Type__c = 'DOLP1';
        grg4.Override_Effective_Date__c = Date.today().addDays(-3);
        grg4.Override_End_Date__c = Date.today().addDays(-1);
        grg4.Override_Tier_Reason__c = 'Testing';
        insert grg4;
        
        Global_Rewards_Group__c grg5 = new Global_Rewards_Group__c();
        grg5.RecordTypeId = grpRecordTypeId;
        grg5.Name = 'TESTGRP5';
        //grg.Parent_Account__c = Prac3.Id;
        grg5.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg5.Calculated_Tier__c = Second.Id; 
        grg5.Premier_Location_Count_Future__c = 1; 
        grg5.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg5.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg5.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg5.Free_Fitting_and_Adjustments__c = true;
        grg5.Exclusive_VSP_Patient_Offers__c = true;
        grg5.Retinal_Imaging_Indicator_Future__c = true;
        grg5.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg5.Tier_Agreement_Type__c = null;
        grg5.End_Date__c = null;
        grg5.Contract_Type__c = 'Independent';
        grg5.Tier_Agreement_Type__c = 'DOLP11111';
        grg5.Override_Effective_Date__c = Date.today().addDays(-3);
        grg5.Override_End_Date__c = Date.today().addDays(-1);
        grg5.Override_Tier_Reason__c = 'Testing';
        insert grg5;
        
        
         Global_Rewards_Group__c grg6 = new Global_Rewards_Group__c();
        grg6.RecordTypeId = grpRecordTypeId;
        grg6.Name = 'TESTGRP6';
        //grg.Parent_Account__c = Prac3.Id;
        grg6.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg6.Calculated_Tier__c = Second.Id; 
        grg6.Premier_Location_Count_Future__c = 1; 
        grg6.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg6.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg6.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg6.Free_Fitting_and_Adjustments__c = true;
        grg6.Exclusive_VSP_Patient_Offers__c = true;
        grg6.Retinal_Imaging_Indicator_Future__c = true;
        grg6.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg6.Tier_Agreement_Type__c = null;
        grg6.End_Date__c = null;
        grg6.Contract_Type__c = 'CAT2';
        grg6.Tier_Agreement_Type__c = 'DOLP11111';
        grg6.Override_Effective_Date__c = Date.today().addDays(-3);
        grg6.Override_End_Date__c = Date.today().addDays(-1);
        grg6.Override_Tier_Reason__c = 'Testing';
        insert grg6;
        
         Global_Rewards_Group__c grg7 = new Global_Rewards_Group__c();
        grg7.RecordTypeId = grpRecordTypeId;
        grg7.Name = 'TESTGRP7';
        //grg.Parent_Account__c = Prac3.Id;
        grg7.Applied_Tier__c = Second.Id; 
        //grg.Applied_Tier__r.Order__c = 1;
        grg7.Calculated_Tier__c = Second.Id; 
        grg7.Premier_Location_Count_Future__c = 1; 
        grg7.Average_Tiering_Total_Spend_LTM__c = 1000;
        grg7.Average_Tiering_Eyewear_Spend_LTM__c = 1000; 
        grg7.Average_Tiering_Optics_Spend_LTM__c = 1000;
        grg7.Free_Fitting_and_Adjustments__c = true;
        grg7.Exclusive_VSP_Patient_Offers__c = true;
        grg7.Retinal_Imaging_Indicator_Future__c = true;
        grg7.Start_Date__c = Date.newInstance(2019, 7, 1);
        grg7.Tier_Agreement_Type__c = null;
        grg7.End_Date__c = Date.today().addDays(-1);
        grg7.Contract_Type__c = 'CAT2';
        grg7.Tier_Agreement_Type__c = 'DOLP11111';
        grg7.Override_Effective_Date__c = Date.today().addDays(-3);
        grg7.Override_End_Date__c = Date.today().addDays(-1);
        grg7.Override_Tier_Reason__c = 'Testing';
        insert grg7;
        
        VSPR32_Override_Tier_Update_Sch job = new VSPR32_Override_Tier_Update_Sch();
        Test.startTest();
        job.execute(null);
        Test.stopTest();
        grg1 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP1' LIMIT 1];
        grg2 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP2' LIMIT 1];
        grg3 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP3' LIMIT 1];
        grg4 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP4' LIMIT 1];
        grg5 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP5' LIMIT 1];
        grg6 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP6' LIMIT 1];
        grg7 = [SELECT Id, Applied_Tier__c, Override_Effective_Date__c, Override_End_Date__c, Override_Tier_Reason__c FROM Global_Rewards_Group__c WHERE Name = 'TESTGRP7' LIMIT 1];
        ////Assert Group 1
        system.assertEquals(Second.Id, grg1.Applied_Tier__c);
        system.assertEquals(Date.today(), grg1.Override_Effective_Date__c);
        system.assertEquals(Null, grg1.Override_End_Date__c);
        system.assertEquals('Testing', grg1.Override_Tier_Reason__c);
        ////Assert Group 2
        system.assertEquals(First.Id, grg2.Applied_Tier__c);
        system.assertEquals(Null, grg2.Override_Effective_Date__c);
        system.assertEquals(Null, grg2.Override_End_Date__c);
        system.assertEquals(Null, grg2.Override_Tier_Reason__c);
        ////Assert Group 3
        system.assertEquals(Null, grg3.Applied_Tier__c);
        system.assertEquals(Null, grg3.Override_Effective_Date__c);
        system.assertEquals(Null, grg3.Override_End_Date__c);
        system.assertEquals(Null, grg3.Override_Tier_Reason__c);
        ////Assert Group 4
        system.assertEquals(FirstTHi.Id, grg4.Applied_Tier__c);
        system.assertEquals(Null, grg4.Override_Effective_Date__c);
        system.assertEquals(Null, grg4.Override_End_Date__c);
        system.assertEquals(Null, grg4.Override_Tier_Reason__c);
         ////Assert Group 5
        system.assertEquals(First.Id, grg5.Applied_Tier__c);
        system.assertEquals(Null, grg5.Override_Effective_Date__c);
        system.assertEquals(Null, grg5.Override_End_Date__c);
        system.assertEquals(Null, grg5.Override_Tier_Reason__c);
           ////Assert Group 6
        system.assertEquals(Null, grg6.Applied_Tier__c);
        system.assertEquals(Null, grg6.Override_Effective_Date__c);
        system.assertEquals(Null, grg6.Override_End_Date__c);
        system.assertEquals(Null, grg6.Override_Tier_Reason__c);
           ////Assert Group 7
        system.assertEquals(Null, grg7.Applied_Tier__c);
        system.assertEquals(Null, grg7.Override_Effective_Date__c);
        system.assertEquals(Null, grg7.Override_End_Date__c);
        system.assertEquals(Null, grg7.Override_Tier_Reason__c);

        
    }*/
    
    
}