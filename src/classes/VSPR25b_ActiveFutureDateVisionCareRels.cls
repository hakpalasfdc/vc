public class VSPR25b_ActiveFutureDateVisionCareRels {
    
    public boolean activeFutureDatedVisionCareRels_recursion = true;
    public void activeFutureDatedVisionCareRels(List<Network_Relationship__c> newTrigger,List<Network_Relationship__c> oldRecs){
        
        if(activeFutureDatedVisionCareRels_recursion){
            activeFutureDatedVisionCareRels_recursion = false;
            
            if(trigger.isUpdate || trigger.isInsert){
                Set<id> nrID = new Set<Id>();
                List<Contact_Role__c> crList = new List<Contact_Role__c>();
                
                for(Network_Relationship__c nr : newTrigger) {
                    nrID.add(nr.Contact_Role__c); 
                    Contact_Role__c y = new Contact_Role__c(Id = nr.Contact_Role__c);
                    crList.add(y);  
                }
                
                date todayDate = system.today();
                
                AggregateResult[] countActiveNRs =
                    [SELECT Contact_Role__c contact, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Contact_Role__c =: nrID
                     AND (Program_End_Date__c = NULL
                          OR Program_End_Date__c >=: todayDate)
                     GROUP BY Contact_Role__c];
                
                Map<String, Integer> countActiveNRsMap = new Map<String, Integer>();
                for(Contact_Role__c cX: crList){
                    countActiveNRsMap.put(cX.id,0);
                }
                
                if(!countActiveNRs.isEmpty()){
                    for (AggregateResult ar : countActiveNRs){
                        countActiveNRsMap.put((string)ar.get('contact'),(integer)ar.get('myCount'));
                    }
                }
                
                Set<Contact_Role__c> crUpdateSet = new Set<Contact_Role__c>();
                for(Contact_Role__c cr : crList) {
                    if(countActiveNRsMap.get(cr.Id) != 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = TRUE;
                        crUpdateSet.add(x);
                    }
                    if(countActiveNRsMap.get(cr.Id) == 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = FALSE;
                        crUpdateSet.add(x);
                    }
                }
                
                List<Contact_Role__c> crUpdate = new List<Contact_Role__c>(crUpdateSet);
                if(!crUpdate.isEmpty()){
                    update crUpdate;
                }
            }
            if(trigger.isDelete){
                Set<id> nrID = new Set<Id>();
                List<Contact_Role__c> crList = new List<Contact_Role__c>();
                
                for(Network_Relationship__c nr : oldRecs) {
                    nrID.add(nr.Contact_Role__c); 
                    Contact_Role__c y = new Contact_Role__c(Id = nr.Contact_Role__c);
                    crList.add(y);  
                }
                
                date todayDate = system.today();
                
                AggregateResult[] countActiveNRs =
                    [SELECT Contact_Role__c contact, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Contact_Role__c =: nrID
                     AND (Program_End_Date__c = NULL
                          OR Program_End_Date__c >=: todayDate)
                     GROUP BY Contact_Role__c];
                
                Map<String, Integer> countActiveNRsMap = new Map<String, Integer>();
                for(Contact_Role__c cX: crList){
                    countActiveNRsMap.put(cX.id,0);
                }
                
                if(!countActiveNRs.isEmpty()){
                    for (AggregateResult ar : countActiveNRs){
                        countActiveNRsMap.put((string)ar.get('contact'),(integer)ar.get('myCount'));
                    }
                }
                
                Set<Contact_Role__c> crUpdateSet = new Set<Contact_Role__c>();
                for(Contact_Role__c cr : crList) {
                    if(countActiveNRsMap.get(cr.Id) != 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = TRUE;
                        crUpdateSet.add(x);
                    }
                    if(countActiveNRsMap.get(cr.Id) == 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = FALSE;
                        crUpdateSet.add(x);
                    }
                }
                
                List<Contact_Role__c> crUpdate = new List<Contact_Role__c>(crUpdateSet);
                if(!crUpdate.isEmpty()){
                    update crUpdate;
                }
            }
        }
        
    }
}