@isTest
public class DSUpdateEventNameV3_Test {

    @isTest
    static void insertTest()
    {
        //Create an Account and insert it
        Account testAccount = new Account(
			Name = 'Test'        
        );
        
        insert testAccount; 
        
        Contact testContact = new Contact(
       		Account = testAccount,
            LastName = 'Test'
        );
        
        insert testContact; 
        
        //Create a Contact Role and insert it
        Contact_Role__c testContactRole = new Contact_Role__c(
            Account__c = testAccount.Id,
            Contact__c = testContact.Id,
        	Type__c = 'Student',
            Start_Date__c = System.today()
        ); 
        
        insert testContactRole; 
        
        Event testFollowUpEvent = new Event(
            DialSource__Call_Disposition_DS__c = 'Test',
            Event_Type__c = 'Outbound Call',
            Subject = 'Call',
            Classification__c = 'Other',
            DurationInMinutes = 10,
            ActivityDateTime = Datetime.newInstance(2017,  1,  13),
            WhatId = testContactRole.Id
        );
        
        Test.startTest(); 
        insert testFollowUpEvent; 
        Test.stopTest(); 
    }
}