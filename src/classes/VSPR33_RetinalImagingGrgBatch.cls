global class VSPR33_RetinalImagingGrgBatch implements Database.Batchable<sObject>, Database.Stateful {
    
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static List<String> exceptionList = new List<String>();
    private static final String query = 'Select Id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where Status__c = \'Active\' ';

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Global_Rewards_Group__c> scope){

        Set<Id> grgIdSet = new Set<Id>();
        Set<Id> childAccIdSet = new Set<Id>();
        List<Global_Rewards_Group__c> grgToUpd = new List<Global_Rewards_Group__c>();
        Map<Id, Set<Id>> grgGrgrIdSet = new Map<Id, Set<Id>>();
        Map<Id, Id> grgrBusAccIdMap = new Map<Id, Id>();
        Set<Id> busAccountIds = new Set<Id>();

        for(Global_Rewards_Group__c grg: scope){
            grgIdSet.add(grg.Id);
        }

        List<Global_Rewards_Group_Relationship__c> grgrList = [Select Id, Global_Rewards_Group__c, Child_Account__c from Global_Rewards_Group_Relationship__c where Global_Rewards_Group__c in :grgIdSet and Child_Account__r.recordTypeId = :businessRecordTypeID and Status__c = 'Active'];

        for(Global_Rewards_Group_Relationship__c grgr: grgrList){
            childAccIdSet.add(grgr.Child_Account__c);
            grgrBusAccIdMap.put(grgr.Id, grgr.Child_Account__c);
            if(!grgGrgrIdSet.containsKey(grgr.Global_Rewards_Group__c)){
                grgGrgrIdSet.put(grgr.Global_Rewards_Group__c, new Set<Id>{grgr.Id});
            }else{
                Set<Id> s = grgGrgrIdSet.get(grgr.Global_Rewards_Group__c);
                s.add(grgr.Id);
                grgGrgrIdSet.put(grgr.Global_Rewards_Group__c, s);
            }
        }

        List<Account> busAccList = [Select Id from Account where Id in :childAccIdSet and recordTypeId = :businessRecordTypeID and Retinal_Imaging_Indicator__c = true and Vision_Care_Good_Standing__c = true];

        for(Account a: busAccList){
            busAccountIds.add(a.Id);
        }

        for(Global_Rewards_Group__c grg: scope){
            Boolean check = true;
            if(grgGrgrIdSet.containsKey(grg.Id)){
                for(Id i: grgGrgrIdSet.get(grg.Id)){
                    if(grgrBusAccIdMap.containsKey(i) && busAccountIds.contains(grgrBusAccIdMap.get(i))){
                        check = false;
                        if(!grg.Retinal_Imaging_Indicator_Future__c){
                            grg.Retinal_Imaging_Indicator_Future__c = true;
                            grgToUpd.add(grg);
                        }
                        break;
                    }
                }
            }
            if(check){
                if (grg.Retinal_Imaging_Indicator_Future__c) {
                    grg.Retinal_Imaging_Indicator_Future__c = false;
                    grgToUpd.add(grg);
                }
            }
        }

        if(grgToUpd.size()>0){
            Database.SaveResult[] SaveResultList = Database.update(grgToUpd, false);

            for(integer i =0; i<grgToUpd.size();i++){
                String msg='';
                if(!SaveResultList[i].isSuccess()){
                    msg += grgToUpd.get(i).id + '\n'+'Error: "';
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
                
                mail.setSubject('Retinal Imaging Checkbox GRG Evaluation Job');
                
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
            VSPR31_TierAgreementTypePracticeAccount job = new VSPR31_TierAgreementTypePracticeAccount(); 
            Database.executeBatch(job,100);
        }
    }
}