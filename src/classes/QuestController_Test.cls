@isTest
public class QuestController_Test {
    @testsetup
    public static void setup1(){
        List<CatTabDefault__c> catDefaults = new List<CatTabDefault__c>();
        CatTabDefault__c elg = new CatTabDefault__c();
        CatTabDefault__c benis = new CatTabDefault__c();
        CatTabDefault__c auth = new CatTabDefault__c();
        CatTabDefault__c sub = new CatTabDefault__c();
        CatTabDefault__c dp = new CatTabDefault__c();
        CatTabDefault__c proc = new CatTabDefault__c();
        CatTabDefault__c cob = new CatTabDefault__c();
        CatTabDefault__c adjs = new CatTabDefault__c();
        CatTabDefault__c dr = new CatTabDefault__c();
        CatTabDefault__c ce = new CatTabDefault__c();
        CatTabDefault__c compl = new CatTabDefault__c();
        CatTabDefault__c phone = new CatTabDefault__c();
        
        elg.Name = 'Eligibility';
        elg.Category_Links__c = 'Sidebar-EligibilityTest';
        catDefaults.add(elg);
        
        benis.Name = 'Benefits';
        benis.Category_Links__c = 'Sidebar-BenefitsTest';
        catDefaults.add(benis);
        
        auth.Name = 'Authorization';
        auth.Category_Links__c = 'Sidebar-AuthorizationTest';
        catDefaults.add(auth);
        
        sub.Name = 'Submit';
        sub.Category_Links__c = 'Sidebar-SubmitTest';
        catDefaults.add(sub);
        
        dp.Name = 'Determine Payment';
        dp.Category_Links__c = 'Sidebar-DeterminePaymentTest';
        catDefaults.add(dp);
        
        proc.Name = 'Processing';
        proc.Category_Links__c = 'Sidebar-ProcessingTest';
        catDefaults.add(proc);
        
        cob.Name = 'COB';
        cob.Category_Links__c = 'Sidebar-COBTest';
        catDefaults.add(cob);
        
        adjs.Name = 'Adjustments';
        adjs.Category_Links__c = 'Sidebar-AdjustmentsTest';
        catDefaults.add(adjs);
        
        
        dr.Name = 'Dr Info';
        dr.Category_Links__c = 'Sidebar-DrInfoTest';
        catDefaults.add(dr);
        
        ce.Name = 'Client Exceptions';
        ce.Category_Links__c = 'Sidebar-ClientExceptionsTest';
        catDefaults.add(ce);
        
        compl.Name = 'Compliance';
        compl.Category_Links__c = 'Sidebar-ComplianceTest';
        catDefaults.add(compl);
        
        phone.Name = 'Phone Book';
        phone.Category_Links__c = 'Sidebar-PhoneBookTest';
        catDefaults.add(phone);
        
        insert catDefaults;
        
        Knowledge__kav elgkav = new Knowledge__kav();
        elgkav.Title = 'EligibilityTestArticle';
        elgkav.Language = 'en_US';
        elgkav.UrlName = 'Sidebar-EligibilityTest';
        elgkav.Links__c = 'http://www.QuestControllerTestEligibility.com';
        insert elgkav;
        String elgArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-EligibilityTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(elgArticleId, true);
        
        Knowledge__kav beniskav = new Knowledge__kav();
        beniskav.Title = 'BenefitsTestArticle';
        beniskav.Language = 'en_US';
        beniskav.UrlName = 'Sidebar-BenefitsTest';
        beniskav.Links__c = 'http://www.QuestControllerTestBenefits.com';
        insert beniskav;
        String benisArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-BenefitsTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(benisArticleId, true);
        
        Knowledge__kav authkav = new Knowledge__kav();
        authkav.Title = 'AuthTestArticle';
        authkav.Language = 'en_US';
        authkav.UrlName = 'Sidebar-AuthorizationTest';
        authkav.Links__c = 'http://www.QuestControllerTestAuth.com';
        insert authkav;
        String authArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-AuthorizationTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(authArticleId, true);
        
        Knowledge__kav subkav = new Knowledge__kav();
        subkav.Title = 'SubmitTestArticle';
        subkav.Language = 'en_US';
        subkav.UrlName = 'Sidebar-SubmitTest';
        subkav.Links__c = 'http://www.QuestControllerTestSubmit.com';
        insert subkav;
        String subArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-SubmitTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(subArticleId, true);
        
        Knowledge__kav dpkav = new Knowledge__kav();
        dpkav.Title = 'DeterminePaymentTestArticle';
        dpkav.Language = 'en_US';
        dpkav.UrlName = 'Sidebar-DeterminePaymentTest';
        dpkav.Links__c = 'http://www.QuestControllerTestDetermine.com';
        insert dpkav;
        String dpArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-DeterminePaymentTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(dpArticleId, true);
        
        Knowledge__kav prockav = new Knowledge__kav();
        prockav.Title = 'ProcessingTestArticle';
        prockav.Language = 'en_US';
        prockav.UrlName = 'Sidebar-ProcessingTest';
        prockav.Links__c = 'http://www.QuestControllerTestProcessing.com';
        insert prockav;
        String procArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-ProcessingTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(procArticleId, true);
        
        Knowledge__kav cobkav = new Knowledge__kav();
        cobkav.Title = 'COBTestArticle';
        cobkav.Language = 'en_US';
        cobkav.UrlName = 'Sidebar-COBTest';
        cobkav.Links__c = 'http://www.QuestControllerTestCOB.com';
        insert cobkav;
        String cobArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-COBTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(cobArticleId, true);
        
        Knowledge__kav adjskav = new Knowledge__kav();
        adjskav.Title = 'AdjsTestArticle';
        adjskav.Language = 'en_US';
        adjskav.UrlName = 'Sidebar-AdjustmentsTest';
        adjskav.Links__c = 'http://www.QuestControllerTestAdjs.com';
        insert adjskav;
        String adjsArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-AdjustmentsTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(adjsArticleId, true);
        
        Knowledge__kav drkav = new Knowledge__kav();
        drkav.Title = 'DrInfoTestArticle';
        drkav.Language = 'en_US';
        drkav.UrlName = 'Sidebar-DrInfoTest';
        drkav.Links__c = 'http://www.QuestControllerTestDrInfo.com';
        insert drkav;
        String drArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-DrInfoTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(drArticleId, true);
        
        Knowledge__kav cekav = new Knowledge__kav();
        cekav.Title = 'CETestArticle';
        cekav.Language = 'en_US';
        cekav.UrlName = 'Sidebar-ClientExceptionsTest';
        cekav.Links__c = 'http://www.QuestControllerTestCE.com';
        insert cekav;
        String ceArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-ClientExceptionsTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(ceArticleId, true);
        
        Knowledge__kav complkav = new Knowledge__kav();
        complkav.Title = 'ComplianceTestArticle';
        complkav.Language = 'en_US';
        complkav.UrlName = 'Sidebar-ComplianceTest';
        complkav.Links__c = 'http://www.QuestControllerTestCompliance.com';
        insert complkav;
        String complArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-ComplianceTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(complArticleId, true);
        
        Knowledge__kav phonekav = new Knowledge__kav();
        phonekav.Title = 'PhoneBookTestArticle';
        phonekav.Language = 'en_US';
        phonekav.UrlName = 'Sidebar-PhoneBookTest';
        phonekav.Links__c = 'http://www.QuestControllerTestPhoneBook.com';
        insert phonekav;
        String phoneArticleId = [select Id,KnowledgeArticleId from Knowledge__kav where UrlName = 'Sidebar-PhoneBookTest' And PublishStatus = 'draft'].KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(phoneArticleId, true);
    }
    
    @isTest
    public static void eligibilityTest(){
        test.startTest();
        QuestController1 qc = new QuestController1();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void BenefitsTest(){
        test.startTest();
        QuestController2 qc = new QuestController2();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void AuthorizationTest(){
        test.startTest();
        QuestController3 qc = new QuestController3();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void SubmitTest(){
        test.startTest();
        QuestController4 qc = new QuestController4();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void DeterminePaymentTest(){
        test.startTest();
        QuestController5 qc = new QuestController5();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void ProcTest(){
        test.startTest();
        QuestController6 qc = new QuestController6();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void COBTest(){
        test.startTest();
        QuestController7 qc = new QuestController7();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void AdjustmentsTest(){
        test.startTest();
        QuestController8 qc = new QuestController8();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void DrInfoTest(){
        test.startTest();
        QuestController9 qc = new QuestController9();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void ClientExceptionsTest(){
        test.startTest();
        QuestController10 qc = new QuestController10();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void ComplianceTest(){
        test.startTest();
        QuestController11 qc = new QuestController11();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
    
    @isTest
    public static void PhoneBookTest(){
        test.startTest();
        QuestController12 qc = new QuestController12();
        String links = qc.getSidebarlinks();
        test.stopTest();
        system.assertNotEquals(null, links);
    }
}