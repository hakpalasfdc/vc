///Test Class for VSPR25_UpdatePracticeProdAssets
@isTest
public class VSPR25_UpdatePracticeProdAssets_Test {
 public static testmethod void testNewContactRole() { 
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Technical User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u){
            
            test.starttest();
            Account acc= new Account();
            acc.Name='Practice Account Name';
            acc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc.Tax_ID__c = '123456789';
            acc.Phone = '1234567890';
            acc.ShippingStreet = '123 Test Street';
            acc.ShippingCity = 'Somewhere';
            acc.ShippingState = 'CA';
            acc.ShippingPostalCode = '90210';
            acc.ShippingCountry = 'USA';
            acc.Practice_Business_Type__c = 'S - Sole Proprietor';
            acc.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
            acc.Payment_Method__c = 'Direct Deposit';
            acc.Payment_Distribution__c = 'Practice Account';
            Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
            
            acc.RecordTypeId =  practiceRecordTypeId;        
            insert acc;
            system.debug('++++++++++++++++++++++++++++  TestClassAccId  ++++++++++++++++++++++++++++++++++++++++++++++' + acc.Id);
            
            
            Account acc1= new Account();
            Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            acc1.Name='Business Account Name';       
            acc1.ParentId = acc.id;
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
            
           
            acc1.Products_and_Assets__c = 'Level; RightEye';
            
            update acc1;
            delete acc1;
            
            
            Account acc2= new Account();  //null Parent Id for Bus Account
           
            acc2.Name='Business Account Name';       
          //  acc2.ParentId = acc.id;
            acc2.Fax = '123456789';
            acc2.ShippingStreet = '123 Test Street';
            acc2.ShippingCity = 'Somewhere';
            acc2.ShippingState = 'CA';
            acc2.ShippingPostalCode = '90210';
            acc2.ShippingCountry = 'USA';
            acc2.Vision_Care_Location_Phone_Number__c = '123456789';
            acc2.Eyefinity_Access__c = 'B - Basic';
            acc2.Location_Type__c = 'A - Affiliate Provider Location';
            acc2.Tax_ID__c = '123456789';
            acc2.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc2.Vision_Care_End_Date__c = System.today() + 3;
            acc2.Products_and_Assets__c = 'Level';
            acc2.RecordTypeId =  businessRecordTypeId; 
            
            insert acc2;  
            
            test.stoptest();
            
            
        }
        
    }
}