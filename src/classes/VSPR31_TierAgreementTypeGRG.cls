global class VSPR31_TierAgreementTypeGRG implements Database.Batchable<sObject>, Database.Stateful{
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private List<String> exceptionList = new List<String>();
    global final String query = 'Select id, Tier_Agreement_Type__c, Status__c from Global_Rewards_Group__c';
    //The above query contains fields which need to come from Dustin when the AgreementTypeCalculation runs GRG.
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Global_Rewards_Group__c> scope){
    //public static List<Global_Rewards_Group__c> AgreementTypeCalculation(List<Global_Rewards_Group__c> scope) {
        Map<Id, String> oldGRG = new Map<Id, String>(); //To maintain trace and not update the records which remain same.
        //I guess history doest need to be maintained as it is a method and it should be handled at Dustin's batch job level atleast for GRG records.

        List<Global_Rewards_Group__c> grgList = new List<Global_Rewards_Group__c>(scope);

        List<Agreement_Type__mdt> agreementTypeList = [Select MasterLabel, Precedence__c from Agreement_Type__mdt]; //Extracting Agreement Type custom metadata type records.
        Map<String, Integer> precedenceMap = new Map<String, Integer>();
        
        Map<Id, Global_Rewards_Group__c> grgMap = new Map<Id, Global_Rewards_Group__c>();
        Map<Id, String> grgAgreement = new Map<Id, String>();
        Set<Id> grgId = new Set<Id>();

        for(Agreement_Type__mdt at: agreementTypeList){
            if(!precedenceMap.containsKey(at.MasterLabel)){
                precedenceMap.put(at.MasterLabel, (Integer)at.Precedence__c);
            }
        }


        for(Global_Rewards_Group__c grg: grgList){
            
            //Check for removal of history tracking for GRG
            /*if(!oldGRG.containsKey(grg.Id)){
                oldGRG.put(grg.Id, grg.Tier_Agreement_Type__c);
            }*/
            //The above part needs to be checked.
            
            //Added by Vikhyat on 08/06/2019
            oldGRG.put(grg.Id, grg.Tier_Agreement_Type__c);
            //Part added by Vikhyat on 06/08/2019 ends here.

            grgMap.put(grg.Id, grg);

            if(/*!grgMap.containsKey(grg.Id) && */ grg.Status__c == 'Active'){
                grgId.add(grg.Id);
                //grgMap.put(grg.Id, grg);
            }else {
                grgAgreement.put(grg.Id, null);
            }
        }

        //below query updated by Vikhyat on 08/22/2019
        //List<Global_Rewards_Group_Relationship__c> grgrList = [Select id, Child_Account__c, Global_Rewards_Group__c from Global_Rewards_Group_Relationship__c where Global_Rewards_Group__c in :grgId and Status__c = 'Active'];
        //part commented out by Vikhyat ends here

        //below query added by Vikhyat on 08/22/2019
        Map<ID, Global_Rewards_Group_Relationship__c> grgrList = new Map<Id, Global_Rewards_Group_Relationship__c>([Select id, Child_Account__c, Global_Rewards_Group__c from Global_Rewards_Group_Relationship__c where Global_Rewards_Group__c in :grgId and Status__c = 'Active']);
        //part added by vikhyat on 08/22/2019 ends here

        //check for the active condition when active changed to false and what happens then. Also do I need to update if there is an existing grg and change it to null.

        Map<Id, Set<Id>> grgGrgrMap = new Map<Id, Set<Id>>();
        Map<Id, Id> grgrBusAccMap = new Map<Id, Id>();
        Map<Id, Set<Id>> busAccGrgrMap = new Map<Id, Set<Id>>();
        //Map<Id, Set<Id>> pracBusAccMap = new Map<Id, Set<Id>>();
        Set<Id> pracIdSet = new Set<Id>();
        Set<Id> grgrAccId = new Set<Id>();

        //Below for loop updated to now now run against map values of grgrList
        for(Global_Rewards_Group_Relationship__c grgr: /*grgrList*/ grgrList.values()){
            if(!grgGrgrMap.containsKey(grgr.Global_Rewards_Group__c)){
                grgGrgrMap.put(grgr.Global_Rewards_Group__c, new Set<Id>{grgr.Id});
            }else{
                Set<Id> s = new Set<Id>(grgGrgrMap.get(grgr.Global_Rewards_Group__c));
                s.add(grgr.Id);
                grgGrgrMap.put(grgr.Global_Rewards_Group__c, s);
            }

            //below part commented out by Vikhyat on 08/22/2019
            /*if(!grgrBusAccMap.containsKey(grgr.Id)){
                grgrBusAccMap.put(grgr.Id, grgr.Child_Account__c);
            }*/
            //part commented out by Vikhyat on 08/22/2019 ends here.

            grgrAccId.add(grgr.Child_Account__c);

            /*if(!busAccGrgrMap.containsKey(grgr.Child_Account__c)){
                busAccGrgrMap.put(grgr.Child_Account__c, new Set<Id>{grgr.Id});
            }else{
                Set<Id> s = new Set<Id>(busAccGrgrMap.get(grgr.Child_Account__c));
                s.add(grgr.id);
                busAccGrgrMap.put(grgr.Child_Account__c, s);
            }*/

        }


        //below part commented out by Vikhyat on 08/22/2019
        //List<Account> businessAccounts = [Select id, ParentId from Account where recordTypeId = :businessRecordTypeID and Id in :grgrAccId /*busAccGrgrMap.keySet()*/ and Contract_Type__c != null];
        //part commented out by Vikhyat on 08/22/2019 ends here.

        //below query added by Vikhyat on 08/22/2019
        Map<Id, Account> businessMap = new Map<Id, Account>([Select id, ParentId from Account where recordTypeId = :businessRecordTypeID and Id in :grgrAccId /*busAccGrgrMap.keySet()*/ and Contract_Type__c != null]);
        //part added by Vikhyat on 08/22/2019 ends here.

        //check for contract type condition is not NULL.

        //below part commented out by vikhyat on 08/22/2019
        //Map<Id, Account> businessMap = new Map<Id, Account>();
        //part commented out by vikhyat on 08/22/2019 ends here.

        //beklow for loop updated by Vikhyat on 08/22/2019 to run against map values of business accounts
        for(Account a: /*businessAccounts*/ businessMap.values()){
            pracIdSet.add(a.ParentId);

            //below part commented out by vikhyat on 08/22/2019
            /*if(!businessMap.containsKey(a.Id)){
                businessMap.put(a.Id, a);
            }*/
            //part commented out by vikhyat on 08/22/2019 ends here.
        }

        List<Id> pracIdList = new List<Id>(pracIdSet);

        //below part added by Vikhyat on 08/21/2019

        /*List<Account> practiceList*/ //updateAccountMap = [Select id, Tier_Agreement_Type__c, Contract_Type__c from Account where recordTypeId = :practiceRecordTypeID and id in :pracIdList];
        Map<Id, Account> updateAccountMap = new Map<Id, Account>([Select id, Tier_Agreement_Type__c, Contract_Type__c from Account where recordTypeId = :practiceRecordTypeID and id in :pracIdList]);
        //part added by Vikhyat on 08/21/2019 ends here.

        for(Id gId: grgId /*Global_Rewards_Group__c grg: grgMap.values()*/ ){
            Set<String> s = new Set<String>();
            if(grgGrgrMap.containsKey(gId)){
                for(Id i: grgGrgrMap.get(gId)){
                    //below part commented out by Vikhyat on 08/22/2019
                    /*if(grgrBusAccMap.containsKey(i) && businessMap.containsKey(grgrBusAccMap.get(i))){
                        if(pracIdList.contains(businessMap.get(grgrBusAccMap.get(i)).ParentId)){
                            if(updateAccountMap.containsKey(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrBusAccMap.get(i)).ParentId))) && 
                                updateAccountMap.get(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrBusAccMap.get(i)).ParentId))).Tier_Agreement_Type__c != null){
                                s.add(updateAccountMap.get(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrBusAccMap.get(i)).ParentId))).Tier_Agreement_Type__c);
                            }
                        }
                    }*/
                    //part commented out by Vikhyat on 08/22/2019 ends here.

                    if(grgrList.containsKey(i) && businessMap.containsKey(grgrList.get(i).Child_Account__c)){
                        if(pracIdList.contains(businessMap.get(grgrList.get(i).Child_Account__c).ParentId)){
                            if(updateAccountMap.containsKey(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrList.get(i).Child_Account__c).ParentId))) && 
                                updateAccountMap.get(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrList.get(i).Child_Account__c).ParentId))).Tier_Agreement_Type__c != null){
                                s.add(updateAccountMap.get(pracIdList.get(pracIdList.indexOf(businessMap.get(grgrList.get(i).Child_Account__c).ParentId))).Tier_Agreement_Type__c);
                            }
                        }
                    }
                }
            }

            //Check the below part again.
            if(!s.isEmpty()){
                //below part updated by Vikhyat on 08/21/2019
                grgAgreement.put(gId, VSPR31_PrecedenceCalculator.calculate(new List<String>(s), precedenceMap));
            }else{
                grgAgreement.put(gId, null);
            }
        }


        for(Id i: grgAgreement.keySet()){
            if(grgMap.containsKey(i)){
                Global_Rewards_Group__c grg = grgMap.get(i);
                grg.Tier_Agreement_Type__c = grgAgreement.get(i);
                grgMap.put(i, grg);
            }
        }
        
        //Below part added by Vikhyat on 08/06/2019
        
        if(grgMap.values().size()>0){
            List<Global_Rewards_Group__c> grgListToUpdate = new List<Global_Rewards_Group__c>();
            
            for(Global_Rewards_Group__c grg: grgMap.values()){
                if(oldGRG.containsKey(grg.Id) && oldGRG.get(grg.Id) != grg.Tier_Agreement_Type__c){
                    grgListToUpdate.add(grg);
                }
            }
            
            if(grgListToUpdate.size()>0){
                Database.SaveResult[] SaveResultList = Database.update(grgListToUpdate, false);
                
                for(integer i =0; i<grgListToUpdate.size();i++){
                	String msg='';
                	if(!SaveResultList[i].isSuccess()){
                    	msg += grgListToUpdate.get(i).id + '\n'+'Error: "';
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
        //Part added by Vikhyat on 08/06/2019 ends here.

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
                
                mail.setSubject('Tier Agreement Type on GRG  Job Errors');
                
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

        if(!Test.isRunningTest()){
            VSPR31_Grg_Tier_Update_Batch obj = new VSPR31_Grg_Tier_Update_Batch();
            Database.executeBatch(obj, 200);
        }

    }
}