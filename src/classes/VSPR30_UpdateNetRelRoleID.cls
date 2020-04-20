public class VSPR30_UpdateNetRelRoleID {
    
    @TestVisible public static boolean VSPR30_UpdateNetRelRoleID_recursion = true;
    public void VSPR30_UpdateNetRelRoleID(List<Network_Relationship__c> newTrigger,Map<Id,Network_Relationship__c> oldRecs){
        
        if(VSPR30_UpdateNetRelRoleID_recursion){
            VSPR30_UpdateNetRelRoleID_recursion = false;
            system.debug('***** entered VSPR30_UpdateNetRelRoleID ***** ');
            Set<id> netRelID=new Set<Id>();
            
            for(Network_Relationship__c nr :newTrigger){
                system.debug('***** Program_ID_Code__c ***** ' + nr.Program_ID_Code__c);
                if(oldRecs !=null){
                    if(nr.Program_ID__c != oldRecs.get(nr.Id).Program_ID__c && (nr.Program_ID_Code__c == 'LVC01' || oldRecs.get(nr.Id).Program_ID_Code__c == 'LVC01')){
                        netRelID.add(nr.Id);
                    }                    
                }
                else{
                    if(nr.Program_ID_Code__c == 'LVC01'){
                        netRelID.add(nr.Id);
                    }
                }                    
            }
            
            if(!netRelID.isEmpty()){
                system.debug('***** netRelID ***** ' + netRelID);
                Set<Network_Relationship__c> updNRSet = new Set<Network_Relationship__c>();
                List<Network_Relationship__c> netRelLst = [SELECT Id, Program_ID_Code__c, Provider_Name__c, Provider_Name__r.Facility_Type__c  FROM Network_Relationship__c WHERE Id IN :netRelID];
                
                for(Network_Relationship__c nr :netRelLst){
                    if(nr.Program_ID_Code__c == 'LVC01' && nr.Provider_Name__r.Facility_Type__c == 'EF - Laser Vision Center'){
                        nr.Role_ID__c = 'FA';
                        updNRSet.add(nr);
                    }
                    else if(nr.Program_ID_Code__c == 'LVC01' && nr.Provider_Name__r.Facility_Type__c != 'EF - Laser Vision Center'){
                        nr.Role_ID__c = 'FS';
                        updNRSet.add(nr);
                    }
                    else{
                        nr.Role_ID__c = null;
                        updNRSet.add(nr);
                    }
                }
                List<Network_Relationship__c> updNRLst = new List<Network_Relationship__c>(updNRSet);
                if(!updNRLst.isEmpty()){
                    update updNRLst;
                }
            }
        }
    }
    
    public static boolean VSPR30_UpdateNetRelRoleID_From_Contact_recursion = true;
    public void VSPR30_UpdateNetRelRoleID_From_Contact(List<Contact> newTrigger,Map<Id,Contact> oldRecs){
        
        if(VSPR30_UpdateNetRelRoleID_From_Contact_recursion){
            VSPR30_UpdateNetRelRoleID_From_Contact_recursion = false;
            system.debug('***** entered VSPR30_UpdateNetRelRoleID_From_Contact ***** ');
            
            Set<id> conID=new Set<Id>();
            
            for(contact con :newTrigger){
                if(oldRecs !=null){
                    if(con.Facility_Type__c != oldRecs.get(con.Id).Facility_Type__c && (con.Facility_Type__c == 'EF - Laser Vision Center' || oldRecs.get(con.Id).Facility_Type__c == 'EF - Laser Vision Center')){
                        conID.add(con.Id);
                    }   
                }
                
            }
            
            if(!conID.isEmpty()){
                
                Set<Network_Relationship__c> updNRSet = new Set<Network_Relationship__c>();
                List<Network_Relationship__c> netRelLst = [SELECT Id, Program_ID_Code__c, Provider_Name__c, Provider_Name__r.Facility_Type__c FROM Network_Relationship__c WHERE Provider_Name__c IN :conID AND Program_ID_Code__c = 'LVC01'];
                
                for(Network_Relationship__c nr :netRelLst){
                    if(nr.Provider_Name__r.Facility_Type__c == 'EF - Laser Vision Center'){
                        nr.Role_ID__c = 'FA';
                        updNRSet.add(nr);
                    }
                    else{
                        nr.Role_ID__c = 'FS';
                        updNRSet.add(nr);
                    }
                }
                
                List<Network_Relationship__c> updNRLst = new List<Network_Relationship__c>(updNRSet);
                if(!updNRLst.isEmpty()){
                    update updNRLst;
                } 
                
            }
        }
    }
    
}