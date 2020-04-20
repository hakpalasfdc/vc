/**
* Class Name: VSPR19b_UpdatePracticeAccountEndDate
* Date: April 27, 2017
* Project: PROS Decommission
* @author: Shravani Chigullapally
* @description: Populates Vision Care End Date to a Practice Account from the related Business Accounts, if there are no 
*               remaining active Business Accounts.
*/


public class VSPR19b_UpdatePracticeAccountEndDate{
    
    public static boolean VSPR19b_UpdatePracticeAccountEndDate_recursion = true;
    public void VSPR19b_UpdatePracticeAccountEndDate(List<Account> newTrigger, Map<Id,Account> oldMap, Boolean isTrgUpdate, Boolean isTrgDelete){
       
        if(VSPR19b_UpdatePracticeAccountEndDate_recursion){
            VSPR19b_UpdatePracticeAccountEndDate_recursion = false;
            system.debug('***** entered VSPR19b_UpdatePracticeAccountEndDate ***** ');
            Boolean isUpdate = true;
            Date maxEndDate;
           
            Boolean endDateBlank = false;
            
            Set<id> accIDs = new set<id>();
            Map<id,Date> mapIdWithEndDate = new Map<id,Date>();
            String accRecordTypeId=[SELECT Id 
                                    from RecordType 
                                    where SObjectType = 'Account' and Name='Business Account'].Id;
            
            List<Network_Relationship__c> netRelList = new List<Network_Relationship__c>();
            List<Account> pracAccList = new List<Account>();
            List<Account> busAccList = new List<Account>();
            Id pracAccId; 
            Date pracVCEndDate;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return; }
            
            for(Account acc : newTrigger){
                 
                //if(isTrgDelete || isTrgUpdate){
                if(acc.ParentId != null){
                    pracAccId = acc.ParentId;
                    if(acc.Vision_Care_End_Date__c != null){ 
                        pracVCEndDate = acc.Vision_Care_End_Date__c;
                    }
                }
                if(acc.Vision_Care_End_Date__c != null && acc.RecordTypeId == accRecordTypeId){
                    accIDs.add(acc.id);
                    mapIdWithEndDate.put(acc.id,acc.Vision_Care_End_Date__c);         
                    
                }
                //}
                if(isTrgUpdate){
                    Account oldAcc = oldMap.get(acc.Id);
                    if(oldAcc.Vision_Care_End_Date__c == acc.Vision_Care_End_Date__c){ 
                        isUpdate = false;
                    }
                }       
            }
            system.debug('++++++++++++++++++++++++++++  pracVCEndDate +++++++++++++++++++++++++++++++++++++++++++++' +pracVCEndDate);
            system.debug('++++++++++++++++++++++++++++  isUpdate ++++++++++++++++++++++++++++++++++++++++++++++++++' +isUpdate);
            system.debug('++++++++++++++++++++++++++++  accIDs.size  ++++++++++++++++++++++++++++++++++++++++++++++' + accIDs.size());
           
            
            if(accIDs.size() > 0 && isUpdate == true){
                List<Network_Relationship__c> lstNetRel = [Select Id, Program_End_Date__c, Account_Name__c 
                                                           From Network_Relationship__c 
                                                           where Account_Name__c IN :accIDs AND Program_End_Date__c = null];
                if(lstNetRel.size() > 0){
                    for(Network_Relationship__c nr : lstNetRel){
                        nr.Program_End_Date__c = mapIdWithEndDate.get(nr.Account_Name__c);
                        nr.Bypass_VC_Validation_Rules__c = true;
                        netRelList.add(nr);
                    }           
                }
                
                List<Account> lstAcc = [Select Id, Vision_Care_End_Date__c, Vision_Care_Effective_Date__c 
                                        from Account 
                                        where RecordType.Name = 'Business Account' AND Parent.Id = :pracAccId AND Vision_Care_Effective_Date__c <= TODAY];
                if(lstAcc.size()>0)
                    maxEndDate = lstAcc[0].Vision_Care_End_Date__c;
                
               /*
                if(lstAcc.size() >0){
                    for(Account a : lstAcc){
                        if(a.Vision_Care_End_Date__c == null || a.Vision_Care_End_Date__c > pracVCEndDate){
                            a.Vision_Care_End_Date__c = pracVCEndDate; 
                            busAccList.add(a);
                        }
                    }
                }*/

                
                //         if(busAccList.size() > 0){ 
                //update busAccList;
                //         }
                
                if(lstAcc.size() >0){
                    for(Account acct : lstAcc){
                        if(acct.Vision_Care_End_Date__c == null){ 
                            endDateBlank = true; 
                            break;
                        }
                    }
                }            
                
                if(endDateBlank == false){
                    for(Account account : lstAcc){
                        if(account.Vision_Care_End_Date__c >= maxEndDate){  
                            maxEndDate = account.Vision_Care_End_Date__c;
                        }
                    }
                }
                
                if(endDateBlank == true){ 
                    maxEndDate = null;
                }
                
 //////******Check if Business Account exisits that starts one day past the last end date*****///////////////
                if(maxEndDate != null){
                    Date maxEndDate2 = maxEndDate.addDays(1);
                    List<Account> lstAccMax = [Select Id, Vision_Care_End_Date__c, Vision_Care_Effective_Date__c 
                                               from Account 
                                               where RecordType.Name = 'Business Account' AND Parent.Id = :pracAccId AND Vision_Care_Effective_Date__c <= :maxEndDate2];
                    
                    if(lstAccMax.size()>0)
                        maxEndDate = lstAccMax[0].Vision_Care_End_Date__c;
                    
                    if(lstAccMax.size() >0){
                        for(Account acct : lstAccMax){
                            if(acct.Vision_Care_End_Date__c == null){ 
                                endDateBlank = true; 
                                break;
                            }
                            
                        }
                        
                    } 
                    
                    if(endDateBlank == true){ 
                        maxEndDate = null;
                    }
                    
                    if(endDateBlank == false){
                        for(Account account : lstAccMax){
                            if(account.Vision_Care_End_Date__c >= maxEndDate){  
                                maxEndDate = account.Vision_Care_End_Date__c;
                            }
                        }
                    }
                }  
                //          if(netRelList.size() > 0){
                //update netRelList;
                //           }
                
                if(pracAccId != null){
                    List<Account> a = [Select Parent.Id from Account where RecordType.Name = 'Practice Account' AND Id = :pracAccId];
                    if(a.size()>0){a[0].Vision_Care_End_Date__c = maxEndDate;
                                   a[0].Bypass_VC_Validation_Rules__c = true;
                                   update a[0];
                                  }
                }
            }                    
            
            //        VSPR19b_BypassValidationRules.RemovePermissionSet();
        }
    }
    
}