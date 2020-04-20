/**
 * Trigger Name: NetworkRecruitmentTrigger
 * @author: karl.wilson.l.tan
 * Date: 16.SEP.2013
 * Requirement/Project Name: VSP
 * @description: Trigger for the Network Recruitment object.
 */



trigger NetworkRecruitmentTrigger on Network_Recruitment__c (before insert, before update, after insert, after update, after delete) {



 try {
    
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate )){
     // if(trigger.isBefore && trigger.isInsert){  
      VSPR3_NetworkRecruitmentBL UpdateNetRecFields = new VSPR3_NetworkRecruitmentBL();
      UpdateNetRecFields.recruitmentBeforeTriggerMethod(trigger.new);
      //}
      //if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate )){
      //VSPR3_BusinessDaysUtil updateLstBusDate = new VSPR3_BusinessDaysUtil();
      //updateLstBusDate.addBusinessDays(system.today(),7); 
     // }
    }
    
    if(trigger.isAfter){
     VSPR3_NetworkRecruitmentBL.recruitmentAfterTriggerMethod(trigger.new,trigger.old,trigger.oldMap,trigger.isDelete,trigger.isInsert);
    }              
  } catch (Exception e) {
      System.debug(e.getMessage());  
  }
      
}