public class VSPR25b_ValidateClaimsPriced {
    
    //Restrict users from deleting a Network Relationship if Claims Priced = Y
    public static boolean validateClaimsPriced_recursion = true;
    public void validateClaimsPriced(List<Network_Relationship__c> lstNetRels){
        
        if (validateClaimsPriced_recursion){
            validateClaimsPriced_recursion = false;
            
            system.debug('***** entered validateClaimsPriced ***** ');
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Allow_Network_Relationships_Delete__c) { 
                return; 
            }
            
            for(Network_Relationship__c nr : lstNetRels) {
                if(nr.Claims_Priced__c == 'Y'){
                    nr.addError('A claim has been priced against this Network Relationship. It cannot be deleted.');
                    return;
                }
            }
        }
    }
    
}