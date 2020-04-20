@isTest
public class VSPR34_FfaaNodis_Test {
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Id contractTypeGrgRecordTypeID = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
    private static final Date todayDate = System.today();

    @IsTest
    static void testmethod1(){
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = todayDate;
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        /*Account pracAcc = [Select id, VC__c from Account where recordTypeId = :practiceRecordTypeID and id = :p1.Id];
        System.assertEquals(pracAcc.VC__c, true);*/

        Account b1 = new Account();
        b1.Name = 'Business Test Account 1';
        b1.Vision_Care_Effective_Date__c = todayDate;
        b1.Vision_Care_End_Date__c = todayDate.addYears(1);
        b1.ParentId = p1.Id;
        b1.recordTypeId = businessRecordTypeID;
        b1.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        //test.startTest();   
        insert b1;
        
        Account baRec = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c 
                         FROM Account 
                         WHERE Id =: b1.Id];
        
        //test.stopTest();
        
        //system.assertEquals(null, baRec.Participation_Exclusions__c);
        system.assertEquals(true, baRec.VC__c);
        system.assertEquals(false, baRec.Free_Fitting_and_Adjustments__c);

        Account b2 = new Account();
        b2.Name = 'Business Test Account 2';
        b2.Vision_Care_Effective_Date__c = todayDate;
        b2.Vision_Care_End_Date__c = todayDate.addYears(1);
        b2.ParentId = p1.Id;
        b2.recordTypeId = businessRecordTypeID;
        b1.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        //test.startTest();   
        insert b2;

        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = contractTypeGrgRecordTypeID;
        insert grg;

        List<Global_Rewards_Group_Relationship__c> grgrList = new List<Global_Rewards_Group_Relationship__c>();

        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Start_Date__c = todayDate;
        grgr1.Global_Rewards_Group__c = grg.Id;
        grgr1.Child_Account__c = b1.Id;
        grgrList.add(grgr1);

        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Start_Date__c = todayDate;
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Child_Account__c = b2.Id;
        grgrList.add(grgr2);
        
        insert grgrList;

        //System.debug(grgrList);
        /*List<Global_Rewards_Group_Relationship__c> grgrList1 = [Select id, Status__c from Global_Rewards_Group_Relationship__c];
        System.debug(grgrList1);*/

        b2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        update b2;

        Account b3 = [SELECT Id, Name, Exclusive_VSP_Patient_Offers__c, VC__c, Free_Fitting_and_Adjustments__c 
                         FROM Account 
                         WHERE Id =: b2.Id];

        system.assertEquals(true, b3.VC__c);
        system.assertEquals(false, b3.Exclusive_VSP_Patient_Offers__c);
        system.assertEquals(false, b3.Free_Fitting_and_Adjustments__c);

        Global_Rewards_Group__c grg1 = [Select id, Exclusive_VSP_Patient_Offers__c, Free_Fitting_and_Adjustments__c from Global_Rewards_Group__c where Id = :grg.Id];
        System.assertEquals(false, grg1.Free_Fitting_and_Adjustments__c);
        System.assertEquals(false, grg1.Exclusive_VSP_Patient_Offers__c);

        
        b1.Participation_Exclusions__c = 'NODIS – Opts out of discounts; NOFFAA – Opts out of free fittings and adjustments';
        update b1;
        

    }

    @IsTest
    static void testmethod2(){
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = todayDate.addDays(1);
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        /*Account pracAcc = [Select id, VC__c from Account where recordTypeId = :practiceRecordTypeID and id = :p1.Id];
        System.assertEquals(pracAcc.VC__c, true);*/

        Account b1 = new Account();
        b1.Name = 'Business Test Account 1';
        b1.Vision_Care_Effective_Date__c = todayDate;
        b1.Vision_Care_End_Date__c = todayDate.addYears(1);
        b1.ParentId = p1.Id;
        b1.recordTypeId = businessRecordTypeID;
        b1.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        //test.startTest();   
        insert b1;

        p1.Vision_Care_Effective_Date__c = System.today();
        update p1;

        Account b2 = new Account();
        b2.Name = 'Business Test Account 1';
        b2.Vision_Care_Effective_Date__c = todayDate;
        b2.Vision_Care_End_Date__c = todayDate.addYears(1);
        b2.ParentId = p1.Id;
        b2.recordTypeId = businessRecordTypeID;
        b2.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        //test.startTest();   
        insert b2;

        b1.Participation_Exclusions__c = null;
        update b1;

        b2.Participation_Exclusions__c = null;
        update b2;

        b1.Vision_Care_Effective_Date__c = System.today().addDays(1);
        b2.Vision_Care_Effective_Date__c = System.today().addDays(1);
        update b1;
        update b2;

        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = contractTypeGrgRecordTypeID;
        insert grg;

        List<Global_Rewards_Group_Relationship__c> grgrList = new List<Global_Rewards_Group_Relationship__c>();

        grgrList.add(new Global_Rewards_Group_Relationship__c(Child_Account__c = b1.Id, Start_Date__c = System.today(), Global_Rewards_Group__c = grg.Id));
        grgrList.add(new Global_Rewards_Group_Relationship__c(Child_Account__c = b2.Id, Start_Date__c = System.today(), Global_Rewards_Group__c = grg.Id));
        grgrList.add(new Global_Rewards_Group_Relationship__c(Child_Account__c = p1.Id, Start_Date__c = System.today(), Global_Rewards_Group__c = grg.Id));
        
        insert grgrList;

        /*List<Global_Rewards_Group_Relationship__c> grgrList1 = [Select id, Child_Account__r.recordTypeId, Status__c from Global_Rewards_Group_Relationship__c where Global_Rewards_Group__c = :grg.Id];
        System.debug(grgrList1);*/

        b1.Vision_Care_Effective_Date__c = System.today();
        b2.Vision_Care_Effective_Date__c = System.today();
        update b1;
        update b2;

        List<Account> accList = [Select id, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, VC__c from Account where id = :b1.Id or id = :b2.Id];
        for(Account a: accList){
            //System.debug(a);
            System.assertEquals(true, a.VC__c);
        }

        b1.Participation_Exclusions__c = 'NODIS – Opts out of discounts';
        b1.Free_Fitting_and_Adjustments__c = true;
        update b1;

        Account p2 = [Select id, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, VC__c from Account where id = :p1.Id];
        /*System.assertEquals(true, p2.Free_Fitting_and_Adjustments__c);
        System.assertEquals(false, p2.Exclusive_VSP_Patient_Offers__c);*/
        
    }
}