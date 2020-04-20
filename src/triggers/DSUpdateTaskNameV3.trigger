/***************************************************
Jitesh Bhatia, Implementation Engineer, 12/6/2016

12/6/2016

Brief Description: Relates the DialSource logged call 
to the Contact on the Contact Role record. 
****************************************************/
trigger DSUpdateTaskNameV3 on Task (before update, before insert) {

    System.debug('updatedTaskNameV3'); 
    
    //List to store the Task records to update
    List<Task> tasksToUpdate = new List<Task>();
    
    //Activity History
    if (Trigger.isUpdate)
    {
        for (Task t : Trigger.new)
        {
            System.debug('Disposition (updateTaskNameV3): ' + t.DialSource__Call_Disposition_DS__c);
            System.debug('Status (updateTaskNameV3): ' +  t.Status);
            System.debug('Related to (updateTaskNameV3): ' + t.WhatId);
            
            //Only DialSource logged calls
            if (t.DialSource__Call_Disposition_DS__c != NULL
               && t.Status == 'Completed' && t.WhatId != NULL)
            {
                System.debug('DialSource Logged Call (updateTaskNameV3): ' + t);
                
                //Only add DialSource calls related to a Contact Role
                if (String.valueOf(t.WhatId).startsWith('a0f'))
                    tasksToUpdate.add(t);
            }
        }
    }
    
    //Open Activities
    if (Trigger.isInsert)
    {
        for (Task t : Trigger.new)
        {
            System.debug('Disposition (updateTaskNameV3): ' + t.DialSource__Call_Disposition_DS__c);
            System.debug('Status (updateTaskNameV3): ' +  t.Status);
            System.debug('Related to (updateTaskNameV3): ' + t.WhatId);
            
            if (t.Priority == 'Normal' && t.type__c == 'Outbound Call'
               && t.Status == 'Not Started' && t.WhatId != NULL)
            {
                //Only add follow up Tasks related to a Contact Role
                if (String.valueOf(t.WhatId).startsWith('a0f'))
                    tasksToUpdate.add(t);
            }
        }
    }
    
    //Perform the trigger actions only if we have some 
    //tasks to update
    if (tasksToUpdate.size() > 0)
    {
        //Maps to traverse the object relationships
        Map<Id, Id> taskToContactRole = new Map<Id, Id>(); 
        Map<Id, Id> contactRoleToContact = new Map<Id, Id>();
        
       	//Map the Task to its Contact Role
        for (Task t : tasksToUpdate)
            taskToContactRole.put(t.Id, t.WhatId);
        
        //Query for Contact Roles related to our Tasks
        List<Contact_Role__c> contactRoles = [SELECT Contact__c, Id
                                              FROM Contact_Role__c
                                              WHERE Id IN :taskToContactRole.values()];
        //If the query returns values
        if (contactRoles.size() > 0)
        {
            //Map the Contact Role to its Contact
            for (Contact_Role__c c : contactRoles)
                contactRoleToContact.put(c.Id, c.Contact__c);
        }
        
        //Relate the Tasks to the appropriate Contact
        for (Task t : tasksToUpdate)
            t.WhoId = contactRoleToContact.get(taskToContactRole.get(t.Id));
    }   
}