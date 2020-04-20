/**
 * Trigger Name: SalesGoalsTrigger
 * @author: Katherine Boothe
 * Date: June 18, 2017
 * @description: Trigger for Sales Goal object.
 */


trigger SalesGoalsTrigger on Sales_Goals__c (before insert, before update) {

     try {
         for (Sales_Goals__c a : Trigger.New){
             if (a.Territory_Code__c != null) {
                 a.User__c = [SELECT Id FROM User Where MarketingID__c =: a.Territory_Code__c OR MarketingID2__c = :a.Territory_Code__c LIMIT 1 ].Id;
            }
                       
        }
    
  } catch (Exception e) {
      System.debug(e.getMessage());  
  }
    
    
    

}