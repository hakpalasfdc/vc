@isTest
// Test class for VSPR_All_Bus_Acc_Curr_Cust_Flg_Sch
public class VSP_All_Bus_Acc_Curr_Cust_Flg_Test {

     @TestSetup
    static void testData(){
        Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
        Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        VSPUtility.stopAccountTrigger = True;  ///bypass Account Trigger
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
        acc.RecordTypeId =  practiceRecordTypeId;        
        insert acc;
        
        Account acc1= new Account();
        acc1.Name='Bus Account Name M - VSP Member Location';       
        acc1.ParentId = acc.id;
        acc1.Fax = '123456789';
        acc1.ShippingStreet = '123 Test Street';
        acc1.ShippingCity = 'Somewhere';
        acc1.ShippingState = 'CA';
        acc1.ShippingPostalCode = '90210';
        acc1.ShippingCountry = 'USA';
        acc1.Vision_Care_Location_Phone_Number__c = '123456789';
        acc1.Eyefinity_Access__c = 'B - Basic';
        acc1.Location_Type__c = 'M - VSP Member Location';
        acc1.Tax_ID__c = '123456789';
        acc1.Vision_Care_Effective_Date__c = Date.today().addDays(-10);
        acc1.Vision_Care_End_Date__c = Date.today().addDays(-5);
        acc1.Vision_Care_VSP_Network_Provider__c = TRUE;
        acc1.Vision_Care_VSP_Affiliate__c = TRUE;                                               
        acc1.Vision_Care_VSP_Other__c = TRUE;
        acc1.VC__c = False;
        acc1.RecordTypeId =  busAccRecordTypeId; 
        
        insert acc1;  
        
        Account acc2= new Account();
        acc2.Name='Bus Account Name A - Affiliate Provider Location';       
        acc2.ParentId = acc.id;
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
        acc2.Vision_Care_Effective_Date__c = Date.today().addDays(-10);
        acc2.Vision_Care_End_Date__c = Date.today().addDays(10);
        acc2.Vision_Care_VSP_Network_Provider__c = TRUE;
        acc2.Vision_Care_VSP_Affiliate__c = TRUE;                                               
        acc2.Vision_Care_VSP_Other__c = TRUE;
        acc2.VC__c = True;
        acc2.RecordTypeId =  busAccRecordTypeId; 
        
        insert acc2;
        
        Account acc3= new Account();
        acc3.Name='Bus Acc Name X - Client Authorized Location (GAP)';       
        acc3.ParentId = acc.id;
        acc3.Fax = '123456789';
        acc3.ShippingStreet = '123 Test Street';
        acc3.ShippingCity = 'Somewhere';
        acc3.ShippingState = 'CA';
        acc3.ShippingPostalCode = '90210';
        acc3.ShippingCountry = 'USA';
        acc3.Vision_Care_Location_Phone_Number__c = '123456789';
        acc3.Eyefinity_Access__c = 'B - Basic';
        acc3.Location_Type__c = 'X - Client Authorized Location (GAP)';
        acc3.Tax_ID__c = '123456789';
        acc3.Vision_Care_Effective_Date__c = Date.today().addDays(-10);
        acc3.Vision_Care_End_Date__c = Date.today().addDays(10);
        acc3.Vision_Care_VSP_Network_Provider__c = TRUE;
        acc3.Vision_Care_VSP_Affiliate__c = TRUE;                                               
        acc3.Vision_Care_VSP_Other__c = TRUE;
        acc3.VC__c = True;
        acc3.RecordTypeId =  busAccRecordTypeId; 
        
        insert acc3;
        
          Account acc4= new Account();
        acc4.Name='Bus Account Name M - VSP Member Location2';       
        acc4.ParentId = acc.id;
        acc4.Fax = '123456789';
        acc4.ShippingStreet = '123 Test Street';
        acc4.ShippingCity = 'Somewhere';
        acc4.ShippingState = 'CA';
        acc4.ShippingPostalCode = '90210';
        acc4.ShippingCountry = 'USA';
        acc4.Vision_Care_Location_Phone_Number__c = '123456789';
        acc4.Eyefinity_Access__c = 'B - Basic';
        acc4.Location_Type__c = 'M - VSP Member Location';
        acc4.Tax_ID__c = '123456789';
        acc4.Vision_Care_Effective_Date__c = Date.today().addDays(-10);
        acc4.Vision_Care_End_Date__c = Date.today().addDays(10);
        acc4.Vision_Care_VSP_Network_Provider__c = TRUE;
        acc4.Vision_Care_VSP_Affiliate__c = TRUE;                                               
        acc4.Vision_Care_VSP_Other__c = TRUE;
        acc4.VC__c = True;
        acc4.RecordTypeId =  busAccRecordTypeId; 
        
        insert acc4;  
    }
     public static testmethod void runBatch() {
               
        Test.startTest();
        
        String EXP = '0 0 1 * * ?';
        
        VSP_All_Bus_Acc_Curr_Cust_Flg_Sch sch = new VSP_All_Bus_Acc_Curr_Cust_Flg_Sch();
        
        system.Schedule('Business Account All Current Customer Flags Test', EXP, sch);
        
        Test.stopTest();
       
    }
}