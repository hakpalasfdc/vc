public with sharing class VSPR2_UpdateContactRoleBatch implements Database.Batchable<sObject>{
    

   public static final String BATCH_QUERY   = 'Select id from Contact_Role__c';
    
   public Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator(BATCH_QUERY);
   }

   public void execute(Database.BatchableContext BC, List<sObject> contRoleList){
    
    List<Contact_Role__c> cRoleUpdate = new List<Contact_Role__c>();
    for(sObject contRole : contRoleList){
            Contact_Role__c cRole = (Contact_Role__c)contRole;
            cRoleUpdate.add(cRole);

      }
      //system.assertEquals(cRoleUpdate,null);      
      update cRoleUpdate;
   }
 
   public void finish(Database.BatchableContext BC){

   }

}