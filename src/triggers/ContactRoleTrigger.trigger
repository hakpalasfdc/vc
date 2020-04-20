trigger ContactRoleTrigger on Contact_Role__c (before insert, before update,after update)
{   
   try
   {
     if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
     {
        VSPR19b_ContactRoleTrigger_Handler crt = new VSPR19b_ContactRoleTrigger_Handler();
        VSPR19b_ContactRoleTrigger_Handler.VSPR27_ContactRole_Dupe_Validation(trigger.new);
        crt.VSPR19b_ContactRoleTrigger_Handler(trigger.new);
        crt.VSPR19b_CRoleTrigger_Handler(Trigger.new);
     }
        
     if(Trigger.isAfter && Trigger.isUpdate) {

         VSPR19b_ContactRoleTrigger_Handler.populateFeeCodeONNR(Trigger.new,Trigger.oldMap);
         VSPR19b_ContactRoleTrigger_Handler.populateNetRelsHoursWorked(Trigger.new, Trigger.oldMap);
         

     }
   }
   catch(Exception e) {
    System.Debug(e.getMessage());   
   }  
}