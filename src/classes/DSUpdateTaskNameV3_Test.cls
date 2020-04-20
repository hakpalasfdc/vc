@isTest
public class DSUpdateTaskNameV3_Test {

    @isTest
    static void updateTest()
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
        
        Task testLoggedCall = new Task(
            Type = 'Outbound Call',
            Subject = 'Call',
            Status = 'Completed',
            WhatId = testContactRole.Id
        );
        
        insert testLoggedCall; 
        testLoggedCall.DialSource__Call_Disposition_DS__c = 'Test';
            
        Test.startTest(); 
        update testLoggedCall; 
        Test.stopTest(); 
    }
    
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
        
        Task testLoggedCall = new Task(
            Priority = 'Normal',
            DialSource__Call_Disposition_DS__c = 'Test',
            type__c = 'Outbound Call',
            Subject = 'Call',
            Status = 'Not Started',
            WhatId = testContactRole.Id
        );
        
        Test.startTest(); 
        insert testLoggedCall; 
        Test.stopTest(); 
    }
}