@isTest
public class VSPR34_FFAA_Update_Test {

    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    
    @TestSetup
    static void testData(){
        
        
        Account pa = new Account();
        pa.RecordTypeId = practiceRecordTypeID;
        pa.Name = 'Practice1Account';
        pa.Status__c = 'A';
        pa.Vision_Care_Effective_Date__c = Date.today();
        
        insert pa;
        
        Account ba = new Account();
        ba.RecordTypeId = businessRecordTypeID;
        ba.Name = 'Business1Account';
        ba.Status__c = 'A';
        ba.Vision_Care_Effective_Date__c = Date.today();
        ba.ParentId = pa.Id;
        ba.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        
        insert ba;
        
        Account ba1 = new Account();
        ba1.RecordTypeId = businessRecordTypeID;
        ba1.Name = 'Business2Account';
        ba1.Status__c = 'A';
        ba1.Vision_Care_Effective_Date__c = Date.today();
        ba1.ParentId = pa.Id;
        
        insert ba1;
        
        Account ba2 = new Account();
        ba2.RecordTypeId = businessRecordTypeID;
        ba2.Name = 'Business3AccountVCFalse';
        ba2.Status__c = 'A';
        
        insert ba2;
    }    
    public static testmethod void baInsertNoParticipationExclusionTest(){
        
        Account pa = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, RecordTypeId 
                      FROM Account 
                      WHERE RecordTypeId =: practiceRecordTypeID 
                      AND Name = 'Practice1Account'];
        
        Account ba = new Account();
        ba.RecordTypeId = businessRecordTypeID;
        ba.Name = 'Business1Account';
        ba.Status__c = 'A';
        ba.Vision_Care_Effective_Date__c = Date.today();
        ba.ParentId = pa.Id;
        ba.Participation_Exclusions__c = null;
        
        test.startTest();   
        insert ba;
        
        Account baRec = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c 
                         FROM Account 
                         WHERE Id =: ba.Id];
        
        test.stopTest();
        
        system.assertEquals(null, baRec.Participation_Exclusions__c);
        system.assertEquals(true, baRec.VC__c);
        system.assertEquals(true, baRec.Free_Fitting_and_Adjustments__c);
    }
    
    
    public static testmethod void baUpdateToHaveValueOfAMCDTest(){
        
                
        List<Account> baList = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, ParentId 
                                FROM Account 
                                WHERE ParentId != null AND RecordTypeID =: businessRecordTypeID AND Name = 'Business2Account'];
        List<Account> baToUpd = new List<Account>();
        
        for(Account baL: baList){
            if(!baList.isEmpty()){
                //system.debug('TEST baL VC: ' + baL.VC__c);
                //system.debug('TEST baL ParentId: ' + baL.ParentId);
                //system.debug('TEST Participation Exclusions: ' + baL.Participation_Exclusions__c);
                if(baL.VC__c == true){
                    //Update Participation Exclusions to only have ADMCD – Opts out of Medicaid All Doctors in it's value
                    baL.Participation_Exclusions__c = 'ADMCD – Opts out of Medicaid All Doctors';
                }
            }
            baToUpd.add(baL);
        }
        //system.debug('TEST baToUpd: ' + baToUpd);
        if(!baToUpd.isEmpty()){
            test.startTest();
            //Commented below by Vikhyat
            //VSPR34_FFAA_Update.VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = True;
            update baToUpd;
            
        }
        
        Account baList1 =[SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, ParentId 
                          FROM Account 
                          WHERE ParentId != null AND RecordTypeID =: businessRecordTypeID AND Name = 'Business1Account'];
        
        Account paList = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, RecordTypeId
                          FROM Account 
                          WHERE RecordTypeID =: practiceRecordTypeID AND Id =: baList1.ParentId];
        
        test.stopTest();
        //system.debug('TEST2 VC__c: ' + baList1.VC__c);
        //system.debug('TEST2 ParentId: ' + baList1.ParentId);
        //system.debug('TEST2 Participation Exclusions: ' + baList1.Participation_Exclusions__c);
        system.assertNotEquals(null, baList1);
        //System.assertEquals(true, paList.Free_Fitting_and_Adjustments__c);
    }
    public static testmethod void baUpdateVCFalseTest(){
        
        Account ba = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, ParentId 
                          FROM Account 
                          WHERE RecordTypeID =: businessRecordTypeID AND Name = 'Business3AccountVCFalse']; 
        Test.startTest();
        ba.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments;NODIS – Opts out of discounts';
        //Commented below by Vikhyat on 01/26/2020
        //VSPR34_FFAA_Update.VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = True;
        update ba;
        Test.stopTest();
        Account baUpd = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, RecordTypeId 
                         FROM Account 
                         WHERE Id =: ba.Id];
        
        system.assertEquals(true, baUpd.Free_Fitting_and_Adjustments__c);
        system.assertEquals(false, baUpd.Exclusive_VSP_Patient_Offers__c);
        system.assertEquals(false, baUpd.VC__c);
    }
    public static testMethod void baUpdatePaUpdateGRGUpdateTest(){
        
        Account pa = new Account();
        pa.RecordTypeId = practiceRecordTypeID;
        pa.Name = 'Practice1AccountGRG';
        pa.Status__c = 'A';
        pa.Vision_Care_Effective_Date__c = Date.today();
        
        insert pa;
        
        Account ba = new Account();
        ba.RecordTypeId = businessRecordTypeID;
        ba.Name = 'Business1AccountGRG';
        ba.Status__c = 'A';
        ba.Vision_Care_Effective_Date__c = Date.today();
        ba.ParentId = pa.Id;
        ba.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        
        insert ba;
        
        Account ba1 = new Account();
        ba1.RecordTypeId = businessRecordTypeID;
        ba1.Name = 'Business2AccountGRG';
        ba1.Status__c = 'A';
        ba1.Vision_Care_Effective_Date__c = Date.today();
        ba1.ParentId = pa.Id;
        
        insert ba1;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.Name = 'GRGFFAUPDATE';
        grg.Start_Date__c = Date.today();
        
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c ();
        grgr.Child_Account__c = ba.Id;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = Date.today();
        
        insert grgr;
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c ();
        grgr2.Child_Account__c = ba1.Id; 
        grgr2.Global_Rewards_Group__c = grg.Id;
        grgr2.Start_Date__c = Date.today();
        
        insert grgr2;
        test.startTest();
        //Update the Accounts because of recursion we have to reset recursion to true then update.
        ba1.Participation_Exclusions__c = 'NOFFAA – Opts out of free fittings and adjustments';
        //Commented by Vikhyat on 01/26/2020
        //VSPR34_FFAA_Update.VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = True;
        update ba1;
        
        ba.Participation_Exclusions__c = null;
        //Commented out by Vikhayt on 01/26/2020
        //VSPR34_FFAA_Update.VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = True;
        update ba;
        
        test.stopTest();

        Account paUpd = [SELECT Id, Name, Participation_Exclusions__c, VC__c, Free_Fitting_and_Adjustments__c, RecordTypeId 
                         FROM Account 
                         WHERE Id =: pa.id];

        Global_Rewards_Group__c grgUpd = [SELECT Id, Free_Fitting_and_Adjustments__c
                                          FROM Global_Rewards_Group__c
                                          WHERE Id =: grg.Id];
        system.assertEquals(false, paUpd.Free_Fitting_and_Adjustments__c);
        system.assertEquals(false, grgUpd.Free_Fitting_and_Adjustments__c);
    }

}