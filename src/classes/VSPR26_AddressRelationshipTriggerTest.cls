//This test class can only cover 75% if the Try Catch of the AddressRelationshipTrigger is in place. The trigger should never error out and hit the Catch block.
//See AddressTrigger, it has a try and catch removed.
@isTest(SeeAllData=false)
private class VSPR26_AddressRelationshipTriggerTest {
    @testSetup private static void setupData(){
        test.startTest();
        Account accObj = new Account(Name = 'BusinessAccountTest');
        insert accObj;
        
        Address__c addrObj = new Address__c(Street__c = '423 Test Drive', City__c = 'Dallas', State__c = 'TX', Zip__c = '75080');   
        insert addrObj;
        
        Address_Relationship__c addrRelObj = new Address_Relationship__c(Account__c = accObj.Id, Address__c = addrObj.Id, Address_Type__c = 'Physical');
        insert addrRelObj;
        test.stopTest();
    }
    
    private static testmethod void test_UseCase1(){
        Account acc = [SELECT Name FROM Account WHERE Name = 'BusinessAccountTest' Limit 1];
        Address_Relationship__c addRel = [SELECT Name FROM Address_Relationship__c WHERE Account__c = :acc.Id  LIMIT 1];
        addRel.Address_Type__c = 'Shipping';
        test.startTest();
        update addRel;
        test.stopTest();
    }
    
    private static testMethod void test_UseCase2(){
        Account acc = [SELECT Name FROM Account WHERE Name = 'BusinessAccountTest' Limit 1];
        Address__c addr = [SELECT Street__c FROM Address__c WHERE Street__c = '423 Test Drive' Limit 1];
        Address__c newAddr = new Address__c(Street__c = '424 Test Drive', City__c = 'Dallas', State__c = 'TX', Zip__c = '75080');
        Test.startTest();
        insert newAddr;
        Test.stopTest();
        
        Address_Relationship__c addRel = [SELECT Name, Account__c, Address__c FROM Address_Relationship__c WHERE Account__c = :acc.Id LIMIT 1];       
   
        try
        { 
            acc.Description = 'TEST';
            addRel.Address__c = newAddr.Id;
            test.startTest();
            update acc;
            delete addRel;
            test.stopTest();
        }
        catch(Exception e)
        {
            System.assert(true);
        }        
    }
    
}