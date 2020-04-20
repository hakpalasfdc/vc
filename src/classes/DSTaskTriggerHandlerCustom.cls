public class DSTaskTriggerHandlerCustom {

   public static boolean updateComplete = False; 

   public static void updateSObjects(List<Task> TaskList, string kind){
      Map<Id,String> records = new Map<Id,String>();
    
      //Build list of recently dispositioned ID's
      for(Task t : TaskList){
          //ensure task is DS related
          if( (!(String.isBlank(t.DialSource__Call_Disposition_DS__c)) && kind == 'update') || ((t.Subject == 'DialSource Automated Call' ||  t.Subject == 'DialSource Inbound Call') && kind == 'insert') ) {
              //Add using whatID
              if(t.WhatId != NULL){
                  records.put(t.WhatId, t.DialSource__Call_Disposition_DS__c);  
              }
              
              //Add using whoId
              if(t.WhoId != NULL){
                  records.put(t.WhoId, t.DialSource__Call_Disposition_DS__c);    
              }
         }
      }
       
      //create and call queuable class to update DS fields 
      if(records.size() > 0){
          try{
              DSUpdateFieldsCustomVSP updateDS = new DSUpdateFieldsCustomVSP(records, kind);
              updateDS.updateFields();
          }
          catch(exception e){
              System.debug('Failed to enqueue batch job.  Error: ' + e);
          } 

          if (kind == 'update')
            updateComplete = True; 
      }
     
  }
  
}