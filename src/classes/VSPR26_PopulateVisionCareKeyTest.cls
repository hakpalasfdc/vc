@isTest(SeeAllData=false)
private class VSPR26_PopulateVisionCareKeyTest {
    //static Id PracticeId;
    @testSetup private static void setupData(){ 
        test.startTest();
        Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
        Account pracc1= new Account();
        pracc1.Name='Practice Account Name1';
        pracc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        pracc1.Tax_ID__c = '123456789';
        pracc1.Phone = '1234567890';
        pracc1.ShippingStreet = '123456 Test Streetssssssssssssssssss';
        pracc1.ShippingCity = 'Somewhere';
        pracc1.ShippingState = 'CA';
        pracc1.ShippingPostalCode = '90210';
        pracc1.ShippingCountry = 'USA';
        pracc1.Practice_Business_Type__c = 'S - Sole Proprietor';
        pracc1.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
        pracc1.Payment_Method__c = 'Direct Deposit';
        pracc1.Payment_Distribution__c = 'Practice Account';
        pracc1.Vision_Care_Effective_Date__c = system.today();
        pracc1.Vision_Care_Location_Key__c = '123456789101112';
        pracc1.IRS_Tax_ID__c = '123456789';
        pracc1.RecordTypeId =  practiceRecordTypeId;
        
        insert pracc1;
        //   PracticeId = acc.Id;
        
        Account pracc2= new Account();
        pracc2.Name='Practice Account Name2';
        pracc2.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        pracc2.Tax_ID__c = '123456789';
        pracc2.Phone = '1234567890';
        pracc2.ShippingStreet = '123456 Test Streetssssssssssssssssss';
        pracc2.ShippingCity = 'Somewhere';
        pracc2.ShippingState = 'CA';
        pracc2.ShippingPostalCode = '90210';
        pracc2.ShippingCountry = 'USA';
        pracc2.Practice_Business_Type__c = 'S - Sole Proprietor';
        pracc2.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
        pracc2.Payment_Method__c = 'Direct Deposit';
        pracc2.Payment_Distribution__c = 'Practice Account';
        pracc2.Vision_Care_Effective_Date__c = system.today();
        pracc2.Vision_Care_Location_Key__c = '123456789101112';
        pracc2.IRS_Tax_ID__c = '123456789';
        pracc2.RecordTypeId =  practiceRecordTypeId; 
        
        insert pracc2;
        
        Account acc1= new Account();
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        acc1.Name='Business Account Name';       
        acc1.ParentId = pracc1.id;
        acc1.Fax = '123456789';
        acc1.ShippingStreet = '123 Test Street';
        acc1.ShippingCity = 'Somewhere';
        acc1.ShippingState = 'CA';
        acc1.ShippingPostalCode = '90210';
        acc1.ShippingCountry = 'USA';
        acc1.Vision_Care_Location_Phone_Number__c = '123456789';
        acc1.Eyefinity_Access__c = 'B - Basic';
        acc1.Location_Type__c = 'A - Affiliate Provider Location';
        acc1.Tax_ID__c = '123456789';
        acc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        acc1.Vision_Care_End_Date__c = System.today() + 3;
        acc1.Products_and_Assets__c = 'Level';
        acc1.RecordTypeId =  businessRecordTypeId; 
        
        insert acc1;
        
        Account acc2= new Account();
        acc2.Name='BA Account';       
        acc2.ParentId = pracc1.id;
        acc2.Fax = '123456789';
        acc2.ShippingStreet = '32343 Test Street';
        acc2.ShippingCity = 'Nowhere';
        acc2.ShippingState = 'ND';
        acc2.ShippingPostalCode = '58072';
        acc2.ShippingCountry = 'USA';
        acc2.Vision_Care_Location_Phone_Number__c = '5556667777';
        acc2.Eyefinity_Access__c = 'B - Basic';
        acc2.Location_Type__c = 'A - Affiliate Provider Location';
        acc2.Tax_ID__c = '123456789';
        acc2.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        acc2.Vision_Care_End_Date__c = System.today() + 3;
        acc2.Products_and_Assets__c = 'Level';
        acc2.RecordTypeId =  businessRecordTypeId; 
        acc2.Vision_Care_Location_Key__c = '1234567891234,123';
        
        insert acc2;
        test.stopTest();
    }
    
    private static testmethod void testUpdateAccTypewithEndDate() { 
        
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
        
        Account pracAcc1 = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c from Account WHERE RecordTypeId = :practiceRecordTypeId
                            // AND ParentId != null
                            AND Vision_Care_Effective_Date__c != null 
                            AND Name = 'Practice Account Name1'LIMIT 1];
        //AND Vision_Care_Location_Key__c = null LIMIT 1]; 
        
        Account pracAcc2 = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c from Account WHERE RecordTypeId = :practiceRecordTypeId
                            
                            AND Vision_Care_Effective_Date__c != null
                            AND Name = 'Practice Account Name2' LIMIT 1];       
        pracAcc1.ShippingStreet = '123456 Main Stssssssssssss';
        pracAcc1.RecordTypeId = businessRecordTypeId;
        pracAcc1.Vision_Care_Location_Key__c = null;
        pracAcc1.ParentId = pracAcc2.Id;
        test.startTest();
        update pracAcc1;
        test.stopTest();
        
    }
    
    private static testmethod void testInsertBaAccType() { 
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
        Account praAcc = [SELECT Id, Name FROM Account WHERE Name = 'Practice Account Name1' AND RecordTypeId = :practiceRecordTypeId LIMIT 1];
        
        Account acc2= new Account();
        acc2.Name='BA Account';       
        acc2.ParentId = praAcc.id;
        acc2.Fax = '123456789';
        acc2.ShippingStreet = '12345 Test Street';
        acc2.ShippingCity = 'Nowhere';
        acc2.ShippingState = 'ND';
        acc2.ShippingPostalCode = '58072';
        acc2.ShippingCountry = 'USA';
        acc2.Vision_Care_Location_Phone_Number__c = '5556667777';
        acc2.Eyefinity_Access__c = 'B - Basic';
        acc2.Location_Type__c = 'A - Affiliate Provider Location';
        acc2.Tax_ID__c = '123456789';
        acc2.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        acc2.Vision_Care_End_Date__c = System.today() + 3;
        acc2.Products_and_Assets__c = 'Level';
        acc2.RecordTypeId =  businessRecordTypeId; 
        //acc2.Vision_Care_Location_Key__c = '1234567891234';
        test.startTest();
        insert acc2;
        test.stopTest();
    }
}