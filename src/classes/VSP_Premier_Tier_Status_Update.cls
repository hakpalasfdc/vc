public class VSP_Premier_Tier_Status_Update {
    
    public static boolean VSP_Premier_Tier_Status_Update_recursion = true;
    public void VSP_Premier_Tier_Status_Update(List<Premier_Tier__c> newTrigger, Map<Id,Premier_Tier__c> oldRecs){
        
        if(VSP_Premier_Tier_Status_Update_recursion){
            VSP_Premier_Tier_Status_Update_recursion = false;
            system.debug('*****entered VSP_Premier_Tier_Status_Update ****');
            
            Set<Id> TierStatusUpdate = new Set<Id>();
            
            for(Premier_Tier__c nT: newTrigger){
                
                system.debug('***** oldRecs ***** ' + oldRecs);
                
                if(oldRecs != null){
                    if(nT.Effective_Date__c != oldRecs.get(nT.Id).Effective_Date__c ||
                       nT.End_Date__c != oldRecs.get(nT.Id).End_Date__c){
                           
                           TierStatusUpdate.add(nT.Id);
                           
                       }
                    
                }
                
                else{
                    
                    TierStatusUpdate.add(nT.Id);
                }
            }
            
            
            if(!TierStatusUpdate.isEmpty()){
                
                List<Premier_Tier__c> TierToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c Where Id in :TierStatusUpdate];
                
                for(Premier_Tier__c updTier :allTiers){
                    
                    if(updTier.Effective_Date__c > Date.today()){
                        updTier.Status__c = 'Future';
                    }
                    else if(updTier.Effective_Date__c <= Date.today() && (updTier.End_Date__c >= Date.today() || updTier.End_Date__c == NULL)){
                        updTier.Status__c = 'Active';
                    }
                    else{
                        updTier.Status__c = 'Inactive';
                    }
                    TierToUpdate.add(updTier);
                }
                 system.debug('TierToUpdate List '+ TierToUpdate);
                if(!TierToUpdate.isEmpty()){
                    update TierToUpdate;
                }
            
            }
        }
        
    }
    
}