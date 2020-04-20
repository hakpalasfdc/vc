/***************************************************
Eric Varela & Jitesh Bhatia , Implementation Engineers, 12/6/2016

Last Updated 11/1/2017 by Jitesh Bhatia
Updated for VSP's second Denali build out. Moved the 
functionality to delete overdue activities to a separate
class: DSDenali_DeleteOverDueActivities. Added some extra
logic for pending due dates.

Brief Description: Invocable method that creates a follow
up task based on the DialSource V3 dispositions. In addition, 
it creates an Opportunity depending on the disposition selected.
****************************************************/
global class DSTaskDueDatePB {
        
    @InvocableMethod
    global static void createFollowUpTasks(List<DSTaskDueDatePB_Request> requests)
    {
        //List to store all the Contact Role Ids
        List<Id> contactRoleIDs = new List<Id>();
        Map<Id, Contact_Role__c> contactRoleMap = new Map<Id, Contact_Role__C>(); 

        //Store the last DialSource call
        Map<Id, Task> latestLoggedCall = new Map<Id, Task>(); 
        
        //List that stores all the Follow Up Tasks/Events to insert
        List<Task> followUpTasks = new List<Task>();
        List<Event> followUpEvents = new List<Event>();
        
        //Object record lists
        List<Contact_Role__c> contactRolesToUpdate = new List<Contact_Role__c>();
        List<Opportunity> oppsToInsert = new List<Opportunity>();
        List<OpportunityContactRole> oppContactRolesToInsert = new List<OpportunityContactRole>();
        List<Contact_Role__c> contactRoles = new List<Contact_Role__c>();
        List<Task> activityHistory = new List<Task>();
        
        //Add the Contact Role Ids to the list
        for (DSTaskDueDatePB_Request r : requests)
            contactRoleIDs.add(r.contactRoleID);

        queryRecords(contactRoleIDs, contactRoles, activityHistory);

        System.debug('Activity history: ' + activityHistory);

        for (Task t : activityHistory)
            latestLoggedCall.put(t.WhatId, t);
                
        //Map the id of the Contact Role to the Contact Role
        for (Contact_Role__c cr : contactRoles)
            contactRoleMap.put(cr.Id, cr); 
        
        for (DSTaskDueDatePB_Request r : requests)
        {
            //Follow Up Task to insert
            Task followUpTask = new Task();
            
            //Event to insert
            //Only if the DS_Pending_Event_Date__c checkbox is checked
            Event followUpEvent = new Event(); 
            
            //Contact Role we are referencing on this iteration
            Contact_Role__c currentContact = contactRoleMap.get(r.contactRoleID); 
            
            //Get the latest logged call 
            Task loggedCall = latestLoggedCall.get(r.contactRoleID);
            
            System.debug('Logged call: ' + loggedCall); 
            
            //Comments to add
            //If notes are enabled and the user leaves no notes,
            //the logged call will have a text value of 'NULL'
            //in the comments section
            followUpTask.Subject = isDescriptionNull(followUpTask, NULL, loggedCall.Description, r.subject);
            
            //Set the fields from the Process Builder
            followUpTask.OwnerId = r.assignedTo; 
            followUpTask.Status = r.status; 
            followUpTask.Type__c = r.taskType; 
            followUpTask.Priority = r.priority; 
            followUpTask.WhatId = currentContact.Id; 
            
            //Business days logic
            Integer condition = math.mod((Date.newInstance(1900, 1, 7).daysBetween(r.dateToday)), 7); 
            Integer numBusinessDays = r.dueDate; 
            Integer weekendsToSkip = Integer.valueOf(r.dueDate) / 5; 
            Integer modCase =  math.mod(Integer.valueOf(r.dueDate), 5); 
            Date followUpDate; 
            Date todaysDate = System.today();
            
            //Create Opp code
            if (r.createOpp != NULL)
            {
                if (r.createOpp && currentContact.DS_Last_Disposition__c == 'Altair Interested Prospect Opportunity')
                {
                    Opportunity Opp = New Opportunity();
                    
                    Opp.name = 'autofill'; //workflow autofills name of opp
                    Opp.Product_Program__c = 'Prospect';
                    Opp.StageName = 'Work';
                    Opp.VSP_Contact_Role__c = currentContact.Id;     
                    
                    //Retrieve the Contact Role associated with the current Task iteration
                    Opp.AccountId = currentContact.Account__c;
                    
                    Opp.Line_of_Business__c = 'Eyewear';
                    Opp.Division_Brand__c = 'Altair';
                    
                    Opp.CloseDate = System.Today() + 90;
                    Integer PlannedDate = Opp.CloseDate.month();
                    
                    //Set the close month
                    setOppPlannedCloseMonth(Opp, PlannedDate);
                                
                    //Relate to Opp Contact Role
                    OpportunityContactRole CR = new OpportunityContactRole();
                    CR.ContactId = currentContact.Contact__c;
                    CR.Role = 'Decision Maker';
                    
                    oppsToInsert.add(opp);
                    oppContactRolesToInsert.add(CR);
                }
                
                else if (r.createOpp && currentContact.DS_Last_Disposition__c == 'Altair Not Interested Prospect Opportunity')
                {
                    System.debug('Create closed lost opp');
                    
                    Opportunity Opp = New Opportunity();
                    
                    Opp.name = 'autofill'; //workflow autofills name of opp
                    Opp.Product_Program__c = 'Prospect';
                    Opp.StageName = 'Closed Lost';
                    Opp.Lost_Reason__c = 'Not Interested';    
                    Opp.VSP_Contact_Role__c = currentContact.Id;     
                    
                    //Retrieve the Contact Role associated with the current Task iteration
                    Opp.AccountId = currentContact.Account__c;
                    
                    Opp.Line_of_Business__c = 'Eyewear';
                    Opp.Division_Brand__c = 'Altair';
                    
                    Opp.CloseDate = System.Today();
                    Integer PlannedDate = Opp.CloseDate.month();
                    
                    //Set the close month
                    setOppPlannedCloseMonth(Opp, PlannedDate);
                    
                    //Relate to Opp Contact Role
                    OpportunityContactRole CR = new OpportunityContactRole();
                    CR.ContactId = currentContact.Contact__c;
                    CR.Role = 'Decision Maker';
                    
                    oppsToInsert.add(opp);
                    oppContactRolesToInsert.add(CR);
                    break;
                }
            }
                        
            //Test for the Date checkboxes
            if (currentContact.DS_Pending_Task_Date__c != NULL && r.pendingDateOption != NULL && r.pendingDateOption) 
            {
                followUpTask.ActivityDate = currentContact.DS_Pending_Task_Date__c;
                
                //Add to the list for insertion
                followUpTasks.add(followUpTask); 
            }

            else if (currentContact.DS_Pending_Event_Date__c != NULL && r.pendingDateOption != NULL && r.pendingDateOption)           
            {
                //Update the fields
                followUpEvent.Subject = isDescriptionNull(NULL, followUpEvent, loggedCall.Description, r.subject);
                followUpEvent.OwnerId = r.assignedTo; 
                followUpEvent.Event_Type__c = r.eventType; 
                followUpEvent.StartDateTime = currentContact.DS_Pending_Event_Date__c; 
                followUpEvent.EndDateTime = currentContact.DS_Pending_Event_Date__c.addMinutes(30);
                followUpEvent.WhatId = currentContact.Id;
                followUpEvent.Classification__c = r.eventClassification;
                
                System.debug('Follow up event (DSTaskDueDatePB): ' + followUpEvent);
                
                //Add to the list for insertion
                followUpEvents.add(followUpEvent);
            }
            
            else if (r.createUsingPendingDateOnly == NULL || r.createUsingPendingDateOnly == FALSE)
            {
                //Default Follow Up Task due date
                if (r.businessDaysOption != NULL && r.businessDaysOption)
                {
                    //Analagous to 1 business day out 
                    if (modCase == 1)
                    {
                        //Works: 1 day, 11 days
                        if (condition >= 1 && condition <= 4)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                        
                        else if (condition == 5)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 2; 
                        
                        else if (condition == 6)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 1; 
                        
                        else
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                    }
                    
                    //Analagous to 2 business days out 
                    else if (modCase == 2)
                    {
                        //Works: 2 days, 12 days
                        if (condition >= 1 && condition <= 3)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                        
                        else if (condition >= 4 && condition <= 5)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 2;
                        
                        else if (condition == 6)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 1;
                        
                        else
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                    }
                    
                    //Analagous to 3 business days out 
                    else if (modCase == 3)
                    {
                        //Works: 3 days, 13 days
                        if (condition >= 1 && condition <= 2)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                        
                        else if (condition >= 3 && condition <= 5)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 2;
                        
                        else if (condition == 6)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 1;
                        
                        else
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                    }
                    
                    //Analagous to 4 business days out 
                    else if (modCase == 4)
                    {
                        //Works: 4 days, 14 days
                        if (condition >= 2 && condition <= 5)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 2; 
                        
                        else if (condition == 1)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays;
                        
                        else if (condition == 6)
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays + 1;
                        
                        else
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays; 
                    }
                    
                    //Analagous to 5 business days out 
                    else 
                    {
                        //Works: 5 days, 10 days
                        if (condition >= 1 && condition <= 5)
                        {
                            System.debug('Entered this condition');
                            followUpDate = todaysDate + (weekendsToSkip * 2) + numBusinessDays;
                        }
                        
                        else if (condition == 6)
                            followUpDate = todaysDate + ((weekendsToSkip - 1) * 2) + numBusinessDays + 1;
                        
                        else 
                            followUpDate = todaysDate + ((weekendsToSkip - 1) * 2) + numBusinessDays;
                    }
                    
                    followUpTask.ActivityDate = followUpDate;
                    
                    //Add to the list for insertion
                    followUpTasks.add(followUpTask);
                }

                else if (r.specificDateOption != NULL && r.specificDateOption)
                {
                    followUpTask.ActivityDate = Date.newInstance(r.specificYear, r.specificMonth, r.specificDay);

                    //Add to the list for insertion
                    followUpTasks.add(followUpTask);
                }
                
                else
                {
                    followUpTask.ActivityDate = System.today() + r.dueDate;
                    
                    //Add to the list for insertion
                    followUpTasks.add(followUpTask);
                }
            }
        }
        
        //Insert new Follow Up Events
        if (followUpEvents.size() > 0)
        {
            try{
                insert followUpEvents;
            }
            
            catch (DMLException e){
                System.debug('The following error occured (DSTaskDueDatePB): ' + e);
            }
        }
        
        //Insert new Follow Up Tasks
        if (followUpTasks.size() > 0)
        {
            try{
                insert followUpTasks; 
            }
            
            catch (DMLException e){
                System.debug('The following error occured (DSTaskDueDatePB): ' + e);
            }
        }
        
        if (oppsToInsert.size() > 0)
        {
            try{
                insert oppsToInsert; 
            }
            
            catch (DMLException e){
                System.debug('The following error occured (DSTaskDueDatePB): ' + e);
            }
        }
        
        //Relate the Contact Roles to the newly inserted Opps
        for (Integer i = 0; i < oppContactRolesToInsert.size(); i++)
            oppContactRolesToInsert[i].OpportunityId = oppsToInsert[i].Id;
        
        if (oppContactRolesToInsert.size() > 0)
        {
            try{
                insert oppContactRolesToInsert; 
            }
            
            catch (DMLException e){
                System.debug('The following error occured (DSTaskDueDatePB): ' + e);
            }
        }
    }

    private static void queryRecords(List<Id> contactRoleIDs, List<Contact_Role__c> contactRoles,  List<Task> activityHistory)
    {
        //Query for all the Contact Roles whose ids are in the list
        contactRoles.addAll(new List<Contact_Role__c>([SELECT id, DS_Pending_Event_Date__c, DS_Pending_Task_Date__c, 
                                              DS_Last_Disposition__c, 
                                              Account__c, Contact__c
                                              FROM Contact_Role__c
                                              WHERE id IN :contactRoleIDs]));

        //Query for all Activity History to get Notes section 
        activityHistory.addAll(new List<Task>([SELECT Id, WhatID, Description, Subject, 
                                      Type__c, OwnerID, Status, ActivityDate, CreatedDate 
                                      FROM Task 
                                      WHERE WhatID IN :contactRoleIDs
                                      AND status = 'Completed' 
                                      ORDER BY CreatedDate]));        

        System.debug('Activity history: ' + activityHistory);
    }
    
    //Return the adjusted subject line
    private static String isDescriptionNull(Task t, Event e, String description, String requestSubject)
    {
        String subject; 
        
        if (description != NULL && description != 'NULL')
        {
            if (t != NULL)
                t.Description = description; 
            
            if (e != NULL)
                e.Event_Description__c = description; 
            
            System.debug('Logged call description: ' + description);
            String addToSubject;
            
            //To account for the added phone number dialed in 
            //the description
            String[] testString = description.split('\n');
            String descriptionAdjusted = ''; 
            
            Integer i = 0; 
            for (String s : testString)
            {
                System.debug('Test string: ' + s); 
                
                if (i >= 2)
                {
                    s += ' '; 
                    descriptionAdjusted += s; 
                }
                
                i++;
            }
            
            if (descriptionAdjusted.length() > 77)
                addToSubject = descriptionAdjusted.substring(0, 77);
            
            else
                addToSubject = descriptionAdjusted.substring(0);
            
            Subject = requestSubject + ': ' + addToSubject; 
            return Subject; 
        }
            
        Subject = requestSubject; 
        return Subject; 
    }
    
    //Set the correct Opp close month
    private static void setOppPlannedCloseMonth (Opportunity opp, Integer plannedDate)
    {
        if (PlannedDate == 1)
            Opp.Planned_Closed_Month__c = 'January';
        
        if (PlannedDate == 2)
            Opp.Planned_Closed_Month__c = 'February';
        
        if (PlannedDate == 3)
            Opp.Planned_Closed_Month__c = 'March';
        
        if (PlannedDate == 4)
            Opp.Planned_Closed_Month__c = 'April';
        
        if (PlannedDate == 5)
            Opp.Planned_Closed_Month__c = 'May';
        
        if (PlannedDate == 6)
            Opp.Planned_Closed_Month__c = 'June';
        
        if (PlannedDate == 7)
            Opp.Planned_Closed_Month__c = 'July';
        
        if (PlannedDate == 8)
            Opp.Planned_Closed_Month__c = 'August';
        
        if (PlannedDate == 9)
            Opp.Planned_Closed_Month__c = 'September';
        
        if (PlannedDate == 10)
            Opp.Planned_Closed_Month__c = 'October';
        
        if (PlannedDate == 11)
            Opp.Planned_Closed_Month__c = 'November';
        
        if (PlannedDate == 12)
            Opp.Planned_Closed_Month__c = 'December';
    }
    
    global class DSTaskDueDatePB_Request
    {
        @InvocableVariable (required=true)
        global Id contactRoleID; 
        
        @InvocableVariable (required=true)
        global Integer dueDate; 
        
        @InvocableVariable (required=true)
        global String subject; 
        
        @InvocableVariable (required=true)
        global Id assignedTo; 
        
        @InvocableVariable (required=true)
        global String status; 
        
        @InvocableVariable (required=true)
        global String taskType; 

        @InvocableVariable (required=false)
        global String eventType; 

        @InvocableVariable (required=false)
        global String eventClassification; 
        
        @InvocableVariable (required=true)
        global String priority;
        
        @InvocableVariable (required=false)
        global Boolean businessDaysOption;

        @InvocableVariable (required=false)
        global Boolean pendingDateOption;

        @InvocableVariable (required=false)
        global Boolean createUsingPendingDateOnly;

        @InvocableVariable (required=false)
        global Boolean specificDateOption;

        @InvocableVariable (required=false)
        global Integer specificYear;

        @InvocableVariable (required=false)
        global Integer specificMonth;

        @InvocableVariable (required=false)
        global Integer specificDay;
        
        @InvocableVariable (required=false)
        global Boolean createOpp;
                
        @InvocableVariable (required=false)
        global Date dateToday = System.today();
    }
}