global class BusContractTypeOneTimeCalBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Date todayDate = System.today();
    private static List<String> exceptionList = new List<String>();
    private static final String query = 'Select Id, Non_VC_Exception__c,	Parent_Company__c, Vision_Care_Good_Standing__c, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, Location_Type__c, Provider_Category__c, Vision_Care_Location_Exception__c, ParentId, recordTypeId from Account where recordTypeId = \'' + businessRecordTypeID + '\' and ParentId != null and Vision_Care_Effective_Date__c != null';
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope){

        List<Account> busAccToUpdate = new List<Account>();
        Set<Id> pracIdSet = new Set<Id>();
        Map<Id, String> practiceExceptionMap = new Map<Id, String>();
        
        for(Account a: scope){
            pracIdSet.add(a.ParentId);
        }

        List<Account> practAccountList = [Select id, Vision_Care_Practice_Exception__c from Account where recordTypeID = :practiceRecordTypeID and id in :pracIdSet and Vision_Care_Good_Standing__c = true];

        for(Account a: practAccountList){
            practiceExceptionMap.put(a.Id, a.Vision_Care_Practice_Exception__c);
        }

        for(Account a: scope){
            if (!a.Vision_Care_Good_Standing__c) {
                a.Contract_Type__c = null;
            }
            else if(practiceExceptionMap.containsKey(a.ParentId)){
                VSPR31_BusAccContractTypeCalculation cal = new VSPR31_BusAccContractTypeCalculation();
                cal.calculator(a, practiceExceptionMap.get(a.Id));
            }else {
                a.Contract_Type__c = null;
            }
            busAccToUpdate.add(a);
        }

        if(busAccToUpdate.size()>0){
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
                
                mail.setSubject('Business Account Contract Type One Time Calculation Batch');
                
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