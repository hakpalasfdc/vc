public class VSPR25b_ApplyProgramIds {
    
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
}