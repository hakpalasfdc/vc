@isTest
public class VSPR1_ContactDML_Test {
    
    static testmethod void runClass(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test Account';
        acc.RecordTypeId = accRecordTypeId;
        insert acc;
        
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Client').getRecordTypeId();
        Contact con = new Contact();
        con.FirstName = 'Test First';
        con.LastName = 'Test Last';
        con.RecordTypeId = conRecordTypeId;
        con.AccountId = acc.Id;
        insert con;
        
        Set<Id> conIdSet = new Set<Id>();
        conIdSet.add(con.Id);
        
        List<Contact> con1 =  VSPR1_ContactDML.getContactDetails(conIdSet);
        
        system.assertNotEquals(null,con1);
        
    }
}