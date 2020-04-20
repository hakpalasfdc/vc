@isTest
//Test class for VSPR31_Premier_Tier_Schedule_Update & VSPR31_Premier_Tier_Update_Batch
public class VSPR31_Premier_Tier_Schedule_Test {
    
    //Commented out the below testmethod by Vikhyat
    //Commented because scheduler class is no longer required for the particular batch.
    /*public static testmethod void testPremierScheduler(){
        Premier_Tier__c FirstT = new Premier_Tier__c();
        FirstT.Name = 'First';
        FirstT.Description__c = 'First Description';
        FirstT.Effective_Date__c = Date.today();
        FirstT.Hierarchy_Action__c = 'Top_Tier';
        FirstT.Contract_Type__c = 'Contract';
        FirstT.Order__c = 1;
        //FirstT.Status__c = 'Active';
        FirstT.Retinal_Imaging_Indicator__c = true;
        FirstT.Free_Fitting_and_Adjustments__c = false;
        FirstT.Exclusive_VSP_Patient_Offers__c = true;
        FirstT.Total_Purchases_LTM__c = 0;
        FirstT.Eyewear_Minimum__c = 0;
        FirstT.Lens_Minimum__c = 0;
        
        insert FirstT;
        
        Test.startTest();
        String EXP = '0 0 23 * * ?';
        VSPR31_Premier_Tier_Schedule_Update sch = new VSPR31_Premier_Tier_Schedule_Update();
        system.Schedule('Premier Tier Update Test', EXP, sch);
        Test.stopTest();  
        
        Premier_Tier__c pt = [SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c WHERE Id =: FirstT.Id];
        system.assertEquals('Active', pt.Status__c);
    }*/
    public static testmethod void testPremierSchedulerBatch(){
        Premier_Tier__c FirstT = new Premier_Tier__c();
        FirstT.Name = 'First';
        FirstT.Description__c = 'First Description';
        FirstT.Effective_Date__c = Date.today() + 10;
        FirstT.Hierarchy_Action__c = 'Top_Tier';
        FirstT.Contract_Type__c = 'Contract';
        FirstT.Order__c = 1;
        //FirstT.Status__c = 'Active';
        FirstT.Retinal_Imaging_Indicator__c = true;
        FirstT.Free_Fitting_and_Adjustments__c = false;
        FirstT.Exclusive_VSP_Patient_Offers__c = true;
        FirstT.Total_Purchases_LTM__c = 0;
        FirstT.Eyewear_Minimum__c = 0;
        FirstT.Lens_Minimum__c = 0;
        
        insert FirstT;
        
        Premier_Tier__c SecondT = new Premier_Tier__c();
        SecondT.Name = 'First';
        SecondT.Description__c = 'First Description';
        SecondT.Effective_Date__c = Date.today();
        SecondT.Hierarchy_Action__c = 'Top_Tier';
        SecondT.Contract_Type__c = 'Contract';
        SecondT.Order__c = 1;
        //FirstT.Status__c = 'Active';
        SecondT.Retinal_Imaging_Indicator__c = true;
        SecondT.Free_Fitting_and_Adjustments__c = false;
        SecondT.Exclusive_VSP_Patient_Offers__c = true;
        SecondT.Total_Purchases_LTM__c = 0;
        SecondT.Eyewear_Minimum__c = 0;
        SecondT.Lens_Minimum__c = 0;
        
        insert SecondT;
        
        SecondT.Status__c = 'Inactive';
        update SecondT;
        
        Premier_Tier__c ThirdT = new Premier_Tier__c();
        ThirdT.Name = 'First';
        ThirdT.Description__c = 'First Description';
        ThirdT.Effective_Date__c = Date.today().addDays(-10);
        ThirdT.End_Date__c = Date.today().addDays(-1);
        ThirdT.Hierarchy_Action__c = 'Top_Tier';
        ThirdT.Contract_Type__c = 'Contract';
        ThirdT.Order__c = 1;
        //FirstT.Status__c = 'Active';
        ThirdT.Retinal_Imaging_Indicator__c = true;
        ThirdT.Free_Fitting_and_Adjustments__c = false;
        ThirdT.Exclusive_VSP_Patient_Offers__c = true;
        ThirdT.Total_Purchases_LTM__c = 0;
        ThirdT.Eyewear_Minimum__c = 0;
        ThirdT.Lens_Minimum__c = 0;
        
        insert ThirdT;
        
        ThirdT.Status__c = 'Active';
        update ThirdT;
        
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        String Query;
        
        Query = 'SELECT Id FROM Premier_Tier__c WHERE IsDeleted = false';
        //VSPR31_Premier_Tier_Update_Batch job = new VSPR31_Premier_Tier_Update_Batch(Query);
        
        VSPR31_Premier_Tier_Update_Batch job = new VSPR31_Premier_Tier_Update_Batch();
        
        Test.startTest();
        Id jobId1 = Database.executeBatch(job);
        Test.stopTest();
        
		Premier_Tier__c pt = [SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c WHERE Id =: FirstT.Id];        
        system.assertEquals('Future', pt.Status__c);
    }
}