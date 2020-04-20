@isTest
public class QAReviewTrigger_Handler_Test {
    
    @TestSetup
    static void testData(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();
        
        
        ///Create Business Account
        Account busAcc = new Account();
        busAcc.RecordTypeId = accRecordTypeId;
        busAcc.Name = 'Test Bus Account';
        busAcc.Vision_Care_Location_Key__c = '123456';        
        insert busAcc;
        
        ///Create EyeCare Contact
        Contact eyeCare = new Contact();
        eyeCare.FirstName = 'First Name';
        eyeCare.LastName = 'Last Name';
        eyeCare.Degree__c = 'OD';
        eyeCare.RecordTypeId = conRecordTypeId;
        eyeCare.AccountId = busAcc.Id;        
        insert eyeCare;
        
        Contact eyeCare2 = new Contact();
        eyeCare2.FirstName = 'First Name';
        eyeCare2.LastName = 'Last Name2';
        eyeCare2.Degree__c = 'DO';
        eyeCare2.RecordTypeId = conRecordTypeId;
        eyeCare2.AccountId = busAcc.Id;
        insert eyeCare2;        
        
        test.startTest();
        ///Create Contact Role
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = busAcc.Id;
        cr.Contact__c = eyeCare.Id;
        cr.Start_Date__c = Date.today();
        cr.Type__c = 'Doctor-Owner';
        cr.Active_or_Future_Vision_Care_Relationshi__c = True;        
        insert cr;
        
        ///Create Contact Role
        Contact_Role__c cr2 = new Contact_Role__c();
        cr2.Account__c = busAcc.Id;
        cr2.Contact__c = eyeCare2.Id;
        cr2.Start_Date__c = Date.today();
        cr2.Type__c = 'Doctor-Owner';
        cr2.Active_or_Future_Vision_Care_Relationshi__c = True;        
        insert cr2;
        test.stopTest();
        
        QA_Review__c qaR2 = new QA_Review__c();
        qaR2.Contact_Role__c = cr.Id;        
        insert qaR2;
    }
    
    static testmethod void updateQARecord(){
        Account acc = [SELECT Id, Vision_Care_Location_Key__c FROM Account WHERE Name = 'Test Bus Account'];
        Contact_Role__c cr1 = [SELECT Id, Contact__r.Name FROM Contact_Role__c WHERE Account__r.Name = 'Test Bus Account' AND Contact__r.LastName = 'Last Name' LIMIT 1];
        Contact_Role__c cr2 = [SELECT Id, Contact__r.Name FROM Contact_Role__c WHERE Account__r.Name = 'Test Bus Account' AND Contact__r.LastName = 'Last Name2' LIMIT 1];
        QA_Review__c qaR2 = [SELECT Id, Contact_Role__c FROM QA_Review__c WHERE Contact_Role__c = :cr1.Id];
        
        qaR2.Contact_Role__c = cr2.Id;
        
        Test.startTest();
        update qaR2;
        Test.stopTest();
        qaR2 = [SELECT Id, Contact_Role__c, Provider_Name__r.Name, Vision_Care_Location_Key__c FROM QA_Review__c WHERE Id = :qaR2.Id];
        system.debug('Contact Role2 ' + cr2.Id);
        system.debug('qaR2 ' + qaR2);
        
        System.assertEquals(qaR2.Provider_Name__r.Name, cr2.Contact__r.Name);
        System.assertEquals(qaR2.Vision_Care_Location_Key__c, acc.Vision_Care_Location_Key__c);
    }
    
    
}