@isTest//(SeeAllData=true)
public class TabController_TestClass{
/* Jesten Hayle
    public static void setUpData(){
        CatTabDefault__c ct1 = new CatTabDefault__c(Name='Dr Info',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct1;
        CatTabDefault__c ct = new CatTabDefault__c(Name='Adjustments',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct;
        CatTabDefault__c ct2 = new CatTabDefault__c(Name='Authorization',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct2;
        CatTabDefault__c ct3 = new CatTabDefault__c(Name='Benefits',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct3;
        CatTabDefault__c ct4 = new CatTabDefault__c(Name='Client Exceptions',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct4;
        CatTabDefault__c ct5 = new CatTabDefault__c(Name='Compliance',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct5;
         CatTabDefault__c ct6 = new CatTabDefault__c(Name='COB',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct6;
         CatTabDefault__c ct7 = new CatTabDefault__c(Name='Determine Payment',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct7;
         CatTabDefault__c ct8 = new CatTabDefault__c(Name='Submit',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct8;
         CatTabDefault__c ct9 = new CatTabDefault__c(Name='QNews',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct9;
         CatTabDefault__c ct10 = new CatTabDefault__c(Name='Phone Book',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct10;
        CatTabDefault__c ct11 = new CatTabDefault__c(Name='Eligibility',Category_Links__c='TestLinkURL',
                                                Default_Article__c='Test Article',Search_Category__c='Test Category');
        insert ct11;
        Category_Tab_Link__kav kav = new Category_Tab_Link__kav(Approval_Status__c='Approved',
                                                            Links__c='link',UrlName='TestLinkURL',Title='Test',Language='en_US');
        insert kav;
        system.debug(kav+'######'+kav.PublishStatus);
          Core_Benefit__kav cb = new Core_Benefit__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert cb;
        Core_Benefit__kav insertedTestcb = [Select KnowledgeArticleId from Core_Benefit__kav where ID = :cb.Id];
        KbManagement.PublishingService.publishArticle(insertedTestcb.KnowledgeArticleId, true);
        Category_Tab_Link__kav insertedTestcb1 = [Select KnowledgeArticleId from Category_Tab_Link__kav where ID = :kav.Id];
        KbManagement.PublishingService.publishArticle(insertedTestcb1.KnowledgeArticleId, true);
        system.debug(kav+'######%%%%%'+kav.PublishStatus);

        //String articleId = kav.KnowledgeArticleId;
        //KbManagement.PublishingService.publishArticle(articleId, true);
    }
    static testMethod void ValidateEligibilityTabController(){
        setUpData();
        EligibilityTabController x=new EligibilityTabController();           
        
    } 
    static testMethod void ValidateBenefitsTabController(){
        setUpData();
        BenefitsTabController y=new BenefitsTabController();           
        
    } 
    static testMethod void ValidateAuthorizationTabController(){
        setUpData();
        AuthorizationTabController z=new AuthorizationTabController();           
        
    } 
    static testMethod void ValidateAdjustmentsTabController(){
        setUpData();
        AdjustmentsTabController l=new AdjustmentsTabController();           
        
    }
    static testMethod void ValidateClientExceptionsTabController(){
        setUpData();
        ClientExceptionsTabController m=new ClientExceptionsTabController();           
       
    }
    static testMethod void ValidateCOBTabController(){
        setUpData();
        COBTabController n=new COBTabController();           
        
    }
    static testMethod void ValidateComplianceTabController(){
            setUpData();

        ComplianceTabController o=new ComplianceTabController();           
       
    }
    static testMethod void ValidatePhoneBookTabController(){
            setUpData();

        PhoneBookTabController p=new PhoneBookTabController();           
       
    }
    static testMethod void ValidateSubmitTabController(){
            setUpData();

        SubmitTabController q=new SubmitTabController();           
        
    }
    static testMethod void ValidateDeterminePaymentTabController(){
    
            setUpData();

        DeterminePaymentTabController r=new DeterminePaymentTabController();           
       
    }
    static testMethod void ValidateDrInfoTabController(){
            setUpData();

        DrInfoTabController s=new DrInfoTabController();           
       
    }
    static testMethod void ValidateQNewsTabController(){
            setUpData();

        QNewsTabController x=new QNewsTabController();           
        
    }
Jesten Hayle */      
}