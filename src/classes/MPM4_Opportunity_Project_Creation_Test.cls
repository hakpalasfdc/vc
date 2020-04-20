/* 
* 
* Test Class for MPM4_Opportunity_Project_Creation_Test
*  
*/
@isTest
private class MPM4_Opportunity_Project_Creation_Test {

    static testMethod void unitTest(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        // Insert sample Account 
        Account acc = new Account();
        acc.Name = 'Sample Account 0';
        acc.RecordTypeId = accRecordTypeId;
       
        insert acc;
        
        
        Id oppRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Shift Opportunity').getRecordTypeId();
        // Insert Oportunity record with account id but without record Type
        Opportunity opty0 = new Opportunity();
        opty0.Name = 'Sample Opty 0';
        opty0.RecordTypeId = oppRecordTypeId;
        opty0.AccountId = acc.Id;
        opty0.Amount_Value_Timeframe__c = '1 Month';
        opty0.Amount = 1000;
        opty0.Line_of_Business__c = 'Optics';
        opty0.Product_Program__c = 'SampleText 0';
        opty0.StageName = 'Closed Won';
        opty0.Probability = 100;
        opty0.Closedate = system.today();                           
        opty0.Planned_Closed_Month__c = 'December'; 
        Test.startTest();
        insert opty0;  
        Test.stopTest();
        
        
        
    }
}