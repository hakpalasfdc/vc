/*@isTest
private class TestBatchApex{
    public static String CRON_EXP = '0 0 1 * * ?';
    @isTest
    static void validateArticleBatchScheduler(){
        Test.startTest();         
        String jobId = System.schedule('testScheduledApex', CRON_EXP, new ArticleBatchScheduler());
        CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
        System.assertEquals(CRON_EXP, ct.CronExpression); 
        System.assertEquals(0, ct.TimesTriggered);
        //System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));            
        Test.stopTest();    
    }    
    static testmethod void validateQNewsUpdateBatch(){
        QNewsUpdateBatch qn = new QNewsUpdateBatch();
            qn.insertQnewsData('Additional_Benefits');                     
    }
}*/

@isTest
public class TestBatchApex{

    static testmethod void validateArticleBatchIterable(){
        ArticleBatchIterable abi = new ArticleBatchIterable(); 
        abi.Iterator();  
    }
    static testmethod void validateArticleBatchScheduler(){
        Test.startTest();
            String CRON_EXP = '0 0 0 1 1 ? 2025';  
            
            ArticleBatchScheduler sch = new ArticleBatchScheduler();
            SchedulableContext sc = null;
            sch.execute(sc);
            
            
            String jobId = System.schedule('testScheduledApex', CRON_EXP, new ArticleBatchScheduler());
            CronTrigger ct = [select id, CronExpression, TimesTriggered, NextFireTime from CronTrigger where id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression); 
            System.assertEquals(0, ct.TimesTriggered);
            System.assertEquals('2025-01-01 00:00:00', String.valueOf(ct.NextFireTime));    

        Test.stopTest();
         
    }
    
    static testmethod void validateArticleBatchIterator(){
        ArticleBatchIterator abit = new ArticleBatchIterator(); 
        abit.hasNext();
        abit.next();        
    }

    static testmethod void validateArticleBatch(){
        Test.startTest();
        ArticleBatch ab = new ArticleBatch();        
        Database.executeBatch(ab);
        Test.StopTest();
    }

    static testmethod void validateQNewsUpdateBatch(){
        Test.setMock(HttpCalloutMock.class, new SharepointHTTPMockSuccess());
        
        Article_Categories__c acs = new Article_Categories__c(); //CC Data Categories custom setting
        acs.Name = 'Eligibility_Related';
        insert acs; 
        
        SharePointWebService__c spws = new SharePointWebService__c();
        spws.Name = 'Credentials';
        spws.Password__c = 'S@le$force1';
        spws.UserName__c = 'salesforce@visionserviceplan.onmicrosoft.com';
        insert spws;
        
        RecordType recType = [select Id from RecordType where DeveloperName = 'Universal_Service' and SObjectType='Knowledge__kav'];
        Knowledge__kav article = new knowledge__kav();
        article.Title = 'Test Title 419';
        article.Version_Comments__c = 'Version 1';
        article.UrlName = 'Test-Title-419';
        article.RecordTypeId = recType.Id;
        insert article;  
        
        article = [SELECT Id,knowledgearticleId from knowledge__kav where Title =: 'Test Title 419' and publishstatus='draft'];
        Knowledge__DataCategorySelection dcs = new Knowledge__DataCategorySelection();
        dcs.ParentId = article.Id;
        dcs.DataCategoryGroupName = 'Vision_Care';
        dcs.DataCategoryName = 'Eligibility_Related';
        insert dcs;   
        
        article = [SELECT knowledgearticleId from knowledge__kav where Title =: 'Test Title 419' and publishstatus='draft'];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);

        article = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article.KnowledgeArticleId and publishstatus='online'];
        KbManagement.PublishingService.editOnlineArticle(article.KnowledgeArticleId, true);
        article = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article.KnowledgeArticleId and publishstatus='draft'];
        article.Version_Comments__c = 'Version 2';
        update article;
        article = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article.KnowledgeArticleId and publishstatus='draft'];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
        
        RecordType recType2 = [select Id from RecordType where DeveloperName = 'Additional_Benefits' and SObjectType='Knowledge__kav'];
        Knowledge__kav article2 = new knowledge__kav();
        article2.Title = 'Test Title 421';
        article2.Version_Comments__c = 'Version 1';
        article2.UrlName = 'Test-Title-421';
        article2.RecordTypeId = recType2.Id;
        insert article2;  
         
        article2 = [SELECT Id,knowledgearticleId from knowledge__kav where Title =: 'Test Title 421' and publishstatus='draft'];
        Knowledge__DataCategorySelection dcs2 = new Knowledge__DataCategorySelection();
        dcs2.ParentId = article2.Id;
        dcs2.DataCategoryGroupName = 'Vision_Care';
        dcs2.DataCategoryName = 'Eligibility_Related';
        insert dcs2;   

        article2 = [SELECT knowledgearticleId from knowledge__kav where Title =: 'Test Title 421' and publishstatus='draft'];
        KbManagement.PublishingService.publishArticle(article2.KnowledgeArticleId, true);
        article2 = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article2.KnowledgeArticleId and publishstatus='online'];
        KbManagement.PublishingService.editOnlineArticle(article2.KnowledgeArticleId, true);
        article2 = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article2.KnowledgeArticleId and publishstatus='draft'];
        article2.Version_Comments__c = 'Version 2';
        update article2;
        article2 = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article2.KnowledgeArticleId and publishstatus='draft'];
        KbManagement.PublishingService.publishArticle(article2.KnowledgeArticleId, true);
        article2 = [SELECT knowledgearticleId from knowledge__kav where knowledgearticleId =: article2.KnowledgeArticleId and publishstatus='online'];

		QNewsUpdateBatch qnub = new QNewsUpdateBatch();
        
        Test.startTest();
        qnub.insertQnewsData('Universal_Service');
        qnub.insertQnewsData('Additional_Benefits');
        Test.stopTest();
		
        List<QNews__c> qnews = [SELECT Id from QNews__c Where Article_Title__c = 'Test Title 419' and ForSharePointService__c = true];
        system.assertEquals(2,qnews.size());
        
        List<QNews__c> qnews2 = [SELECT Id from QNews__c Where Article_Title__c = 'Test Title 421' and ForSharePointService__c = true];
        system.assertEquals(2,qnews2.size());
    }
}