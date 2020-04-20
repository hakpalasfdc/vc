@isTest public class VSPR33_RetinalImagingIndicatorTest {
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Id contractTypeGrgRecordTypeID = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
    private static final Date todayDate = System.today();

    @IsTest
    static void testMethod1(){

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
        b1.Service_Offering_s__c = 'CCLOC - CareCredit Program Participant;RTLIM - Retinal Imaging';
        insert b1;

        Account b2 = new Account();
        b2.Name = 'Business Test Account 2';
        b2.Vision_Care_Effective_Date__c = todayDate;
        b2.ParentId = p1.Id;
        b2.recordTypeId = businessRecordTypeID;
        insert b2;

        Global_Rewards_Group__c grg1 = new Global_Rewards_Group__c();
        grg1.recordTypeId = contractTypeGrgRecordTypeID;
        insert grg1;

        List<Global_Rewards_Group_Relationship__c> grgrList = new List<Global_Rewards_Group_Relationship__c>();

        Global_Rewards_Group_Relationship__c grgr1 = new Global_Rewards_Group_Relationship__c();
        grgr1.Start_Date__c = todayDate;
        grgr1.Global_Rewards_Group__c = grg1.Id;
        grgr1.Child_Account__c = b1.Id;
        grgrList.add(grgr1);

        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Start_Date__c = todayDate;
        grgr2.Global_Rewards_Group__c = grg1.Id;
        grgr2.Child_Account__c = b2.Id;
        grgrList.add(grgr2);

        insert grgrList;

        b2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        update b2;

        Account pracAcc = [Select id, VC__c, Retinal_Imaging_Indicator__c from Account where recordTypeId = :practiceRecordTypeID and id = :p1.Id];
        System.assertEquals(pracAcc.VC__c, true);
        //System.assertEquals(pracAcc.Retinal_Imaging_Indicator__c, true);

        List<Account> busAccList = [Select id, VC__c, Retinal_Imaging_Indicator__c from Account where recordTypeId = :businessRecordTypeID and (id = :b1.Id or id = :b2.Id)];
        for(Account a: busAccList){
            System.assertEquals(a.VC__c, true);
            System.assertEquals(a.Retinal_Imaging_Indicator__c, true);
        }

        Global_Rewards_Group__c grg = [Select id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where iD = :grg1.Id];
        //System.assertEquals(grg.Retinal_Imaging_Indicator_Future__c, true);

        b2.Service_Offering_s__c = 'CVLKT - CIGNA Luxottica Collection';
        update b2;

        Account b3 = [Select id, Retinal_Imaging_Indicator__c from Account where Id = :b2.Id];
        System.assertEquals(b3.Retinal_Imaging_Indicator__c, false);

        b1.Service_Offering_s__c = null;
        update b1;

        Account b4 = [Select id, Retinal_Imaging_Indicator__c from Account where id = :b1.Id];
        System.assertEquals(b4.Retinal_Imaging_Indicator__c, false);

        p1.Vision_Care_Effective_Date__c = todayDate.addDays(1);
        update p1;

        p1.Vision_Care_Effective_Date__c = todayDate;
        update p1;
        
    }

    @IsTest
    static void testMethod2(){
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = todayDate.addDays(-10);
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        /*Account pracAcc = [Select id, VC__c from Account where recordTypeId = :practiceRecordTypeID and id = :p1.Id];
        System.assertEquals(pracAcc.VC__c, true);*/

        Account b1 = new Account();
        b1.Name = 'Business Test Account 1';
        b1.Vision_Care_Effective_Date__c = todayDate.addDays(-9);
        //b1.Vision_Care_End_Date__c = todayDate.addYears(1);
        b1.ParentId = p1.Id;
        b1.recordTypeId = businessRecordTypeID;
        b1.Service_Offering_s__c = 'CCLOC - CareCredit Program Participant;RTLIM - Retinal Imaging';
        insert b1;

        p1.Vision_Care_End_Date__c = todayDate.addDays(-1);
        update p1;

        b1.Vision_Care_End_Date__c = todayDate.addDays(-1);
        update b1;
        
    }
}