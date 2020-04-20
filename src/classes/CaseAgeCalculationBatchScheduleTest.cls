@isTest
public class CaseAgeCalculationBatchScheduleTest {
    public static String CRON_EXP = '0 30 * * * ?';
    public static testMethod void caseAgeCalculate(){
    
    
       RecordType rt = new RecordType();
       rt = [Select id,name from RecordType where Name = 'Customer Care' and sobjectType = 'Case' LIMIT 1];
       
       
       list<CaseRecordType__c> lstCaseRT = new list<CaseRecordType__c>();
        
       CaseRecordType__c CaseRecordType=new CaseRecordType__c();
       CaseRecordType.Id__c= rt.id;
       CaseRecordType.name='Customer Care';
       lstCaseRT.add(CaseRecordType);
       
       
       CaseRecordType__c CaseRecordType1=new CaseRecordType__c();
       CaseRecordType1.Id__c= rt.id;
       CaseRecordType1.name='VSP Global Full Id';
       lstCaseRT.add(CaseRecordType1);
       
       
       insert lstCaseRT;
       
       DVIWebService__c di = new DVIWebService__c(Name='DVI Values',DVI_Web_Service__c='Test');
       insert di;
       
       system.assertNotEquals(CaseRecordType.id,null);
       
       Escalated_Queue_Name__c Escalated_Queue_Name=new Escalated_Queue_Name__c();
       Escalated_Queue_Name.name='Error Queue';
       Escalated_Queue_Name.Escalated_Q_Name__c='Error Queue';
       insert Escalated_Queue_Name;
       system.assertNotEquals(Escalated_Queue_Name.id,null); 
       
        Test.startTest();
        
        List<Case> lstCases = new List<Case>();
         
        Case c = new Case(Case_Age_2__c= 20,Priority='high',origin = 'Email',Email_Last_Received__c=system.now(),
        status='Closed',Description='Test Description : VSP Member:',  Subject='Test Subject', recordTypeId =rt.id);
        
        lstCases.add(c);
        
        
        Case c2 = new Case(Case_Age_2__c= 30,Priority='Medium',origin = 'Email',Email_Last_Received__c=system.now(),
        recordTypeId =rt.id, Description='Test Description : VSP Member:',  Subject='Test Subject');
       
        lstCases.add(c2);
        
        
        Case c3 = new Case(Case_Age_2__c= 30,Priority='Medium',origin = 'Email',Email_Last_Received__c=system.now(), 
                        Email_Last_Sent__c = system.now().addDays(5),recordTypeId =rt.id, Description='Test Description : VSP Member:'
                        ,Subject='Test Subject');
                        
        lstCases.add(c3);
        
        
        insert lstCases;
        
         for(CronTrigger ct : [Select Id from CronTrigger]){
            System.abortJob(ct.Id);
        }
        
        CaseAgeCalculationBatchSchedule ccb = new CaseAgeCalculationBatchSchedule();
        ccb.CaseAgeCalculationBatchSchedule();
        ccb.execute(null);
       
        // Schedule the test job
        String jobId = System.schedule('testBasicScheduledApex',CRON_EXP, ccb);
        
        // Get the information from the CronTrigger API object
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered,NextFireTime
                          FROM CronTrigger WHERE id = :jobId];
        
        // Verify the expressions are the same
        System.assertEquals(CaseAgeCalculationBatchSchedule.sched, ct.CronExpression);
        
        Test.stopTest();
    }
}