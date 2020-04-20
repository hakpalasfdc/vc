@isTest
private class ArticleFeedbackTrigger_TestClass {
/* Jesten Hayle
    static testmethod void testTrigger(){ 
        Core_Benefit__kav cb = new Core_Benefit__kav();
        cb.Title = 'ArticleFeedbackTriggerTest';
        cb.urlname = 'ArticleFeedbackTriggerTest';
        insert cb;
        Core_Benefit__kav insertedTestcb = [Select KnowledgeArticleId from Core_Benefit__kav where ID = :cb.Id];
        KbManagement.PublishingService.publishArticle(insertedTestcb.KnowledgeArticleId, true);
                
        Article_Feedback__c af =new Article_Feedback__c();
        af.Comments__c='Testing';
        af.Article_ID__c=insertedTestcb.KnowledgeArticleId;
        system.debug('=================15======'+af.Article_ID__c);
        af.Reason__c='Other';
        af.Article_Title__c=cb.Title;
        insert af;
        //Core_Benefit__Feed cbfeed=[SELECT Body,ParentId,Title,Type FROM Core_Benefit__Feed WHERE ParentId = :cb.KnowledgeArticleId LIMIT 1];
        //List<FeedItem> lstFeeds = new List<FeedItem>();
        FeedItem fi = new FeedItem();
        fi.Type = 'TextPost';
        fi.Title= 'test article';
        fi.ParentId = af.Article_ID__c;
        fi.Body = af.Comments__c;       
        insert fi;
    }
Jesten Hayle */
}