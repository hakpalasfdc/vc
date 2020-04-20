@isTest(SeeAllData=false)
private class NetworkRelationshipTriggerHandlerTest{

    private static testMethod void setupTestData(){
        
         Id BusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        	        
        //Create Account
        Account account_obj = new Account (Name ='Name904', Status__c = 'New',Location_Type__c = 'A - Affiliate Provider Location', RecordTypeId = BusRecordTypeId);
        Insert account_obj; 
        
        Id ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();  
        
        //Create Contact        
        Contact contact_obj = new Contact
               
        (AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'A - Affiliate Provider', RecordTypeId = ConRecordTypeId);
        Insert contact_obj; 
        
        //Create 2 Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id);

        insert cr_obj;

        
        //Create 2 Program
        General_Table__c gt_obj = new General_Table__c(Name = 'COSTA', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        General_Table__c gt_obj2 = new General_Table__c(Name = 'COSTQ', Code_Description__c = 'test51071', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        insert gt_obj2;
        
        //Create 2 Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Contact_Role__c = cr_obj.Id, Account_Name__c = account_obj.id, Provider_Name__c = contact_obj.id, 
                                                                     Program_ID__c = gt_obj.Id, Program_Effective_Date__c = date.today().adddays(-2));
        Network_Relationship__c nr_obj2 = new Network_Relationship__c(Contact_Role__c = cr_obj.Id, Account_Name__c = account_obj.id, Provider_Name__c = contact_obj.id, 
                                                                      Program_ID__c = gt_obj2.Id, Program_Effective_Date__c = date.today().adddays(-2));
        test.startTest();  
        insert nr_obj;
        insert nr_obj2;
        test.stopTest();
        

        NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj.id});
        

        NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj2.id});

        
        
    }
    
    private static testMethod void setupTestData2(){
        
                 Id BusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

        
        //Create Account
        Account account_obj = new Account(Name = 'Name904', Status__c = 'New', Location_Type__c = 'A - Affiliate Provider Location', RecordTypeId = BusRecordTypeId);
        Insert account_obj; 
        
                Id ConRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();  

        //Create Contact        
        Contact contact_obj = new Contact(AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'A - Affiliate Provider', RecordTypeId = ConRecordTypeId);
        Insert contact_obj; 
        
         Contact contact_obj2 = new Contact(AccountId = account_obj.id, LastName = 'LastName2412', FirstName = 'First8342', Doctor_Type__c = 'A - Affiliate Provider', RecordTypeId = ConRecordTypeId);
        Insert contact_obj2; 
        
        //Create 2 Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id);
        insert cr_obj;
         //Create 2 Contact Role
        Contact_Role__c cr_obj2 = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(30), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj2.Id);

        insert cr_obj2;

        
        //Create 2 Program
        General_Table__c gt_obj = new General_Table__c(Name = 'COSTA', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        General_Table__c gt_obj2 = new General_Table__c(Name = 'COSTQ', Code_Description__c = 'test51071', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        insert gt_obj2;
        
        //Create 2 Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Contact_Role__c = cr_obj.Id, Account_Name__c = account_obj.id, Provider_Name__c = contact_obj.id, 
                                                                     Program_ID__c = gt_obj.Id, Program_Effective_Date__c = date.today().adddays(-2));
        Network_Relationship__c nr_obj2 = new Network_Relationship__c(Contact_Role__c = cr_obj2.Id, Account_Name__c = account_obj.id, Provider_Name__c = contact_obj.id, 
                                                                      Program_ID__c = gt_obj2.Id, Program_Effective_Date__c = date.today().adddays(-2));
        test.startTest();  
        insert nr_obj;
        insert nr_obj2;
        test.stopTest();
        

        NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj.id});
        

        NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj2.id});

        
        
    }
}