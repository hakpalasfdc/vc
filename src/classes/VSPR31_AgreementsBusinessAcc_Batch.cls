global class VSPR31_AgreementsBusinessAcc_Batch implements Database.Batchable<sObject>, Database.Stateful {

	private final String query = 'Select id, Account__c, Effective_Date__c, End_Date__c, Type__c from Agreement__c where Status__c = \'Active\'';
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    //private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private List<String> exceptionList = new List<String>();

	global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Agreement__c> scope){

        Map<Id, Set<Id>> pracAgIdMap = new Map<Id, Set<Id>>();
        Map<Id, Agreement__c> agMap = new Map<Id, Agreement__c>();
        Map<Id, Integer> noEndDateMap = new Map<Id, Integer>();
        Map<Id, Integer> withEndDateMap = new Map<Id, Integer>();
        Map<Id, Set<Id>> pracBusAccMap = new Map<Id, Set<Id>>(); //Map of Practice A/C IDs and associated business A/C IDs.
        Map<Id, Account> busAccMap = new Map<Id, Account>(); //Map of Business Accounts.
        //Map<Integer, Set<Id>> noEndDateMapCal = new Map<Integer, Set<Id>>();
        //Map<Integer, Set<Id>> withEndDateMapCal = new Map<Integer, Set<Id>>();
        Map<Id,String> pracAccAgMap = new Map<Id, String>();
        List<Account> busAccListUpdate = new List<Account>(); //List of business Accounts to be updated.

        for(Agreement__c a: scope){
            if(!agMap.containsKey(a.Id)){
                agMap.put(a.Id, a);
            }

            if(!pracAgIdMap.containsKey(a.Account__c)){
                pracAgIdMap.put(a.Account__c, new Set<Id>{a.Id});
            }else{
                Set<Id> s = new Set<Id>(pracAgIdMap.get(a.Account__c));
                s.add(a.Id);
                pracAgIdMap.put(a.Account__c, s);
            }
        }

        for(Id i: agMap.keySet()){
            if(agMap.containsKey(i)){
                if(agMap.get(i).End_Date__c != null){
                    withEndDateMap.put(i, agMap.get(i).Effective_Date__c.daysBetween(agMap.get(i).End_Date__c));
                }else{
                    noEndDateMap.put(i, agMap.get(i).Effective_Date__c.daysBetween(System.today()));
                }
            }
        }

        List<Account> busAccList = [Select id, ParentId, Agreement_Type__c from Account where recordTypeId = :businessRecordTypeID and ParentId in :pracAgIdMap.keySet()];

        for(Account a: busAccList){
            if(!pracBusAccMap.containsKey(a.ParentId)){
                pracBusAccMap.put(a.ParentId, new Set<Id>{a.Id});
            }else{
                Set<Id> s = new Set<Id>(pracBusAccMap.get(a.ParentId));
                s.add(a.Id);
                pracBusAccMap.put(a.ParentId, s);
            }
            busAccMap.put(a.Id, a);
        }

        for(Id i: pracAgIdMap.keySet()){
            String agType = ';';
            Map<Integer, Set<Id>> noEndDateMapCal = new Map<Integer, Set<Id>>();
            Map<Integer, Set<Id>> withEndDateMapCal = new Map<Integer, Set<Id>>();
            for(Id agId: pracAgIdMap.get(i)){
                if(agMap.containsKey(agId)){
                    if(agMap.get(agId).End_Date__c != null){
                        if(!withEndDateMapCal.containsKey(withEndDateMap.get(agId))){
                            withEndDateMapCal.put(withEndDateMap.get(agId), new Set<Id>{agId});
                        }else{
                            Set<Id> s = new Set<Id>(withEndDateMapCal.get(withEndDateMap.get(agId)));
                            s.add(agId);
                            withEndDateMapCal.put(withEndDateMap.get(agId), s);
                        }
                    }else{
                        if(!noEndDateMapCal.containsKey(noEndDateMap.get(agId))){
                            noEndDateMapCal.put(noEndDateMap.get(agId), new Set<Id>{agId});
                        }else{
                            Set<Id> s = new Set<Id>(noEndDateMapCal.get(noEndDateMap.get(agId)));
                            s.add(agId);
                            noEndDateMapCal.put(noEndDateMap.get(agId), s);
                        }
                    }
                }
            }
            List<Integer> noEndDateList = sorted(new List<Integer>(noEndDateMapCal.keySet()));
            List<Integer> withEndDateList = sorted(new List<Integer>(withEndDateMapCal.keySet()));

            for(Integer diff=noEndDateList.size()-1;diff>=0;diff--){
                if(noEndDateMapCal.containsKey(noEndDateList.get(diff))){
                    for(Id aId: noEndDateMapCal.get(noEndDateList.get(diff))){
                        if(agMap.containsKey(aId)){
                            agType = stringMaker(agType, agMap.get(aId).Type__c);
                        }
                    }
                }
            }

            for(Integer diff=withEndDateList.size()-1;diff>=0;diff--){
                if(withEndDateMapCal.containsKey(withEndDateList.get(diff))){
                    for(Id aId: withEndDateMapCal.get(withEndDateList.get(diff))){
                        if(agMap.containsKey(aId)){
                            agType = stringMaker(agType, agMap.get(aId).Type__c);
                        }
                    }
                }
            }

            pracAccAgMap.put(i, agType.removeStart(';'));

        }

        for(Id i: pracAccAgMap.keySet()){
            if(pracBusAccMap.containsKey(i)){
                for(Id bId: pracBusAccMap.get(i)){
                    if(busAccMap.containsKey(bId)){
                        if(busAccMap.get(bId).Agreement_Type__c != pracAccAgMap.get(i)){
                            Account a = busAccMap.get(bId);
                            a.Agreement_Type__c = pracAccAgMap.get(i);
                            busAccListUpdate.add(a);
                        }
                    }
                }
            }
        }

        if(!busAccListUpdate.isEmpty()){
            Database.SaveResult[] SaveResultList = Database.update(busAccListUpdate, false);

            for(integer i =0; i<busAccListUpdate.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += busAccListUpdate.get(i).id + '\n'+'Error: "';
                    for(Database.Error err: SaveResultList[i].getErrors()){
                        msg += err.getmessage()+'"\n\n';
                    } 
                }
                if(msg!= ''){
                    exceptionList.add(msg);
                }
            }
        }

        /*for(Id i: noEndDateMap.keySet()){
            if(!noEndDateMapCal.containsKey(noEndDateMap.get(i))){
                noEndDateMapCal.put(noEndDateMap.get(i), new Set<ID>{i});
            }else{
                Set<Id> s = new Set<Id>(noEndDateMapCal.get(noEndDateMap.get(i)));
                s.add(i);
                noEndDateMapCal.put(noEndDateMap.get(i), s);
            }
        }

        for(Id i: withEndDateMap.keySet()){
            if(!withEndDateMapCal.containsKey(withEndDateMap.get(i))){
                withEndDateMapCal.put(withEndDateMap.get(i), new Set<Id>{i});
            }else{
                Set<Id> s = new Set<Id>(withEndDateMapCal.get(withEndDateMap.get(i)));
                s.add(i);
                withEndDateMapCal.put(withEndDateMap.get(i), s);
            }
        }*/

        

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
                
                mail.setSubject('Agreement on Business Account Batch Job Errors');
                
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
            VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();
            Id jobId = Database.executeBatch(job);
        }
    }

    private static List<Integer> sorted(List<Integer> l){

        if(l.size() == 1 || l.size() == 0){
            return l;
        }else{
            for(Integer i=0;i<l.size()-1;i++){
                Boolean swapped = false;
                for(Integer j=0;j<l.size()-i-1;j++){
                    if(l.get(j)>l.get(j+1)){
                        Integer temp = l.get(j);
                        l[j] = l.get(j+1);
                        l[j+1] = temp; 
                        swapped = true;
                    }
                }
                if(swapped == false){
                    break;
                }
            }
        }

        return l;
    }


    private static String stringMaker(String agType, String ag){
        if(agType.lastIndexOf(ag) == -1){
            if(agType == ';'){
                agType = agType + ag;
            }else{
                agType = agType + '; ' + ag;
            }
        }
        return agType;
    }

}