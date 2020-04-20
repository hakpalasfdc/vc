//This test class needs to be deleted.

@isTest
public class VSPR32_Premier_Benefit_Status_Upd_Test {

    private static String CRON_EXP = '0 00 01 * * ?';
    
    //test method to check for active Premier Benefit
    public static testmethod void testPremierBenefitBatch(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Premier_Benefit__c newBenefit = new Premier_Benefit__c();
        
        newBenefit.Name = 'Test Benefit';
        newBenefit.Benefit_Type__c = 'Currency';
        newBenefit.Effective_Date__c = Date.today().addDays(-1);
        newBenefit.Description__c = 'Qwerty';
        insert newBenefit;

        Premier_Benefit__c benefit = [Select Status__c from Premier_Benefit__c LIMIT 1];
        System.assertEquals('Future', benefit.Status__c);
        
        Test.startTest();
        VSPR32_Premier_Benefit_Status_Upd_Batch job = new VSPR32_Premier_Benefit_Status_Upd_Batch();
        Id jobId = Database.executeBatch(job,200);
        Test.stopTest();
        newBenefit = [Select Status__c from Premier_Benefit__c Where Name = 'Test Benefit' LIMIT 1];
        system.assertEquals(newBenefit.Status__c, 'Active');
    }
    
    @IsTest
    static void methodName2(){
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Premier_Benefit__c newBenefit = new Premier_Benefit__c();
        
        newBenefit.Name = 'Test Benefit';
        newBenefit.Benefit_Type__c = 'Currency';
        newBenefit.Effective_Date__c = Date.today().addDays(-10);
        newBenefit.End_Date__c = System.today().addDays(-1);
        newBenefit.Description__c = 'Qwerty';
        insert newBenefit;

        Premier_Benefit__c benefit = [Select Status__c from Premier_Benefit__c LIMIT 1];
        System.assertEquals('Future', benefit.Status__c);
        
        Test.startTest();
        VSPR32_Premier_Benefit_Status_Upd_Batch job = new VSPR32_Premier_Benefit_Status_Upd_Batch();
        Id jobId = Database.executeBatch(job,200);
        Test.stopTest();
        newBenefit = [Select Status__c from Premier_Benefit__c Where Name = 'Test Benefit' LIMIT 1];
        system.assertEquals(newBenefit.Status__c, 'Inactive');
    }

    //Below test method added to cover VSPR33_PremierDailyBatch2_Sch
    //Added as part of SFDC-11988
    @IsTest
    static void methodName3(){
        
        VSPR33_PremierDailyBatch2_Sch job = new VSPR33_PremierDailyBatch2_Sch();

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
    //Ends here.
}