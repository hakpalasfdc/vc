public class VSP_Premier_Tier_Dupe_Validation {
    public static boolean VSP_Premier_Tier_Dupe_Validation_Recursion = true;
    public static void checkVSP_Premier_Tier_Dupe_Validation(List<Premier_Tier__c> newTierRecsLst, Map<Id,Premier_Tier__c> oldTierRecsMap){
        if(VSP_Premier_Tier_Dupe_Validation_Recursion){
            VSP_Premier_Tier_Dupe_Validation_Recursion = false;
            
            List<Profile> getUserProfile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
            String profileName = getUserProfile[0].Name;           
            List<String> nTierList = new List<String>();
            List<Premier_Tier__c> exTierList = new List<Premier_Tier__c>();
            
            for(Premier_Tier__c nTier : newTierRecsLst){
                if(oldTierRecsMap != null){
                    if(nTier.Name != oldTierRecsMap.get(nTier.Id).Name || nTier.Effective_Date__c != oldTierRecsMap.get(nTier.Id).Effective_Date__c || nTier.End_Date__c != oldTierRecsMap.get(nTier.Id).End_Date__c){
                        nTierList.add(nTier.Name);
                    }
                }
                else{
                    nTierList.add(nTier.Name);
                }
            }
            System.debug('New Tier Record Name = ' + nTierList);
            if(!nTierList.isEmpty()){
                
                exTierList = [SELECT Id, Name, Effective_Date__c, End_Date__c, Status__c, Contract_Type__c, Agreement_Type__c 
                              FROM Premier_Tier__c 
                              WHERE //Name IN : nTierList                                                
                              //     AND Id != :newTierRecsLst
                              //  AND
                              (Status__c = 'Active' OR Status__c = 'Future')];
                               
                //Compare the new Tier record with an existing Tier if found.
                if(!exTierList.isEmpty()){
                    
                    String newName;
                    String exTierName;
                    Boolean errorAdded = False;
                    for(Premier_Tier__c nTier : newTierRecsLst){
                        for(Premier_Tier__c exTier : exTierList){ 
                            //Check if it's a duplicate Tier. Fail it if it is.
                            if(exTier.Id != nTier.Id && exTier.Name == nTier.Name && exTier.Contract_Type__c == nTier.Contract_Type__c 
                               && (nTier.Agreement_Type__c == exTier.Agreement_Type__c || nTier.Agreement_Type__c == null && exTier.Agreement_Type__c == null) &&
                               (
                                   ((exTier.End_Date__c == null || nTier.Effective_Date__c <= exTier.End_Date__c) 
                                    && (nTier.End_Date__c == null || exTier.Effective_Date__c <= nTier.End_Date__c)
                                    && (nTier.End_Date__c == null || nTier.Effective_Date__c <= nTier.End_Date__c)
                                    && (exTier.End_Date__c == null || exTier.Effective_Date__c <= exTier.End_Date__c)
                                   ))){
                                       if(profileName != 'VSP Technical User' && 
                                          profileName != 'System Administrator'){
                                              errorAdded = True;
                                              nTier.addError('Tier with same Name, Agreement Type and Contract Type exists within the date range');                                     
                                          }
                                   }
                            if(exTier.Name.deleteWhitespace().toLowerCase() == nTier.Name.deleteWhitespace().toLowerCase() && errorAdded == False && profileName != 'VSP Technical User' && profileName != 'System Administrator'){
                                if(exTier.Id != nTier.Id && 
                                   ((exTier.End_Date__c == null || nTier.Effective_Date__c <= exTier.End_Date__c) 
                                    && (nTier.End_Date__c == null || exTier.Effective_Date__c <= nTier.End_Date__c)
                                    && (nTier.End_Date__c == null || nTier.Effective_Date__c <= nTier.End_Date__c)
                                    && (exTier.End_Date__c == null || exTier.Effective_Date__c <= exTier.End_Date__c)
                                   )){
                                       nTier.addError('Tier Name must be unique');
                                   }
                            }  
                        }  
                    }
                }            
            }
            
        }        
    }
}