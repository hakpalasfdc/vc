@isTest
public class VSPR2_ConsumerSearch_Test {
    @isTest
    public static void testConsumerSearch(){
     
        //create Person Account
        Id paId = testdatafactory.createPersonAccount('personAccount');
    	//    Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        //Need to create Custom Setting so that VSPR16_GetConsumerID.getConsumerID2 doesnt error
        DVIWebService__c dviCustSetting = testDataFactory.setDVISettings();
        Consumer_Search_Web_Service__c CSCustSetting =testDataFactory.setCSSettings();
        CC_Portal__c ccPortalSettings = testDataFactory.setCCPortalSettings();
       
    	/*    VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok;*/  
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
       
        caseobj.recordtypeId = rtId;
           
        insert caseobj; 
        
        consumerseachresults__c csr = new consumerseachresults__c();
        csr.City__c = 'Ranch Cordova';
        insert csr; 
        
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;
      
        Test.startTest();
        Test.setCurrentPageReference(new PageReference('VSPR2_ConsumerSearch.VSPR2_ConsumerSearch'));      
         
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
   
        VSPR2_ConsumerSearch cs = new VSPR2_ConsumerSearch(sc);
        cs.reset();
      
        cs.firstname='ABCDEF';
        cs.lastName='GHIJKL';
        cs.callername='test';
        cs.calltype = 'Member';
        cs.midname='';
        cs.remdob = false;
        cs.activeOnly = false;
        cs.include = true;
        cs.primaryMemberConsumerID = '';
        cs.callerintent = 'B9902';
        cs.ConsumerId = '5'; 
        cs.dob = '03/08/1901';
        cs.classId = '0100';
        cs.reason = 'Benefits';
        cs.reasondetail = 'Benefits detail';
        cs.ciscoContactId = '4';
        cs.ANI = '2';
        cs.DNIS = '1112223333';
        cs.policyid = '4';
        cs.channel = 'phone';
        cs.CEP = '2223334444';
        cs.custBody = 'body';
        
        cs.setparams();
        cs.storeIVRparameters();
        cs.APIsearchRecords();
        cs.togglesort();
        cs.createcase();  //This creates case from JSON
        
        cs.caseobj.PersonAccount__c = paId;      
        cs.createcase();  //This creates case from Person Account
        
        cs.setparams(); 
        cs.getfirstname();
        cs.getlastname();         
        cs.getrelation();         
        cs.getcontactId(); 
        cs.getbirthdate();
        cs.getasofdate();
        cs.getcity();
        cs.getemail();
        cs.getlast4();  
        cs.getlastname();
        cs.getfirstname();
        cs.getrelation();
        cs.getmidname();
        cs.getclientid();
        cs.getinclude();
        cs.getremdob();
        cs.getdob();
        cs.getcname();
        cs.getclassification();
        cs.getphone();
        cs.getactiveOnly();
        cs.getQ();
        cs.getrefresh();
        // gets memberId (capital I)
        cs.get();
        //
        cs.getauth();
        cs.getconsumerId();
        cs.getauthenticated();
        cs.getcallername();
        cs.getsubject();
        cs.getcallerintent();
        cs.getstate();
        cs.gettocase();
        cs.getIVRCalltype();
        cs.getcalltype();
        cs.getConsumers();
        cs.setConsumerID();
        cs.getmemberIds();
        cs.getconsumerids();
        cs.getsortfield(); 
        cs.getauths();
        cs.getnames();
        cs.getname();
        cs.getcaseid();
        cs.getStates();
        cs.getdebugSoql();
        String result = VSPR2_ConsumerSearch.getCCPURL();
        PageReference result2 = VSPR2_ConsumerSearch.finalReset();
        Test.stopTest();
        
        //Assert that case was created and Person Account and Member Plan
        //Contact field = Consumer_ID__c and on Account = Consumer_ID__pc
        String cid = '999999999';
        List<Account> pList = new List<Account>([SELECT id 
                                                 FROM Account 
                                                 WHERE Consumer_Id__pc=:cId]);
        List<Case> caseList = new List<Case>([SELECT ID, Member_Plan__c, AccountId from Case 
                                                WHERE createddate=TODAY 
                                                AND AccountId =:paId
                                                ]);
        //System.Assertequals(caseList.size(),1);
        
        
       
    }
    // need to mock the page 
  /*  @isTest
    public static void testConsumerSearch_validation(){
             
        //create Person Account
        Id paId = testdatafactory.createPersonAccount('personAccount');
    	//    Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        //Need to create Custom Setting so that VSPR16_GetConsumerID.getConsumerID2 doesnt error
        DVIWebService__c dviCustSetting = testDataFactory.setDVISettings();
        Consumer_Search_Web_Service__c CSCustSetting =testDataFactory.setCSSettings();
        CC_Portal__c ccPortalSettings = testDataFactory.setCCPortalSettings();
        
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
       
        caseobj.recordtypeId = rtId;
           
        insert caseobj; 
        
        consumerseachresults__c csr = new consumerseachresults__c();
        csr.City__c = 'Ranch Cordova';
        insert csr; 
        
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;
      
        Test.startTest();
        PageReference page = new PageReference('VSPR2_ConsumerSearch.VSPR2_ConsumerSearch');
        Test.setCurrentPageReference(page);
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
   
        VSPR2_ConsumerSearch cs = new VSPR2_ConsumerSearch(sc);
        cs.dob ='07/28/1983';
        cs.APIsearchRecords();
        List<Apexpages.Message> msgs = ApexPages.getMessages();
    	boolean b = false;
    	for(Apexpages.Message msg:msgs){
            System.debug(msg.getDetail());
            if (msg.getDetail().contains('A user account for this email address already exists')) {
                
            }
       }	
        Test.stopTest();
        
    } */
    
}