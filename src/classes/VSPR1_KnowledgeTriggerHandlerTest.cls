@IsTest
private class VSPR1_KnowledgeTriggerHandlerTest{

    static testmethod void TestKnowledge(){
        
        //Add email for Procedure - current user should generate and email
        id i3 = testDataFactory.createGroupArticleOwners('Procedure','test.abc@gmail.com');

        Knowledge__kav article = testDataFactory.createKnowledge('Procedure');
        
        User testuser2 = testdatafactory.createUser('John', 'Jones');
        User CurrUser = [Select id, name from User where id =: UserInfo.getUserID()]; 
        
        //Add testuser1 to allowable Editors but not testuser2 - testuser2 = email recipient
        id i1 = testDataFactory.createArticleEditors('Procedure', CurrUser);
        id i2 = testDataFactory.createUserArticleOwners('Procedure', testUser2);
        
        //Now Current User has Edit capabiity so won't generate an email
        Knowledge__kav article2 = testDataFactory.createKnowledge('Procedure');

    } 
    @istest(SeeAllData=true)
    public static void testChatter(){
        Knowledge__kav testArticle = new Knowledge__Kav();
        testArticle.Summary = 'this is the test article summary';
        testArticle.Title = 'test article title';
        testArticle.UrlName = 'test-article-urlname';
        insert testArticle;
        Knowledge__Kav artId = [select id, Feedback_Submitted__c, Title, UrlName, KnowledgeArticleId from Knowledge__kav where summary='this is the test article summary' and Title = 'test article title' and UrlName ='test-article-urlname' and PublishStatus='draft'];
        KbManagement.PublishingService.publishArticle(artId.KnowledgeArticleId, true);
        /*artId.Feedback_Submitted__c = true; 
		update artId; 
        Knowledge__Kav artId2 = [Select id, Feedback_Submitted__c, Title, UrlName from Knowledge__kav where summary='this is the test article summary' and Feedback_Submitted__c=true and Title = 'test article title' and UrlName ='test-article-urlname'];
        KbManagement.PublishingService.publishArticle(artId2.id, true);
		*/
    }
}