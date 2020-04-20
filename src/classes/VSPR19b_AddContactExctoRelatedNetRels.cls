/**
* Class Name:  VSPR19b_AddContactExctoRelatedNetRels
* Date: March 27, 2018
* Project: PROS Decommission
* @author: Katherine
* @description: When the Vision Care Doctor Exception changes on the Contact record, populate the Exception_Reason__c field 
                on the associated Active or Future VSP Network Relationship records. 
*/

public with sharing class VSPR19b_AddContactExctoRelatedNetRels {
    public static boolean VSPR19b_AddContactExctoRelatedNetRels_recursion = true;
    public void VSPR19b_AddContactExctoRelatedNetRels(List<Contact> newTrigger, Map<Id,Contact> oldMap, Boolean isTrgUpdate){
        if(VSPR19b_AddContactExctoRelatedNetRels_recursion){
            VSPR19b_AddContactExctoRelatedNetRels_recursion = false;
            system.debug('***********entered VSPR19b_AddContactExctoRelatedNetRels ********');
            Boolean isUpdate = false;
            Set<id> conIDs = new set<id>();
            List<Network_Relationship__c> netRelList = new List<Network_Relationship__c>();
            String conRecordTypeId=[SELECT Id from RecordType WHERE sObjectType = 'Contact' and Name = 'Eye Care Professional'].Id;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c){
                return;
            }
            for(Contact con : NewTrigger){
                if(con.RecordTypeId == conRecordTypeId){
                    conIDs.add(con.Id);
                }
                if(isTrgUpdate){
                    Contact oldCon = oldMap.get(con.Id);
                    
                    system.debug('++++++++++++oldCon.Vision_Care_Doctor_Exception__c++++++++++++++++++++++++++' +oldCon.Vision_Care_Doctor_Exception__c);
                    system.debug('++++++++++++con.Vision_Care_Doctor_Exception__c++++++++++++++++++++++++++' +con.Vision_Care_Doctor_Exception__c);
                     
                    if(oldCon.Vision_Care_Doctor_Exception__c != con.Vision_Care_Doctor_Exception__c){
                        isUpdate=true;
                    }
                }    
            }
            
            system.debug('+++++++++++isUpdate++++++++++ ' +isUpdate);
            system.debug('+++++++++++conIDs++++++++++++ ' +conIDs);
            system.debug('+++++++++++conIDsSize++++++++ ' +conIDs.size());
            
            if(conIDs.size()>0 && isUpdate == true){
                list<Network_Relationship__c> conNetRelList = [SELECT Id, Exception_Reason__c, Exception_Reason_Calculation__c 
                                                              FROM Network_Relationship__c WHERE Provider_Name__c in : conIDs 
                                                               AND Program_ID__r.Name = 'VSP' AND (Program_End_Date__c >=TODAY OR Program_End_Date__c = NULL)];
                
                system.debug('+++++++++++++conNetRelList+++++++++++ '+conNetRelList);
                
                if(conNetRelList.size()>0){
                    for(Network_Relationship__c nr : conNetRelList){
                        nr.Exception_Reason__c = nr.Exception_Reason_Calculation__c;
                        nr.Bypass_VC_Validation_Rules__c = true;
                        netRelList.add(nr);
                 
                    }
                }
                
            } 
            
            if(netRelList.size()>0){
                update netRelList;
            }
            system.debug('************exiting VSPR19b_AddContactExctoRelatedNetRels***********');
                        
        }
    }
}