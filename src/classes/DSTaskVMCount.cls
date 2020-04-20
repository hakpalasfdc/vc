global class DSTaskVMCount {
	@InvocableMethod
    public static void DSSendtoQueue(List<sobjectsListRequests> requests)
    {   
        System.debug('In Invocable Method');
        ID TaskID;
        ID WhatID;
        String Subject;
        //String Description;
        List<Id> contactRoleIds = new List<Id>(); 
        List<Id> taskIds = new List<Id>(); 

        for (sobjectsListRequests request : requests)
        {
            TaskID = request.TaskIdRequest;
            WhatID = request.WhatIdRequest;
			Subject = request.SubjectRequest;
            //Description = request.DescriptionRequest;
            //Create lists to hold the Task Ids and Contact Role Ids
            taskIds.add(TaskID); 
            contactRoleIds.add(WhatID); 
        }
        system.debug('CRID = ' + WhatID);
		system.debug('TaskID = ' + TaskID);

        //Retrieve the Tasks which fired the event
        List<Task> dispoTasks = new List<Task>([SELECT
                                                Id,
                                               	WhoId,  //Contact
                                                WhatId, //Contact Role 
                                               	Description,
                                                Subject,
                                                ActivityDate,
                                                Type__c,
                                                Priority,
                                                Status
                                               	FROM 
                                               	Task 
                                               	WHERE 
                                               	Id in :taskIds]);
   
        //Retrieve the Contact Roles associated with each task 
        List<Contact_Role__c> contactRoles = new List<Contact_Role__c>([SELECT 
                                                                        Id, 
                                                                        DS_VM_Count__c 
                                                                        FROM 
                                                                        Contact_Role__c
                                                                        WHERE
                                                                        Id in :contactRoleIds]);
        
        //Map the Contact Role Id to the Contact Role Object
        Map<Id, Contact_Role__c> contactRoleMap = new Map<Id, Contact_Role__c>(); 
        
        for (Contact_Role__c c : contactRoles)
        	contactRoleMap.put(c.Id, c); 
        
        //List of follow up tasks to insert
        List<Task> followUpTasks = new List<Task>(); 
        
        for (Task t : dispoTasks)
        {
            Integer businessDays;
                
            //Create a follow up task 
            Task followUpTask = new Task(); 
            followUpTask.WhoId = t.WhoId;
            followUpTask.WhatId = t.WhatId; 
            
            if (t.Description != null && t.Description != '')
            	followUpTask.Description = t.Description;
            
            followUpTask.Status = 'Not Started';
            followUpTask.Type__c = 'Outbound Call'; 
            followUpTask.Priority = 'Normal'; 
            followUpTask.Subject = Subject; 
            followUpTask.Description = subject.substringAfter(':');
            
            IF((Integer)contactRoleMap.get(t.WhatId).DS_VM_Count__c >= 6)
            {
               followUpTask.ActivityDate = System.today() + 30;
            }
            Else 
            {
            businessDays = (Integer)contactRoleMap.get(t.WhatId).DS_VM_Count__c + 1; 
            followUpTask.ActivityDate = System.today() + businessDays;
            }
            
            followUpTasks.add(followUpTask); 
        }
        
        insert followUpTasks; 
        
    }
      
    global class sobjectsListRequests
    {
        @InvocableVariable(required=True)
        public Id TaskIdRequest;
        @InvocableVariable(required=True)
        public Id WhatIdRequest;
        @InvocableVariable(required=False)
        public string SubjectRequest;
        //@InvocableVariable(required=False)
        //public string DescriptionRequest;
    }
}