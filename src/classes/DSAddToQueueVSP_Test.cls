@isTest
private class DSAddToQueueVSP_Test
{
    @isTest static void testCallout1() 
    {
        // Set mock callout class 
       // Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator2());
        
        string res = DSAddToQueueVSP.httpPOSTrecord('http://api.salesforce.com/foo/bar', '', '');   
    }
    
    @isTest static void testCallout2() 
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        
        Account testAccount = new Account (
            Name = 'Test',
            Phone = '5106480346'
        ); 
        
        insert testAccount; 
        
        Contact testContact = new Contact (
            LastName = 'Test',
            Account = testAccount
        );
        
        insert testContact; 
        
        Contact_Role__c testContactRole = new Contact_Role__c(
            Type__c = 'Test',
            Contact__c = testContact.Id, 
            Account__c = testAccount.Id,
            Contact_Role_Phone__c =  '5106480346'
        ); 
        
        insert testContactRole; 
        System.debug('Role Phone: ' + testContactRole.Contact_Role_Phone__c);
        
        User testUser = [SELECT Id FROM User WHERE IsActive = True LIMIT 1];
        
        String contactRoleId = '' + testContactRole.Id;
        String acctId = '' + testAccount.Id;  
        String userId = '' + testUser.Id; 
        
        System.debug(contactRoleId);
        
        //Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator3());
        string res2 = DSAddToQueueVSP.httpPOSTlist('Contact_Role_Phone__c', 'Account__c, Contact__c', contactRoleId, 'Contact_Role__c', testUser.Id, acctId);
    }
}