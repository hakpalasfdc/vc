//Apex batch class to implement IOF Uncut Pilot Program to Business Accounts

global class VSPR31_UncutPilotProgramBatch implements Database.Batchable<sObject>, Database.Stateful {
	
	private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	private static Id accountGroupsRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Groups').getRecordTypeId();
	global final String query = 'Select id, IOF_Uncut_Pilot_Program__c from Account where recordTypeId = \'' + businessRecordTypeID + '\' and IOF_Uncut_Pilot_Program__c != \'Exception\'';
	private final String s = 'Vision Trends';
	
	global Database.QueryLocator start(Database.BatchableContext BC) {
		return Database.getQueryLocator(query);
	}

   	global void execute(Database.BatchableContext BC, List<Account> scope) {

   		Set<Id> accountIds = new Set<Id>();
   		//Account acc = [Select id from Account where Name = 'Vision Trends' and recordTypeId = :accountGroupsRecordTypeID];
   		Salesforce_ID__mdt acc = [Select MasterLabel, ID__c from Salesforce_ID__mdt where MasterLabel = :s];
   		List<Account_Group__c> accRelationshipList = new List<Account_Group__c>();
   		Set<Id> idSet = new Set<Id>();
   		List<Account> accList = new List<Account>();
		Map<Id, String> accMap = new Map<Id, String>();

   		for(Account a: scope){
   			//accountIds.add(a.id);
			accMap.put(a.Id, a.IOF_Uncut_Pilot_Program__c);
   		}

   		//accRelationshipList = [Select id, Account__c from Account_Group__c where Account__c in :accountIds and Account_Group__c = :acc.id and End_Date__c = null and Optics_Primary__c = true];
		
		//The below was the original query   
   		//accRelationshipList = [Select id, Account__c from Account_Group__c where Account__c in :accountIds and Account_Group__c = :(Id)acc.ID__c and End_Date__c = null and Optics_Primary__c = true];

		//Querying it this way because the job will run at the end of the date. This way we will run the uncut part for A/C relationships having start date as tomorrow and end date of today. 
		//This will also cover for scenarios where end date might be yesterday or the relation got activated today, but the record failed to update.
		accRelationshipList = [Select id, Account__c, Status__c, End_Date__c, Start_Date__c from Account_Group__c where Account__c in :/*accountIds*/ accMap.keySet() and Account_Group__c = :(Id)acc.ID__c and (Status__c = 'Active' or Start_Date__c = TOMORROW) and Optics_Primary__c = true];

   		/*for(Account_Group__c a: accRelationshipList){
   			if(accountIds.contains(a.Account__c)){
   				if(!idSet.contains(a.Account__c)){
   					idSet.add(a.Account__c);
   				}
   			}
   		}*/

		
		//Updated logic statement.
		for(Account_Group__c a: accRelationshipList){
   			if(accMap.containsKey(a.Account__c)){
				if(a.End_Date__c != System.today()){
					idSet.add(a.Account__c);
				}
   			}
   		}

   		for(Account a: scope){
   			if(idSet.contains(a.id)){
   				a.IOF_Uncut_Pilot_Program__c = 'Yes';
   			}else{
   				a.IOF_Uncut_Pilot_Program__c = 'No';
   			}
   			//accList.add(a);
			if(a.IOF_Uncut_Pilot_Program__c != accMap.get(a.Id)){
				accList.add(a);
			}
   		}

   		update accList;
	
	}
	
	global void finish(Database.BatchableContext BC) {
		
	}
	
}