@isTest(SeeAllData=true)
public class FeedbackController_TestClass{
/* Jesten Hayle
    static testMethod void ValidateAdditionalBenefits_Feedbackctrl(){     
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        Additional_Benefits__kav ab = new Additional_Benefits__kav(Title = 'test_apex',Summary = 'test from apex',URLName = 'test-apex');
        insert ab;
        Additional_Benefits__kav insertedTestab = [Select KnowledgeArticleId from Additional_Benefits__kav where ID = :ab.Id];
        KbManagement.PublishingService.publishArticle(insertedTestab.KnowledgeArticleId, true);
        system.debug('==========================9===='+insertedTestab);
        //Additional_Benefits__kav abt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Additional_Benefits__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
        //system.debug('-----------------ab.ID:'+abt.KnowledgeArticleId);       
        //ApexPages.CurrentPage().GetParameters().put('id', 'kA1J00000004N63');
        ApexPages.CurrentPage().GetParameters().put('id',insertedTestab.KnowledgeArticleId);                      
        ApexPages.KnowledgeArticleVersionStandardController scx = new ApexPages.KnowledgeArticleVersionStandardController(ab);
        AdditionalBenefits_Feedbackctrl abf =new AdditionalBenefits_Feedbackctrl(scx);
        abf.getItems();
        abf.getReasons();                   
        system.assertnotequals(abf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestab.KnowledgeArticleId);
        system.assertnotequals(abf.cbk,null);
        system.assertnotequals(abf.filterid,null);
        system.assertnotequals(abf.catDetails,null);       
        system.assertequals(abf.getart(),abf.ID);
        system.assertequals(abf.getsfurll(),abf.sfURL);  
        
         
        system.assertequals(abf.getCategory(),abf.CatDetails);
        abf.getReturnid();        
        List<String> myStrings = new List<String>{'one','two'};
        abf.setreasons(mystrings);
        
      
        abf.getArticleFeedbackObj();
        Article_Feedback__c a =new Article_Feedback__c();
        a.Article_Title__c='article_xyz';
        a.Comments__c='xyz';
        a.Data_Category__c='eligibility';
        a.Data_Category_Group__c='visioncare';
        a.Article_ID__c = insertedTestab.KnowledgeArticleId;
        a.Article_URL__c='apex/vfp';
        a.Article_Type__c='corebenefits__Kav';
        
        abf.highlightVersionComments = false;
        
        abf.setArticleFeedbackObj(a);
        Test.startTest();           
        insert a;
        Test.stopTest();
        abf.Comments = 'Test Comment';
        
        List<Additional_Benefits__DataCategorySelection> catDetailsListInfo= new List<Additional_Benefits__DataCategorySelection>();    
        Additional_Benefits__DataCategorySelection catDetailsinfo = new Additional_Benefits__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        abf.setCatDetails(catDetailsListInfo);
        
        abf.saveClick(); 
        
        abf.Comments = '';      
        abf.saveClick();
                          
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
           }
         
    static testMethod void ValidateCoreBenefits_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Core_Benefit__kav cbt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Core_Benefit__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
        
        Core_Benefit__kav cb = new Core_Benefit__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert cb;
        Core_Benefit__kav insertedTestcb = [Select KnowledgeArticleId from Core_Benefit__kav where ID = :cb.Id];
        KbManagement.PublishingService.publishArticle(insertedTestcb.KnowledgeArticleId, true);
        ApexPages.CurrentPage().GetParameters().put('id',insertedTestcb.KnowledgeArticleId);               
        ApexPages.KnowledgeArticleVersionStandardController sccb= new ApexPages.KnowledgeArticleVersionStandardController(cb);
        CoreBenefits_Feedbackctrl cbf =new CoreBenefits_Feedbackctrl(sccb);
        cbf.getItems();
        cbf.getReasons();                   
        system.assertnotequals(cbf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestcb.KnowledgeArticleId); 
        system.assertnotequals(cbf.cbk,null);
        system.assertnotequals(cbf.filterid,null);
        system.assertnotequals(cbf.catDetails,null);       
        system.assertequals(cbf.getart(),cbf.ID);
        system.assertequals(cbf.getsfurll(),cbf.sfURL);   
        system.assertequals(cbf.getCategory(),cbf.CatDetails);
        cbf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        cbf.setreasons(mystrings);
        cbf.getArticleFeedbackObj();                       
        Article_Feedback__c af =new Article_Feedback__c();
        af.Article_Title__c='article_xyz';
        af.Comments__c='xyz';
        af.Data_Category__c='eligibility';
        af.Data_Category_Group__c='visioncare';
        af.Article_ID__c = insertedTestcb.KnowledgeArticleId;
        af.Article_URL__c='apex/vfp';
        af.Article_Type__c='corebenefits__Kav';
        cbf.setArticleFeedbackObj(af);
        Test.startTest();           
        insert af;
        Test.stopTest();
        cbf.Comments = 'Test Comment';
        
        List<Core_Benefit__DataCategorySelection> catDetailsListInfo= new List<Core_Benefit__DataCategorySelection>();    
        Core_Benefit__DataCategorySelection catDetailsinfo = new Core_Benefit__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        cbf.setCatDetails(catDetailsListInfo);
        
        cbf.saveClick();      
        
        cbf.Comments = '';      
        cbf.saveClick();
                     
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    }
           
    static testMethod void ValidateMultiTopic_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Multi_Topic__kav mtt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Multi_Topic__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
        
        Multi_Topic__kav mt = new Multi_Topic__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert mt; 
        Multi_Topic__kav insertedTestmt = [Select KnowledgeArticleId from Multi_Topic__kav where ID = :mt.Id];
        KbManagement.PublishingService.publishArticle(insertedTestmt.KnowledgeArticleId, true);
        ApexPages.CurrentPage().GetParameters().put('id',insertedTestmt.KnowledgeArticleId);              
        ApexPages.KnowledgeArticleVersionStandardController scmt = new ApexPages.KnowledgeArticleVersionStandardController(mt);
        MultiTopic_Feedbackctrl mtf =new MultiTopic_Feedbackctrl(scmt);
        mtf.getItems();
        mtf.getReasons();                   
        system.assertnotequals(mtf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestmt.KnowledgeArticleId); 
        system.assertnotequals(mtf.cbk,null);
        system.assertnotequals(mtf.filterid,null);
        system.assertnotequals(mtf.catDetails,null);       
        system.assertequals(mtf.getart(),mtf.ID);
        system.assertequals(mtf.getsfurll(),mtf.sfURL);   
        system.assertequals(mtf.getCategory(),mtf.CatDetails);
        mtf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        mtf.setreasons(mystrings);
        mtf.getArticleFeedbackObj();                       
        Article_Feedback__c mtaf =new Article_Feedback__c();
        mtaf.Article_Title__c='article_xyz';
        mtaf.Comments__c='xyz';
        mtaf.Data_Category__c='eligibility';
        mtaf.Data_Category_Group__c='visioncare';
        mtaf.Article_ID__c = insertedTestmt.KnowledgeArticleId;
        mtaf.Article_URL__c='apex/vfp';
        mtaf.Article_Type__c='corebenefits__Kav';
        mtf.setArticleFeedbackObj(mtaf);
        Test.startTest();           
        insert mtaf;
        Test.stopTest();
        mtf.Comments = 'Test Comment';
        
        List<Multi_Topic__DataCategorySelection> catDetailsListInfo= new List<Multi_Topic__DataCategorySelection>();    
        Multi_Topic__DataCategorySelection catDetailsinfo = new Multi_Topic__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        mtf.setCatDetails(catDetailsListInfo);
        
        mtf.saveClick();  
        
        mtf.Comments = '';      
        mtf.saveClick();
                         
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    }
    
    static testMethod void ValidateMultiTopicDetails_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Multi_Topic_Details__kav mtdt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Multi_Topic_Details__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
        
        Multi_Topic_Details__kav mtd = new Multi_Topic_Details__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert mtd;
        Multi_Topic_Details__kav insertedTestmtd = [Select KnowledgeArticleId from Multi_Topic_Details__kav where ID = :mtd.Id];
        KbManagement.PublishingService.publishArticle(insertedTestmtd.KnowledgeArticleId, true);
        ApexPages.CurrentPage().GetParameters().put('id',insertedTestmtd.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController scmtd = new ApexPages.KnowledgeArticleVersionStandardController(mtd);
        MultiTopicDetails_Feedbackctrl mtdf =new MultiTopicDetails_Feedbackctrl(scmtd);
        mtdf.getItems();
        mtdf.getReasons();                   
        system.assertnotequals(mtdf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestmtd.KnowledgeArticleId); 
        system.assertnotequals(mtdf.cbk,null);
        system.assertnotequals(mtdf.filterid,null);
        //system.assertnotequals(mtdf.catDetails,null);       
        system.assertequals(mtdf.getart(),mtdf.ID);
        system.assertequals(mtdf.getsfurll(),mtdf.sfURL);   
        system.assertequals(mtdf.getCategory(),mtdf.CatDetails);
        mtdf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        mtdf.setreasons(mystrings);
        mtdf.getArticleFeedbackObj();                       
        Article_Feedback__c mtdaf =new Article_Feedback__c();
        mtdaf.Article_Title__c='article_xyz';
        mtdaf.Comments__c='xyz';
        mtdaf.Data_Category__c='eligibility';
        mtdaf.Data_Category_Group__c='visioncare';
        mtdaf.Article_ID__c = insertedTestmtd.KnowledgeArticleId;
        mtdaf.Article_URL__c='apex/vfp';
        mtdaf.Article_Type__c='corebenefits__Kav';
        mtdf.setArticleFeedbackObj(mtdaf);
        Test.startTest();           
        insert mtdaf;
        Test.stopTest();
        mtdf.Comments = 'Test Comment';
        
        List<Multi_Topic_Details__DataCategorySelection> catDetailsListInfo= new List<Multi_Topic_Details__DataCategorySelection>();    
        Multi_Topic_Details__DataCategorySelection catDetailsinfo = new Multi_Topic_Details__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        mtdf.setCatDetails(catDetailsListInfo);
        
        mtdf.saveClick();
                           
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    }
           
    static testMethod void ValidateOpenEnrollment_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Open_Enrollment__kav oet =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Open_Enrollment__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
        
        Open_Enrollment__kav oe = new Open_Enrollment__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert oe;
        Open_Enrollment__kav insertedTestoe = [Select KnowledgeArticleId from Open_Enrollment__kav where ID = :oe.Id];
        KbManagement.PublishingService.publishArticle(insertedTestoe.KnowledgeArticleId, true); 
        ApexPages.CurrentPage().GetParameters().put('id', insertedTestoe.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController scoe = new ApexPages.KnowledgeArticleVersionStandardController(oe);
        OpenEnrollment_Feedbackctrl oef =new OpenEnrollment_Feedbackctrl(scoe);
        oef.getItems();
        oef.getReasons();                   
        system.assertnotequals(oef.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestoe.KnowledgeArticleId); 
        system.assertnotequals(oef.cbk,null);
        system.assertnotequals(oef.filterid,null);
        system.assertnotequals(oef.catDetails,null);       
        system.assertequals(oef.getart(),oef.ID);
        system.assertequals(oef.getsfurll(),oef.sfURL);   
        system.assertequals(oef.getCategory(),oef.CatDetails);
        oef.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        oef.setreasons(mystrings);
        oef.getArticleFeedbackObj();                       
        Article_Feedback__c oeaf =new Article_Feedback__c();
        oeaf.Article_Title__c='article_xyz';
        oeaf.Comments__c='xyz';
        oeaf.Data_Category__c='eligibility';
        oeaf.Data_Category_Group__c='visioncare';
        oeaf.Article_ID__c = insertedTestoe.KnowledgeArticleId;
        oeaf.Article_URL__c='apex/vfp';
        oeaf.Article_Type__c='corebenefits__Kav';
        oef.setArticleFeedbackObj(oeaf);
        Test.startTest();           
        insert oeaf;
        Test.stopTest();
        oef.Comments = 'Test Comment';
        
        List<Open_Enrollment__DataCategorySelection> catDetailsListInfo= new List<Open_Enrollment__DataCategorySelection>();    
        Open_Enrollment__DataCategorySelection catDetailsinfo = new Open_Enrollment__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        oef.setCatDetails(catDetailsListInfo);
        
        oef.saveClick();    
        
        oef.Comments = '';      
        oef.saveClick();
                       
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
    }
    
    static testMethod void ValidateSingleTopic_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Single_Topic__kav stt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Single_Topic__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
       
        Single_Topic__kav st = new Single_Topic__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert st;
        Single_Topic__kav insertedTestst = [Select KnowledgeArticleId from Single_Topic__kav where ID = :st.Id];
        KbManagement.PublishingService.publishArticle(insertedTestst.KnowledgeArticleId, true); 
        ApexPages.CurrentPage().GetParameters().put('id', insertedTestst.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController scst = new ApexPages.KnowledgeArticleVersionStandardController(st);
        SingleTopic_Feedbackctrl stf =new SingleTopic_Feedbackctrl(scst);
        stf.getItems();
        stf.getReasons();                   
        system.assertnotequals(stf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestst.KnowledgeArticleId); 
        system.assertnotequals(stf.cbk,null);
        system.assertnotequals(stf.filterid,null);
        system.assertnotequals(stf.catDetails,null);       
        system.assertequals(stf.getart(),stf.ID);
        system.assertequals(stf.getsfurll(),stf.sfURL);   
        system.assertequals(stf.getCategory(),stf.CatDetails);
        stf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        stf.setreasons(mystrings);
        stf.getArticleFeedbackObj();                       
        Article_Feedback__c staf =new Article_Feedback__c();
        staf.Article_Title__c='article_xyz';
        staf.Comments__c='xyz';
        staf.Data_Category__c='eligibility';
        staf.Data_Category_Group__c='visioncare';
        staf.Article_ID__c = insertedTestst.KnowledgeArticleId;
        staf.Article_URL__c='apex/vfp';
        staf.Article_Type__c='corebenefits__Kav';
        stf.setArticleFeedbackObj(staf);
        Test.startTest();           
        insert staf;
        Test.stopTest();
        stf.Comments = 'Test Comment';
        
        List<Single_Topic__DataCategorySelection> catDetailsListInfo= new List<Single_Topic__DataCategorySelection>();    
        Single_Topic__DataCategorySelection catDetailsinfo = new Single_Topic__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        stf.setCatDetails(catDetailsListInfo);
        
        stf.saveClick();  
        
        stf.Comments = '';      
        stf.saveClick();
                         
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    } 
    
    static testMethod void ValidateSupportQueue_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Single_Topic__kav stt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Single_Topic__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
       
        Support_Queue__kav st = new Support_Queue__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert st;
        Support_Queue__kav insertedTestst = [Select KnowledgeArticleId from Support_Queue__kav where ID = :st.Id];
        KbManagement.PublishingService.publishArticle(insertedTestst.KnowledgeArticleId, true); 
        ApexPages.CurrentPage().GetParameters().put('id', insertedTestst.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController scst = new ApexPages.KnowledgeArticleVersionStandardController(st);
        SupportQueue_Feedbackctrl stf =new SupportQueue_Feedbackctrl(scst);
        stf.getItems();
        stf.getReasons();                   
        system.assertnotequals(stf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestst.KnowledgeArticleId); 
        system.assertnotequals(stf.cbk,null);
        system.assertnotequals(stf.filterid,null);
        system.assertnotequals(stf.catDetails,null);       
        system.assertequals(stf.getart(),stf.ID);
        system.assertequals(stf.getsfurll(),stf.sfURL);   
        system.assertequals(stf.getCategory(),stf.CatDetails);
        stf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        stf.setreasons(mystrings);
        stf.getArticleFeedbackObj();                       
        Article_Feedback__c staf =new Article_Feedback__c();
        staf.Article_Title__c='article_xyz';
        staf.Comments__c='xyz';
        staf.Data_Category__c='eligibility';
        staf.Data_Category_Group__c='visioncare';
        staf.Article_ID__c = insertedTestst.KnowledgeArticleId;
        staf.Article_URL__c='apex/vfp';
        staf.Article_Type__c='corebenefits__Kav';
        stf.setArticleFeedbackObj(staf);
        Test.startTest();           
        insert staf;
        Test.stopTest();
        stf.Comments = 'Test Comment';
        
        List<Support_Queue__DataCategorySelection> catDetailsListInfo= new List<Support_Queue__DataCategorySelection>();    
        Support_Queue__DataCategorySelection catDetailsinfo = new Support_Queue__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        stf.setCatDetails(catDetailsListInfo);
        
        stf.saveClick();  
        
        stf.Comments = '';      
        stf.saveClick();
                         
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    }


    static testMethod void ValidateCandGArticle_Feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
       
        C_G_Article__kav cg = new C_G_Article__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert cg;
        C_G_Article__kav insertedTestcg = [Select KnowledgeArticleId from C_G_Article__kav where ID = :cg.Id];
        KbManagement.PublishingService.publishArticle(insertedTestcg.KnowledgeArticleId, true); 
        ApexPages.CurrentPage().GetParameters().put('id', insertedTestcg.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController sccg = new ApexPages.KnowledgeArticleVersionStandardController(cg);
        CandGArticle_feedbackctrl cgf =new CandGArticle_feedbackctrl(sccg);
        cgf.getItems();
        cgf.getReasons();                   
        system.assertnotequals(cgf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestcg.KnowledgeArticleId); 
        system.assertnotequals(cgf.cbk,null);
        system.assertnotequals(cgf.filterid,null);
        system.assertnotequals(cgf.catDetails,null);       
        system.assertequals(cgf.getart(),cgf.ID);
        system.assertequals(cgf.getsfurll(),cgf.sfURL);   
        system.assertequals(cgf.getCategory(),cgf.CatDetails);
        cgf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        cgf.setreasons(mystrings);
        cgf.getArticleFeedbackObj();                       
        Article_Feedback__c cgaf =new Article_Feedback__c();
        cgaf.Article_Title__c='article_xyz';
        cgaf.Comments__c='xyz';
        cgaf.Data_Category__c='eligibility';
        cgaf.Data_Category_Group__c='visioncare';
        cgaf.Article_ID__c = insertedTestcg.KnowledgeArticleId;
        cgaf.Article_URL__c='apex/vfp';
        cgaf.Article_Type__c='corebenefits__Kav';
        cgf.setArticleFeedbackObj(cgaf);
        Test.startTest();           
        insert cgaf;
        Test.stopTest();
        cgf.Comments = 'Test Comment';
        
        List<C_G_Article__DataCategorySelection> catDetailsListInfo= new List<C_G_Article__DataCategorySelection>();    
        C_G_Article__DataCategorySelection catDetailsinfo = new C_G_Article__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        cgf.setCatDetails(catDetailsListInfo);
        
        cgf.saveClick();  
        
        cgf.Comments = '';      
        cgf.saveClick();
                         
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    } 


    static testMethod void ValidateUniversalService_feedbackctrl(){        
        ApexPages.CurrentPage().GetParameters().put('message', 'Test Message');
        //Single_Topic__kav stt =[SELECT ArticleNumber,Id,KnowledgeArticleId,Title,UrlName FROM Single_Topic__kav WHERE Language = 'en_US' AND PublishStatus = 'online' LIMIT 1 ];
       
        Universal_Service__kav st = new Universal_Service__kav(
            Title = 'test_apex',
            Summary = 'test from apex',            
            URLName = 'test-apex'
        );        
        insert st;
        Universal_Service__kav insertedTestst = [Select KnowledgeArticleId from Universal_Service__kav where ID = :st.Id];
        KbManagement.PublishingService.publishArticle(insertedTestst.KnowledgeArticleId, true); 
        ApexPages.CurrentPage().GetParameters().put('id', insertedTestst.KnowledgeArticleId);                
        ApexPages.KnowledgeArticleVersionStandardController scst = new ApexPages.KnowledgeArticleVersionStandardController(st);
        UniversalService_feedbackctrl stf =new UniversalService_feedbackctrl(scst);
        stf.getItems();
        stf.getReasons();                   
        system.assertnotequals(stf.cbkid,null);
        ApexPages.CurrentPage().GetParameters().put('cbkid', insertedTestst.KnowledgeArticleId); 
        system.assertnotequals(stf.cbk,null);
        system.assertnotequals(stf.filterid,null);
        system.assertnotequals(stf.catDetails,null);       
        system.assertequals(stf.getart(),stf.ID);
        system.assertequals(stf.getsfurll(),stf.sfURL);   
        system.assertequals(stf.getCategory(),stf.CatDetails);
        stf.getReturnid();        
        List<String> myStrings = new List<String> { 'one', 'two' };
        stf.setreasons(mystrings);
        stf.getArticleFeedbackObj();                       
        Article_Feedback__c staf =new Article_Feedback__c();
        staf.Article_Title__c='article_xyz';
        staf.Comments__c='xyz';
        staf.Data_Category__c='eligibility';
        staf.Data_Category_Group__c='visioncare';
        staf.Article_ID__c = insertedTestst.KnowledgeArticleId;
        staf.Article_URL__c='apex/vfp';
        staf.Article_Type__c='corebenefits__Kav';
        stf.setArticleFeedbackObj(staf);
        Test.startTest();           
        insert staf;
        Test.stopTest();
        stf.Comments = 'Test Comment';
        
        List<Universal_Service__DataCategorySelection> catDetailsListInfo= new List<Universal_Service__DataCategorySelection>();    
        Universal_Service__DataCategorySelection catDetailsinfo = new Universal_Service__DataCategorySelection();
        catDetailsListInfo.add(catDetailsinfo);
        stf.setCatDetails(catDetailsListInfo);
        
        stf.saveClick();  
        
        stf.Comments = '';      
        stf.saveClick();
                         
        PageReference pageref = Page.AdditionalBenefits_VFP;
        Test.setCurrentPageReference(pageref);      
        String id = ApexPages.currentPage().getParameters().get('id');
        system.debug('---------------------------id:'+id);
    } 
Jesten Hayle */                                                                   
}