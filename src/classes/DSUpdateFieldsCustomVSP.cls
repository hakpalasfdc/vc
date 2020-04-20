global class DSUpdateFieldsCustomVSP {
  private Map<Id,String> records;
  List<List<sObject>> objects = new List<List<sObject>>();
  string kind;
  
  public DSUpdateFieldsCustomVSP(Map<Id,String> records, string kind){
      this.records = records;
      this.kind = kind; 
      try{
          this.objects.add([SELECT Id, DS_Datetime_of_Last_Disposition__c, DS_Last_Disposition__c, DS_Total_Call_Count__c FROM Contact_Role__c WHERE Id IN: records.keySet() FOR UPDATE]);   
      }
      catch(exception e){
          System.debug('Failed to collect records.  Error: ' + e);
      }
  }
  
  public void updateFields(){
      
      if(kind == 'insert'){
          //iterate through objects and update fields
          System.debug('objects: ' + objects);
          for(List<sObject> l : objects){
                   for(sObject o : l){
                     if(o != null){

//Increase total call count by 1
                         if(o.get('DS_Total_Call_Count__c') == null){
                             o.put('DS_Total_Call_Count__c', 1);
                         }
                         else{
                             o.put('DS_Total_Call_Count__c', (Decimal)o.get('DS_Total_Call_Count__c') + 1);
                         }
                     }
                  }      
                  try{
                       update l;
                  }
                  catch(exception e){
                      System.debug('Failed to update list.  Error: ' + e);
                  }            
              }
      }
      
      if(kind == 'update'){
          //iterate through objects and update fields
          System.debug('objects: ' + objects);
          for(List<sObject> l : objects){
                   for(sObject o : l){
                     if(o != null){
                         
                         //Update DS Last Disposition 
                         o.put('DS_Last_Disposition__c', records.get(o.id));
                             
                         //Update DS Date of Last Disposition
                         o.put('DS_Datetime_of_Last_Disposition__c', DateTime.now());       
                     }
                  }      
                  try{
                      update l;
                  }
                  catch(exception e){
                      System.debug('Failed to update list.  Error: ' + e.getLineNumber() + ' ' + e.getCause());
                  }            
              }
      }
  }
}