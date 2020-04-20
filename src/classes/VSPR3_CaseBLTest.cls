/** 
     * Class Name: VSPR3_CaseBLTest
     * @author: karl.wilson.l.tan
     * Date: 10.OCT.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR3_CaseBL class.  
     */
@istest(seealldata=true)
public with sharing class VSPR3_CaseBLTest {
    static testMethod void createCaseTest() {
        // Insert an account
        
      RecordType rType = [Select id from RecordType where Name =: 'Pending Account'];
      UserRole usRole = [Select id, Name from UserRole where Name =: 'VSPOne - Columbus'];
      Profile profile = [Select id from Profile where Name =: 'System Administrator'];
      
      
      
      Account a = new Account();
      a.Name = 'Test Sample';
      a.Status__c = 'New';
      insert a;
      
    Contact c = new Contact();
    c.AccountId = a.id;
    c.LastName = 'Sample Contact';
    c.Status__c = 'Active';
    c.Birthdate__c = system.today();
    c.Marketing_Name__c = 'lRak';
    insert c;
    
    
    Contact_Role__c cRole = new Contact_Role__c();
    cRole.Account__c = a.id;
    cRole.Contact__c = c.id;
    cRole.Type__c = 'Accounting';
    c.Birthdate__c = system.today();
    
    insert cRole;
    
    
    Case cases = new Case();
    cases.Description = 'Sample Description';
    cases.Contact_Role__c = cRole.id;
    cases.Line_of_Business__c = 'Altair';
    cases.Priority = 'Minor';
    cases.Status = 'New';
    cases.Origin = 'Altair';
    cases.Subject = 'Sample Subject';
    cases.Type = 'Issue';
    cases.Product__c = 'N/A';
    cases.Classification__c = 'Status';
    
    
    insert cases;
    
       
       

        
        
    
    }
}