@isTest
public class VSPR27_CampaignRelatedListExt_Test {
@isTest
    static void executeRelatedList()
    {
        //Create an Account 
        Account testAccount = new Account(
			Name = 'Test Business Account',
            RecordType = [SELECT Id from RecordType WHERE Name = 'Business Account' and sObjectType ='Account']
        );
        
        insert testAccount; 
        
        //Create a Contact
        Contact testContact = new Contact(
       		Account = testAccount,
            FirstName = 'Jane',
            LastName = 'Doe'
        );
        
        insert testContact; 
        
        //Create a Contact Role 
        Contact_Role__c testContactRole = new Contact_Role__c(
            Account__c = testAccount.Id,
            Contact__c = testContact.Id,
        	Type__c = 'Doctor-Owner',
            Start_Date__c = System.today()
        ); 
        
        insert testContactRole; 
        
        //create a Campaign
        Campaign testCampaign = new Campaign(
            Name = 'This is a test campaign with a very long name in the name field',
            RecordType = [SELECT Id from RecordType WHERE Name ='VSP Campaign' and SObjectType = 'Campaign'],
            Line_of_Business__c = 'Altair',
            StartDate = System.today()-45,
            Description = 'The quick brown fox jumped over the lazy dog every good boy does fine',
            Product_Service__c = 'Test Product'
            
        );
        insert testCampaign;
        
        //create a Campaign Member
        CampaignMember testCampaignMember = new CampaignMember(
            CampaignId = testCampaign.Id,
            ContactId = testContact.Id
        );
        insert testCampaignMember;
        
        List<CampaignMember> campaigns = new List<CampaignMember>();
        campaigns.add(testCampaignMember);

		ApexPages.currentPage().getParameters().put('Id', testContactRole.Id);        
        
        ApexPages.StandardController testController = new ApexPages.StandardController(testContactRole); 
        VSPR27_CampaignRelatedListExt relatedListObj = new VSPR27_CampaignRelatedListExt(testController);
        relatedListObj.camps = campaigns;
//        relatedListObj.queueRecords();
    }
   
}