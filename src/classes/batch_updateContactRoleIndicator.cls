global class batch_updateContactRoleIndicator implements Database.Batchable<sObject>, Database.Stateful{
    
    global final String gstrQuery = 'SELECT Id, Active_or_Future_Vision_Care_Relationshi__c FROM Contact_Role__c';
    global List<String> exception_List = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(gstrQuery);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact_Role__c> scope){
        
        Set<Id> crIds = new Set<Id>();
        for(Contact_Role__c s :scope){
            crIds.add(s.Id);            
        }
        
        if(!crIds.isEmpty()){
            
            List<Contact_Role__c> updCRrecs = new List<Contact_Role__c>();
            List<Contact_Role__c> allCR = [SELECT Id, Active_or_Future_Vision_Care_Relationshi__c FROM Contact_Role__c WHERE Id IN :crIds];
            
            AggregateResult[] netRelCount = [SELECT Contact_Role__c, Count(Id) Total FROM Network_Relationship__c WHERE Contact_Role__c IN :crIds
                                             AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY) GROUP BY Contact_Role__c];
            
            
            for(Contact_Role__c updCR :allCR){
                updCR.Active_or_Future_Vision_Care_Relationshi__c = false;
                
                for(AggregateResult ar :netRelCount){
                    if(ar.get('Contact_Role__c') == updCR.Id && (decimal)ar.get('Total') > 0){
                        updCR.Active_or_Future_Vision_Care_Relationshi__c = true;
                    }   
                }
                updCRrecs.add(updCR);                
            }
            
            if(!updCRrecs.isEmpty()){
                Database.SaveResult[] SaveResultList = Database.update(updCRrecs,false); 
                
                for(integer i =0; i<updCRrecs.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        msg += updCRrecs.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
        }
        system.debug(exception_List);
    }
    
    global void finish(Database.BatchableContext BC){
        
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
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
                
                mail.setSubject('Contact Role Batch Job Errors');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List.size() + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }
        
    }
    
}