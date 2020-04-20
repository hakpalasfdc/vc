/***************************************************
Original Author: Eric Varela, Modified By: Jitesh Bhatia, Implementation Engineer, 7/10/2016

Last Updated: 7/10/2017
Updated to be Batch and Schedulable

Brief Description: Counts the number of VM dispositions and 
Conversation dispositions on the Contact Role Record within 
the last 30 days
****************************************************/
global class DSUpdateVMConvoCountV3 implements Database.Batchable<sObject>, Schedulable {
	
	String query = 'SELECT Id, DS_VM_Count__c, DS_Conversation_Count__c FROM Contact_Role__c';
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<sObject> scope) {

   		List<Contact_Role__c> contactRolesToUpdate = [SELECT Id, DS_VM_Count__c, DS_Conversation_Count__c, (SELECT Id, OwnerId, DialSource__Call_Disposition_DS__c, WhatId, ActivityDate, CreatedDate, WhoId FROM Tasks WHERE CreatedDate >=: system.today() - 30) FROM Contact_Role__c WHERE Id IN :scope FOR UPDATE];

   		Set<Id> ContactRoleIds = new Set<Id>();
   		List<Task> totalVMTasks = new List<Task>();
        List<Task> totalConvoTasks = new List<Task>();

		for (Contact_Role__c newObjScope: contactRolesToUpdate) 
		{ 
			System.debug('Contact Role: ' + newObjScope); 
            for (Task t : newObjScope.Tasks)
            {
        		System.debug('Task call disposition: ' +  t.DialSource__Call_Disposition_DS__c);
                //Increment VM Count
                if (t.DialSource__Call_Disposition_DS__c != Null &&
                   t.whatID == newObjScope.id &&
                   (t.DialSource__Call_Disposition_DS__c.contains('Voicemail') || 
                   t.DialSource__Call_Disposition_DS__c.contains('Left Message')))
                    {
                        system.debug('VM Task = ' + t);
                        totalVMTasks.add(t);
                    }
                
                //Increment Convo Count
                if (t.DialSource__Call_Disposition_DS__c != Null &&
                   t.whatID == newObjScope.id &&
                   (!t.DialSource__Call_Disposition_DS__c.contains('Voicemail') &&
                   !t.DialSource__Call_Disposition_DS__c.contains('Left Message') &&
                   !t.DialSource__Call_Disposition_DS__c.contains('VM') &&
                   t.DialSource__Call_Disposition_DS__c != 'Next'))
                {
                    system.debug('Convo Tasks = ' + t);
                    totalConvoTasks.add(t);
                }
            }

            System.debug('Total convo count: ' + totalConvoTasks.size());
            System.debug('Total VM count: ' + totalVMTasks.size());

            newObjScope.DS_Conversation_Count__c = totalConvoTasks.size();
            newObjScope.DS_VM_Count__c = totalVMTasks.size();

            //Clear out the Voicemail and Convo lists
            totalVMTasks.clear(); 
            totalConvoTasks.clear(); 
        }

        try {
        	update contactRolesToUpdate;
        }
        
        catch (DMLException ex)
        {
            System.debug('The following error occured: ' + ex);Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();String[] toAddresses = new String[] {'support@dialsource.com', 'implementation@dialsource.com'};mail.setToAddresses(toAddresses);mail.setReplyTo('support@dialsource.com');mail.setSenderDisplayName('DialSource Apex Error Message: ' + UserInfo.getOrganizationName()); mail.setSubject('DSUpdateVMConvoCountV3' + ' Line #' + ex.getLineNumber() + ' (' + UserInfo.getOrganizationName() + '\n\n Org Id: ' + UserInfo.getOrganizationId() + ')'); mail.setPlainTextBody('DSUpdateVMConvoCountV3' + '\n\nException Type Thrown: '+ ex.getTypeName() + '\n\nOn Line #' + ex.getLineNumber() + '\n\nMessage: ' + ex.getMessage() + '\n\nStack Trace: ' + ex.getStackTraceString()); Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}

	//Scheduler Method to schedule the class
    global void execute(SchedulableContext sc)
    {
        DSUpdateVMConvoCountV3 batchJob = new DSUpdateVMConvoCountV3();
        database.executebatch(batchJob, 200);
    }
}