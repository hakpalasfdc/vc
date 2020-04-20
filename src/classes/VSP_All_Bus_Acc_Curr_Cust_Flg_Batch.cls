global class VSP_All_Bus_Acc_Curr_Cust_Flg_Batch implements Database.Batchable<sObject>, Database.Stateful{

     private static Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private date yestrDay = Date.today().addDays(-1); 
    private date todayDate = Date.today();
    global List<String> exception_List = new List<String>();
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Location_Type__c, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c, Vision_Care_VSP_Affiliate__c,
                                         Vision_Care_VSP_Network_Provider__c, Vision_Care_VSP_Other__c, VC__c
                                         FROM Account
                                         WHERE RecordTypeId = :busAccRecordTypeId]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        VSPUtility.stopAccountTrigger = True;  ///bypass Account Trigger
        List<Account> accToUpdLst = new List<Account>();
        for(Account a :scope){
            ///Account Eneded ///Clear Current Customer Flags
            if(a.VC__c == False
              && (a.Vision_Care_VSP_Affiliate__c != FALSE || a.Vision_Care_VSP_Network_Provider__c != FALSE || a.Vision_Care_VSP_Other__c != FALSE)){
                a.Vision_Care_VSP_Network_Provider__c = FALSE;
                a.Vision_Care_VSP_Affiliate__c = FALSE;
                a.Vision_Care_VSP_Other__c = FALSE;
                a.Bypass_VC_Validation_Rules__c = TRUE;
                accToUpdLst.add(a);
            }
            ///Account Active///Set Current Customer Flags
            else{
                if(a.Location_Type__c == 'M - VSP Member Location'  
                   && (a.Vision_Care_End_Date__c >= Date.today() || a.Vision_Care_End_Date__c == NULL)
                   && (a.Vision_Care_VSP_Affiliate__c != TRUE || a.Vision_Care_VSP_Network_Provider__c != FALSE || a.Vision_Care_VSP_Other__c != FALSE)){
                       a.Vision_Care_VSP_Network_Provider__c = TRUE;
                       a.Vision_Care_VSP_Affiliate__c = FALSE;                                               
                       a.Vision_Care_VSP_Other__c = FALSE;
                       a.Bypass_VC_Validation_Rules__c = TRUE;
                       accToUpdLst.add(a);
                   }
                else if(a.Location_Type__c == 'A - Affiliate Provider Location'
                        && (a.Vision_Care_End_Date__c >= Date.today() || a.Vision_Care_End_Date__c == NULL)
                        && (a.Vision_Care_VSP_Affiliate__c != TRUE || a.Vision_Care_VSP_Network_Provider__c != FALSE || a.Vision_Care_VSP_Other__c != FALSE)){
                            a.Vision_Care_VSP_Network_Provider__c = FALSE;
                            a.Vision_Care_VSP_Affiliate__c = TRUE;                           
                            a.Vision_Care_VSP_Other__c = FALSE;
                            a.Bypass_VC_Validation_Rules__c = TRUE;
                            accToUpdLst.add(a);
                        }
                else if((a.Location_Type__c == 'F - Laser Vision Correction (LVC)' ||  a.Location_Type__c == 'X - Client Authorized Location (GAP)') 
                        && (a.Vision_Care_End_Date__c >= Date.today() || a.Vision_Care_End_Date__c == NULL)
                        && (a.Vision_Care_VSP_Affiliate__c != FALSE || a.Vision_Care_VSP_Network_Provider__c != FALSE || a.Vision_Care_VSP_Other__c != TRUE)){
                            a.Vision_Care_VSP_Network_Provider__c = FALSE;
                            a.Vision_Care_VSP_Affiliate__c = FALSE;                            
                            a.Vision_Care_VSP_Other__c = TRUE;
                            a.Bypass_VC_Validation_Rules__c = TRUE;
                            accToUpdLst.add(a);
                        }     
            }
        }
        
         ///Update Accounts
        if(!accToUpdLst.isEmpty()){
            //  insert grpReltoInst;
            
            Database.SaveResult[] SaveResultList = Database.update(accToUpdLst,false); 
            
            for(integer i =0; i<SaveResultList.size();i++){
                String msg='';
                If(!SaveResultList[i].isSuccess()){
                    
                    msg += 'Business Account Record Id: ' + accToUpdLst.get(i).id + '\n'+'Error: "';        
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
        
    }
}