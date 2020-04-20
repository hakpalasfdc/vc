@isTest public class VSPR31_PracticeContractTypeBatch_Test {

	private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
	private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();

	//Testing for scenario where the practice account is not in good standing. 
	public static testmethod void testMethod1(){

		//List<Account> accountList = new List<Account>();

		Account a1 = new Account();
		a1.Name = 'Practice Account Test';
		a1.recordTypeId = practiceRecordTypeID;
		a1.Premier_Tax_ID_Roll_Up_Account__c = true;
		insert a1;

		Account a2 = new Account();
		a2.Name = 'Testing Account';
		a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
		a2.Vision_Care_Good_Standing__c = true;
		a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a2.Parent_Company__c = 'PERL - Pearle Vision Location';
		a2.recordTypeID = businessRecordTypeID;
		a2.ParentId = a1.id;
		insert a2;

		Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

		VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId = Database.executeBatch(job);
		Test.stopTest();

		Account a3 = [Select id, Contract_Type__c from Account where Name = 'Practice Account Test'];
		System.assertEquals(a3.Contract_Type__c, null);

	}


	//Testing for scenario where the practice account is a tax id rollup.
	public static testmethod void testMethod2(){

		List<Account> accountList = new List<Account>();

		Account acc = new Account();
		acc.Name = 'Practice Account Test';
		acc.recordTypeId = practiceRecordTypeID;
		acc.Premier_Tax_ID_Roll_Up_Account__c = true;
		acc.Vision_Care_Good_Standing__c = true;
		insert acc;

		Account a1 = new Account();
		a1.Name = 'Business Test Account 1';
		a1.Location_Type__c = 'F - Laser Vision Correction (LVC)';
		a1.recordTypeId = businessRecordTypeID;
		a1.Vision_Care_Good_Standing__c = true;
		a1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a1.ParentId = acc.id;
		a1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		accountList.add(a1);

		Account a2 = new Account();
		a2.Name = 'Testing Account';
		a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
		a2.Vision_Care_Good_Standing__c = true;
		a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a2.Parent_Company__c = 'PERL - Pearle Vision Location';
		a2.recordTypeID = businessRecordTypeID;
		a2.ParentId = acc.id;
		a2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		accountList.add(a2);

		insert accountList;

		Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

		VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

		Account acc1 = [Select id, Contract_Type__c from Account where Name = 'Practice Account Test'];
		System.assertEquals(acc1.Contract_Type__c, 'Rollup');

	}


	//testing for scenario when the account is in good standing but not a tax id rollup.
	//The business accounts have a different contract types.
	public static testmethod void testMethod3(){
		List<Account> accountList = new List<Account>();

		Account acc = new Account();
		acc.Name = 'Practice Account Test';
		acc.recordTypeId = practiceRecordTypeID;
		acc.Vision_Care_Good_Standing__c = true;
		insert acc;

		Account a1 = new Account();
		a1.Name = 'Business Test Account 1';
		a1.Location_Type__c = 'F - Laser Vision Correction (LVC)';
		a1.recordTypeId = businessRecordTypeID;
		a1.Vision_Care_Good_Standing__c = true;
		a1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a1.ParentId = acc.id;
		a1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		accountList.add(a1);

		Account a2 = new Account();
		a2.Name = 'Testing Account';
		a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
		a2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		a2.Vision_Care_Good_Standing__c = true;
		a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a2.Parent_Company__c = 'PERL - Pearle Vision Location';
		a2.recordTypeID = businessRecordTypeID;
		a2.ParentId = acc.id;
		accountList.add(a2);

		Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

		insert accountList;

		VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

		Account acc1 = [Select id, Contract_Type__c from Account where Name = 'Practice Account Test'];
		System.assertEquals(acc1.Contract_Type__c, 'Conflict');
	}

	//testing for scenario when the account is in good standing but not a tax id rollup.
	//The business accounts have a same contract types.
	public static testmethod void testMethod4(){
		List<Account> accountList = new List<Account>();

		Account acc = new Account();
		acc.Name = 'Practice Account Test';
		acc.recordTypeId = practiceRecordTypeID;
		acc.Vision_Care_Good_Standing__c = true;
		insert acc;

		Account a1 = new Account();
		a1.Name = 'Testing Account 1';
		a1.Location_Type__c = 'X - Client Authorized Location (GAP)';
		a1.Vision_Care_Good_Standing__c = true;
		a1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a1.Parent_Company__c = 'PERL - Pearle Vision Location';
		a1.recordTypeID = businessRecordTypeID;
		a1.ParentId = acc.id;
		a1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		accountList.add(a1);

		Account a2 = new Account();
		a2.Name = 'Testing Account';
		a2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
		a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
		a2.Vision_Care_Good_Standing__c = true;
		a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a2.Parent_Company__c = 'PERL - Pearle Vision Location';
		a2.recordTypeID = businessRecordTypeID;
		a2.ParentId = acc.id;
		accountList.add(a2);

		insert accountList;

		Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

		VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

		Account acc1 = [Select id, Contract_Type__c from Account where Name = 'Practice Account Test'];
		System.assertEquals(acc1.Contract_Type__c, 'GAP');
	}

	//testing for scenario when the account is in good standing but not a tax id rollup.
	//The business accounts have contract types equals to null.
	public static testmethod void testMethod5(){
		List<Account> accountList = new List<Account>();

		Account acc = new Account();
		acc.Name = 'Practice Account Test';
		acc.recordTypeId = practiceRecordTypeID;
		acc.Vision_Care_Good_Standing__c = true;
		insert acc;

		Account a1 = new Account();
		a1.Name = 'Testing Account 1';
		a1.Location_Type__c = 'X - Client Authorized Location (GAP)';
		//a1.Vision_Care_Good_Standing__c = true;
		a1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a1.Parent_Company__c = 'PERL - Pearle Vision Location';
		a1.recordTypeID = businessRecordTypeID;
		a1.ParentId = acc.id;
		accountList.add(a1);

		Account a2 = new Account();
		a2.Name = 'Testing Account';
		a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
		//a2.Vision_Care_Good_Standing__c = true;
		a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
		a2.Parent_Company__c = 'PERL - Pearle Vision Location';
		a2.recordTypeID = businessRecordTypeID;
		a2.ParentId = acc.id;
		accountList.add(a2);

		insert accountList;

		Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

		VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

		Account acc1 = [Select id, Contract_Type__c from Account where Name = 'Practice Account Test'];
		System.assertEquals(acc1.Contract_Type__c, null);
	}
	
}