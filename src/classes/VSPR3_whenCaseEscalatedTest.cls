/** 
     * Class Name: VSPR3_whenCaseEscalatedTest
     * @author: karl.wilson.l.tan
     * Date: 23.OCT.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for Case Escalation classes.  
     */
@isTest(seeAllData=true)

public with sharing class VSPR3_whenCaseEscalatedTest{
    static testMethod void createcaseTest() {
    
        // Insert a account, user, contact, contact role, case
        
      RecordType rType = [Select id from RecordType where Name =: 'Pending Account']; 
      Profile profile1 = [Select id from Profile where Name =: 'System Administrator'];
      
      //UserRole uRole = new UserRole();
      //uRole.Name = '';
      //insert uRole;
      
      //uRole1 = new UserRole();
      //uRole1.Name = 'VSPOne - Columbus';
      //insert uRole1;
       
 
      User u  = new User();        
      u.LastName = 'Test';
      u.Alias = 'Te00';
      u.Username = 'usname123@noemail.com';
      u.Email = 'sample@noemail.com';
      u.profileId = profile1.Id;   
      u.emailencodingkey = 'UTF-8';
      u.languagelocalekey = 'en_US';
      u.localesidkey = 'en_US';
      u.timezonesidkey = 'America/Los_Angeles';
      u.country = 'United States';
      //u.UserRole.Name = uRole.Name;
      
      insert u;
      
        
                       
      Profile profile2 = [select id from profile where name='Marketing User'];
                
      User u1 = new User();        
      u1.LastName = 'Test1';
      u1.Alias = 'Te11';
      u1.Username = 'usname1234@noemail.com';
      u1.Email = 'sample1@noemail.com';
      u1.profileId = profile2.Id;
      u1.emailencodingkey = 'UTF-8';
      u1.languagelocalekey = 'en_US';
      u1.localesidkey = 'en_US';
      u1.timezonesidkey = 'America/Los_Angeles';
      u1.country = 'United States';
      u1.ManagerId = u.Id;
      //u1.UserRole.Name = uRole1.Name;

      insert u1;

        
      //System.runAs ( u1 ) {     
      
      //QueueSobject myQ = [Select QueueId From QueueSobject where Queue.Name =:'Escalated Queue']; 
            
     // Group g1 = new Group(Name='Escalated Queue', type='Queue');      
     // insert g1;      
     // QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Case');      
     // insert q1;
      //}
                   
      
      
     
      
      List<Escalated_Queue_Name__c> EQName = new List<Escalated_Queue_Name__c>();
      for(integer i=0;i<2;i++){
          Escalated_Queue_Name__c e = new Escalated_Queue_Name__c();
          e.Escalated_Q_Name__c = 'Escalated Queue';
          e.Name = i + 'Sample Name';
          EQName.add(e);
      }
            
      insert EQName;
      


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
    cases.Origin = 'Email';
    cases.Subject = 'Sample Subject';
    cases.Type = 'Issue';
    cases.Product__c = 'N/A';
    cases.Classification__c = 'Status';
    cases.ownerId = u1.id;
    insert cases;
    
    cases.id = cases.id;
    cases.IsEscalated = true;
    cases.ownerId = u.id;
    
    update cases;
    
    
    cases.id = cases.id;
    cases.IsEscalated = false;
    cases.ownerId = u1.id;      
  
  
    update cases;
    
    }
}