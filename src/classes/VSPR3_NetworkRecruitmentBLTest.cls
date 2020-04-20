/** 
     * Class Name: VSPR3_NetworkRecruitmentBLTest
     * @author: karl.wilson.l.tan
     * Date: 10.OCT.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for Network Recruitment classes.  
     */
@isTest

public with sharing class VSPR3_NetworkRecruitmentBLTest {
    static testMethod void createNetRecTest() {
        // Insert an account
        
      RecordType rType = [Select id from RecordType where Name =: 'Pending Account'];
      //User us = [Select id, UserRole.Name from User where Name =: 'VSPOne - Columbus'];
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
    //c.Doctor_ID__c = '555555555';
    c.CAQH_ID__c = '1111';
    insert c;
    
    
    Contact_Role__c cRole = new Contact_Role__c();
    cRole.Account__c = a.id;
    cRole.Contact__c = c.id;
    cRole.Type__c = 'Accounting';
    c.Birthdate__c = system.today();
    
    insert cRole;
    
    
    Network_Recruitment__c netRec = new Network_Recruitment__c();
    netRec.Contact_Role__c = cRole.id;
    netRec.Recruitment_Status__c = 'Completed';
    
    insert netRec;
    
    Network_Recruitment__c netRecr = new Network_Recruitment__c();
    netRecr.Contact_Role__c = cRole.id;
    netRecr.Recruitment_Status__c = 'New Lead';
    
    insert netRecr;
    
    update c;
    
    delete netRec;
    
    update c;
    

       

        
        
    
    }
}