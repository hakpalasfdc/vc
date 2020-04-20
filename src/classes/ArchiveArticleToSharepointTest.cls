/*  Created Date : 21th June 2016
    Related Class : ArchiveArticleToSharepoint
    Related Object : QNews__c Custom Object
    Related Case : #9251.
    Description : This class is for the Unit Testing purpose of ArchiveArticleToSharepoint Batch Class .
*/ 
@isTest
public class ArchiveArticleToSharepointTest { 
	@istest
   	static void ArchiveArticleToSharepointBatchTestSuccess(){
		Test.setMock(HttpCalloutMock.class, new SharepointHTTPMockSuccess());
       	Exception_Handler_Email__c ehe = new Exception_Handler_Email__c();
        ehe.Name = 'jhayle@eaglecrk.com';
        insert ehe;
       
        SharePointWebService__c my_setting = new SharePointWebService__c(Name = 'Credentials',
        	UserName__c='salesforce@visionserviceplan.onmicrosoft.com',
            Password__c = 'S@le$force1'
            );          
		insert my_setting; 
       
        List<QNews__c> qNewstestList = new List<QNews__c >();
        List<Attachment> attachList = new List<Attachment>();
        for(Integer i =0 ; i<= 90; i++){
            QNews__c qnewsTest = new QNews__c();
            qnewsTest.ForSharePointService__c = true;
            qnewsTest.Article_Type__c = 'External_Publication';
            qnewsTest.Article_ID__c = '1234';
            qnewsTest.Article_Version_Number__c = '12';
            qnewsTest.Data_Category__c = 'Test';
            qnewsTest.Article_Title__c = 'Title'+i;
            qNewstestList.add(qnewsTest);
        } 

        QNews__c qnewsTestNew = new QNews__c();
        qnewsTestNew.ForSharePointService__c = true;
        qnewsTestNew.Article_Type__c = 'Procedure';
        qnewsTestNew.Article_ID__c = '1234';
        qnewsTestNew.Article_Version_Number__c = '12';
        qnewsTestNew.Data_Category__c = 'Test';
        qnewsTestNew.Article_Title__c = 'Test1';
        
        qNewstestList.add(qnewsTestNew); 
        
        QNews__c qnewsTestNew1 = new QNews__c();
        qnewsTestNew1.ForSharePointService__c = true;
        qnewsTestNew1.Article_Type__c = 'Proce__kav';
        qnewsTestNew1.Article_ID__c = '1234';
        qnewsTestNew1.Article_Version_Number__c = '12';
        qnewsTestNew1.Data_Category__c = 'Test'; 
        qnewsTestNew1.Article_Title__c = 'Test Proce__kav title';
        qNewstestList.add(qnewsTestNew1);
         
        System.debug('#### qNewstestList = >'+qNewstestList + ' and Size() = > ' + qNewstestList.size());
        insert qNewstestList;
        
        ArchiveArticleToSharepoint TestObj = new ArchiveArticleToSharepoint();
        
        Test.StartTest();  
        Database.executeBatch(TestObj);
        Test.StopTest();
        
        List<Attachment> atts = [SELECT Id from Attachment];
        System.assertEquals(0, atts.size());
        
        List<QNews__c> qns = [Select Id from QNews__c where ForSharePointService__c = true];
        System.assertEquals(0, qns.size());
	}

    @isTest
	static void ArchiveArticleToSharepointBatchTestFailure(){
		Test.setMock(HttpCalloutMock.class, new SharepointHTTPMockFailure());
       	Exception_Handler_Email__c ehe = new Exception_Handler_Email__c();
        ehe.Name = 'jhayle@eaglecrk.com';
        insert ehe;
       
        SharePointWebService__c my_setting = new SharePointWebService__c(Name = 'Credentials',
        	UserName__c='salesforce@visionserviceplan.onmicrosoft.com',
            Password__c = 'S@le$force1'
        );          
		insert my_setting; 
       
        List<QNews__c> qNewstestList = new List<QNews__c >();
        List<Attachment> attachList = new List<Attachment>();
        for(Integer i =0 ; i<= 90; i++){
            QNews__c qnewsTest = new QNews__c();
            qnewsTest.ForSharePointService__c = true;
            qnewsTest.Article_Type__c = 'External_Publication';
            qnewsTest.Article_ID__c = '1234';
            qnewsTest.Article_Version_Number__c = '12';
            qnewsTest.Data_Category__c = 'Test';
            qnewsTest.Article_Title__c = 'Title'+i;
            qNewstestList.add(qnewsTest);
        } 

        QNews__c qnewsTestNew = new QNews__c();
        qnewsTestNew.ForSharePointService__c = true;
        qnewsTestNew.Article_Type__c = 'Procedure';
        qnewsTestNew.Article_ID__c = '1234';
        qnewsTestNew.Article_Version_Number__c = '12';
        qnewsTestNew.Data_Category__c = 'Test';
       	qnewsTestNew.Article_Title__c = 'Test1';
         
        qNewstestList.add(qnewsTestNew); 
          
        QNews__c qnewsTestNew1 = new QNews__c();
        qnewsTestNew1.ForSharePointService__c = true;
        qnewsTestNew1.Article_Type__c = 'Proce__kav';
        qnewsTestNew1.Article_ID__c = '1234';
        qnewsTestNew1.Article_Version_Number__c = '12';
        qnewsTestNew1.Data_Category__c = 'Test'; 
        qnewsTestNew1.Article_Title__c = 'Test Proce__kav title';
        qNewstestList.add(qnewsTestNew1);
          
        System.debug('#### qNewstestList = >'+qNewstestList + ' and Size() = > ' + qNewstestList.size());
        insert qNewstestList; 

        ArchiveArticleToSharepoint TestObj = new ArchiveArticleToSharepoint();
        
        Test.StartTest(); 
        Database.executeBatch(TestObj);
        Test.stopTest();
        
        List<Attachment> atts = [SELECT Id from Attachment];
        System.assertEquals(93, atts.size());
        
        List<QNews__c> qns = [Select Id from QNews__c where ForSharePointService__c = true];
        System.assertEquals(93, qns.size());
	}
}