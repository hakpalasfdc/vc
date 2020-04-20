@isTest
public class MultiTopic_Feedbackctrl_Test {
	@isTest
    public static void controller(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
		Test.setCurrentPage(kvfp);
        
		ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        
        test.startTest();
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        test.stopTest();
        
        system.assertNotEquals(null, mtfc.cbk);
    }
    
    @isTest
    public static void saveNoComments(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
		Test.setCurrentPage(kvfp);
        
		ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        List<String> reasonList = new List<String>{'Reason1','Reason2'};
        
        test.startTest();
        mtfc.saveclick();
        test.stopTest();
        
        system.assertEquals(null, mtfc.Comments);
    }
    
    @isTest
    public static void saveNoReason(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
		Test.setCurrentPage(kvfp);
        
		ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        mtfc.Comments = 'Test Comments';
        
        test.startTest();
        mtfc.saveclick();
        test.stopTest();
        
        List<String> reasonList = new List<String>();
        reasonList = mtfc.getReasons();
        system.assertEquals(0, reasonList.size());
    }
    
    @isTest
    public static void saveSuccess(){
        DescribeDataCategoryGroupResult[] groups = Schema.describeDataCategoryGroups(new String[] {'KnowledgeArticleVersion'}); 
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        
        Knowledge__DataCategorySelection kdcs = new Knowledge__DataCategorySelection();
        kdcs.ParentId = kav.id;
        kdcs.DataCategoryGroupName = groups[0].getName();
        kdcs.DataCategoryName = 'Eyeconic';
        insert kdcs;
        
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
		Test.setCurrentPage(kvfp);
        
		ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        List<String> reasonList = new List<String>{'Reason1','Reason2'};
        mtfc.Comments = 'Test Comments';
        mtfc.setreasons(reasonList);
        
        test.startTest();
        mtfc.saveclick();
        Article_Feedback__c af = mtfc.getArticleFeedbackObj();
        test.stopTest();
        
        //Article_Feedback__c af = [SELECT Id FROM Article_Feedback__c WHERE Article_Title__c = 'TestTitle'];
        system.assertNotEquals(null, af);
    }
    
    @isTest
    public static void getItems(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        List<SelectOption> reasons = new List<SelectOption>();
        reasons = mtfc.getItems();
        
        system.assertNotEquals(0, reasons.size());
    }
    
    @isTest
    public static void getReasons(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        List<String> reasonList = new List<String>{'Reason1','Reason2'};
        List<String> reasonList2 = new List<String>();
		mtfc.setreasons(reasonList);
        reasonList2 = mtfc.getReasons();
        
        system.assertEquals(reasonList, reasonList2);
    }
    
    @isTest
    public static void catDetails(){
        DescribeDataCategoryGroupResult[] groups = Schema.describeDataCategoryGroups(new String[] {'KnowledgeArticleVersion'}); 
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        List<Knowledge__DataCategorySelection> kdcs = new List<Knowledge__DataCategorySelection>();
        Knowledge__DataCategorySelection kdc = new Knowledge__DataCategorySelection();
        kdc.ParentId = kav.id;
        kdc.DataCategoryGroupName = groups[0].getName();
        kdc.DataCategoryName = 'Eyeconic';
        insert kdc;
        kdcs.add(kdc);
        
        test.startTest();
        mtfc.setCatDetails(kdcs);
        test.stopTest();
        List<Knowledge__DataCategorySelection> kdcs2 = new List<Knowledge__DataCategorySelection>();
        kdcs2 = mtfc.getCategory();
        system.assertNotEquals(0,kdcs2.size());
    }
    
    @isTest
    public static void getArticleId(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        String karticleId = kav.KnowledgeArticleId;
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        
		PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
		Test.setCurrentPage(kvfp);
        
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc); 
        
        
        test.startTest();
        String articleId = mtfc.getart();
        test.stopTest();
        
        system.assertEquals(karticleId, kav.KnowledgeArticleId);
    }
    
    @isTest
    public static void getURL(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc);
        
        test.startTest();
        String url = mtfc.getsfurll();
        test.stopTest();
        
        system.assertNotEquals(null, url);
    }
    
    @isTest
    public static void setFeedback(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
        Test.setCurrentPage(kvfp);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc);
        mtfc.comments = 'Test Comments';
        Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();           
        ArticleFeedbackObj.Article_ID__c = kav.KnowledgeArticleId;
        ArticleFeedbackObj.Article_Title__c = mtfc.cbk.Title;
		ArticleFeedbackObj.Article_Type__c = mtfc.cbk.Article_Record_Type_Name__c;
        ArticleFeedbackObj.Article_URL__c = mtfc.sfURL+'/'+kav.KnowledgeArticleId;    
        ArticleFeedbackObj.Comments__c = mtfc.Comments;
        articleFeedbackObj.Reason__c = 'test reason';
        insert articleFeedbackObj;
        
       	test.startTest();
        mtfc.setArticleFeedbackObj(articleFeedbackObj);
        test.stopTest();
        
        system.assertNotEquals(null, mtfc.ArticleFeedbackObj);
    }
    
    @isTest
    public static void getCBKId(){
        knowledge__kav kav = new Knowledge__kav();
        kav.Title = 'TestTitle';
        kav.UrlName = 'UrlName';
        insert kav;
        
        kav = [SELECT KnowledgeArticleId,Article_Record_Type_Name__c FROM Knowledge__kav WHERE Id =: kav.Id and PublishStatus = 'draft'];
        //KbManagement.PublishingService.publishArticle(kav.KnowledgeArticleId, true);
        PageReference kvfp = Page.Knowledge_VFP;
        kvfp.getParameters().put('id',kav.KnowledgeArticleId);
        Test.setCurrentPage(kvfp);
        ApexPages.KnowledgeArticleVersionStandardController kavsc = new ApexPages.KnowledgeArticleVersionStandardController(kav);
        MultiTopic_FeedbackctrlLEX mtfc = new MultiTopic_FeedbackctrlLEX(kavsc);
        
        test.startTest();
        String idCBK = mtfc.getReturnid();
        test.stopTest();
        
        system.assertEquals(idCBK, mtfc.cbkId);
    }
    
    @isTest
    public static void testRedirectProcedure(){

        Knowledge__Kav pro = new Knowledge__Kav();
        pro.Title = 'Procedure_Test';       
        pro.URLName = 'Procedure-Test-Unique';
        pro.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Procedure' and SobjectType ='Knowledge__kav'].Id;
        
        insert pro;
        
        Knowledge__Kav postPro =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :pro.Id];
        KbManagement.PublishingService.publishArticle(postPro.KnowledgeArticleId, true); 
        PageReference proTest = new PageReference('/apex/VFP_Knowledge?Id='+pro.Id);

        Test.setCurrentPage(proTest);
        ApexPages.currentPage().getParameters().put('id',postPro.KnowledgeArticleId);
        MultiTopic_FeedbackctrlLEX proRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference proRef = proRe.redirect();
        Test.stopTest();

        PageReference expectedPage = new PageReference('/apex/Procedure_VFP?Id='+postPro.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), proRef.getURL());
    }
    
    @isTest 
    public static void testRedirectProviderSolutionsCommunity(){
        
        Knowledge__Kav psc = new Knowledge__Kav();
        psc.Title ='Provider_Solutions_Community_Test';
        psc.URLName ='Provider-Solutions-Community-Test-Unique';
        psc.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Provider_Solutions_Community' and SobjectType ='Knowledge__kav'].Id;
        
        insert psc;
        
        Knowledge__Kav postPsc =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :psc.Id];
        KbManagement.PublishingService.publishArticle(postPsc.KnowledgeArticleId, true); 
        PageReference pscTest = new PageReference('/apex/VFP_Knowledge?Id='+psc.Id);
        
        Test.setCurrentPage(pscTest);
        ApexPages.currentPage().getParameters().put('id',postPsc.KnowledgeArticleId);
        MultiTopic_FeedbackctrlLEX pscRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference pscRef = pscRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Provider_Solutions_Community_VFP?Id='+postPsc.KnowledgeArticleId);
        System.assertEquals(expectedPage.getUrl(), pscRef.getURL());
    }
    
    @isTest
    public static void testRedirectExternalPublication(){
        
        Knowledge__Kav ep = new Knowledge__Kav();
        ep.Title = 'External_Publication_Test';
        ep.URLName = 'External-Publication-Test-Unique';
        ep.RecordTypeId = [Select Id From RecordType Where DeveloperName ='External_Publication' and SobjectType ='Knowledge__kav'].Id;
        
        insert ep;
        
        Knowledge__Kav postEp =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :ep.Id];
		KbManagement.PublishingService.publishArticle(postEp.KnowledgeArticleId, true); 
		PageReference epTest = new PageReference('/apex/VFP_Knowledge?Id='+ep.Id);
        
        Test.setCurrentPage(epTest);
		ApexPages.currentPage().getParameters().put('id',postEp.KnowledgeArticleId);
        MultiTopic_FeedbackctrlLEX epRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference epRef = epRe.redirect(); 
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/External_Publication_VFP?Id='+postEp.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), epRef.getUrl());
    }
    
    @isTest
    public static void testRedirectGeneralArticleTemplate(){
 
        Knowledge__Kav gat = new Knowledge__Kav();
        gat.Title = 'General_Article_Template_Test'; 
        gat.URLName = 'General-Article-Template-Test-Unique';
        gat.RecordTypeId = [Select Id From RecordType Where DeveloperName ='General_Article_Template' and SobjectType ='Knowledge__kav'].Id;
        
        insert gat;
        
        Knowledge__Kav postGat =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :gat.Id];
        KbManagement.PublishingService.publishArticle(postGat.KnowledgeArticleId, true);
        PageReference gatTest = new PageReference('/apex/VFP_Knowledge?Id='+gat.Id); 
        
        Test.setCurrentPage(gatTest);
		ApexPages.currentPage().getParameters().put('id',postGat.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX gatRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference gatRef = gatRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/General_Article_VFP?Id='+postGat.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), gatRef.getUrl());
    }
    
    @isTest
    public static void testRedirectOpenEnrollment(){
 
        Knowledge__Kav oe = new Knowledge__Kav();
        oe.Title = 'Open_Enrollment_Test'; 
        oe.URLName = 'Open-Enrollment-Test-Unique';
        oe.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Open_Enrollment' and SobjectType ='Knowledge__kav'].Id;
        
        insert oe;
        
        Knowledge__Kav postOe =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :oe.Id];
        KbManagement.PublishingService.publishArticle(postOe.KnowledgeArticleId, true);
        PageReference oeTest = new PageReference('/apex/VFP_Knowledge?Id='+oe.Id); 
        
        Test.setCurrentPage(oeTest);
		ApexPages.currentPage().getParameters().put('id',postOe.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX oeRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference oeRef = oeRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Open_Enrollment_VFP?Id='+postOe.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), oeRef.getUrl());
    }
    
    @isTest
    public static void testRedirectCoreBenfit(){
 
        Knowledge__Kav cb = new Knowledge__Kav();
        cb.Title = 'Core_Benefit_Test'; 
        cb.URLName = 'Core-Benefit-Test-Unique';
        cb.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Core_Benefit' and SobjectType ='Knowledge__kav'].Id;
        
        insert cb;
        
        Knowledge__Kav postCb =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :cb.Id];
        KbManagement.PublishingService.publishArticle(postCb.KnowledgeArticleId, true);
        PageReference cbTest = new PageReference('/apex/VFP_Knowledge?Id='+cb.Id); 
        
        Test.setCurrentPage(cbTest);
		ApexPages.currentPage().getParameters().put('id',postCb.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX cbRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference cbRef = cbRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Core_Benefit_VFP?Id='+postCb.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), cbRef.getUrl());
    }
    @isTest
    public static void testRedirectAdditionalBenefits(){
 
        Knowledge__Kav ab = new Knowledge__Kav();
        ab.Title = 'Additional_Benefits_Test'; 
        ab.URLName = 'Additional-Benefits-Test-Unique';
        ab.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Additional_Benefits' and SobjectType ='Knowledge__kav'].Id;
        
        insert ab;
        
        Knowledge__Kav postAb =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :ab.Id];
        KbManagement.PublishingService.publishArticle(postAb.KnowledgeArticleId, true);
        PageReference abTest = new PageReference('/apex/VFP_Knowledge?Id='+ab.Id); 
        
        Test.setCurrentPage(abTest);
		ApexPages.currentPage().getParameters().put('id',postAb.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX abRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference abRef = abRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Additional_Benefits_VFP?Id='+postAb.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), abRef.getUrl());
    }
    @isTest
    public static void testRedirectComplaintsGreviances(){
 
        Knowledge__Kav cg = new Knowledge__Kav();
        cg.Title = 'Complaints_Greiances_Test'; 
        cg.URLName = 'Complaints-Greiances-Test-Unique';
        cg.RecordTypeId = [Select Id From RecordType Where DeveloperName ='C_G_Article' and SobjectType ='Knowledge__kav'].Id;
        
        insert cg;
        
        Knowledge__Kav postCg =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :cg.Id];
        KbManagement.PublishingService.publishArticle(postCg.KnowledgeArticleId, true);
        PageReference cgTest = new PageReference('/apex/VFP_Knowledge?Id='+cg.Id); 
        
        Test.setCurrentPage(cgTest);
		ApexPages.currentPage().getParameters().put('id',postCg.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX cgRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference cgRef = cgRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/CG_VFP?Id='+postCg.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), cgRef.getUrl());
    }
    @isTest
    public static void testRedirectCategoryTabLink(){
 
        Knowledge__Kav ctl = new Knowledge__Kav();
        ctl.Title = 'Category_Tab_Link_Test'; 
        ctl.URLName = 'Category-Tab-Link-Test-Unique';
        ctl.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Category_Tab_Link' and SobjectType ='Knowledge__kav'].Id;
        
        insert ctl;
        
        Knowledge__Kav postCtl =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :ctl.Id];
        KbManagement.PublishingService.publishArticle(postCtl.KnowledgeArticleId, true);
        PageReference ctlTest = new PageReference('/apex/VFP_Knowledge?Id='+ctl.Id); 
        
        Test.setCurrentPage(ctlTest);
		ApexPages.currentPage().getParameters().put('id',postCtl.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX ctlRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference ctlRef = ctlRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Category_Tab_Link_VFP?Id='+postCtl.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), ctlRef.getUrl());
    }
    
    @isTest
    public static void testRedirectMultiTopicDetails(){
 
        Knowledge__Kav mtd = new Knowledge__Kav();
        mtd.Title = 'Multi_Topic_Details_Test'; 
        mtd.URLName = 'Multi-Topic-Details-Test-Unique';
        mtd.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Multi_Topic_Details' and SobjectType ='Knowledge__kav'].Id;
        
        insert mtd;
        
        Knowledge__Kav postMtd =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :mtd.Id];
        KbManagement.PublishingService.publishArticle(postMtd.KnowledgeArticleId, true);
        PageReference mtdTest = new PageReference('/apex/VFP_Knowledge?Id='+mtd.Id); 
        
        Test.setCurrentPage(mtdTest);
		ApexPages.currentPage().getParameters().put('id',postMtd.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX mtdRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference mtdRef = mtdRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/MTD_VFP?Id='+postMtd.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), mtdRef.getUrl());
    }
    
    @isTest
    public static void testRedirectSupportQueue(){
 
        Knowledge__Kav sq = new Knowledge__Kav();
        sq.Title = 'Support_Queue_Test'; 
        sq.URLName = 'Support-Queue-Test-Unique';
        sq.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Support_Queue' and SobjectType ='Knowledge__kav'].Id;
        
        insert sq;
        
        Knowledge__Kav postSq =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :sq.Id];
        KbManagement.PublishingService.publishArticle(postSq.KnowledgeArticleId, true);
        PageReference sqTest = new PageReference('/apex/VFP_Knowledge?Id='+sq.Id); 
        
        Test.setCurrentPage(sqTest);
		ApexPages.currentPage().getParameters().put('id',postSq.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX sqRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference sqRef = sqRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/Support_Queue_VFP?Id='+postSq.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), sqRef.getUrl());
    }

    @isTest
    public static void testRedirectUniversalService(){
 
        Knowledge__Kav usc = new Knowledge__Kav();
        usc.Title = 'USC_Test'; 
        usc.URLName = 'USC-Test-Unique';
        usc.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Universal_Service' and SobjectType ='Knowledge__kav'].Id;
        
        insert usc;
        
        Knowledge__Kav postUsc =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :usc.Id];
        KbManagement.PublishingService.publishArticle(postUsc.KnowledgeArticleId, true);
        PageReference uscTest = new PageReference('/apex/VFP_Knowledge?Id='+usc.Id); 
        
        Test.setCurrentPage(uscTest);
		ApexPages.currentPage().getParameters().put('id',postUsc.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX uscRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference uscRef = uscRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/USC_VFP?Id='+postUsc.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), uscRef.getUrl());
    }
    
    @isTest
    public static void testDraftArticle(){
 
        Knowledge__Kav draft = new Knowledge__Kav();
        draft.Title = 'Draft_Test'; 
        draft.URLName = 'Draft-Test-Unique';
        draft.RecordTypeId = [Select Id From RecordType Where DeveloperName ='Universal_Service' and SobjectType ='Knowledge__kav'].Id;
        
        insert draft;
        
        Knowledge__Kav postDraft =  [Select id, knowledgeArticleId from Knowledge__Kav where id = :draft.Id];
        PageReference draftTest = new PageReference('/apex/VFP_Knowledge?Id='+draft.Id); 
        
        Test.setCurrentPage(draftTest);
		ApexPages.currentPage().getParameters().put('id',postDraft.KnowledgeArticleId);
		MultiTopic_FeedbackctrlLEX draftRe = new MultiTopic_FeedbackctrlLEX();
        
        Test.startTest();
        PageReference draftRef = draftRe.redirect();
        Test.stopTest();
        
        PageReference expectedPage = new PageReference('/apex/USC_VFP?Id='+postDraft.KnowledgeArticleId);
        System.assertEquals(expectedPage.getURL(), draftRef.getUrl());
    } 
}