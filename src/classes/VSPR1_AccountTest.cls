/** 
     * Class Name: VSPR1_AccountTest
     * @author: karl.wilson.l.tan
     * Date: 12.JUL.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR1_Account class.  
     */
@isTest

public with sharing class VSPR1_AccountTest {
    static testMethod void submitApprovalRequest() {
        // Insert an account
        
      RecordType rType = [Select id from RecordType where Name =: 'Pending Account'];
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
    
    update a;   
       
        //Approval.ProcessSubmitRequest reqApp = new Approval.ProcessSubmitRequest();
        //reqApp.setComments('Submitting request for approval.');
        //reqApp.setObjectId(a.id);
        
      
       //Approval.ProcessResult result = Approval.process(reqApp);
        
        
        
    
    }
}