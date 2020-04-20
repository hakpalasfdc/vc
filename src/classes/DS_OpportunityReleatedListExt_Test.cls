@isTest
public class DS_OpportunityReleatedListExt_Test {
    
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
        
        Opportunity testOpp = new Opportunity(
            Name = 'Test Opp',
            AccountId = testAccount.Id,   
            StageName = 'Open',
            CloseDate = System.today(),
            Product_Program__c = 'Test'
        );
        
        insert testOpp;
        
        List<Opportunity> opportunities = new List<Opportunity>();
        opportunities.add(testOpp);

        ApexPages.currentPage().getParameters().put('Id', testContactRole.Id);        
        
        ApexPages.StandardController testController = new ApexPages.StandardController(testContactRole); 
        DS_OpportunityRelatedListExt relatedListObj = new DS_OpportunityRelatedListExt(testController);
        relatedListObj.opps = opportunities;
        relatedListObj.updateValues();
    }
}