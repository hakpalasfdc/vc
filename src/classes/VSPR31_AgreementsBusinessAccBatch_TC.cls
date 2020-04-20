@isTest public class VSPR31_AgreementsBusinessAccBatch_TC {
    
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Date startDate = System.today();
    //below part added on 08/19/2019
    private static String CRON_EXP = '0 00 01 * * ?';

    @IsTest
    static void testmethod1(){

        List<Account> busAccList = new List<Account>();
        Account ba1 = new Account();
        Account ba2 = new Account();

        Account a = new Account();
        a.recordTypeId = practiceRecordTypeID;
        a.Name = 'Practice Account';
        a.Vision_Care_Good_Standing__c = true;
        insert a;

        ba1.Name = 'Testing Business Account 1';
        ba1.Location_Type__c = 'X - Client Authorized Location (GAP)';
        ba1.Vision_Care_Good_Standing__c = true;
        ba1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        ba1.Parent_Company__c = 'PERL - Pearle Vision Location';
        ba1.recordTypeID = businessRecordTypeID;
        ba1.ParentId = a.id;
        ba1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        busAccList.add(ba1);

        ba2.Name = 'Testing Business Account 2';
        ba2.Location_Type__c = 'X - Client Authorized Location (GAP)';
        ba2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        ba2.Parent_Company__c = 'PERL - Pearle Vision Location';
        ba2.recordTypeID = businessRecordTypeID;
        ba2.ParentId = a.id;
        ba2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        busAccList.add(ba2);

        insert busAccList;

        List<Agreement__c> agList = new List<Agreement__c>();
        Agreement__c ag1 = new Agreement__c();
        Agreement__c ag2 = new Agreement__c();

        ag1.Type__c = 'DOLP1';
        ag1.Effective_Date__c = startDate;
        ag1.Account__c = a.Id;
        agList.add(ag1);

        ag2.Type__c = 'DOLP4';
        ag2.Effective_Date__c = startDate;
        ag2.Account__c = a.Id;
        ag2.End_Date__c = startDate.addMonths(2);
        ag2.End_Date_Reason__c = 'Error';
        //ag2.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag2);

        Agreement__c ag3 = new Agreement__c();
        ag3.Type__c = 'DOLP2';
        ag3.Account__c = a.Id;
        ag3.Effective_Date__c = startDate.addDays(1);
        agList.add(ag3);

        insert agList;

        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

        VSPR31_AgreementsBusinessAcc_Batch job = new VSPR31_AgreementsBusinessAcc_Batch();
        
        Test.startTest();
        Id jobId = Database.executeBatch(job);
        Test.stopTest();

        Account ba3 = [Select id, Agreement_Type__c from Account where Name = 'Testing Business Account 1'];
        System.assertEquals('DOLP1; DOLP4', ba3.Agreement_Type__c);
        
    }

    @IsTest
    static void testmethod2(){

        List<Account> busAccList = new List<Account>();
        Account ba1 = new Account();
        Account ba2 = new Account();

        Account a = new Account();
        a.recordTypeId = practiceRecordTypeID;
        a.Name = 'Practice Account';
        a.Vision_Care_Good_Standing__c = true;
        insert a;

        ba1.Name = 'Testing Business Account 1';
        ba1.Location_Type__c = 'X - Client Authorized Location (GAP)';
        ba1.Vision_Care_Good_Standing__c = true;
        ba1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        ba1.Parent_Company__c = 'PERL - Pearle Vision Location';
        ba1.recordTypeID = businessRecordTypeID;
        ba1.ParentId = a.id;
        ba1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        busAccList.add(ba1);

        ba2.Name = 'Testing Business Account 2';
        ba2.Location_Type__c = 'X - Client Authorized Location (GAP)';
        ba2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        ba2.Parent_Company__c = 'PERL - Pearle Vision Location';
        ba2.recordTypeID = businessRecordTypeID;
        ba2.ParentId = a.id;
        ba2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        busAccList.add(ba2);

        insert busAccList;

        List<Agreement__c> agList = new List<Agreement__c>();
        Agreement__c ag1 = new Agreement__c();
        Agreement__c ag2 = new Agreement__c();

        ag1.Type__c = 'DOLP1';
        ag1.Effective_Date__c = startDate;
        ag1.Account__c = a.Id;
        agList.add(ag1);

        ag2.Type__c = 'DOLP4';
        ag2.Effective_Date__c = startDate;
        ag2.Account__c = a.Id;
        ag2.End_Date__c = startDate.addMonths(2);
        ag2.End_Date_Reason__c = 'Error';
        //ag2.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag2);

        Agreement__c ag3 = new Agreement__c();
        ag3.Type__c = 'DOLP2';
        ag3.Account__c = a.Id;
        ag3.Effective_Date__c = startDate.addDays(1);
        agList.add(ag3);

        Agreement__c ag4 = new Agreement__c();
        ag4.Type__c = 'DOLP1';
        ag4.Account__c = a.Id;
        ag4.Effective_Date__c = startDate;
        agList.add(ag4);

        Agreement__c ag5 = new Agreement__c();
        ag5.Type__c = 'DOLP4';
        ag5.Effective_Date__c = startDate;
        ag5.Account__c = a.Id;
        ag5.End_Date__c = startDate.addMonths(1);
        ag5.End_Date_Reason__c = 'Error';
        //ag2.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag5);

        Agreement__c ag6 = new Agreement__c();
        ag6.Type__c = 'DOLP4';
        ag6.Effective_Date__c = startDate;
        ag6.Account__c = a.Id;
        ag6.End_Date__c = startDate.addMonths(1);
        ag6.End_Date_Reason__c = 'Error';
        //ag2.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag6);

        insert agList;

        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

        VSPR31_AgreementsBusinessAcc_Batch job = new VSPR31_AgreementsBusinessAcc_Batch();
        
        Test.startTest();
        Id jobId = Database.executeBatch(job);
        Test.stopTest();

        Account ba3 = [Select id, Agreement_Type__c from Account where Name = 'Testing Business Account 1'];
        System.assertEquals('DOLP1; DOLP4', ba3.Agreement_Type__c);
        
    }

    //Below part added to run the test against the premier admin tool daily batch job scheduler class. 
    @IsTest
    static void methodName3(){
        
        VSPR31_AgreementStatusBatch_Sch job = new VSPR31_AgreementStatusBatch_Sch();

        Test.startTest();
        String jobId = System.schedule('Test Territory Check', CRON_EXP, job);

		CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
                          NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CRON_EXP, 
                            ct.CronExpression);
        
        // Verify the job has not run
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
        
    }
}