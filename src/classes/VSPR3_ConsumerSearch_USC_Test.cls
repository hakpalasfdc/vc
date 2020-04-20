@isTest
public class VSPR3_ConsumerSearch_USC_Test {
    @isTest
    public static void eyeconicSearch_EmailAndOrderNum(){
        Id paRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC cslc = new VSPR3_ConsumerSearch_USC(sc);
		cslc.eyeOrderNum = '123';
        cslc.eyeEmailAddr = 'eyemail@email.com';
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecTypeId;
        pa1.LastName = 'last1';
        pa1.Eyeconic_Recent_Order_Number__pc = '123';
        pa1.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa1;
        
        Account pa2 = new Account();
        pa2.RecordTypeId = paRecTypeId;
        pa2.LastName = 'last2';
        pa2.Eyeconic_Recent_Order_Number__pc = '124';
        pa2.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa2;
        
        Test.startTest();
        cslc.eyeconicSearch();
        Test.stopTest();
        
        System.assertEquals(2, cslc.paList.size());
    }
    
    @isTest
    public static void eyeconicSearch_OnlyOrderNum(){
        Id paRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC cslc = new VSPR3_ConsumerSearch_USC(sc);
		cslc.eyeOrderNum = '123';
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecTypeId;
        pa1.LastName = 'last1';
        pa1.Eyeconic_Recent_Order_Number__pc = '123';
        pa1.Eyeconic_Login_Email__pc = 'eyemail@email.com';
        insert pa1;
        
        Account pa2 = new Account();
        pa2.RecordTypeId = paRecTypeId;
        pa2.LastName = 'last2';
        pa2.Eyeconic_Recent_Order_Number__pc = '123';
        pa2.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa2;
        
        Test.startTest();
        cslc.eyeconicSearch();
        Test.stopTest();
        
        System.assertEquals(2, cslc.paList.size());
    }
    
    @isTest
    public static void eyeconicSearch_OnlyEmail(){
        Id paRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC cslc = new VSPR3_ConsumerSearch_USC(sc);
        cslc.eyeEmailAddr = 'eyemail@email.com';
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecTypeId;
        pa1.LastName = 'last1';
        pa1.Eyeconic_Recent_Order_Number__pc = '123';
        pa1.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa1;
        
        Account pa2 = new Account();
        pa2.RecordTypeId = paRecTypeId;
        pa2.LastName = 'last2';
        pa2.Eyeconic_Recent_Order_Number__pc = '123';
        pa2.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa2;
        
        Test.startTest();
        cslc.eyeconicSearch();
        Test.stopTest();
        
        System.assertEquals(2, cslc.paList.size());
    }
    
    @isTest
    public static void eyeconicSearch_NoResults(){
        Id paRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC cslc = new VSPR3_ConsumerSearch_USC(sc);
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecTypeId;
        pa1.LastName = 'last1';
        pa1.Eyeconic_Customer_Number__pc = '123';
        pa1.Eyeconic_Login_Email__pc = 'eyemail@email.com';
        insert pa1;
        
        Account pa2 = new Account();
        pa2.RecordTypeId = paRecTypeId;
        pa2.LastName = 'last2';
        pa2.Eyeconic_Recent_Order_Number__pc = '123';
        pa2.Eyeconic_Email__pc = 'eyemail@email.com';
        insert pa2;
        
        Test.startTest();
        cslc.eyeconicSearch();
        Test.stopTest();
        
        System.assertEquals(0, cslc.paList.size());
        system.assertEquals(1, apexpages.getMessages().size());
    }
    
    @isTest
    public static void attachToCaseWithPerson(){
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        Id eyeRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
        Id paRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        
        Case testCase = new Case();
        testCase.RecordTypeId = eyeRecTypeId;
        testCase.Product__c = 'Eyeconic Ops';
        testCase.Caller_Type__c = 'Member';
        insert testCase;
        
        Account pa1 = new Account();
        pa1.RecordTypeId = paRecTypeId;
        pa1.LastName = 'last1';
        pa1.Eyeconic_Customer_Number__pc = '123';
        pa1.Eyeconic_Login_Email__pc = 'eyemail@email.com';
        insert pa1;
        
        pa1 = [SELECT PersonContactId FROM Account WHERE LastName = 'last1'];
        
        ApexPages.StandardController sc = new ApexPages.standardController(testCase);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.selectedPersonId = pa1.PersonContactId;
        
        Test.startTest();
        csUSC.attachToCase();
        Test.stopTest();
        
        testCase = [SELECT ContactId FROM Case WHERE Id =: testCase.Id];
        System.assertEquals(pa1.PersonContactId, testCase.ContactId);
    }
    
    @isTest
    public static void attachToCaseWithoutPerson(){
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        Id eyeRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
        
        Case testCase = new Case();
        testCase.RecordTypeId = eyeRecTypeId;
        testCase.Product__c = 'Eyeconic Ops';
        testCase.Caller_Type__c = 'Member';
        insert testCase;
        
        ApexPages.StandardController sc = new ApexPages.standardController(testCase);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        
        Test.startTest();
        csUSC.attachToCase();
        Test.stopTest();
        
        testCase = [SELECT ContactId FROM Case WHERE Id =: testCase.Id];
        System.assertEquals(null, testCase.ContactId);
        System.assertEquals(1, apexpages.getMessages().size());
    }
    
    @isTest
    public static void searchRecords401(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock_Code401());
        TestDataFactory.setCSSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '03/08/1901';
        csUSC.include = false;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
         
        test.startTest();
        csUSC.APIsearchRecords();
        test.stopTest(); 
        
        system.assertEquals(0, csUSC.searchResults.size());
        system.assertEquals(1, apexpages.getMessages().size());
        system.assertEquals('401 Unauthorized', apexpages.getMessages().get(0).getDetail());
    }
    
    @isTest
    public static void searchRecords503(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock_Code503());
        TestDataFactory.setCSSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '03/08/1901';
        csUSC.include = false;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        test.stopTest(); 
        
        system.assertEquals(0, csUSC.searchResults.size());
        system.assertEquals(1, apexpages.getMessages().size());
        system.assertEquals('Please try your search again. We are experiencing slow response times.', apexpages.getMessages().get(0).getDetail());
    }
    
    @isTest
    public static void searchRecords500(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock_Code500());
        TestDataFactory.setCSSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '03/08/1901';
        csUSC.include = false;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        test.stopTest(); 
        
        system.assertEquals(0, csUSC.searchResults.size());
        system.assertEquals(1, apexpages.getMessages().size());
        system.assertEquals('No results found for your Search Criteria - ensure you entered First and LastName, Auth# or Expanded ID', apexpages.getMessages().get(0).getDetail());
    }

    @isTest
    public static void constructor(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok;  
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC cslc = new VSPR3_ConsumerSearch_USC(sc);
        cslc.contactId = '';
        cslc.midname = '';
        cslc.relation = '';
        cslc.classId = '';
        cslc.reason = '';
        cslc.reasondetail = '';
        cslc.authenticated = true;
        cslc.classification = '';
        cslc.ciscoContactId = '';
        cslc.ivrcalltype = '';
        cslc.ANI = '';
        cslc.DNIS = '';
        cslc.subject = '';
        cslc.policyid = '';
        cslc.channel = '';
        cslc.CEP = '';
        cslc.uscCaseId = '';
        
        insert caseobj;
        sc = new ApexPages.standardController(caseobj);
        cslc = new VSPR3_ConsumerSearch_USC(sc);
        
        Id uscRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        caseobj.RecordTypeId = uscRecTypeId;
        caseobj.Description = 'test';
        update caseobj;
        
        sc = new ApexPages.standardController(caseobj);
        cslc = new VSPR3_ConsumerSearch_USC(sc);
        
        caseobj = [select CallerType__c FROM Case where Id =: caseobj.id];
        system.assertEquals('Member', cslc.caseobj.CallerType__c);
    }
    
    @isTest
    public static void getCCPUrl(){
        string ccpURL;
        CC_Portal__c ccp = new CC_Portal__c();
        ccp.Name = 'Environment';
        ccp.Base_URL__c = 'https://vsp.com';
        ccp.Ready_URL__c = '/csrportal/ctiEvent/answered?SalesforceReadOnlyMode=True';        
        insert ccp;
        
        test.startTest();
        ccpURL = VSPR3_ConsumerSearch_USC.getCCPURL();
        test.stopTest();
        
        system.assertEquals('https://vsp.com', ccpURL);
    } 
     
    @isTest
    public static void searchRecords(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '03/08/1901';
        csUSC.include = false;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        test.stopTest(); 
        
        system.assertEquals(1, csUSC.searchResults.size());
    }

    @isTest
    public static void updateCaseNoPA(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        TestDataFactory.setCCPortalSettings();
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        Id uscRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        caseobj.RecordTypeId = uscRecTypeId;
        caseobj.Description = 'test';
        insert caseobj;
        
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.callername = 'J Smith';
        csUSC.callerintent = 'B9902';
        csUSC.dob = '03/08/1901';
        csUSC.include = true;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        csUSC.wrapcsrList[0].isSelected = true;
        test.stopTest();
        
        csUSC.updateCase();
        caseobj = [SELECT Member_Plan__c,CallerType__c,Reason__c,Reason_Details__c,Consumer_ID__c,AccountId,PersonAccount__c,RecordTypeId,CaseNumber FROM Case WHERE Id =:caseobj.Id];
        system.assertNotEquals(null, caseobj.AccountId);
        system.assertNotEquals(null, caseobj.Member_Plan__c);
    }

    @isTest
    public static void updateCaseFoundPAandMP(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        TestDataFactory.setCCPortalSettings();
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;
        
        Account perAccount = new Account();
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        perAccount.RecordTypeId = personAccountRecordType.Id;
        perAccount.ConsumerID__c = '999999999';
        perAccount.LastName = 'lname';
        insert perAccount;
        
        MemberPlan membPlan = new MemberPlan();
        membPlan.Client_ID__c = '30023319';
        membPlan.Division_ID__c = '0061';
        membPlan.MemberId = perAccount.Id;
        membPlan.Name = 'testName';
        insert membPlan;
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        Id uscRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        caseobj.RecordTypeId = uscRecTypeId;
        caseobj.Description = 'test';
        insert caseobj;
        
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.callername = 'J Smith';
        csUSC.callerintent = 'B9902';
        csUSC.dob = '03/08/1901';
        csUSC.include = true;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        csUSC.wrapcsrList[0].isSelected = true;
        test.stopTest();
        
        csUSC.updateCase();
        
        caseobj = [SELECT Member_Plan__c,CallerType__c,Reason__c,Reason_Details__c,Consumer_ID__c,AccountId,PersonAccount__c,RecordTypeId,CaseNumber FROM Case WHERE Id =:caseobj.Id];
        system.assertEquals(perAccount.Id, caseobj.AccountId);
        system.assertEquals(membPlan.Id, caseobj.Member_Plan__c);
    }
    
    @isTest
    public static void updateCaseFoundPANoMP(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        TestDataFactory.setCCPortalSettings();
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;
        
        Account perAccount = new Account();
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        perAccount.RecordTypeId = personAccountRecordType.Id;
        perAccount.ConsumerID__c = '999999999';
        perAccount.LastName = 'lname';
        insert perAccount;
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        Id uscRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        caseobj.RecordTypeId = uscRecTypeId;
        caseobj.Description = 'test';
        insert caseobj;
        
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.callername = 'J Smith';
        csUSC.callerintent = 'B9902';
        csUSC.dob = '03/08/1901';
        csUSC.include = true;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        csUSC.wrapcsrList[0].isSelected = true;
        test.stopTest();
        
        csUSC.updateCase();
        
        caseobj = [SELECT Member_Plan__c,CallerType__c,Reason__c,Reason_Details__c,Consumer_ID__c,AccountId,PersonAccount__c,RecordTypeId,CaseNumber FROM Case WHERE Id =:caseobj.Id];
        system.assertEquals(perAccount.Id, caseobj.AccountId);
        system.assertNOtEquals(null, caseobj.Member_Plan__c);
    }
    
    @isTest
    public static void finalReset(){
        ConsumerSeachResults__c csr = new ConsumerSeachResults__c();
        insert csr;
        Case caseobj = new case();
        
        Test.startTest();
        VSPR3_ConsumerSearch_USC.finalReset();
        Test.stopTest();
        
        List<ConsumerSeachResults__c> csrs = new List<ConsumerSeachResults__c>();
        csrs = [SELECT Id FROM ConsumerSeachResults__c WHERE createdBy__c =: userInfo.getUserId()];
        system.assertEquals(0, csrs.size());
    }
    
    @isTest
    public static void reset(){
        Case caseobj = new Case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.memberid = '1';
        VSPR3_ConsumerSearch_USC.ConsumerId = '2';
        csUSC.dob = '01/01/1901';
        
        consumerseachresults__c csr = new consumerseachresults__c();
        insert csr;
        
        test.startTest();
        csUSC.reset();
        test.stopTest();
        
        system.assertEquals('', csUSC.memberid);
        system.assertEquals('', VSPR3_ConsumerSearch_USC.ConsumerId);
        system.assertEquals('', csUSC.dob);
    }
    
    @isTest
    public static void executeSearch(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new Case();
        caseobj.Consumer_ID__c = '999999999';
        insert caseobj;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '01/01/1901';
        csUSC.include = false;
        csUSC.activeOnly = true;
        csUSC.remdob = false;
        
        test.startTest();
        csUSC.executeUSCSearch();
        test.stopTest();
        
        system.debug('csUSC.searchResults = '+csUSC.searchResults);
        system.assertEquals(1, csUSC.searchResults.size());
    }
    
    @isTest
    public static void createUSCCaseCustomerCare(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci; 
        
        Test.startTest();
        VSPR3_ConsumerSearch_USC.createUSCCase('123', '9999', '55', '44', '122', 'B9902', '1112223333', '222', '18004004569', 'Phone', 'Member', 'callType');
        Test.stopTest();
        
        List<Case> newCaseList = new List<Case>();
        newCaseList = [SELECT Id,IVR_DNIS__c,IVR_ANI__c FROM Case WHERE IVR_Contact_ID__c = '123'];
        system.assertEquals(1, newCaseList.size());
    }
    
    @isTest
    public static void createUSCCaseRetail(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setDVISettings();
        
        Caller_Intent__c ci = new Caller_Intent__c();
        ci.Name = 'Test';
        ci.Code__c = 'B9902'; 
        ci.Intent_Text__c = 'IntentText';
        insert ci;  
         
        Test.startTest();
        VSPR3_ConsumerSearch_USC.createUSCCase('123', '9999', '55', '44', '122', 'B9902', '1112223333', '222', '18442761280', 'Phone', 'Member', 'callType');
        Test.stopTest();
        
        List<Case> newCaseList = new List<Case>();
        newCaseList = [SELECT Id,IVR_DNIS__c,IVR_ANI__c FROM Case WHERE IVR_Contact_ID__c = '123'];
        system.assertEquals(1, newCaseList.size());
    }
    
    @isTest
    public static void selectConsumer(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setCCPortalSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new case();
        ApexPages.StandardController sc = new ApexPages.standardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.dob = '03/08/1901';
        csUSC.include = true;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        test.stopTest(); 
        
        csUSC.wrapcsrList[0].isSelected = true;
        
        csUSC.selectConsumer();
    }
    
    @isTest
    public static void getStates(){
        Case caseobj = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        List<SelectOption> stateList = new List<SelectOption>();
        
        Test.startTest();
        stateList = csUSC.getStates();
        Test.stopTest(); 
        
        system.assertNotEquals(0, stateList.size());
    }
    
    @isTest
    public static void toggleSort(){
        Test.setMock(HttpCalloutMock.class, new VSPR3_ConsumerSearchMock());
        TestDataFactory.setCSSettings();
        TestDataFactory.setCCPortalSettings();
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok; 
        
        Case caseobj = new Case();
        ApexPages.StandardController sc = new ApexPages.StandardController(caseobj);
        VSPR3_ConsumerSearch_USC csUSC = new VSPR3_ConsumerSearch_USC(sc);
        csUSC.sortDir = 'asc';
        csUSC.dob = '03/08/1901';
        csUSC.include = true;
        csUSC.activeonly = false;
        csUSC.remdob = false;
        csUSC.firstname = 'ABCDEF';
        csUSC.lastname = 'GHIJKL';
        
        test.startTest();
        csUSC.APIsearchRecords();
        csUSC.toggleSort();
        test.stopTest(); 
        
        system.assertEquals('desc', csUSC.sortDir);
    }
}