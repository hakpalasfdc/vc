trigger ArticleFeedbackAfterTrigger on Article_Feedback__c (after insert) {
   
    List<FeedItem> lstFeeds = new List<FeedItem>();
    
    for(Article_Feedback__c af : Trigger.new) {
        FeedItem fi = new FeedItem();
        fi.Type = 'TextPost';
        fi.Title= af.Name;
        fi.ParentId = af.Article_ID__c;
        fi.Body = af.Comments__c;
        fi.CreatedById=af.CreatedById;
        lstFeeds.add(fi);
    }
    if(lstFeeds.size() > 0) { insert lstFeeds; }   

}