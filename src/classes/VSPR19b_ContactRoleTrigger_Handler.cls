public with sharing class VSPR19b_ContactRoleTrigger_Handler{
    
    public static boolean VSPR19b_ContactRoleTrigger_Handler_recursion = true;
    public void VSPR19b_ContactRoleTrigger_Handler(List<Contact_Role__c> newTrigger){
        
        if(VSPR19b_ContactRoleTrigger_Handler_recursion){
            VSPR19b_ContactRoleTrigger_Handler_recursion = false;
            
            Set<Id> newTriggerIds = (new Map<Id,Contact_Role__c>(newTrigger)).keySet();
            Id profileId = userinfo.getProfileId();
            String profileName = [SELECT Id, Name 
                                  FROM Profile 
                                  WHERE ID =: profileId].Name;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            if(profileName != 'System Administrator' || profileName != 'VSP Technical User'){
                
                map<string,Integer> count1 = new Map<string,Integer>();
                AggregateResult[] netRelList = 
                    [SELECT Contact_Role__c Id, COUNT(Id) netRelListCount 
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: newTriggerIds
                     GROUP BY Contact_Role__c];
                
                for(AggregateResult ar : netRelList){
                    count1.put((string)ar.get('Id'), (Integer)ar.get('netRelListCount'));
                }
                
                for(Contact_Role__c crc : newTrigger){
                    if(count1.get(crc.Id) > 0){
                        if(crc.Type__c == 'Doctor-Owner' || crc.Type__c == 'Doctor-Employee') { 
                        }else{
                            crc.addError('Contact Roles with associated Network Relationships must be Doctor-Owners or Doctor-Employees');
                        }
                    }
                }
            }
        }
    }
    
    public static boolean populateFeeCodeONNR_recursion = true;
    public static void populateFeeCodeONNR(list<Contact_Role__c> lstContactRole,map<Id,Contact_Role__c> mpOldCR) {
        
        if(populateFeeCodeONNR_recursion){
            populateFeeCodeONNR_recursion = false;
            system.debug('************************Enter Method populateFeeCodeONNR***************');
            map<id,Contact_Role__c> mpNewCR = new map<id,Contact_Role__c>(); 
            for(Contact_Role__c cr : lstContactRole) {
                if(cr.Fee_Code__c != mpOldCR.get(cr.id).Fee_Code__c) {
                    mpNewCR.put(cr.id,cr);
                }
            }
            map<Id,General_Table__c> mpPrograms = new map<Id,General_Table__c>([Select Id from General_Table__c Where Name = 'VSP' OR Name = 'CHOIC']);
            List<Network_Relationship__c> lstNR = [select Id,Contact_Role__c from Network_Relationship__c Where Contact_Role__c IN :mpNewCR.keySet() AND Claims_Priced__c = 'N' AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = null ) AND Program_ID__c IN :mpPrograms.keySet()];       
            system.debug('***************************************Count of NR to Update: '+lstNR.size());
            Set<Network_Relationship__c> nrUpdateSet = new Set<Network_Relationship__c>();
            for(Network_Relationship__c nr : lstNR) {
                system.debug('***************************************mpNewCR.get(nr.Contact_Role__c).Fee_Code__c: '+mpNewCR.get(nr.Contact_Role__c).Fee_Code__c);
                Network_Relationship__c x = new Network_Relationship__c(Id=nr.Id);
                nr.Fee_Code__c = mpNewCR.get(nr.Contact_Role__c).Fee_Code__c;
                nr.Bypass_VC_Validation_Rules__c = true;
                nrUpdateSet.add(nr); 
            }
            List<Network_Relationship__c> nrUpdateList = new List<Network_Relationship__c>(nrUpdateSet);
            if(!nrUpdateList.isEmpty()){
                system.debug('****************nrUpdateList.isEmpty()***********************' +nrUpdateList[0].Fee_Code__c);
                update nrUpdateList;
            }
        }
    }
    
    public static boolean VSPR19b_CRoleTrigger_Handler_recursion = true;
    public void VSPR19b_CRoleTrigger_Handler(List<Contact_Role__c> newTrigger){
        
        if(VSPR19b_CRoleTrigger_Handler_recursion){
            VSPR19b_CRoleTrigger_Handler_recursion = false;
            
            System.Debug('*******Inside Handler:*******');
            Boolean ProfileMatch = false; 
            Boolean permissionSetFound = false;
            Id profileId = userinfo.getProfileId(); 
            Id currentUserId = userInfo.getUserid();
            
            String profileName = [SELECT Id, Name 
                                  FROM Profile 
                                  WHERE Id = :profileId].Name; 
            
            List<PermissionSetAssignment> listPSA = [SELECT id, PermissionSetId 
                                                     FROM PermissionSetAssignment 
                                                     WHERE AssigneeId = :currentUserId];
            Set<Id> ids = new set<Id>();
            
            for(PermissionSetAssignment PSA : listPSA){ 
                ids.add(PSA.PermissionSetId); 
            }
            
            List<PermissionSet> listPS = [SELECT Name 
                                          FROM PermissionSet 
                                          WHERE id IN:ids];
            
            for(PermissionSet PS: listPS) {  
                if(PS.Name == 'Credentialing_Data_Manager'){  
                    permissionSetFound = true;  
                } 
            } 
            if(profileName == 'VSP Network Recruitment User' || 
               profileName == 'VSP Network Recruitment Management User' || 
               (permissionSetFound == true)){  
                   ProfileMatch = true; 
               } 
            if(profileName == 'System Administrator'|| 
               profileName == 'VSP Technical User') {  
                   ProfileMatch = true; 
               }
            
            Set<id> setCRCIds = new Set<id>(); 
            
            if(ProfileMatch){ 
                for(Contact_Role__c crc : newTrigger) { 
                    setCRCIds.add(crc.ID); 
                }    
                
                List<Contact_Role__c> listContactRoles = 
                    [SELECT Id, Contact__c, Account__c, Type__c, Start_Date__c, Account__r.ParentId,
                     Account__r.Vision_Care_Effective_Date__c, Account__r.Vision_Care_End_Date__c, 
                     Contact__r.Vision_Care_Effective_Date__c, Contact__r.Vision_Care_End_Date__c,
                     Account__r.Parent.Vision_Care_Effective_Date__c, Account__r.Parent.Vision_Care_End_Date__c
                     FROM Contact_Role__c 
                     WHERE Id IN: setCRCIds]; 
                
                Set<Id> setCRCContIds = new Set<Id>();
                Set<Id> setParentIDs = new Set<Id>();
                Map<Id, Date> paVCEffD = new Map<Id, Date>();
                Map<Id, Date> paVCEndD = new Map<Id, Date>();
                Map<Id, Date> pcVCEffD = new Map<Id, Date>();
                Map<Id, Date> pcVCEndD = new Map<Id, Date>();
                Map<Id, Date> prAccVCEffD = new Map<Id, Date>();
                Map<Id, Date> prAccVCEndD = new Map<Id, Date>();
                
                for(Contact_Role__c crcX : listContactRoles){
                    setCRCContIds.add(crcX.Contact__c);
                    setParentIDs.add(crcX.Account__r.ParentID);
                    paVCEffD.put(crcX.Id, crcX.Account__r.Vision_Care_Effective_Date__c);
                    paVCEndD.put(crcX.Id, crcX.Account__r.Vision_Care_End_Date__c);
                    pcVCEffD.put(crcX.Id, crcX.Contact__r.Vision_Care_Effective_Date__c);
                    pcVCEndD.put(crcX.Id, crcX.Contact__r.Vision_Care_End_Date__c);
                    prAccVCEffD.put(crcX.Id, crcX.Account__r.Parent.Vision_Care_Effective_Date__c);
                    prAccVCEndD.put(crcX.Id, crcX.Account__r.Parent.Vision_Care_End_Date__c);
                } 
                
                List<Contact_Role__c> crcNewList = new List<Contact_Role__c>();
                Set<Contact_Role__c> crcNewSet = new Set<Contact_Role__c>();
                Contact_Role__c crcNew = new Contact_Role__c();
                
                for(Contact_Role__c crole : listContactRoles){
                    
                    if(crole.Contact__c != NULL &&
                       crole.Account__c != NULL &&
                       crole.Start_Date__c != NULL &&
                       crole.Account__r.ParentID != NULL &&
                       crole.Type__c == 'Doctor-Owner'){
                           
                           if((pcVCEffD.get(crole.Id) != Null && (pcVCEndD.get(crole.Id) == NULL || pcVCEndD.get(crole.Id) >= Date.Today())) &&
                              (prAccVCEffD.get(crole.Id) != Null && (prAccVCEndD.get(crole.Id) == NULL || prAccVCEndD.get(crole.Id) >= Date.Today()))){ 
                                  crcNew.Contact__c = crole.Contact__c;  
                              } 
                           
                           if((paVCEffD.get(crole.Id) != Null && (paVCEndD.get(crole.Id) == NULL || paVCEndD.get(crole.Id) >= Date.Today())) &&
                              (prAccVCEffD.get(crole.Id) != Null && (prAccVCEndD.get(crole.Id) == NULL || prAccVCEndD.get(crole.Id) >= Date.Today()))) { 
                                  crcNew.Account__c  = crole.Account__r.ParentID;
                              }
                           
                           crcNew.Start_Date__c = crole.Start_Date__c; 
                           crcNew.Type__c = 'Doctor-Owner'; 
                           
                           
                           if(crcNew.Account__c != null &&
                              crcNew.Contact__c != null && 
                              crcNew.Start_Date__c != null && 
                              crcNew.Type__c == 'Doctor-Owner') { 
                                  
                                  List<Contact_Role__c> listCrc = [SELECT Id 
                                                                   FROM Contact_Role__c 
                                                                   WHERE Type__c = 'Doctor-Owner' 
                                                                   AND Contact__c =: crcNew.Contact__c
                                                                   AND Account__c =: crcNew.Account__c];  
                                  
                                  if(!crcNewSet.contains(crcNew) && listCrc.size() == 0)
                                  { crcNewSet.add(crcNew); }
                              }
                       }            
                }  
                
                crcNewList = new List<Contact_Role__c>(crcNewSet);
                
                if(!crcNewList.isEmpty()) { 
                    insert crcNewList; 
                } 
                
            }  
        }
    }
    
    public static boolean populateNetRelsHoursWorked_recursion = true;
    public static void populateNetRelsHoursWorked(list<Contact_Role__c> lstContactRole,map<Id,Contact_Role__c> mpOldCR) {
        
        if(populateNetRelsHoursWorked_recursion){
            populateNetRelsHoursWorked_recursion = false;
            system.debug('************************Enter Method populateNetRelsHoursWorked***************');
            map<id,Contact_Role__c> mpNewCR = new map<id,Contact_Role__c>(); 
            for(Contact_Role__c cr : lstContactRole) {
                if(cr.Total_Doctor_Hours__c != mpOldCR.get(cr.id).Total_Doctor_Hours__c) {
                    mpNewCR.put(cr.id,cr);
                }
            }
            //            map<Id,General_Table__c> mpPrograms = new map<Id,General_Table__c>([Select Id from General_Table__c Where Name = 'VSP' OR Name = 'CHOIC']);
            List<Network_Relationship__c> lstNR = [select Id,Contact_Role__c from Network_Relationship__c Where Contact_Role__c IN :mpNewCR.keySet() AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = null )];       
            system.debug('***************************************Count of NR to Update: '+lstNR.size());
            Set<Network_Relationship__c> nrUpdateSet = new Set<Network_Relationship__c>();
            for(Network_Relationship__c nr : lstNR) {
                system.debug('***************************************mpNewCR.get(nr.Contact_Role__c).Total_Doctor_Hours__c: '+mpNewCR.get(nr.Contact_Role__c).Total_Doctor_Hours__c);
                Network_Relationship__c x = new Network_Relationship__c(Id=nr.Id);
                nr.Hours_Worked__c = mpNewCR.get(nr.Contact_Role__c).Total_Doctor_Hours__c;
                nr.Bypass_VC_Validation_Rules__c = true;
                nrUpdateSet.add(nr); 
            }
            List<Network_Relationship__c> nrUpdateList = new List<Network_Relationship__c>(nrUpdateSet);
            if(!nrUpdateList.isEmpty()){
                system.debug('****************nrUpdateList.isEmpty()***********************' +nrUpdateList[0].Fee_Code__c);
                update nrUpdateList;
            }
        }
    }
    ////Checks for duplicate contact roles with type Doctor-Owner or Doctor-Employee
    public static boolean VSPR27_ContactRole_Dupe_recursion = true; 
    public static void VSPR27_ContactRole_Dupe_Validation(List<Contact_Role__c> newConRoles){
        VSPR27_ContactRole_Dupe_recursion = false;
        system.debug('***** entered VSPR27_ContactRole_Dupe_Validation ***** ');
        
        Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
        if(skip.Skip_Triggers__c) { return;} 
        
        Set<Id> conRoleAccIdSet = new Set<Id>();
        Set<Id> conRoleConIdSet = new Set<Id>();
        Set<Id> conRoleIdSet = new Set<Id>();
        
        for(Contact_Role__c nConRole :newConRoles){
            conRoleAccIdSet.add(nConRole.Account__c);
            conRoleConIdSet.add(nConRole.Contact__c);
            conRoleIdSet.add(nConRole.Id);
        }
        
        System.debug('Contact Role Account Set ' + conRoleAccIdSet);
        System.debug('Contact Role Contact Set ' + conRoleConIdSet);
        System.debug('Contact Role Id Set ' + conRoleConIdSet);
        
        List<Contact_Role__c> exConRoleList = [SELECT Id, Account__c, Contact__c, Type__c FROM Contact_Role__c
                                               WHERE Account__c IN :conRoleAccIdSet
                                               AND Contact__c IN :conRoleConIdSet
                                               AND Id NOT IN :conRoleIdSet
                                               AND (Type__c = 'Doctor-Owner' OR Type__c = 'Doctor-Employee')];
        
        if(!exConRoleList.isEmpty()){
            for(Contact_Role__c newConR :newConRoles){
                for(Contact_Role__c exRec :exConRoleList){
                    if(newConR.Account__c == exRec.Account__c && newConR.Contact__c == exRec.Contact__c && newConR.Type__C == exRec.Type__c){
                        newConR.addError('There is already a Contact Role for this Contact on this Account');
                    }
                }
                
            }
            
        }
    }
}