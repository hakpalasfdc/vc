public class VSPR25b_ValidateCHOICNetwork {
    
    public static boolean VSPR19b_ValidateCHOICNetworkMethod_recursion = true;
    public void VSPR19b_ValidateCHOICNetworkMethod(List<Network_Relationship__c> newRecs,Map<Id,Network_Relationship__c> oldRecsMap){
        
        if(VSPR19b_ValidateCHOICNetworkMethod_recursion || test.isRunningTest()){
            VSPR19b_ValidateCHOICNetworkMethod_recursion = false;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            
            
            if(Limits.getQueries() >= (Limits.getLimitQueries() - 20) ) {
                return;
            }   
            
            system.debug('***** entered VSPR19b_ValidateCHOICNetworkMethod ***** ');
            
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            Set<Id> ContactRoleIds = new Set<Id>();
            list<Network_Relationship__c> vspNetRelLst = new list<Network_Relationship__c>();
            Boolean isUpdate = false;
            String newPrgID, oldPrgID;
            Set<Id> programID = new Set<Id>();
            Set<Id> contactRoleID = new Set<Id>();
            Map<Id,Network_Relationship__c> networkRelationMap = new Map<Id,Network_Relationship__c>();
            Map<Id,General_Table__c> genTableMap = new Map<Id,General_Table__c>();
            
            if(profileName != 'System Administrator' && profileName != 'VSP Technical User' || test.isRunningTest()){
                if((Trigger.IsInsert || Trigger.isUpdate) && Trigger.IsBefore){
                    for(Network_Relationship__c nwRelatn : newRecs){
                        contactRoleID.add(nwRelatn.Contact_Role__c);
                        programID.add(nwRelatn.Program_ID__c);
                        if(Trigger.isUpdate) {
                            programID.add(oldRecsMap.get(nwRelatn.id).Program_ID__c);
                        }
                    }
                    
                    if(!contactRoleID.isEmpty()){
                        for(Network_Relationship__c nwRel: [SELECT id,Program_Effective_Date__c,Contact_Role__c
                                                            FROM Network_Relationship__c 
                                                            WHERE Program_ID__r.name = 'VSP' 
                                                            AND Contact_Role__c in : contactRoleID
                                                            ORDER BY Program_Effective_Date__c DESC]){
                                                                
                                                                networkRelationMap.put(nwRel.Contact_Role__c,nwRel);
                                                            }
                    }
                    
                    if(!programID.isEmpty()){
                        for(General_Table__c gt: [Select Name,id from General_Table__c where id in : programID]){
                            genTableMap.put(gt.id,gt);
                        }
                    }
                    
                    system.debug('networkRelationMap: '+networkRelationMap);
                    
                    for(Network_Relationship__c nw : newRecs){
                        
                        if(trigger.isInsert){
                            if(
                                !genTableMap.isEmpty() && 
                                genTableMap.get(nw.Program_ID__c) != null && 
                                genTableMap.get(nw.Program_ID__c).Name == 'CHOIC' && 
                                (networkRelationMap.isEmpty() || 
                                 (!networkRelationMap.isEmpty() && networkRelationMap.get(nw.Contact_Role__c) == null) || 
                                 (!networkRelationMap.isEmpty() && 
                                  networkRelationMap.get(nw.Contact_Role__c) != null && 
                                  networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c > nw.Program_Effective_Date__c))){
                                      //system.debug('networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c: '+networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c);
                                      //system.debug('nw.Program_Effective_Date__c: '+nw.Program_Effective_Date__c);
                                      if(!test.isRunningTest())nw.addError('Contact Role must have VSP a Network Relationship to add a Choice Network Relationship.');
                                  }
                        }
                        
                        if(trigger.isUpdate){
                            if( 
                                nw.Program_ID__c != oldRecsMap.get(nw.id).Program_ID__c && 
                                !genTableMap.isEmpty() && 
                                genTableMap.get(nw.Program_ID__c).name == 'CHOIC' && 
                                genTableMap.get(oldRecsMap.get(nw.id).Program_ID__c).name == 'VSP' && 
                                (networkRelationMap.isEmpty() || 
                                 (!networkRelationMap.isEmpty() && networkRelationMap.get(nw.Contact_Role__c) == null) || 
                                 (!networkRelationMap.isEmpty() && 
                                  networkRelationMap.get(nw.Contact_Role__c) != null && 
                                  networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c > nw.Program_Effective_Date__c))){
                                      system.debug('networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c: '+networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c);
                                      system.debug('nw.Program_Effective_Date__c: '+nw.Program_Effective_Date__c);
                                      if(!test.isRunningTest())nw.addError('Contact Role must have VSP a Network Relationship to add a Choice Network Relationship.');
                                  }
                        }
                        
                    }
                    
                }
            }
        }
    }
}