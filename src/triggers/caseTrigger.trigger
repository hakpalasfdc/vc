trigger caseTrigger on Case (before insert, before update, after insert, after update, after delete, after undelete) {
    if(trigger.isBefore){
       
        if(trigger.isInsert){
            
            VSPR3_CaseBL updateFields = new VSPR3_CaseBL();
            updateFields.CaseBeforeTriggerMethod(trigger.new);
            updateFields.cRoleCasesBeforeTriggerMethod(trigger.new);
            
            VSPR26_PopulateResolutionContact updateResolution = new VSPR26_PopulateResolutionContact();
            updateResolution.setResolution(trigger.new, trigger.oldMap);     
            
            VSPR34_Mask9DigitCase.Mask9DigitCaseInsert(trigger.new);
        }
        if(trigger.isUpdate){
            VSPR26_PopulateResolutionContact updateResolution = new VSPR26_PopulateResolutionContact();
            
            updateResolution.setResolution(trigger.new, trigger.oldMap); 
            
            VSPR2_PreChatCaseContactUpdate.setCaseContact(trigger.newMap, trigger.oldMap);
            
            VSPR34_Mask9DigitCase.Mask9DigitCaseUpdate(trigger.new, trigger.oldMap);
        }
    }
    if(trigger.isAfter){
        
        if(trigger.isInsert){
            
            VSPR34_CaseAutoAssign.setPracticeAccountProdAssets(trigger.new);
            
            VSPR34_AutoContactCreation.AutoContactCreation(trigger.new);
            
        }
    }
}