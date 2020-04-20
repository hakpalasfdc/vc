@isTest public class VSPR33_vcCalculatorBatchTest {
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    
    @IsTest
    static void testMethod1(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = System.today();
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        p1.VC__c = false;
        update p1;

        Test.startTest();

        VSPR33_vcCalculatorBatch job = new VSPR33_vcCalculatorBatch();
        Id jobId = Database.executeBatch(job);
        
        Test.stopTest();

        Account a = [Select id, VC__c from Account where id = :p1.Id];
        System.assertEquals(a.VC__c, true);
    }

    @IsTest
    static void testMethod2(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = System.today().addDays(-10);
        p1.Vision_Care_End_Date__c = System.today().addDays(-1);
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        p1.VC__c = true;
        update p1;

        Test.startTest();

        VSPR33_vcCalculatorBatch job = new VSPR33_vcCalculatorBatch();
        Id jobId = Database.executeBatch(job);
        
        Test.stopTest();

        Account a = [Select id, VC__c from Account where id = :p1.Id];
        System.assertEquals(a.VC__c, false);
        
    }

    @IsTest
    static void testMethod3(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = System.today();
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        p1.VC__c = false;
        update p1;

        Test.startTest();

        vsCalculatorOneTimeBatch job = new vsCalculatorOneTimeBatch(1);
        Id jobId = Database.executeBatch(job);
        
        Test.stopTest();

        Account a = [Select id, VC__c from Account where id = :p1.Id];
        System.assertEquals(a.VC__c, true);
    }

    @IsTest
    static void testMethod4(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = System.today().addDays(-10);
        p1.Vision_Care_End_Date__c = System.today().addDays(-1);
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        p1.VC__c = true;
        update p1;

        Test.startTest();

        vsCalculatorOneTimeBatch job = new vsCalculatorOneTimeBatch(1);
        Id jobId = Database.executeBatch(job);
        
        Test.stopTest();

        Account a = [Select id, VC__c from Account where id = :p1.Id];
        System.assertEquals(a.VC__c, false);
    }
}