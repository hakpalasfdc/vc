@isTest
public class VSPR30_Acc_Brand_History_LTM_Ctrl_Test {
    
    static testMethod void test_Acc_EBS(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        //Insert New Business Account
        Account ba = new Account();
        ba.Name = 'testbizAccount';
        ba.RecordTypeId = accRecordTypeId;
        ba.Vision_Care_Effective_Date__c = date.today();
        insert ba;
        
        Eyewear_Brand_Sales__c eBS = new Eyewear_Brand_Sales__c();
        eBS.Sales_Org__c = '2010';
        eBS.Brand_Code__c = '123';
        eBS.Marketing_Group_Description__c = 'Test Group Description';
        eBS.Net_Frame_Sales_LTM__c = 500;
        eBS.Net_Sales_LTM__c = 5000;
        eBS.Last_Date_Ordered__c = system.today();
        eBS.Account_ID__c = ba.Id;
        insert eBS;
                
        Apexpages.StandardController sc = new Apexpages.StandardController(ba);
        VSPR30_Acc_Brand_History_LTM_Ctrl ext = new VSPR30_Acc_Brand_History_LTM_Ctrl(sc);
        ext.geteBS();
        
    }
}