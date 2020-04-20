@isTest
//Test class for VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch
public class VSPR31_Bus_Acc_Tier_Upd_from_Prac_Test {
    @testSetup
    public static void testData(){
        Id paRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id baRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
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
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecordTypeId;
        pa1.Name = 'PA Test 1234';
        pa1.Status__c = 'A';
        pa1.Vision_Care_Effective_Date__c = system.today() - 3;
        pa1.Vision_Care_End_Date__c = null;//system.today() + 1;
        pa1.Vision_Care_Good_Standing__c = true;
        pa1.Free_Fitting_and_Adjustments__c = true;
        //pa1.Retinal_Imaging_Indicator__c = true;
        pa1.Tax_ID__c = '123456789';
        pa1.Premier_Tax_ID_Roll_Up_Account__c = false;
        pa1.Applied_Tier__c = FirstT.Id;
        
        insert pa1;
        
        Account ba1 = new Account();
        ba1.RecordTypeId = baRecordTypeId;
        ba1.Name = 'BA Test 1234';
        ba1.ParentId = pa1.Id;
        ba1.Contract_Type__c = 'Independent';
        ba1.Vision_Care_Good_Standing__c = True;
        ba1.Status__c = 'A';
        ba1.Vision_Care_Effective_Date__c = system.today() - 3;
        ba1.Vision_Care_End_Date__c = null;
        ba1.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        ba1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        
        insert ba1;
        
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Premier_Admin_Email__c toAddress2 = new Premier_Admin_Email__c();
        toAddress2.Name = 'test2@vsp.com';
        insert toAddress2;
        
    }
    @isTest
    public static void baVisionCareTrueWithTierTest(){
        Test.startTest();
        Account paGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'PA Test 1234' LIMIT 1];
        
        Set<Id> paIdSet = new Set<Id>();
        paIdSet.add(paGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch(paIdSet);  
        Database.executeBatch(ba,10);
        Test.stopTest();
        
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c, Applied_Tier__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        System.assertNotEquals(null, baGet.Applied_Tier__c);        
    }
    
    @isTest
    public static void baVisionCareFalseWithTierTest(){
        Test.startTest();
        Account paGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'PA Test 1234' LIMIT 1];
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        baGet.Vision_Care_Good_Standing__c = False;
        update baGet;
        
        Set<Id> paIdSet = new Set<Id>();
        paIdSet.add(paGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch(paIdSet);  
        Database.executeBatch(ba,10);
        Test.stopTest();
        
        Account baGet2 = [SELECT Id, Name, Vision_Care_Good_Standing__c, Applied_Tier__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        System.assertEquals(null, baGet2.Applied_Tier__c);
    }
    
    @isTest
    public static void paWithTierTest(){
        Test.startTest();
        Account paGet = [SELECT Id, Name, Vision_Care_Good_Standing__c FROM Account WHERE Name = 'PA Test 1234' LIMIT 1];
        //Premier_Tier__c pT = [SELECT Id, Name FROM Premier_Tier__c WHERE Name = 'First' LIMIT 1];
        paGet.Applied_Tier__c = null;
        update paGet;
        
        Set<Id> paIdSet = new Set<Id>();
        paIdSet.add(paGet.Id);
        
        VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch ba = new VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch(paIdSet);  
        Database.executeBatch(ba,10);
        Test.stopTest();
        
        Account baGet = [SELECT Id, Name, Vision_Care_Good_Standing__c, Applied_Tier__c FROM Account WHERE Name = 'BA Test 1234' LIMIT 1];
        System.assertEquals(null, baGet.Applied_Tier__c);        
    }
    
}