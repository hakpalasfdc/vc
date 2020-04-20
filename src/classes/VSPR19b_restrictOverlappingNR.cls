public class VSPR19b_restrictOverlappingNR {
    
    public static boolean goDo_recursion = true;
    public static void goDo(List<Network_Relationship__c> records) 
    {
        if(goDo_recursion){
        goDo_recursion = false;
        
            List<Profile> getUserProfile = [SELECT Id, Name FROM Profile WHERE Id=:userinfo.getProfileId() LIMIT 1];
            String profileName = getUserProfile[0].Name;
            
            Map<Id,Account> netRelAccMap = new Map<Id,Account>();
            Set<Id> netRelAccIds = new Set<Id>();
            for(Network_Relationship__c netRels : records){
                netRelAccIds.add(netRels.Account_Name__c);
            }
            if(!netRelAccIds.isEmpty()){
                for(Account nRAcc : [SELECT Id, Vision_Care_Location_Key__c FROM Account WHERE Id IN :netRelAccIds]){
                    netRelAccMap.put(nrAcc.Id, nrAcc);
                }
            }     
            
            List<String> cRoles = new List<String>();
            for(Network_Relationship__c y : records){
                cRoles.add(y.Contact_Role__c);
            }
                 
            List<Network_Relationship__c> nrRecs = 
                [SELECT Id, Contact_Role__c, Program_ID__c, Program_End_Date__c, Vision_Care_Location_Key__c
                 FROM Network_Relationship__c
                 WHERE Contact_Role__c =: cRoles
                 AND Id !=: records
                 AND Bypass_VC_Validation_Rules__c = FALSE];
                        
            if(!nrRecs.isEmpty()){
                for(Network_Relationship__c z : records){
                    for(Network_Relationship__c x : nrRecs){
                        if(x.Contact_Role__c == z.Contact_Role__c &&
                           x.Program_ID__c == z.Program_ID__c &&
                           x.Vision_Care_Location_Key__c == netRelAccMap.get(z.Account_Name__c).Vision_Care_Location_Key__c &&  /// Allow overlapping Net Rels if Vision Care Location Keys are different
                           (
                            ((x.Program_End_Date__c >= z.Program_End_Date__c) && z.Program_End_Date__c != NULL)
                            ||
                            (x.Program_End_Date__c == NULL && z.Program_End_Date__c != NULL)
                            ||
                            (x.Program_End_Date__c != NULL && z.Program_End_Date__c == NULL && (z.Program_Effective_Date__c <= x.Program_End_Date__c))
                            ||
                            (x.Program_End_Date__c == NULL && z.Program_End_Date__c == NULL)
                           )){
                            if(profileName != 'VSP Technical User' &&
                               profileName != 'System Administrator' &&
                               profileName != 'VSP Integration User' &&
                               z.Bypass_VC_Validation_Rules__c == FALSE){
    
                                z.addError('Network Relationship effective dates must not overlap with existing Network Relationship records.');
                            }
                        }
    
                    }
                }
            }
        }
    }

}