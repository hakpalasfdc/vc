public class VSPR25b_ValidateMedicaidLicense {
    
    public static boolean VSPR19B_ValidateMedicaidLicenseMethod_recursion = true;
    public void VSPR19B_ValidateMedicaidLicenseMethod(List<Network_Relationship__c> newRecs,List<Network_Relationship__c> oldRecs,Map<Id,Network_Relationship__c> newRecsMap,Map<Id,Network_Relationship__c> oldRecsMap){
        
        if(VSPR19B_ValidateMedicaidLicenseMethod_recursion){
            VSPR19B_ValidateMedicaidLicenseMethod_recursion = false;
            
            system.debug('***** entered VSPR19B_ValidateMedicaidLicenseMethod ***** ');
            
            list<License__c> listLicense = new list<License__c>();
            list<Contact_Role__c> listContactRole = new list<Contact_Role__c>();
            Set<Id> DoctorIds = new Set<Id>();
            Set<Id> ContactRoleIds = new Set<Id>();
            String stateMedicaId;
            String programIdBeginswith;
            Id currentUserId = userInfo.getUserId();
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            
            
            if(( profileName != 'System Administrator' && 
                profileName != 'VSP Technical User' && 
                profileName != 'VSP Integration User' ) || test.isrunningtest()){
                    if(Trigger.IsInsert && Trigger.IsBefore){
                        map<String,General_Table__c> mpProgramId = new map<String,General_Table__c>(); 
                        for(Network_Relationship__c nw : newRecs){
                            if(nw.Program_ID__c != NULL) {
                                mpProgramId.put(nw.Program_ID__c,NULL);
                            }
                        }
                        mpProgramId = new map<String,General_Table__c>([SELECT Id,Name FROM General_Table__c WHERE Id IN :mpProgramId.keySet()]);
                        for(Network_Relationship__c nw : newRecs){
                            system.debug('============CRole'+nw.Contact_Role__c);
                            system.debug('============Provider'+nw.Provider_Name__c);
                            //system.debug('============Program'+nw.Program_ID__r.name);
                            //DoctorIds.add(nw.Provider_Name__c);
                            ContactRoleIds.add(nw.Contact_Role__c);
                            
                            stateMedicaId = mpProgramId.containsKey(nw.Program_ID__c) ? mpProgramId.get(nw.Program_ID__c).Name.right(2) : null; //((String.valueof(nw.Program_ID__r.Name)).right(2));
                            system.debug('------------'+stateMedicaId); 
                            programIdBeginswith = mpProgramId.containsKey(nw.Program_ID__c) ? mpProgramId.get(nw.Program_ID__c).Name.left(3) : null; //(String.valueof(nw.Program_ID__r.Name).left(3));
                            system.debug('------------ '+programIdBeginswith); 
                        }
                        
                        listContactRole = [select Id, Contact__c from Contact_Role__c where Id IN:ContactRoleIds];
                        for(Contact_Role__c cr :listContactRole ){
                            DoctorIds.add(cr.Contact__c);
                        }
                        if(programIdBeginswith == 'MCD'){
                            listLicense = [SELECT Id, License_Type_Description__c, State__c 
                                           FROM License__c 
                                           WHERE Provider__c IN :DoctorIds 
                                           AND License_Type_Description__c ='Medicaid' 
                                           AND State__c=:stateMedicaId];
                            system.debug('=============ListLicense'+listLicense+'Size'+ ListLicense.size());
                            for(Network_Relationship__c nw : newRecs){
                                if(programIdBeginswith == 'MCD' && listLicense.size()>0)
                                    system.debug('Match Ok');
                                else
                                    nw.addError('To add this Program ID, the doctor must have an associated Medicaid License for that state.');
                            }
                        }
                    }
                    
                    
                    //Case Number: 00010881
                    //Date: 17th March, 2017
                    if (trigger.IsInsert && trigger.isAfter)
                    {
                        system.debug('#### in handler');
                        
                        if(NetworkRelTriggerForProgramIdHandler.validate==false){
                            system.debug('############# Insert in Handler');
                            NetworkRelTriggerForProgramIdHandler.applyActiveCostcoPIToNewDoctor(newRecsMap.keyset());
                        }
                        
                    }
                    if (( (trigger.IsInsert && trigger.isAfter)|| (trigger.IsUpdate && trigger.isAfter) ) || test.isrunningtest())
                    {
                        system.debug('#### in handler updation');
                        //call to handler class
                        //NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(trigger.new);
                        
                        if(NetworkRelationshipTriggerHandler.validate==false && (trigger.IsInsert && trigger.isAfter)){
                            system.debug('############# Insert in Handler');
                            NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(newRecsMap.keyset());
                        }
                        else if(NetworkRelationshipTriggerHandler.validate==false && (trigger.IsUpdate && trigger.isAfter)){
                            system.debug('updated&&&&&&');
                            set<id> newId=new set<id>();
                            for(Network_Relationship__c nw:newRecs){
                                // system.debug(nw.Program_ID__c+'%%%%%%%%'+Trigger.oldMap.get(nw.id).Program_ID__c);
                                if(nw.Program_ID__c!=oldRecsMap.get(nw.id).Program_ID__c)
                                    newId.add(nw.id);
                            }
                            if(newId.size()>0)
                                NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(newId);
                            
                        }
                        
                        
                    }
                    
                    If(Trigger.isdelete){
                        for(Network_Relationship__c nw:oldRecs){
                            
                            if(nw.Claims_Priced__c=='Y'){
                                nw.Claims_Priced__c.addError(' A claim has been priced against this Network Relationship. It cannot be deleted.');
                                
                            }
                            
                        }
                        
                    }
                } 
        }
    }  
    
}