global class VSPR31_PracticeContractTypeBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    global final String query = 'Select id, Contract_Type__c, Vision_Care_Good_Standing__c, Premier_Tax_ID_Roll_Up_Account__c from Account where recordTypeId = \'' + practiceRecordTypeID + '\''; 
	private List<String> exceptionList = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope) {

    	Set<Id> accountIds = new Set<Id>();
    	List<Account> practiceList = new List<Account>();
    	List<Account> accountList = new List<Account>();
    	Map<Id, Set<String>> mapper = new Map<Id, Set<String>>();

    	for(Account a: scope){
    		if(a.Premier_Tax_ID_Roll_Up_Account__c == true && a.Vision_Care_Good_Standing__c == true){
    			a.Contract_Type__c = 'Rollup';
    			practiceList.add(a);
    		}else if(a.Vision_Care_Good_Standing__c == true){
    			accountIds.add(a.id);
    			accountList.add(a);
    		}else{
    			a.Contract_Type__c = null;
    			practiceList.add(a);
    		}
    	}

    	List<Account> businessList = [Select id, ParentId, Contract_Type__c from Account where ParentId in :accountIds and recordTypeId = :businessRecordTypeID and Vision_Care_Good_Standing__c = true];

    	for(Account a: businessList){
    		if(accountIds.contains(a.ParentId)){
    			if(!mapper.containsKey(a.ParentId)){
    				if(a.Contract_Type__c != null){
    					mapper.put(a.ParentId, new Set<String>{a.Contract_Type__c});
    				}
    			}else{
    				if(a.Contract_Type__c != null){
    					Set<String> sSet = new Set<String>(mapper.get(a.ParentId));
    					sSet.add(a.Contract_Type__c);
    					mapper.put(a.ParentId, sSet);
    				}
    			}
    		}
    	}

    	for(Account a: accountList){
    		if(accountIds.contains(a.id)){
    			if(mapper.containsKey(a.id)){
    				if(mapper.get(a.id).size() > 1){
    					a.Contract_Type__c = 'Conflict';
    				}else if(mapper.get(a.id).size() == 1){
    					a.Contract_Type__c = (new List<String>(mapper.get(a.id)))[0];
    				}else{
    					a.Contract_Type__c = null;
    				}
    			}else{
    				a.Contract_Type__c = null;
    			}
    		}else{
    			a.Contract_Type__c = null;
    		}
    		practiceList.add(a);
    	}


    	//update practiceList;
		if(!practiceList.isEmpty()){
            Database.SaveResult[] SaveResultList = Database.update(practiceList, false);

            for(integer i =0; i<practiceList.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += practiceList.get(i).id + '\n'+'Error: "';
                    for(Database.Error err: SaveResultList[i].getErrors()){
                        msg += err.getmessage()+'"\n\n';
                    } 
                }
                if(msg!= ''){
                    exceptionList.add(msg);
                }
            }
        }
    
    }
    
    global void finish(Database.BatchableContext BC) {
        if(!exceptionList.isEmpty() || Test.isRunningTest()){
            List<Exception_handler_Email__c> toEmailLst = Exception_handler_Email__c.getall().values();
            
            if(!toEmailLst.isEmpty()){
                String[] toAddresses = new String[]{};
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
                
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Contract Type on Practice Account Batch Job Errors');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exceptionList.size());
                
                mail.setHtmlBody('Number of records failed = ' + exceptionList.size() + '<br><br>' + exceptionList + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }

        //Below part updated by Vikhyat on 11/07/2019 to stop the call for the batch class using Effective Date and End Date.
		//Done as part of SFDC-11988
		/*if(!Test.isRunningTest()){
            VSPR32_Premier_Benefit_Status_Upd_Batch job = new VSPR32_Premier_Benefit_Status_Upd_Batch();
            Id jobId = Database.executeBatch(job,200);
        }*/
		//Commented part by Vikhyat ends here.

		//Below part added by Vikhyat on 11/07/2019 as part of SFDC-11988
		String[] toAddresses1 = new String[]{};
            
        for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
            toAddresses1.add(obj.Name);
        }
        
        if(!toAddresses1.isEmpty()){
            Messaging.reserveSingleEmailCapacity(2);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            mail.setToAddresses(toAddresses1);
                
            mail.setSenderDisplayName('Salesforce Support');
                
            mail.setSubject('Daily batch job Part 1: Successful ');
                
            mail.setBccSender(false);
                
            mail.setUseSignature(false);
                
            // Specify the text content of the email.
            mail.setPlainTextBody('Sucessful run of Premier Admin Tool Daily Part 1 Batch Jobs.');
                
            mail.setHtmlBody('Sucessful run of Premier Admin Tool Daily Part 1 Batch Jobs.<br><br>');
                
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
		//New part added on 11/07/2019 Ends here.
    }
    
}