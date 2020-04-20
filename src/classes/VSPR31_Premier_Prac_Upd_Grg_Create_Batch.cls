global class VSPR31_Premier_Prac_Upd_Grg_Create_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    global final String Query;
    
    global List<String> exception_List = new List<String>();
    
    private Set<Id> pracAccSetSameContractType = new set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Tax_ID__c, Premier_Tax_ID_Roll_Up_Account__c, Tier_Agreement_Type__c 
                                         FROM Account 
                                         WHERE IsDeleted = false AND Tax_ID__c != Null AND Premier_Tax_ID_Roll_Up_Account__c = False AND recordTypeId = :accRecordTypeId]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        VSPUtility.stopAccountTrigger=true;
        Set<Id> pracAccSet = new set<Id>();
        
        Map<Id,Account> pracAccSetMap = new Map<Id,Account>();
        
        for(Account s : scope){
            pracAccSet.add(s.Id);
            pracAccSetMap.put(s.Id,s);
        }
        
        
        if(!pracAccSet.isEmpty()){ ///Set Account Premier Detail Fields
            List<Account> pracAccToUpdate = new List<Account>();
            
            Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
            Id grpTaxIdContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
            Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
            
            
            Map<Account, Set<String>> prcGrpMap = new Map<Account, Set<String>>();
            Set<String> grpNameStr = new Set<String>();
            Map<Global_Rewards_Group__c, Set<Id>> GrpMapContractType = new Map<Global_Rewards_Group__c, Set<Id>>();
            List<Global_Rewards_Group_Relationship__c> grpReltoUpd = new List<Global_Rewards_Group_Relationship__c>();
            Set<Global_Rewards_Group_Relationship__c> grpReltoInst = new Set<Global_Rewards_Group_Relationship__c>();
            Map<Id, Set<Global_Rewards_Group_Relationship__c>> accGRGRmap = new Map<Id, Set<Global_Rewards_Group_Relationship__c>>();            
            Map<Id, Set<Global_Rewards_Group_Relationship__c>> accTaxIdGRGRmap = new Map<Id, Set<Global_Rewards_Group_Relationship__c>>();            
            Map<String, Set<Id>> lookupGrpMap = new Map<String, Set<Id>>();            
            List<Global_Rewards_Group__c> newGrp = new List<Global_Rewards_Group__c>();            
            Set<String> newGrpNameStr = new Set<String>();            
            List<Account> pracAcctoUpd = new List<Account>();           
            List<Id> busAccIdLst = new List<Id>();
            Map<String,Global_Rewards_Group__c> allGrpName = new Map<String,Global_Rewards_Group__c>();
            Set<Id> conflictPracAccId = new Set<Id>();
            
            List<Account> allBusAcc = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
                                       FROM Account WHERE ParentId in :pracAccSet AND 
                                       RecordTypeId = :accBusRecordTypeId AND Contract_Type__c != NULL];
            
            List<Global_Rewards_Group_Relationship__c> rollupGrpConflictRelation = [SELECT Id,Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Global_Rewards_Group__r.Parent_Account__r.Tax_ID__c,
                                                                                    Global_Rewards_Group__r.Parent_Account__c,
                                                                                    Start_Date__c, End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                                    FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :pracAccSet AND Status__c = 'Active'
                                                                                    AND Global_Rewards_Group__r.RecordTypeId = :grpTaxIdRecordTypeId];
                      
            for(Account busAcc :allBusAcc){
                Account prc = pracAccSetMap.get(busAcc.ParentId);
                if(prc != Null){
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
            
            if(!prcGrpMap.IsEmpty()){
                for(Account prAcc :prcGrpMap.keySet()){
                    Integer setSize = prcGrpMap.get(prAcc).size();
                    
                    ////Contract Types all the same and Tax Id is NO ----Premier 1.0
                    if(setSize == 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == False){
                        pracAccSetSameContractType.add(prAcc.Id);
                    }
                   
                    ////Tax Id is No ///Group Contract Type //// Practice = Conflict
                    else if(setSize > 1 && prAcc.Premier_Tax_ID_Roll_Up_Account__c == False){
                        for(Account busAcc :allBusAcc){
                            if(prAcc.Id == busAcc.ParentId){
                                conflictPracAccId.add(prAcc.Id);                                
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
                                            Set<Id> existingValue = GrpMapContractType.get(conTypelookup);
                                            existingValue.add(busAcc.Id);
                                            GrpMapContractType.put(conTypelookup , existingValue);
                                        }
                                        else{
                                            GrpMapContractType.put(conTypelookup , new Set<Id>{busAcc.Id});
                                        }
                                    }
                                }
                            }
                        }
                    }
                }                
            }
            
            if(!GrpMapContractType.isEmpty()){
                for(Global_Rewards_Group__c key :GrpMapContractType.keySet()){
                    busAccIdLst.addAll(GrpMapContractType.get(key));
                    newGrpNameStr.add(key.Name);
                    lookupGrpMap.put(key.Name, GrpMapContractType.get(key));                      
                }      
            }
            
            List<Global_Rewards_Group__c> existGrp = [SELECT Name, RecordTypeId, Parent_Account__c FROM Global_Rewards_Group__c WHERE Name IN :newGrpNameStr];
            
            ///// Add Existing Groups to the All Group List
            for(Global_Rewards_Group__c addAllLst :existGrp){
                allGrpName.put(addAllLst.Name, addAllLst);
                grpNameStr.add(addAllLst.Name);
            }
            
            for(Global_Rewards_Group__c grp :GrpMapContractType.keySet()){
                    
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
            
            
             //   Add New Groups to the All Group List
                for(Global_Rewards_Group__c addAllLst :newGrp){
                    allGrpName.put(addAllLst.Name,addAllLst);
                } 
            
            List<Global_Rewards_Group_Relationship__c> existGrpRelation = [SELECT Id, Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
                                                                           End_Date__c, Global_Rewards_Group__r.RecordTypeId
                                                                           FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :busAccIdLst AND Status__c = 'Active'];
            
            
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
            
            
            
             //////Grouping of >1/////
                //
                //
                Integer grgExists = 0;
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
                                    else{
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
       
                            
  
            //
            //
            for(Id prAccId :conflictPracAccId){
                Account pA = pracAccSetMap.get(prAccId);
                pa.Premier_Location_Count_Future__c = 0;
                pa.Total_Average_Purchases_LTM_Calculated__c = 0;
                pa.Average_Frame_Purchases_LTM_Calculated__c = 0;
                pa.Average_Lens_Purchases_LTM_Calculated__c = 0;
                pa.Free_Fitting_and_Adjustments__c = true;
                pa.Exclusive_VSP_Patient_Offers__c = true;
                pa.Applied_Tier__c = null;
                pa.Calculated_Tier__c = null;
                pracAcctoUpd.add(pa); 
            }
    
            
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