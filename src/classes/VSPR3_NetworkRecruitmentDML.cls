/**
 * Class Name: VSPR1_AccountDML
 * @author: Jinky M.N. Salvador
 * Date: 09.OCT.2013
 * Requirement/Project Name: VSP
 * @description: Handles all DML for the Network Recruitment object.
 */
 
 
 public class VSPR3_NetworkRecruitmentDML { 
 
   public static void updateContactDetails(Map<Id,Double> contactsNetRecInProg, Boolean hasNetRec) {
   system.debug('>>> Enter updateContactDetails');
   
   Set <Id> contactIds = contactsNetRecInProg.keySet();
    List<Contact> contactDetails = [Select Recruitment_in_Progress__c  from Contact where id IN: contactIds];
    
    for (Contact contact: contactDetails ){
      //account.Has_Contact__c = hasContact;
      //System.debug('>>>>hasContactAccount' + hasContact);
      if (contactsNetRecInProg.get(contact.id) > 0){
        contact.Recruitment_in_Progress__c = true;
      }
      else{
        contact.Recruitment_in_Progress__c = false;
      }
      /*
      if (accountsHighProf.get(account.id) > 0){
        account.High_Profile__c = true;
      }
      else{
        account.High_Profile__c = false;
      }
      */
      System.debug('>>>>Contact Recruitment In Progress' + contact.Recruitment_in_Progress__c);
      //System.debug('>>>>Account High Profile' + account.High_Profile__c);
    }
    update contactDetails;
   }  
 }