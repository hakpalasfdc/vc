@isTest
public class VSPR28_QA_Review_Purge_Schedule_Test {

    @TestSetup
    static void testData(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();
        
        Account pracAcc = new Account();
        pracAcc.RecordTypeId = accRecordTypeId;
        pracAcc.Name = 'Practice Account';
        insert pracAcc;
        
        Contact con = new Contact();
        con.RecordTypeId = conRecordTypeId;
        con.AccountId = pracAcc.Id;
        con.Status__c = 'Active';
        con.FirstName = 'FName';
        con.LastName = 'LName';
        insert con;
        
        Contact_Role__c	cr = new Contact_Role__c();
        cr.Account__c = pracAcc.Id;
        cr.Contact__c = con.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Status__c = 'Active';
        cr.Start_Date__c = Date.today();
        cr.Active_or_Future_Vision_Care_Relationshi__c = True;
        insert cr;
        
        QA_Review__c qaReview = new QA_Review__c();
        qaReview.Contact_Role__c = cr.Id;
        qaReview.Provider_Name__c = con.Id;
        qaReview.Vision_Care_Location_Key__c = '123456789';
        qaReview.Review_Date_Scheduled__c = Date.today().addMonths(-130);
        qaReview.Review_Received_Date__c = Date.today().addMonths(-130);
        qaReview.Result_Letter_Date__c = Date.today().addMonths(-130);
        qaReview.QA_Review_Status__c = 'Completed Audit Pass';
        insert qaReview;
        
        
    }
    static testmethod void runJob(){
        Test.startTest();
        
        String EXP = '0 0 23 * * ?';
        
        VSPR28_QA_Review_Purge_Schedule sch = new VSPR28_QA_Review_Purge_Schedule();
        
        system.Schedule('QA Review Purge Test', EXP, sch);
        
        Test.stopTest();
    }
}