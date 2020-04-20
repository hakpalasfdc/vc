global class VSPR33_Con_Role_VSP_Net_Provider_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    // Private Date todaysDate = Date.today();
    global List<String> exception_List = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, VSP_Network_Provider__c FROM Contact_Role__c
                                         WHERE Id IN (SELECT Contact_Role__c FROM Network_Relationship__c
                                                      WHERE Program_Effective_Date__c = :Date.today() OR Program_End_Date__c = :Date.today() - 1)]);
        
        
        /*      SELECT Id, Contact_Role__c FROM Network_Relationship__c
WHERE Program_Effective_Date__c = :Date.today() OR Program_End_Date__c = :Date.today() - 1]);*/
    }
    
    global void execute(Database.BatchableContext BC, List<Contact_Role__c> scope){
        
        
        Map<Id, Contact_Role__c> cRolesMap = new Map<Id, Contact_Role__c>();
        Set<Contact_Role__c> cRolesToUpdateSet = new Set<Contact_Role__c>();
        Set<Id> cRoles = new Set<Id>();
        map<String,Integer> countTotal = new Map<String,Integer>();
        
        for(Contact_Role__c s : scope){
            cRolesMap.put(s.Id,s);
            cRoles.add(s.Id);
            
        }
        
        if(!cRolesMap.isEmpty()){
            
            AggregateResult[] netRelCounts = [SELECT Contact_Role__c Id, COUNT(Id) netRelCount FROM Network_Relationship__c 
                                              WHERE Contact_Role__c =: cRolesMap.keySet() 
                                              AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                                              AND Program_Effective_Date__c <= TODAY
                                              GROUP BY Contact_Role__c];
            
            for(AggregateResult ar : netRelCounts){
                countTotal.put((string)ar.get('Id'), (Integer)ar.get('netRelCount'));
            }
            
            for(Contact_Role__c nr: cRolesMap.values()){
                if(countTotal.get(nr.Id) > 0){
                    if(nr.VSP_Network_Provider__c == FALSE){
                        Contact_Role__c crX = new Contact_Role__c(Id=nr.Id);
                        crX.VSP_Network_Provider__c = TRUE;
                        cRolesToUpdateSet.add(crX);  
                    }
                }else{
                    if(nr.VSP_Network_Provider__c == TRUE){
                        Contact_Role__c crX = new Contact_Role__c(Id=nr.Id);
                        crX.VSP_Network_Provider__c = FALSE;
                        cRolesToUpdateSet.add(crX);
                    }
                }          
            }
            
            
            List<Contact_Role__c> cRolesToUpdate = new List<Contact_Role__c>(cRolesToUpdateSet);
            if(!cRolesToUpdate.isEmpty()){
                //   update cRolesToUpdate;
                //   
                Database.SaveResult[] SaveResultList = Database.update(cRolesToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Contact Role Record Id: ' + cRolesToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
            
        }
    }
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}