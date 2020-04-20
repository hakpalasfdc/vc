global class VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private Set<Id> practiceIds = new Set<Id>();
    
    global List<String> exception_List = new List<String>();
    
    public VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch(Set<Id> pracIds){
        practiceIds = pracIds;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        //  String query = 'SELECT Id, Applied_Tier__c, Calculated_Tier__c, ParentId, Vision_Care_Good_Standing__c FROM Account WHERE ParentId in \''+:practiceIds+'\' AND RecordTypeId =  \''+:accRecordTypeId +'\''; 
        return Database.getQueryLocator([SELECT Id, Applied_Tier__c, Calculated_Tier__c, ParentId, Vision_Care_Good_Standing__c 
                                         FROM Account
                                         WHERE ParentId IN :practiceIds
                                         AND RecordTypeId = :accRecordTypeId]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        VSPUtility.stopAccountTrigger=true;
        Map<Id, Account> busAccMap = new Map<Id, Account>();
        Set<Id> pracIdSet = new Set<Id>();
        
        for(Account s : scope){
            busAccMap.put(s.Id,s);
            pracIdSet.add(s.ParentId);
        }
        
        if(!busAccMap.isEmpty()){
            
            Set<Account> busAccUpd = new Set<Account>();
            List<Account> pracAccLst = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Id IN :pracIdSet];
            
            for(Account pAcc :pracAccLst){
                for(Id bAccId :busAccMap.keySet()){
                    Account bAcc = busAccMap.get(bAccId);
                    if(bAcc.ParentId == pAcc.Id){
                        if(bAcc.Vision_Care_Good_Standing__c != True){
                            bAcc.Applied_Tier__c = null;
                            bAcc.Calculated_Tier__c = null;
                            bAcc.Tier_Calculation_Group_Level_Batch__c = null;
                            bAcc.Tier_Calculation_Record_ID__c = null;
                        }
                        else{                            
                            bAcc.Applied_Tier__c = pAcc.Applied_Tier__c;
                            bAcc.Calculated_Tier__c = pAcc.Calculated_Tier__c;
                            
                            if(pAcc.Applied_Tier__c == null){
                                bAcc.Tier_Calculation_Group_Level_Batch__c = null;
                                bAcc.Tier_Calculation_Record_ID__c = null;
                            }
                            else{
                                bAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ pAcc.Id +',' + ' Practice'; 
                                bAcc.Tier_Calculation_Record_ID__c = pAcc.Id;
                            }    
                        }
                        busAccUpd.add(bAcc);
                    }
                }
            }
            
            
            
            List<Account> busAccUpdLst = new List<Account>(busAccUpd);
            system.debug('busAccUpd List '+ busAccUpd);
            if(!busAccUpdLst.isEmpty()){
                // update busAccUpd;
                
                Database.SaveResult[] SaveResultList = Database.update(busAccUpdLst,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Business Account Record Id: ' + busAccUpdLst.get(i).id + '\n'+'Error: "';        
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
        
        List<User> batchUserLst = new List<User>();
        for(User batchRunningUser : [SELECT Id, Bypass_Account_Process__c FROM User WHERE Id = :UserInfo.getUserId()]){
            if(batchRunningUser.Bypass_Account_Process__c == True){
                batchRunningUser.Bypass_Account_Process__c = False;
                batchUserLst.add(batchRunningUser);
            }
        }
        if(!batchUserLst.isEmpty()){
            update batchUserLst;
        }
        
        
        
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            for(Premier_Admin_Email__c obj1:[select Name from Premier_Admin_Email__c]){
                toAddresses.add(obj1.Name);
            }
            
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Practice Account Premier Tier Update Failed');
                
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
        for(Premier_Admin_Email__c obj1:[select Name from Premier_Admin_Email__c]){
            toAddresses.add(obj1.Name);
        }
        if(!toAddresses.isEmpty()){
            
            Messaging.reserveSingleEmailCapacity(2);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toAddresses);
            
            mail.setSenderDisplayName('Salesforce Support');
            
            mail.setSubject('Premier Admin Tool Batch Jobs Completed');
            
            mail.setBccSender(false);
            
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            mail.setPlainTextBody('Premier Admin Tool Batch Jobs Completed.');
            
            mail.setHtmlBody('Premier Admin Tool Batch Jobs Completed.<br><br>');
            
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        
    }
}