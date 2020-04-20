@isTest
public class VSPR27_ContactRole_Dupe_Validation_Test {
    
    @TestSetup
    static void testDate(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account Acc1 = new Account();
        Acc1.Name='Practice Account Name1';
        Acc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        Acc1.Tax_ID__c = '123456789';
        Acc1.Phone = '1234567890';
        Acc1.ShippingStreet = '123456 Test Streetssssssssssssssssss';
        Acc1.ShippingCity = 'Somewhere';
        Acc1.ShippingState = 'CA';
        Acc1.ShippingPostalCode = '90210';
        Acc1.ShippingCountry = 'USA';
        Acc1.Practice_Business_Type__c = 'S - Sole Proprietor';
        Acc1.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
        Acc1.Payment_Method__c = 'Direct Deposit';
        Acc1.Payment_Distribution__c = 'Practice Account';
        Acc1.Vision_Care_Effective_Date__c = system.today();
        Acc1.Vision_Care_Location_Key__c = '123456789101112';
        Acc1.IRS_Tax_ID__c = '123456789';
        Acc1.RecordTypeId = accRecordTypeId;        
        insert Acc1;
        
        
        Contact con = new Contact();
        con.LastName='Con1';
        con.FirstName='Test1';
        con.NPI__c='9876543211';
        con.Vision_Care_Effective_Date__c = date.today().adddays(-30);
        con.Vision_Care_End_Date__c = date.today().adddays(+30);
        insert con;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = Acc1.Id;
        cr.Contact__c = con.Id;
        cr.Start_Date__c = Date.newInstance(2018, 09, 23);
        cr.Type__c = 'Doctor-Owner';
        insert cr;
    }
    private static testmethod void insertDupeConRole(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'Practice Account Name1' AND Tax_ID__c = '123456789' LIMIT 1];
        Contact con = [SELECT Id, FirstName, LastName, Doctor_ID__c, Vision_Care_End_Date__c FROM Contact WHERE LastName = 'Con1' AND NPI__c='9876543211' Limit 1];
        
        Contact_Role__c cr2 = new Contact_Role__c();
        cr2.Account__c = acc.Id;
        cr2.Contact__c = con.Id;
        cr2.Start_Date__c = Date.newInstance(2019, 01, 01);
        cr2.Type__c = 'Doctor-Owner';
        test.startTest();
        try{
            insert cr2;
        }
        catch(Exception e){
            System.assert(e.getMessage().contains('There is already a Contact Role for this Contact on this Account'));
        }
        test.stopTest();
    }
}