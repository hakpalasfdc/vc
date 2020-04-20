trigger Premier_Tier_Trigger on Premier_Tier__c (before insert, before update,before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore){
        
        if(trigger.isInsert || trigger.isupdate){
            
            VSP_Premier_Tier_Dupe_Validation.checkVSP_Premier_Tier_Dupe_Validation(trigger.new, Trigger.oldmap);
        }
        if(trigger.isInsert){
            VSPR32_Premier_Tier_Auto_Number.set_Auto_Number(trigger.new);
        }
        
        if(trigger.isDelete){
            
            VSP_Premier_Tier_Hierarchy updateTierHierarchy = new VSP_Premier_Tier_Hierarchy();
            updateTierHierarchy.VSP_Tier_Hierarchy_Delete(Trigger.isDelete ? trigger.old : trigger.New,Trigger.oldmap);
            
            VSPR32_Premier_Tier_Auto_Number.skip_Auto_Number(Trigger.oldmap);
            
        }
    }
    
    
    if(Trigger.isAfter){
        if(trigger.isInsert || trigger.isupdate){
            
            VSP_Premier_Tier_Status_Update updateStatus = new VSP_Premier_Tier_Status_Update();
            updateStatus.VSP_Premier_Tier_Status_Update(trigger.new,trigger.oldmap);
            
            VSP_Premier_Tier_Hierarchy updateTierHierarchy = new VSP_Premier_Tier_Hierarchy();
            updateTierHierarchy.VSP_Tier_Hierarchy_Update(trigger.new,trigger.oldmap);
            
        } 
    }
}