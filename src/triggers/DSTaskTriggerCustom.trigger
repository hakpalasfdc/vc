trigger DSTaskTriggerCustom on Task (after insert, after update) {
  if(trigger.isInsert){
      
      //ensure DS fields are up to date in sObjects
       DSTaskTriggerHandlerCustom.updateSObjects((List<Task>)trigger.new, 'insert');
      
  }
  
  if (!DSTaskTriggerHandlerCustom.updateComplete)
  {
    if(trigger.isUpdate){
        //only add if updated by backened
        List<Task> tasks = new List<Task>();
        for(Task t : trigger.new){
            Task oldTask = Trigger.oldMap.get(t.id);
            if(oldTask.Subject == 'DialSource Automated Call' ||  oldTask.Subject == 'DialSource Inbound Call'){
                tasks.add(t);
            }
        }
        
        //ensure DS fields are up to date in sObjects
         DSTaskTriggerHandlerCustom.updateSObjects(tasks, 'update');
   }
  }
}