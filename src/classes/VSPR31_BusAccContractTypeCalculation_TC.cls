@isTest public class VSPR31_BusAccContractTypeCalculation_TC {

    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();

    //Test methods for the scerios when Location Type == X - Client Authorized Location (GAP)

    //Testing for Provider Catergory is PVCO - Corp Managed Pearle Vision
    public static testmethod void testMethod1(){

        Account acc = new Account();
        acc.Name = 'Practice Test Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        Account a = new Account();
        a.Name = 'Testing Account';
        a.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a.Vision_Care_Good_Standing__c = true;
        a.Provider_Category__c = 'PVCO - Corp Managed Pearle Vision';
        a.Parent_Company__c = 'PERL - Pearle Vision Location';
        a.recordTypeID = businessRecordTypeID;
        a.ParentId = acc.id;
        a.Vision_Care_Effective_Date__c = System.today().addDays(-1);
        a.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a;

        //System.debug(a);


        Account a1 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a1.Contract_Type__c, 'GAP');
        //System.debug(a1);

        a1.Provider_Category__c = null;
        a1.Parent_Company__c = null;

        update a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a2.Contract_Type__c, 'GAP');

        a2.Parent_Company__c = 'COHN - Cohen\'s Fashion Optical';
        a2.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        //a2.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';

        update acc;
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a3.Contract_Type__c, 'Not Supported');

        a3.Parent_Company__c = 'COST - Costco Location';
        a3.Vision_Care_Location_Exception__c = null;
        //a3.Vision_Care_Practice_Exception__c = null;
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;
        update a3;

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a4.Contract_Type__c, 'Not Supported');

        //a4.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;
        //update a4;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a5.Contract_Type__c, null);

        a5.Parent_Company__c = 'FEGV - For Eyes Grand Vision';
        update a5;

        Account a6 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a6.Contract_Type__c, null);

        //a6.Vision_Care_Practice_Exception__c = null;
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;
        //update a6;

        Account a7 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a7.Contract_Type__c, 'GAP');

        a7.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a7;

        Account a8 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a8.Contract_Type__c, null);

        a8.Vision_Care_Good_Standing__c = false;
        update a8;

        Account a9 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a9.Contract_Type__c, null);

        a9.Vision_Care_Good_Standing__c = true;
        a9.Provider_Category__c = 'AOP - Approved OON Provider';
        update a9;

        Test.startTest();

        Account a10 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        //System.debug(a10);
        System.assertEquals(a10.Contract_Type__c, 'AOP');

        a10.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        update a10;

        Account a11 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a11.Contract_Type__c, 'AOP');

        a11.Parent_Company__c = null;
        update a11;

        Account a12 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a12.Contract_Type__c, null);

        a12.Provider_Category__c = 'CAT2 - Non-Standard Ownership Model';
        update a12;

        Account a13 = [Select id, Contract_Type__c from Account where Name = 'Testing Account'];
        System.assertEquals(a13.Contract_Type__c, null);

        Test.stopTest();

    }


    //Condition when the business account created is not in good standing.
    //Condition when an exsiting business account record details is updated but the business account is not in good standing.
    public static testmethod void testMethod2(){

        Account a1 = new Account();
        a1.Name = 'Testing Account 2';
        a1.Location_Type__c = 'X - Client Authorized Location (GAP)';
        a1.Vision_Care_Good_Standing__c = false;
        a1.Provider_Category__c = 'AOP - Approved OON Provider';
        a1.Parent_Company__c = 'PERL - Pearle Vision Location';
        a1.recordTypeID = businessRecordTypeID;
        a1.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Testing Account 2'];
        System.assertEquals(a2.Contract_Type__c, null);

        a2.Location_Type__c = 'M - VSP Member Location';
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Testing Account 2'];
        System.assertEquals(a3.Contract_Type__c, null);

        //a3.Vision_Care_Good_Standing__c = true;

        //List<Account> accList = new List<Account>();

        Account a4 = new Account();
        a4.Name = 'Practice Test Account 1';
        a4.recordTypeId = practiceRecordTypeID;
        a4.Vision_Care_Good_Standing__c = true;

        insert a4;

        Account a6 = [Select id from Account where Name = 'Practice Test Account 1'];

        a3.ParentId = a6.id;
        a3.Vision_Care_Good_Standing__c = true;
        update a3;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Testing Account 2'];
        System.assertEquals(a5.Contract_Type__c, null);

        Account a7 = new Account();
        a7.Name = 'Business Test Account 1';
        a7.Location_Type__c = 'M - VSP Member Location';
        a7.Vision_Care_Good_Standing__c = true;
        a7.Provider_Category__c = 'AOP - Approved OON Provider';
        a7.Parent_Company__c = 'OCNB - Near-site Clinic Location, VSP';
        a7.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
        a7.ParentId = a6.id;
        a7.recordTypeId = businessRecordTypeID;
        a7.Vision_Care_Effective_Date__c = System.today();
        a7.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a7;

        Account a8 = [Select id, Contract_Type__c from Account where Name = 'Business Test Account 1'];
        System.assertEquals(a8.Contract_Type__c, 'Not Supported');

        a6.name = 'Practice Test Account 12';
        update a6;

        Account a9 = [Select id, Contract_Type__c from Account where Name = 'Business Test Account 1'];
        System.assertEquals(a9.Contract_Type__c, 'Not Supported');

        a6.Vision_Care_Good_Standing__c = false;
        update a6;

        Account a12 = [Select id from Account where Name = 'Practice Test Account 12'];

        Account a10 = new Account();
        a10.Name = 'Business Test Account 2';
        a10.Location_Type__c = 'M - VSP Member Location';
        a10.Vision_Care_Good_Standing__c = true;
        a10.Provider_Category__c = 'AOP - Approved OON Provider';
        a10.recordTypeId = businessRecordTypeID;
        a10.ParentId = a12.id;
        a10.Vision_Care_Effective_Date__c = System.today();
        a10.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a10;

        Account a11 = [Select id, Contract_Type__c from Account where Name = 'Business Test Account 2'];
        System.assertEquals(a11.Contract_Type__c, null);

    }


    //Testing for scenarios when Location Type == A - Affiliate Provider Location
    public static testMethod void testMethod3(){

        Account acc = new Account();
        acc.Name = 'Practice Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        //Testing scenarios when Provider Category == AOP - Approved OON Provider
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.ParentId = acc.id;
        a1.Location_Type__c = 'A - Affiliate Provider Location';
        a1.Vision_Care_Good_Standing__c = true;
        a1.Provider_Category__c = 'AOP - Approved OON Provider';
        a1.Parent_Company__c = 'PERL - Pearle Vision Location';
        a1.recordTypeID = businessRecordTypeID;
        a1.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1; 

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a2.Contract_Type__c, 'AOP');

        a2.Parent_Company__c = null;
        a2.Vision_Care_Location_Exception__c = null;
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a3.Contract_Type__c, 'AOP');

        a3.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        update a3;

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a4.Contract_Type__c, null);

        //Testing for scenarios when Provider Category == 'AOP - Approved OON Provider ends'.


        //Checking for scenarios when Provider Category == 'OFPCS - Pearle Vision Corp Sublease Holder'
        a4.Provider_Category__c = 'OFPCS - Pearle Vision Corp Sublease Holder';
        //a4.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;
        update a4;

        Account a5 = [select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a5.Contract_Type__c, 'Not Supported');

        a5.Vision_Care_Location_Exception__c = null;
        update a5;

        Account a6 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a6.Contract_Type__c, null);

        a6.Parent_Company__c = 'PERL - Pearle Vision Location';
        update a6;

        Account a7 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a7.Contract_Type__c, 'Not Supported');

        Test.startTest();

        //a7.Vision_Care_Practice_Exception__c = null;
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;
        //update a7;

        Account a8 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a8.Contract_Type__c, 'Not Supported');

        a8.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a8;

        Account a9 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a9.Contract_Type__c, 'Not Supported');

        //a9.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;
        //update a9;
        
        Account a10 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a10.Contract_Type__c, null);

        //Testing for scenarios when provider category == 'OFPCS - Pearle Vision Corp Sublease Holder' ends.

        //System.debug(a10);

        //Checking for scenarios when Provider Category == 'OFPLS - Pearle Vision L.O Sublease Holder'
        a10.Provider_Category__c = 'OFPLS - Pearle Vision L.O Sublease Holder';
        update a10;

        Account a11 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a11.Contract_Type__c, null);

        //a11.Vision_Care_Practice_Exception__c = null;
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;
        //update a11;

        Account a12 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a12.Contract_Type__c, 'Not Supported');

        a12.Parent_Company__c = null;
        update a12;

        Test.stopTest();

        //Test.startTest();

        Account a13 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a13.Contract_Type__c, 'Not Supported');

        acc.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        //a13.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        //update a13;
        update acc;

        Account a14 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a14.Contract_Type__c, null);

        a14.Parent_Company__c = 'PERL - Pearle Vision Location';
        update a14;

        //Test.startTest();

        Account a15 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a15.Contract_Type__c, null);

        //a15.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;
        //update a15;

        Account a16 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a16.Contract_Type__c, 'Not Supported');

        a16.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        update a16;

        Account a17 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a17.Contract_Type__c, null);

        //a17.Vision_Care_Practice_Exception__c = null;
        acc.Vision_Care_Practice_Exception__c = null;
        //update a17;
        update acc;

        Account a18 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a18.Contract_Type__c, 'Not Supported');
        System.debug(a18);

        //Testing for scenarios when provider category == 'OFPLS - Pearle Vision L.O Sublease Holder' ends.

        //System.debug(a18);

    }

    //Testing for scenarios when Location Type == A - Affiliate Provider Location
    //Continued scenarios
    public static testmethod void testMethod4(){

        Account acc = new Account();
        acc.Name = 'Practice Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        //Checking for scenarios when Provider Category == null
        Account a1 = new Account();
        a1.recordTypeId = businessRecordTypeID;
        a1.Name = 'Test Account';
        a1.Vision_Care_Good_Standing__c = true;
        a1.Location_Type__c = 'A - Affiliate Provider Location';
        a1.Provider_Category__c = null;
        a1.Parent_Company__c = 'COHN - Cohen\'s Fashion Optical';
        a1.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        a1.ParentId = acc.id;
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a19 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a19.Contract_Type__c, 'Affiliate');

        a19.Vision_Care_Location_Exception__c = null;
        update a19;

        Account a20 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a20.Contract_Type__c, 'Affiliate');//Updated by Vikhyat on 08/09/2019

        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;
        //a20.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        //update a20;

        Account a21 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a21.Contract_Type__c, 'Affiliate');

        a21.Parent_Company__c = 'CVS - CVS Location';
        update a21;

        Account a22 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a22.Contract_Type__c, 'Affiliate');

        a22.Parent_Company__c = null;
        update a22;

        Account a23 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a23.Contract_Type__c, null);

        acc.Vision_Care_Practice_Exception__c = null;
        update acc;
        //a23.Vision_Care_Practice_Exception__c = null;
        //update a23;

        Account a24 = [Select id, Contract_Type__c from Account where Name  = 'Test Account'];
        System.assertEquals(a24.Contract_Type__c, 'Affiliate');

        a24.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a24;

        Account a25 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a25.Contract_Type__c, null);

        a25.Provider_Category__c = 'CAT2 - Non-Standard Ownership Model';
        update a25;

        Account a26 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a26.Contract_Type__c, null);

        //Testing for scenarios when provider category == null ends.


    }

    //Testing for scenarios when Location Type == F - Laser Vision Correction (LVC)
    public static testMethod void testMethod5(){

        Account acc = new Account();
        acc.Name = 'Practice Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        //Scenarios when Provider Category == Any
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.Location_Type__c = 'F - Laser Vision Correction (LVC)';
        a1.Provider_Category__c = 'CAT2 - Non-Standard Ownership Model';
        a1.Vision_Care_Good_Standing__c = true;
        a1.recordTypeId = businessRecordTypeID;
        a1.ParentId = acc.id;
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a2.Contract_Type__c, 'Not Supported');

        a2.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a3.Contract_Type__c, null);
        //Testing for scenarios when Provider Category == Any ends.


        //Scenrios when Provider Category == null
        a3.Provider_Category__c = null;
        update a3;

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a4.Contract_Type__c, 'Not Supported');

        a4.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        update a4;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a5.Contract_Type__c, null);

        a5.Parent_Company__c = null;
        update a5;

        Account a6 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a6.Contract_Type__c, 'LVC');

        //Testing for scenarios when Provider Category == null ends.

    }


    //Testing for scenarios when Location Type == 'M - VSP Member Location'
    public static testmethod void testMethod6(){

        Account acc = new Account();
        acc.Name = 'Practice Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        //Scenarios when Provider Category == null
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.Location_Type__c = 'M - VSP Member Location';
        a1.Vision_Care_Good_Standing__c = true;
        a1.recordTypeId = businessRecordTypeID;
        a1.ParentId = acc.id;
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a2.Contract_Type__c, 'Independent');

        //a2.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        //update a2;
        acc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        update acc;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a3.Contract_Type__c, 'Net Dev Excluded');

        a3.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        update a3;

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a4.Contract_Type__c, 'Net Dev Purchasing Requirement');

        /*a4.Vision_Care_Practice_Exception__c = null;
        update a4;*/
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a5.Contract_Type__c, 'Net Dev Purchasing Requirement');

        a5.Vision_Care_Location_Exception__c = 'COFR - Does not Maintain 200 Frames';
        update a5;

        Account a6 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a6.Contract_Type__c, 'Net Dev Excluded');

        a6.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
        update a6;

        Account a7 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a7.Contract_Type__c, null);

        a7.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a7;

        Account a8 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a8.Contract_Type__c, 'Not Supported');

        a8.Vision_Care_Location_Exception__c = null;
        //a8.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        acc.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        update acc;
        update a8;

        Account a9 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a9.Contract_Type__c, null);

        a9.Parent_Company__c = 'COHN - Cohen\'s Fashion Optical';
        update a9;

        Account a10 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a10.Contract_Type__c, null);

        /*a10.Vision_Care_Practice_Exception__c = null;
        update a10;*/
        acc.Vision_Care_Practice_Exception__c = null;
        update acc;

        Account a11 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a11.Contract_Type__c, 'Not Supported');

        a11.Parent_Company__c = 'ECCA - ECCA or Visionworks Location';
        update a11;

        Account a12 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a12.Contract_Type__c, 'Visionworks'); //Updated by vikhyat on 10/16/2019 to cover for visionworks conditions.

        Test.startTest();

        a12.Vision_Care_Location_Exception__c = 'COFR - Does not Maintain 200 Frames';
        update a12;

        Account a13 = [select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a13.Contract_Type__c, 'Visionworks'); //updated by vikhyat on 10/16/2019 to cover for visionworks conditions.

        a13.Parent_Company__c = 'OCNB - Near-site Clinic Location, VSP';
        update a13;

        Account a14 = [select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a14.Contract_Type__c, null);
        System.debug(a14);

        a14.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
        update a14;

        Account a15 = [select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a15.Contract_Type__c, 'Near Site');

        a15.Parent_Company__c = 'OCSI - Onsite Clinic Location, VSP';
        update a15;

        Account a16 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a16.Contract_Type__c, 'Onsite');

        a16.Vision_Care_Location_Exception__c = 'COFR - Does not Maintain 200 Frames';
        update a16;

        Account a17 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a17.Contract_Type__c, null);

        a17.Parent_Company__c = 'PERL - Pearle Vision Location';
        update a17;

        Account a18 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a18.Contract_Type__c, null);

        a18.Vision_Care_Location_Exception__c = null;
        update a18;

        Account a19 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a19.Contract_Type__c, 'Pearle Vision LO');

        a19.Parent_Company__c = 'POP - Pop-Up Clinic Location, VSP';
        update a19;

        Account a20 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a20.Contract_Type__c, null);

        a20.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
        update a20;

        Account a21 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a21.Contract_Type__c, 'Pop Up');

        a21.Parent_Company__c = 'VNTR - VSP Ventures';
        update a21;

        Account a22 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a22.Contract_Type__c, null);

        //Testing for scenarios when Provider Category == null ends.


        //Scenarios where Provider Categoy == 'CAT2 - Non-Standard Ownership Model'

        a22.Provider_Category__c = 'CAT2 - Non-Standard Ownership Model';
        a22.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a22;

        Account a23 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a23.Contract_Type__c, 'CAT2');

        a23.Parent_Company__c = 'COHN - Cohen\'s Fashion Optical';
        update a23;

        Account a24 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a24.Contract_Type__c, null);

        //Testing for scenarios when Provider Category == 'CAT2 - Non-Standard Ownership Model' ends


        //Scenarios when Provider Category == 'OFPCS - Pearle Vision Corp Sublease Holder'

        a24.Provider_Category__c = 'OFPCS - Pearle Vision Corp Sublease Holder';
        update a24;

        Account a25 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a25.Contract_Type__c, null);

        a25.Parent_Company__c = null;
        update a25;

        Account a26 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a26.Contract_Type__c, 'Pearle Vision CO'); 

        acc.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        update acc;

        Account a27 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a27.Contract_Type__c, null);

        a27.Parent_Company__c = 'PERL - Pearle Vision Location';
        update a27;

        Account a28 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a28.Contract_Type__c, 'Pearle Vision CO');

        //Testing for scenarios when Provider Category == 'OFPCS - Pearle Vision Corp Sublease Holder' ends.


        Test.stopTest();


    }


    //Testing for scenarios when Location Type == 'M - VSP Member Location'
    //Continued scenarios
    public static testmethod void testMethod7(){
        Account acc = new Account();
        acc.Name = 'Practice Account';
        acc.Vision_Care_Good_Standing__c = true;
        acc.recordTypeId = practiceRecordTypeID;
        insert acc;

        //Scenarios when Provider Category == 'OFPLS - Pearle Vision L.O Sublease Holder'
        Account a1 = new Account();
        a1.recordTypeId = businessRecordTypeID;
        a1.Name = 'Test Account';
        a1.Vision_Care_Good_Standing__c = true;
        a1.Location_Type__c = 'M - VSP Member Location';
        a1.ParentId = acc.id;
        a1.Provider_Category__c = 'OFPLS - Pearle Vision L.O Sublease Holder';
        a1.Parent_Company__c = 'PERL - Pearle Vision Location';
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a2.Contract_Type__c, 'Pearle Vision LO');

        a2.Parent_Company__c = null;
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a3.Contract_Type__c, 'Pearle Vision LO');

        acc.Vision_Care_Practice_Exception__c = 'EFTX - No EFT';
        update acc;

        a3.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
        update a3;

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a4.Contract_Type__c, null);

        a4.Parent_Company__c = 'COHN - Cohen\'s Fashion Optical';
        update a4;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a5.Contract_Type__c, null);

        a5.Provider_Category__c = 'RETL - VSP Retail';
        update a5;

        Account a6 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a6.Contract_Type__c, null);

        a6.Parent_Company__c = null;
        update a6;

        Account a7 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a7.Contract_Type__c, 'VSP Retail');

        a7.Provider_Category__c = 'SCHLS - Optometric School or University';
        update a7;

        Account a8 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a8.Contract_Type__c, 'School');

        a8.Parent_Company__c = 'AEHG- Acuity Eyecare Holding Group';
        update a8;

        Account a9 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a9.Contract_Type__c, null);

        a9.Provider_Category__c = 'VNTR - VSP Ventures';
        update a9;

        Account a10 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a10.Contract_Type__c, null);

        a10.Parent_Company__c = 'JVNTR - Joint Ventures';
        update a10;

        Account a11 = [Select id, Contract_Type__c from Account where Name = 'Test Account'];
        System.assertEquals(a11.Contract_Type__c, 'VSP Ventures');

    }


    /*The following scenarios are testing in the below test class.
        1. Scenario when ParentId is removed from Business Account.
        2. Scenario when a Practice is converted to a Business Account.
        3. Scenario when a Practice is concerted to a Buiness and gets associated to another practice. */

    public static testMethod void testMethod8(){
        Account acc1 = new Account();
        acc1.Name = 'Practice Account 1';
        acc1.Vision_Care_Good_Standing__c = true;
        acc1.recordTypeId = practiceRecordTypeID;
        insert acc1;

        Account acc2 = new Account();
        acc2.Name = 'Practice Account 2';
        acc2.Vision_Care_Good_Standing__c = true;
        acc2.recordTypeId = practiceRecordTypeID;
        insert acc2;

        Account a1 = new Account();
        a1.recordTypeId = businessRecordTypeID;
        a1.Vision_Care_Good_Standing__c = true;
        a1.ParentId = acc2.id;
        a1.Name = 'Test Business Account';
        a1.Location_Type__c = 'M - VSP Member Location';
        a1.Provider_Category__c = 'VNTR - VSP Ventures';
        a1.Parent_Company__c = 'JVNTR - Joint Ventures';
        a1.Vision_Care_Effective_Date__c = System.today();
        a1.Vision_Care_End_Date__c = System.today().addMonths(1);
        insert a1;

        Account a2 = [Select id, Contract_Type__c from Account where Name = 'Test Business Account'];
        System.assertEquals(a2.Contract_Type__c, 'VSP Ventures');

        a2.ParentId = null;
        update a2;

        Account a3 = [Select id, Contract_Type__c from Account where Name = 'Test Business Account'];
        System.assertEquals(a3.Contract_Type__c, null);

        a3.ParentId = acc2.id;
        update a3;

        Account a5 = [Select id, Contract_Type__c from Account where Name = 'Test Business Account'];
        System.assertEquals(a5.Contract_Type__c, 'VSP Ventures');

        acc2.recordTypeId = businessRecordTypeID;
        acc2.ParentId = acc1.id;
        acc2.Location_Type__c = 'M - VSP Member Location';
        acc2.Provider_Category__c = 'VNTR - VSP Ventures';
        acc2.Parent_Company__c = 'JVNTR - Joint Ventures';
        acc2.Vision_Care_Effective_Date__c = System.today();
        acc2.Vision_Care_End_Date__c = System.today().addMonths(1);
        update acc2;

        Account acc3 = [Select id, Contract_Type__c from Account where Name = 'Practice Account 2'];
        System.assertEquals(acc3.Contract_Type__c, 'VSP Ventures');

        Account a4 = [Select id, Contract_Type__c from Account where Name = 'Test Business Account'];
        System.assertEquals(a4.Contract_Type__c, null);

        acc1.recordTypeId = businessRecordTypeID;
        update acc1;

        List<Account> accList = [Select id, Contract_Type__c from Account where Name = 'Practice Account 1' or Name = 'Practice Account 2'];

        for(Account a: accList){
            System.assertEquals(a.Contract_Type__c, null);
        }

    }

}