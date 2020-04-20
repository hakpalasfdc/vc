/** 
     * Class Name: VSPR1_AddressBLTest
     * @author: karl.wilson.l.tan
     * Date: 17.JUL.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR1_AddressBL class.  
     */
@isTest

public with sharing class VSPR1_AddressBLTest {
  
  public static testMethod void unitTestAddress1() {    
    
      //RecordType rType = [Select id from RecordType where Name =: 'Pending Account'];
      Profile profile = [Select id from Profile where Name =: 'System Administrator'];
      
      //List<Account> accList = new List<Account>();
      //for(integer i=0;i<2;i++){
      Account acc = new Account();
      acc.Name = 'Test1 Account';
      acc.Status__c = 'New';
       //accList.add(acc);
   // }
    insert acc;
    
    //List<Address__c> aDList = new List<Address__c>();
    //for(integer i=0;i<2;i++){
    Address__c aD = new Address__c();
    //aD.Address_Type__c = 'Physical';
    aD.Street__c = 'Tamaraw';
    aD.City__c = 'Kornak';
    aD.State__c = 'PL';
    aD.Country__c = 'US';
    aD.Zip__c = '12345-6789';
    //aDList.add(aD);
    
    insert aD;
    
    
    //List<Address_Relationship__c> aRelList = new List<Address_Relationship__c>();
    //for(integer i=0;i<2;i++){
    Address_Relationship__c aRel = new Address_Relationship__c();
    //aRel.Account__c = accList[0].id;
    aRel.Account__c = acc.id;
    //aRel.Address__c = aDList[0].id;
    aRel.Address__c = aD.id;
    //aRel.Status__c = 'A';
    aRel.Start_Date__c = system.today();
    //aRelList.add(aRel);
    //}
    insert aRel;
    update acc;
    //aD.Address_Type__c = 'Billing';
    update aD;
    update acc;
    }
}