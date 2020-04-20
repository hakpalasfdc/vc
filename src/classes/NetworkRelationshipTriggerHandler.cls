//Date: 17th March, 2017
//Description: Case Number: 00010881. Ability to apply Active Costco Program IDs to New Doctors.
//             Handler class for trigger trgValidateMedicaidLicense on Network Relationship object.
public class NetworkRelationshipTriggerHandler {
    
    public static boolean validate = false;
    public static boolean applyActiveCostcoPIToNewDoctor_recursionX = true;
    public static void applyActiveCostcoPIToNewDoctor(set < id > nwid) {

        if(applyActiveCostcoPIToNewDoctor_recursionX){
        applyActiveCostcoPIToNewDoctor_recursionX = false;
        
                List < Network_Relationship__c > finalNetworkRelationship = new List < Network_Relationship__c > ();
                List < Network_Relationship__c > NetworkRelationship = new List < Network_Relationship__c > ();
                NetworkRelationship = [select id, name, Program_Effective_Date__c, Program_End_Date__c, Contact_Role__c, Directory_Effective_Date__c, Directory_End_Date__c, program_id__r.name, Contact_Role__r.Type__c, Contact_Role__r.Account__c, Contact_Role__r.Contact__c, Contact_Role__r.Account__r.Location_Type__c, Contact_Role__r.Contact__r.Doctor_Type__c from network_relationship__c where id in: nwId];
                Map < id, Network_Relationship__c > MapNetworkRelationship = new map < id, Network_Relationship__c > ();
                set < id > RemoveNetwork = new set < id > ();
                for (Network_Relationship__c nw: NetworkRelationship) {

                    MapNetworkRelationship.put(nw.id, nw);
                }
                System.debug(MapNetworkRelationship + '###############');
                Map < Id, Id > NetworlWithAccount = new Map < Id, Id > ();
                mAP < ID, ID > ContactRoleWithAccount = new Map < id, id > ();
                Map < id, id > NetworkIdContactRoleId = new map < id, id > ();
                for (Network_Relationship__c NR: NetworkRelationship) {
                    if (NR.Program_ID__r.Name == 'COSTA' && (NR.Contact_Role__r.Contact__r.Doctor_Type__c == 'M - VSP Member Doctor' || NR.Contact_Role__r.Contact__r.Doctor_Type__c == 'A - Affiliate Provider' || NR.Contact_Role__r.Contact__r.Doctor_Type__c == 'S - School Faculty Provider') &&
                        (NR.Contact_Role__r.Account__r.Location_Type__c == 'A - Affiliate Provider Location' && NR.Contact_Role__r.Type__c == 'Doctor-Owner')) {
                        NetworlWithAccount.put(nr.id, nr.Contact_Role__r.Account__c);
                        ContactRoleWithAccount.put(nr.Contact_Role__c, nr.Contact_Role__r.Account__c);
                        NetworkIdContactRoleId.put(nr.id, nr.Contact_Role__c);
                    }
                }
                System.debug(NetworlWithAccount + '###############');
                System.debug(ContactRoleWithAccount + '###############');
                System.debug(NetworkIdContactRoleId + '###############');
                For(Contact_Role__c cr: [select id, Type__c, Account__c, Contact__r.Doctor_Type__c, (select id, program_id__r.name, Program_Effective_Date__c, Program_End_Date__c from Payment_Relationships__r where program_id__r.name = 'COSTQ' and Program_Effective_Date__c <= Today and (Program_End_Date__c=null or Program_End_Date__c>=Today)) from Contact_Role__c where Account__c in: NetworlWithAccount.values() and Type__c = 'Doctor-Owner']) {
                    system.debug(Cr + '$$$$');
                    if (cr.Payment_Relationships__r.size() > 0) {

                        system.debug('Network Realation ship found');
                        For(String NtrId: NetworlWithAccount.keyset()) {
                            if (NetworlWithAccount.get(NtrId) == cr.Account__c && NetworkIdContactRoleId.get(NtrId) != cr.id && !RemoveNetwork.contains(NtrId)) {
                                system.debug('Create network Realtion ship');
                                Network_Relationship__c nw = new Network_Relationship__c();
                                nw.Contact_Role__c = MapNetworkRelationship.get(NtrId).Contact_Role__c;
                                nw.Directory_Effective_Date__c = MapNetworkRelationship.get(NtrId).Directory_Effective_Date__c;
                                nw.Directory_End_Date__c = MapNetworkRelationship.get(NtrId).Directory_End_Date__c;
                                nw.Program_Effective_Date__c = MapNetworkRelationship.get(NtrId).Program_Effective_Date__c;
                                nw.Program_End_Date__c = MapNetworkRelationship.get(NtrId).Program_End_Date__c;
                                nw.Program_ID__c = cr.Payment_Relationships__r[0].Program_ID__c;
                                //if (cr.Contact__r.Doctor_Type__c == MapNetworkRelationship.get(NtrId).Contact_Role__r.Contact__r.Doctor_Type__c){
                                    finalNetworkRelationship.add(nw);
                                    RemoveNetwork.add(NtrId);
                                    break;
                                //}
                            }

                        }




                    }


                }
                if (finalNetworkRelationship.size() > 0) {
                    validate = true;
                    insert finalNetworkRelationship;
                }
        }
    }


}