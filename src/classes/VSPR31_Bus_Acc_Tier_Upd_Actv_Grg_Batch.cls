global class VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    global List<String> exception_List = new List<String>();
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private Set<Id> grgIds = new Set<Id>();
    
    
    public VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch(Set<Id> gIds){
        grgIds = gIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Applied_Tier__c, Calculated_Tier__c, Vision_Care_Good_Standing__c 
                                         FROM Account 
                                         WHERE RecordTypeId = :accRecordTypeId 
                                         AND Id IN (SELECT Child_Account__c 
                                                    FROM Global_Rewards_Group_Relationship__c 
                                                    WHERE Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)
                                                    AND Global_Rewards_Group__c IN :grgIds)]);
    }
    
    
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        VSPUtility.stopAccountTrigger=true;
        // Set<Id> grgIdSet = new Set<Id>();
        Map<Id,Account> busAccMap = new Map<Id,Account>();
        
        Map<Id,Global_Rewards_Group__c> grgMap = new Map<Id,Global_Rewards_Group__c>();
        
        for(Account s : scope){           
            //   grgIdSet.add(s.Id);
            busAccMap.put(s.Id,s);
        }
        
        if(!grgIds.isEmpty() && !busAccMap.isEmpty()){
            Set<Account> busAccUpd = new Set<Account>();
            List<Global_Rewards_Group__c> updGrgTiers = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, RecordType.DeveloperName FROM Global_Rewards_Group__c Where Id in :grgIds];
            for(Global_Rewards_Group__c g :updGrgTiers){
                grgMap.put(g.Id,g);
            }
            List<Global_Rewards_Group_Relationship__c> grgRel = [SELECT Id, Child_Account__c, Global_Rewards_Group__c, End_Date__c FROM Global_Rewards_Group_Relationship__c
                                                                 WHERE Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)
                                                                 AND Global_Rewards_Group__c IN :grgIds AND Child_Account__c IN :busAccMap.keySet()];
            
            
            
            //   for(Global_Rewards_Group__c grg :updGrgTiers){
            for(Id busAccId :busAccMap.keySet()){
                Account busAcc = busAccMap.get(busAccId);
                for(Global_Rewards_Group_Relationship__c grgR :grgRel){
                    if(busAcc.Id == grgR.Child_Account__c){//} && grgR.Global_Rewards_Group__c == grg.Id){
                        if(busAcc.Vision_Care_Good_Standing__c != True){
                            busAcc.Applied_Tier__c = null;
                            busAcc.Calculated_Tier__c = null;
                            busAcc.Tier_Calculation_Group_Level_Batch__c = null;
                            busAcc.Tier_Calculation_Record_ID__c = null;
                            busAccUpd.add(busAcc);
                            break;
                        }
                        else{
                            busAcc.Applied_Tier__c = grgMap.get(grgR.Global_Rewards_Group__c).Applied_Tier__c;      ///grg.Applied_Tier__c;
                            busAcc.Calculated_Tier__c = grgMap.get(grgR.Global_Rewards_Group__c).Calculated_Tier__c;
                            if(grgMap.get(grgR.Global_Rewards_Group__c).Applied_Tier__c == null){
                                busAcc.Tier_Calculation_Group_Level_Batch__c = null;
                                busAcc.Tier_Calculation_Record_ID__c = null;
                                busAccUpd.add(busAcc);
                                break;
                            }
                            else if(grgMap.get(grgR.Global_Rewards_Group__c).RecordType.DeveloperName == 'Tax_ID_Rollup_Contract_Type'){
                                busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grgMap.get(grgR.Global_Rewards_Group__c).Id +',' + ' Tax ID Rollup & Contract Type';
                                busAcc.Tier_Calculation_Record_ID__c = grgMap.get(grgR.Global_Rewards_Group__c).Id;
                                busAccUpd.add(busAcc);
                                break;
                            }
                            else if(grgMap.get(grgR.Global_Rewards_Group__c).RecordType.DeveloperName == 'Tax_ID_Rollup'){
                                busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grgMap.get(grgR.Global_Rewards_Group__c).Id +',' + ' Tax ID Rollup';
                                busAcc.Tier_Calculation_Record_ID__c = grgMap.get(grgR.Global_Rewards_Group__c).Id;
                                busAccUpd.add(busAcc);
                                break;
                            }
                            else if(grgMap.get(grgR.Global_Rewards_Group__c).RecordType.DeveloperName == 'Contract_Type'){
                                busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grgMap.get(grgR.Global_Rewards_Group__c).Id +',' + ' Contract Type';
                                busAcc.Tier_Calculation_Record_ID__c = grgMap.get(grgR.Global_Rewards_Group__c).Id;
                                busAccUpd.add(busAcc);
                                break;
                            }
                        }
                        //busAccUpd.add(busAcc);
                    }
                }
                
            }
            
            //         }
            
            
            List<Account> busAccUpdLst = new List<Account>(busAccUpd);
            system.debug('busAccUpd List '+ busAccUpd);
            if(!busAccUpdLst.isEmpty()){
                // update busAccUpd;
                
                Database.SaveResult[] SaveResultList = Database.update(busAccUpdLst,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Group Reward Group Record Id: ' + busAccUpdLst.get(i).id + '\n'+'Error: "';        
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
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Business Account Tier Update Failed');
                
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
        
        if(!Test.isRunningTest()){
            VSPR31_Bus_Acc_Tier_Upd_Not_Actv_Batch obj = new VSPR31_Bus_Acc_Tier_Upd_Not_Actv_Batch(grgIds);
            Database.executeBatch(obj, 50);
        }
    }
}