@isTest
private class DSUpdateVMConvoCountV3_Test 
{	
	@isTest 
	static void testAccuracy() {
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

        //Insert a logged call
        Task loggedCall2 = new Task(
        	Subject = 'Call',
            Type__c = 'Outbound Call',
            Status = 'Completed',
            WhatId = testContactRole.Id,
            DialSource__Call_Disposition_DS__c = 'Convo'
        );
        
        insert loggedCall2;

        //Start test
        Test.startTest();
        DSUpdateVMConvoCountV3 batchJob = new DSUpdateVMConvoCountV3();
        database.executebatch(batchJob, 200);
        Test.stopTest();

        //Query for the inserted Contact Role
        Contact_Role__c updatedContactRole = [SELECT Id, DS_Conversation_Count__c, DS_VM_Count__c FROM Contact_Role__c WHERE Id = :testContactRole.Id LIMIT 1]; 

        System.assertEquals(1, updatedContactRole.DS_Conversation_Count__c, 'The Conversation Count for the last 30 days is incorrect.');
        System.assertEquals(1, updatedContactRole.DS_VM_Count__c, 'The Voicemail Count for the last 30 days is incorrect.');
	}
	
}