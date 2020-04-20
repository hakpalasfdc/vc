trigger Premier_Benefit_Trigger on Premier_Benefit__c (before insert, before update,before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore){
        
        if(trigger.isInsert || trigger.isUpdate){
            
            VSP_Premier_Benefit_Dupe_Validation.VSP_Premier_Benefit_Dupe_Validation(trigger.new);
            
        }
        if(trigger.isDelete){
            VSP_Premier_Benefit_Dupe_Validation.delete_VSPR32_VSP_Premier_Benefit_Validation(trigger.old);
        }
    }
}