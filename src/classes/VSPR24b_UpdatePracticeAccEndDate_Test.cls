//Tests VSPR19b_UpdatePracticeAccountEndDate
//Dated:07-26-2018
@isTest(SeeAllData=true)
public class VSPR24b_UpdatePracticeAccEndDate_Test {

    public static testmethod void testPracticeEndDate() {  
        
        
        test.starttest();
        Account acc= new Account();
        acc.Name='Practice Account Name';
        acc.NPI_Type_2__c='1234567893';
        acc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
        
        acc.RecordTypeId =  practiceRecordTypeId;        
        insert acc;
        system.debug('++++++++++++++++++++++++++++  TestClassAccId  ++++++++++++++++++++++++++++++++++++++++++++++' + acc.Id);
    
         
        Account acc1= new Account();
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        acc1.Name='Business Account Name';
        acc1.NPI_Type_2__c='1234567893';       
        acc1.ParentId = acc.id;
        acc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        acc1.Vision_Care_End_Date__c = Date.newInstance(2018, 07, 31);
        acc1.RecordTypeId =  businessRecordTypeId; 
        
      	insert acc1;  
        test.stoptest();
        
        
    }
    public static testmethod void testUpdateBusAccEndDate(){
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        Account acc2 = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c from Account WHERE RecordTypeId = :businessRecordTypeId AND ParentId != NULL LIMIT 1];
        acc2.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
        acc2.Vision_Care_End_Date__c = Date.newInstance(2018, 07, 31);
        update acc2;
        
    }
}