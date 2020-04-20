/*
*  VSPR19_ChangeTaxIDCtrl 
*
*/
public with sharing class VSPR19_ChangeTaxIDCtrl {
    public boolean isvalidUser{get;set;}
    public Account acc{get;set;}
    public Account accTEMP{get;set;}
    public Account accPREV{get;set;}
    public account exisingAccount{get;set;}

    /*public static boolean stopAccountTrg = false;
    public static boolean stopnwRelationshipsTrg = false;
    public static boolean stopValidateCHOICNetwork = false;
    public static boolean stopApplyProgramID = false;*/
    ApexPages.standardController m_sc = null;
    //Public Date existingVCED {get; set;}
    public VSPR19_ChangeTaxIDCtrl(Apexpages.standardcontroller sc){

        m_sc = sc;
        acc=new Account();
        accTEMP=new Account();
        accPREV=new Account();
        exisingAccount=(Account)sc.getrecord();
        exisingAccount=[SELECT id,ShippingCity,
        ShippingState,ShippingStreet,ShippingPostalCode,
        BillingCity, BillingState,BillingStreet,BillingPostalCode,
        Common_Account_Name_Report__c,IRS_Tax_ID__c,IRS_Name__c, VSP_Key__c,
        Practice_Business_Type__c,Vision_Care_Effective_Date__c,Vision_Care_End_Date__c,
        Vision_Care_Location_Key__c,BillingCountry, Tax_ID__c, ParentId  
        FROM account
        WHERE id=:exisingAccount.id];    

        //existingVCED = exisingAccount.Vision_Care_End_Date__c;
        accTEMP.Vision_Care_End_Date__c = exisingAccount.Vision_Care_End_Date__c;
        accPREV.Vision_Care_Effective_Date__c = exisingAccount.Vision_Care_Effective_Date__c;
        accPREV.Vision_Care_End_Date__c = exisingAccount.Vision_Care_End_Date__c;
        acc.BillingCity=exisingAccount.BillingCity;
        acc.BillingState=exisingAccount.BillingState;
        acc.BillingStreet=exisingAccount.BillingStreet;
        acc.BillingPostalCode=exisingAccount.BillingPostalCode;  

        system.debug('existingAccount: '+exisingAccount);
        system.debug('accPREV: '+accPREV);
    }
    
    public PageReference doCancel(){
        return m_sc.cancel();
    }
    
    public void validateVCEndDate(){

        system.debug('RULE3pre....');
        system.debug('RULE3pre - accPREV.Vision_Care_Effective_Date__c: '+accPREV.Vision_Care_Effective_Date__c);
        system.debug('RULE3pre - accTEMP.Vision_Care_End_Date__c: '+accTEMP.Vision_Care_End_Date__c);
        if(accTEMP.Vision_Care_End_Date__c != NULL && accPREV.Vision_Care_Effective_Date__c != NULL &&
        accTEMP.Vision_Care_End_Date__c < accPREV.Vision_Care_Effective_Date__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vision Care End Date must be greater than or equal to Vision Care Effective Date'));
            //return null;
        }

        date today = system.today();
        date vcedDate = date.valueOf(accTEMP.Vision_Care_End_Date__c);
        system.debug('RULE4pre....');
        system.debug('RULE4pre - today: '+today);
        system.debug('RULE4pre - vcedDate: '+vcedDate);
        if(today != NULL && vcedDate != NULL && vcedDate < today) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vision Care End Date must be greater than or equal to today'));
            //return null;
        }
    }
    
    public pagereference createtaxId(){

        try{
            system.debug('RULE1....');
            system.debug('RULE1 - acc.Vision_Care_End_Date__c: '+acc.Vision_Care_End_Date__c);
            system.debug('RULE1 - acc.Vision_Care_Effective_Date__c: '+acc.Vision_Care_Effective_Date__c);
            system.debug('RULE1 - accTEMP.Vision_Care_End_Date__c: '+accTEMP.Vision_Care_End_Date__c);
            if(accTEMP.Vision_Care_End_Date__c != NULL && acc.Vision_Care_Effective_Date__c != NULL && accTEMP.Vision_Care_End_Date__c >= acc.Vision_Care_Effective_Date__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'New Tax ID Effective Date must be greater than Vision Care End Date')); return null;
            }

            system.debug('RULE2....');
            system.debug('RULE2 - acc.Vision_Care_Effective_Date__c: '+acc.Vision_Care_Effective_Date__c);
            system.debug('RULE2 - acc.Vision_Care_End_Date__c: '+acc.Vision_Care_End_Date__c);
            if(acc.Vision_Care_End_Date__c != NULL && acc.Vision_Care_Effective_Date__c != NULL && acc.Vision_Care_Effective_Date__c >= acc.Vision_Care_End_Date__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'New Tax ID Effective Date must be less than the New Tax ID End Date')); return null;
            }

            system.debug('RULE3pre....');
            system.debug('RULE3pre - accPREV.Vision_Care_Effective_Date__c: '+accPREV.Vision_Care_Effective_Date__c);
            system.debug('RULE3pre - accTEMP.Vision_Care_End_Date__c: '+accTEMP.Vision_Care_End_Date__c);
            if(accTEMP.Vision_Care_End_Date__c != NULL && accPREV.Vision_Care_Effective_Date__c != NULL && accTEMP.Vision_Care_End_Date__c < accPREV.Vision_Care_Effective_Date__c) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vision Care End Date must be greater than or equal to Vision Care Effective Date')); return null;
            }

            date today = system.today();
            date vcedDate = date.valueOf(accTEMP.Vision_Care_End_Date__c);
            system.debug('RULE4pre....');
            system.debug('RULE4pre - today: '+today);
            system.debug('RULE4pre - vcedDate: '+vcedDate);
            if(today != NULL && vcedDate != NULL && vcedDate < today) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Vision Care End Date must be greater than or equal to today')); return null;
            }

            //TaxID values
            Tax_ID_History__c tih=new Tax_ID_History__c();
            tih.Account__c=exisingAccount.id;
            tih.Effective_Date__c=exisingAccount.Vision_Care_Effective_Date__c;
            tih.IRS_Name__c=exisingAccount.IRS_Name__c;
            tih.Tax_ID__c=exisingAccount.IRS_Tax_ID__c;
            tih.Vision_Care_Key__c=exisingAccount.IRS_Tax_ID__c;
            tih.Vision_Care_Practice_City__c=exisingAccount.BillingCity;
            tih.Vision_Care_Practice_State__c=exisingAccount.BillingState;
            tih.Vision_Care_Practice_Street__c=exisingAccount.BillingStreet;
            tih.Vision_Care_Practice_Zip__c=exisingAccount.BillingPostalCode;
            tih.Practice_Business_Type__c=exisingAccount.Practice_Business_Type__c;
            tih.End_Date__c=accTEMP.Vision_Care_End_Date__c;

            system.debug('*****tih.Effective_Date__c*******'+tih.Effective_Date__c);
            system.debug('*****tih.End_Date__c*******'+tih.End_Date__c);

            insert tih;

            list<Account> lstBusinessAccounts;
            String[] ph1;
            String ph;
            String formLK;  //form the location key by replacing the Tax ID
            String seqKey;  //save the sequence key
            String trimmedAddressKey; //Address trimmed 
            Boolean streetAddresschar1 = false;
            Boolean streetAddresschar2 = false;
            Boolean streetAddresschar3 = false;
            Boolean streetAddresschar4 = false;
            String streetAddress = ''; 
            lstBusinessAccounts = [SELECT Id,Vision_Care_Effective_Date__c,IRS_Tax_ID__c,IRS_Name__c,ShippingCity,ShippingState,
                                          ShippingStreet,ShippingPostalCode,BillingCity, BillingState,BillingStreet,BillingPostalCode,
                                          Vision_Care_End_Date__c,Practice_Business_Type__c, Vision_Care_Location_Key__c, VSP_Key__c, 
                                          Tax_ID__c, ParentId, Parent.IRS_Tax_ID__c, Parent.Tax_ID__c, Practice_IRS_Tax_ID__c
                                     FROM Account 
                                    WHERE ParentId = :exisingAccount.Id 
                                      AND RecordType.name = 'Business Account' 
                                      AND ((Vision_Care_Effective_Date__c <= Today 
                                      AND (Vision_Care_End_Date__c = NULL 
                                       OR Vision_Care_End_Date__c > Today)) 
                                       OR Vision_Care_Effective_Date__c > Today)];  

            list<Account> updateBizAccount = new list<Account>();
            if(!lstBusinessAccounts.isEmpty()){
                system.debug('lstBusinessAccounts: '+lstBusinessAccounts[0].Id);

                list<Tax_ID_History__c> lstTaxIDHistory = new list<Tax_ID_History__c>();

                for(Account acct : lstBusinessAccounts) {
                    Tax_ID_History__c ti=new Tax_ID_History__c();
                    ti.Account__c=acct.id;
                    ti.IRS_Name__c=exisingAccount.IRS_Name__c;
                    ti.Tax_ID__c=exisingAccount.IRS_Tax_ID__c;
                    ti.Vision_Care_Key__c=acct.Vision_Care_Location_Key__c;
                    ti.Vision_Care_Practice_City__c=acct.BillingCity;
                    ti.Vision_Care_Practice_State__c=acct.BillingState;
                    ti.Vision_Care_Practice_Street__c=acct.BillingStreet;
                    ti.Vision_Care_Practice_Zip__c=acct.BillingPostalCode;
                    ti.Practice_Business_Type__c=exisingAccount.Practice_Business_Type__c;
                    ti.Effective_Date__c=exisingAccount.Vision_Care_Effective_Date__c;
                    ti.End_Date__c=accTEMP.Vision_Care_End_Date__c; 
                    lstTaxIDHistory.add(ti);         
                } 
                system.debug('lstTaxIDHistory: '+lstTaxIDHistory);
                if(!lstTaxIDHistory.isEmpty()) {
                    insert lstTaxIDHistory;
                } 

                System.Debug('Size of list: ' + lstBusinessAccounts.size());

                for(Account acct2 : lstBusinessAccounts) {
                    streetAddress = '';
                    Account aX2 = new Account(Id=acct2.Id);  
                    aX2.IRS_Tax_ID__c = acc.Tax_ID__c;   
                    System.Debug('^^^ Check 1 ^^^' + acc.Tax_ID__c);                  
                    System.Debug('^^^ Check 2 ^^^' + aX2.IRS_Tax_ID__c);
                    aX2.Vision_Care_Effective_Date__c=acc.Vision_Care_Effective_Date__c;
                    if(acc.Vision_Care_End_Date__c != NULL){
                        aX2.Vision_Care_End_Date__c=acc.Vision_Care_End_Date__c;
                    }

                    if(acct2.IRS_Tax_ID__c != NULL){
                        aX2.VSP_Key__c = acc.Tax_ID__c;  //acct2.IRS_Tax_ID__c;  
                    } 

                    /*
                    System.Debug('acct2 irs tax id' + acct2.IRS_Tax_ID__c);                        
                    System.Debug('acct2 tax id' + acct2.Tax_ID__c);
                    System.Debug('acct2 vision care location key ' + acct2.Vision_Care_Location_Key__c);
                    System.Debug('acct2 billing street ' + acct2.BillingStreet);
                    System.Debug('acc irs tax id' + acc.IRS_Tax_ID__c);
                    System.Debug('acc tax id' + acc.Tax_ID__c);
                    System.Debug('acc vision care location key ' + acc.Vision_Care_Location_Key__c);
                    System.Debug('acc billing street ' + acc.BillingStreet);
                    */

                    if(acct2.Vision_Care_Location_Key__c != NULL && acct2.Vision_Care_Location_Key__c.length() <= 15){
                        formLK = ''; 
                        String replacementString = acc.Tax_ID__c;  //acct2.Parent.Tax_ID__c;
                        System.Debug('Replacement String: ' + replacementString);
                        String addressString = acct2.ShippingStreet;
                        System.Debug('** replace add **' + addressString);
                        String key = acct2.Vision_Care_Location_Key__c.substring(9, acct2.Vision_Care_Location_Key__c.length());
                        System.Debug('** key **' + key);
                        String seqK = key.right(1);
                        System.Debug('** seqK **' + seqK);

                        if(addressString != null){
                            if(addressString.length() >= 1){
                                streetAddresschar1 = (addressString.substring(0,1)).isNumeric();             
                                system.debug('+++streetAddresschar1+++'+streetAddresschar1);
                            }

                            if(addressString.length() >= 2){
                                streetAddresschar2 = (addressString.substring(1,2)).isNumeric();
                                system.debug('+++streetAddresschar2+++'+streetAddresschar2);
                            }

                            if(addressString.length() >= 3){
                                streetAddresschar3 = (addressString.substring(2,3)).isNumeric();
                                system.debug('+++streetAddresschar3+++'+streetAddresschar3);
                            }

                            if(addressString.length() >= 4){
                                streetAddresschar4 = (addressString.substring(3,4)).isNumeric();
                                system.debug('+++streetAddresschar4+++'+streetAddresschar4);
                            }
                        }               
                    
                        if(streetAddresschar1 == true){
                            streetAddress = streetAddress + addressString.substring(0,1);
                            System.Debug('^^^ Address1 ^^^' + streetAddress);
                            if(streetAddresschar2 == true){
                                streetAddress = streetAddress + addressString.substring(1,2);
                                System.Debug('^^^ Address2 ^^^' + streetAddress);
                                if(streetAddresschar3 == true){
                                    streetAddress = streetAddress + addressString.substring(2,3);
                                    System.Debug('^^^ Address3 ^^^' + streetAddress);
                                if(streetAddresschar4 == true){
                                    streetAddress = streetAddress + addressString.substring(3,4);
                                    System.Debug('^^^ Address4 ^^^' + streetAddress);
                                }
                                else{ 
                                    streetAddress = streetAddress + ' ';                                
                                }
                                }
                                else{ 
                                    streetAddress = streetAddress + '  ';
                                }
                            }
                            else{ 
                                streetAddress = streetAddress + '   ';
                            }
                        }
                        else{ 
                            streetAddress = streetAddress + '    ';
                        }

                        //formLK = acc.Tax_ID__c + streetAddress + seqK; 
                        formLK = acc.Tax_ID__c + streetAddress.substring(0,4) + seqK;
                        if(formLK.length() > 15){  //<=15
                            System.Debug('^^^String too long^^^');
                        }
                        if(formLK.length() <= 15){
                            aX2.Vision_Care_Location_Key__c = formLK;                     
                        }
                        aX2.Bypass_VC_Validation_Rules__c = true;
                    }
                    System.Debug('Location key modified is: ' +  formLK);
                    updateBizAccount.add(aX2); 
                system.debug('lstBusinessAccountsToUpdate: '+lstBusinessAccounts);
                }
                if(!updateBizAccount.isEmpty()) {
                    update updateBizAccount;                     
                }

                list<Account> updatedlstBusinessAccounts;
                updatedlstBusinessAccounts = [SELECT Id, Vision_Care_Location_Key__c
                FROM Account 
                WHERE ParentId = :exisingAccount.Id 
                AND RecordType.name = 'Business Account']; 

                Map<String,String> lbaMap = new Map<String,String>();
                for(Account x : updatedlstBusinessAccounts){
                    lbaMap.put(x.Id,x.Vision_Care_Location_Key__c);
                }


                Batch_ChangeTaxIdNetRel x = new Batch_ChangeTaxIdNetRel();
                x.lstBusinessAccounts = lstBusinessAccounts;
                x.accTEMP_Vision_Care_End_Date = accTEMP.Vision_Care_End_Date__c;
                x.acc_Vision_Care_End_Date = acc.Vision_Care_End_Date__c;
                x.acc_Vision_Care_Effective_Date = acc.Vision_Care_Effective_Date__c;
                x.lbaMap = lbaMap;
                Id batchId = Database.executeBatch(x, 25);

                /******
                list<Network_Relationship__c> lstNetRelation = [SELECT Id,Program_ID__c,Program_End_Date__c,Directory_End_Date__c,Account_Name__c,
                                                                       Contact_Role__c, Provider_Name__c, Vision_Care_Location_Key__c, Fee_Code__c,
                                                                       LVC_Negotiated_Discount__c, Account_Name__r.Vision_Care_Effective_Date__c,
                                                                       Account_Name__r.Vision_Care_End_Date__c, Program_Effective_Date__c, 
                                                                       Bypass_VC_Validation_Rules__c
                                                                  FROM Network_Relationship__c WHERE Account_Name__c IN :lstBusinessAccounts];
                                                                 //AND Program_Effective_Date__c <= :acc.Vision_Care_End_Date__c 
                                                                 //AND Program_End_Date__c > :acc.Vision_Care_Effective_Date__c]; 
            
                system.debug('lstNetRelation: '+lstNetRelation);
                list<Network_Relationship__c> lstBizNetRelationShip = new list<Network_Relationship__c>();   
                list<Network_Relationship__c> lstBizNetRelationShipExist = new list<Network_Relationship__c>();    

                
                for(Network_Relationship__c net : lstNetRelation) {
                    // future
                    if(test.isRunningTest())
                        accTEMP.Vision_Care_End_Date__c=date.today().adddays(-5);
                    if(net.Program_Effective_Date__c > accTEMP.Vision_Care_End_Date__c){             
                        Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                        bizNetRelExist.Program_End_Date__c = accTEMP.Vision_Care_End_Date__c; //acc.Vision_Care_End_Date__c           
                        bizNetRelExist.Directory_End_Date__c = accTEMP.Vision_Care_End_Date__c; //acc.Vision_Care_End_Date__c
                        bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                        lstBizNetRelationShipExist.add(bizNetRelExist);
                    }
                    if(test.isRunningTest())
                        lstBizNetRelationShipExist.clear();
                    
                    //if(net.Program_Effective_Date__c > system.today() && net.Program_End_Date__c != NULL){            
                        // DO NOTHING
                    //}
                    

                    if(net.Program_Effective_Date__c <= system.today() && net.Program_End_Date__c != NULL && net.Program_End_Date__c > accTEMP.Vision_Care_End_Date__c){
                        Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                        bizNetRelExist.Program_End_Date__c = accTEMP.Vision_Care_End_Date__c;        
                        bizNetRelExist.Directory_End_Date__c = accTEMP.Vision_Care_End_Date__c; 
                        bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                        lstBizNetRelationShipExist.add(bizNetRelExist);

                        Network_Relationship__c bizNetRel = new Network_Relationship__c();
                        bizNetRel.Contact_Role__c = net.Contact_Role__c;
                        bizNetRel.Account_Name__c = net.Account_Name__c;
                        bizNetRel.Program_ID__c = net.Program_ID__c;         
                        bizNetRel.Program_Effective_Date__c = acc.Vision_Care_Effective_Date__c;
                        bizNetRel.Program_End_Date__c = acc.Vision_Care_End_Date__c; 
                        bizNetRel.Directory_End_Date__c = acc.Vision_Care_End_Date__c; 
                        bizNetRel.Provider_Name__c = net.Provider_Name__c;
                        bizNetRel.Vision_Care_Location_Key__c = lbaMap.get(net.Account_Name__c);
                        bizNetRel.Fee_Code__c = net.Fee_Code__c;
                        bizNetRel.LVC_Negotiated_Discount__c = net.LVC_Negotiated_Discount__c;
                        bizNetRel.Bypass_VC_Validation_Rules__c = true;
                        lstBizNetRelationShip.add(bizNetRel);
                        if(test.isRunningTest())
                            lstBizNetRelationShip.clear();
                    }
                    if(net.Program_Effective_Date__c <= system.today() && net.Program_End_Date__c == NULL) {
                        Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                        bizNetRelExist.Program_End_Date__c = accTEMP.Vision_Care_End_Date__c;        
                        bizNetRelExist.Directory_End_Date__c = accTEMP.Vision_Care_End_Date__c; 
                        bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                        lstBizNetRelationShipExist.add(bizNetRelExist);

                        Network_Relationship__c bizNetRel = new Network_Relationship__c();
                        bizNetRel.Contact_Role__c = net.Contact_Role__c;
                        bizNetRel.Account_Name__c = net.Account_Name__c;
                        bizNetRel.Program_ID__c = net.Program_ID__c;         
                        bizNetRel.Program_Effective_Date__c = acc.Vision_Care_Effective_Date__c;
                        bizNetRel.Program_End_Date__c = acc.Vision_Care_End_Date__c; 
                        bizNetRel.Directory_End_Date__c = acc.Vision_Care_End_Date__c; 
                        bizNetRel.Provider_Name__c = net.Provider_Name__c;
                        bizNetRel.Vision_Care_Location_Key__c = lbaMap.get(net.Account_Name__c);
                        bizNetRel.Fee_Code__c = net.Fee_Code__c;
                        bizNetRel.LVC_Negotiated_Discount__c = net.LVC_Negotiated_Discount__c;
                        bizNetRel.Bypass_VC_Validation_Rules__c = true;
                        lstBizNetRelationShip.add(bizNetRel);
                    }
                }
                
                //system.debug('exisingAccount.Vision_Care_Effective_Date__c: '+exisingAccount.Vision_Care_Effective_Date__c);
                //system.debug('exisingAccount.Vision_Care_End_Date__c: '+exisingAccount.Vision_Care_End_Date__c);
                //
                //for(Network_Relationship__c net : lstNetRelation) {
                //    if(exisingAccount.Vision_Care_Effective_Date__c <= system.today()){    
                //        Network_Relationship__c bizNetRel = new Network_Relationship__c();
                //        bizNetRel.Contact_Role__c = net.Contact_Role__c;
                //        bizNetRel.Account_Name__c = net.Account_Name__c;
                //        bizNetRel.Program_ID__c = net.Program_ID__c;         
                //        bizNetRel.Program_Effective_Date__c = acc.Vision_Care_Effective_Date__c;
                //        bizNetRel.Program_End_Date__c = acc.Vision_Care_End_Date__c; 
                //        bizNetRel.Directory_End_Date__c = acc.Vision_Care_End_Date__c; 
                //        bizNetRel.Provider_Name__c = net.Provider_Name__c;
                //        bizNetRel.Vision_Care_Location_Key__c = lbaMap.get(net.Account_Name__c);
                //        bizNetRel.Fee_Code__c = net.Fee_Code__c;
                //        bizNetRel.LVC_Negotiated_Discount__c = net.LVC_Negotiated_Discount__c;
                //        bizNetRel.Bypass_VC_Validation_Rules__c = true;
                //        lstBizNetRelationShip.add(bizNetRel);
                //    }
                //}
                //system.debug('lstBizNetRelationShip: '+lstBizNetRelationShip);
                

                if(!lstBizNetRelationShipExist.isEmpty()) { 
                    lstBizNetRelationShip.addAll(lstBizNetRelationShipExist); 
                } 
                if(!lstBizNetRelationShip.isEmpty()) { 
                    upsert lstBizNetRelationShip;                      
                } 
                *******/   
            }

            exisingAccount.Previous_IRS_Tax_ID__c=exisingAccount.IRS_Tax_ID__c;
            exisingAccount.Vision_Care_Effective_Date__c=acc.Vision_Care_Effective_Date__c;
            exisingAccount.Vision_Care_End_Date__c=acc.Vision_Care_End_Date__c;            
            exisingAccount.IRS_Tax_ID__c=acc.Tax_ID__c;
            exisingAccount.BillingCity=acc.BillingCity;
            exisingAccount.BillingState=acc.BillingState;
            exisingAccount.BillingStreet=acc.BillingStreet;
            exisingAccount.BillingPostalCode =acc.BillingPostalCode ;
            exisingAccount.IRS_Name__c = acc.IRS_Name__c;
            exisingAccount.Practice_Business_Type__c = acc.Practice_Business_Type__c;
            exisingAccount.Bypass_VC_Validation_Rules__c = true;
            exisingAccount.Billing_Address_Validation_Status__c = '';
            exisingAccount.Billing_Address_Validation_Timestamp__c=null;
            //update exisingAccount;

            system.debug('++++++++++++++++++++++++  salesForceProviderId ++++++++++++++++++++++++++++++++++++' +exisingAccount.Id);
            system.debug('++++++++++++++++++++++++  newTaxIdEffectiveDate ++++++++++++++++++++++++++++++++++++' +exisingAccount.Vision_Care_Effective_Date__c);
            system.debug('++++++++++++++++++++++++  oldTaxIdLimitDate ++++++++++++++++++++++++++++++++++++' +tih.End_Date__c);
            system.debug('++++++++++++++++++++++++  userId ++++++++++++++++++++++++++++++++++++' +UserInfo.getUserId());
            Id userId = UserInfo.getUserId();

            DateTime dtNewTaxIDEffDt = (DateTime)exisingAccount.Vision_Care_Effective_Date__c + 1;
            DateTime dtOldTaxIDLmtDt = (DateTime)tih.End_Date__c + 1;
            String newTaxIdEffDt = dtNewTaxIDEffDt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');       
            String oldTaxIdLmtDt = dtOldTaxIDLmtDt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSS');
            system.debug('++++++++++++++++++++++++  newTaxIdEffectiveDate after formatting++++++++++++++++++++++++++++++++++++' +newTaxIdEffDt);
            system.debug('++++++++++++++++++++++++  oldTaxIdLmtDt after formatting++++++++++++++++++++++++++++++++++++' +oldTaxIdLmtDt);

            User u = [Select CommunityNickname from User where id = :userId];
            system.debug('++++++++++++++++++++++++  CommunityNickname ++++++++++++++++++++++++++++++++++++' +u.CommunityNickname);

            updateBizAccount.add(exisingAccount);           

            if(!updateBizAccount.isEmpty()) {
                upsert updateBizAccount;   
            }
            executeWebService(exisingAccount.Id, newTaxIdEffDt, oldTaxIdLmtDt, u.CommunityNickname);
            return new pagereference('/'+exisingAccount.id);
        }catch(Exception e){ 
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getmessage())); 
        }
        return null;
    }
    
    public static Boolean runningInSandbox(){
        return [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    }
    
    @future(callout=true)
    public static void executeWebService(Id acctId, String effDt, String lmtDt, String fedId){

        system.debug('+++++++++++++++  ENTERED  executeWebService ++++++++++++++++++++++++++++++');
        system.debug('++++++++++++++++ EndPoint Sandbox +++++++++++++++++++++++++++++' +DVIWebService__c.getInstance('Fee_Web').EndPoint_Sandbox__c);
        system.debug('++++++++++++++++ EndPoint Production ++++++++++++++++++++++++++' +DVIWebService__c.getInstance('Fee_Web').Prod_Org_ID__c);
        system.debug('++++++++++++++++ IsSandbox ++++++++++++++++++++++++++++++++++++' + runningInSandbox());
        
        system.debug('++++++++++++++++++++ acctId ++++++++++++++++++++++++++++++++++++++' +acctId);
        system.debug('++++++++++++++++++++ effDt ++++++++++++++++++++++++++++++++++++++' +effDt);
        system.debug('++++++++++++++++++++ lmtDt ++++++++++++++++++++++++++++++++++++++' +lmtDt);
        system.debug('++++++++++++++++++++ fedId ++++++++++++++++++++++++++++++++++++++' +fedId);
        
        String clientSecret;
        String feeAuthEndPoint; 
        String feeEndPoint;
        
        if(runningInSandbox()){
            clientSecret = DVIWebService__c.getInstance('Fee_Web').Fee_Token_Header_Sandbox__c; 
            feeAuthEndPoint = DVIWebService__c.getInstance('Fee_Web').EndPoint_Sandbox__c + '/as/token.oauth2';
            feeEndPoint = DVIWebService__c.getInstance('Fee_Web').EndPoint_Sandbox__c + '/fee-web/feeschedulebatch/copyrequest';
        }
        else{
            clientSecret = DVIWebService__c.getInstance('Fee_Web').Fee_Token_Header_Production__c; 
            feeAuthEndPoint = DVIWebService__c.getInstance('Fee_Web').EndPoint_Production__c + '/as/token.oauth2';
            feeEndPoint = DVIWebService__c.getInstance('Fee_Web').EndPoint_Production__c + '/fee-web/feeschedulebatch/copyrequest';
        }
        
        HttpRequest oauthReq = new HttpRequest();
        String clientId = 'salesforce-fees-integration-api';
        String clientScope = 'write:vc.feebatch';
        String clientGrantType = 'client_credentials';
        String reqbody = 'grant_type='+EncodingUtil.urlEncode(clientGrantType, 'UTF-8')+'&client_id='+EncodingUtil.urlEncode(clientId, 'UTF-8')+
        '&client_secret='+EncodingUtil.urlEncode(clientSecret, 'UTF-8')+'&scope='+EncodingUtil.urlEncode(clientScope, 'UTF-8');

        oauthReq.setHeader('Content-Type','application/x-www-form-urlencoded');
        oauthReq.setBody(reqbody);
        oauthReq.setMethod('POST');
        oauthReq.setEndpoint(feeAuthEndPoint); 

        Http oauthHttp = new Http(); 
        HTTPResponse oauthResp = oauthHttp.send(oauthReq); 

        String oauthRespJSON=oauthResp.getBody();
        system.debug('++++++++++++++++++++++++++++++++++++++++++++++++++++++' +oauthRespJSON);

        String access_token = '';

        JSONParser parser=JSON.createParser(oauthRespJSON);
        while(parser.nextToken()!=null){
            if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                parser.nextToken();
                access_token+=parser.getText();
            }
        }
        system.debug('++++++++++++++++++++++++++++' +access_token);

        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject();      
        generator.writeStringField('salesForceProviderId', acctId);   
        generator.writeStringField('newTaxIdEffectiveDate', effDt);   
        generator.writeStringField('oldTaxIdLimitDate', lmtDt); 
        generator.writeStringField('userId', fedId);   
        generator.writeEndObject();    

        String strBody = generator.getAsString();
        system.debug('----------------------------------strBody---------------------------------------------------------------------' +strBody);

        HttpRequest req = new HttpRequest();    
        req.setEndpoint(feeEndPoint);   
        req.setMethod('PUT');
        req.setHeader('Content-Type','application/vnd.vsp.copyfeeschedule');
        String labHeaders = 'Bearer ' + access_token; 
        req.setHeader('Authorization', labHeaders); 
        req.setBody(strBody);

        req.setTimeout(2 * 60 * 1000);
        Http labHttp = new Http();     
        HTTPResponse labResp = labHttp.send(req);
        system.debug('----------------------------------labResp---------------------------------------------------------------------' +labResp.getBody());
    }
}