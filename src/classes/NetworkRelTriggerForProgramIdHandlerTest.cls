@isTest(SeeAllData=false)
private class NetworkRelTriggerForProgramIdHandlerTest{
    //@testSetup
    private static testmethod void setupTestData(){
        
        // get RecordType Name
        Id recType = [SELECT Id from RecordType WHERE sObjectType = 'Account' AND Name = 'Business Account'].Id; 
        
        //Create Account
        Account account_obj = new Account(Name = 'Name904', Status__c = 'New', Location_Type__c = 'M - VSP Member Location', RecordTypeId = recType);
        Insert account_obj; 
        
        Id ConRecType = [SELECT Id from RecordType WHERE sObjectType = 'Contact' AND Name = 'Eye Care Professional'].Id; 
        
        //Create Contact        
        Contact contact_obj = new Contact(AccountId = account_obj.id, LastName = 'LastName241', FirstName = 'First834', Doctor_Type__c = 'M - VSP Member Doctor', RecordTypeId = ConRecType);
        Insert contact_obj; 
        
        //Create 2 Contact Role
        Contact_Role__c cr_obj = new Contact_Role__c(Type__c = 'Doctor-Employee', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(+2), 
                                                     Account__c = account_obj.Id, Contact__c = contact_obj.Id, VSP_Network_Provider__c = true);
        Contact_Role__c cr_obj2 = new Contact_Role__c(Type__c = 'Doctor-Owner', Start_Date__c = date.today().adddays(-2), End_Date__c = date.today().adddays(+2), 
                                                      Account__c = account_obj.Id, Contact__c = contact_obj.Id, VSP_Network_Provider__c = true);
        insert cr_obj;
        insert cr_obj2;
        
        //Create Program
        General_Table__c gt_obj = new General_Table__c(Name = 'ADVTG', Code_Description__c = 'test5107', Table__c = 'PRSP', Status__c = 'Active');
        insert gt_obj;
        
        
        //Create 2 Network Relationship
        Network_Relationship__c nr_obj = new Network_Relationship__c(Contact_Role__c = cr_obj.Id, Account_Name__c = account_obj.id, Provider_Name__c = contact_obj.id, 
                                                                     Program_ID__c = gt_obj.Id, Program_Effective_Date__c = date.today().adddays(-2));
        test.startTest();
        insert nr_obj;
        test.stopTest();
        
        //System.debug(LoggingLevel.ERROR);
        NetworkRelTriggerForProgramIdHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj.id});
        //NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>{nr_obj.id});
        //System.debug(LoggingLevel.ERROR);
        
        
    }
    /*    static testMethod void test_applyActiveCostcoPIToNewDoctor_UseCase1(){
test.startTest();
List<Account> account_obj  =  [SELECT Name, Status__c from Account WHERE Name = 'Name904' AND Location_Type__c = 'M - VSP Member Location' LIMIT 1];
System.assertEquals(true,account_obj.size()>0);

//Account account_obj  =  [SELECT Name, Status__c from Account WHERE Name = 'Name904' AND Location_Type__c = 'M - VSP Member Location' LIMIT 1];
List<Contact> contact_obj  =  [SELECT AccountId, LastName, FirstName from Contact WHERE LastName = 'LastName241' AND FirstName = 'First834' AND Doctor_Type__c = 'M - VSP Member Doctor' LIMIT 1];
System.assertEquals(true,contact_obj.size()>0);
List<Contact_Role__c> cr_obj = [SELECT Account__c, Status_Formula__c FROM Contact_Role__c WHERE Type__c = 'Doctor-Employee' OR Type__c = 'Doctor-Owner' LIMIT 1];
System.assertEquals(true, cr_obj.size()>0);

NetworkRelationshipTriggerHandler obj01 = new NetworkRelationshipTriggerHandler();
NetworkRelationshipTriggerHandler.validate = false;
NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor_recursionX = false;
NetworkRelationshipTriggerHandler.applyActiveCostcoPIToNewDoctor(new set<id>());
test.stopTest();        
}
*/    
}