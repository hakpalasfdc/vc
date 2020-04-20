@isTest public class VSPR33_RetinalImagingGrgBatch_Test {
    
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Id contractTypeGrgRecordTypeID = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
    private static final Date todayDate = System.today();

    @IsTest
    static void testMethod1(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = todayDate;
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        Account b1 = new Account();
        b1.Name = 'Business Test Account 1';
        b1.Vision_Care_Effective_Date__c = todayDate;
        b1.Vision_Care_End_Date__c = todayDate.addYears(1);
        b1.ParentId = p1.Id;
        b1.recordTypeId = businessRecordTypeID;
        b1.Service_Offering_s__c = 'CCLOC - CareCredit Program Participant;RTLIM - Retinal Imaging';
        b1.Vision_Care_Good_Standing__c = true;
        insert b1;

        Account b2 = new Account();
        b2.Name = 'Business Test Account 2';
        b2.Vision_Care_Effective_Date__c = todayDate;
        b2.ParentId = p1.Id;
        b2.recordTypeId = businessRecordTypeID;
        b2.Vision_Care_Good_Standing__c = true;
        insert b2;

        Global_Rewards_Group__c grg1 = new Global_Rewards_Group__c();
        grg1.recordTypeId = contractTypeGrgRecordTypeID;
        grg1.Start_Date__c = todayDate;
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

        Global_Rewards_Group__c grg2 = [Select Id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where id = :grg1.Id];
        System.assertEquals(grg2.Retinal_Imaging_Indicator_Future__c, true);

        grg2.Retinal_Imaging_Indicator_Future__c = false;
        update grg2;

        Test.startTest();
        VSPR33_RetinalImagingGrgBatch job = new VSPR33_RetinalImagingGrgBatch();
        Database.executeBatch(job);
        Test.stopTest();

        Global_Rewards_Group__c grg3 = [Select Id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where id = :grg1.Id];
        System.assertEquals(grg3.Retinal_Imaging_Indicator_Future__c, true);

    }

    @IsTest
    static void testMethod2(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Account p1 = new Account();
        p1.Name = 'Practice Test Account';
        p1.Vision_Care_Effective_Date__c = todayDate;
        p1.recordTypeId = practiceRecordTypeID;
        insert p1;

        Account b1 = new Account();
        b1.Name = 'Business Test Account 1';
        b1.Vision_Care_Effective_Date__c = todayDate;
        b1.Vision_Care_End_Date__c = todayDate.addYears(1);
        b1.ParentId = p1.Id;
        b1.recordTypeId = businessRecordTypeID;
        b1.Service_Offering_s__c = 'CCLOC - CareCredit Program Participant';
        b1.Vision_Care_Good_Standing__c = true;
        insert b1;

        Account b2 = new Account();
        b2.Name = 'Business Test Account 2';
        b2.Vision_Care_Effective_Date__c = todayDate;
        b2.ParentId = p1.Id;
        b2.recordTypeId = businessRecordTypeID;
        b2.Vision_Care_Good_Standing__c = true;
        insert b2;

        Global_Rewards_Group__c grg1 = new Global_Rewards_Group__c();
        grg1.recordTypeId = contractTypeGrgRecordTypeID;
        grg1.Start_Date__c = todayDate;
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

        /*b2.Service_Offering_s__c = 'RTLIM - Retinal Imaging';
        update b2;*/

        Global_Rewards_Group__c grg2 = [Select Id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where id = :grg1.Id];
        System.assertEquals(grg2.Retinal_Imaging_Indicator_Future__c, false);

        grg2.Retinal_Imaging_Indicator_Future__c = true;
        update grg2;

        Test.startTest();
        VSPR33_RetinalImagingGrgBatch job = new VSPR33_RetinalImagingGrgBatch();
        Database.executeBatch(job);
        Test.stopTest();

        Global_Rewards_Group__c grg3 = [Select Id, Retinal_Imaging_Indicator_Future__c from Global_Rewards_Group__c where id = :grg1.Id];
        System.assertEquals(grg3.Retinal_Imaging_Indicator_Future__c, false);

    }
}