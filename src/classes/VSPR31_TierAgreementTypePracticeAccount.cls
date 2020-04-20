//Apex class to calculate Tier Agreement Type on the Practice Account and on the Global Rewards Group.
global class VSPR31_TierAgreementTypePracticeAccount implements Database.Batchable<sObject>, Database.Stateful{ 
    
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private List<String> exceptionList = new List<String>();
    //global final String query = 'Select id, Tier_Agreement_Type__c, Status__c from Global_Rewards_Group__c';
    global final String query = 'Select id, Tier_Agreement_Type__c, Contract_Type__c from Account where recordTypeId = \'' + practiceRecordTypeID + '\'';

    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    //Below execute method update to include List of Accounts rather than List of Global Rewards Group.
    global void execute(Database.BatchableContext BC, /*List<Global_Rewards_Group__c>*/ List<Account> scope){

        Map<Id, Account> practiceMap = new Map<Id, Account>();
        Map<Id, Set<String>> pracAccountAgreement = new Map<Id, Set<String>>();

        Map<Id, String> accOldPrecedence = new Map<Id, String>(); //To maintain trace of the Practice account and not to update account records which remain same.
        List<Agreement_Type__mdt> agreementTypeList = [Select MasterLabel, Precedence__c from Agreement_Type__mdt]; //Extracting Agreement Type custom metadata type records.
        Map<String, Integer> precedenceMap = new Map<String, Integer>();
        List<Account> updateAccountList = new List<Account>();

        for(Agreement_Type__mdt at: agreementTypeList){
            if(!precedenceMap.containsKey(at.MasterLabel)){
                precedenceMap.put(at.MasterLabel, (Integer)at.Precedence__c);
            }
        }

        //Below for loop updated by Vikhyat on 08/21/2019 due to refractoring.
        for(Account a: /*practiceList*/ scope){
            
            accOldPrecedence.put(a.Id, a.Tier_Agreement_Type__c);//Added by Vikhyat on 08/06/2019
            
            if(a.Contract_Type__c != null){
                practiceMap.put(a.id, a);
                //accOldPrecedence.put(a.id, a.Tier_Agreement_Type__c);
            }else{
                a.Tier_Agreement_Type__c = null;
                updateAccountList.add(a);
            }
        }

        List<Agreement__c> agreementList = [Select id, Account__c, Type__c from Agreement__c where Account__c in :practiceMap.keySet() and Status__c = 'Active'];

        for(Agreement__c a: agreementList){
            if(practiceMap.containsKey(a.Account__c)){
                if(!pracAccountAgreement.containsKey(a.Account__c)){
                    pracAccountAgreement.put(a.Account__c, new Set<String>{a.Type__c});
                }else{
                    Set<String> s = new Set<String>(pracAccountAgreement.get(a.Account__c));
                    s.add(a.Type__c);
                    pracAccountAgreement.put(a.Account__c, s);
                }
            }
        }


        //Below part added by Vikhyat on 08/21/2019
        Map<Id, String> practiceAgreement = VSPR31_PrecedenceCalculator.calculatePracticeAgreement(practiceMap, pracAccountAgreement, precedenceMap);
        //Part added by Vikhyat ends here.

        for(Id i: practiceAgreement.keySet()){
            if(practiceMap.containsKey(i) && practiceMap.get(i).Tier_Agreement_Type__c != practiceAgreement.get(i)){
                Account a = practiceMap.get(i);
                a.Tier_Agreement_Type__c = practiceAgreement.get(i);
                updateAccountList.add(a);
            }
        }


        
        //Below part added by Vikhyat on 08/06/2019
        List<Account> finalPracAccount = new List<Account>();
        
        for(Account a: updateAccountList){
            if(accOldPrecedence.containsKey(a.Id) && accOldPrecedence.get(a.Id) != a.Tier_Agreement_Type__c){
                finalPracAccount.add(a);
            }
        }
        //Part added by Vikhyat on 08/06/2019 ends here.
        
        //Part added by Vikhyat on 08/06/2019
        if(!finalPracAccount.isEmpty()){
            Database.SaveResult[] SaveResultList = Database.update(finalPracAccount, false);

            for(integer i =0; i<finalPracAccount.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += finalPracAccount.get(i).id + '\n'+'Error: "';
                    for(Database.Error err: SaveResultList[i].getErrors()){
                        msg += err.getmessage()+'"\n\n';
                    } 
                }
                if(msg!= ''){
                    exceptionList.add(msg);
                }
            }
        }
        //Part added by Vikhyat on 09/06/2019 ends here.

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
                
                mail.setSubject('Tier Agreement Type on Practice Account Job Errors');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exceptionList.size());
                
                mail.setHtmlBody('Number of records failed = ' + exceptionList.size() + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
        }

        //Need to be updated later
        
        /*if(!Test.isRunningTest()){
            VSPR31_Grg_Tier_Update_Batch obj = new VSPR31_Grg_Tier_Update_Batch();
            Database.executeBatch(obj, 200);
        }*/

        //below part added by Vikhyat on 08/21/2019
        VSPR31_TierAgreementTypeGRG job = new VSPR31_TierAgreementTypeGRG();
        Database.executeBatch(job);
        //part added by Vikhyat on 08/21/2019 ends here

    }

}