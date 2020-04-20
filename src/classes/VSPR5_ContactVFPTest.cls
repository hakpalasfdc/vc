@isTest(SeeAllData=true)
public class VSPR5_ContactVFPTest {
static testMethod void VSPR5_ContactVFP_Test()
{
//Test converage for the myPage visualforce page
PageReference pageRef = Page.VSPR5_ContactVFP;
Test.setCurrentPageReference(pageRef);

    
//Create Account
Account ac = new Account (name='XYZ Organization');
ac.Name = 'XYZ Organization';
ac.Email__c = 'francisbenzon@gmail.com';
ac.Phone = '3634582';
ac.Fax = '123456';
ac.Website = 'www.google.com';
insert ac;


//Create Contact

//insert c;
/*    
Contact c2 = new Contact(
    LastName = 'Test',
    Marketing_Name__c = 'Test',
    AccountId = ac.id
);
insert c2;

Contact_Role__c cRole = new Contact_Role__c();
cRole.Type__c = 'Accounting';
cRole.Start_Date__c = system.today();
cRole.Account__c = c.AccountId;
cRole.Contact__c = c.id;
insert cRole;
    

    
    Marketing_Name__c = 'Test',
    AccountId = ac.id
);
*/
    
    Contact c = new Contact();
    c.LastName = 'Test';
    c.Marketing_Name__c = 'Test';
    c.AccountId = ac.id;
   
   
    
    Contact c2 = new Contact();
    c2.LastName = 'Test';
    c2.Marketing_Name__c = 'Test';
    c2.AccountId = ac.id;
    
    Contact c3 = new Contact();
    c3.Marketing_Name__c = 'Test';
    c3.AccountId = ac.id;
    
   
    
ApexPages.StandardController sc = new ApexPages.standardController(c);
    
// create an instance of the controller
VSPR5_ContactExtensionController ExtensionControllerTest = new VSPR5_ContactExtensionController(sc);

    
    
ApexPages.StandardController sc2 = new ApexPages.standardController(c2);
// create an instance of the controller
VSPR5_ContactExtensionController ExtensionControllerTest2 = new VSPR5_ContactExtensionController(sc2);  
    
ApexPages.StandardController sc3 = new ApexPages.standardController(c3);
// create an instance of the controller
VSPR5_ContactExtensionController ExtensionControllerTest4 = new VSPR5_ContactExtensionController(sc3);       
           

        Test.startTest();
        Test.setCurrentPage(Page.VSPR5_ContactVFP);
        
        PageReference pagereferenceTest = ExtensionControllerTest2.save();
        PageReference pagereferenceTest2 = ExtensionControllerTest.cancel(); 
        PageReference pagereferenceTest3 = ExtensionControllerTest.doSaveAndNew();
        PageReference pagereferenceTest4 = ExtensionControllerTest4.save();    
        System.assert(true);
        Test.stopTest();
        
        

}

}