@isTest
public class DSContactRolePBV3_Test {
    
    @isTest
    static void testIncrementingVMCount()
    {
        Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        Contact_Role__c testContactRole = new Contact_Role__c (
            Account__c = testAcct.Id, 
            Contact__c = testContact.Id, 
            Type__c	= 'Student',
            Start_Date__c = Date.newInstance(2016, 12, 9),
            DS_Pending_Task_Date__c = Date.newInstance(2016, 12, 10)
        );
        
        insert testContactRole; 
        
        //Insert a logged call
        Task loggedCall = new Task(
        	Subject = 'Call',
            Type__c = 'Outbound Call',
            Status = 'Completed',
            WhatId = testContactRole.Id,
            DialSource__Call_Disposition_DS__c = 'Voicemail'
        );
        
        insert loggedCall;
        
        DSContactRolePBV3.sobjectsListRequests requestItem = new DSContactRolePBV3.sobjectsListRequests(); 
        List<DSContactRolePBV3.sobjectsListRequests> requestList = new List<DSContactRolePBV3.sobjectsListRequests>();
        requestItem.CRID = testContactRole.Id;
        requestList.add(requestItem);
        
        Test.startTest();
        DSContactRolePBV3.actions(requestList);
        Test.stopTest();
    }
    
    @isTest
    static void testIncrementingContactCount()
    {
        Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        Contact_Role__c testContactRole = new Contact_Role__c (
            Account__c = testAcct.Id, 
            Contact__c = testContact.Id, 
            Type__c	= 'Student',
            Start_Date__c = Date.newInstance(2016, 12, 9),
            DS_Pending_Task_Date__c = Date.newInstance(2016, 12, 10)
        );
        
        insert testContactRole; 
        
        //Insert a logged call
        Task loggedCall = new Task(
        	Subject = 'Call',
            Type__c = 'Outbound Call',
            Status = 'Completed',
            WhatId = testContactRole.Id,
            DialSource__Call_Disposition_DS__c = 'Contact'
        );
        
        insert loggedCall;
        
        DSContactRolePBV3.sobjectsListRequests requestItem = new DSContactRolePBV3.sobjectsListRequests(); 
        List<DSContactRolePBV3.sobjectsListRequests> requestList = new List<DSContactRolePBV3.sobjectsListRequests>();
        requestItem.CRID = testContactRole.Id;
        requestList.add(requestItem);
        
        Test.startTest();
        DSContactRolePBV3.actions(requestList);
        Test.stopTest();
    }
}