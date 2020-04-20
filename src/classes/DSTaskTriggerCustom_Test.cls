@isTest
public class DSTaskTriggerCustom_Test {

    @isTest
    static void insertTaskAndContactRole(){
        
        //Search the database for the active user and grab the first user id
        List<User> activeUserList = new List<User>([SELECT Id FROM User WHERE IsActive = true]);
        List<Id> activeUserIdList = new List<Id>();
        for(User u : activeUserList)
        {
            activeUserIdList.add(u.Id);
        }
        Id UID = activeUserIdList[0];
        
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
        
        Task t2 = new Task(
            OwnerId = UID,
            WhatId = testContactRole.Id,
            Status = 'Completed',
            CallDurationInSeconds = 0,
            Subject='DialSource Automated Call',
            DialSource__Call_Disposition_DS__c ='Recycle',
            DialSource__Call_Campaign_DS__c = 'Test List 2!',
            Description='Description: Please look at recording  Please look at recording Please look at recording Please look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recordingPlease look at recording'); 
    
        Test.startTest(); 
        insert t2; 
        t2.Status= 'In Progress'; 
        update t2; 
        Test.stopTest(); 
    
    }
}