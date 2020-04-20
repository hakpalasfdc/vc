global class VSPR32_Override_Bus_Acc_Tier_Prac_Batch implements Database.Batchable<sObject>, Database.Stateful{

    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    Private Date todaysDate = Date.today();
    global List<String> exception_List = new List<String>();
    
   
     global Database.QueryLocator start(Database.BatchableContext BC){
        //  String query = 'SELECT Id, Applied_Tier__c, Calculated_Tier__c, ParentId, Vision_Care_Good_Standing__c FROM Account WHERE ParentId in \''+:practiceIds+'\' AND RecordTypeId =  \''+:accRecordTypeId +'\''; 
        return Database.getQueryLocator([SELECT Id, Applied_Tier__c, Calculated_Tier__c, ParentId, Vision_Care_Good_Standing__c, VC__c
                                         FROM Account
                                         WHERE Parent.Override_Tier_Effective_Date__c = :todaysDate
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
            Map<Id,Account> pracAccLst = new Map<Id,Account>([SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Id IN :pracIdSet]);
            
            
                for(Account bAcc :busAccMap.values()){
                    Account pAcc = pracAccLst.get(bAcc.ParentId);
                    if(bAcc.ParentId == pAcc.Id){
                        if(bAcc.Vision_Care_Good_Standing__c != True || bAcc.VC__c != True){
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
                
                mail.setSubject('Daily Override Premier Admin Tool Batch Job failure - Business Account Premier Tier Update Failed');
                
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
        
        //Below part commented out by Vikhyat on 10/07/2019
        /*String[] toAddresses = new String[]{};            
            for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                toAddresses.add(obj.Name);
            }
        if(!toAddresses.isEmpty()){
            
            Messaging.reserveSingleEmailCapacity(2);
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            
            mail.setToAddresses(toAddresses);
            
            mail.setSenderDisplayName('Salesforce Support');
            
            mail.setSubject('Daily Override Premier Admin Tool Batch Jobs Completed');
            
            mail.setBccSender(false);
            
            mail.setUseSignature(false);
            
            // Specify the text content of the email.
            mail.setPlainTextBody('Daily Override Premier Admin Tool Batch Jobs Completed.');
            
            mail.setHtmlBody('Daily Override Premier Admin Tool Batch Jobs Completed.<br><br>');
            
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }*/
        //Commented out part by Vikhyat ends here.

        //Below part added by Vikhyat on 10/07/2019
        String[] toAddresses1 = new String[]{};
            
        for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
            toAddresses1.add(obj.Name);
        }
        
        if(!toAddresses1.isEmpty()){
            Messaging.reserveSingleEmailCapacity(2);
                
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
            mail.setToAddresses(toAddresses1);
                
            mail.setSenderDisplayName('Salesforce Support');
                
            mail.setSubject('Daily batch job Part 2: Successful ');
                
            mail.setBccSender(false);
                
            mail.setUseSignature(false);
                
            // Specify the text content of the email.
            mail.setPlainTextBody('Sucessful run of Premier Admin Tool Daily Part 2 Batch Jobs.');
                
            mail.setHtmlBody('Sucessful run of Premier Admin Tool Daily Part 2 Batch Jobs.<br><br>');
                
            // Send the email you have created.
            if(!Test.isRunningTest()){
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
            }
        }
        
    }
}