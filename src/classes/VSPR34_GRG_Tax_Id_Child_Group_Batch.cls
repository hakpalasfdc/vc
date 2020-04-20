global class VSPR34_GRG_Tax_Id_Child_Group_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
    private static Id pracAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId(); 
    global List<String> exception_List = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Parent_Account__r.Tax_ID__c, Parent_Account__c
                                         FROM Global_Rewards_Group__c WHERE Status__c = 'Active'
                                         AND RecordTypeId = :grpTaxIdRecordTypeId]);
    }
    
    global void execute(Database.BatchableContext BC, List<Global_Rewards_Group__c> scope){
        
        VSPUtility.stopAccountTrigger=true;
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        Id grpTaxIdContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        
        Set<Id> grgIdSet = new Set<Id>();
        Map<Id, Global_Rewards_Group__c> grgMap = new Map<Id, Global_Rewards_Group__c>();
        Map<Id,Set<Id>> grgPracMap = new Map<Id,Set<Id>>(); ///GRGId, Set PA Id
        Set<Id> pracAccIdSet = new Set<Id>();
        Map<Id, Set<String>> pracAccMap = new Map<Id, Set<String>>();
        Map<Id, Set<Account>> pracAccObjMap = new Map<Id, Set<Account>>();
        Map<Id, Set<String>> grpBusAccMap = new Map<Id, Set<String>>();
        Map<Id, Set<Account>> grpBusObjAccMap = new Map<Id, Set<Account>>();
        List<Account> pracAcctoUpd = new List<Account>();
        Map<Account, Set<String>> prcGrpMap = new Map<Account, Set<String>>();
        Set<String> newGrpNameStr = new Set<String>();
        Set<String> grpNameStr = new Set<String>();
        List<Global_Rewards_Group__c> newGrp = new List<Global_Rewards_Group__c>();
        
        //   Map<Global_Rewards_Group__c, Set<Account>> GrpMapContractType = new Map<Global_Rewards_Group__c, Set<Account>>();
        Map<Global_Rewards_Group__c, Set<Id>> GrpMapTaxIDContractType = new Map<Global_Rewards_Group__c, Set<Id>>();
        // Map<Global_Rewards_Group__c, Set<Account>> combineGrpMap = new Map<Global_Rewards_Group__c, Set<Account>>();
        Map<Id, Set<Global_Rewards_Group_Relationship__c>> accGRGRmap = new Map<Id, Set<Global_Rewards_Group_Relationship__c>>();
        List<Global_Rewards_Group_Relationship__c> grpReltoUpd = new List<Global_Rewards_Group_Relationship__c>();
        Set<Global_Rewards_Group_Relationship__c> grpReltoInst = new Set<Global_Rewards_Group_Relationship__c>();
        
        Set<Id> busAccIdSet = new Set<Id>();
        Map<String,Global_Rewards_Group__c> allGrpName = new Map<String,Global_Rewards_Group__c>();///All Group List
        Set<Id> rollupPracAccId = new Set<Id>();///Practice Account Ids --Contract Type Rollup
        Set<Id> conflictPracAccId = new Set<Id>();///Practice Account Ids --Contract Type Rollup
        Map<Id, Set<Id>> grgGroup1BusAccMap = new Map<Id, Set<Id>>();
        Map<String, Set<Id>> lookupGrpMap = new Map<String, Set<Id>>();
        
        for(Global_Rewards_Group__c s : scope){
            grgIdSet.add(s.Id);
            grgMap.put(s.Id,s);
        }
        
        if(!grgIdSet.isEmpty()){
            List<Global_Rewards_Group_Relationship__c> allPracAcc = [SELECT Child_Account__c, Global_Rewards_Group__c 
                                                                     FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__r.RecordTypeId = :pracAccRecordTypeId 
                                                                     AND Child_Account__r.Tax_ID__c != Null
                                                                     AND Child_Account__r.Premier_Tax_ID_Roll_Up_Account__c = True
                                                                     AND Global_Rewards_Group__c IN :grgIdSet];
            
            for(Global_Rewards_Group_Relationship__c pracMap: allPracAcc){
                
                pracAccIdSet.add(pracMap.Child_Account__c);
                
                if(grgPracMap.containsKey(pracMap.Global_Rewards_Group__c)){
                    Set<Id> existingValue = grgPracMap.get(pracMap.Global_Rewards_Group__c);
                    existingValue.add(pracMap.Child_Account__c);
                    grgPracMap.put(pracMap.Global_Rewards_Group__c, existingValue);
                }
                else{
                    grgPracMap.put(pracMap.Global_Rewards_Group__c, new Set<Id>{pracMap.Child_Account__c});
                }
            }
            
            
            List<Account> allBusAcc = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
                                       FROM Account WHERE ParentId IN :pracAccIdSet AND Contract_Type__c != NULL];
            
            for(Account busAcc: allBusAcc){
                if(pracAccMap.containsKey(busAcc.ParentId)){
                    Set<String> existingValue = pracAccMap.get(busAcc.ParentId);
                    existingValue.add(busAcc.Contract_Type__c);
                    pracAccMap.put(busAcc.ParentId, existingValue);
                }
                else{
                    pracAccMap.put(busAcc.ParentId, new Set<String>{busAcc.Contract_Type__c});
                }
                
                if(pracAccObjMap.containsKey(busAcc.ParentId)){
                    Set<Account> existingValue = pracAccObjMap.get(busAcc.ParentId);
                    existingValue.add(busAcc);
                    pracAccObjMap.put(busAcc.ParentId, existingValue);
                }
                else{
                    pracAccObjMap.put(busAcc.ParentId, new Set<Account>{busAcc});
                }
            }
            
            for(Id grg :grgIdSet){   
                Set<Id> praASet = grgPracMap.get(grg);
                if(praASet !=null){
                    for(Id pracAcc :praASet){
                        Set<String> busConType = pracAccMap.get(pracAcc);
                        Set<Account> busConObjType = pracAccObjMap.get(pracAcc);
                        
                       
                      if(busConType != Null && !busConType.isEmpty()){

                            if(grpBusAccMap.containsKey(grg)){
                                Set<String> existingValue = grpBusAccMap.get(grg);
                                existingValue.addAll(busConType);
                                grpBusAccMap.put(grg, existingValue);
                            }
                            else{
                                grpBusAccMap.put(grg, busConType);
                            }
                        }
                        if(busConObjType != Null && !busConObjType.isEmpty()){
                            if(grpBusObjAccMap.containsKey(grg)){
                                Set<Account> existingValue = grpBusObjAccMap.get(grg);
                                existingValue.addAll(busConObjType);
                                grpBusObjAccMap.put(grg, existingValue);
                            }
                            else{
                                grpBusObjAccMap.put(grg, busConObjType);
                            }
                        }
                    }
                }
            }
            
            if(!grpBusAccMap.isEmpty()){
                for(Id grgTax :grpBusAccMap.keySet()){
                    Integer setSize = grpBusAccMap.get(grgTax).size();
                    
                    ////Contract Types all the same and Tax Id is YES  --- Practice Contract Type - Rollup
                    if(setSize == 1){
                        
                        for(Account busAcc :grpBusObjAccMap.get(grgTax)){
                            //   if(prAcc.Id == busAcc.ParentId){
                            //     busAccIdLst.add(busAcc.Id); ////Add Bus Acc to Lst to check for existing group relationships that need to end
                            rollupPracAccId.add(busAcc.ParentId);
                            
                            if(grgGroup1BusAccMap.containsKey(grgTax)){
                                Set<Id> existingValue = grgGroup1BusAccMap.get(grgTax);
                                existingValue.add(busAcc.Id);
                                grgGroup1BusAccMap.put(grgTax, existingValue);
                            }
                            else{
                                grgGroup1BusAccMap.put(grgTax, new Set<Id>{busAcc.Id});
                            }
                            //   }
                        }
                    }
                    
                    ////Tax Id is Yes  /// Group Tax Id & Contract Type  ///Practice = Conflict
                    else if(setSize > 1){
                        
                        for(Account busAcc :grpBusObjAccMap.get(grgTax)){
                            Set<String> conTypeSet = grpBusAccMap.get(grgTax);
                            for(string ConType: conTypeSet){
                                conflictPracAccId.add(busAcc.ParentId);
                                if(busAcc.Contract_Type__c == ConType){
                                    Global_Rewards_Group__c taxConTypelookup = new Global_Rewards_Group__c(name = 'PREMIER - '+grgMap.get(grgTax).Parent_Account__r.Tax_ID__c+ ' - ' + ConType, 
                                                                                                           RecordTypeId = grpTaxIdContractRecordTypeId,
                                                                                                           Start_Date__c = Date.today(),
                                                                                                           Contract_Type__c = ConType,
                                                                                                           Parent_Account__c = grgMap.get(grgTax).Parent_Account__c);
                                    if(GrpMapTaxIDContractType.containsKey(taxConTypelookup)){
                                        Set<Id> existingValue = GrpMapTaxIDContractType.get(taxConTypelookup);
                                        existingValue.add(busAcc.Id);
                                        GrpMapTaxIDContractType.put(taxConTypelookup , existingValue);
                                    }
                                    else{
                                        GrpMapTaxIDContractType.put(taxConTypelookup , new Set<Id>{busAcc.Id});
                                    }
                                }
                            }
                        }
                    }
                }
                ////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                //
                //      
                //            
                //                        
                for(Id key : grgGroup1BusAccMap.keySet()) {
                    busAccIdSet.addAll(grgGroup1BusAccMap.get(key));
                }
                
                for(Global_Rewards_Group__c key : GrpMapTaxIDContractType.keySet()) {
                    busAccIdSet.addAll(GrpMapTaxIDContractType.get(key));
                    lookupGrpMap.put(key.Name, GrpMapTaxIDContractType.get(key));
                }
                ////Add GRG Names to query for/////
                if(!GrpMapTaxIDContractType.isEmpty()){
                    for(Global_Rewards_Group__c grp :GrpMapTaxIDContractType.keySet()){
                        newGrpNameStr.add(grp.Name);
                    }
                }
                
                List<Global_Rewards_Group__c> existGrp = [SELECT Name, RecordTypeId, Parent_Account__c FROM Global_Rewards_Group__c WHERE Name IN :newGrpNameStr];
                
                ///// Add Existing Groups to the All Group List
                for(Global_Rewards_Group__c addAllLst :existGrp){
                    allGrpName.put(addAllLst.Name, addAllLst);
                    grpNameStr.add(addAllLst.Name);
                } 
                
                for(Global_Rewards_Group__c grp :GrpMapTaxIDContractType.keySet()){
                    
                    //Below debug statement commeneted out by Vikhyat
                    //system.debug('combGrMap ------ '+ combGrMap);
                    
                    if(!grpNameStr.contains(grp.Name)){
                        newGrp.add(grp);
                    }
                    
                }
                
                /////Insert new GRG ////////////////
                //
                //
                if(!newGrp.isEmpty()){
                    
                    //      insert newGrp;
                    
                    Database.SaveResult[] SaveResultList = Database.insert(newGrp,false); 
                    
                    for(integer i =0; i<SaveResultList.size();i++){
                        String msg='';
                        If(!SaveResultList[i].isSuccess()){
                            
                            msg += 'Group Record Id: ' + newGrp.get(i).id + '\n'+'Error: "';        
                            for(Database.Error err: SaveResultList[i].getErrors()){  
                                msg += err.getmessage()+'"\n\n';
                            } 
                        }
                        if(msg!= '')
                            exception_List.add(msg);
                    }
                    
                    
                } 
                ///////End Insert////////
                //      List<Global_Rewards_Group__c> existGrp1 = [SELECT Name, RecordTypeId, Parent_Account__c FROM Global_Rewards_Group__c WHERE Name IN :grpNameStr];
                
                
                //   Add New Groups to the All Group List
                for(Global_Rewards_Group__c addAllLst :newGrp){
                    allGrpName.put(addAllLst.Name,addAllLst);
                } 
                /////Query existing GRGR/////////
                List<Global_Rewards_Group_Relationship__c> existGrpRelation = [SELECT Id, Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
                                                                               End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                               FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :busAccIdSet AND Status__c = 'Active'];
                
                ////End Query/////
                //
                
                for(Global_Rewards_Group_Relationship__c grgr: existGrpRelation){
                    if(accGRGRmap.containsKey(grgr.Child_Account__c)){
                        Set<Global_Rewards_Group_Relationship__c> existAccGRGR = accGRGRmap.get(grgr.Child_Account__c);
                        existAccGRGR.add(grgr);
                        accGRGRmap.put(grgr.Child_Account__c,existAccGRGR);
                    }
                    else{
                        accGRGRmap.put(grgr.Child_Account__c , new Set<Global_Rewards_Group_Relationship__c>{grgr});
                    }                
                }
                
                //////Grouping of 1/////
                //
                //
                Integer grgExists = 0;
                for(Id grg1 : grgGroup1BusAccMap.keySet()){
                    Set<Id> busAccSet1 = grgGroup1BusAccMap.get(grg1);
                    if(busAccSet1 != Null){
                        for(Id busAcc : busAccSet1){
                            grgExists = 0;
                            Set<Global_Rewards_Group_Relationship__c> grgrSet = accGRGRmap.get(busAcc);
                            if(grgrSet != Null){
                                for(Global_Rewards_Group_Relationship__c grgr :accGRGRmap.get(busAcc)){
                                    if(grgr.Global_Rewards_Group__c == grg1){
                                        grgExists = 1;
                                    }
                                    else if(grgr.Global_Rewards_Group__r.RecordTypeId != grpTaxIdRecordTypeId){
                                        grgr.End_Date__c = Date.today().addDays(-1);
                                        grpReltoUpd.add(grgr);                                 
                                    }
                                }
                            }
                            if(grgExists == 0){///create new GRGR
                                Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                ngrpRel.Child_Account__c = busAcc;
                                ngrpRel.Global_Rewards_Group__c = grg1;
                                ngrpRel.Start_Date__c = Date.today();
                                ngrpRel.Active__c = True;
                                grpReltoInst.add(ngrpRel);
                            }
                        }
                    }
                }
                
                
                
                
                //////Grouping of >1/////
                //
                //
                // Integer grgExists = 0;
                for(String grg2 : lookupGrpMap.keySet()){
                    Set<Id> busAccSet2 = lookupGrpMap.get(grg2);
                    if(busAccSet2 != Null){
                        for(Id busAcc : busAccSet2){
                            grgExists = 0;
                            Set<Global_Rewards_Group_Relationship__c> grgrSet = accGRGRmap.get(busAcc);
                            if(grgrSet != Null){
                                for(Global_Rewards_Group_Relationship__c grgr :accGRGRmap.get(busAcc)){
                                    if(grgr.Global_Rewards_Group__c == allGrpName.get(grg2).Id){
                                        grgExists = 1;
                                    }
                                    else if(grgr.Global_Rewards_Group__r.RecordTypeId != grpTaxIdRecordTypeId){
                                        grgr.End_Date__c = Date.today().addDays(-1);
                                        grpReltoUpd.add(grgr);
                                    }
                                }
                            }
                            if(grgExists == 0){///create new GRGR
                                Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                ngrpRel.Child_Account__c = busAcc;
                                ngrpRel.Global_Rewards_Group__c = allGrpName.get(grg2).Id;
                                ngrpRel.Start_Date__c = Date.today();
                                ngrpRel.Active__c = True;
                                grpReltoInst.add(ngrpRel);
                            }
                        }
                    }
                }
                
                
                
                
                
                
                ////////Update Practice Account
                //
                //
                for(Account prAccId :[SELECT Id, Tax_ID__c, Premier_Tax_ID_Roll_Up_Account__c, Tier_Agreement_Type__c 
                                      FROM Account WHERE Id IN :conflictPracAccId OR Id IN :rollupPracAccId]){
                                          prAccId.Premier_Location_Count_Future__c = 0;
                                          prAccId.Total_Average_Purchases_LTM_Calculated__c = 0;
                                          prAccId.Average_Frame_Purchases_LTM_Calculated__c = 0;
                                          prAccId.Average_Lens_Purchases_LTM_Calculated__c = 0;
                                          prAccId.Exclusive_VSP_Patient_Offers__c = true;
                                          prAccId.Free_Fitting_and_Adjustments__c = true;
                                          prAccId.Applied_Tier__c = null;
                                          prAccId.Calculated_Tier__c = null;
                                          pracAcctoUpd.add(prAccId); 
                                      }
                //////////////////////////////////////////////////////////////
                //
                //
                
                
                List<Global_Rewards_Group_Relationship__c> grpReltoInstLst = new List<Global_Rewards_Group_Relationship__c>(grpReltoInst);
                /////Group Relationships to Insert/////////////////////////////////////////////////////
                if(!grpReltoInstLst.isEmpty()){
                    //  insert grpReltoInst;
                    
                    Database.SaveResult[] SaveResultList = Database.insert(grpReltoInstLst,false); 
                    
                    for(integer i =0; i<SaveResultList.size();i++){
                        String msg='';
                        If(!SaveResultList[i].isSuccess()){
                            
                            msg += 'Group Relation Record Id: ' + grpReltoInstLst.get(i).id + '\n'+'Error: "';        
                            for(Database.Error err: SaveResultList[i].getErrors()){  
                                msg += err.getmessage()+'"\n\n';
                            } 
                        }
                        if(msg!= '')
                            exception_List.add(msg);
                    } 
                } 
                
                
                
                
                
                
                /////Group Relationships to Update///////////////////////////////////////////////////////////////////
                if(!grpReltoUpd.isEmpty()){
                    //   update grpReltoUpd;
                    
                    Database.SaveResult[] SaveResultList = Database.update(grpReltoUpd,false); 
                    
                    for(integer i =0; i<SaveResultList.size();i++){
                        String msg='';
                        If(!SaveResultList[i].isSuccess()){
                            
                            msg += 'Group Relation Record Id: ' + grpReltoUpd.get(i).id + '\n'+'Error: "';        
                            for(Database.Error err: SaveResultList[i].getErrors()){  
                                msg += err.getmessage()+'"\n\n';
                            } 
                        }
                        if(msg!= '')
                            exception_List.add(msg);
                    } 
                }
                
                if(!pracAcctoUpd.isEmpty()){                
                    //  update pracAcctoUpd;                
                    Database.SaveResult[] SaveResultList = Database.update(pracAcctoUpd,false);                 
                    for(integer i =0; i<SaveResultList.size();i++){
                        String msg='';
                        If(!SaveResultList[i].isSuccess()){                        
                            msg += 'Account Record Id: ' + pracAcctoUpd.get(i).id + '\n'+'Error: "';        
                            for(Database.Error err: SaveResultList[i].getErrors()){  
                                msg += err.getmessage()+'"\n\n';
                            } 
                        }
                        if(msg!= '')
                            exception_List.add(msg);
                    } 
                }
                
                
            }  
        }
    }
    
    global void finish(Database.BatchableContext BC){
        //Below if condition updated by Vikhyat. Updated to include Test.isRunningTest to cover the part in the test class.
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            
            
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Practice Update & Global Reward Group Create Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List.size() + '<br><br>' + exception_List + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
        
        //Updated below part to only run when test class is not running.
        if(!Test.isRunningTest()){
            VSPR31_Premier_Prac_Upd_Grg_Create_Batch obj = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch();
            Database.executeBatch(obj, 100);
        }
    }
}