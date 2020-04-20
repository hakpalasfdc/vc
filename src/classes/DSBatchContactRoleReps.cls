/***************************************************
Caileigh Brown & Jitesh Bhatia, Implementation Engineers, 2/15/2017

Last Updated Date: 5/15/2017 (Jitesh Bhatia)

Brief Description: Allows a record to have multiple owners
all contained within a single CSV field.
****************************************************/
global class DSBatchContactRoleReps implements Database.Batchable<sobject>, Schedulable{
    
    global Database.Querylocator start (Database.BatchableContext BC) {
        return Database.getQueryLocator('SELECT Id, Concatenated_GAT_Formula__c FROM Account'); 
    }
    
    global void execute (Database.BatchableContext BC, List<sobject> scope) {
        List<Id> AccountIds = new List<Id>();
        
        System.debug('Accounts: ' + scope);
        for (sObject objScope: scope) { 
            Account newObjScope = (Account)objScope ;
            AccountIds.add(newObjScope.Id);
        }
        
        //Container Variable Setup.
        //System.debug('DialSource : DSContactRoleUpdates Line 43 : AccountIds' + AccountIds);
        Map<ID, string> AltRepsMap = new Map<ID, string>();
        List<Contact_Role__c> crList = [SELECT Id, DS_Altair_Rep_ID__c, Account__c, Contact__c
                                        From Contact_Role__c
                                        WHERE Account__c IN :AccountIds];
        List<string> AltRepsNumbers = new List<string>();
        List<string> SAPNumbers = new List<string>();
        Map<ID, string> gatMap = new Map<ID, string>();
        Map<string, ID> userMap = new Map<string, ID>();
        //System.debug('DialSource : in schedule after containers gat Query : '+ [SELECT ID, Altair_Reps__c FROM Account]);
        
        
        //Refresh Contact_Role__c Altair Rep Ids.
        for(Contact_Role__c cr : crList)
        {
            cr.DS_Altair_Rep_ID__c = null;
            //ystem.debug('DialSource : cr : ' + cr);
        }
        
        List<Account> acctList = [SELECT Id, Concatenated_GAT_Formula__c, Altair_Reps__c FROM Account WHERE Id IN :AccountIds];
        //System.debug('DialSource : AcctList : ' + AccountIds);
        
        //Get all SAPNumbers associated with the Contact_Role__c Accounts and add Altair_Standard__c string to map, Aswell as Altair numbers through the altair rep field on account.
        for(Account acct : acctList)
        {
            if(Acct.Altair_Reps__c!=null )
            {
                
                string Alt_Reps = Acct.Altair_Reps__c.replaceAll('\\s+', '');
                System.debug('Alt Reps: ' + Alt_Reps);
                AltRepsMap.put(acct.Id, Alt_Reps);
                AltRepsNumbers.addAll(Alt_Reps.split(','));
                //System.debug('DialSource Alt_Reps: ' + AltRepsNumbers);
            }
            
            else if(Acct.Concatenated_GAT_Formula__c!=null)
            {
                string gat = Acct.Concatenated_GAT_Formula__c;
                gat = gat.remove('null');
                //gat = gat.remove(':');
                for(string g : gat.split(':'))
                {
                    g = g.remove(':');
                    if(g.startsWith('ALT-R'))
                    {
                        gatMap.put(acct.Id, g);
                        SAPNumbers.add(g);
                        //System.debug('DialSource saps : ' + SAPNumbers);
                    }
                }
                
            }
            
        }
        
        //Use Altair Rep Field
        List <User> altairRepUsers = [SELECT ID, Altair_SAP_Number__c FROM User WHERE Altair_SAP_Number__c IN :AltRepsNumbers];
        
        for (User u : altairRepUsers)
        {
            userMap.put(u.Altair_SAP_Number__c, u.Id);
        }
        //System.debug('DialSource altairRepUsers List : ' + altairRepUsers);
        
        //Get users with an Altair SAP Number that is in Altair_Standard__c then add to userMap.
        List <User> sapRepUsers = [SELECT ID, MarketingID__c  FROM User WHERE MarketingID__c IN :SAPNumbers];
        
        for (User u : sapRepUsers)
        {
            userMap.put(u.MarketingID__c /*Altair_SAP_Number__c*/, u.Id);
        }
        
        
        System.debug('DialSource sapRepUsers List : ' + sapRepUsers);
        
        //Iterate through updated Contact_Role__c to update them.
        for(Contact_Role__c cr : CrList)
        {
            //System.debug('DialSource cr.acct = ' + cr.Account__c);       
            //Account itAcct = new Account();
            string gat = '';
            string alt = '';
            
            System.debug('Contact Role ID: ' + cr.Id);

            try
            {
                //System.debug('DialSource Acct  : ' + cr.Account__c);
                SAPNumbers = null;
                id aid = cr.Account__c;
                //system.debug('DialSource : AID Line 127 : ' + aid + ' : gat : ' + gatmap.get(aid) + ' : alts : ' + AltRepsMap.get(aid) );
                
                if(AltRepsMap.get(cr.Account__c) != null)//Gets Account's altair numbers through AltairReps.
                {
                    try
                    {
                        alt = AltRepsMap.get(cr.Account__c);
                        alt = alt.replace(' ', '');
                        SAPNumbers = alt.split(',');
                        System.debug('DialSource : SAPNumbers AltairReps : ' + SAPNumbers);
                    }catch(Exception e) {
                        System.debug('Exception caught: ' + e.getMessage());   
                        
                    }
                } else if (gatMap.get(aid) != null)//Gets Account's altair numbers through gat.
                {
                    try
                    {
                        SAPNumbers = new List<string>();
                        SAPNumbers.add(gatMap.get(aid));// != null);//Gets Account's altair numbers through Altair_Standard__c.);
                        System.debug('DialSource : SAPNumbers gat : ' + SAPNumbers);
                    }catch(Exception e) {
                        System.debug('Exception caught: ' + e.getMessage());   
                        
                    }
                }

                else
                     cr.DS_Altair_Rep_ID__c = NULL;
                
                
                //Get account specific SAPNumbers.
                if(!SAPNumbers.isEmpty())
                {
                    for(string sap : SAPNumbers)
                    {
                        //Match in order Account SAP Numbers with Rep Field.
                        //system.debug('DialSource In for Loop, line 133: ' + userMap.get(sap));
                        //System.debug('Altair SAP: ' + userMap.get(sap)); 

                        if (userMap != NULL && userMap.get(sap) != NULL &&  (cr.DS_Altair_Rep_ID__c == NULL || cr.DS_Altair_Rep_ID__c == '' || !cr.DS_Altair_Rep_ID__c.contains(userMap.get(sap))))
                        {
                            if (cr.DS_Altair_Rep_ID__c == NULL || cr.DS_Altair_Rep_ID__c == '')
                            {
                                cr.DS_Altair_Rep_ID__c = userMap.get(sap); 
                            }

                            else
                            {
                                cr.DS_Altair_Rep_ID__c += ',' + userMap.get(sap);
                            }

                            System.debug('Altair Rep ID: ' + cr.DS_Altair_Rep_ID__c ); 
                        }
                    }
                } 

            } catch(DmlException e){
                system.debug('DML' + e.getMessage());
            }catch(Exception e) {
                System.debug('Exception caught: ' + e.getMessage());   
                
            }
        }
        
        try {
            update crList;
        }
        
        catch (DMLException e)
        {
            System.debug('Failed to update contact roles: ' + crList);
        }
    }
    
     //Finish Method
    global void finish(Database.BatchableContext BC){
        /*Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //Below code will fetch the job Id
        AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors, a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById, a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];//get the job Id
        System.debug('$$$ Jobid is'+BC.getJobId());
        
        //below code will send an email to User about the status
        mail.setToAddresses(new List<String>{'support@dialsource.com', 'implementation@dialsource.com'});
        mail.setReplyTo('support@dialsource.com');//Add here your email address
        mail.setSenderDisplayName('Apex Batch Processing Module');
        mail.setSubject('Batch Processing '+a.Status);
        mail.setPlainTextBody('The Batch Apex job processed  '+a.TotalJobItems+'batches with  '+a.NumberOfErrors+'failures'+'Job Item processed are'+a.JobItemsProcessed);
        Messaging.sendEmail(new Messaging.Singleemailmessage [] {mail});*/
    }
    
    //Scheduler Method to schedule the class
    global void execute(SchedulableContext sc)
    {
        DSBatchContactRoleReps batchJob = new DSBatchContactRoleReps();
        database.executebatch(batchJob, 200);
    }
}