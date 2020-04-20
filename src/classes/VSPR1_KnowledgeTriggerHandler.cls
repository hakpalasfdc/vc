public with sharing class VSPR1_KnowledgeTriggerHandler { 
/*Created by: Elly Bockley - Eagle Creek Software Services
  Date: April 2019
  Description: This handles the Updates/Deletes to an Article
               If a person is not allowed to edit/delete and email is sent to the owner
               Whether a person can edit or delete is defined in Article_Permissions__c
               The person(s) who receive the email are also defined there. 
               The Record Type Name exists on teh Knowledge Article
               This trigger will not run in batch updates - only sends email once
			   Need to send separate emails in case there are multiple Owners - in order to fillin the Owner field	
*/

    public void onBefore(List<Knowledge__kav> newArticles) { 
        
         String userPermissions = setPermissions(); 
        
         String trigger_type = 'modification';
         Knowledge__kav newArticle;
         
         for(Knowledge__kav kav:newArticles){
             newArticle = kav; 
         }
          
        List<String> recipients = getEmailRecipients(newArticle.Article_Record_Type_Name__c); 
        List<String> ownerNames = getOwnerNames(newArticle.Article_Record_Type_Name__c); 
            
             if(trigger.isDelete){
                 trigger_type = 'deletion';
             }       
             
            
             //Now see if the current user has this permission
                 if(userPermissions == null || !userPermissions.contains(newArticle.Article_Record_Type_Name__c)){
                    
                     if(recipients.size() >0){
                         for(Integer i = 0; i < recipients.size(); i++){
                      	   SendEmail(trigger_type, recipients[i], ownerNames[i], newArticle); 
                     }
                     }   
                 }
         
    }
    public String setPermissions(){
    //Get the list of permissions for current user
    Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Editors').getRecordTypeId();
     
     List<Article_Permission__c> permList = new List<Article_Permission__c>(
         [SELECT id, User__c, Article_Type__c 
          FROM Article_Permission__c
          WHERE RecordtypeId =: rtId
          AND User__c =: UserInfo.getUserId()
           ]);
     String permissionList='';
     
     if(permList.size() >0){
         permissionList = permList[0].Article_Type__c;
     }
      
     return permissionList;
    }
   
    public List<String> getEmailRecipients(String aType){
    //Get the list of recipients for the current Record Type
   
     Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Article Owners').getRecordTypeId();
    
     List<Article_Permission__c> emailList = new List<Article_Permission__c>(
         [SELECT id, Article_Type__c, UserEmail__c
          FROM Article_Permission__c
          WHERE RecordtypeId =: rtId
           ]);
    
     List<String> recipients = new List<String>();
 
     //There can be multiple recipients per Knowledge Record Type
         for(Article_Permission__c a:emailList){
         
             if(a.Article_Type__c.contains(aType)){
                     recipients.add(a.UserEmail__c);                    
       
             }
         }
    System.debug('### size of recipients = ' + recipients.size() );
     return recipients;
    }
    
    public List<String> getOwnerNames(String aType){
    //Get the list of recipients for the current Record Type
   
     Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Article Owners').getRecordTypeId();
    
     List<Article_Permission__c> emailList = new List<Article_Permission__c>(
         [SELECT id, Article_Type__c, OwnerName__c
          FROM Article_Permission__c
          WHERE RecordtypeId =: rtId
           ]);
    
     List<String> ownerNames = new List<String>();
 
     //There can be multiple recipients per Knowledge Record Type - if groupemail, use that email as the OwnerName
        for(Article_Permission__c a:emailList){
         
             if(a.Article_Type__c.contains(aType)){         
     	        ownerNames.add(a.OwnerName__c);                    
             }
		}
     return ownerNames;
    }
   
    public void sendEmail(string updatetype, String recipient, String ownerName, Knowledge__kav kArticle ){
      
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        List<String> recipients = new List<String>(); //need to pass List
        recipients.add(recipient);
        message.setToAddresses(recipients);
        message.Subject = 'Article Modification Notification';
        
        String Body = 'Dear '+ ownerName +'</p>';
        Body =  Body + 'There has recently been a ' +updatetype+ ' to an article you own. </p>';
        Body = Body+'Modified By: '+ userInfo.getName()+'</p>Date/Time of Change: '+ kArticle.lastModifiedDate;
        Body = Body + '<p/>Article Title: '+ kArticle.Title + '</p>Article Number: '+ kArticle.ArticleNumber;
        Body = Body + '<p/>Please review the article content and contact the modifier if appropriate.';
        message.setHTMLBODY(Body);
               
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>{message};
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
        if(results[0].success){
            System.debug('###Message sent');
        }
        else{
            System.debug('###Email failed to send'+results[0].errors[0].message);
        }
       
    }
    public void chatterPost(List<Knowledge__kav> newArticles){
		for(integer i = 0; i<newArticles.size(); i++ ){
        	if(newArticles.get(i).Feedback_Submitted__c == true && newArticles.get(i).isLatestVersion == true){			
            	ConnectApi.FeedElement feedElement = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), newArticles.get(i).id, ConnectApi.FeedElementType.FeedItem, 'Feedback was submitted on this article');
        	}
    	} 
    }
}