/**
* Class Name: VSPR19b_PopulateBAVCEndDate
* Date: June 13, 2017
* Project: PROS Decommission
* @author: Shravani Chigullapally
* @description: Populates Vision Care End Date from a Practice Account to its related Business Accounts 
*/


public with sharing class VSPR19b_PopulateBAVCEndDate{
   public static boolean VSPR19b_PopulateBAVCEndDate_recursion = true;
    //method holds logic of trigger VSPR19b_PopulateBAVCEndDate
    public void VSPR19b_PopulateBAVCEndDate(List<Account> newTrigger, Map<Id,Account> oldMap, Boolean isTrgUpdate){
        
        if(VSPR19b_PopulateBAVCEndDate_recursion){
        VSPR19b_PopulateBAVCEndDate_recursion = false;
            
            system.debug('***** entered VSPR19b_PopulateBAVCEndDate ***** ');
            Boolean isUpdate = false;
            Set<id> accIDs = new set<id>();
            List<Account> busAccList = new List<Account>();
            Id pracAccId; 
            Date pracVCEndDate;
            String accRecordTypeId=[SELECT Id 
                                    from RecordType 
                                    where SObjectType = 'Account' and Name='Practice Account'].Id;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return; }
            
            for(Account acc : newTrigger){
                    if(acc.Id != null){
                        pracAccId = acc.ParentId;
                        if(acc.Vision_Care_End_Date__c != null){
                            pracVCEndDate = acc.Vision_Care_End_Date__c;
                            system.debug('+++++++++++++++++++++++++ acc.Vision_Care_End_Date__c +++++++++++++++++++++++++' +acc.Vision_Care_End_Date__c);
                        }
                    }
                
                    if(acc.RecordTypeId == accRecordTypeId){
                        accIDs.add(acc.id);
                    }
                    

                    if(isTrgUpdate){
                        Account oldAcc = oldMap.get(acc.Id);
                        if(oldAcc.Vision_Care_End_Date__c != acc.Vision_Care_End_Date__c){
                            isUpdate = true;
                        }
                    }   
                    
            }
            system.debug('++++++++++++++++++++++++++++  pracVCEndDate +++++++++++++++++++++++++++++++++++++++++++++' +pracVCEndDate);
            //**** CHANGE
            if(accIDs.size() > 0 && isUpdate == TRUE){
                        
                List<Account> lstAcc = [Select Id, Vision_Care_End_Date__c, Vision_Care_Effective_Date__c 
                                        from Account 
                                        where RecordType.Name = 'Business Account' 
                                        AND ParentId IN :accIDs 
                                        AND Vision_Care_Effective_Date__c <= TODAY];
                
                system.debug('+++++++++++++++++++++++++ lstAcc +++++++++++++++++++++++++++++++++' +lstAcc );
                
                if(lstAcc.size() >0){
                    for(Account a : lstAcc){
                        system.debug('+++++++++++++++++++++++++ 1 +++++++++++++++++++++++++++++++++');
                        if(a.Vision_Care_End_Date__c == null || a.Vision_Care_End_Date__c > pracVCEndDate){
                            system.debug('+++++++++++++++++++++++++ 2 +++++++++++++++++++++++++++++++++');
                            a.Vision_Care_End_Date__c = pracVCEndDate;
                            a.Bypass_VC_Validation_Rules__c = true;
                            busAccList.add(a);
                        }
                    }
                }   
            }
            
            if(busAccList.size() > 0){update busAccList;
            }
        system.debug('***** exiting VSPR19b_PopulateBAVCEndDate ***** ');
        }
    }
    
        
    
    
        
  
}