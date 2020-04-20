/***************************************************
Original Author: Eric Varela, Modified By: Jitesh Bhatia, Implementation Engineer, 12/5/2016

Last Updated 11/22/2017 by Jitesh Bhatia
Updated to prevent adding "Skip Call" to the Conversation Count.

Brief Description: Increments the 'Conversation Count' or 'Voicemail Count'
fields on the Contact Role record depending on which disposition is
clicked. Modified by Jitesh to work for V3.  
****************************************************/
global class DSContactRolePBV3 {

   	@InvocableMethod
    public static void actions(List<sobjectsListRequests> requests){
	
        List<Id> CRID = new List<Id>(); 
       
        //Retrieve variables from the Process Builder
        for (sobjectsListRequests r : requests)
        {
            CRID.add(r.CRID); 
            system.debug('CRID = ' + CRID);
        }
       
    	//Query for all Tasks associated to CR where created date is within the last 30 days
    	List<Task> VMTasks = new List<Task>([SELECT Id, 
                                           OwnerId,
                                           DialSource__Call_Disposition_DS__c,
                                           WhatId,
                                           ActivityDate,
                                           CreatedDate,
                                           WhoId
                                           FROM Task  
                                       	   WHERE WhatId IN :CRID AND CreatedDate >=: system.today() - 30]);
        
        System.debug('Tasks (DSContactRolePBV3): ' + VMTasks); 
    	List<Task> totalVMTasks = new List<Task>();
        List<Task> totalConvoTasks = new List<Task>();
        List<Contact_Role__c> UpdateCRs = new List<Contact_Role__c>();

        List<Contact_Role__c> CRs = new List<Contact_Role__c>([SELECT Id,
                                                               DS_VM_Count__c,
                                                               DS_Conversation_Count__c
                                                               FROM Contact_Role__c  
                                                               WHERE Id IN :CRID]); 
        
        //Iterate through each task associated with the CR, incrementing the VM Count and Convo Counts each time dispo matches criteria
        For(Contact_Role__c CR : CRs)
        {
            system.debug('CRs = ' + CR);
            //0 Out VM Count and Convo Count
            CR.DS_VM_Count__c = 0;
            CR.DS_Conversation_Count__c = 0;

            IF(!VMTasks.isEmpty())
            {
                For(Task t : VMTasks)
                {            
                    System.debug('Task call disposition (DSContactRolePBV3): ' +  t.DialSource__Call_Disposition_DS__c);
                    //Increment VM Count
                    IF(t.DialSource__Call_Disposition_DS__c != Null &&
                       t.whatID == CR.id &&
                       (t.DialSource__Call_Disposition_DS__c.contains('Voicemail') || 
                       t.DialSource__Call_Disposition_DS__c.contains('Left Message')))
                        {
                            system.debug('VM Task = ' + t);
                            totalVMTasks.add(t);
                        }
                    
                    //Increment Convo Count
                    IF(t.DialSource__Call_Disposition_DS__c != Null &&
                       t.whatID == CR.id &&
                       (!t.DialSource__Call_Disposition_DS__c.contains('Voicemail') &&
                       !t.DialSource__Call_Disposition_DS__c.contains('Left Message') &&
                       !t.DialSource__Call_Disposition_DS__c.contains('VM') &&
                       t.DialSource__Call_Disposition_DS__c != 'Next' &&
                       t.DialSource__Call_Disposition_DS__c != 'Skip Call'))
                    {
                        system.debug('Convo Tasks = ' + t);
                        totalConvoTasks.add(t);
                    }
                }
            }
            
            System.debug('Total amount of conversation dispositions (DSContactRolePBV3): ' + totalConvoTasks.size()); 
            System.debug('Total amount of voicemail dispositions (DSContactRolePBV3): ' + totalVMTasks.size());
            
            CR.DS_Conversation_Count__c = totalConvoTasks.size();
            CR.DS_VM_Count__c = totalVMTasks.size();

            //Clear out the Voicemail and Convo lists
            totalVMTasks.clear(); 
            totalConvoTasks.clear(); 

            UpdateCRs.add(CR);
        }
        
        try {
        	update UpdateCRs;
        }
        
        catch (DMLException e)
        {
            System.debug('The following error occured (DSContactRolePBV3): ' + e);
        }
    }
    
    
    global class sobjectsListRequests
    {		
        @InvocableVariable(required=True)
        public Id CRID;
    }
}