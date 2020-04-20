/*
*Date: 8.November.2016
*Description: ContactTrigger handler class to check digit logic of NPI Type 1 Number
*/

public class ContactTrigger_Handler
{
    //Method to restrict user from saving a VC Contact Record with existing record with same Doctor NPI
    public static boolean validateContact_recursion = true;
    public static void validateContact(List<Contact> lstContacts) {      
        
        if(validateContact_recursion){
        validateContact_recursion = false;

            system.debug('***** entered validateContact ***** ');
            Schema.DescribeSObjectResult d = Schema.SObjectType.Contact;       
            Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
            Schema.RecordTypeInfo rtByName =  rtMapByName.get('Eye Care Professional');
            String ecpRTId = rtByName.getRecordTypeId(); 
            set<String> stNPI = new set<String>();
            list<Contact> lstContactToValidate = new list<Contact>();
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return; }
            
            for(Contact con : lstContacts) {
                if(con.RecordTypeId != ecpRTId 
                   || con.Vision_Care_Effective_Date__c == NULL 
                     || con.NPI__c == NULL) {
                    continue;
                }
                if(!stNPI.contains(con.NPI__c)) {
                    stNPI.add(con.NPI__c);
                }
                else {
                    con.addError('Another Vision Care Doctor Contact already exists with this Doctor NPI.'); return;
                }        
                lstContactToValidate.add(con);
            }
            
            list<Contact> lstExistingContacts = [Select Id,NPI__c 
                                                 FROM Contact 
                                                 Where ID NOT IN :lstContactToValidate
                                                 AND RecordType.Name = 'Eye Care Professional' 
                                                 AND Vision_Care_Effective_Date__c !=NULL
                                                 AND NPI__c IN:stNPI];
            set<String> stExistingNPI = new set<String>();
            for(Contact con : lstExistingContacts) {
                stExistingNPI.add(con.NPI__c);        
            }                                   
            for(contact con : lstContactToValidate) {
                if(stExistingNPI.contains(con.NPI__c)) {
                    con.addError('Another Vision Care Doctor Contact already exists with this Doctor NPI.');
                }
            } 

            system.debug('***** exiting validateContact ***** ');
        }  
    }
    
   //Method to restrict user from saving Contact Record with non-unique Doctor ID
    public static boolean validateDocID_recursion = true;
    public static void validateDocID(List<Contact> lstContacts,Map<Id,Contact> oldContactMap) { 
        
        if(validateDocID_recursion && !system.isBatch()){
        validateDocID_recursion = false;

            system.debug('***** entering validateDocID ***** ');
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}

            String doctorID;
            String prev1;
            String prev2;
            List<Contact> doctorIDMatch = new List<Contact>();
            List<Contact> doctorIDMatch2pre = new List<Contact>();
            List<Contact> doctorIDMatchA = new List<Contact>();
            List<Contact> doctorIDMatchB = new List<Contact>();
            List<Contact> doctorIDMatchC = new List<Contact>();
            List<Contact> doctorIDMatch2 = new List<Contact>();
            Boolean isUpdate = false;

            for(Contact c : lstContacts){
                /*
                if(Trigger.IsUpdate){
                    Contact oldCon = oldContactMap.get(c.Id);
                    if(oldCon.Doctor_ID__c == c.Doctor_ID__c){
                        isUpdate = true;
                    }
                }*/
                if(oldContactMap != NULL){
                    if(c.Doctor_ID__c != NULL && c.Doctor_ID__c != oldContactMap.get(c.Id).Doctor_ID__c){
                        doctorID = c.Doctor_ID__c;
                    }
                }
                //else{doctorID = 'xxxxxxxxx';}
                if(c.Previous_Doctor_ID_1__c != NULL && c.Previous_Doctor_ID_1__c != oldContactMap.get(c.Id).Previous_Doctor_ID_1__c){
                    prev1 = c.Previous_Doctor_ID_1__c;
                }
                //else{prev1 = 'xxxxxxxxx';}
                if(c.Previous_Doctor_ID_2__c != NULL && c.Previous_Doctor_ID_2__c != oldContactMap.get(c.Id).Previous_Doctor_ID_2__c){
                    prev2 = c.Previous_Doctor_ID_2__c;
                }
                //else{prev2 = 'xxxxxxxxx';}
                    if(doctorID != NULL){
                        doctorIDMatchA = [Select Id FROM Contact WHERE (Doctor_ID__c =: doctorID OR Previous_Doctor_ID_1__c =: doctorID OR Previous_Doctor_ID_2__c =: doctorID) AND RecordType.developerName = 'Eye_Care_Professional'];
                       // List<List<SObject>> searchListA = [FIND :doctorID IN ALL FIELDS RETURNING Contact (Id)];
                       // doctorIDMatchA = (List<Contact>)searchListA[0];
                        system.debug('doctorIDMatchA: '+doctorIDMatchA);
                    }
                    if(prev1 != NULL){
                        doctorIDMatchB = [Select Id FROM Contact WHERE (Doctor_ID__c =: prev1 OR Previous_Doctor_ID_1__c =: prev1 OR Previous_Doctor_ID_2__c =: prev1) AND RecordType.developerName = 'Eye_Care_Professional'];
                      //  List<List<SObject>> searchListB = [FIND :prev1 IN ALL FIELDS RETURNING Contact (Id)];
                      //  doctorIDMatchB = (List<Contact>)searchListB[0];
                        system.debug('doctorIDMatchB: '+doctorIDMatchB);
                    }
                    if(prev2 != NULL){
                        doctorIDMatchC = [Select Id FROM Contact WHERE (Doctor_ID__c =: prev2 OR Previous_Doctor_ID_1__c =: prev2 OR Previous_Doctor_ID_2__c =: prev2) AND RecordType.developerName = 'Eye_Care_Professional'];
                     //   List<List<SObject>> searchListC = [FIND :prev2 IN ALL FIELDS RETURNING Contact (Id)];
                     //   doctorIDMatchC = (List<Contact>)searchListC[0];
                        system.debug('doctorIDMatchC: '+doctorIDMatchC);
                    }
                    
                    Set<Contact> searchList = new Set<Contact>();
                    searchList.addAll(doctorIDMatchA);
                    searchList.addAll(doctorIDMatchB);
                    searchList.addAll(doctorIDMatchC);
                    doctorIDMatch2pre.addAll(searchList);
                    system.debug('doctorIDMatch2pre: '+doctorIDMatch2pre);
                    
                    for(Contact x: doctorIDMatch2pre){
                        if(x.Id != c.Id){
                            doctorIDMatch2.add(x);
                        }
                    }  
                    system.debug('doctorIDMatch2: '+doctorIDMatch2);
                    
                    /*
                    doctorIDMatch2 = [SELECT Doctor_ID__c 
                                      FROM Contact 
                                      WHERE Id !=: c.Id
                                      AND (Doctor_ID__c =: doctorID
                                      OR Doctor_ID__c =: prev1
                                      OR Doctor_ID__c =: prev2
                                      OR Previous_Doctor_ID_1__c=: doctorID
                                      OR Previous_Doctor_ID_1__c=: prev1
                                      OR Previous_Doctor_ID_1__c=: prev2
                                      OR Previous_Doctor_ID_2__c=: doctorID
                                      OR Previous_Doctor_ID_2__c=: prev1
                                      OR Previous_Doctor_ID_2__c=: prev2)]; */
                
            }

            for(Contact con : lstContacts){
                if(doctorIDMatch2 != null && 
                   doctorIDMatch2.size() >0 && 
                  (con.Doctor_ID__c != null || con.Previous_Doctor_ID_1__c != null || con.Previous_Doctor_ID_2__c != null)){
                  //if(doctorIDMatch != null && doctorIDMatch.size() >0 && con.Doctor_ID__c != null && isUpdate == false){
                        con.id.addError('Another Contact already exists with this Doctor ID.');                   
                }
            }
            system.debug('***** exiting validateDocID ***** ');
        }
    } 
    
    //Method for updating associated Network Relationship records if user enters Vision Care End Date on Contact Record
    public static boolean VisionCareEndDate_recursion = true;
    public static void  VisionCareEndDate(List<Contact> conList){
        List<Id> lstContactIds = new List<Id>();
        for(Contact c : conList){
            lstContactIds.add(c.Id);
        }
        if(System.isBatch() || System.isFuture()){VisionCareEndDateNotFuture(lstContactIds);}
        else{VisionCareEndDateFuture(lstContactIds);}
    }

      @future
      public static void  VisionCareEndDateFuture(List<Id> lstContactIds){
        List<Contact> conList = [Select Id, Vision_Care_End_Date__c from Contact where Id in :lstContactIds];      
        if(VisionCareEndDate_recursion){
        VisionCareEndDate_recursion = false;

            system.debug('***** entering VisionCareEndDate ***** ');

            Set<id> ConId=new set<id>();
            Set<id> AccId=new set<id>();
            Set<id> pAccId=new set<id>();
            Map<id,Date> MapIdWithDate=new Map<id,Date>();
            Map<id,Date> MapAccountIdWithDate=new Map<id,Date>();
            Map<id,Date> MapPractAccountIdWithDate=new Map<id,Date>();
            Set<Network_Relationship__c> nrSet = new Set<Network_Relationship__c>();
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
                For(Contact c: conList){
                    //c.Vision_Care_End_Date__c!=Trigger.oldMap.get(c.id).Vision_Care_End_Date__c &&
                    if(c.Vision_Care_End_Date__c!=null){
                        
                        ConId.add(c.id);
                        MapIdWithDate.put(c.id,c.Vision_Care_End_Date__c);               
                    }    
                    
                }
                system.debug(ConId+'###########'+MapIdWithDate);
                if(ConId.size()>0){                    
                    list<Network_Relationship__c> networkRelationshipList=new List<Network_Relationship__c>();
                    networkRelationshipList=
                        [SELECT id,Program_End_Date__c,Provider_Name__c, Provider_Name__r.Vision_Care_End_Date__c
                         FROM Network_Relationship__c 
                         WHERE Provider_Name__c in : ConId];
                    
                    for(Network_Relationship__c network : networkRelationshipList){
                        
                        if(MapIdWithDate.containsKey(network.Provider_Name__c) &&
                           (network.Program_End_Date__c == NULL || 
                            (network.Program_End_Date__c > MapIdWithDate.get(network.Provider_Name__c)))){
                            Network_Relationship__c x = new Network_Relationship__c(Id = network.Id);
                            x.Program_End_Date__c=MapIdWithDate.get(network.Provider_Name__c);
                            x.Bypass_VC_Validation_Rules__c = true;  
                            nrSet.add(x);  
                        }
                    }
                    system.debug('networkRelationshipList: '+networkRelationshipList);
                    system.debug('nrSet: '+nrSet);
                }
                List<Network_Relationship__c> nrList = new List<Network_Relationship__c>(nrSet);
                system.debug('nrList: '+nrList);
                if(!nrList.isEmpty()){
                    update nrList;
                }

                list<Contact_Role__c> ContactRoleList=
                        [SELECT id,Account__c,Contact__c,contact__r.Vision_Care_End_Date__c, Account__r.ParentId
                         FROM Contact_Role__c 
                         WHERE Contact__c in : conid];

                system.debug('ContactRoleList: '+ContactRoleList);

                for(Contact_Role__c cr:ContactRoleList){
                    AccId.add(cr.Account__c);
                    pAccId.add(cr.Account__r.ParentId);
                    MapAccountIdWithDate.put(cr.Account__c,MapIdWithDate.get(cr.Contact__c));
                    MapPractAccountIdWithDate.put(cr.Account__r.ParentId,MapIdWithDate.get(cr.Contact__c));
                }

                system.debug('AccId: '+AccId);
                system.debug('MapAccountIdWithDate: '+MapAccountIdWithDate);
                system.debug('pAccId: '+pAccId);
                system.debug('pAccId(size): '+pAccId.size());
                system.debug('MapPractAccountIdWithDate: '+MapPractAccountIdWithDate);
                
                Set<Account> UpdateAccountSet=new Set<Account>();
                
                AggregateResult[] checkBizAcctActive =
                    [SELECT Account_Name__c bAcct, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Account_Name__c =: AccId
                     AND Program_End_Date__c = NULL
                     AND Account_Name__r.recordType.name='Business Account'
                     GROUP BY Account_Name__c];

                system.debug('checkBizAcctActive: '+checkBizAcctActive);

                Map<String,Integer> checkBizAcctActiveMap = new Map<String,Integer>();
                List<Account> bAccts=[SELECT id,Vision_Care_End_Date__c,RecordType.name 
                                      FROM Account 
                                      WHERE Id =: AccId];
                system.debug('bAccts: '+bAccts);
                for(Account acc: bAccts){
                    checkBizAcctActiveMap.put(acc.id,0);
                }
                if(!checkBizAcctActiveMap.isEmpty()){
                    for (AggregateResult ar : checkBizAcctActive){
                        checkBizAcctActiveMap.put((string)ar.get('bAcct'),(integer)ar.get('myCount'));
                    }
                }
                system.debug('checkBizAcctActiveMap: '+checkBizAcctActiveMap);
                
                for(Account acc: bAccts){
                    if(MapAccountIdWithDate.containsKey(acc.id)){
                        if(acc.RecordType.name=='Business Account' &&
                           checkBizAcctActiveMap.get(acc.Id)==0 &&
                           acc.Vision_Care_End_Date__c == NULL){
                            acc.Vision_Care_End_Date__c = MapAccountIdWithDate.get(acc.id);
                            acc.Bypass_VC_Validation_Rules__c = true;
                            UpdateAccountSet.add(acc); 
                        }
                    }
                }
                system.debug('UpdateAccountSet: '+UpdateAccountSet);

                //////////////////////////////////////////////////////////////

                List<Account> pAcctsSetup=
                    [SELECT id 
                     FROM Account 
                     WHERE Id =: pAccId];
                system.debug('pAcctsSetup(size): '+pAcctsSetup.size());
                system.debug('pAcctsSetup: '+pAcctsSetup);

                AggregateResult[] checkPractAcctActive =
                    [SELECT ParentId parent, count(ID) myCount
                     FROM Account
                     WHERE ParentId =: pAcctsSetup
                     AND Vision_Care_End_Date__c = NULL 
                     AND RecordType.name='Business Account'
                     GROUP BY ParentId];
                system.debug('checkPractAcctActive: '+checkPractAcctActive);

                Map<String,Integer> checkPractAcctActiveMap = new Map<String,Integer>();

                List<Account> pAccts = 
                    [SELECT id,Vision_Care_End_Date__c,RecordType.name 
                     FROM Account 
                     WHERE Id =: pAccId];
                system.debug('pAccts: '+pAccts);

                for(Account acc: pAccts){
                    checkPractAcctActiveMap.put(acc.id,0);
                }
                if(!checkPractAcctActive.isEmpty()){
                    for (AggregateResult ar : checkPractAcctActive){
                        checkPractAcctActiveMap.put((string)ar.get('parent'),(integer)ar.get('myCount'));
                    }
                }
                system.debug('checkPractAcctActiveMap: '+checkPractAcctActiveMap);

                Map<String,Date> maxEndDateMap = new Map<String,Date>();

                List<Account> maxEndDateList = 
                    [SELECT ParentId, Vision_Care_End_Date__c 
                     FROM Account 
                     WHERE RecordType.Name = 'Business Account' 
                     AND ParentId = :pAccId 
                     ORDER BY Vision_Care_End_Date__c ASC];
                
                for(Account accX: maxEndDateList){
                    maxEndDateMap.put(accX.ParentId,accX.Vision_Care_End_Date__c);
                }

                for(Account acc: pAccts){
                    if(MapPractAccountIdWithDate.containsKey(acc.id)){    
                        if( (acc.RecordType.name=='Practice Account' &&
                             checkPractAcctActiveMap.get(acc.Id)==0 &&
                             acc.Vision_Care_End_Date__c == NULL)
                             ||
                            (acc.RecordType.name=='Practice Account' &&
                             acc.Vision_Care_End_Date__c > maxEndDateMap.get(acc.Id)) 
                            ){    
                                acc.Vision_Care_End_Date__c = MapPractAccountIdWithDate.get(acc.Id);
                                acc.Bypass_VC_Validation_Rules__c = true;
                                UpdateAccountSet.add(acc);    
                        }
                    }
                }

                system.debug('UpdateAccountSet: '+UpdateAccountSet);
                List<Account> UpdateAccount = new List<Account>(UpdateAccountSet);
                if(!UpdateAccount.isEmpty()){
                    update UpdateAccount;
                }
                system.debug('***** exiting VisionCareEndDate ***** ');
        }
    }
    
    public static void  VisionCareEndDateNotFuture(List<Id> lstContactIds){
        List<Contact> conList = [Select Id, Vision_Care_End_Date__c from Contact where Id in :lstContactIds];
        if(VisionCareEndDate_recursion){
        VisionCareEndDate_recursion = false;

            system.debug('***** entering VisionCareEndDate ***** ');

            Set<id> ConId=new set<id>();
            Set<id> AccId=new set<id>();
            Set<id> pAccId=new set<id>();
            Map<id,Date> MapIdWithDate=new Map<id,Date>();
            Map<id,Date> MapAccountIdWithDate=new Map<id,Date>();
            Map<id,Date> MapPractAccountIdWithDate=new Map<id,Date>();
            Set<Network_Relationship__c> nrSet = new Set<Network_Relationship__c>();
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
                For(Contact c: conList){
                    //c.Vision_Care_End_Date__c!=Trigger.oldMap.get(c.id).Vision_Care_End_Date__c &&
                    if(c.Vision_Care_End_Date__c!=null){
                        
                        ConId.add(c.id);
                        MapIdWithDate.put(c.id,c.Vision_Care_End_Date__c);               
                    }    
                    
                }
                system.debug(ConId+'###########'+MapIdWithDate);
                if(ConId.size()>0){                    
                    list<Network_Relationship__c> networkRelationshipList=new List<Network_Relationship__c>();
                    networkRelationshipList=
                        [SELECT id,Program_End_Date__c,Provider_Name__c, Provider_Name__r.Vision_Care_End_Date__c
                         FROM Network_Relationship__c 
                         WHERE Provider_Name__c in : ConId];
                    
                    for(Network_Relationship__c network : networkRelationshipList){
                        
                        if(MapIdWithDate.containsKey(network.Provider_Name__c) &&
                           (network.Program_End_Date__c == NULL || 
                            (network.Program_End_Date__c > MapIdWithDate.get(network.Provider_Name__c)))){
                            Network_Relationship__c x = new Network_Relationship__c(Id = network.Id);
                            x.Program_End_Date__c=MapIdWithDate.get(network.Provider_Name__c);
                            x.Bypass_VC_Validation_Rules__c = true;  
                            nrSet.add(x);  
                        }
                    }
                    system.debug('networkRelationshipList: '+networkRelationshipList);
                    system.debug('nrSet: '+nrSet);
                }
                List<Network_Relationship__c> nrList = new List<Network_Relationship__c>(nrSet);
                system.debug('nrList: '+nrList);
                if(!nrList.isEmpty()){
                    update nrList;
                }

                list<Contact_Role__c> ContactRoleList=
                        [SELECT id,Account__c,Contact__c,contact__r.Vision_Care_End_Date__c, Account__r.ParentId
                         FROM Contact_Role__c 
                         WHERE Contact__c in : conid];

                system.debug('ContactRoleList: '+ContactRoleList);

                for(Contact_Role__c cr:ContactRoleList){
                    AccId.add(cr.Account__c);
                    pAccId.add(cr.Account__r.ParentId);
                    MapAccountIdWithDate.put(cr.Account__c,MapIdWithDate.get(cr.Contact__c));
                    MapPractAccountIdWithDate.put(cr.Account__r.ParentId,MapIdWithDate.get(cr.Contact__c));
                }

                system.debug('AccId: '+AccId);
                system.debug('MapAccountIdWithDate: '+MapAccountIdWithDate);
                system.debug('pAccId: '+pAccId);
                system.debug('pAccId(size): '+pAccId.size());
                system.debug('MapPractAccountIdWithDate: '+MapPractAccountIdWithDate);
                
                Set<Account> UpdateAccountSet=new Set<Account>();
                
                AggregateResult[] checkBizAcctActive =
                    [SELECT Account_Name__c bAcct, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Account_Name__c =: AccId
                     AND Program_End_Date__c = NULL
                     AND Account_Name__r.recordType.name='Business Account'
                     GROUP BY Account_Name__c];

                system.debug('checkBizAcctActive: '+checkBizAcctActive);

                Map<String,Integer> checkBizAcctActiveMap = new Map<String,Integer>();
                List<Account> bAccts=[SELECT id,Vision_Care_End_Date__c,RecordType.name 
                                      FROM Account 
                                      WHERE Id =: AccId];
                system.debug('bAccts: '+bAccts);
                for(Account acc: bAccts){
                    checkBizAcctActiveMap.put(acc.id,0);
                }
                if(!checkBizAcctActiveMap.isEmpty()){
                    for (AggregateResult ar : checkBizAcctActive){
                        checkBizAcctActiveMap.put((string)ar.get('bAcct'),(integer)ar.get('myCount'));
                    }
                }
                system.debug('checkBizAcctActiveMap: '+checkBizAcctActiveMap);
                
                for(Account acc: bAccts){
                    if(MapAccountIdWithDate.containsKey(acc.id)){
                        if(acc.RecordType.name=='Business Account' &&
                           checkBizAcctActiveMap.get(acc.Id)==0 &&
                           acc.Vision_Care_End_Date__c == NULL){
                            acc.Vision_Care_End_Date__c = MapAccountIdWithDate.get(acc.id);
                            acc.Bypass_VC_Validation_Rules__c = true;
                            UpdateAccountSet.add(acc); 
                        }
                    }
                }
                system.debug('UpdateAccountSet: '+UpdateAccountSet);

                //////////////////////////////////////////////////////////////

                List<Account> pAcctsSetup=
                    [SELECT id 
                     FROM Account 
                     WHERE Id =: pAccId];
                system.debug('pAcctsSetup(size): '+pAcctsSetup.size());
                system.debug('pAcctsSetup: '+pAcctsSetup);

                AggregateResult[] checkPractAcctActive =
                    [SELECT ParentId parent, count(ID) myCount
                     FROM Account
                     WHERE ParentId =: pAcctsSetup
                     AND Vision_Care_End_Date__c = NULL 
                     AND RecordType.name='Business Account'
                     GROUP BY ParentId];
                system.debug('checkPractAcctActive: '+checkPractAcctActive);

                Map<String,Integer> checkPractAcctActiveMap = new Map<String,Integer>();

                List<Account> pAccts = 
                    [SELECT id,Vision_Care_End_Date__c,RecordType.name 
                     FROM Account 
                     WHERE Id =: pAccId];
                system.debug('pAccts: '+pAccts);

                for(Account acc: pAccts){
                    checkPractAcctActiveMap.put(acc.id,0);
                }
                if(!checkPractAcctActive.isEmpty()){
                    for (AggregateResult ar : checkPractAcctActive){
                        checkPractAcctActiveMap.put((string)ar.get('parent'),(integer)ar.get('myCount'));
                    }
                }
                system.debug('checkPractAcctActiveMap: '+checkPractAcctActiveMap);

                Map<String,Date> maxEndDateMap = new Map<String,Date>();

                List<Account> maxEndDateList = 
                    [SELECT ParentId, Vision_Care_End_Date__c 
                     FROM Account 
                     WHERE RecordType.Name = 'Business Account' 
                     AND ParentId = :pAccId 
                     ORDER BY Vision_Care_End_Date__c ASC];
                
                for(Account accX: maxEndDateList){
                    maxEndDateMap.put(accX.ParentId,accX.Vision_Care_End_Date__c);
                }

                for(Account acc: pAccts){
                    if(MapPractAccountIdWithDate.containsKey(acc.id)){    
                        if( (acc.RecordType.name=='Practice Account' &&
                             checkPractAcctActiveMap.get(acc.Id)==0 &&
                             acc.Vision_Care_End_Date__c == NULL)
                             ||
                            (acc.RecordType.name=='Practice Account' &&
                             acc.Vision_Care_End_Date__c > maxEndDateMap.get(acc.Id)) 
                            ){    
                                acc.Vision_Care_End_Date__c = MapPractAccountIdWithDate.get(acc.Id);
                                acc.Bypass_VC_Validation_Rules__c = true;
                                UpdateAccountSet.add(acc);    
                        }
                    }
                }

                system.debug('UpdateAccountSet: '+UpdateAccountSet);
                List<Account> UpdateAccount = new List<Account>(UpdateAccountSet);
                if(!UpdateAccount.isEmpty()){
                    update UpdateAccount;
                }
                system.debug('***** exiting VisionCareEndDate ***** ');
        }
    }
    
/*    public static boolean contactAfterTriggerMethod_recursion = true;
    public static void contactAfterTriggerMethod(List<Contact> newTrigger, List<Contact> oldTrigger, Map<id,Contact> oldTriggerMap, Boolean isDelete, Boolean isInsert){
        
        if(contactAfterTriggerMethod_recursion){
        contactAfterTriggerMethod_recursion = false;

            system.debug('***** entering contactAfterTriggerMethod ***** ');
            Set<Id> accountIds = new Set<Id>();
            Set<Id> oldAccountIds = new Set<Id>();
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
                        
            if(isDelete){
                for(Contact oldContact : oldTrigger){
                    //accountIds.add(oldContact.AccountId);
                    accountIds.add(oldTriggerMap.get(oldContact.id).AccountId);
                }
            }else{
                for(Contact contact : newTrigger){
                    if(!isInsert && 
                       contact.AccountId != NULL &&
                       oldTriggerMap.get(contact.id).AccountId != NULL &&
                       contact.AccountId != oldTriggerMap.get(contact.id).AccountId){
                            oldAccountIds.add(oldTriggerMap.get(contact.id).AccountId);
                            accountIds.add(contact.AccountId);     
                            System.debug('>>>>OldAccountIds' + oldTriggerMap.get(contact.id).AccountId);
                            System.debug('>>>>NewAccountIds' + contact.AccountId);
                    }
                    if(isInsert && contact.AccountId != NULL){
                        accountIds.add(contact.AccountId);    
                    }        
                }
            }
            if(!accountIds.isEmpty()){
                updateCheckboxFields(accountIds);
                System.debug('>>>>accountIds' + accountIds);
            }
            if(!oldAccountIds.isEmpty()){
                updateCheckboxFields(oldAccountIds);
                System.debug('>>>>oldAccountIds' + oldAccountIds);  
            }
        }      
        system.debug('***** exiting contactAfterTriggerMethod ***** ');  
    }
    
    public static boolean updateCheckboxFields_recursion = true;
    public static void updateCheckboxFields(Set<Id> accountIds){
        
        if(updateCheckboxFields_recursion ){
        updateCheckboxFields_recursion = false;
        
            system.debug('***** entering updateCheckboxFields ***** ');  
            Map<Id,Double> totContactVSPCnt = new Map<Id,Double>();
            Double netProvCount = 0; 
            
            System.debug('>>>>accountIds' + accountIds);        
            List<Contact> contactDetails = VSPR1_ContactDML.getContactDetails(accountIds);
            List<Account> accountDetails = VSPR1_AccountDML.getAccountDetails(accountIds);
            System.debug('>>>>contactDetails' + contactDetails);
            
            Set<Account> acctSet = new Set<Account>();
            if(!contactDetails.isEmpty()){
                System.debug('>>>>contactDetailsSize' + contactDetails.size());
                
                for(Contact contactDetail : contactDetails){
                    Account x = new Account(Id=contactDetail.accountId);
                    x.Has_Contact__c = TRUE;
                    x.Bypass_VC_Validation_Rules__c = TRUE;
                    acctSet.add(x);        
                }
                
            }else{
                if(!accountDetails.isEmpty()){
                    System.debug('>>>>accountDetailsSize' + accountDetails.size());
                    for(Account accId : accountDetails){
                        Account x = new Account(Id=accId.Id);
                        x.Has_Contact__c = FALSE;
                        x.Bypass_VC_Validation_Rules__c=TRUE;
                        acctSet.add(x);       
                    }
                }
            }
            List<Account> acctList = new List<Account>(acctSet);
            system.debug('acctList: '+acctList);
            if(!acctList.isEmpty()){
                update acctList;
            }
    
            system.debug('***** exiting updateCheckboxFields ***** ');  
        }
    }
*/
}