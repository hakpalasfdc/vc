@isTest
public class VSPR28_CalculateFinalScoreExtension_Test {
    @testSetup 
    static void testData(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();

        //Create Account
        Account pracAcc = new Account();
        pracAcc.RecordTypeId = accRecordTypeId;
        pracAcc.Name = 'Practice Account';
        insert pracAcc;

        //Create Contact
        Contact con = new Contact();
        con.RecordTypeId = conRecordTypeId;
        con.AccountId = pracAcc.Id;
        con.Status__c = 'Active';
        con.FirstName = 'FName';
        con.LastName = 'LName';
        insert con;

        //Create Contact Role
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = pracAcc.Id;
        cr.Contact__c = con.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Status__c = 'Active';
        cr.Start_Date__c = Date.today();
        cr.Active_or_Future_Vision_Care_Relationshi__c = True;
        Test.startTest();
        insert cr;
        Test.stopTest();

        //Create General Table
        General_Table__c gt = new General_Table__c();
        gt.Name = 'VSP';
        gt.Table__c = 'PRSP';        
        insert gt;

        //Create QA Review
        QA_Review__c qaReview = new QA_Review__c();
        qaReview.Contact_Role__c = cr.Id;
        qaReview.Provider_Name__c = con.Id;
        qaReview.Vision_Care_Location_Key__c = '123456789';
        qaReview.Review_Date_Scheduled__c = Date.today().addMonths(-130);
        qaReview.Review_Received_Date__c = Date.today().addMonths(-130);
        insert qaReview;

        //Create QA Patient Review 1
        QA_Patient_Review__c qaPatRec1 = new QA_Patient_Review__c();
        qaPatRec1.QA_Review_Number__c = qaReview.Id;
        qaPatRec1.Patient_First_Name__c = 'qaPatFName1';
        qaPatRec1.Patient_Last_Name__c = 'qaPatLName1';
        qaPatRec1.Relationship_to_Member__c = 'Member';
        qaPatRec1.Patient_Age__c = 20;
        qaPatRec1.Member_First_Name__c = 'memberFName1';
        qaPatRec1.Member_Last_Name__c = 'memberLName1';
        qaPatRec1.Patient_Review_Status__c = 'Complete';
        qaPatRec1.Date_of_Service__c = date.today();
        qaPatRec1.Claim_Number__c = 'Clam Number 1';
        qaPatRec1.Claim_Type__c = 'Exam';
        qaPatRec1.Benefit_Type__c = 'Exam Only';
        qaPatRec1.Program_ID__c = gt.Id;
        qaPatRec1.Level__c = 'Comprehensive';
        qaPatRec1.Patient_Review_Status__c = 'Complete';
        qaPatRec1.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec1;

        //Create QA Patient Review 2
        QA_Patient_Review__c qaPatRec2 = new QA_Patient_Review__c();
        qaPatRec2.QA_Review_Number__c = qaReview.Id;
        qaPatRec2.Patient_First_Name__c = 'qaPatFName2';
        qaPatRec2.Patient_Last_Name__c = 'qaPatLName2';
        qaPatRec2.Relationship_to_Member__c = 'Member';
        qaPatRec2.Patient_Age__c = 20;
        qaPatRec2.Member_First_Name__c = 'memberFName2';
        qaPatRec2.Member_Last_Name__c = 'memberLName2';
        qaPatRec2.Patient_Review_Status__c = 'Complete';
        qaPatRec2.Date_of_Service__c = date.today();
        qaPatRec2.Claim_Number__c = 'Clam Number 2';
        qaPatRec2.Claim_Type__c = 'Exam';
        qaPatRec2.Benefit_Type__c = 'Exam Only';
        qaPatRec2.Program_ID__c = gt.Id;
        qaPatRec2.Level__c = 'Comprehensive';
        qaPatRec2.Patient_Review_Status__c = 'Complete';
        qaPatRec2.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec2;

        //Create QA Patient Review 3
        QA_Patient_Review__c qaPatRec3 = new QA_Patient_Review__c();
        qaPatRec3.QA_Review_Number__c = qaReview.Id;
        qaPatRec3.Patient_First_Name__c = 'qaPatFName3';
        qaPatRec3.Patient_Last_Name__c = 'qaPatLName3';
        qaPatRec3.Relationship_to_Member__c = 'Member';
        qaPatRec3.Patient_Age__c = 20;
        qaPatRec3.Member_First_Name__c = 'memberFName3';
        qaPatRec3.Member_Last_Name__c = 'memberLName3';
        qaPatRec3.Patient_Review_Status__c = 'Complete';
        qaPatRec3.Date_of_Service__c = date.today();
        qaPatRec3.Claim_Number__c = 'Clam Number 3';
        qaPatRec3.Claim_Type__c = 'Exam';
        qaPatRec3.Benefit_Type__c = 'Exam Only';
        qaPatRec3.Program_ID__c = gt.Id;
        qaPatRec3.Level__c = 'Comprehensive';
        qaPatRec3.Patient_Review_Status__c = 'Complete';
        qaPatRec3.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec3;

        //Create QA Patient Review 4
        QA_Patient_Review__c qaPatRec4 = new QA_Patient_Review__c();
        qaPatRec4.QA_Review_Number__c = qaReview.Id;
        qaPatRec4.Patient_First_Name__c = 'qaPatFName4';
        qaPatRec4.Patient_Last_Name__c = 'qaPatLName4';
        qaPatRec4.Relationship_to_Member__c = 'Member';
        qaPatRec4.Patient_Age__c = 20;
        qaPatRec4.Member_First_Name__c = 'memberFName4';
        qaPatRec4.Member_Last_Name__c = 'memberLName4';
        qaPatRec4.Patient_Review_Status__c = 'Complete';
        qaPatRec4.Date_of_Service__c = date.today();
        qaPatRec4.Claim_Number__c = 'Clam Number 4';
        qaPatRec4.Claim_Type__c = 'Exam';
        qaPatRec4.Benefit_Type__c = 'Exam Only';
        qaPatRec4.Program_ID__c = gt.Id;
        qaPatRec4.Level__c = 'Comprehensive';
        qaPatRec4.Patient_Review_Status__c = 'Complete';
        qaPatRec4.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec4;

        //Create QA Patient Review 5
        QA_Patient_Review__c qaPatRec5 = new QA_Patient_Review__c();
        qaPatRec5.QA_Review_Number__c = qaReview.Id;
        qaPatRec5.Patient_First_Name__c = 'qaPatFName5';
        qaPatRec5.Patient_Last_Name__c = 'qaPatLName5';
        qaPatRec5.Relationship_to_Member__c = 'Member';
        qaPatRec5.Patient_Age__c = 20;
        qaPatRec5.Member_First_Name__c = 'memberFName5';
        qaPatRec5.Member_Last_Name__c = 'memberLName5';
        qaPatRec5.Patient_Review_Status__c = 'Complete';
        qaPatRec5.Date_of_Service__c = date.today();
        qaPatRec5.Claim_Number__c = 'Clam Number 5';
        qaPatRec5.Claim_Type__c = 'Exam';
        qaPatRec5.Benefit_Type__c = 'Exam Only';
        qaPatRec5.Program_ID__c = gt.Id;
        qaPatRec5.Level__c = 'Comprehensive';
        qaPatRec5.Patient_Review_Status__c = 'Complete';
        qaPatRec5.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec5;

        //Create QA Patient Review 6
        QA_Patient_Review__c qaPatRec6 = new QA_Patient_Review__c();
        qaPatRec6.QA_Review_Number__c = qaReview.Id;
        qaPatRec6.Patient_First_Name__c = 'qaPatFName6';
        qaPatRec6.Patient_Last_Name__c = 'qaPatLName6';
        qaPatRec6.Relationship_to_Member__c = 'Member';
        qaPatRec6.Patient_Age__c = 20;
        qaPatRec6.Member_First_Name__c = 'memberFName6';
        qaPatRec6.Member_Last_Name__c = 'memberLName6';
        qaPatRec6.Patient_Review_Status__c = 'Complete';
        qaPatRec6.Date_of_Service__c = date.today();
        qaPatRec6.Claim_Number__c = 'Clam Number 6';
        qaPatRec6.Claim_Type__c = 'Exam';
        qaPatRec6.Benefit_Type__c = 'Exam Only';
        qaPatRec6.Program_ID__c = gt.Id;
        qaPatRec6.Level__c = 'Comprehensive';
        qaPatRec6.Patient_Review_Status__c = 'Complete';
        qaPatRec6.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec6;

        //Create QA Patient Review 7
        QA_Patient_Review__c qaPatRec7 = new QA_Patient_Review__c();
        qaPatRec7.QA_Review_Number__c = qaReview.Id;
        qaPatRec7.Patient_First_Name__c = 'qaPatFName7';
        qaPatRec7.Patient_Last_Name__c = 'qaPatLName7';
        qaPatRec7.Relationship_to_Member__c = 'Member';
        qaPatRec7.Patient_Age__c = 20;
        qaPatRec7.Member_First_Name__c = 'memberFName7';
        qaPatRec7.Member_Last_Name__c = 'memberLName7';
        qaPatRec7.Patient_Review_Status__c = 'Complete';
        qaPatRec7.Date_of_Service__c = date.today();
        qaPatRec7.Claim_Number__c = 'Clam Number 7';
        qaPatRec7.Claim_Type__c = 'Exam';
        qaPatRec7.Benefit_Type__c = 'Exam Only';
        qaPatRec7.Program_ID__c = gt.Id;
        qaPatRec7.Level__c = 'Comprehensive';
        qaPatRec7.Patient_Review_Status__c = 'Complete';
        qaPatRec7.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec7;

        //Create QA Patient Review 8
        QA_Patient_Review__c qaPatRec8 = new QA_Patient_Review__c();
        qaPatRec8.QA_Review_Number__c = qaReview.Id;
        qaPatRec8.Patient_First_Name__c = 'qaPatFName8';
        qaPatRec8.Patient_Last_Name__c = 'qaPatLName8';
        qaPatRec8.Relationship_to_Member__c = 'Member';
        qaPatRec8.Patient_Age__c = 20;
        qaPatRec8.Member_First_Name__c = 'memberFName8';
        qaPatRec8.Member_Last_Name__c = 'memberLName8';
        qaPatRec8.Patient_Review_Status__c = 'Complete';
        qaPatRec8.Date_of_Service__c = date.today();
        qaPatRec8.Claim_Number__c = 'Clam Number 8';
        qaPatRec8.Claim_Type__c = 'Exam';
        qaPatRec8.Benefit_Type__c = 'Exam Only';
        qaPatRec8.Program_ID__c = gt.Id;
        qaPatRec8.Level__c = 'Comprehensive';
        qaPatRec8.Patient_Review_Status__c = 'Complete';
        qaPatRec8.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec8;

        //Create QA Patient Review 9
        QA_Patient_Review__c qaPatRec9 = new QA_Patient_Review__c();
        qaPatRec9.QA_Review_Number__c = qaReview.Id;
        qaPatRec9.Patient_First_Name__c = 'qaPatFName9';
        qaPatRec9.Patient_Last_Name__c = 'qaPatLName9';
        qaPatRec9.Relationship_to_Member__c = 'Member';
        qaPatRec9.Patient_Age__c = 20;
        qaPatRec9.Member_First_Name__c = 'memberFName9';
        qaPatRec9.Member_Last_Name__c = 'memberLName9';
        qaPatRec9.Patient_Review_Status__c = 'Complete';
        qaPatRec9.Date_of_Service__c = date.today();
        qaPatRec9.Claim_Number__c = 'Clam Number 9';
        qaPatRec9.Claim_Type__c = 'Exam';
        qaPatRec9.Benefit_Type__c = 'Exam Only';
        qaPatRec9.Program_ID__c = gt.Id;
        qaPatRec9.Level__c = 'Comprehensive';
        qaPatRec9.Patient_Review_Status__c = 'Complete';
        qaPatRec9.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec9;

        //Create QA Patient Review 10
        QA_Patient_Review__c qaPatRec10 = new QA_Patient_Review__c();
        qaPatRec10.QA_Review_Number__c = qaReview.Id;
        qaPatRec10.Patient_First_Name__c = 'qaPatFName10';
        qaPatRec10.Patient_Last_Name__c = 'qaPatLName10';
        qaPatRec10.Relationship_to_Member__c = 'Member';
        qaPatRec10.Patient_Age__c = 20;
        qaPatRec10.Member_First_Name__c = 'memberFName10';
        qaPatRec10.Member_Last_Name__c = 'memberLName10';
        qaPatRec10.Patient_Review_Status__c = 'Complete';
        qaPatRec10.Date_of_Service__c = date.today();
        qaPatRec10.Claim_Number__c = 'Clam Number 10';
        qaPatRec10.Claim_Type__c = 'Exam';
        qaPatRec10.Benefit_Type__c = 'Exam Only';
        qaPatRec10.Program_ID__c = gt.Id;
        qaPatRec10.Level__c = 'Comprehensive';
        qaPatRec10.Patient_Review_Status__c = 'Complete';
        qaPatRec10.Case_Hx_Perf__c = 'Yes';
        insert qaPatRec10;
    }

    static testmethod void clickButton(){
        Account acc = [SELECT Id FROM Account WHERE Name = 'Practice Account' LIMIT 1];
        QA_Review__c qaRec = [SELECT Id FROM QA_Review__c WHERE Contact_Role__r.Account__r.Id = :acc.Id LIMIT 1];

        PageReference pageRef = Page.VSPR28_QA_Review_Send_Documents_VFP;
        pageRef.getParameters().put('Id', qaRec.Id );
        Test.setCurrentPageReference(pageRef);

        Apexpages.StandardController sc = new Apexpages.StandardController(qaRec);
        VSPR28_CalculateFinalScoreExtension ext = new VSPR28_CalculateFinalScoreExtension(sc);
        Test.startTest();
        ext.getRecDetails();
        Test.stopTest();
    }
}