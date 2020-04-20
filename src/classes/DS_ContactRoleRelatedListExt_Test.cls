@isTest
public class DS_ContactRoleRelatedListExt_Test {

    @isTest
    static void executeRelatedList()
    {
        //Create an Account and insert it
        Account testAccount = new Account(
			Name = 'Test'        
        );
        
        insert testAccount; 
        
        Contact testContact = new Contact(
       		Account = testAccount,
            LastName = 'Test'
        );
        
        insert testContact; 
        
        //Create a Contact Role and insert it
        Contact_Role__c testContactRole = new Contact_Role__c(
            Account__c = testAccount.Id,
            Contact__c = testContact.Id,
        	Type__c = 'Student',
            Start_Date__c = System.today()
        ); 
        
        insert testContactRole; 
        
        List<Contact_Role__c> contactRoles = new List<Contact_Role__c>();
        contactRoles.add(testContactRole);

		ApexPages.currentPage().getParameters().put('Id', testContactRole.Id);        
        
        ApexPages.StandardController testController = new ApexPages.StandardController(testContactRole); 
        DS_ContactRoleRelatedListExt relatedListObj = new DS_ContactRoleRelatedListExt(testController);
        relatedListObj.contactRoles = contactRoles;
        relatedListObj.queueRecords();
    }
}