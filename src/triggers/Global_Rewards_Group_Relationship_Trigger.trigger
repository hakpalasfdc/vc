trigger Global_Rewards_Group_Relationship_Trigger on Global_Rewards_Group_Relationship__c (after insert, after update, after delete, before insert, before update, before delete) {
    
    if(trigger.isAfter){
        if(trigger.isInsert || trigger.isUpdate) {
            
            VSPR31_Update_GRG_End_Date updGrgEndDate = new VSPR31_Update_GRG_End_Date();
            updGrgEndDate.VSPR31_Update_GRG_End_Date(trigger.new,trigger.oldmap);
            
        }
    }
    
    if(trigger.isBefore){
        if(trigger.isInsert || trigger.isUpdate){
            
            VSPR31_GRGR_Validation.new_VSPR31_GRG_Validation(trigger.new);

        }
        if(trigger.isDelete){
            VSPR31_GRGR_Validation.delete_VSPR31_GRG_Validation(trigger.old);
        }
    }
}