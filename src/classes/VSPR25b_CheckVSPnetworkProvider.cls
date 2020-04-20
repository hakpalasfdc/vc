public class VSPR25b_CheckVSPnetworkProvider {
    
    public static boolean VSPR19b_checkVSPnetworkProviderMethod_recursion = true;
    public void VSPR19b_checkVSPnetworkProviderMethod(List<Network_Relationship__c> oldRecs, List<Network_Relationship__c> newRecs, Map<Id,Network_Relationship__c> oldRecsMap){
        
        if(VSPR19b_checkVSPnetworkProviderMethod_recursion){// || test.isRunningTest()){
            VSPR19b_checkVSPnetworkProviderMethod_recursion = false;
            
            system.debug('***** entered VSPR19b_checkVSPnetworkProviderMethod ***** ');
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            Set<Contact_Role__c> cRolesToUpdateSet = new Set<Contact_Role__c>();
            if(trigger.isUpdate || trigger.isInsert){
      //          system.debug('******* IS UPDATE ********');
    /*            List<Network_Relationship__c> netRel = 
                    [SELECT Id, Name, Program_Effective_Date__c, Program_End_Date__c, Contact_Role__r.Name, 
                     Contact_Role__r.Id, Contact_Role__r.VSP_Network_Provider__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Id =: newRecs];*/
                
                Set<string> cRoles = new Set<string>();
                for (Network_Relationship__c x : newRecs){
                    if(x.Contact_Role__c != NULL){
                        cRoles.add(x.Contact_Role__c);
                    }
                }
                
                map<string,Integer> count1 = new Map<string,Integer>();
                AggregateResult[] netRelCounts = 
                    [SELECT Contact_Role__c Id, COUNT(Id) netRelCount 
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY
                     GROUP BY Contact_Role__c];
                system.debug('netRelCounts: '+netRelCounts);
                for(AggregateResult ar : netRelCounts){
                    count1.put((string)ar.get('Id'), (Integer)ar.get('netRelCount'));
                }
                system.debug('count1: '+count1);   
                
                for(Network_Relationship__c nr: newRecs){
                    if(trigger.isInsert){
                        if(count1.get(nr.Contact_Role__c) > 0){
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = TRUE;
                            cRolesToUpdateSet.add(crX);  
                        }else{
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = FALSE;
                            cRolesToUpdateSet.add(crX);
                        }          
                    }
                    else if((oldRecsMap.get(nr.Id).Program_End_Date__c != nr.Program_End_Date__c) || (oldRecsMap.get(nr.Id).Program_Effective_Date__c != nr.Program_Effective_Date__c)){
                        if(count1.get(nr.Contact_Role__c) > 0){
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = TRUE;
                            cRolesToUpdateSet.add(crX);  
                        }else{
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = FALSE;
                            cRolesToUpdateSet.add(crX);
                        }                      
                    }            
                }
            }
            
            if(trigger.isDelete){
                
      /*          List<Network_Relationship__c> netRel = 
                    [SELECT Id, Name, Program_Effective_Date__c, Program_End_Date__c, Contact_Role__r.Name, 
                     Contact_Role__r.Id, Contact_Role__r.VSP_Network_Provider__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Id =: oldRecs];*/
                
   //             Map<Id, Network_Relationship__c> netRelMap = new Map<Id, Network_Relationship__c>([SELECT Id, Contact_Role__r.Id FROM Network_Relationship__c WHERE 
    //                                                                                               Id =: oldRecs AND Contact_Role__c != NULL]);
                Set<string> cRoles = new Set<string>();
                for (Network_Relationship__c x : oldRecs){
                    if(x.Contact_Role__c != NULL){
                        cRoles.add(x.Contact_Role__c);
                    }
                }
                
                map<string,Integer> count1 = new Map<string,Integer>();
                AggregateResult[] netRelCounts = 
                    [SELECT Contact_Role__c Id, COUNT(Id) netRelCount 
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY
                     GROUP BY Contact_Role__c];
                system.debug('netRelCounts: '+netRelCounts);
                for(AggregateResult ar : netRelCounts){
                    count1.put((string)ar.get('Id'), (Integer)ar.get('netRelCount'));
                }
                system.debug('count1: '+count1);   
                
                for(Network_Relationship__c nr: oldRecs){      
              //      if(oldRecsMap.get(nr.Id).Program_End_Date__c != nr.Program_End_Date__c){
                        if(count1.get(nr.Contact_Role__c) > 0){
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = TRUE;
                            cRolesToUpdateSet.add(crX);  
                        }else{
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = FALSE;
                            cRolesToUpdateSet.add(crX);
                        }                      
                //    }            
                }
            }  
            
            List<Contact_Role__c> cRolesToUpdate = new List<Contact_Role__c>(cRolesToUpdateSet);
            if(!cRolesToUpdate.isEmpty()){
                update cRolesToUpdate;
            }
        }
    }
}