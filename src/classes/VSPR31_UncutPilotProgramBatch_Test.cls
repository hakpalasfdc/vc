@isTest public class VSPR31_UncutPilotProgramBatch_Test {

	private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	private static Id accountGroupsRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Account Groups').getRecordTypeId();
	private static Salesforce_Id__mdt a1 = [Select ID__c from Salesforce_Id__mdt where MasterLabel = 'Vision Trends']; 

	//Test method to check when IOF_Uncut_Pilot_Program__c will be updated to YES.
	public static testmethod void testMethod1(){

		/*Account a1 = new Account();
		a1.Name = 'Vision Trends';
		a1.recordTypeId = accountGroupsRecordTypeID;
		insert a1;*/

		//Salesforce_Id__mdt a1 = [Select ID__c from Salesforce_Id__mdt where MasterLabel = 'Vision Trends'];

		Account a2 = new Account();
		a2.Name = 'Business Account Test';
		a2.recordTypeId = businessRecordTypeID;
		insert a2;

		List<Account_Group__c> agList = new List<Account_Group__c>();

		Account_Group__c ag1 = new Account_Group__c();
		ag1.Account__c = a2.id;
		//ag1.Account_Group__c = a1.id;
		ag1.Account_Group__c = (Id)a1.ID__c;
		ag1.Start_Date__c = System.today();
		ag1.Optics_Primary__c = true;
		agList.add(ag1);

		Account_Group__c ag2 = new Account_Group__c();
		ag2.Account__c = a2.id;
		//ag2.Account_Group__c = a1.id;
		ag2.Account_Group__c = (Id)a1.ID__c;
		ag2.Start_Date__c = System.today();
		ag2.End_Date__c = System.today().addMonths(1);
		agList.add(ag2);

		Account_Group__c ag3 = new Account_Group__c();
		ag3.Account__c = a2.id;
		//ag3.Account_Group__c = a1.id;
		ag3.Account_Group__c = (Id)a1.ID__c;
		ag3.Start_Date__c = System.today();
		agList.add(ag3);

		insert agList;

		VSPR31_UncutPilotProgramBatch job = new VSPR31_UncutPilotProgramBatch();
		
		Test.startTest();
		Id jobId = Database.executeBatch(job);
		Test.stopTest();

		Account a3 = [Select id, IOF_Uncut_Pilot_Program__c from Account where id = :a2.id];
		System.assertEquals('Yes', a3.IOF_Uncut_Pilot_Program__c);

	}

	//Test method to check when IOF_Uncut_Pilot_Program__c will be updated to NO.
	public static testmethod void testMethod2(){

		/*Account a1 = new Account();
		a1.Name = 'Vision Trends';
		a1.recordTypeId = accountGroupsRecordTypeID;
		insert a1;*/

		Account a2 = new Account();
		a2.Name = 'Business Account Test';
		a2.recordTypeId = businessRecordTypeID;
		insert a2;

		List<Account_Group__c> agList = new List<Account_Group__c>();

		Account_Group__c ag1 = new Account_Group__c();
		ag1.Account__c = a2.id;
		//ag1.Account_Group__c = a1.id;
		ag1.Account_Group__c = (Id)a1.ID__c;
		ag1.Start_Date__c = System.today();
		agList.add(ag1);

		Account_Group__c ag2 = new Account_Group__c();
		ag2.Account__c = a2.id;
		//ag2.Account_Group__c = a1.id;
		ag2.Account_Group__c = (Id)a1.ID__c;
		ag2.Start_Date__c = System.today();
		ag2.End_Date__c = System.today().addMonths(1);
		agList.add(ag2);

		insert agList;

		VSPR31_UncutPilotProgramBatch job = new VSPR31_UncutPilotProgramBatch();
		
		Test.startTest();
		Id jobId = Database.executeBatch(job);
		Test.stopTest();

		Account a3 = [Select id, IOF_Uncut_Pilot_Program__c from Account where id = :a2.id];
		System.assertEquals('No', a3.IOF_Uncut_Pilot_Program__c);

	}


	public static testmethod void testMethod3(){

		/*Account a1 = new Account();
		a1.Name = 'Vision Trends';
		a1.recordTypeId = accountGroupsRecordTypeID;
		insert a1;*/

		Account a2 = new Account();
		a2.Name = 'Business Account Test';
		a2.recordTypeId = businessRecordTypeID;
		a2.IOF_Uncut_Pilot_Program__c = 'Exception';
		insert a2;

		List<Account_Group__c> agList = new List<Account_Group__c>();

		Account_Group__c ag1 = new Account_Group__c();
		ag1.Account__c = a2.id;
		//ag1.Account_Group__c = a1.id;
		ag1.Account_Group__c = (Id)a1.ID__c;
		ag1.Start_Date__c = System.today();
		ag1.Optics_Primary__c = true;
		agList.add(ag1);

		Account_Group__c ag2 = new Account_Group__c();
		ag2.Account__c = a2.id;
		//ag2.Account_Group__c = a1.id;
		ag2.Account_Group__c = (Id)a1.ID__c;
		ag2.Start_Date__c = System.today();
		ag2.End_Date__c = System.today().addMonths(1);
		agList.add(ag2);

		insert agList;

		VSPR31_UncutPilotProgramBatch job = new VSPR31_UncutPilotProgramBatch();
		
		Test.startTest();
		Id jobId = Database.executeBatch(job);
		Test.stopTest();

		Account a3 = [Select id, IOF_Uncut_Pilot_Program__c from Account where id = :a2.id];
		System.assertEquals('Exception', a3.IOF_Uncut_Pilot_Program__c);

	}


	/*public static testmethod void testMethod4(){

		Account a1 = new Account();
		a1.Name = 'Vision Trends';
		a1.recordTypeId = accountGroupsRecordTypeID;
		insert a1;

		Account a2 = new Account();
		a2.Name = 'Business Account Test';
		a2.recordTypeId = businessRecordTypeID;
		//a2.IOF_Uncut_Pilot_Program__c = 'Exception';
		insert a2;

		List<Account_Group__c> agList = new List<Account_Group__c>();

		Account_Group__c ag1 = new Account_Group__c();
		ag1.Account__c = a2.id;
		ag1.Account_Group__c = a1.id;
		ag1.Start_Date__c = System.today();
		ag1.Optics_Primary__c = true;
		agList.add(ag1);

		Account_Group__c ag2 = new Account_Group__c();
		ag2.Account__c = a2.id;
		ag2.Account_Group__c = a1.id;
		ag2.Start_Date__c = System.today();
		ag2.End_Date__c = System.today().addMonths(1);
		agList.add(ag2);

		insert agList;

		Account a3 = [Select id from Account where id = :a2.id FOR UPDATE];

		VSPR31_UncutPilotProgramBatch job = new VSPR31_UncutPilotProgramBatch();
		
		Test.startTest();
		Id jobId = Database.executeBatch(job);
		Test.stopTest();

		Account a4 = [Select id, IOF_Uncut_Pilot_Program__c from Account where id = :a2.id];
		//System.assertEquals('Exception', a3.IOF_Uncut_Pilot_Program__c);
		System.debug(a4.IOF_Uncut_Pilot_Program__c);

	}*/
	
}