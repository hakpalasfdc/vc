/*
* Updates Network relationship fee code
*/
public class VSP_NetworkRelationshipTriggerHandler {
//Contact Role is required on the Network Relationship object. SFDC-9054
/*
    public static boolean poulateFreeCodeFromCntRole_recursion = true;
    public static void poulateFreeCodeFromCntRole(list<Network_Relationship__c> lstNR) {
        
        if(poulateFreeCodeFromCntRole_recursion){
        poulateFreeCodeFromCntRole_recursion = false;

            map<String,Contact_Role__c> mpContactRole = new map<String,Contact_Role__c>(); 

            for(Network_Relationship__c nr : lstNR) {
                if(nr.Contact_Role__c == NULL ) {
                    mpContactRole.put(nr.Contact_Role__c,null);
                }
            }
            if(mpContactRole.isEmpty()) {
                return;
            }

            mpContactRole = new map<String,Contact_Role__c>([SELECT id,Fee_Code__c FROM Contact_Role__c WHERE id IN :mpContactRole.keySet()]);

            map<Id,General_Table__c> mpPrograms = new map<Id,General_Table__c>([SELECT Id FROM General_Table__c WHERE Name = 'VSP' OR Name = 'CHOIC']); 

            Set<Network_Relationship__c> nrSet = new Set<Network_Relationship__c>();
            for(Network_Relationship__c nr : lstNR) {
                if(nr.Contact_Role__c == NULL || !mpPrograms.containsKey(nr.Program_ID__c) || nr.Claims_Priced__c != 'N') {
                  continue;
                }
                Network_Relationship__c x = new Network_Relationship__c(Id = nr.Id);
                nr.Fee_Code__c = mpContactRole.get(nr.Contact_Role__c).Fee_Code__c;
                nrSet.add(x);
            }
            
            List<Network_Relationship__c> nrList = new List<Network_Relationship__c>(nrSet);
            if(!nrList.isEmpty()){
                update nrList;
            }
        }
    }  */
}