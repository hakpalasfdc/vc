@isTest
public class ArticleFeedbackAfterTrigger_Test {
    @isTest
    public static void triggerTest(){

        knowledge__kav article = new knowledge__kav();
        article.Title = 'Eligibility-Member';
        article.UrlName = 'URLNameTest';
        insert article;
        article = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Id =: article.Id and PublishStatus = 'draft'];
        KbManagement.PublishingService.publishArticle(article.KnowledgeArticleId, true);
        knowledge__kav kav = [SELECT KnowledgeArticleId FROM Knowledge__kav WHERE Title = 'Eligibility-Member' AND PublishStatus = 'Online'];

        Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();           
        //ArticleFeedbackObj.Article_ID__c = 'kA5U0000000CbgT'; //Eligibility-Member KnowledgearticleId
        ArticleFeedbackObj.Article_ID__c = kav.KnowledgeArticleId;
        ArticleFeedbackObj.Article_Title__c = 'Eligbility-Member';
        ArticleFeedbackObj.Article_Type__c = 'Multi-Topic';
        ArticleFeedbackObj.Article_URL__c = 'http://www.vsp.com';    
        ArticleFeedbackObj.Comments__c = 'Teste Comments';
        articleFeedbackObj.Reason__c = 'test reason';
        
        test.startTest();
        insert articleFeedbackObj;
        test.stopTest();
        
        FeedItem fi = [SELECT Id from FeedItem WHERE Type = 'TextPost'];
        
        system.assertNotEquals(null, fi);
    }
}