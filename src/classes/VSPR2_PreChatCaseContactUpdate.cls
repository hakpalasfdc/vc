public class VSPR2_PreChatCaseContactUpdate {
    /*
     Jesten Hayle - Eagle Creek Software Service. 7/16/19. 
     When a case is created via Chat the new person account record Id is set in the Case AccountId field.
     Once the case is updated with the AccountId, set the PersonContactId from the new person account into
     the ContactId field. This will expose the new person account as a contact on the case.
    */
    
    public static void setCaseContact(Map<Id,Case> newCases, Map<Id,Case> oldCases){
        Map<String,Case> caseMap = new Map<String,Case>();
        for(Case updatedCase:newCases.values()){
            if(updatedCase.Origin == 'Chat'){
                if(updatedCase.AccountId != oldCases.get(updatedCase.Id).AccountId){
                    caseMap.put(updatedCase.AccountId,updatedCase); 
                }
            }
        }
        
        if(caseMap.KeySet().size() > 0){
            List<Account> personAccounts = [SELECT Id,PersonContactId FROM Account WHERE Id IN: caseMap.keySet()];
            for(Account person:personAccounts){
                caseMap.get(person.Id).ContactId = person.PersonContactId;
            }
        }
    }
}