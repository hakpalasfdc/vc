@isTest public class VSPR31_UncutPilotProgramBatch_Sch_TC {
	
	private static String CRON_EXP = '0 00 00 * * ?';
	private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	private static Id accountGroupsRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Groups').getRecordTypeId();
	private static Salesforce_ID__mdt a1 = [Select ID__c from Salesforce_ID__mdt where MasterLabel = 'Vision Trends'];

	public static testmethod void testMethod1(){

		//List<Account> accList = new Account();

		/*Account a1 = new Account();
		a1.Name = 'Vision Trends';
		a1.recordTypeId = accountGroupsRecordTypeID;
		insert a1;*/

		Account a2 = new Account();
		a2.Name = 'Business Test Account';
		a2.recordTypeId = businessRecordTypeID;
		insert a2;

		//accList.add(a1);
		//accList.add(a2);

		Account_Group__c ag = new Account_Group__c();
		ag.Account__c = a2.id;
		//ag.Account_Group__c = a1.id;
		ag.Account_Group__c = (Id)a1.ID__c;
		ag.Start_Date__c = System.today();
		ag.Optics_Primary__c = true;
		insert ag;

		VSPR31_UncutPilotProgramBatch_Sch job = new VSPR31_UncutPilotProgramBatch_Sch();

		Test.startTest();

		/*String jobId = VSPR31_UncutPilotProgramBatch_Sch.scheduleMe();*/

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