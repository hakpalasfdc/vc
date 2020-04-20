/**
 * Trigger Name: AddressTrigger
 * @author: Marvin B. Gatchalian
 * Date: 18.JUNE.2013
 * Requirement/Project Name: VSP
 * @description: Trigger for the Address Custom object.
 */

trigger AddressTrigger on Address__c (after insert, after update, before delete) {
    
 //   try {
        
        if((trigger.isAfter) && (trigger.isUpdate || trigger.isDelete)){
            system.debug('>>>Enter trigger');
            //VSPR1_AddressBL(trigger.new,trigger.old,trigger.newMap,trigger.isDelete,trigger.isInsert);
            VSPR1_AddressBL UpdateAccountAddress = new VSPR1_AddressBL(trigger.new,trigger.old,trigger.newMap,trigger.isDelete,trigger.isInsert);
            
        }                       
  //  } catch (Exception e) {
 //       System.debug(e.getMessage()); 
 //   } 

}