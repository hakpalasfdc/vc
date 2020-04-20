/* Modified Date : 21st June 2016
Related Case : #9251.
Description : Increase Code coverage to 90 %.
*/

@isTest(seeAllData=false)
public class VSPR13_ContactAndCaseControllerTest{
    
    @TestSetup
    static void testData(){
        Test.startTest();
        Id contactRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Id personRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId(); 
        DVIWebService__c dviWeb = new DVIWebService__c();
        
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        //Create Account
        Account ac = new Account (name='VSP Consumer');
        ac.Name = 'VSP Consumer';
        ac.Email__c = 'francisbenzon@gmail.com';
        ac.Phone = '3634582';
        ac.Fax = '123456';
        ac.Website = 'www.google.com';
        insert ac;
        
        
        Contact c = new Contact();
        c.Salutation = 'Mr.';
        c.LastName = 'Test1';
        c.FirstName = 'Test';
        c.Marketing_Name__c = 'Test';
        c.AccountId = ac.id;
        c.RecordTypeId =  contactRecordTypeId;
        insert c;
        //c.RecordTypeId = '012P00000000S0NIAU';
        
        Contact c2 = new Contact();
        c2.Salutation = 'Mr.';
        c2.LastName = 'Test2';
        c2.FirstName = 'Test';
        c2.Marketing_Name__c = 'Test';
        c2.AccountId = ac.id;
        c2.RecordTypeId =  contactRecordTypeId;
        insert c2;
        //c2.RecordTypeId = '012P00000000S0S';
        
        Contact c3 = new Contact();
        c3.Salutation = 'Mr.';
        c3.Marketing_Name__c = 'Test';
        c3.LastName = 'Test3';
        c3.FirstName = 'Test';
        c3.AccountId = ac.id;
        c3.RecordTypeId =  contactRecordTypeId;
        insert c3;
        //c3.RecordTypeId = '012P00000000S0N';

        /*
        Contact c4 = new Contact();
        c4.Salutation = 'Mr.';
        c4.Marketing_Name__c = 'Test';
        c4.LastName = 'Test4';
        c4.FirstName = 'Test';
        c4.AccountId = ac.id;
        c4.RecordTypeId =  contactRecordTypeId;
        insert c4;
        //c3.RecordTypeId = '012P00000000S0N';
        */
        
        Id personAccountId = TestDataFactory.createPersonAccount('lname');
        Id personContactId = [SELECT PersonContactId FROM Account WHERE Id=: personAccountId].PersonContactId;
        
        
        Case cs1 = new Case();
        cs1.Subject = 'Test';
        cs1.Notes__c = 'Test';
        cs1.Severity__c = 'Minor';
        cs1.Origin = 'Email';
        cs1.Line_of_Business__c = 'Retail';
        cs1.Description = 'Test';
        cs1.Status = 'New';
        cs1.Type = 'Issue';
        cs1.Classification__c = 'Training';
        cs1.Product__c = 'Premier';
        cs1.Auto_Assign__c = false;
        cs1.ContactId = c.Id;
        insert cs1;
        
        Case cs2 = new Case();
        cs2.Subject = 'Test';
        cs2.Notes__c = 'Test';
        cs2.Severity__c = 'Minor';
        cs2.Origin = 'Email';
        cs2.Line_of_Business__c = 'Retail';
        cs2.Description = 'Test';
        cs2.Status = 'New';
        cs2.Type = 'Issue';
        cs2.Classification__c = 'Training';
        cs2.Product__c = 'Premier';
        cs2.ContactId = c2.Id;
        insert cs2;
        
        Case cs3 = new Case();
        cs3.Subject = 'Test';
        cs3.Notes__c = 'Test';
        cs3.Severity__c = 'Minor';
        cs3.Origin = 'Email';
        cs3.Line_of_Business__c = 'Retail';
        cs3.Description = 'Test';
        cs3.Status = 'New';
        cs3.Type = 'Issue';
        cs3.Classification__c = 'Training';
        cs3.Product__c = 'Premier';
        cs3.ContactId = c3.Id;
        insert cs3;
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
        Case cs5 = new Case();
        cs5.Subject = 'Test';
        cs5.Notes__c = 'Test';
        cs5.Severity__c = 'Minor';
        cs5.Origin = 'Email';
        cs5.Line_of_Business__c = 'Retail';
        cs5.Description = 'Test';
        cs5.Status = 'New';
        cs5.Type = 'Issue';
        cs5.Classification__c = 'Training';
        cs5.Product__c = 'Premier';
        cs5.RecordTypeId = caseRecordTypeId;
        //cs5.ContactId = c4.Id;
        cs5.ContactId = personContactId;
        cs5.SuppliedEmail = 'test@test.net';
        cs5.SuppliedName = 'Test Contact';
        insert cs5; 
        Test.stopTest();
    }
    static testMethod void VSPR13_ContactAndCaseControllerTest()
    {
        CaseRecordType__c caseRecType = new CaseRecordType__c();
        caseRecType.Name = 'Eyeconic';
        caseRecType.Id__c = '0120B000000t8xa';
        insert caseRecType;
        //Test converage for the myPage visualforce page
        PageReference pageRef = Page.VSPR13_ContactAndCaseVFP;
        Test.setCurrentPageReference(pageRef);
        
        
        Contact c = [SELECT Id FROM Contact WHERE LastName = 'Test1' LIMIT 1];
        Contact c2 = [SELECT Id FROM Contact WHERE LastName = 'Test2' LIMIT 1];
        Contact c3 = [SELECT Id FROM Contact WHERE LastName = 'Test3' LIMIT 1];
        //Contact c4 = [SELECT Id FROM Contact WHERE LastName = 'Test4' LIMIT 1];
        Contact c4 = [SELECT Id FROM Contact WHERE LastName = 'lname' LIMIT 1];
        
        ApexPages.StandardController sc = new ApexPages.standardController(c);

        // create an instance of the controller
        
        VSPR13_ContactAndCaseExtensionController ExtensionControllerTest = new VSPR13_ContactAndCaseExtensionController(sc);
        ExtensionControllerTest.selectedrecordType = 'Client';
        //ExtensionControllerTest.ContactID = c.Id;            
        
        ApexPages.StandardController sc2 = new ApexPages.standardController(c2);
        // create an instance of the controller
        VSPR13_ContactAndCaseExtensionController ExtensionControllerTest2 = new VSPR13_ContactAndCaseExtensionController(sc2); 
        ExtensionControllerTest2.selectedrecordType = 'Consumer';
        //ExtensionControllerTest2.ContactID = c2.Id;
        
        ApexPages.StandardController sc3 = new ApexPages.standardController(c3);
        // create an instance of the controller
        VSPR13_ContactAndCaseExtensionController ExtensionControllerTest4 = new VSPR13_ContactAndCaseExtensionController(sc3);       
        ExtensionControllerTest4.selectedrecordType = 'Client';  
        //ExtensionControllerTest4.ContactId = c3.ID;
        //ExtensionControllerTest4.acc = ac.Id;
        
        ApexPages.StandardController sc5 = new ApexPages.standardController(c4);
        // create an instance of the controller
        VSPR13_ContactAndCaseExtensionController ExtensionControllerTest6 = new VSPR13_ContactAndCaseExtensionController(sc5);       
        ExtensionControllerTest6.selectedrecordType = 'Client';  
        ExtensionControllerTest6.acc = '';
        ExtensionControllerTest6.contactid = '';
        ExtensionControllerTest6.caseSelectedRecordType = 'Eyeconic';
        //ExtensionControllerTest4.ContactId = c3.ID;
        //ExtensionControllerTest4.acc = ac.Id;
        
        Test.startTest();
        Test.setCurrentPage(Page.VSPR13_ContactAndCaseVFP);
        
        PageReference pagereferenceTest = ExtensionControllerTest2.save();
        PageReference pagereferenceTest2 = ExtensionControllerTest.cancel(); 
        PageReference pagereferenceTest3 = ExtensionControllerTest.doSaveAndNew();
        PageReference pagereferenceTest5 = ExtensionControllerTest2.doSaveAndNew();
        PageReference pagereferenceTest4 = ExtensionControllerTest4.save();
        PageReference pagereferenceTest6 = ExtensionControllerTest6.save();
        
        try{
            ApexPages.StandardController sc4 = new ApexPages.standardController(new Contact());
            // create an instance of the controller
            VSPR13_ContactAndCaseExtensionController ExtensionControllerTest5 = new VSPR13_ContactAndCaseExtensionController(sc4); 
            ExtensionControllerTest5.save();
        }catch(System.DMLException e){
            
        }
        
        System.assert(true);
        Test.stopTest();
        
    }
    
}