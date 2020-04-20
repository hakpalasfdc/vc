trigger QAReviewTrigger on QA_Review__c (before insert, before update,before delete, after insert, after update, after delete, after undelete) {
    
    if(trigger.isAfter ){ 
        if(trigger.isInsert || trigger.isUpdate) {
            
            QAReviewTrigger_Handler.VSP_QA_Review_Update(trigger.new,trigger.oldmap);
        }
    }
}