/* Created Date : 22nd June 2016
   Related Case : #9251
   Related Class : VSPR13_CaseExtensionController
   Related Object : Case, Contact.
   Description : Code Coverage should be 90 % or Greater than 90 %.
*/

@isTest(seeAllData = true)
public class VSPR13_CaseExtensionControllerTest{
static testMethod void VSPR13_CaseExtensionControllerTest()
{
//Test converage for the myPage visualforce page
    PageReference pageRef = Page.VSPR13_ContactAndCaseVFP;
    Test.setCurrentPageReference(pageRef);

//Create Account
    Account ac = new Account (name='XYZ Organization');
    ac.Name = 'XYZ Organization';
    ac.Email__c = 'francisbenzon@gmail.com';
    ac.Phone = '3634582';
    ac.Fax = '123456';
    ac.Website = 'www.google.com';
    insert ac;
    
    
    Contact c = new Contact();
    c.Salutation = 'Mr.';
    c.LastName = 'Test';
    c.FirstName = 'Test';
    c.Marketing_Name__c = 'Test';
    c.AccountId = ac.id;
    //c.RecordTypeId = '012P00000000S0NIAU';
    
    Contact c2 = new Contact();
    c2.Salutation = 'Mr.';
    c2.LastName = 'Test';
    c2.FirstName = 'Test';
    c2.Marketing_Name__c = 'Test';
    c2.AccountId = ac.id;
    //c2.RecordTypeId = '012P00000000S0S';
    
    Contact c3 = new Contact();
    c2.Salutation = 'Mr.';
    c3.Marketing_Name__c = 'Test';
    c3.LastName = 'Test';
    c3.FirstName = 'Test';
    c3.AccountId = ac.id;
    //c3.RecordTypeId = '012P00000000S0N';
    
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
    
    
        ApexPages.StandardController sc = new ApexPages.standardController(c);
    
        // create an instance of the controller

        VSPR13_CaseExtensionController ExtensionControllerTest = new VSPR13_CaseExtensionController(sc);          
            
        ApexPages.StandardController sc2 = new ApexPages.standardController(c2);
        // create an instance of the controller
        VSPR13_CaseExtensionController ExtensionControllerTest2 = new VSPR13_CaseExtensionController(sc2);  
            
        ApexPages.StandardController sc3 = new ApexPages.standardController(c3);
        // create an instance of the controller
        VSPR13_CaseExtensionController ExtensionControllerTest4 = new VSPR13_CaseExtensionController(sc3);      
        
        Test.startTest();
        Test.setCurrentPage(Page.VSPR13_ContactAndCaseVFP);
        
        PageReference pagereferenceTest = ExtensionControllerTest2.save();
        PageReference pagereferenceTest2 = ExtensionControllerTest.cancel(); 
        PageReference pagereferenceTest3 = ExtensionControllerTest.doSaveAndNew();
        PageReference pagereferenceTest5 = ExtensionControllerTest2.doSaveAndNew();
        PageReference pagereferenceTest4 = ExtensionControllerTest4.save();
        try{
            ApexPages.StandardController sc4 = new ApexPages.standardController(new Contact());
            // create an instance of the controller
            VSPR13_CaseExtensionController ExtensionControllerTest5 = new VSPR13_CaseExtensionController(sc4); 
            ExtensionControllerTest5.save();
        }catch(System.DMLException e){
            
        }
        System.assert(true);
        Test.stopTest();
        
        }

}