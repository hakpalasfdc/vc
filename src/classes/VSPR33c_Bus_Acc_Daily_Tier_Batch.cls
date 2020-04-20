global class VSPR33c_Bus_Acc_Daily_Tier_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private date eightDayago = Date.today().addDays(-8);
    global List<String> exception_List = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Contract_Type__c, Agreement_Type__c, Vision_Care_Good_Standing__c, ParentId, Parent.Tax_ID__c,
                                         Parent.Premier_Tax_ID_Roll_Up_Account__c, Parent.Vision_Care_Good_Standing__c, Parent.Applied_Tier__c, Parent.Tier_Agreement_Type__c,
                                         Parent.Contract_Type__c
                                         FROM Account
                                         WHERE RecordTypeId = :busAccRecordTypeId
                                         AND VC__c = True
                                         AND Vision_Care_Good_Standing__c = True
                                         AND Applied_Tier__c = Null
                                         AND Contract_Type__c != Null
                                         AND Vision_Care_Effective_Date__c >= :eightDayago]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        VSPUtility.stopAccountTrigger=true; 
        integer yestrMonth = Date.today().addDays(-1).month();
        integer yestrYear = Date.today().addDays(-1).year();
        Map<Id,Account> busAccGRGParentMap = new Map<Id,Account>();
        Map<Id,Account> busAccParentMap = new Map<Id,Account>();
        Set<Id> pracAccSet = new Set<Id>();
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        Id grpTaxIdContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
        List<Account> busAcctoUpd = new List<Account>();
        List<Premier_Tier__c> allTiers = new List<Premier_Tier__c>();   
        Map<String,List<Premier_Tier__c>> conTypeTierMap = new Map<String,List<Premier_Tier__c>>();
        Map<Id,Global_Rewards_Group_Relationship__c> pracGRGMap = new Map<Id,Global_Rewards_Group_Relationship__c>();
        Map<String,Global_Rewards_Group_Relationship__c> busGRGMap = new Map<String,Global_Rewards_Group_Relationship__c>();
        Map<Id,Set<String>> allPracAccMap = new Map<Id,Set<String>>();
        List<Premier_Tier__c> AssignTierLst = new List<Premier_Tier__c>();
        Global_Rewards_Group_Relationship__c busAssignGRGR = new Global_Rewards_Group_Relationship__c();
        Global_Rewards_Group_Relationship__c pracAssignGRGR = new Global_Rewards_Group_Relationship__c();
        
        for(Account s : scope){
            
            ///Business Account - Parent Tax Id Roll Up = False && Contract Type != Conflict ///Tiering at Practice Level
            if(s.ParentId != Null && s.Parent.Applied_Tier__c != Null){
                busAccParentMap.put(s.Id,s);
            }
            ///Business Account && Contract_Type__c = Rollup OR Conflict
            else if(s.ParentId !=Null){
                busAccGRGParentMap.put(s.Id,s);
                pracAccSet.add(s.ParentId);	                
            }   
        }
        
        if(!pracAccSet.isEmpty()){
            List<Global_Rewards_Group_Relationship__c> rollupGrpConflictRelation = [SELECT Id,Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Global_Rewards_Group__r.Parent_Account__r.Tax_ID__c,
                                                                                    Global_Rewards_Group__r.Parent_Account__c, Global_Rewards_Group__r.Applied_Tier__c, Global_Rewards_Group__r.Calculated_Tier__c, 
                                                                                    Start_Date__c, End_Date__c, Global_Rewards_Group__r.RecordTypeId, Global_Rewards_Group__r.Contract_Type__c, Global_Rewards_Group__r.Tier_Agreement_Type__c
                                                                                    FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__c IN :pracAccSet AND Status__c = 'Active'
                                                                                    AND Global_Rewards_Group__r.RecordTypeId = :grpTaxIdRecordTypeId
                                                                                    Order By CreatedDate ASC];
            
            List<Global_Rewards_Group_Relationship__c> busAccGRGRelation = [SELECT Id,Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Global_Rewards_Group__r.Parent_Account__r.Tax_ID__c,Global_Rewards_Group__r.Id,
                                                                            Global_Rewards_Group__r.Parent_Account__c, Global_Rewards_Group__r.Applied_Tier__c, Global_Rewards_Group__r.Calculated_Tier__c, 
                                                                            Start_Date__c, End_Date__c, Global_Rewards_Group__r.RecordTypeId, Global_Rewards_Group__r.Contract_Type__c, Global_Rewards_Group__r.Tier_Agreement_Type__c
                                                                            FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__r.ParentId IN :pracAccSet AND Status__c = 'Active'
                                                                            AND (Global_Rewards_Group__r.RecordTypeId = :grpContractRecordTypeId OR Global_Rewards_Group__r.RecordTypeId = :grpTaxIdContractRecordTypeId)
                                                                            Order By CreatedDate ASC];
            
            List<Account> allBusAccLst = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
                                          FROM Account WHERE ParentId in :pracAccSet AND 
                                          RecordTypeId = :busAccRecordTypeId AND Contract_Type__c != NULL AND CreatedDate != THIS_MONTH];
            
            for(Global_Rewards_Group_Relationship__c pracGRG :rollupGrpConflictRelation){
                pracGRGMap.put(pracGRG.Child_Account__c, pracGRG);
            }
            for(Global_Rewards_Group_Relationship__c busGRG :busAccGRGRelation){
                busGRGMap.put(busGRG.Global_Rewards_Group__r.Name, busGRG);
            }
            
            for(Account busAcc :allBusAccLst){                   
                if(allPracAccMap.containsKey(busAcc.ParentId)){
                    Set<String> existingvalue = allPracAccMap.get(busAcc.ParentId);
                    existingvalue.add(busAcc.Contract_Type__c);
                    allPracAccMap.put(busAcc.ParentId, existingvalue);
                }
                else{
                    allPracAccMap.put(busAcc.ParentId, new Set<String>{busAcc.Contract_Type__c});
                }                 
            }
        }
        
        List<Premier_Tier__c> allT = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
                                      Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
                                      Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
                                      FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Order__c DESC];
        
        for(Premier_Tier__c p: allT){
            if(p.Agreement_Type__c == null && p.Contract_Type__c != Null){
                if(conTypeTierMap.containsKey(p.Contract_Type__c)){
                    List<Premier_Tier__c> existingValues = conTypeTierMap.get(p.Contract_Type__c);
                    existingValues.add(p);
                    conTypeTierMap.put(p.Contract_Type__c, existingValues);
                }
                else{
                    conTypeTierMap.put(p.Contract_Type__c , new List<Premier_Tier__c>{p});
                }
            }        
        }
        
        ///Tiering at Parent Level////////////
        ///Business Account - Parent Tax Id Roll Up = False && Contact Type != Conflict///////////////////
        for(Account busAccParent :busAccParentMap.values()){
            ///Account has NO agreement type
            
            AssignTierLst = conTypeTierMap.get(busAccParent.Contract_Type__c);
            
            if(busAccParent.Contract_Type__c == busAccParent.Parent.Contract_Type__c){
                busAccParent.Applied_Tier__c = busAccParent.Parent.Applied_Tier__c;
                busAccParent.Calculated_Tier__c = busAccParent.Parent.Applied_Tier__c;
                busAcctoUpd.add(busAccParent);
            }
            
            else if(AssignTierLst != null && !AssignTierLst.isEmpty()){                    
                busAccParent.Applied_Tier__c = AssignTierLst[0].Id;
                busAccParent.Calculated_Tier__c = AssignTierLst[0].Id;
                busAcctoUpd.add(busAccParent);
            }                   
        }
        
        ///Business Account - Parent Tax Id Roll Up = True && Contract_Type__c = Rollup OR Conflict ///////////////////
        Set<String> currString = new Set<String>();
        Integer setSize = 0;
        for(Account busAccGRGParent :busAccGRGParentMap.values()){
            currString = allPracAccMap.get(busAccGRGParent.ParentId);
            if(currString != null && !currString.isEmpty()){
                setSize = currString.size();
            }  
            busAssignGRGR = busGRGMap.get('PREMIER - '+busAccGRGParent.Parent.Tax_ID__c+ ' - ' + busAccGRGParent.Contract_Type__c);
            pracAssignGRGR = pracGRGMap.get(busAccGRGParent.ParentId);
            AssignTierLst = conTypeTierMap.get(busAccGRGParent.Contract_Type__c);
            
            if(busAccGRGParent.Parent.Premier_Tax_ID_Roll_Up_Account__c == False || setSize > 1){
                if(busAssignGRGR != Null && busAssignGRGR.Global_Rewards_Group__r.Contract_Type__c == busAccGRGParent.Contract_Type__c){
                    busAccGRGParent.Applied_Tier__c = busAssignGRGR.Global_Rewards_Group__r.Applied_Tier__c;
                    busAccGRGParent.Calculated_Tier__c = busAssignGRGR.Global_Rewards_Group__r.Applied_Tier__c;
                    busAcctoUpd.add(busAccGRGParent);
                }
                else{
                    if(AssignTierLst != null && !AssignTierLst.isEmpty()){                    
                        busAccGRGParent.Applied_Tier__c = AssignTierLst[0].Id;
                        busAccGRGParent.Calculated_Tier__c = AssignTierLst[0].Id;
                        busAcctoUpd.add(busAccGRGParent);
                    }
                }
            }            
            ////Tax Id = True and Grouping of 1
            else if(setSize == 1){
                if(pracAssignGRGR != Null && pracAssignGRGR.Global_Rewards_Group__r.Contract_Type__c == busAccGRGParent.Contract_Type__c){
                    busAccGRGParent.Applied_Tier__c = pracAssignGRGR.Global_Rewards_Group__r.Applied_Tier__c;
                    busAccGRGParent.Calculated_Tier__c = pracAssignGRGR.Global_Rewards_Group__r.Applied_Tier__c;
                    busAcctoUpd.add(busAccGRGParent);
                }
                else{
                    if(AssignTierLst != null && !AssignTierLst.isEmpty()){                    
                        busAccGRGParent.Applied_Tier__c = AssignTierLst[0].Id;
                        busAccGRGParent.Calculated_Tier__c = AssignTierLst[0].Id;
                        busAcctoUpd.add(busAccGRGParent);
                    }
                }
            }
            else{
                if(AssignTierLst != null && !AssignTierLst.isEmpty()){                    
                    busAccGRGParent.Applied_Tier__c = AssignTierLst[0].Id;
                    busAccGRGParent.Calculated_Tier__c = AssignTierLst[0].Id;
                    busAcctoUpd.add(busAccGRGParent);
                }
            }
        }
        
        ///Update Accounts
        if(!busAcctoUpd.isEmpty()){
            //  insert grpReltoInst;
            
            Database.SaveResult[] SaveResultList = Database.update(busAcctoUpd,false); 
            
            for(integer i =0; i<SaveResultList.size();i++){
                String msg='';
                If(!SaveResultList[i].isSuccess()){
                    
                    msg += 'Business Account Record Id: ' + busAcctoUpd.get(i).id + '\n'+'Error: "';        
                    for(Database.Error err: SaveResultList[i].getErrors()){  
                        msg += err.getmessage()+'"\n\n';
                    } 
                }
                if(msg!= '')
                    exception_List.add(msg);
            } 
        }  
    }
    
    global void finish(Database.BatchableContext BC){
        
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
                
                mail.setSubject('Business Account - Daily Tier Batch Job failure');
                
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
        
        String[] toAddresses = new String[]{};  
        

        for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
            toAddresses.add(obj.Name);
        }
        
        
        
        if(!toAddresses.isEmpty()){
            
            Messaging.reserveSingleEmailCapacity(2);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toAddresses);
            
            mail.setSenderDisplayName('Salesforce Support');
            
            mail.setSubject('Business Account - Daily Tier Batch Job Completed');
            
            mail.setBccSender(false);
            
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            mail.setPlainTextBody('Business Account - Daily Tier Batch Job Completed.');
            
            mail.setHtmlBody('Business Account - Daily Tier Batch Job Completed.<br><br>');
            
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        
        if(!Test.isRunningTest()){
            vspr33_tierBenefitOutboundBatch batch = new vspr33_tierBenefitOutboundBatch();
            database.executeBatch(batch,50);
        }
    }
}