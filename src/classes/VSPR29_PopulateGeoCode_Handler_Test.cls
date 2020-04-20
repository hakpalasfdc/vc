@isTest
public class VSPR29_PopulateGeoCode_Handler_Test {
//test class for VSPR19b_PopulateGeoCode_Handler

    static testmethod void accPracInsert(){
      
        General_Table__c gt = new General_Table__c();
        gt.Table__c = 'CLM2305';
        gt.Status__c = 'Active';
        gt.Name = '95670';
        gt.Additional_Information__c = 'US';
        gt.Additional_Information_2__c = 'USA';
        gt.Code_Description__c = 'Desc';
        
        insert gt;
       
        
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
           
        
        //Create Account
        Account pracAcc = new Account();
        pracAcc.RecordTypeId = accRecordTypeId;
        pracAcc.Name = 'Practice Account';
        pracAcc.ShippingStreet = '123 Main Ave';
        pracAcc.ShippingCity = 'SomeWhere';
        pracAcc.ShippingState = 'CA';
        pracAcc.ShippingPostalCode = '95670';
        test.startTest();
        insert pracAcc;
        test.stopTest();
    }
    
    
    
    static testmethod  void accBusInsert(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        General_Table__c gt = new General_Table__c();
        gt.Table__c = 'CLM2305';
        gt.Status__c = 'Active';
        gt.Name = '95670';
        gt.Additional_Information__c = 'US';
        gt.Additional_Information_2__c = 'USA';
        gt.Code_Description__c = 'Desc';
        
        insert gt;
        
        //Create Account
        Account busAcc = new Account();
        busAcc.RecordTypeId = accRecordTypeId;
        busAcc.Name = 'Business Account';
        busAcc.ShippingStreet = '123 Main Ave';
        busAcc.ShippingCity = 'SomeWhere';
        busAcc.ShippingState = 'CA';
        busAcc.ShippingPostalCode = '95670';
        test.startTest();
        insert busAcc;
        test.stopTest();
    }
    
     static testmethod  void accBusInsertNoGT(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
         
              General_Table__c gt = new General_Table__c();
        gt.Table__c = 'CLM2305';
        gt.Status__c = 'Active';
        gt.Name = '95670';
        gt.Additional_Information__c = 'US';
        gt.Additional_Information_2__c = 'USA';
        gt.Code_Description__c = 'Desc';
        
        insert gt;
               
        //Create Account
        Account busAcc = new Account();
        busAcc.RecordTypeId = accRecordTypeId;
        busAcc.Name = 'Business Account';
        busAcc.ShippingStreet = '123 Main Ave';
        busAcc.ShippingCity = 'SomeWhere';
        busAcc.ShippingState = 'CA';
        busAcc.ShippingPostalCode = '58072';
        test.startTest();
        insert busAcc;
        test.stopTest();
    }
    
     static testmethod void accPracUpdate(){
       
       General_Table__c gt = new General_Table__c();
        gt.Table__c = 'CLM2305';
        gt.Status__c = 'Active';
        gt.Name = '95670';
        gt.Additional_Information__c = 'US';
        gt.Additional_Information_2__c = 'USA';
        gt.Code_Description__c = 'Desc';
        
        insert gt;
       
        
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
           
        
        //Create Account
        Account pracAcc = new Account();
        pracAcc.RecordTypeId = accRecordTypeId;
        pracAcc.Name = 'Practice Account';
        pracAcc.ShippingStreet = '123 Main Ave';
        pracAcc.ShippingCity = 'SomeWhere';
        pracAcc.ShippingState = 'CA';
        pracAcc.ShippingPostalCode = null;
        test.startTest();
        insert pracAcc;
         
         
        Account updAcc = [SELECT Id, ShippingPostalCode FROM Account Where Name = 'Practice Account'];
         updAcc.ShippingPostalCode = '95670';
         update updAcc;
        test.stopTest();
    }
}