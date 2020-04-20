global class vspr33_tierBenefitOutboundBatch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static String query = 'Select Id, Benefit__c, Premier_Tier__c, Send_Outbound_Message__c from Tier_Benefit__c where Send_Outbound_Message__c = false';
    private static List<String> exceptionList = new List<String>();

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Tier_Benefit__c> scope) {

        List<Tier_Benefit__c> tierBenefitToUpdate = VSPR33_outboundCheckoxCalculator.premierTier(scope);

        if (!tierBenefitToUpdate.isEmpty()) {
            Database.SaveResult[] SaveResultList = Database.update(tierBenefitToUpdate, false);

            for(integer i =0; i<tierBenefitToUpdate.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += tierBenefitToUpdate.get(i).id + '\n'+'Error: "';
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
                
                mail.setSubject('Tier Benefit Send_Outbound_Message checkbox Batch Job Errors');
                
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

        if(!Test.isRunningTest()){
            VSPR32_Override_Bus_Acc_Tier_Grg_Batch batch = new VSPR32_Override_Bus_Acc_Tier_Grg_Batch();
            database.executeBatch(batch,50);
        }
    }
}