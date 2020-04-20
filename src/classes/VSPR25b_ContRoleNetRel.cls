public class VSPR25b_ContRoleNetRel {
    
    public static boolean conRoleNetRelAfterTriggerMethod_recursion = true;
    public void conRoleNetRelAfterTriggerMethod(List<Network_Relationship__c> newTrigger){
        
        if(conRoleNetRelAfterTriggerMethod_recursion){
            conRoleNetRelAfterTriggerMethod_recursion = false;
            
            system.debug('***** entered conRoleNetRelAfterTriggerMethod ***** ');
            
            List<Network_Relationship__c> listNRWithSameContactRole = new List<Network_Relationship__c>(); 
            Set<Network_Relationship__c> uniqueSet = new Set<Network_Relationship__c>();  
            List<Network_Relationship__c> noDups = new List<Network_Relationship__c>();    
            Boolean ProfileMatch = false; 
            Boolean isUpdate = false; 
            Boolean permissionSetFound = false; 
            Id profileId = userinfo.getProfileId();  
            Id currentUserId = userInfo.getUserid(); 
            Set<Id> ids = new Set<Id>();  
            Set<ID> setNetRelRoleIds = new Set<ID>();
            Set<id> conID=new Set<Id>();
            String profileName = [SELECT Id, Name 
                                  FROM Profile 
                                  WHERE Id = :profileId].Name;
            
            List<PermissionSetAssignment> listPSA = [SELECT id, PermissionSetId 
                                                     FROM PermissionSetAssignment 
                                                     WHERE AssigneeId = :currentUserId];  
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            
            
            for(PermissionSetAssignment PSA : listPSA)  {  
                ids.add(PSA.PermissionSetId); 
            }
            
            List<PermissionSet> listPS = [SELECT name 
                                          FROM PermissionSet 
                                          WHERE id IN:ids];          
            
            for(PermissionSet PS: listPS) { 
                if(PS.Name == 'Credentialing_Data_Manager')  permissionSetFound = true; 
            }   
            
            if(profileName == 'VSP Network Recruitment User' || 
               profileName == 'VSP Network Recruitment Management User' ||
               (permissionSetFound == true )) { ProfileMatch = true; }        
            
            
            for(Network_Relationship__c netRels: newTrigger){  
                if(netRels.Contact_Role__c != null) 
                    setNetRelRoleIds.add(netRels.Contact_Role__c); 
                    conID.add(netRels.Provider_Name__c);
            }   
            
            List<Network_Relationship__c> listTest = [SELECT ID, Program_End_Date__c, Program_ID__r.Name, Contact_Role__c 
                                                      FROM Network_Relationship__c 
                                                      WHERE Program_ID__r.Name = 'VSP' 
                                                      AND Program_End_Date__c != null 
                                                      AND Contact_Role__c IN : setNetRelRoleIds];   
            
            map<String,list<Network_Relationship__c>> mpNRs = new map<String,list<Network_Relationship__c>>();
            for(Network_Relationship__c nr : [SELECT ID, Program_End_Date__c, Program_ID__r.Name,Contact_Role__c 
                                              FROM Network_Relationship__c 
                                              WHERE Contact_Role__c =: setNetRelRoleIds AND ID NOT IN :newTrigger]) {
                                                  if(!mpNRs.containskey(nr.Contact_Role__c)) {
                                                      mpNRs.put(nr.Contact_Role__c,new list<Network_Relationship__c>());
                                                  }
                                                  mpNRs.get(nr.Contact_Role__c).add(nr);
                                              }
            if(listTest.size() > 0) { 
                for(Network_Relationship__c nrOne : listTest) {
                    if(mpNRs.containsKey(nrOne.Contact_Role__c)) listNRWithSameContactRole = mpNRs.get(nrOne.Contact_Role__c); 
                    
                    if(listNRWithSameContactRole.size() >= 1){  
                        for(Network_Relationship__c nrc : listNRWithSameContactRole) {
                            if(nrc.Program_End_Date__c == NULL || nrc.Program_End_Date__c  > nrOne.Program_End_Date__c) { 
                                if(ProfileMatch) { 
                                    if(nrOne.Program_End_Date__c != null && !(nrOne.Program_End_Date__c < Date.Today())) {   
                                        nrc.Program_End_Date__c = nrOne.Program_End_Date__c; uniqueSet.add(nrc); 
                                    } 
                                } 
                            } 
                        }
                    } 
                } 
            }   
            
            for (Network_Relationship__c n : uniqueSet) { 
                noDups.add(n); 
            }if(noDups.size() > 0) { 
                database.update(noDups,false); 
                
                if(!conID.isEmpty()){///update contact and exclude noDups in Query below
                    
                    Map<String,Date> maxEndDateMap = new Map<String,Date>();
                    Map<String,Date> ActivemaxEndDateMap = new Map<String,Date>();
                    Map<String,Date> ActiveBlankEndDateMap = new Map<String,Date>();
                    Set<Contact> updateConSet =new Set<Contact>();
                    List<Network_Relationship__c> ActivemaxEndDateList = 
                        [SELECT id,Program_End_Date__c,Contact_Role__r.Contact__c, Provider_Name__c
                         FROM Network_Relationship__c 
                         WHERE Contact_Role__r.Contact__c in : conID AND Program_End_Date__c !=NULL AND Id NOT IN :noDups
                         ORDER BY Program_End_Date__c ASC];
                    
                    List<Network_Relationship__c> ActiveBlankEndDateList = 
                        [SELECT id,Program_End_Date__c,Contact_Role__r.Contact__c, Provider_Name__c
                         FROM Network_Relationship__c 
                         WHERE Contact_Role__r.Contact__c in : conID AND Program_End_Date__c = NULL AND Id NOT IN :noDups];
                    
                    
                    system.debug('ActivemaxEndDateList ' + ActivemaxEndDateList);
                    system.debug('ActiveBlankEndDateList ' + ActiveBlankEndDateList);
                    
                    for(Network_Relationship__c accX: ActivemaxEndDateList){
                        ActivemaxEndDateMap.put(accX.Provider_Name__c,accX.Program_End_Date__c);
                    }
                    
                    for(Network_Relationship__c accX: ActiveBlankEndDateList){
                        ActiveBlankEndDateMap.put(accX.Provider_Name__c,accX.Program_End_Date__c);
                    }
                    
                    system.debug('ActivemaxEndDateMap' + ActivemaxEndDateMap);
                    system.debug('ActiveBlankEndDateMap '+ ActiveBlankEndDateMap);
                    List<Contact> contoUpdtoActive = 
                        [SELECT id,Vision_Care_End_Date__c, Vision_Care_Term_Reason__c
                         FROM Contact 
                         WHERE Id =: conID]; 
                    
                    
                    List<General_Table__c> GT_List = new List<General_Table__c>();
                    
                    for(General_Table__c GT : [SELECT id FROM General_Table__c WHERE Name = '1PRC' AND Table__c = 'PRS6' AND Status__c = 'Active']){
                        GT_List.add(GT);
                    }        
                    
                    for(Contact actCon: contoUpdtoActive){                 
                        if(ActiveBlankEndDateMap.keySet().contains(actCon.Id)){
                            actCon.Vision_Care_End_Date__c = null;
                            actCon.Bypass_VC_Validation_Rules__c = true;
                            updateConSet.add(actCon);
                        }
                        else{
                            if(!GT_List.isEmpty()){
                                actCon.Vision_Care_End_Date__c = ActivemaxEndDateMap.get(actCon.Id);
                                actCon.Vision_Care_Term_Reason__c = GT_List[0].id;
                                actCon.Bypass_VC_Validation_Rules__c = true;
                                updateConSet.add(actCon);  
                            }
                            else{
                                actCon.Vision_Care_End_Date__c = ActivemaxEndDateMap.get(actCon.Id);
                                actCon.Bypass_VC_Validation_Rules__c = true;
                                updateConSet.add(actCon);  
                                
                            }
                        }                    
                    }
                    List<Contact> updateCon = new List<Contact>(updateConSet);
                    if(!updateCon.isEmpty()){
                        update updateCon;
                    } 
                }
                
            } 
            
            system.debug('***** exiting conRoleNetRelAfterTriggerMethod ***** ');
        }
    } 
}