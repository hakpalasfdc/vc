trigger VSPR1_KnowledgeTrigger on Knowledge__kav (before update, before delete) {
    
    VSPR1_KnowledgeTriggerHandler handler = new VSPR1_KnowledgeTriggerHandler();
   if(trigger.isDelete){
        handler.onBefore(Trigger.Old);
    }
    else{
        handler.onBefore(Trigger.New);
   }   
    if(trigger.isBefore && trigger.isUpdate && !trigger.isDelete){
        handler.chatterPost(trigger.new);
    }
}