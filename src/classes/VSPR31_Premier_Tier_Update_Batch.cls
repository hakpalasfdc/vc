global class VSPR31_Premier_Tier_Update_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    global final String query = 'SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c WHERE IsDeleted = false';
    global List<String> exception_List_Tier_Upd = new List<String>();
    global List<String> exceptionList = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Premier_Tier__c> scope){

        Map<Id, Premier_Tier__c> Tiers = new Map<Id, Premier_Tier__c>();

        for(Premier_Tier__c s: scope){
            Tiers.put(s.Id, s.clone(true, true, false, false));
        }
        
        if(Tiers.size() > 0){
            List<Premier_Tier__c> TierToUpdate = new List<Premier_Tier__c>();
            
            for(Premier_Tier__c tr: scope){
                if(tr.Effective_Date__c > Date.today()){
                    tr.Status__c = 'Future';                    
                }
                else if(tr.Effective_Date__c <= Date.today() && (tr.End_Date__c >= Date.today() || tr.End_Date__c == NULL)){
                    tr.Status__c = 'Active';
                }
                else{
                    tr.Status__c = 'Inactive';
                }
                //Added this so that only status of tiers which are actually updated get added to the list to be updated.
                if(tr.Status__c != Tiers.get(tr.Id).Status__c){
                    TierToUpdate.add(tr);
                }
            }
            
            if(!TierToUpdate.isEmpty()){
                // update TierToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(TierToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Premier Tier Record Id: ' + TierToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"<br/>';
                        } 
                    }
                    if(msg!= '')
                        exception_List_Tier_Upd.add(msg);
                } 
            }
        }
        
    }
    
    global void finish(Database.BatchableContext BC){

        //Added Test.isRunningTest() to allow to run the part when test is running        
        if(!exception_List_Tier_Upd.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
            
            for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                toAddresses.add(obj.Name);
            }
 
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Tier Status Update Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List_Tier_Upd.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List_Tier_Upd.size() + '<br><br>' + exception_List_Tier_Upd + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
        
        //Below part commented out by Vikhyat on 10/07/2019
        /*String[] toAddresses1 = new String[]{};
            
        for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
            toAddresses1.add(obj.Name);
        }
        
        if(!toAddresses1.isEmpty()){
            Messaging.reserveSingleEmailCapacity(2);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            mail.setToAddresses(toAddresses1);
                
            mail.setSenderDisplayName('Salesforce Support');
                
            mail.setSubject('Daily batch job: Successful ');
                
            mail.setBccSender(false);
                
            mail.setUseSignature(false);
                
            // Specify the text content of the email.
            mail.setPlainTextBody('Sucessful run of Premier Admin Tool Daily Batch Jobs.');
                
            mail.setHtmlBody('Sucessful run of Premier Admin Tool Daily Batch Jobs.<br><br>');
                
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }*/
        //commented out part by vikhyat on 10/07/2019 ends here.

        if(!Test.isRunningTest()){
            vspr33_tierBenefitOutboundBatch batch = new vspr33_tierBenefitOutboundBatch();
            database.executeBatch(batch,50);
        }
    }
}