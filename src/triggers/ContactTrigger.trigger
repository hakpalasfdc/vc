trigger ContactTrigger on Contact (after insert, after update, after delete, before insert, before update) { 
    
    if(Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ContactTrigger_Handler.validateContact(Trigger.new); 
        ContactTrigger_Handler.validateDocID(Trigger.new,Trigger.oldMap);
    }
    
    
    if(trigger.isAfter ){ 
        if(trigger.isInsert) {
            ContactTrigger_Handler.VisionCareEndDate(Trigger.New);
        }
        
        if(trigger.isUpdate){
            ContactTrigger_Handler.VisionCareEndDate(Trigger.New);
            
            VSPR19b_AddContactExctoRelatedNetRels addException = new VSPR19b_AddContactExctoRelatedNetRels();
            addException.VSPR19b_AddContactExctoRelatedNetRels(trigger.new, trigger.oldmap, true);
                  
            VSPR30_UpdateNetRelRoleID updateRoleID = new VSPR30_UpdateNetRelRoleID();
            updateRoleID.VSPR30_UpdateNetRelRoleID_From_Contact(trigger.new,trigger.oldmap);
            
        }
        
    }
    
    
}