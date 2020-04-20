//Batch job to populate VC__c one time in SIT and Production.
//Created by Vikhyat as part of SFDC-12238
global class vsCalculatorOneTimeBatch implements Database.Batchable<sObject>, Database.Stateful {
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    //private static Id accountRecordTypeId;
    //private static final String query = 'Select Id, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, VC__c from Account where ( recordTypeId = \'' + businessRecordTypeID + '\' or recordTypeId = \'' + practiceRecordTypeID + '\' ) and Vision_Care_Effective_Date__c != null' ;
    private String query; /*= 'Select Id, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, VC__c from Account where recordTypeId = \''+ practiceRecordTypeID + '\' and Vision_Care_Effective_Date__c != null' ;*/
    private static final Date todayDate = System.today();
    private static List<String> exceptionList = new List<String>();

    global vsCalculatorOneTimeBatch(Integer i){
       //accountRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get(record).getRecordTypeId();
        if(i == 1){
            query = 'Select Id, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, VC__c from Account where recordTypeId = \''+ practiceRecordTypeID + '\' and Vision_Care_Effective_Date__c != null' ;
        }else{
            query = 'Select Id, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, VC__c from Account where recordTypeId = \''+ businessRecordTypeID + '\' and Vision_Care_Effective_Date__c != null' ;
        }
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
        //return Database.getQueryLocator('Select Id, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, VC__c from Account where recordTypeId = \''+ accountRecordTypeId + '\' and Vision_Care_Effective_Date__c != null');
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){

        List<Account> busAccToUpdate = new List<Account>();

        for(Account a: scope){

             if(a.Vision_Care_Effective_Date__c <= todayDate && (a.Vision_Care_End_Date__c == null || a.Vision_Care_End_Date__c >= todayDate)){
                if(!a.VC__c){
                    a.VC__c = true;
                    busAccToUpdate.add(a);
                }
            }else{
                if (a.VC__c) {
                    a.VC__c = false;
                    busAccToUpdate.add(a);
                }
            }
        }

        if(!busAccToUpdate.isEmpty()){
            Database.SaveResult[] SaveResultList = Database.update(busAccToUpdate, false);

            for(integer i =0; i<busAccToUpdate.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += busAccToUpdate.get(i).id + '\n'+'Error: "';
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

    global void finish(Database.BatchableContext BC){
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
                
                mail.setSubject('VC__c checkbox Batch Job Errors');
                
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

    }
}