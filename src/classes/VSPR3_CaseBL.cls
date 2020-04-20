/**
 * Class Name: VSPR3_CaseBL
 * @author: karl.wilson.l.tan
 * Date: 08.OCT.2013
 * Requirement/Project Name: VSP
 * @description: Handles all Business Logic for the Case object.
 */
 
public class VSPR3_CaseBL{
 
    public void CaseBeforeTriggerMethod(List<Case> newTrigger){ 
 
     Set<ID> setCaseIds = new Set<ID>();

     for(Case cases : newTrigger){
        setCaseIds.add(cases.OwnerId);
     //system.debug('-------------------------------- Case ID : ' + setCaseIds);
    }
    
      
     MAP<ID , User> mapUser = new MAP<ID , User>([Select Id, UserRole.Name from User where id in: setCaseIds]);
     //system.debug('--------------------------------MAP  : ' +mapUser);

     for(Case cases : newTrigger){

            User u = mapUser.get(cases.ownerId);
            //system.debug('--------------------------------Case Owner : ' + cases.ownerId);
            
            if(u != null){
            
                cases.User_Role__c = u.UserRole.Name;
            }
            else if(u == null){
            
                cases.User_Role__c ='';
            }
            

       }
    }
    
        public void cRoleCasesBeforeTriggerMethod(List<Case> newTrigger){ 
 
     Set<ID> setCIds = new Set<ID>();
     for(Case cases : newTrigger){
        if(cases.Contact_Role__c != null)
        setCIds.add(cases.Contact_Role__c);
    }
     


     MAP<ID , Contact_Role__c> mapConRoltoCase = new MAP<ID , Contact_Role__c>([Select Id, Account__c, Contact__c from Contact_Role__c where id in: setCIds]);
     

     for(Case cases : newTrigger)
       {
        if(cases.Contact_Role__c != null)
            {
            Contact_Role__c c = mapConRoltoCase.get(cases.Contact_Role__c);
            
            
            cases.AccountId = c.Account__c;
            cases.ContactId = c.Contact__c;

            
            }
       }
    }

}