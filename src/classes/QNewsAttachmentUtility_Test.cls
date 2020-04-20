/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class QNewsAttachmentUtility_Test {

    @isTest
	public static void addititionalBenefitsTest() {
        // TO DO: implement unit test
        // Create and Inert test Additional_Benefits Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Additional_Benefits' AND SobjectType = 'Knowledge__kav'];        
        List<QNews__c> lstQNews = new List<QNews__c>();
        
        Knowledge__kav abk = new Knowledge__kav();
        abk.Title='Additional_Benefits';
        abk.Version_Comments__c='Test Coment';
        abk.Exam__c='Test exam';
        abk.Lens__c='TEst';
        abk.Lens_Enhancements__c='TEst';
        abk.Frame__c='TEst';
        abk.Contacts__c='TEst';
        abk.Doctor_Network__c='TEst';
        abk.Lab__c='TEst';
        abk.Support_Queue_Steps__c='TEst';
        abk.URLName = 'Additional-Benefit-Qnews-Test';
        abk.summary='test';
        abk.RecordTypeId = recordIdList.get(0).id;
        
        insert abk;
       
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = abk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Additional_Benefits';
        qn.Article_Title__c = 'Additional_Benefits';
        
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Additional_Benefits'];
        System.assertNotEquals(null, att);
	}
   
    @isTest
    public static void singleTopicTest(){
    // Create and Inert test Single_Topic Knowledge Article Record 
    	List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Single_Topic' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav stk = new Knowledge__kav();
        stk.Title='Single_Topic';
        stk.Version_Comments__c='Test';
        stk.Article_Details__c='Test';
        stk.Support_Queue_Steps__c='Test';
        stk.URLName='Singlge-Topic-Qnews-Test';
        stk.Summary='TEst';
        stk.RecordTypeId = recordIdList.get(0).id;
        
        insert stk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = stk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Single_Topic';
        qn.Article_Title__c = 'Single_Topic';
 
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Single_Topic'];
        System.assertNotEquals(null, att);
    }
 
    @isTest
    public static void supportQueueTest(){
        // Create and Inert test Support_Queue Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Support_Queue' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav sqk = new Knowledge__kav();
        sqk.Title='Support_Queue';
        sqk.Article_Details__c='Test';
        sqk.Support_Queue_Steps__c='test';
        sqk.URLName='Support-Queue-Qnews-Test';
        sqk.Summary='test';
        sqk.RecordTypeId = recordIdList.get(0).id;
        
        insert sqk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = sqk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Support_Queue';
        qn.Article_Title__c = 'Support_Queue';
        
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Support_Queue'];
        System.assertNotEquals(null, att); 
    }
    
    @isTest
	public static void universalServiceTest(){     
        // Create and Inert test Universal_Service Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Universal_Service' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav usk = new Knowledge__kav();
        usk.Title='Universal_Service';
        usk.Version_Comments__c='Test';
        usk.Article_Details__c='Test';
        usk.Support_Queue_Steps__c='test';
        usk.URLName='Universal-Service-Qnews-Test';
        usk.Summary='Test';
        usk.RecordTypeId = recordIdList.get(0).id;
        
        insert usk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = usk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Universal_Service';
        qn.Article_Title__c = 'Universal_Service';
        
		Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Universal_Service'];
        System.assertNotEquals(null, att);
	}
		
    @isTest
    public static void cgTest(){
        // Create and Inert test C_G_Article Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Procedure' AND SobjectType = 'C_G_Article'];
        
        Knowledge__kav cg = new Knowledge__kav();
        cg.Title='C_G_Article';
        cg.Article_Details__c ='Details';
        cg.Support_Queue_Steps__c = 'Test';
        cg.Version_Comments__c = 'Test';
        cg.UrlName = 'Complaints-Greivances-Qnews-Test';
        
        insert cg;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = cg.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='C_G_Article';
        qn.Article_Title__c = 'C_G_Article';
        
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'C_G_Article'];
        System.assertNotEquals(null, att);
	}
    
   	@isTest
	public static void procedureTest(){ 
        // Create and Inert test Procedure Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Procedure' AND SobjectType = 'Knowledge__kav'];
               
		Knowledge__kav pk = new Knowledge__kav();
        pk.Title='Procedure';
        pk.Procedure__c='Procedure';
        pk.Additional_Information__c='Procedure';
        pk.Keywords__c='Procedure';
        pk.Review_Date__c=System.today();
        pk.URLName='Procedure-Qnews-Test';
        pk.Summary='Procedure';
        pk.RecordTypeId = recordIdList.get(0).id;
       
        insert pk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = pk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Procedure';
        qn.Article_Title__c = 'Procedure';
        
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Procedure'];
        System.assertNotEquals(null, att);
	}
        
    @isTest
    public static void externalPublicationTest(){
        // Create and Inert test External_Publication Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'External_Publication' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav epk = new Knowledge__kav();
        epk.Title='External_Publication';
        epk.Details__c='External_Publication';
        epk.Version_Comments__c='External_Publication';
        epk.URLName='External-Publication-Qnews-Test';
        epk.Summary='External_Publication';
        epk.RecordTypeId = recordIdList.get(0).id;
        
        insert epk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = epk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='External_Publication';
        qn.Article_Title__c = 'External_Publication';
        
        Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'External_Publication'];
        System.assertNotEquals(null, att);
    }
    
    @isTest
    public static void coreBenefitTest(){
        // Create and Inert test Core_Benefit Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Core_Benefit' AND SobjectType = 'Knowledge__kav'];

        Knowledge__kav cbk  = new Knowledge__kav();
        cbk.Title='Core_Benefit';
        cbk.Version_Comments__c='Core_Benefit';
        cbk.Exam__c='Core_Benefit';
        cbk.Lens__c='Core_Benefit';
        cbk.Lens_Enhancements__c='Core_Benefit';
        cbk.Frame__c='Core_Benefit';
        cbk.Contacts__c='Core_Benefit';
        cbk.Doctor_Network__c='Core_Benefit';
        cbk.Lab__c='Core_Benefit';
        cbk.Support_Queue_Steps__c='Core_Benefit';
        cbk.Additional_Benefits__c='Core_Benefit';
        cbk.URLName='Core-Benefit-Qnews-Test';
        cbk.Summary='Core_Benefit';
        cbk.RecordTypeId = recordIdList.get(0).id;
        
        insert cbk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = cbk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Core_Benefit';
        qn.Article_Title__c = 'Core_Benefit';
        
		Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Core_Benefit'];
        System.assertNotEquals(null, att);
    } 

    @isTest
    public static void multiTopicTest(){
        // Create and Inert test Multi_Topic Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Multi_Topic' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav mtk = new Knowledge__kav();
        mtk.Title='Multi_Topic';
        mtk.Version_Comments__c='Multi_Topic';
        mtk.Article_Details__c='Multi_Topic';
        mtk.Topic_Links__c='Multi_Topic';
        mtk.Support_Queue_Steps__c='Multi_Topic';
        mtk.URLName='Multi-Topic-Qnews-Test';
        mtk.Summary='Multi_Topic';
        
        insert mtk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = mtk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Multi_Topic';
        qn.Article_Title__c = 'Multi_Topic';
        
	    Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Multi_Topic'];
        System.assertNotEquals(null, att);
    }

    @isTest
    public static void multiTopicDetailsTest(){
        // Create and Inert test Multi_Topic_Details Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Multi_Topic_Details' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav mtdk = new Knowledge__kav();
        mtdk.Title='Multi_Topic_Details';
        mtdk.Version_Comments__c='Multi_Topic_Details';
        mtdk.Article_Details__c='Multi_Topic_Details';
        mtdk.Support_Queue_Steps__c='Multi_Topic_Details';
        mtdk.URLName='Multi-Topic-Details-Qnews-Test';
        mtdk.Summary='Multi_Topic_Details';

        insert mtdk;
        
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = mtdk.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Multi_Topic_Details';
        qn.Article_Title__c = 'Multi_Topic_Details';
        
      	Test.startTest();
        insert qn;
        Test.stopTest();
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Multi_Topic_Details'];
        System.assertNotEquals(null, att); 
    }

    @isTest
	public static void openEnrollmentTest(){
        // Create and Inert test Open_Enrollment Knowledge Article Record 
        List<RecordType> recordIdList = [Select id from RecordType where DeveloperName = 'Open_Enrollment' AND SobjectType = 'Knowledge__kav'];
        
        Knowledge__kav oek = new Knowledge__kav();
        oek.Title='Open_Enrollment';
        oek.Version_Comments__c='Open_Enrollment';
        oek.Enrollment_Start_Date__c=System.today();
        oek.Enrollment_End_Date__c=System.today().addDays(7);
        oek.Benefit_Effective_Data__c=System.today();
        oek.General_Description__c='Open_Enrollment';
        oek.Benefit__c='Open_Enrollment';
        oek.Eligibility__c='Open_Enrollment';
        oek.How_To_Enroll__c='Open_Enrollment';
        oek.Premiums_and_Billing__c='Open_Enrollment';
        oek.Confirmation__c='Open_Enrollment';
        oek.Change_Cancel__c='Open_Enrollment';
        oek.Support_Queue_Steps__c='Open_Enrollment';
        oek.URLName='Open-Enrollment-Qnews-Test';
        oek.Summary='Open_Enrollment';
        oek.RecordTypeId = recordIdList.get(0).id;
        
       	insert oek;
    
        QNews__c qn = new QNews__c();
        qn.Version_History_Version_Id__c = oek.id;
        qn.ForSharePointService__c = true;
        qn.Article_Type__c ='Open_Enrollment';
        qn.Article_Title__c = 'Open_Enrollment';
        
      	Test.startTest();
        insert qn;
        Test.stopTest();  
        
        Attachment att = new Attachment();
        att = [Select id from Attachment where Name = 'Open_Enrollment'];
        System.assertNotEquals(null, att);  
	}
}