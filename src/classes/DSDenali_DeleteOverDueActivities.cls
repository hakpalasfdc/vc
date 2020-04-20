/***************************************************
Jitesh Bhatia, Implementation Engineer, 10/25/2017

Brief Description: Deletes overdue Tasks or Events.
****************************************************/
public class DSDenali_DeleteOverDueActivities {
    
    private static List<Task> followUpTasksToDelete = new List<Task>(); 
    private static List<Event> followUpEventsToDelete = new List<Event>();
    private static Map<Id, Set<String>> ownerOfActivities = new Map<Id, Set<String>>();

    @InvocableMethod (label = 'DialSource Denali Delete Overdue Activities')
    public static void gatherData(List<Data> requests)
    {
        Map<Id, String> results = new Map<Id, String>();

        for (Data request : requests)
            results.put(request.contactRoleID, request.assignedTo);
        

        for (Id key : results.keySet())
        {
            Set<String> assignedToValues = parseAssignedTo(results.get(key));
            System.debug('assignedToValues: ' + assignedToValues);
            ownerOfActivities.put(key, assignedToValues);
        }

        queryAndFilterData();
        deleteOverdueActivities();
    }

    //Query for the Tasks and Events and filter the ones to delete
    private static void queryAndFilterData()
    {
        
        //get contact roles
        List<Contact_Role__c> contactRoles = [SELECT Id, Account_ID_Text__c,
                                              
                                            (SELECT Id, Owner.UserRole.Name, Subject, OwnerId FROM Tasks 
                                             //WHERE (Status != 'Completed' AND ActivityDate <= :System.TODAY() AND Type__c = 'Outbound Call') OR
                                             //(Subject LIKE '%Altair Left Message Follow Up%' AND ActivityDate >= :System.TODAY())
                                             ),
                                             
                                             
                                              (SELECT Id, Owner.UserRole.Name, OwnerId, Description FROM Events 
                                               //WHERE EndDateTime <= :System.NOW()
                                              )
                                            
                                            
                                            
                                              
                                                    
                                             FROM Contact_Role__c
                                             WHERE Id IN :ownerOfActivities.keySet()];
        
        System.debug('Initial contact roles are: ' + contactRoles);                                           
        

        
        List<Id> cRIds = new List<Id>();
        
        for(Contact_Role__c c : contactRoles){
            ID cId = Id.valueOf(c.Account_ID_Text__c);
            cRIDs.add(cId);
        }
        
        System.debug('CRIDS = ' + cRIDs);

        
        
        //get accounts related to contact roles
        List<Contact_Role__c> contactRoleAccounts = [SELECT Account_ID_Text__c 
                                                     FROM Contact_Role__c WHERE Account__c =: cRIds];
        
        System.debug('Contact Role Accounts are ' + contactRoleAccounts);
        
        

        
        List<Contact_Role__c> cRole = [SELECT Id FROM Contact_Role__c WHERE Account_ID_Text__c =: crIDs];
 
        
        //get tasks & events related to accounts
        List<Task> craTasks = [SELECT Id, ActivityDate, Status, Owner.UserRole.Name, OwnerId, Type__c, Subject FROM Task WHERE 
                               WhatId =: cRole];
        
        List<Event> craEvents = [SELECT Id, Description, EndDateTime, Owner.UserRole.Name, OwnerId, Subject FROM Event WHERE 
                               WhatId =: cRole];
        
        System.debug(craTasks + ' craEventsBeforeFilter ' + craEvents);
        System.debug('There are ' + craTasks.size() + ' CRA Non Culled Tasks');
        
        
        List<Task> craTasksCulled = new List<Task>();
        List<Event> craEventsCulled = new List<Event>();
        
        
        //set task deletion criteria
        
        //emulate this.....cont. on line 143
        
        for(Task t : craTasks){
           //craTasksCulled.add(t);
            
             if(t.ActivityDate <= System.Today() && t.Type__c == 'Outbound Call' && t.Status != 'Completed'){
                craTasksCulled.add(t);
            }
            else if(t.ActivityDate >= System.Today() && t.Subject.ContainsIgnoreCase('Left Message Follow')){
                craTasksCulled.add(t);
            }
//            else if(t.ActivityDate >= System.Today() && t.Subject.startsWithIgnoreCase('Altair Prospect Left Message Followup')){
//                craTasksCulled.add(t);
//            }
//            else if(t.ActivityDate >= System.Today() && t.Subject.startsWithIgnoreCase('Altair Prospect Left Message Follow')){
//                craTasksCulled.add(t);
//            }
//            else if(t.ActivityDate >= System.Today() && t.Subject.startsWithIgnoreCase('Altair Left Message Followup')){
//                craTasksCulled.add(t);
//            }
//            else if(t.ActivityDate >= System.Today() && t.Subject.startsWithIgnoreCase('Altair Left Message Follow')){
//                craTasksCulled.add(t);
//            }
            System.debug('There are ' + craTasksCulled.size() + ' CRA Culled Tasks');
        }
        
        
        for(Event e : craEvents){
            if(e.EndDateTime < System.now() && e.Description == NULL){
            craEventsCulled.add(e);
            }
            else if (e.EndDateTime > System.now() && e.Subject.ContainsIgnoreCase('Left Message Follow')){
                craEventsCulled.add(e);
            }
//            else if(e.EndDateTime > System.now() && e.Subject.startsWithIgnoreCase('Altair Left Message Followup')){
//               craEventsCulled.add(e);
//            }
//            else if(e.EndDateTime > System.now() && e.Subject.startsWithIgnoreCase('Altair Left Message Follow')){
//               craEventsCulled.add(e);
//            }
//            else if(e.EndDateTime > System.now() && e.Subject.startsWithIgnoreCase('Altair Prospect Left Message Followup')){
//               craEventsCulled.add(e);
//            }
//             else if(e.EndDateTime > System.now() && e.Subject.startsWithIgnoreCase('Altair Prospect Left Message Follow')){
//               craEventsCulled.add(e);
//            }
           
            
            else continue;
        }
    
        System.debug('Account Ids are :' + cRIds + ' and tasks are ' + craTasksCulled + ' and craEvents are ' + craEventsCulled);
        
        
        for (Contact_Role__c contactRole : contactRoles)
        {
        System.debug('owner of activities: ' + ownerOfActivities.get(contactRole.Id));
            
            for (Task currentTask : craTasksCulled)
            {
                if (ownerOfActivities.get(contactRole.Id).contains(currentTask.OwnerId))
                {
                    if (currentTask.OwnerId != '0050B000006ET37' && currentTask.Owner.UserRole != NULL && (Pattern.matches('.*Altair.*', currentTask.Owner.UserRole.Name)||Pattern.matches('.*Eyewear Customer.*', currentTask.Owner.UserRole.Name)))
                        followUpTasksToDelete.add(currentTask);

                    else if (currentTask.OwnerId == '0050B000006ET37')
                        followUpTasksToDelete.add(currentTask);

                    else 
                        continue; 
                }

                else if (ownerOfActivities.get(contactRole.Id).contains('ALL'))
                {
                    if (currentTask.Owner.UserRole != NULL && (Pattern.matches('.*Altair.*', currentTask.Owner.UserRole.Name)||Pattern.matches('.*Eyewear Customer.*', currentTask.Owner.UserRole.Name)))
                        followUpTasksToDelete.add(currentTask);

                    else 
                        continue;
                }
            }

            //...through this
            
            
            //iterate through events
            //LEFT OFF HERE
            System.debug('events are ' + craEventsCulled);
            for (Event currentEvent : craEventsCulled)
            {
                if (ownerOfActivities.get(contactRole.Id).contains(currentEvent.OwnerId))
                {
                    if (currentEvent.OwnerId != '0050B000006ET37' && currentEvent.Owner.UserRole != NULL && 
                        (Pattern.matches('.*Altair.*', currentEvent.Owner.UserRole.Name)||Pattern.matches('.*Eyewear Customer.*', currentEvent.Owner.UserRole.Name)))
                        followUpEventsToDelete.add(currentEvent);

                    else if (currentEvent.OwnerId == '0050B000006ET37')
                        followUpEventsToDelete.add(currentEvent);

                    else 
                        continue; 
                }

                else if (ownerOfActivities.get(contactRole.Id).contains('ALL') 
                         //&& currentEvent.Description == NULL && currentEvent.EndDateTime < System.now()
                        )
                {
                    if (currentEvent.Owner.UserRole != NULL && (Pattern.matches('.*Altair.*', currentEvent.Owner.UserRole.Name) ||Pattern.matches('.*Eyewear Customer.*', currentEvent.Owner.UserRole.Name))
                    //&& currentEvent.Description == NULL
                    )
                        followUpEventsToDelete.add(currentEvent);

                    else 
                        continue;
                }
            }
        }                                   
    }

    //Delete overdue Events/Tasks
    private static void deleteOverdueActivities()
    {
        try{
            System.debug('Final Delete Report: ' + followUpTasksToDelete);
            delete followUpTasksToDelete;
        }

        catch (DmlException e){
            System.debug('The following error occured (DSDenali_DeleteOverDueActivities): ' + e);
        }

        try{
            delete followUpEventsToDelete;
        }

        catch (DmlException e){
            System.debug('The following error occured (DSDenali_DeleteOverDueActivities): ' + e);
        }
    }

    //Parse the CSVs of possible owners
    private static Set<String> parseAssignedTo(String assignedTo)
    {
        Set<String> assignedToValues = new Set<String>();
        assignedToValues.addAll(assignedTo.deleteWhitespace().split(','));
        return assignedToValues;
    }

    public class Data
    {
        @InvocableVariable (required=true)
        public String assignedTo;

        @InvocableVariable (required=true)
        public Id contactRoleID; 
    }
}