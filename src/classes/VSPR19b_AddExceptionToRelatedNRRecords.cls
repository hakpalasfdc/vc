/**
* Class Name: VSPR19b_AddExceptionToRelatedNRRecords
* Date: March 01, 2018
* Project: PROS Decommission
* @author: Shravani Chigullapally
* @description: Populates Update__c field with the value "True" on associated Network Relationship records when Vision_Care_Location_Exception__c field on Business or  Vision_Care_Practice_Exception__c field on Practice is changed.
*/

public with sharing class VSPR19b_AddExceptionToRelatedNRRecords{
    public static boolean VSPR19b_AddExceptionToRelatedNRRecords_recursion = true;
    //method holds logic of trigger VSPR19b_AddExceptionToRelatedNRRecords
    public void VSPR19b_AddExceptionToRelatedNRRecords(List<Account> newTrigger, Map<Id,Account> oldMap, Boolean isTrgUpdate){
        if(VSPR19b_AddExceptionToRelatedNRRecords_recursion){
            VSPR19b_AddExceptionToRelatedNRRecords_recursion = false;
            system.debug('***** entered VSPR19b_AddExceptionToRelatedNRRecords ***** ');
            Boolean isUpdate = false;
            Set<id> pracAccIDs = new set<id>();
            Set<id> busAccIDs = new set<id>();
            List<Network_Relationship__c> netRelList = new List<Network_Relationship__c>();
            String pracException, busException;
            String busAccRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Account' and Name='Business Account'].Id;
            String pracAccRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { 
                return;
            }
            for(Account acc : newTrigger){
                if(acc.RecordTypeId == pracAccRecordTypeId){
                    pracAccIDs.add(acc.id);
                }
                if(acc.RecordTypeId == busAccRecordTypeId){
                    busAccIDs.add(acc.id);
                }
                if(isTrgUpdate){
                    Account oldAcc = oldMap.get(acc.Id);
                    
                    system.debug('++++++++++++oldAcc.Vision_Care_Practice_Exception__c++++++++++++++++++++++++++' +oldAcc.Vision_Care_Practice_Exception__c);
                    system.debug('++++++++++++acc.Vision_Care_Practice_Exception__c++++++++++++++++++++++++++' +acc.Vision_Care_Practice_Exception__c);
                    
                    system.debug('++++++++++++acc.Vision_Care_Location_Exception__c++++++++++++++++++++++++++' +acc.Vision_Care_Location_Exception__c);
                    system.debug('++++++++++++oldAcc.Vision_Care_Location_Exception__c++++++++++++++++++++++++++' +oldAcc.Vision_Care_Location_Exception__c);
                    
                    if(oldAcc.Vision_Care_Practice_Exception__c == acc.Vision_Care_Practice_Exception__c && acc.RecordTypeId == pracAccRecordTypeId){
                        isUpdate = true;
                    }
                    if(oldAcc.Vision_Care_Location_Exception__c == acc.Vision_Care_Location_Exception__c && acc.RecordTypeId == busAccRecordTypeId){
                        isUpdate = true;
                    }
                }
            }

            system.debug('+++++++++++++++++++isUpdate++++++++++++++++++' +isUpdate);
            system.debug('+++++++++++++++++++busAccIDs++++++++++++++++++' +busAccIDs);
            system.debug('+++++++++++++++++++busAccIDs++++++++++++++++++' +busAccIDs.size());
            
            if(pracAccIDs.size() > 0 && isUpdate == false){
                List<Account> lstBusAcc = [Select Id from Account where RecordType.Name = 'Business Account' AND ParentId IN :pracAccIDs];
                for(Account a : lstBusAcc){
                    busAccIDs.add(a.id);
                }
            }
            
            
            if(busAccIDs.size() > 0 && isUpdate == false){
                list<Network_Relationship__c> busNetworkRelationshipList = [SELECT id, Exception_Reason__c, Exception_Reason_Calculation__c FROM Network_Relationship__c WHERE Account_Name__c in : busAccIDs AND Program_ID__r.name = 'VSP' AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL)];
                
                system.debug('+++++++++++++++++++busNetworkRelationshipList++++++++++++++++++' +busNetworkRelationshipList);
                
                if(busNetworkRelationshipList.size() >0){
                    for(Network_Relationship__c nr : busNetworkRelationshipList){
                        nr.Exception_Reason__c = nr.Exception_Reason_Calculation__c;
                        nr.Bypass_VC_Validation_Rules__c = true;
                        netRelList.add(nr);
                    }
                }
            }
            if(netRelList.size() > 0){
                update netRelList;
            }
            system.debug('***** exiting VSPR19b_AddExceptionToRelatedNRRecords ***** ');
        }
    }
}