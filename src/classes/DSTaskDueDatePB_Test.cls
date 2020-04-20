@isTest
public class DSTaskDueDatePB_Test {

    @isTest
    static void pendingTask()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('', 'Task').Id; 
        testRequest.dueDate = 10;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest
    static void pendingEvent()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','Event').Id; 
        testRequest.dueDate = 10;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }

    @isTest 
    static void normalDays()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 11;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = false; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask1DayMonday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 11;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask1DayFriday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 11;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 9);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask1DaySaturday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 11;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 10);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask1DaySunday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 11;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 11);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask2DaysMonday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 12;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
		testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask2DaysThursday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 12;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
		testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 8);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask2DaysSaturday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 12;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
		testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 10);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask2DaysSunday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 12;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
		testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 11);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask3DaysMonday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 13;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask3DaysWednesday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 13;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 7);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask3DaysSaturday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 13;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 10);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask3DaysSunday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 13;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 11);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask4DaysMonday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 14;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask4DaysTuesday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 14;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 6);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest
    static void defaultTask4DaysSaturday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 14;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 10);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest
    static void defaultTask4DaysSunday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 14;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 11);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask5DaysMonday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 15;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 5);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask5DaysSaturday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 15;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 24);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTask5DaysSunday()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('','').Id; 
        testRequest.dueDate = 15;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 25);
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTaskOppInterested()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('Altair Interested Prospect Opportunity','Task').Id; 
        testRequest.dueDate = 15;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 25);
        testRequest.createOpp = true; 
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    @isTest 
    static void defaultTaskOppNotInterested()
    {
        User u = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE LIMIT 1];
        
        List<DSTaskDueDatePB.DSTaskDueDatePB_Request> testRequestList = new List<DSTaskDueDatePB.DSTaskDueDatePB_Request>();
        DSTaskDueDatePB.DSTaskDueDatePB_Request testRequest = new DSTaskDueDatePB.DSTaskDueDatePB_Request();
        
        testRequest.contactRoleID = instantiateDBTask('Altair Not Interested Prospect Opportunity','Task').Id; 
        testRequest.dueDate = 15;
        testRequest.subject = 'Test';
        testRequest.assignedTo = u.Id; 
        testRequest.status = 'Test';
        testRequest.taskType = 'Test'; 
        testRequest.priority = 'Test';
        testRequest.businessDaysOption = true; 
        testRequest.dateToday = Date.newInstance(2016, 12, 25);
        testRequest.createOpp = true; 
        
        testRequestList.add(testRequest);
        
        Test.startTest(); 
        DSTaskDueDatePB.createFollowUpTasks(testRequestList);
        Test.stopTest();
    }
    
    static public Contact_Role__c instantiateDBTask(String lastDisposition, String taskOrEvent)
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
        
        Contact_Role__c testContactRole;
        
        if (taskOrEvent == 'Task')
        {
            testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9),
                DS_Pending_Task_Date__c = Date.newInstance(2016, 12, 10),
                DS_Last_Disposition__c = lastDisposition
            );
        }
        
        else if (taskOrEvent == 'Event')
        {
            testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9),
                DS_Pending_Event_Date__c = Date.newInstance(2016, 12, 10)
        	);
        }
        
        else
        {
            testContactRole = new Contact_Role__c (
                Account__c = testAcct.Id, 
                Contact__c = testContact.Id, 
                Type__c	= 'Student',
                Start_Date__c = Date.newInstance(2016, 12, 9)
        	);
        }
        
        insert testContactRole; 
        
        //Insert a logged call
        Task loggedCall = new Task(
        	Subject = 'Call',
            Type__c = 'Outbound Call',
            Status = 'Completed',
            WhatId = testContactRole.Id,
            Description = 'Test'
        );
        
        insert loggedCall;
        
        return testContactRole;
    }
}