/***************************************************
Jitesh Bhatia, Implementation Engineer, 12/6/2016

12/6/2016

Brief Description: Relates the follow up Event 
to the Contact on the Contact Role record. 
****************************************************/
trigger DSUpdateEventNameV3 on Event (before insert) {
	
    //List to store the Event records to update
    List<Event> eventsToUpdate = new List<Event>();

    if (Trigger.isInsert)
    {
        for (Event e : Trigger.new)
        {

            if (e.Event_Type__c == 'Outbound Call' && e.WhatId != NULL
                
               && e.Classification__c == 'Other')
            {
                //Only add follow up Events related to a Contact Role
                if (String.valueOf(e.WhatId).startsWith('a0f'))
                    eventsToUpdate.add(e);
            }
        }
    }
    
    //Perform the trigger actions only if we have some 
    //events to update
    if (eventsToUpdate.size() > 0)
    {
        //Maps to traverse the object relationships
        Map<Id, Id> eventToContactRole = new Map<Id, Id>(); 
        Map<Id, Id> contactRoleToContact = new Map<Id, Id>();
        
       	//Map the Event to its Contact Role
        for (Event e : eventsToUpdate)
            eventToContactRole.put(e.Id, e.WhatId);
        
        //Query for Contact Roles related to our Events
        List<Contact_Role__c> contactRoles = [SELECT Contact__c, Id
                                              FROM Contact_Role__c
                                              WHERE Id IN :eventToContactRole.values()];
        //If the query returns values
        if (contactRoles.size() > 0)
        {
            //Map the Contact Role to its Contact
            for (Contact_Role__c c : contactRoles)
                contactRoleToContact.put(c.Id, c.Contact__c);
        }
        
        //Relate the Events to the appropriate Contact
        for (Event e : eventsToUpdate)
            e.WhoId = contactRoleToContact.get(eventToContactRole.get(e.Id));
    }   
}