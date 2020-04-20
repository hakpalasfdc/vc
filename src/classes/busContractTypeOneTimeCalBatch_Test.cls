@isTest public class busContractTypeOneTimeCalBatch_Test {
    
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();

    public static testmethod void testMethod1(){

        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;

        Account acc = new Account();
        acc.Name = 'Practice Test Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        Account a = new Account();
        a.Name = 'Testing Account';
        a.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a.Vision_Care_Good_Standing__c = true;
        a.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a.Parent_Company__c = 'PERL - Pearle Vision Location';
        a.recordTypeID = businessRecordTypeID;
        a.ParentId = acc.id;
        a.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        a.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a;

        //System.debug(a);

        a.Contract_Type__c = null;
        update a;

        Test.startTest();
        BusContractTypeOneTimeCalBatch job = new BusContractTypeOneTimeCalBatch();
        Id jobId = Database.executeBatch(job);
        Test.stopTest();

        Account a1 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a1.Contract_Type__c, 'GAP');
    }

    public static testmethod void testMethod2(){

        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;

        Account acc = new Account();
        acc.Name = 'Practice Test Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        Account a = new Account();
        a.Name = 'Testing Account';
        a.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a.Vision_Care_Good_Standing__c = true;
        a.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a.Parent_Company__c = 'PERL - Pearle Vision Location';
        a.recordTypeID = businessRecordTypeID;
        a.ParentId = acc.id;
        a.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        a.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a;

        //System.debug(a);

        acc.Vision_Care_Good_Standing__c = false;
        update acc;

        Test.startTest();
        BusContractTypeOneTimeCalBatch job = new BusContractTypeOneTimeCalBatch();
        Id jobId = Database.executeBatch(job);
        Test.stopTest();

        Account a1 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a1.Contract_Type__c, null);
    }

    public static testmethod void testMethod3(){

        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;

        Account acc = new Account();
        acc.Name = 'Practice Test Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        Account a = new Account();
        a.Name = 'Testing Account';
        a.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a.Vision_Care_Good_Standing__c = true;
        a.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a.Parent_Company__c = 'PERL - Pearle Vision Location';
        a.recordTypeID = businessRecordTypeID;
        a.ParentId = acc.id;
        a.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        a.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a;

        //System.debug(a);

        a.Vision_Care_Good_Standing__c = false;
        update a;

        Test.startTest();
        BusContractTypeOneTimeCalBatch job = new BusContractTypeOneTimeCalBatch();
        Id jobId = Database.executeBatch(job);
        Test.stopTest();

        Account a1 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a1.Contract_Type__c, null);
    }
}