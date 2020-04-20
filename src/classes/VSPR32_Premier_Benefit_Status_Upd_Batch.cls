global class VSPR32_Premier_Benefit_Status_Upd_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private final Date today = System.today();
    global final String Query = 'SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Benefit__c where Effective_Date__c <= TODAY and Status__c != \'Inactive\''; /*WHERE Effective_Date__c = '+ sDate1;*/
    global List<String> exception_List = new List<String>();
    
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        System.debug(Query);
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<Premier_Benefit__c> scope){
         
        //Set<Id> BenefitStatusUpdate = new Set<Id>();            
        Map<Id,Premier_Benefit__c> BenefitStatusUpdateMap = new Map<Id,Premier_Benefit__c>();
        Map<Id, String> benefitStatusMap = new Map<Id, String>();
        
        for(Premier_Benefit__c s : scope){      
            //BenefitStatusUpdate.add(s.Id);
            BenefitStatusUpdateMap.put(s.Id, s);
            benefitStatusMap.put(s.Id, s.Status__c);
        }
        
        if(!BenefitStatusUpdateMap.isEmpty()){
            
            List<Premier_Benefit__c> pBenLsttoUpd = new List<Premier_Benefit__c>();
            
            for(Id pBenId :BenefitStatusUpdateMap.keySet()){
                Premier_Benefit__c benRec = BenefitStatusUpdateMap.get(pBenId);
                /*if(benRec.Effective_Date__c > Date.today()){
                    benRec.Status__c = 'Future';
                }
                else */if(benRec.Effective_Date__c <= /*Date.today()*/ today && (benRec.End_Date__c >= /*Date.today()*/ today || benRec.End_Date__c == NULL)){
                    benRec.Status__c = 'Active';
                }
                else{
                    benRec.Status__c = 'Inactive';
                }
                //pBenLsttoUpd.add(benRec);
                if(benRec.Status__c != benefitStatusMap.get(benRec.Id)){
                    pBenLsttoUpd.add(benRec);
                }
            }
            
            system.debug('pBenLsttoUpd List '+ pBenLsttoUpd);
            if(!pBenLsttoUpd.isEmpty()){
                //  update pBenLsttoUpd;
                
                Database.SaveResult[] SaveResultList = Database.update(pBenLsttoUpd,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Premier Benefit Record Id: ' + pBenLsttoUpd.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            if(!toAddresses.isEmpty()){
                if(!Test.isRunningTest()){
                    Messaging.reserveSingleEmailCapacity(2);
                }
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Benefit Status Update Job Failed - Benefit Status Update Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List.size() + '<br><br>' + exception_List + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
         if(!Test.isRunningTest()){
            VSPR31_Premier_Tier_Update_Batch job = new VSPR31_Premier_Tier_Update_Batch();
            Id jobId = Database.executeBatch(job,200);
        }
    }
}