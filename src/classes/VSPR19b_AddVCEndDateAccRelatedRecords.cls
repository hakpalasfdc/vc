/**
* Class Name: VSPR19b_AddVCEndDateAccRelatedRecords
* Date: April 26, 2017
* Project: PROS Decommission
* @author: eightCloud
* @description: Populates Vision Care End Date to a Business Account's related Network Relationship records
*/

public with sharing class VSPR19b_AddVCEndDateAccRelatedRecords{
    
    public static boolean VSPR19b_AddVCEndDateAccRelatedRecords_recursion = true;
    //method holds logic of trigger VSPR19b_AddVCEndDateAccRelatedRecords
    public void VSPR19b_AddVCEndDateAccRelatedRecords(List<Account> newTrigger){
        
        if(VSPR19b_AddVCEndDateAccRelatedRecords_recursion){
        VSPR19b_AddVCEndDateAccRelatedRecords_recursion = false;

            system.debug('***** entered VSPR19b_AddVCEndDateAccRelatedRecords ***** ');
            Set<id> AccId=new set<id>();
            Map<id,Date> MapIdWithDate=new Map<id,Date>();
            Map<id,Date> MapContactIdWithDate=new Map<id,Date>();
            Set<id> conID=new Set<Id>();
            Set<id> updatedContactId=new set<id>();
            Set<contact> UpdatedContactSet=new Set<Contact>();
            String accRecordTypeId=[SELECT Id 
                                    FROM RecordType 
                                    WHERE SObjectType = 'Account' 
                                    AND Name='Business Account'].Id;
            system.debug('accRecordTypeId: '+accRecordTypeId);
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return; }
                                    
            For(Account acc: newTrigger){
                if(acc.Vision_Care_End_Date__c != NULL && 
                   acc.RecordTypeId == accRecordTypeId){
                    AccId.add(acc.id);
                    MapIdWithDate.put(acc.id,acc.Vision_Care_End_Date__c);               
                }    
            }
            system.debug('AccId: '+AccId);
            system.debug('MapIdWithDate: '+MapIdWithDate);

            if(!AccId.isEmpty()){
            
                list<Network_Relationship__c> networkRelationshipList=
                        [SELECT id,Program_End_Date__c,Account_Name__c,Provider_Name__c
                         FROM Network_Relationship__c 
                         WHERE Account_Name__c in : AccId 
                         AND Program_End_Date__c = NULL];
                
                system.debug('networkRelationshipListSIZE: '+networkRelationshipList.size());

                List<Contact> nrContacts = new List<Contact>();   
                List<Network_Relationship__c> networkRelationshipList2 = new List<Network_Relationship__c>();                      
                for(Network_Relationship__c network : networkRelationshipList){
                    if(MapIdWithDate.containsKey(network.Account_Name__c)){
                        //network.Program_End_Date__c=MapIdWithDate.get(network.Account_Name__c);
                        Network_Relationship__c nr = new Network_Relationship__c(id = network.Id);
                        nr.Program_End_Date__c = MapIdWithDate.get(network.Account_Name__c);
                        nr.Bypass_VC_Validation_Rules__c = true;
                        networkRelationshipList2.add(nr);
                        system.debug('nr: '+nr);
                        Contact c = new Contact(Id = network.Provider_Name__c);
                        nrContacts.add(c);
                    }
                }
                system.debug('networkRelationshipList2: '+networkRelationshipList2);
                if(!networkRelationshipList2.isEmpty()){
                    update networkRelationshipList2;
                } 
                
                List<Contact> contactList=[SELECT id, AccountId, Vision_Care_End_Date__c, Vision_Care_Effective_Date__c 
                                           FROM Contact 
                                           WHERE Id =: nrContacts];
                                           //WHERE AccountId in : AccId];
                                           
                system.debug('contactListSIZE: '+contactList.size());
                                           
                for(Contact con:contactList){
                    MapContactIdWithDate.put(con.id,MapIdWithDate.get(con.accountId));
                    conID.add(con.id);         
                }
                system.debug('MapContactIdWithDate: '+MapContactIdWithDate);
                system.debug('conIDSIZE: '+conID.size());
                
                /*
                List<Contact_Role__c> CrList=
                    [SELECT id,Contact__c,Name, (SELECT id 
                                                 FROM Payment_Relationships__r 
                                                 WHERE (Program_End_Date__c = NULL 
                                                 OR Program_End_Date__c >= TODAY)
                                                 AND Program_Effective_Date__c <= TODAY) 
                     FROM Contact_Role__c 
                     WHERE Contact__c in : conID 
                     AND End_Date__c = NULL];
                */

                AggregateResult[] countActiveNRs =
                    [SELECT Provider_Name__c contact, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Provider_Name__c =: conID
                     AND Program_End_Date__c = NULL
                     GROUP BY Provider_Name__c];

                Map<String, Integer> countActiveNRsMap = new Map<String, Integer>();
                for(Contact cX: contactList){
                    countActiveNRsMap.put(cX.id,0);
                }
                if(!countActiveNRs.isEmpty()){
                    for (AggregateResult ar : countActiveNRs){
                        countActiveNRsMap.put((string)ar.get('contact'),(integer)ar.get('myCount'));
                    }
                }

                /*
                system.debug('CrList: '+CrList);
                system.debug('CrListSIZE: '+CrList.size());

                for(Contact_Role__c cr : CrList){
                    if(cr.Payment_Relationships__r.size()<=0){ 
                        updatedContactId.add(cr.Contact__c);  
                        system.debug('cr.Payment_Relationships__r SIZE (less than/equal ZERO): '+cr.Name+' = '+cr.Payment_Relationships__r.size());         
                    }
                    if(cr.Payment_Relationships__r.size()>=1){ 
                        system.debug('cr.Payment_Relationships__r SIZE (greater than/equal ONE): '+cr.Name+' = '+cr.Payment_Relationships__r.size()); 
                    }
                }
                system.debug('updatedContactId: '+updatedContactId);
                */
               
                List<Contact> contactList1 = new List<Contact>();   
                for(Contact con:contactList){
                    //if(updatedContactId.contains(con.id) && 
                    if(countActiveNRsMap.get(con.id) == 0 && 
                       con.Vision_Care_Effective_Date__c != NULL &&
                       (con.Vision_Care_End_Date__c == NULL 
                        || 
                        con.Vision_Care_End_Date__c > MapContactIdWithDate.get(con.id)) ){

                        Contact c = new Contact(id = con.Id);
                        c.Vision_Care_End_Date__c = MapContactIdWithDate.get(con.id);
                        c.Bypass_VC_Validation_Rules__c = true;
                        contactList1.add(c);
                    }         
                }
                system.debug('contactList1: '+contactList1);
                

                //if(UpdatedContactSet.size()>0 && !Test.IsrunningTest())
                if(!contactList1.isEmpty()){
                    update contactList1;
                }

                /*
                // ********** MOVING THIS FOR NOW *********************
                //if(networkRelationshipList.size()>0 && !Test.IsrunningTest())
                if(!networkRelationshipList2.isEmpty()){
                    update networkRelationshipList2;
                } 
                */


                /*
                system.debug('networkRelationshipListSIZE: '+networkRelationshipList.size());
                system.debug('networkRelationshipList0: '+'NR id: '+networkRelationshipList2[0].Id+' NR Program_End_Date__c: '+networkRelationshipList2[0].Program_End_Date__c);
                system.debug('networkRelationshipList1: '+'NR id: '+networkRelationshipList2[1].Id+' NR Program_End_Date__c: '+networkRelationshipList2[1].Program_End_Date__c);
                system.debug('networkRelationshipList2: '+'NR id: '+networkRelationshipList2[2].Id+' NR Program_End_Date__c: '+networkRelationshipList2[2].Program_End_Date__c);
                system.debug('networkRelationshipList3: '+'NR id: '+networkRelationshipList2[3].Id+' NR Program_End_Date__c: '+networkRelationshipList2[3].Program_End_Date__c);
                system.debug('networkRelationshipList4: '+'NR id: '+networkRelationshipList2[4].Id+' NR Program_End_Date__c: '+networkRelationshipList2[4].Program_End_Date__c);
                system.debug('networkRelationshipList5: '+'NR id: '+networkRelationshipList2[5].Id+' NR Program_End_Date__c: '+networkRelationshipList2[5].Program_End_Date__c);
                system.debug('networkRelationshipList6: '+'NR id: '+networkRelationshipList2[6].Id+' NR Program_End_Date__c: '+networkRelationshipList2[6].Program_End_Date__c);
                system.debug('networkRelationshipList7: '+'NR id: '+networkRelationshipList2[7].Id+' NR Program_End_Date__c: '+networkRelationshipList2[7].Program_End_Date__c);
                system.debug('networkRelationshipList8: '+'NR id: '+networkRelationshipList2[8].Id+' NR Program_End_Date__c: '+networkRelationshipList2[8].Program_End_Date__c);
                system.debug('networkRelationshipList9: '+'NR id: '+networkRelationshipList2[9].Id+' NR Program_End_Date__c: '+networkRelationshipList2[9].Program_End_Date__c);
                system.debug('networkRelationshipList10: '+'NR id: '+networkRelationshipList2[10].Id+' NR Program_End_Date__c: '+networkRelationshipList2[10].Program_End_Date__c);
                system.debug('networkRelationshipList11: '+'NR id: '+networkRelationshipList[11].Id+' NR Program_End_Date__c: '+networkRelationshipList[11].Id);*/
            }

        system.debug('***** exiting VSPR19b_AddVCEndDateAccRelatedRecords ***** ');
        }

    }
}