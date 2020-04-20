@isTest public class VSPR31_AgreementType_Test {

	private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static Id contractTypeRecordTypeID = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();

    static testmethod void testMethod1(){
    	List<Global_Rewards_Group__c> grgList = new List<Global_Rewards_Group__c>();
    	Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
    	Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
    	Account acc = new Account();
    	Account a = new Account();
    	Agreement__c ag = new Agreement__c();

    	acc.Name = 'Practice Test Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        //acc.Contract_Type__c = 'GAP';
        insert acc;

        a.Name = 'Testing Account';
        a.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a.Vision_Care_Good_Standing__c = true;
        a.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a.Parent_Company__c = 'PERL - Pearle Vision Location';
        a.recordTypeID = businessRecordTypeID;
        a.ParentId = acc.id;
        a.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        insert a;

        Account a1 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a1.Contract_Type__c, 'GAP');

        VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

		/*Account acc1 = [Select id, Contract_Type__c from Account where Name = 'Practice Test Account'];
        System.assertEquals(acc1.Contract_Type__c, 'GAP');*/

        ag.Type__c = 'DOLP4';
        ag.Effective_Date__c = System.today();
        ag.Account__c = acc.Id;
        ag.End_Date__c = System.today().addMonths(2);
        ag.End_Date_Reason__c = 'Error';
        //ag.Status__c = 'Active'; //needs to be deleted once thr trigger and batch job is ready.
        insert ag;


        grg.Name = 'GRG Test';
        grg.recordTypeId = contractTypeRecordTypeID;
        grg.Start_Date__c = System.today();//Added on 08/19/2019 as part of status field refracting on the GRG object.
        insert grg;

        grgr.Start_Date__c = System.today();
        grgr.End_Date__c = System.today().addMonths(2);
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Child_Account__c = a.Id;
        insert grgr;

        /*grg.Status__c = 'Active';
        update grg;*/

        Global_Rewards_Group__c grg1 = [Select id, Status__c, Tier_Agreement_type__c from Global_Rewards_Group__c where Name = 'GRG Test'];
        System.assertEquals(grg1.Status__c, 'Active');
        System.assertEquals(grg1.Tier_Agreement_Type__c, null);

        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;


        /*grgList = VSPR31_AgreementType.AgreementTypeCalculation(new List<Global_Rewards_Group__c>{grg1});

        Account acc1 = [Select id, Contract_Type__c, Tier_Agreement_type__c from Account where Name = 'Practice Test Account'];
        System.assertEquals(acc1.Contract_Type__c, 'GAP');
        System.assertEquals(acc1.Tier_Agreement_Type__c, 'DOLP4');

        System.assertEquals(grgList.get(0).Tier_Agreement_type__c, 'DOLP4');*/

        //below part commented by Vikhyat on 08/21/2019
        /*VSPR31_AgreementType at = new VSPR31_AgreementType();
        Id id2 = Database.executeBatch(at);*/
        //Part commented by vikhyat on 08/21/2019 ends here.

        //below part added to cover the new tier agreement type test class.
        VSPR31_TierAgreementTypePracticeAccount at = new VSPR31_TierAgreementTypePracticeAccount();
        Id id2 = Database.executeBatch(at);
    }

    static testmethod void testMethod2(){
    	List<Global_Rewards_Group__c> grgList = new List<Global_Rewards_Group__c>();
    	Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
    	//Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
    	Account acc1 = new Account();
    	Account a1 = new Account();
    	Account a2 = new Account();
    	Agreement__c ag = new Agreement__c();

    	acc1.Name = 'Practice Test Account 1';
        acc1.Vision_Care_Good_Standing__c = true;
        acc1.recordTypeId = practiceRecordTypeID;
        //acc1.Contract_Type__c = 'GAP';
        insert acc1;

        a1.Name = 'Testing Account';
        a1.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a1.Vision_Care_Good_Standing__c = true;
        a1.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a1.Parent_Company__c = 'PERL - Pearle Vision Location';
        a1.recordTypeID = businessRecordTypeID;
        a1.ParentId = acc1.id;
        a1.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        insert a1;

        Account acc2 = new Account();
        acc2.Name = 'Practice Test Account 2';
        acc2.Vision_Care_Good_Standing__c = true;
        acc2.recordTypeId = practiceRecordTypeID;
        //acc.Contract_Type__c = 'GAP';
        insert acc2;

        //Account a2 = new Account();
        a2.Name = 'Testing Account';
        a2.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a2.Vision_Care_Good_Standing__c = true;
        a2.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a2.Parent_Company__c = 'PERL - Pearle Vision Location';
        a2.recordTypeID = businessRecordTypeID;
        a2.ParentId = acc2.id;
        a2.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        insert a2;

        VSPR31_PracticeContractTypeBatch job = new VSPR31_PracticeContractTypeBatch();

		Test.startTest();
		Id jobId1 = Database.executeBatch(job);
		Test.stopTest();

        List<Agreement__c> agList = new List<Agreement__c>();
        Agreement__c ag1 = new Agreement__c();
        Agreement__c ag2 = new Agreement__c();

        ag1.Type__c = 'DOLP1';
        ag1.Effective_Date__c = System.today();
        ag1.Account__c = acc1.Id;
        ag1.End_Date__c = System.today().addMonths(2);
        ag1.End_Date_Reason__c = 'Error';
        //ag1.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag1);

        ag2.Type__c = 'DOLP4';
        ag2.Effective_Date__c = System.today();
        ag2.Account__c = acc2.Id;
        ag2.End_Date__c = System.today().addMonths(2);
        ag2.End_Date_Reason__c = 'Error';
        //ag2.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag2);

        Agreement__c ag3 = new Agreement__c();
		ag3.Type__c = 'DOLP2';
        ag3.Effective_Date__c = System.today();
        ag3.Account__c = acc2.Id;
        ag3.End_Date__c = System.today().addMonths(2);
        ag3.End_Date_Reason__c = 'Error';
        //ag3.Status__c = 'Active'; //Need to removed once the trigger on the agreement obj is up and running.
        agList.add(ag3);        

        insert agList;

        List<Global_Rewards_Group_Relationship__c> grgrList = new List<Global_Rewards_Group_Relationship__c>();
        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();

        grg.Name = 'GRG Test';
        grg.recordTypeId = contractTypeRecordTypeID;
        grg.Start_Date__c = System.today(); //Added on 08/19/2019 as part of status field refracting on the GRG object.
        insert grg;

        grgr1.Start_Date__c = System.today();
        grgr1.End_Date__c = System.today().addMonths(2);
        grgr1.Global_Rewards_Group__c = grg.Id;
        grgr1.Child_Account__c = a1.Id;
        grgrList.add(grgr1);

        grgr2.Start_Date__c = System.today();
        grgr2.End_Date__c = System.today().addMonths(2);
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Child_Account__c = a2.Id;
        grgrList.add(grgr2);

        insert grgrList;

        /*grg.Status__c = 'Active';
        update grg;*/

        Global_Rewards_Group__c grg1 = [Select id, Status__c, Tier_Agreement_type__c from Global_Rewards_Group__c where Name = 'GRG Test'];
        System.assertEquals(grg1.Status__c, 'Active');
        System.assertEquals(grg1.Tier_Agreement_Type__c, null);

        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;

        //below part commented by Vikhyat on 08/21/2019 just for running the test class
        /*VSPR31_AgreementType at = new VSPR31_AgreementType();*/

        VSPR31_TierAgreementTypePracticeAccount at = new VSPR31_TierAgreementTypePracticeAccount();
        Id id2 = Database.executeBatch(at);
       


        /*grgList = VSPR31_AgreementType.AgreementTypeCalculation(new List<Global_Rewards_Group__c>{grg1});

        System.assertEquals(grgList.get(0).Tier_Agreement_Type__c, 'DOLP4');

        System.debug(VSPR31_AgreementType.AgreementTypeCalculation(grgList));*/


    }




}