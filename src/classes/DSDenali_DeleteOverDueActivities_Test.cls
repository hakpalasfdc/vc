@isTest
private class DSDenali_DeleteOverDueActivities_Test {
	
	@isTest 
	static void deleteUserTask() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;

		//Create Task
		Task testTask = new Task();
		testTask.Subject = 'Task To Delete';
		testTask.Type__c = 'Outbound Call';
		testTask.ActivityDate = System.today() - 1;
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;
		System.debug('Owner: '+ testTask.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testTask.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}

	@isTest
	static void deleteQueueTask() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE Id = '0050B000006ET37' LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;

		//Create Task
		Task testTask = new Task();
		testTask.Subject = 'Task To Delete';
		testTask.Type__c = 'Outbound Call';
		testTask.ActivityDate = System.today() - 1;
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;
		System.debug('Owner: '+ testTask.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testTask.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();

		Task deletedTask;

		//Make sure the Task is deleted
		try{
			deletedTask = [SELECT Id, OwnerId FROM Task WHERE Id = :testTask.Id];
		}

		catch(Exception e){
			System.assertEquals('List has no rows for assignment to SObject', e.getMessage());
		}
	}
	
	@isTest 
	static void deleteUserEvent() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;

		//Create Task
		Event testEvent = new Event();
		testEvent.Subject = 'Task To Delete';
		testEvent.Event_Type__c = 'Outbound Call';
		testEvent.StartDateTime = System.now() - 1;
		testEvent.DurationInMinutes = 30;
		testEvent.WhatId = testContactRole.Id;
		testEvent.OwnerId = u.Id;

		insert testEvent;
		System.debug('Owner: '+ testEvent.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testEvent.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}
    @isTest 
	static void deleteUserAltairProspectLeftMessageFollowEvent() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;
        
        //Create Task
		Task testTask = new Task();
		testTask.Subject = 'Altair Prospect Left Message Follow';
		testTask.Type__c = 'Email';
		testTask.ActivityDate = System.today();
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;

		//Create Task
		Event testEvent = new Event();
		testEvent.Subject = 'Altair Prospect Left Message Follow';
		testEvent.Event_Type__c = 'Outbound Call';
		testEvent.StartDateTime = System.now();
		testEvent.DurationInMinutes = 30;
		testEvent.WhatId = testContactRole.Id;
		testEvent.OwnerId = u.Id;

		insert testEvent;
		System.debug('Owner: '+ testEvent.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testEvent.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}
    
    
    
    
    
    
    
    @isTest 
	static void deleteUserAltairProspectLeftMessageFollowupEvent() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;
        
        //Create Task
		Task testTask = new Task();
		testTask.Subject = 'Altair Prospect Left Message Followup';
		testTask.Type__c = 'Email';
		testTask.ActivityDate = System.today();
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;

		//Create Task
		Event testEvent = new Event();
		testEvent.Subject = 'Altair Prospect Left Message Followup';
		testEvent.Event_Type__c = 'Outbound Call';
		testEvent.StartDateTime = System.now();
		testEvent.DurationInMinutes = 30;
		testEvent.WhatId = testContactRole.Id;
		testEvent.OwnerId = u.Id;

		insert testEvent;
		System.debug('Owner: '+ testEvent.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testEvent.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}
    
    @isTest 
	static void deleteUserAltairLeftMessageFollowupEvent() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;
        
        //Create Task
		Task testTask = new Task();
		testTask.Subject = 'Altair Left Message Followup';
		testTask.Type__c = 'Email';
		testTask.ActivityDate = System.today();
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;

		//Create Task
		Event testEvent = new Event();
		testEvent.Subject = 'Altair Left Message Followup';
		testEvent.Event_Type__c = 'Outbound Call';
		testEvent.StartDateTime = System.now();
		testEvent.DurationInMinutes = 30;
		testEvent.WhatId = testContactRole.Id;
		testEvent.OwnerId = u.Id;

		insert testEvent;
		System.debug('Owner: '+ testEvent.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testEvent.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}
    
     @isTest 
	static void deleteUserAltairLeftMessageFollowEvent() 
	{
		User u = [SELECT Id, IsActive, UserRole.Name FROM User WHERE IsActive = TRUE AND Username = :UserInfo.getUsername() LIMIT 1];
		System.debug('User: ' + u.UserRole.Name);

		Account testAcct = new Account(
            Name = 'Test Account'
        ); 
            
        insert testAcct; 
        
        Contact testContact = new Contact(
        	LastName = 'Test',
            Account = testAcct
        );
        
        insert testContact; 
        
        //Create Contact Role
        Contact_Role__c testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
            );

        insert testContactRole;
        
        //Create Task
		Task testTask = new Task();
		testTask.Subject = 'Altair Left Message Follow';
		testTask.Type__c = 'Email';
		testTask.ActivityDate = System.today();
		testTask.WhatId = testContactRole.Id;
		testTask.Status = 'Not Started';
		testTask.OwnerId = u.Id;

		insert testTask;

		//Create Task
		Event testEvent = new Event();
		testEvent.Subject = 'Altair Left Message Follow';
		testEvent.Event_Type__c = 'Outbound Call';
		testEvent.StartDateTime = System.now();
		testEvent.DurationInMinutes = 30;
		testEvent.WhatId = testContactRole.Id;
		testEvent.OwnerId = u.Id;

		insert testEvent;
		System.debug('Owner: '+ testEvent.Owner);

		List<DSDenali_DeleteOverDueActivities.Data> dataList = new List<DSDenali_DeleteOverDueActivities.Data>(); 
		DSDenali_DeleteOverDueActivities.Data data = new DSDenali_DeleteOverDueActivities.Data(); 
		data.assignedTo = testEvent.OwnerId; 
		data.contactRoleID = testContactRole.Id;
        dataList.add(data);

		Test.startTest(); 
		DSDenali_DeleteOverDueActivities.gatherData(dataList);
		Test.stopTest();
	}
}