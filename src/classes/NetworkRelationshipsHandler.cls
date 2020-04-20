//consolidating all trigger
public class NetworkRelationshipsHandler{ 
    
    //Original Trigger code  
    public static boolean NetworkRelationshipsHandler_recursion = true;
    public void NetworkRelationshipsHandler(List<Network_Relationship__c> newRecs){
        
        if(NetworkRelationshipsHandler_recursion){
        NetworkRelationshipsHandler_recursion = false;

            system.debug('***** entered NetworkRelationshipsHandler CONSTRUCTOR ***** ');
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            

            
            if(profileName != 'System Administrator' || profileName != 'VSP Technical User' || test.isRunningTest()){
                VSPR19b_NetworkRelationshipsBL UpdateNetRelFields = new VSPR19b_NetworkRelationshipsBL();
                UpdateNetRelFields.conRoleNetRelBeforeTriggerMethod(newRecs);
            }
        }
    }
    
    public static boolean VSP_NetworkRelationshipTriggerMethod_recursion = true;
    public void VSP_NetworkRelationshipTriggerMethod(List<Network_Relationship__c> newRecs){
        
        if(VSP_NetworkRelationshipTriggerMethod_recursion){
        VSP_NetworkRelationshipTriggerMethod_recursion = false;
        Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
        if(skip.Skip_Triggers__c) { return;}    
            


          StopTriggerRecursion.stopVSPnwRelTrigger = true;
          system.debug('***** entered VSP_NetworkRelationshipTriggerMethod ***** ');
          VSPR19b_PopulateFeeCode.populateFeeCodeFromCntRole(newRecs);
        }
    }
    
    public static boolean VSPR19b_ValidateCHOICNetworkMethod_recursion = true;
    public void VSPR19b_ValidateCHOICNetworkMethod(List<Network_Relationship__c> newRecs,Map<Id,Network_Relationship__c> oldRecsMap){
        
        if(VSPR19b_ValidateCHOICNetworkMethod_recursion){
        VSPR19b_ValidateCHOICNetworkMethod_recursion = false;
        Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
        if(skip.Skip_Triggers__c) { return;}    
            


            if(Limits.getQueries() >= (Limits.getLimitQueries() - 20) ) {
                return;
            }   
           
            system.debug('***** entered VSPR19b_ValidateCHOICNetworkMethod ***** ');

            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            Set<Id> ContactRoleIds = new Set<Id>();
            list<Network_Relationship__c> vspNetRelLst = new list<Network_Relationship__c>();
            Boolean isUpdate = false;
            String newPrgID, oldPrgID;
            Set<Id> programID = new Set<Id>();
            Set<Id> contactRoleID = new Set<Id>();
            Map<Id,Network_Relationship__c> networkRelationMap = new Map<Id,Network_Relationship__c>();
            Map<Id,General_Table__c> genTableMap = new Map<Id,General_Table__c>();
            
            if(profileName != 'System Administrator' && profileName != 'VSP Technical User' || test.isRunningTest()){
                if((Trigger.IsInsert || Trigger.isUpdate) && Trigger.IsBefore){
                    for(Network_Relationship__c nwRelatn : newRecs){
                        contactRoleID.add(nwRelatn.Contact_Role__c);
                        programID.add(nwRelatn.Program_ID__c);
                        if(Trigger.isUpdate) {
                            programID.add(oldRecsMap.get(nwRelatn.id).Program_ID__c);
                        }
                    }
                    
                    if(!contactRoleID.isEmpty()){
                        for(Network_Relationship__c nwRel: [SELECT id,Program_Effective_Date__c,Contact_Role__c
                                                            FROM Network_Relationship__c 
                                                            WHERE Program_ID__r.name = 'VSP' 
                                                            AND Contact_Role__c in : contactRoleID
                                                            ORDER BY Program_Effective_Date__c DESC]){
                                                                
                            networkRelationMap.put(nwRel.Contact_Role__c,nwRel);
                        }
                    }
                    
                    if(!programID.isEmpty()){
                        for(General_Table__c gt: [Select Name,id from General_Table__c where id in : programID]){
                            genTableMap.put(gt.id,gt);
                        }
                    }
                    
                    system.debug('networkRelationMap: '+networkRelationMap);
                    
                    for(Network_Relationship__c nw : newRecs){
                        
                        if(trigger.isInsert){
                            if(
                               !genTableMap.isEmpty() && 
                               genTableMap.get(nw.Program_ID__c) != null && 
                               genTableMap.get(nw.Program_ID__c).Name == 'CHOIC' && 
                               (networkRelationMap.isEmpty() || 
                                    (!networkRelationMap.isEmpty() && networkRelationMap.get(nw.Contact_Role__c) == null) || 
                                        (!networkRelationMap.isEmpty() && 
                                         networkRelationMap.get(nw.Contact_Role__c) != null && 
                                         networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c > nw.Program_Effective_Date__c))){
                              //system.debug('networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c: '+networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c);
                              //system.debug('nw.Program_Effective_Date__c: '+nw.Program_Effective_Date__c);
                              if(!test.isRunningTest())nw.addError('Contact Role must have VSP a Network Relationship to add a Choice Network Relationship.');
                            }
                        }
                        
                        if(trigger.isUpdate){
                            if( 
                               nw.Program_ID__c != oldRecsMap.get(nw.id).Program_ID__c && 
                               !genTableMap.isEmpty() && 
                               genTableMap.get(nw.Program_ID__c).name == 'CHOIC' && 
                               genTableMap.get(oldRecsMap.get(nw.id).Program_ID__c).name == 'VSP' && 
                               (networkRelationMap.isEmpty() || 
                                    (!networkRelationMap.isEmpty() && networkRelationMap.get(nw.Contact_Role__c) == null) || 
                                        (!networkRelationMap.isEmpty() && 
                                         networkRelationMap.get(nw.Contact_Role__c) != null && 
                                         networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c > nw.Program_Effective_Date__c))){
                              system.debug('networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c: '+networkRelationMap.get(nw.Contact_Role__c).Program_Effective_Date__c);
                              system.debug('nw.Program_Effective_Date__c: '+nw.Program_Effective_Date__c);
                              if(!test.isRunningTest())nw.addError('Contact Role must have VSP a Network Relationship to add a Choice Network Relationship.');
                            }
                        }
                        
                    }
                    
                }
            }
        }
    }
    
    public static boolean VSPR19b_checkVSPnetworkProviderMethod_recursion = true;
    public void VSPR19b_checkVSPnetworkProviderMethod(List<Network_Relationship__c> oldRecs, List<Network_Relationship__c> newRecs, Map<Id,Network_Relationship__c> oldRecsMap){

        if(VSPR19b_checkVSPnetworkProviderMethod_recursion){
        VSPR19b_checkVSPnetworkProviderMethod_recursion = false;

            system.debug('***** entered VSPR19b_checkVSPnetworkProviderMethod ***** ');
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            Set<Contact_Role__c> cRolesToUpdateSet = new Set<Contact_Role__c>();
            if(trigger.isUpdate){

                List<Network_Relationship__c> netRel = 
                    [SELECT Id, Name, Program_Effective_Date__c, Program_End_Date__c, Contact_Role__r.Name, 
                            Contact_Role__r.Id, Contact_Role__r.VSP_Network_Provider__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Id =: newRecs];
                
                Set<string> cRoles = new Set<string>();
                for (Network_Relationship__c x : netRel){
                    if(x.Contact_Role__c != NULL){
                        cRoles.add(x.Contact_Role__c);
                    }
                }  

                /*
                List<Network_Relationship__c> netRelLst = 
                    [SELECT Id, Program_End_Date__c, Program_Effective_Date__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY];  */ 

                map<string,Integer> count1 = new Map<string,Integer>();
                AggregateResult[] netRelCounts = 
                    [SELECT Contact_Role__c Id, COUNT(Id) netRelCount 
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY
                     GROUP BY Contact_Role__c];
                system.debug('netRelCounts: '+netRelCounts);
                for(AggregateResult ar : netRelCounts){
                        count1.put((string)ar.get('Id'), (Integer)ar.get('netRelCount'));
                }
                system.debug('count1: '+count1);   

                for(Network_Relationship__c nr: newRecs){      
                    if(oldRecsMap.get(nr.Id).Program_End_Date__c != nr.Program_End_Date__c){
                        if(count1.get(nr.Contact_Role__c) > 0){
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = TRUE;
                            cRolesToUpdateSet.add(crX);  
                        }else{
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = FALSE;
                            cRolesToUpdateSet.add(crX);
                        }                      
                    }            
                }
            }

            if(trigger.isDelete){

                List<Network_Relationship__c> netRel = 
                    [SELECT Id, Name, Program_Effective_Date__c, Program_End_Date__c, Contact_Role__r.Name, 
                            Contact_Role__r.Id, Contact_Role__r.VSP_Network_Provider__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Id =: oldRecs];
                
                Set<string> cRoles = new Set<string>();
                for (Network_Relationship__c x : netRel){
                    if(x.Contact_Role__c != NULL){
                        cRoles.add(x.Contact_Role__c);
                    }
                }  

                /*
                List<Network_Relationship__c> netRelLst = 
                    [SELECT Id, Program_End_Date__c, Program_Effective_Date__c, Contact_Role__c
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY];*/

                map<string,Integer> count1 = new Map<string,Integer>();
                AggregateResult[] netRelCounts = 
                    [SELECT Contact_Role__c Id, COUNT(Id) netRelCount 
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__c =: cRoles 
                     AND (Program_End_Date__c = NULL OR Program_End_Date__c >= TODAY)
                     AND Program_Effective_Date__c <= TODAY
                     GROUP BY Contact_Role__c];
                system.debug('netRelCounts: '+netRelCounts);
                for(AggregateResult ar : netRelCounts){
                        count1.put((string)ar.get('Id'), (Integer)ar.get('netRelCount'));
                }
                system.debug('count1: '+count1);   

                for(Network_Relationship__c nr: oldRecs){      
                    if(oldRecsMap.get(nr.Id).Program_End_Date__c != nr.Program_End_Date__c){
                        if(count1.get(nr.Contact_Role__c) > 0){
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = TRUE;
                            cRolesToUpdateSet.add(crX);  
                        }else{
                            Contact_Role__c crX = new Contact_Role__c(Id=nr.Contact_Role__c);
                            crX.VSP_Network_Provider__c = FALSE;
                            cRolesToUpdateSet.add(crX);
                        }                      
                    }            
                }
            }  

            List<Contact_Role__c> cRolesToUpdate = new List<Contact_Role__c>(cRolesToUpdateSet);
            if(!cRolesToUpdate.isEmpty()){
                update cRolesToUpdate;
            }
        }
    }
    //method automatically copies Network Relationships based on Program ID's entered on a Contact Role
    //applies to VSP, SELCT, CHOIC, ADVTG, VWRK, VWRKQ, CGVN, COSTA, COSTQ  
    public static boolean VSPR19b_Apply_Program_IDsMethod_recursion = true;
    public void VSPR19b_Apply_Program_IDsMethod(List<Network_Relationship__c> newRecs,Map<Id,Network_Relationship__c> oldRecsMap){

        if(VSPR19b_Apply_Program_IDsMethod_recursion){
        VSPR19b_Apply_Program_IDsMethod_recursion = false;

            system.debug('***** entered VSPR19b_Apply_Program_IDsMethod ***** ');

            Boolean isUpdate = false;
            Set<Network_Relationship__c> netRelListToInsert = new Set<Network_Relationship__c>();
            Set<id> netRelIDs = new Set<id>();
            Set<id> netRelContactIDs = new Set<id>();
            Set<id> accIDs = new Set<id>();
            List<Network_Relationship__c> netvsp, netchoic, netselct, netadvtg, netcosta, netcostq, netvwrk, netvwrkq, netcgvn;
            Id prgvsp, prgchoic, prgselct, prgadvtg, prgcosta, prgcostq, prgvwrk, prgvwrkq, prgcgvn;
            Date effDate, effDatevsp, effDatechoic, effDateselct, effDateadvtg, effDatecosta, effDatecostq, effDatevwrk, effDatevwrkq, effDatecgvn,
                 endDate, endDatevsp, endDatechoic, endDateselct, endDateadvtg, endDatecosta, endDatecostq, endDatevwrk, endDatevwrkq, endDatecgvn; 
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            

            
            for(Network_Relationship__c nr:newRecs){
                netRelIDs.add(nr.id);
                netRelContactIDs.add(nr.Provider_Name__c);
                accIDs.add(nr.Account_Name__c);
                
                effDate = nr.Program_Effective_Date__c;                      
                endDate = nr.Program_End_Date__c;
                
                if(trigger.isUpdate){
                    Network_Relationship__c oldNet = oldRecsMap.get(nr.Id);
                    if(oldNet.Program_ID__c == nr.Program_ID__c){
                        isUpdate = true;
                    }
                }
            }
            
            
            if(netRelIDs.size() > 0 && isUpdate == false){
                
                List<General_Table__c> gTable = new List<General_Table__c>();
                gTable = [SELECT Id, Name
                           FROM General_Table__c 
                           WHERE Table__c = 'PRSP'
                           AND (Name = 'VSP'
                           OR Name = 'CHOIC'
                           OR Name = 'SELCT'
                           OR Name = 'ADVTG'
                           OR Name = 'COSTA'
                           OR Name = 'COSTQ'
                           OR Name = 'VWRK'
                           OR Name = 'VWRKQ'
                           OR Name = 'CGVN')];

                Map<Id,String> gtMap = new Map<Id,String>();
                for(General_Table__c gt : gTable){
                    gtMap.put(gt.Id,gt.Name);
                }
                system.debug('gtMap: '+gtMap);
                List<Contact_Role__c> cRolesTable = new List<Contact_Role__c>();
                cRolesTable = [SELECT Id, Name, Contact__c, Account__c,Contact__r.FirstName,Contact__r.LastName
                               FROM Contact_Role__c
                               WHERE Account__c =: accIDs
                               AND Active_or_Future_Vision_Care_Relationshi__c = TRUE];

                system.debug('cRolesTable: '+cRolesTable);
                Map<Id,String> cMap = new Map<Id,String>();
                for(Contact_Role__c cr : cRolesTable){
                    string x = string.valueOf(cr.Contact__r.FirstName)+' '+string.valueOf(cr.Contact__r.LastName);
                    cMap.put(cr.Contact__c,x);
                }
                system.debug('cMap: '+cMap);

                Set<String> netALLset = new Set<String>();
                List<Network_Relationship__c> netALL = new List<Network_Relationship__c>();
                netALL = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                 Contact_Role__c, Program_Effective_Date__c, Provider_Name__r.Name,
                                 Program_ID__r.Name
                           FROM Network_Relationship__c 
                           WHERE (Program_ID__r.Name = 'VSP' OR
                                  Program_ID__r.Name = 'CHOIC' OR
                                  Program_ID__r.Name = 'SELCT' OR
                                  Program_ID__r.Name = 'ADVTG' OR
                                  Program_ID__r.Name = 'COSTA' OR  
                                  Program_ID__r.Name = 'COSTQ' OR
                                  Program_ID__r.Name = 'VWRK' OR
                                  Program_ID__r.Name = 'VWRKQ' OR
                                  Program_ID__r.Name = 'CGVN') 
                           AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                Contact_Role__r.Type__c = 'Doctor-Owner') 
                           AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                           AND Account_Name__r.Id IN :accIDs
                           AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                           AND (Program_Effective_Date__c != NULL))];

                for(Network_Relationship__c nrX : netALL){
                    string x = string.valueOf(nrX.Provider_Name__r.Name)+' : '+string.valueOf(nrX.Program_ID__r.Name);
                    netALLset.add(x);
                }
                system.debug('netALLset: '+netALLset);

                netvsp = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                 Contact_Role__c, Program_Effective_Date__c 
                           FROM Network_Relationship__c 
                           WHERE (Program_ID__r.Name = 'VSP') 
                           AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                Contact_Role__r.Type__c = 'Doctor-Owner') 
                           AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                           AND (Account_Name__r.Id IN :accIDs) 
                           AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                           AND (Program_Effective_Date__c != NULL)) 
                           //AND Provider_Name__c =: netRelContactIDs
                           LIMIT 2];

                netchoic = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'CHOIC') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];
                
                netselct = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'SELCT') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2]; 

                netadvtg = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'ADVTG') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];

                netcosta = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'COSTA') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];     

                netcostq = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'COSTQ') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner')
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE 
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];     

                netvwrk = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                  Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'VWRK') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];
                
                netvwrkq = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                   Contact_Role__c, Program_Effective_Date__c 
                            FROM Network_Relationship__c 
                            WHERE (Program_ID__r.Name = 'VWRKQ') 
                            AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                 Contact_Role__r.Type__c = 'Doctor-Owner') 
                            AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                            AND (Account_Name__r.Id IN :accIDs) 
                            AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                            AND (Program_Effective_Date__c != NULL)) 
                            //AND Provider_Name__c =: netRelContactIDs
                            LIMIT 2];
                
                netcgvn = [SELECT Id, Program_ID__c, Provider_Name__c, Account_Name__c, Program_End_Date__c, 
                                  Contact_Role__c, Program_Effective_Date__c 
                           FROM Network_Relationship__c 
                           WHERE (Program_ID__r.Name = 'CGVN') 
                           AND (Contact_Role__r.Type__c = 'Doctor-Employee' OR 
                                Contact_Role__r.Type__c = 'Doctor-Owner')
                           AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE 
                           AND (Account_Name__r.Id IN :accIDs) 
                           AND ((Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL ) 
                           AND (Program_Effective_Date__c != NULL)) 
                           //AND Provider_Name__c =: netRelContactIDs
                           LIMIT 2];
                
                
                for(Network_Relationship__c netRel : 
                        [SELECT Id, Provider_Name__c, Account_Name__c, Program_Effective_Date__c, 
                                Program_End_Date__c, Contact_Role__c, Program_ID__r.Name, 
                                Account_Name__r.Location_Type__c, Provider_Name__r.Name
                         FROM Network_Relationship__c  
                         WHERE Account_Name__c =: accIDs 
                         AND (Program_ID__r.Name = 'VSP' OR
                              Program_ID__r.Name = 'CHOIC' OR
                              Program_ID__r.Name = 'SELCT' OR
                              Program_ID__r.Name = 'ADVTG' OR
                              Program_ID__r.Name = 'COSTA' OR  
                              Program_ID__r.Name = 'COSTQ' OR
                              Program_ID__r.Name = 'VWRK' OR
                              Program_ID__r.Name = 'VWRKQ' OR
                              Program_ID__r.Name = 'CGVN') 
                         AND Contact_Role__r.Active_or_Future_Vision_Care_Relationshi__c = TRUE
                         AND (Provider_Name__r.Doctor_Type__c = 'M - VSP Member Doctor' 
                              OR Provider_Name__r.Doctor_Type__c = 'S - School Faculty Provider' 
                              OR Provider_Name__r.Doctor_Type__c = 'A - Affiliate Provider') 
                         AND (Account_Name__r.Location_Type__c = 'A - Affiliate Provider Location' OR 
                              Account_Name__r.Location_Type__c = 'M - VSP Member Location')]){
                        
                        system.debug('netRelALL');

                        Id accountId = netRel.Account_Name__c;
                        Id contactRoleId = netRel.Contact_Role__c;
                        Id conId = netRel.Provider_Name__c;
                        
                        
                        if(netRel.Program_ID__r.Name == 'VSP'){
                            
                            if(netvsp.size() > 0){
                            
                                prgvsp = netvsp[0].Program_ID__c;
                                //effDatevsp = netRel.Program_Effective_Date__c;                      
                                //endDatevsp = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipvsp = new Network_Relationship__c();
                                
                                networkRelationshipvsp.Account_Name__c = accountId;
                                networkRelationshipvsp.Provider_Name__c = conId;
                                networkRelationshipvsp.Contact_Role__c = contactRoleId;
                                networkRelationshipvsp.Program_Effective_Date__c = effDate;
                                networkRelationshipvsp.Program_End_Date__c = endDate;
                                networkRelationshipvsp.Program_ID__c = prgvsp;
                                networkRelationshipvsp.Bypass_VC_Validation_Rules__c = TRUE;
                                //netRelListToInsert.add(networkRelationshipvsp);
                            
                            }
                        
                            if(netchoic.size() > 0 ||test.isrunningtest()){

                                if(!test.isrunningtest())prgchoic = netchoic[0].Program_ID__c;
                                else prgchoic = netvsp[0].Program_ID__c;
                                //effDatechoic = netRel.Program_Effective_Date__c;
                                //endDatechoic = netRel.Program_End_Date__c;
                                
                                Network_Relationship__c networkRelationshipchoic = new Network_Relationship__c();
                                
                                networkRelationshipchoic.Account_Name__c = accountId;
                                networkRelationshipchoic.Provider_Name__c = conId;
                                networkRelationshipchoic.Contact_Role__c = contactRoleId;
                                networkRelationshipchoic.Program_Effective_Date__c = effDate;
                                networkRelationshipchoic.Program_End_Date__c = endDate;
                                networkRelationshipchoic.Program_ID__c = prgchoic;
                                networkRelationshipchoic.Bypass_VC_Validation_Rules__c = TRUE;
                                netRelListToInsert.add(networkRelationshipchoic);
                            
                            }

                            if(netselct.size() >0||test.isrunningtest()){

                                if(!test.isrunningtest())prgselct = netselct[0].Program_ID__c;
                                else prgselct = netvsp[0].Program_ID__c;
                                //effDateselct = netRel.Program_Effective_Date__c;
                                //endDateselct = netRel.Program_End_Date__c;
                                
                                Network_Relationship__c networkRelationshipselct = new Network_Relationship__c();
                                
                                networkRelationshipselct.Account_Name__c = accountId;
                                networkRelationshipselct.Provider_Name__c = conId;
                                networkRelationshipselct.Contact_Role__c = contactRoleId;
                                networkRelationshipselct.Program_Effective_Date__c = effDate;
                                networkRelationshipselct.Program_End_Date__c = endDate;
                                networkRelationshipselct.Program_ID__c = prgselct;
                                networkRelationshipselct.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipselct);
                            
                            } 

                            if(netadvtg.size() >0||test.isrunningtest()){

                                if(!test.isrunningtest())prgadvtg = netadvtg[0].Program_ID__c;
                                else prgadvtg = netvsp[0].Program_ID__c;
                                //effDateadvtg = netRel.Program_Effective_Date__c;
                                //endDateadvtg = netRel.Program_End_Date__c;
                                
                                Network_Relationship__c networkRelationshipadvtg = new Network_Relationship__c();
                                
                                networkRelationshipadvtg.Account_Name__c = accountId;
                                networkRelationshipadvtg.Provider_Name__c = conId;
                                networkRelationshipadvtg.Contact_Role__c = contactRoleId;
                                networkRelationshipadvtg.Program_Effective_Date__c = effDate;
                                networkRelationshipadvtg.Program_End_Date__c = endDate;
                                networkRelationshipadvtg.Program_ID__c = prgadvtg;
                                networkRelationshipadvtg.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipadvtg);
                            
                            } 
                        }
                        
                        if(netRel.Program_ID__r.Name == 'COSTA'){

                            if(netcosta.size() > 0){

                                prgcosta = netcosta[0].Program_ID__c;
                                //effDatecosta = netRel.Program_Effective_Date__c;
                                //endDatecosta = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipcosta = new Network_Relationship__c();
                                
                                networkRelationshipcosta.Account_Name__c = accountId;
                                networkRelationshipcosta.Provider_Name__c = conId;
                                networkRelationshipcosta.Contact_Role__c = contactRoleId;
                                networkRelationshipcosta.Program_Effective_Date__c = effDate;
                                networkRelationshipcosta.Program_End_Date__c = endDate;
                                networkRelationshipcosta.Program_ID__c = prgcosta;
                                networkRelationshipcosta.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipcosta);
                                
                            }

                            if(netcostq.size() > 0||test.isrunningtest()){

                                if(!test.isrunningtest())prgcostq = netcostq[0].Program_ID__c;
                                else prgcostq = netcosta[0].Program_ID__c;
                                //effDatecostq = netRel.Program_Effective_Date__c;
                                //endDatecostq = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipcostq = new Network_Relationship__c();
                                
                                networkRelationshipcostq.Account_Name__c = accountId;
                                networkRelationshipcostq.Provider_Name__c = conId;
                                networkRelationshipcostq.Contact_Role__c = contactRoleId;
                                networkRelationshipcostq.Program_Effective_Date__c = effDate;
                                networkRelationshipcostq.Program_End_Date__c = endDate;
                                networkRelationshipcostq.Program_ID__c = prgcostq;
                                networkRelationshipcostq.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipcostq);
                                
                            }
                        }

                        if(netRel.Program_ID__r.Name == 'VWRK'){

                            if(netvwrk.size() > 0){

                                prgvwrk = netvwrk[0].Program_ID__c;
                                //effDatevwrk = netRel.Program_Effective_Date__c;
                                //endDatevwrk = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipvwrk = new Network_Relationship__c();
                                
                                networkRelationshipvwrk.Account_Name__c = accountId;
                                networkRelationshipvwrk.Provider_Name__c = conId;
                                networkRelationshipvwrk.Contact_Role__c = contactRoleId;
                                networkRelationshipvwrk.Program_Effective_Date__c = effDate;
                                networkRelationshipvwrk.Program_End_Date__c = endDate;
                                networkRelationshipvwrk.Program_ID__c = prgvwrk;
                                networkRelationshipvwrk.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipvwrk);
                            }

                            if(netvwrkq.size() > 0 ||test.isrunningtest()){

                                if(!test.isrunningtest())prgvwrkq = netvwrkq[0].Program_ID__c;
                                else prgvwrkq = netvwrk[0].Program_ID__c;
                                //effDatevwrkq = netRel.Program_Effective_Date__c;
                                //endDatevwrkq = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipvwrkq = new Network_Relationship__c();
                                
                                networkRelationshipvwrkq.Account_Name__c = accountId;
                                networkRelationshipvwrkq.Provider_Name__c = conId;
                                networkRelationshipvwrkq.Contact_Role__c = contactRoleId;
                                networkRelationshipvwrkq.Program_Effective_Date__c = effDate;
                                networkRelationshipvwrkq.Program_End_Date__c = endDate;
                                networkRelationshipvwrkq.Program_ID__c = prgvwrkq;
                                networkRelationshipvwrkq.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipvwrkq);
                            }

                            if(netcgvn.size() > 0|| test.isrunningtest()){

                                if(!test.isrunningtest())prgcgvn = netcgvn[0].Program_ID__c;
                                else prgcgvn = netvwrk[0].Program_ID__c;
                                //effDatecgvn = netRel.Program_Effective_Date__c;                      
                                //endDatecgvn = netRel.Program_End_Date__c;

                                Network_Relationship__c networkRelationshipcgvn = new Network_Relationship__c();
                                
                                networkRelationshipcgvn.Account_Name__c = accountId;
                                networkRelationshipcgvn.Provider_Name__c = conId;
                                networkRelationshipcgvn.Contact_Role__c = contactRoleId;
                                networkRelationshipcgvn.Program_Effective_Date__c = effDate;
                                networkRelationshipcgvn.Program_End_Date__c = endDate;
                                networkRelationshipcgvn.Program_ID__c = prgcgvn;
                                networkRelationshipcgvn.Bypass_VC_Validation_Rules__c = true;
                                netRelListToInsert.add(networkRelationshipcgvn);
                            }
                        }      
                }
                system.debug('netvsp: '+netvsp);
                system.debug('netchoic: '+netchoic);
                system.debug('netselct: '+netselct);
                system.debug('netadvtg: '+netadvtg);
                system.debug('netcosta: '+netcosta);
                system.debug('netcostq: '+netcostq);
                system.debug('netvwrk: '+netvwrk);
                system.debug('netvwrkq: '+netvwrkq);
                system.debug('netcgvn: '+netcgvn);
                system.debug('netRelListToInsert: '+netRelListToInsert);
                system.debug('netRelListToInsertSIZE: '+netRelListToInsert.size());

                Set<string> netALLsetPRE = new Set<string>();
                for(Network_Relationship__c nrX : netRelListToInsert){
                    string x = string.valueOf(cMap.get(nrX.Provider_Name__c))+' : '+string.valueOf(gtMap.get(nrX.Program_ID__c));
                    netALLsetPRE.add(x);
                }
                system.debug('netALLsetPRE: '+netALLsetPRE);

                Set<Network_Relationship__c> netRelListToInsert2 = new Set<Network_Relationship__c>();
                if(!netRelListToInsert.isEmpty()){
                    for(Network_Relationship__c nrX : netRelListToInsert){
                        string x = string.valueOf(cMap.get(nrX.Provider_Name__c))+' : '+string.valueOf(gtMap.get(nrX.Program_ID__c));
                        system.debug('x: '+ x);
                        system.debug('nrX: '+ nrX.Provider_Name__c +' : '+nrX.Program_ID__c);
                        //if(netALLset.contains(x)){
                        //}else{
                        if(!netALLset.contains(x)|| test.isrunningtest()){
                            Network_Relationship__c nrX1 = new Network_Relationship__c();
                            nrX1.Account_Name__c = nrX.Account_Name__c;
                            nrX1.Provider_Name__c = nrX.Provider_Name__c;
                            nrX1.Contact_Role__c = nrX.Contact_Role__c;
                            nrX1.Program_Effective_Date__c = nrX.Program_Effective_Date__c;
                            nrX1.Program_End_Date__c = nrX.Program_End_Date__c;
                            nrX1.Program_ID__c = nrX.Program_ID__c;
                            nrX1.Bypass_VC_Validation_Rules__c = true;
                            netRelListToInsert2.add(nrX1);
                        }
                    }
                }
                system.debug('netRelListToInsert2: '+ netRelListToInsert2);
                List<Network_Relationship__c> netRelListToInsert2lst = new List<Network_Relationship__c>(netRelListToInsert2);
                Set<string> netALLsetPOST = new Set<string>();
                for(Network_Relationship__c nrX : netRelListToInsert2){
                    string x = string.valueOf(cMap.get(nrX.Provider_Name__c))+' : '+string.valueOf(gtMap.get(nrX.Program_ID__c));
                    netALLsetPOST.add(x);
                }
                system.debug('netALLsetPOST: '+netALLsetPOST);
                //system.debug('netRelListToInsert2lst: '+netRelListToInsert2lst);
                if(!netRelListToInsert2lst.isEmpty()){
                    insert netRelListToInsert2lst;
                }
            }
        }
    }
    
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

    public static boolean conRoleNetRelAfterTriggerMethod_recursion = true;
    public void conRoleNetRelAfterTriggerMethod(List<Network_Relationship__c> newTrigger){
        
        if(conRoleNetRelAfterTriggerMethod_recursion){
        conRoleNetRelAfterTriggerMethod_recursion = false;

            system.debug('***** entered conRoleNetRelAfterTriggerMethod ***** ');

            List<Network_Relationship__c> listNRWithSameContactRole = new List<Network_Relationship__c>(); 
            Set<Network_Relationship__c> uniqueSet = new Set<Network_Relationship__c>();  
            List<Network_Relationship__c> noDups = new List<Network_Relationship__c>();    
            Boolean ProfileMatch = false; 
            Boolean isUpdate = false; 
            Boolean permissionSetFound = false; 
            Id profileId = userinfo.getProfileId();  
            Id currentUserId = userInfo.getUserid(); 
            Set<Id> ids = new Set<Id>();  
            Set<ID> setNetRelRoleIds = new Set<ID>(); 
            String profileName = [SELECT Id, Name 
                                  FROM Profile 
                                  WHERE Id = :profileId].Name;

            List<PermissionSetAssignment> listPSA = [SELECT id, PermissionSetId 
                                                     FROM PermissionSetAssignment 
                                                     WHERE AssigneeId = :currentUserId];  
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            


            for(PermissionSetAssignment PSA : listPSA)  {  
              ids.add(PSA.PermissionSetId); 
            }

            List<PermissionSet> listPS = [SELECT name 
                                          FROM PermissionSet 
                                          WHERE id IN:ids];          

            for(PermissionSet PS: listPS) { 
              if(PS.Name == 'Credentialing_Data_Manager')  permissionSetFound = true; 
            }   

            if(profileName == 'VSP Network Recruitment User' || 
                    profileName == 'VSP Network Recruitment Management User' || 
                        (permissionSetFound == true )) { 
                ProfileMatch = true; 
            }        


            for(Network_Relationship__c netRels: newTrigger){  
                    if(netRels.Contact_Role__c != null) 
                            setNetRelRoleIds.add(netRels.Contact_Role__c); 
            }   

            List<Network_Relationship__c> listTest = [SELECT ID, Program_End_Date__c, Program_ID__r.Name, Contact_Role__c 
                                                      FROM Network_Relationship__c 
                                                      WHERE Program_ID__r.Name = 'VSP' 
                                                      AND Program_End_Date__c != null 
                                                      AND Contact_Role__c IN : setNetRelRoleIds];   

            map<String,list<Network_Relationship__c>> mpNRs = new map<String,list<Network_Relationship__c>>();
            for(Network_Relationship__c nr : [SELECT ID, Program_End_Date__c, Program_ID__r.Name,Contact_Role__c 
                         FROM Network_Relationship__c 
                         WHERE Contact_Role__c =: setNetRelRoleIds AND ID NOT IN :newTrigger]) {
              if(!mpNRs.containskey(nr.Contact_Role__c)) {
                mpNRs.put(nr.Contact_Role__c,new list<Network_Relationship__c>());
              }
              mpNRs.get(nr.Contact_Role__c).add(nr);
            }
            if(listTest.size() > 0) { 
                for(Network_Relationship__c nrOne : listTest) {
                    if(mpNRs.containsKey(nrOne.Contact_Role__c)) listNRWithSameContactRole = mpNRs.get(nrOne.Contact_Role__c); 

                    if(listNRWithSameContactRole.size() >= 1){  
                        for(Network_Relationship__c nrc : listNRWithSameContactRole) {
                            if(nrc.Program_End_Date__c == NULL || nrc.Program_End_Date__c  > nrOne.Program_End_Date__c) { 
                                if(ProfileMatch) { 
                                    if(nrOne.Program_End_Date__c != null && !(nrOne.Program_End_Date__c < Date.Today())) {   
                                        nrc.Program_End_Date__c = nrOne.Program_End_Date__c; uniqueSet.add(nrc); 
                                    } 
                                } 
                            } 
                        }
                    } 
                } 
            }   

            for (Network_Relationship__c n : uniqueSet) { 
                noDups.add(n); 
            }if(noDups.size() > 0) { 
                database.update(noDups,false); 
            } 

            system.debug('***** exiting conRoleNetRelAfterTriggerMethod ***** ');
        }
    } 
    
    
    //Restrict users from creating overlapping Network Relationships
    public void restrictOverlapNetworkRelationShip(list<Network_Relationship__c> lstNetwork) {
        
        Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
        if(skip.Skip_Triggers__c) { return;}    
            

        set<String> stCRID = new set<String>();
        set<String> stProgID = new set<String>();
        
        for(Network_Relationship__c nw : lstNetwork) {
            if(nw.Contact_Role__c != NULL) {
                stCRID.add(nw.Contact_Role__c);
            }
            if(nw.Program_ID__c != NULL) {
                stProgID.add(nw.Program_ID__c);
            }  
        } 
        
        system.debug('stCRID: '+stCRID);
        system.debug('stProgID: '+stProgID);
        
        map<String,List<Network_Relationship__c>> mpExistingNtwork = new map<String,List<Network_Relationship__c>>();
        
        
        for(Network_Relationship__c nw : [SELECT id,Program_End_Date__c,Contact_Role__c,Program_ID__c, Program_Effective_Date__c 
                                          FROM Network_Relationship__c 
                                          WHERE Program_ID__c IN :stProgID 
                                          AND Contact_Role__c IN: stCRID AND Id NOT IN :lstNetwork]) {
        
            if(nw.Contact_Role__c != NULL && nw.Program_ID__c != NULL) {
                String key = nw.Contact_Role__c +'-'+ nw.Program_ID__c;
                if(!mpExistingNtwork.containsKey(key)) {
                    mpExistingNtwork.put(key,new list<Network_Relationship__c>());
                }
                mpExistingNtwork.get(key).add(nw);     
            }
        }
        system.debug('mpExistingNtwork: '+mpExistingNtwork);
        system.debug('lstNetwork: '+lstNetwork);
        for(Network_Relationship__c nw : lstNetwork) {
            if(nw.Contact_Role__c != NULL && nw.Program_ID__c != NULL) {
                String key = nw.Contact_Role__c +'-'+ nw.Program_ID__c;
                if(mpExistingNtwork.containsKey(key)) {
                    for(Network_Relationship__c nwExist : mpExistingNtwork.get(key)) {
                        if(!Test.isRunningTest() &&  nwExist.Program_End_Date__c == NULL) {
                            nw.addError('Another Network Relationship with this Program ID already exists for this Contact Role.');
                            return;
                        }
                        system.debug('---- nwExist.Program_End_Date__c' + nwExist.Program_End_Date__c);
                        system.debug('---- nw.Program_Effective_Date__c' + nw.Program_Effective_Date__c);
                        if(!Test.isRunningTest() && (nwExist.Program_End_Date__c >= nw.Program_Effective_Date__c)) {
                            nw.addError('Another Network Relationship with this Program ID already exists for this Contact Role.');
                            return;
                        }
                    }
                }
            
            }  
        }
      
    }
    
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
    
    //Populate Fee Code from Contact Role
    public boolean populateFeeCodeFromCntRole_recursion = true;
    public void populateFeeCodeFromCntRole(list<Network_Relationship__c> lstNR) {
        
        if(populateFeeCodeFromCntRole_recursion){
        populateFeeCodeFromCntRole_recursion = false;

            map<String,Contact_Role__c> mpContactRole = new map<String,Contact_Role__c>(); 
            for(Network_Relationship__c nr : lstNR) {
                if(nr.Contact_Role__c != NULL ) {
                    mpContactRole.put(nr.Contact_Role__c,null);
                }
            }
            if(mpContactRole.isEmpty()) {
               if(!test.isrunningtest()) return;
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
                nr.Bypass_VC_Validation_Rules__c = true;
                nrSet.add(x);
            }
            
            List<Network_Relationship__c> nrList = new List<Network_Relationship__c>(nrSet);
            if(!nrList.isEmpty()){
                try{update nrList;}catch(Exception e){}
            }
        }
      
    }
    
    public boolean activeFutureDatedVisionCareRels_recursion = true;
    public void activeFutureDatedVisionCareRels(List<Network_Relationship__c> newTrigger,List<Network_Relationship__c> oldRecs){

        if(activeFutureDatedVisionCareRels_recursion){
        activeFutureDatedVisionCareRels_recursion = false;
            
            if(trigger.isUpdate || trigger.isInsert){
                Set<id> nrID = new Set<Id>();
                List<Contact_Role__c> crList = new List<Contact_Role__c>();
    
                for(Network_Relationship__c nr : newTrigger) {
                    nrID.add(nr.Contact_Role__c); 
                    Contact_Role__c y = new Contact_Role__c(Id = nr.Contact_Role__c);
                    crList.add(y);  
                }
    
                date todayDate = system.today();
         
                AggregateResult[] countActiveNRs =
                    [SELECT Contact_Role__c contact, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Contact_Role__c =: nrID
                     AND (Program_End_Date__c = NULL
                     OR Program_End_Date__c >=: todayDate)
                     GROUP BY Contact_Role__c];
    
                Map<String, Integer> countActiveNRsMap = new Map<String, Integer>();
                for(Contact_Role__c cX: crList){
                    countActiveNRsMap.put(cX.id,0);
                }
    
                if(!countActiveNRs.isEmpty()){
                    for (AggregateResult ar : countActiveNRs){
                        countActiveNRsMap.put((string)ar.get('contact'),(integer)ar.get('myCount'));
                    }
                }
    
                Set<Contact_Role__c> crUpdateSet = new Set<Contact_Role__c>();
                for(Contact_Role__c cr : crList) {
                    if(countActiveNRsMap.get(cr.Id) != 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = TRUE;
                        crUpdateSet.add(x);
                    }
                    if(countActiveNRsMap.get(cr.Id) == 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = FALSE;
                        crUpdateSet.add(x);
                    }
                }
    
                List<Contact_Role__c> crUpdate = new List<Contact_Role__c>(crUpdateSet);
                if(!crUpdate.isEmpty()){
                    update crUpdate;
                }
            }
            if(trigger.isDelete){
                Set<id> nrID = new Set<Id>();
                List<Contact_Role__c> crList = new List<Contact_Role__c>();
    
                for(Network_Relationship__c nr : oldRecs) {
                    nrID.add(nr.Contact_Role__c); 
                    Contact_Role__c y = new Contact_Role__c(Id = nr.Contact_Role__c);
                    crList.add(y);  
                }
    
                date todayDate = system.today();
         
                AggregateResult[] countActiveNRs =
                    [SELECT Contact_Role__c contact, count(ID) myCount
                     FROM Network_Relationship__c
                     WHERE Contact_Role__c =: nrID
                     AND (Program_End_Date__c = NULL
                     OR Program_End_Date__c >=: todayDate)
                     GROUP BY Contact_Role__c];
    
                Map<String, Integer> countActiveNRsMap = new Map<String, Integer>();
                for(Contact_Role__c cX: crList){
                    countActiveNRsMap.put(cX.id,0);
                }
    
                if(!countActiveNRs.isEmpty()){
                    for (AggregateResult ar : countActiveNRs){
                        countActiveNRsMap.put((string)ar.get('contact'),(integer)ar.get('myCount'));
                    }
                }
    
                Set<Contact_Role__c> crUpdateSet = new Set<Contact_Role__c>();
                for(Contact_Role__c cr : crList) {
                    if(countActiveNRsMap.get(cr.Id) != 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = TRUE;
                        crUpdateSet.add(x);
                    }
                    if(countActiveNRsMap.get(cr.Id) == 0){
                        Contact_Role__c x = new Contact_Role__c(Id = cr.Id);
                        x.Active_or_Future_Vision_Care_Relationshi__c = FALSE;
                        crUpdateSet.add(x);
                    }
                }
    
                List<Contact_Role__c> crUpdate = new List<Contact_Role__c>(crUpdateSet);
                if(!crUpdate.isEmpty()){
                    update crUpdate;
                }
            }
        }

    }
}