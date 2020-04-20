//Test class for Batch_ChangeTaxIdNetRel.apxc
@isTest
private class VSPR29_Batch_ChangeTaxIdNetRel_Test {
    
    private static testMethod void nrTestBatch(){
        //Contact Role or NR needs DVI custom setting
        DVIWebService__c dviWeb = new DVIWebService__c(); 
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        Id artId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        //Create Account
        Account account_obj = new Account(Name = 'Name904', Status__c = 'New', Location_Type__c = 'A - Affiliate Provider Location', RecordTypeId = artId,
                                          Vision_Care_Effective_Date__c = date.today().adddays(-2), Vision_Care_End_Date__c = date.today().adddays(30));
        Insert account_obj; 
        
        //Create Contact        
        Contact contact_obj = new Contact(AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'A - Affiliate Provider');
        Insert contact_obj; 
        
        //Create Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id);
        
        insert cr_obj;
        
        //Create Program
        General_Table__c gt_obj = new General_Table__c(Name = 'TEST', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        
        //Create Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Program_ID__c = gt_obj.Id, Program_End_Date__c = date.today().adddays(10), Directory_End_Date__c = date.today().adddays(10), 
                                                                     Account_Name__c = account_obj.id, Contact_Role__c = cr_obj.Id, Provider_Name__c = contact_obj.id,
                                                                     Vision_Care_Location_Key__c = 'TEST01', Fee_Code__c = 'TS', LVC_Negotiated_Discount__c = 0,
                                                                     Program_Effective_Date__c = date.today().adddays(-2), Bypass_VC_Validation_Rules__c = false);
        System.debug('nr_obj + ' + nr_obj);
        
        Test.startTest();
        insert nr_obj;        
        
        System.debug('nr_obj select ' + [SELECT Id FROM Network_Relationship__c WHERE Account_Name__c = :account_obj.Id AND Fee_Code__c <> NULL]);
        
        //To test for when program end date is not null
        List<Account> ac = [SELECT Id, Name FROM Account WHERe Name = 'Name904' LIMIT 1];
        Map<String,String> lbamap = new Map<String,String>();
        lbamap.put('TEST02','TEST03');
        //End date
        Date dt = date.today().adddays(9);
        //Start Date
        Date stdt = date.today().adddays(-2);
        
        Batch_ChangeTaxIdNetRel BC = new Batch_ChangeTaxIdNetRel();
        BC.lstBusinessAccounts = ac;
        BC.accTEMP_Vision_Care_End_Date = dt;
        BC.lbaMap = lbamap;
        BC.acc_Vision_Care_Effective_Date = stdt;
        BC.acc_Vision_Care_End_Date = dt;
        Id batchId = Database.executeBatch(BC);
        Test.stopTest();
    }
    private static testMethod void nrtestBatch2(){
        
        //Contact Role or NR needs DVI custom setting
        DVIWebService__c dviWeb = new DVIWebService__c(); 
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        Id artId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        //Create Account
        Account account_obj = new Account(Name = 'Name904', Status__c = 'New', Location_Type__c = 'A - Affiliate Provider Location', RecordTypeId = artId,
                                          Vision_Care_Effective_Date__c = date.today().adddays(-2), Vision_Care_End_Date__c = date.today().adddays(30));
        Insert account_obj; 
        
        //Create Contact        
        Contact contact_obj = new Contact(AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'A - Affiliate Provider');
        Insert contact_obj; 
        
        //Create Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id);
        
        insert cr_obj;
        
        //Create Program
        General_Table__c gt_obj = new General_Table__c(Name = 'TEST', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        
        //Create Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Program_ID__c = gt_obj.Id, Program_End_Date__c = null, Directory_End_Date__c = date.today().adddays(10), 
                                                                     Account_Name__c = account_obj.id, Contact_Role__c = cr_obj.Id, Provider_Name__c = contact_obj.id,
                                                                     Vision_Care_Location_Key__c = 'TEST01', Fee_Code__c = 'TS', LVC_Negotiated_Discount__c = 0,
                                                                     Program_Effective_Date__c = date.today().adddays(2), Bypass_VC_Validation_Rules__c = false);
        System.debug('nr_obj + ' + nr_obj);
        
        Test.startTest();
        insert nr_obj;        
        
        System.debug('nr_obj select ' + [SELECT Id FROM Network_Relationship__c WHERE Account_Name__c = :account_obj.Id AND Fee_Code__c <> NULL]);
        
        //Testmethod to test for when program effective date > accTEMP_Vision_Care_End_Date
        List<Account> ac = [SELECT Id, Name FROM Account WHERe Name = 'Name904' LIMIT 1];
        Map<String,String> lbamap = new Map<String,String>();
        lbamap.put('TEST02','TEST03');
        //End date
        Date dt = date.today().adddays(-9);
        //Start Date
        Date stdt = date.today().adddays(-2);
        
        Batch_ChangeTaxIdNetRel BC = new Batch_ChangeTaxIdNetRel();
        BC.lstBusinessAccounts = ac;
        BC.accTEMP_Vision_Care_End_Date = dt;
        BC.lbaMap = lbamap;
        BC.acc_Vision_Care_Effective_Date = stdt;
        BC.acc_Vision_Care_End_Date = dt;
        Id batchId = Database.executeBatch(BC);
        Test.stopTest();
    }
        private static testMethod void nrtestBatch3(){
        
        //Contact Role or NR needs DVI custom setting
        DVIWebService__c dviWeb = new DVIWebService__c(); 
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        Id artId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        //Create Account
        Account account_obj = new Account(Name = 'Name904', Status__c = 'New', Location_Type__c = 'A - Affiliate Provider Location', RecordTypeId = artId,
                                          Vision_Care_Effective_Date__c = date.today().adddays(-2), Vision_Care_End_Date__c = date.today().adddays(30));
        Insert account_obj; 
        
        //Create Contact        
        Contact contact_obj = new Contact(AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'A - Affiliate Provider');
        Insert contact_obj; 
        
        //Create Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id);
        
        insert cr_obj;
        
        //Create Program
        General_Table__c gt_obj = new General_Table__c(Name = 'TEST', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        
        //Create Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Program_ID__c = gt_obj.Id, Program_End_Date__c = null, Directory_End_Date__c = date.today().adddays(10), 
                                                                     Account_Name__c = account_obj.id, Contact_Role__c = cr_obj.Id, Provider_Name__c = contact_obj.id,
                                                                     Vision_Care_Location_Key__c = 'TEST01', Fee_Code__c = 'TS', LVC_Negotiated_Discount__c = 0,
                                                                     Program_Effective_Date__c = date.today().adddays(-2), Bypass_VC_Validation_Rules__c = false);
        System.debug('nr_obj + ' + nr_obj);
        
        Test.startTest();
        insert nr_obj;        
        
        System.debug('nr_obj select ' + [SELECT Id FROM Network_Relationship__c WHERE Account_Name__c = :account_obj.Id AND Fee_Code__c <> NULL]);
        
        //Testmethod to test for when program effective date > accTEMP_Vision_Care_End_Date
        List<Account> ac = [SELECT Id, Name FROM Account WHERe Name = 'Name904' LIMIT 1];
        Map<String,String> lbamap = new Map<String,String>();
        lbamap.put('TEST02','TEST03');
        //End date
        Date dt = date.today().adddays(9);
        //Start Date
        Date stdt = date.today().adddays(-2);
        
        Batch_ChangeTaxIdNetRel BC = new Batch_ChangeTaxIdNetRel();
        BC.lstBusinessAccounts = ac;
        BC.accTEMP_Vision_Care_End_Date = dt;
        BC.lbaMap = lbamap;
        BC.acc_Vision_Care_Effective_Date = stdt;
        BC.acc_Vision_Care_End_Date = dt;
        Id batchId = Database.executeBatch(BC);
        Test.stopTest();
    }
}