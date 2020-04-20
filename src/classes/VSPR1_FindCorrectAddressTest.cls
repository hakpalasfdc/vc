/** 
     * Class Name: VSPR1_FindCorrectAddressTest
     * @author: karl.wilson.l.tan
     * Date: 17.JUL.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR1_FindCorrectAddress class.  
     */
@isTest

public with sharing class VSPR1_FindCorrectAddressTest {
  
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
    aD.County__c = 'Sacramento';
    aD.Country__c = 'US';
    aD.Zip__c = '12345-6789';
    
    
    aD.LM_MASTER_SKEY__c='123456';//Shravani on 07/15/2014
    
    
    //aDList.add(aD);
    
    insert aD;
    
    Address__c aD1 = new Address__c();
    //aD1.Address_Type__c = 'Physical';
    aD1.Street__c = 'Tamaraw';
    aD1.City__c = 'Kornak';
    aD1.State__c = 'PL';
    aD.County__c = 'Sacramento';
    aD1.Country__c = 'US';
    aD1.Zip__c = '12345-6789';
    
    
    aD.LM_MASTER_SKEY__c='123456';//Shravani on 07/15/2014
    
    
    insert aD1;
    
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
    aRel.End_Date__c = system.today();
    aRel.Address_Type__c = 'Physical';
    try{
    insert aRel;
    update aRel;
    }catch(Exception e){}
    //update acc;
    //aD.Address_Type__c = 'Billing';
    //update aD;
    //aRel.Status__c = 'I';
    //update aRel;
    //update acc;
    //update acc;
    
    Address_Relationship__c aRel1 = new Address_Relationship__c();
    //aRel.Account__c = accList[0].id;
    aRel1.Account__c = acc.id;
    //aRel.Address__c = aDList[0].id;
    aRel1.Address__c = aD1.id;
    //aRel1.Status__c = 'A';
    aRel1.Start_Date__c = system.today()-2;
    aRel1.End_Date__c = system.today()-1;
    aRel1.Address_Type__c = 'Physical';
    insert aRel1;
    
    //aRel.Status__c = 'I';

    //below startTest added by Vikhyat on 08/28/2019
    Test.startTest();
    update acc;
    
    //aRel1.Status__c = 'I';
    update aRel1;
    
    //update acc;
    
    
    //aRel1.Account__c = acc.id;
    //aRel.Address__c = aDList[0].id;
   // aRel1.Address__c = aD1.id;
    //aRel1.Status__c = 'A';
    aRel1.Start_Date__c = system.today()-2;
    aRel1.End_Date__c = system.today()-1;
    update aRel1;
  
   update acc;
   
   Account acc2 = new Account();
      acc2.Name = 'Test1 Account';
      acc2.Status__c = 'New';
    
      //accList.add(acc);
   // }
    insert acc2;
    
    Address_Relationship__c aRel2 = new Address_Relationship__c();
    //aRel.Account__c = accList[0].id;
    aRel2.Account__c = acc2.Id;
    //aRel.Address__c = aDList[0].id;
    aRel2.Address__c = aD1.id;
    //aRel1.Status__c = 'A';
    aRel2.Start_Date__c = system.today()-2;
    aRel2.End_Date__c = system.today()-1;
    aRel2.Address_Type__c = 'Physical';
    insert aRel2;
    
    update aRel2;
    
    update acc2;
    //update aD;
    
    //Below stopTest added by Vikhyat on 08/28/2019
    Test.stopTest();
    }
}