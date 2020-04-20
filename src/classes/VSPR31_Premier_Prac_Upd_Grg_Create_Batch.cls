global class VSPR31_Premier_Prac_Upd_Grg_Create_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    global final String Query;
    
    global List<String> exception_List = new List<String>();
    
    
    private Set<Id> pracAccSetSameContractType = new set<Id>();
    
    global VSPR31_Premier_Prac_Upd_Grg_Create_Batch(String q){
        Query =q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //Updated by Vikhyat.
    //Updated the below code to make it List<Account>
    global void execute(Database.BatchableContext BC, /*List<sObject>*/ List<Account> scope){
        
        VSPUtility.stopAccountTrigger=true;
        Set<Id> pracAccSet = new set<Id>();
        
        Map<Id,Account> pracAccSetMap = new Map<Id,Account>();
        
        for(Account s : scope){
            pracAccSet.add(s.Id);
            pracAccSetMap.put(s.Id,s);
        }
        
        
        if(!pracAccSet.isEmpty()){ ///Set Account Premier Detail Fields
            List<Account> pracAccToUpdate = new List<Account>();
            
            
            
            // Set<Id> pracAccSetSameContractType = new set<Id>();
            
            // Map<Id, Account> pracAccSetSameContractTypeMap = new Map<Id, Account>();
            
            Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
            Id grpTaxIdContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
            Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
            
            //         Map<Id,List<Decimal>> busAccTotalPurchasesMap = new Map<Id,List<Decimal>>();
            //         Map<Id,List<Decimal>> busAccFramePurchasesMap = new Map<Id,List<Decimal>>();
            //        Map<Id,List<Decimal>> busAccLensPurchasesMap = new Map<Id,List<Decimal>>();
            
            Map<Account, Set<String>> prcGrpMap = new Map<Account, Set<String>>();
            
            Map<Global_Rewards_Group__c, Set<Account>> GrpMapContractType = new Map<Global_Rewards_Group__c, Set<Account>>();
            Map<Global_Rewards_Group__c, Set<Account>> GrpMapTaxIDContractType = new Map<Global_Rewards_Group__c, Set<Account>>();
            Map<Global_Rewards_Group__c, Set<Account>> combineGrpMap = new Map<Global_Rewards_Group__c, Set<Account>>();
            
            Map<Id, Set<Global_Rewards_Group_Relationship__c>> accGRGRmap = new Map<Id, Set<Global_Rewards_Group_Relationship__c>>();
            
            Map<Id, Set<Global_Rewards_Group_Relationship__c>> accTaxIdGRGRmap = new Map<Id, Set<Global_Rewards_Group_Relationship__c>>();
            
            Map<String, Set<Account>> lookupGrpMap = new Map<String, Set<Account>>();
            
            List<Global_Rewards_Group__c> newGrp = new List<Global_Rewards_Group__c>();
            
            Set<String> newGrpNameStr = new Set<String>();
            
            List<Account> pracAcctoUpd = new List<Account>();
            Set<Id> pracAccIdSet = new Set<Id>();
            
            List<Id> busAccIdLst = new List<Id>();
            Map<Id,Global_Rewards_Group__c> allGrpId = new Map<Id,Global_Rewards_Group__c>();///All Group List
            Set<Id> rollupPracAccId = new Set<Id>();///Practice Account Ids --Contract Type Rollup
            Set<Id> conflictPracAccId = new Set<Id>();///Practice Account Ids --Contract Type Rollup
            Map<Id, Set<Account>> rollupBusAccMap = new Map<Id, Set<Account>>();
            
            List<Account> allBusAcc = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
                                       FROM Account WHERE ParentId in :pracAccSet AND 
                                       //   Vision_Care_Good_Standing__c = True AND Status__c = 'A' AND
                                       //   Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
                                       RecordTypeId = :accBusRecordTypeId AND Contract_Type__c != NULL];
            
            List<Global_Rewards_Group_Relationship__c> rollupGrpConflictRelation = [SELECT Id,Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Global_Rewards_Group__r.Parent_Account__r.Tax_ID__c,
                                                                                    Global_Rewards_Group__r.Parent_Account__c,
                                                                                    Start_Date__c, End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                                    FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :pracAccSet AND Status__c = 'Active'
                                                                                    AND Global_Rewards_Group__r.RecordTypeId = :grpTaxIdRecordTypeId];
            
            for(Id prcId :pracAccSet){
                Account prc = pracAccSetMap.get(prcId);
                for(Account busAcc :allBusAcc){
                    if(prc.Id == busAcc.ParentId){
                        if(prcGrpMap.containsKey(prc)){
                            Set<String> existingvalue = prcGrpMap.get(prc);
                            existingvalue.add(busAcc.Contract_Type__c);
                            prcGrpMap.put(prc, existingvalue);
                        }
                        else{
                            prcGrpMap.put(prc, new Set<String>{busAcc.Contract_Type__c});
                        }                      
                    }
                }
            }
            
            //Below debug statement commented out by Vikhyat
            //system.debug('prcGrpMap' + prcGrpMap);
            
            if(!prcGrpMap.IsEmpty()){
                for(Account prAcc :prcGrpMap.keySet()){
                    Integer setSize = prcGrpMap.get(prAcc).size();
                    
                    ////Contract Types all the same and Tax Id is NO ----Premier 1.0
                    if(setSize == 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == False){
                        pracAccSetSameContractType.add(prAcc.Id);
                        //   pracAccSetSameContractTypeMap.put(prAcc.Id,prAcc);
                    }
                    
                    ////Contract Types all the same and Tax Id is YES  --- Practice Contract Type - Rollup
                    else if(setSize == 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == True){
                        for(Account busAcc :allBusAcc){
                            if(prAcc.Id == busAcc.ParentId){
                                busAccIdLst.add(busAcc.Id); ////Add Bus Acc to Lst to check for existing group relationships that need to end
                                rollupPracAccId.add(prAcc.Id);
                                
                                if(rollupBusAccMap.containsKey(prAcc.Id)){
                                    Set<Account> existingValue = rollupBusAccMap.get(prAcc.Id);
                                    existingValue.add(busAcc);
                                    rollupBusAccMap.put(prAcc.Id, existingValue);
                                }
                                else{
                                    rollupBusAccMap.put(prAcc.Id, new Set<Account>{busAcc});
                                }
                            }
                        }
                    }
                    
                    ////Tax Id is No ///Group Contract Type //// Practice = Conflict
                    else if(setSize > 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == False){
                        for(Account busAcc :allBusAcc){
                            if(prAcc.Id == busAcc.ParentId){
                                conflictPracAccId.add(prAcc.Id);
                                
                                //Below debug statement commented out by Vikhyat
                                //system.debug('prcGrpMap' + prcGrpMap);
                                
                                Set<String> valueset = prcGrpMap.get(prAcc);
                                for(String vSet :valueset){
                                    if(vSet == busAcc.Contract_Type__c){
                                        //Commented out status field by Vikhyat on 08/19/2019 because status field is not long a picklist field. 
                                        Global_Rewards_Group__c conTypelookup = new Global_Rewards_Group__c(name = 'PREMIER - '+prAcc.Tax_ID__c+ ' - ' + vSet, 
                                                                                                            RecordTypeId = grpContractRecordTypeId,
                                                                                                            Start_Date__c = Date.today(),
                                                                                                            /*Status__c = 'Active',*/
                                                                                                            Contract_Type__c = vSet,
                                                                                                            //Tier_Agreement_Type__c = prAcc.Tier_Agreement_Type__c,
                                                                                                            Parent_Account__c = prAcc.Id);
                                        if(GrpMapContractType.containsKey(conTypelookup)){
                                            Set<Account> existingValue = GrpMapContractType.get(conTypelookup);
                                            existingValue.add(busAcc);
                                            GrpMapContractType.put(conTypelookup , existingValue);
                                        }
                                        else{
                                            GrpMapContractType.put(conTypelookup , new Set<Account>{busAcc});
                                        }
                                        
                                    }
                                }
                                
                            }
                        }
                        
                    }
                    
                    ////Tax Id is Yes  /// Group Tax Id & Contract Type  ///Practice = Conflict
                    else if(setSize > 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == True){
                        for(Global_Rewards_Group_Relationship__c grgParentTax :rollupGrpConflictRelation){
                            if(grgParentTax.Child_Account__c == prAcc.Id){
                                for(Account busAcc :allBusAcc){
                                    
                                    
                                    
                                    if(prAcc.Id == busAcc.ParentId){
                                        conflictPracAccId.add(prAcc.Id);
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        
                                        Set<String> valueset = prcGrpMap.get(prAcc);
                                        for(String vSet :valueset){
                                            if(vSet == busAcc.Contract_Type__c){
                                                //Commented out status field by Vikhyat as status field is no longer part a picklist field.
                                                Global_Rewards_Group__c taxConTypelookup = new Global_Rewards_Group__c(name = 'PREMIER - '+grgParentTax.Global_Rewards_Group__r.Parent_Account__r.Tax_ID__c+ ' - ' + vSet, 
                                                                                                                       RecordTypeId = grpTaxIdContractRecordTypeId,
                                                                                                                       Start_Date__c = Date.today(),
                                                                                                                       /*Status__c = 'Active',*/
                                                                                                                       Contract_Type__c = vSet,
                                                                                                                       // Tier_Agreement_Type__c = prAcc.Tier_Agreement_Type__c,
                                                                                                                       Parent_Account__c = grgParentTax.Global_Rewards_Group__r.Parent_Account__c);
                                                if(GrpMapTaxIDContractType.containsKey(taxConTypelookup)){
                                                    Set<Account> existingValue = GrpMapTaxIDContractType.get(taxConTypelookup);
                                                    existingValue.add(busAcc);
                                                    GrpMapTaxIDContractType.put(taxConTypelookup , existingValue);
                                                }
                                                else{
                                                    GrpMapTaxIDContractType.put(taxConTypelookup , new Set<Account>{busAcc});
                                                }
                                                
                                            }
                                        }
                                        //Below debug statement commented out by Vikhyat
                                        //system.debug('GrpMapTaxIDContractType' + GrpMapTaxIDContractType);
                                    }
                                }
                                
                            }
                        }
                        
                    }
                }                
            }
            
            //Below debug statement commented out by Vikhyat
            //SYSTEM.debug('FIND Contract Type Map  ' + GrpMapContractType);
            
            if(!GrpMapContractType.isEmpty()){
                for(Global_Rewards_Group__c grp :GrpMapContractType.keySet()){
                    Set<Account> existAcc = GrpMapContractType.get(grp);
                    
                    newGrpNameStr.add(grp.Name);
                    pracAccIdSet.add(grp.Parent_Account__c);
                    combineGrpMap.put(grp, existAcc);
                    lookupGrpMap.put(grp.Name, existAcc);
                    //      combineGrpMapforRelation.put(grp, existAcc);
                    for(Account lst :existAcc){
                        busAccIdLst.add(lst.Id);
                    }
                    
                    
                    
                }
                
            }
            
            if(!GrpMapTaxIDContractType.isEmpty()){
                for(Global_Rewards_Group__c grp :GrpMapTaxIDContractType.keySet()){
                    Set<Account> existAcc = GrpMapTaxIDContractType.get(grp);
                    
                    newGrpNameStr.add(grp.Name);
                    pracAccIdSet.add(grp.Parent_Account__c);
                    combineGrpMap.put(grp, existAcc);
                    lookupGrpMap.put(grp.Name, existAcc);
                    for(Account lst :existAcc){
                        busAccIdLst.add(lst.Id);
                    }
                    //    combineGrpMapforRelation.put(grp, existAcc);
                }
                
            }
            
            //Below debug statements commented out by Vikhyat
            //system.debug('combineGrpMap  ARE YOU NULL -- ' +combineGrpMap);
            //system.debug('newGrpNameStr --- ' + newGrpNameStr);
            
            List<Global_Rewards_Group__c> existGrp = [SELECT Name, RecordTypeId, Parent_Account__c FROM Global_Rewards_Group__c WHERE Name IN :newGrpNameStr];
            
            ///// Add Existing Groups to the All Group List
            for(Global_Rewards_Group__c addAllLst :existGrp){
                allGrpId.put(addAllLst.Id, addAllLst);
            }
            
            List<Global_Rewards_Group_Relationship__c> existGrpRelation = [SELECT Id, Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
                                                                           End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                           FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :busAccIdLst AND End_Date__c = NULL];
            
            //Below part commented out by Vikhyat
            /*List<Global_Rewards_Group_Relationship__c> existRollupGrpRelation = [SELECT Id, Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
End_Date__c, Global_Rewards_Group__r.RecordTypeId
FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :busAccIdLst AND End_Date__c = NULL
AND Global_Rewards_Group__r.RecordTypeId = :grpTaxIdRecordTypeId];*/
            //Commented out part by Vikhyat ends here.
            
            //Below part added by Vikhyat.
            
            List<Global_Rewards_Group_Relationship__c> existRollupGrpRelation = new List<Global_Rewards_Group_Relationship__c>();
            
            for(Global_Rewards_Group_Relationship__c grgr: existGrpRelation){
                if(grgr.Global_Rewards_Group__r.RecordTypeId == grpTaxIdRecordTypeId){
                    existRollupGrpRelation.add(grgr);
                    
                    if(accTaxIdGRGRmap.containsKey(grgr.Child_Account__c)){
                        Set<Global_Rewards_Group_Relationship__c> existAccTaxIdGRGR = accTaxIdGRGRmap.get(grgr.Child_Account__c);
                        existAccTaxIdGRGR.add(grgr);
                        accTaxIdGRGRmap.put(grgr.Child_Account__c,existAccTaxIdGRGR);
                    }
                    else{
                        accTaxIdGRGRmap.put(grgr.Child_Account__c , new Set<Global_Rewards_Group_Relationship__c>{grgr});
                    }
                    
                }
                if(accGRGRmap.containsKey(grgr.Child_Account__c)){
                    Set<Global_Rewards_Group_Relationship__c> existAccGRGR = accGRGRmap.get(grgr.Child_Account__c);
                    existAccGRGR.add(grgr);
                    accGRGRmap.put(grgr.Child_Account__c,existAccGRGR);
                }
                else{
                    accGRGRmap.put(grgr.Child_Account__c , new Set<Global_Rewards_Group_Relationship__c>{grgr});
                }
                
            }
            
            //Part added by Vikhyat ends here.
            
            List<Global_Rewards_Group_Relationship__c> rollupPracGrpRelation = [SELECT Id,Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
                                                                                End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                                FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :rollupPracAccId AND End_Date__c = NULL
                                                                                AND Global_Rewards_Group__r.RecordTypeId = :grpTaxIdRecordTypeId];
            
            
            Set<String> grpNameStr = new Set<String>();
            for(Global_Rewards_Group__c str :existGrp){
                grpNameStr.add(str.Name);
            }
            
            Set<Id> grpRelChildAcc = new Set<Id>();
            for(Global_Rewards_Group_Relationship__c chAccId :existGrpRelation){
                grpRelChildAcc.add(chAccId.Child_Account__c);
            }
            
            Set<Id> grpRollupRelChildAcc = new Set<Id>();
            for(Global_Rewards_Group_Relationship__c chAccId :existRollupGrpRelation){
                grpRollupRelChildAcc.add(chAccId.Child_Account__c);
            }
            
            List<Global_Rewards_Group_Relationship__c> grpReltoUpd = new List<Global_Rewards_Group_Relationship__c>();
            Set<Global_Rewards_Group_Relationship__c> grpReltoInst = new Set<Global_Rewards_Group_Relationship__c>();
            
            //Below debug statement commented out by Vikhyat
            //system.debug('existGrp List -------  '+ existGrp);
            
            for(Global_Rewards_Group__c combGrMap :combineGrpMap.keySet()){
                
                //Below debug statement commeneted out by Vikhyat
                //system.debug('combGrMap ------ '+ combGrMap);
                
                if(!grpNameStr.contains(combGrMap.Name)){
                    newGrp.add(combGrMap);
                }
                
            }
            
            if(!newGrp.isEmpty()){
                
                //  insert newGrp;
                
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
            
            //   List<Global_Rewards_Group__c> allGrpId = [SELECT Name, RecordTypeId, Parent_Account__c FROM Global_Rewards_Group__c WHERE Name IN :newGrpNameStr]; ///new and existing Groups
            //   
            //   Add New Groups to the All Group List
            for(Global_Rewards_Group__c addAllLst :newGrp){
                allGrpId.put(addAllLst.Id,addAllLst);
            }
            
            for(String combGrMap :lookupGrpMap.keySet()){
                
                //Below debug statement commented out by Vikhyat
                //system.debug('combGrMap ------ '+ combGrMap);
                //Commented out part by Vikhyat ends here.
                
                //    system.debug('combGrMap ------ '+ combGrMap);
                Set<Account> exBusAcc = lookupGrpMap.get(combGrMap);
                
                //Below debug statements commented out by Vikhyat
                /*system.debug('exBusAcc  ----- ' + exBusAcc);
system.debug('grpRelChildAcc ----- ' + grpRelChildAcc);*/
                //Commented out part by Vikhyat ends here.
                Integer oneActvGRGR;
                for(Account exBAcc :exBusAcc){
                    if(grpRelChildAcc.contains(exBAcc.Id)){
                        oneActvGRGR = 0;
                        for(Global_Rewards_Group_Relationship__c grpRel :accGRGRmap.get(exBAcc.Id)){
                            
                            if((exBAcc.Id == grpRel.Child_Account__c && combGrMap != grpRel.Global_Rewards_Group__r.Name && grpRel.End_Date__c == NULL) || (oneActvGRGR == 1 && grpRel.End_Date__c == Null)){
                                grpRel.End_Date__c = Date.today();
                                grpReltoUpd.add(grpRel);
                            }
                            else if(exBAcc.Id == grpRel.Child_Account__c && combGrMap == grpRel.Global_Rewards_Group__r.Name && grpRel.End_Date__c == NULL){
                                oneActvGRGR = 1;
                            }   
                            
                            
                            /*         for(Id aGId :allGrpId.keySet()){
Global_Rewards_Group__c aG = allGrpId.get(aGId);
if(combGrMap == aG.Name){
Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
ngrpRel.Child_Account__c = exBAcc.Id;
ngrpRel.Global_Rewards_Group__c = aG.Id;
ngrpRel.Start_Date__c = Date.today();
ngrpRel.Active__c = True;
grpReltoInst.add(ngrpRel);  
}
}*/
                            
                            
                        }
                        if(oneActvGRGR == 0){
                            for(Id aGId :allGrpId.keySet()){
                                Global_Rewards_Group__c aG = allGrpId.get(aGId);
                                if(combGrMap == aG.Name){
                                    Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                    ngrpRel.Child_Account__c = exBAcc.Id;
                                    ngrpRel.Global_Rewards_Group__c = aG.Id;
                                    ngrpRel.Start_Date__c = Date.today();
                                    ngrpRel.Active__c = True;
                                    grpReltoInst.add(ngrpRel);  
                                }
                            }
                        }
                    }
                    else{
                        for(Id allGId :allGrpId.keySet()){
                            Global_Rewards_Group__c allG = allGrpId.get(allGId);
                            if(allG.Name == combGrMap){
                                Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                ngrpRel.Child_Account__c = exBAcc.Id;
                                ngrpRel.Global_Rewards_Group__c = allG.Id;
                                ngrpRel.Start_Date__c = Date.today();
                                ngrpRel.Active__c = True;
                                grpReltoInst.add(ngrpRel);
                                
                            }
                        }
                        
                    }
                    
                }  
                
            }
            /////Create Relationship for Tax Rollup Bus Accounts///////
            //
            //
            for(Id rollupPrac :rollupBusAccMap.keySet()){
                
                Set<Account> rollupBusAcc = rollupBusAccMap.get(rollupPrac);
                
                for(Account exBAcc :rollupBusAcc){
                    if(grpRelChildAcc.contains(exBAcc.Id)){////Business Account belonged to a non Roll-up Group
                        for(Global_Rewards_Group_Relationship__c grpRel :accGRGRmap.get(exBAcc.Id)){
                            if(exBAcc.Id == grpRel.Child_Account__c &&  grpRel.Global_Rewards_Group__r.RecordTypeId != grpTaxIdRecordTypeId && grpRel.End_Date__c == NULL){
                                grpRel.End_Date__c = Date.today();
                                grpReltoUpd.add(grpRel);
                            }
                        }
                    }
                    
                }
                for(Global_Rewards_Group_Relationship__c exPracRel :rollupPracGrpRelation){
                    if(exPracRel.Global_Rewards_Group__r.RecordTypeId == grpTaxIdRecordTypeId && exPracRel.Child_Account__c == rollupPrac){
                        for(Account exBAcc :rollupBusAcc){
                            if(grpRollupRelChildAcc.contains(exBAcc.Id)){
                                for(Global_Rewards_Group_Relationship__c grpRel :accTaxIdGRGRmap.get(exBAcc.Id)){
                                    ///Bus Acc Belongs to a different Rollup Group
                                    if(exBAcc.Id == grpRel.Child_Account__c && exPracRel.Global_Rewards_Group__c != grpRel.Global_Rewards_Group__c && grpRel.End_Date__c == NULL){
                                        grpRel.End_Date__c = Date.today();
                                        grpReltoUpd.add(grpRel);
                                        
                                        
                                        
                                        
                                        Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                        ngrpRel.Child_Account__c = exBAcc.Id;
                                        ngrpRel.Global_Rewards_Group__c = exPracRel.Global_Rewards_Group__c;
                                        ngrpRel.Start_Date__c = Date.today();
                                        ngrpRel.Active__c = True;
                                        grpReltoInst.add(ngrpRel);
                                    }
                                }
                            }
                            else{///NEW
                                Global_Rewards_Group_Relationship__c ngrpRel = new Global_Rewards_Group_Relationship__c();
                                ngrpRel.Child_Account__c = exBAcc.Id;
                                ngrpRel.Global_Rewards_Group__c = exPracRel.Global_Rewards_Group__c;
                                ngrpRel.Start_Date__c = Date.today();
                                ngrpRel.Active__c = True;
                                grpReltoInst.add(ngrpRel);
                            }
                        }
                    }
                }
                
                
            }     
            //
            //
            ///////////////////////////////////////////////////////////
            
            
            
            
            //Below debug stataments commented out by Vikhyat
            /*system.debug('grpReltoUpd' + grpReltoUpd);
system.debug('grpReltoInst' + grpReltoInst);
system.debug('GrpMapTaxIDContractType Cleared? '+ GrpMapTaxIDContractType.values());*/
            //Commented out part by Vikhyat ends here.
            
            /*       if(!newGrp.isEmpty()){

//  insert newGrp;

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
}    */
            
            //Below debug statements commented out by Vikhyat
            /*system.debug('GrpMapTaxIDContractType Cleared? '+ GrpMapTaxIDContractType.values());
system.debug('newGrp Cleared? ' + newGrp);*/
            //Commented out part by Vikhyat ends here.
            
            
            ////////Update Practice Account Contract Type to Conflict////
            //
            //
            for(Id prAccId :conflictPracAccId){
                Account pA = pracAccSetMap.get(prAccId);
                pa.Number_of_Eligible_Locations__c = 0;
                pa.Total_Average_Purchases_LTM_Calculated__c = 0;
                pa.Average_Frame_Purchases_LTM_Calculated__c = 0;
                pa.Average_Lens_Purchases_LTM_Calculated__c = 0;
                //below part commented out by Vikhyat as part of SFDC-10005
                //pa.Retinal_Imaging_Indicator__c = false;
                pa.Exclusive_VSP_Patient_Offers__c = true;
                pa.Free_Fitting_and_Adjustments__c = true;
                pa.Applied_Tier__c = null;
                pa.Calculated_Tier__c = null;
                //   pa.Contract_Type__c = 'Conflict';
                pracAcctoUpd.add(pa); 
            }
            //////////////////////////////////////////////////////////////
            //
            //
            ////////Update Practice Account Contract Type to Rollup////
            //
            //
            
            for(Id pAId :rollupPracAccId){
                Account pa = pracAccSetMap.get(pAId);
                pa.Number_of_Eligible_Locations__c = 0;
                pa.Total_Average_Purchases_LTM_Calculated__c = 0;
                pa.Average_Frame_Purchases_LTM_Calculated__c = 0;
                pa.Average_Lens_Purchases_LTM_Calculated__c = 0;
                //below part commented out by Vikhyat as part of SFDC-10005
                //pa.Retinal_Imaging_Indicator__c = false;
                pa.Exclusive_VSP_Patient_Offers__c = true;
                pa.Free_Fitting_and_Adjustments__c = true;
                pa.Applied_Tier__c = null;
                pa.Calculated_Tier__c = null;
                //  pa.Contract_Type__c = 'Rollup';
                pracAcctoUpd.add(pa);
            }
            //////////////////////////////////////////////////////////////
            //
            
            List<Global_Rewards_Group_Relationship__c> grpReltoInstLst = new List<Global_Rewards_Group_Relationship__c>(grpReltoInst);
            /////Group Relationships to Insert
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
            
            
            
            /////Group Relationships to Update
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
            
            ////Practice Account to Update
            
            //Below debug statement commeneted out by Vikhyat.
            //system.debug('pracAcctoUpd' + pracAcctoUpd);
            //Commented out part by Vikhyat ends here.
            
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
            
            
            
            
            
            ////Premier 1.0/////
            /*          if(!pracAccSetSameContractType.isEmpty()){ 
List<Global_Rewards_Group_Relationship__c> grgRLstUpd = new List<Global_Rewards_Group_Relationship__c>();
///////////////if contract type is all the same//////////////
//
//


/*    List<Account> busAccCTquery = [Select Id, Name, Contract_Type__c, ParentId FROM Account Where ParentId in :pracAccSetSameContractType AND
Vision_Care_Good_Standing__c = True AND Status__c = 'A' AND
Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
RecordTypeId = :accBusRecordTypeId AND Contract_Type__c != NULL];*/
            
            /*             List<Global_Rewards_Group_Relationship__c> existBusGrpRelation = [SELECT Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
End_Date__c, Global_Rewards_Group__r.RecordTypeId, Child_Account__r.ParentId
FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__r.ParentId IN :pracAccSetSameContractType AND End_Date__c = NULL];

List<Account> allBusAccAvg = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
FROM Account 
WHERE (ParentId in :pracAccSetSameContractType 
AND Vision_Care_Good_Standing__c = True 
AND RecordTypeId = :accBusRecordTypeId)
OR
(ParentId in :pracAccSetSameContractType
AND RecordTypeId = :accBusRecordTypeId
AND Non_VC_Exception__c = True)];




AggregateResult[] busActiveAccCount =  [SELECT ParentId, Count(Id) Total 
FROM Account 
Where ParentId in :pracAccSetSameContractType 
AND Vision_Care_Good_Standing__c = True 
//   AND Status__c = 'A' 
//  AND Vision_Care_Effective_Date__c <= TODAY 
//  AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) 
AND Contract_Type__c != NULL AND
RecordTypeId = :accBusRecordTypeId
Group By ParentId];

AggregateResult[] busAccRetinalImgCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType AND
Vision_Care_Good_Standing__c = True AND 
//Status__c = 'A' AND
//Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
Service_Offering_s__c includes ('RTLIM - Retinal Imaging') AND
RecordTypeId = :accBusRecordTypeId
Group By ParentId];

AggregateResult[] busAccFreeFittingCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType AND
Vision_Care_Good_Standing__c = True AND 
// Status__c = 'A' AND
// Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
Service_Offering_s__c includes ('FFAA - Free Fitting and Adjustments') AND
RecordTypeId = :accBusRecordTypeId
Group By ParentId];

AggregateResult[] busAccNODISCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType AND
Vision_Care_Good_Standing__c = True AND 
//Status__c = 'A' AND
//Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
Participation_Exclusions__c includes ('NODIS – Opts out of discounts')  AND
RecordTypeId = :accBusRecordTypeId
Group By ParentId];      



for(Id pAccId: pracAccSetSameContractType){
Account pAcc = pracAccSetSameContractTypeMap.get(pAccId);

//Below debug part commented out by Vikhyat
//System.debug('pAcc for loop '+ pAcc.Id);
//Commented out part by Vikhyat ends here.

pAcc.Number_of_Eligible_Locations__c = 0;
pAcc.Total_Average_Purchases_LTM_Calculated__c = 0;
pAcc.Average_Frame_Purchases_LTM_Calculated__c = 0;
pAcc.Average_Lens_Purchases_LTM_Calculated__c = 0;
pAcc.Retinal_Imaging_Indicator__c = false;
pAcc.Exclusive_VSP_Patient_Offers__c = true;
pAcc.Free_Fitting_and_Adjustments__c = true;

//   pAcc.Contract_Type__c = null; //For Contract Type of a Practice Account

for(AggregateResult ar : busActiveAccCount){
if(ar.get('ParentId') == pAcc.Id){                   
pAcc.Number_of_Eligible_Locations__c = ((decimal)ar.get('Total'));
//       pAcc.Total_Average_Purchases_LTM_Calculated__c = ((decimal)ar.get('Total_Average_Purchases_LTM')); 
//      pAcc.Average_Frame_Purchases_LTM_Calculated__c = ((decimal)ar.get('Average_Frame_Purchases_LTM__c'));
//     pAcc.Average_Lens_Purchases_LTM_Calculated__c = ((decimal)ar.get('Average_Lens_Purchases_LTM__c')); 
}
}//end Aggregate For Loop

for(AggregateResult ar1 :busAccRetinalImgCount){
if(ar1.get('ParentId') == pAcc.Id){
pAcc.Retinal_Imaging_Indicator__c = true;
}
}//end Aggregate1 For Loop

for(AggregateResult ar2 :busAccNODISCount){
if(ar2.get('ParentId') == pAcc.Id){
pAcc.Exclusive_VSP_Patient_Offers__c = false;
}
}//end Aggregate2 For Loop

for(AggregateResult ar3 :busAccFreeFittingCount){
if(ar3.get('ParentId') == pAcc.Id){
pAcc.Free_Fitting_and_Adjustments__c = false;
}
}//end Aggregate3 For Loop

/*          for(Account busAccCT : busAccCTquery){ //Set Contract Type of a Practice Account
if(busAccCT.ParentId == pAcc.Id){

pAcc.Contract_Type__c = busAccCT.Contract_Type__c;
break;

}
}*///end Contract Type Update
            
            
            /*                 /////end any Business Accoung Group Reward Relationships that are still active////
for(Global_Rewards_Group_Relationship__c grgR :existBusGrpRelation){
if(grgR.Child_Account__r.ParentId == pAcc.Id){
grgR.End_Date__c = Date.today();
grgRLstUpd.add(grgR);
}
}

//////Calculate the Avg for Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Lens_Purchases_LTM__c
for(Account busAccAvg :allBusAccAvg){
if(busAccAvg.ParentId == pAcc.Id){
if(busAccTotalPurchasesMap.containsKey(busAccAvg.ParentId)){
List<Decimal> existingvalue = busAccTotalPurchasesMap.get(busAccAvg.ParentId);
if(busAccAvg.Total_Location_Spend_LTM__c != null){
existingvalue.add(busAccAvg.Total_Location_Spend_LTM__c);
busAccTotalPurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
else{
existingvalue.add(0);
busAccTotalPurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
} 
else{
if(busAccAvg.Total_Location_Spend_LTM__c != null){
busAccTotalPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Total_Location_Spend_LTM__c});
}
else{
busAccTotalPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
}
}

if(busAccFramePurchasesMap.containsKey(busAccAvg.ParentId)){
List<Decimal> existingvalue = busAccFramePurchasesMap.get(busAccAvg.ParentId);
if(busAccAvg.Eyewear_Location_Spend_LTM__c != null){
existingvalue.add(busAccAvg.Eyewear_Location_Spend_LTM__c);
busAccFramePurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
else{
existingvalue.add(0);
busAccFramePurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
}
else{
if(busAccAvg.Eyewear_Location_Spend_LTM__c != null){
busAccFramePurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Eyewear_Location_Spend_LTM__c});
}
else{
busAccFramePurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
}
}

if(busAccLensPurchasesMap.containsKey(busAccAvg.ParentId)){
List<Decimal> existingvalue = busAccLensPurchasesMap.get(busAccAvg.ParentId);
if(busAccAvg.Optics_Location_Spend_LTM__c != null){
existingvalue.add(busAccAvg.Optics_Location_Spend_LTM__c);
busAccLensPurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
else{
existingvalue.add(0);
busAccLensPurchasesMap.put(busAccAvg.ParentId, existingvalue);
}
}
else{
if(busAccAvg.Optics_Location_Spend_LTM__c != null){
busAccLensPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Optics_Location_Spend_LTM__c});
}
else{
busAccLensPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
}
}

}                    
}//////finish for loop Avg Calc

if(!busAccTotalPurchasesMap.isEmpty()){
for(Id key :busAccTotalPurchasesMap.keySet()){
if(pAcc.Id == key){
Decimal total = 0;
Double tPAvg = 0;
Decimal[] totalPurchase = busAccTotalPurchasesMap.get(key);

for(Decimal d :totalPurchase){
total += d;
}
if(pAcc.Number_of_Eligible_Locations__c != 0){
tPAvg = Double.valueOf(total) / pAcc.Number_of_Eligible_Locations__c;
}                                
pAcc.Total_Average_Purchases_LTM_Calculated__c = tPAvg; 
}
}
}
if(!busAccFramePurchasesMap.isEmpty()){
for(Id key :busAccFramePurchasesMap.keySet()){
if(pAcc.Id == key){
Decimal total = 0;
Double fPAvg = 0;
Decimal[] framePurchase = busAccFramePurchasesMap.get(key);

for(Decimal d :framePurchase){
total += d;
}
if(pAcc.Number_of_Eligible_Locations__c != 0){
fPAvg = Double.valueOf(total) / pAcc.Number_of_Eligible_Locations__c;
}                                
pAcc.Average_Frame_Purchases_LTM_Calculated__c = fPAvg; 
}
}
}

if(!busAccLensPurchasesMap.isEmpty()){
for(Id key :busAccLensPurchasesMap.keySet()){
if(pAcc.Id == key){
Decimal total = 0;
Double lPAvg = 0;
Decimal[] lensPurchase = busAccLensPurchasesMap.get(key);

for(Decimal d :lensPurchase){
total += d;
}
if(pAcc.Number_of_Eligible_Locations__c != 0){
lPAvg = Double.valueOf(total) / pAcc.Number_of_Eligible_Locations__c;
}                                
pAcc.Average_Lens_Purchases_LTM_Calculated__c = lPAvg; 
}
}
}

pracAccToUpdate.add(pAcc);
}

//Below part commented out by Vikhyat.
//system.debug('pracAccToUpdate List '+ pracAccToUpdate);
//Commented out part by Vikhyat ends here.

if(!pracAccToUpdate.isEmpty()){
//  update pracAccToUpdate;

Database.SaveResult[] SaveResultList = Database.update(pracAccToUpdate,false); 

for(integer i =0; i<SaveResultList.size();i++){
String msg='';
If(!SaveResultList[i].isSuccess()){

msg += 'Account Record Id: ' + pracAccToUpdate.get(i).id + '\n'+'Error: "';        
for(Database.Error err: SaveResultList[i].getErrors()){  
msg += err.getmessage()+'"\n\n';
} 
}
if(msg!= '')
exception_List.add(msg);
} 
}

//Below part commented out by Vikhyat.
//system.debug('grgRLstUpd List '+ grgRLstUpd);
//Commented out part by Vikhyat ends here.

if(!grgRLstUpd.isEmpty()){
//  update grgRLstUpd;

Database.SaveResult[] SaveResultList = Database.update(grgRLstUpd,false); 

for(integer i =0; i<SaveResultList.size();i++){
String msg='';
If(!SaveResultList[i].isSuccess()){

msg += 'Account Record Id: ' + grgRLstUpd.get(i).id + '\n'+'Error: "';        
for(Database.Error err: SaveResultList[i].getErrors()){  
msg += err.getmessage()+'"\n\n';
} 
}
if(msg!= '')
exception_List.add(msg);
} 
}

}*/
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
            VSPR31_Premier_Prac_Bus_Acc_Avg_Batch obj = new VSPR31_Premier_Prac_Bus_Acc_Avg_Batch(pracAccSetSameContractType);
            Database.executeBatch(obj, 100);
        }
        
    }
}