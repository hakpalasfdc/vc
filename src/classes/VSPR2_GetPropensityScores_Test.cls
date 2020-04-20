@isTest
public class VSPR2_GetPropensityScores_Test {
    @isTest 
    public static void getScoresWithCallout(){  
        List<VSPR2_GetPropensityScores.Results> results;
        DVIWebService__c dviCustSetting = testDataFactory.setDVISettings();
        Consumer_Search_Web_Service__c CSCustSetting = testDataFactory.setCSSettings();
        CC_Portal__c ccPortalSettings = testDataFactory.setCCPortalSettings();        
        Test.setMock(HttpCalloutMock.Class, new VSPR2_GetPropensityCalloutMock());
        
        System.debug('Test set Mock ===');
        Account acc = new Account();
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.FirstName = 'TestDummy';
        acc.LastName = 'TheThird';
        acc.RecordTypeId = rt;
        insert acc; 
        
        MemberPlan mp = New MemberPlan();
        mp.ConsumerId__c = '306032315';
        mp.Division_ID__c = '0001';
        mp.Client_ID__c = '12006950';
        mp.primaryMemberConsumerId__c= '306032315';
        mp.Name = 'MP-100';
        mp.MemberId = acc.Id;
        insert mp;
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok;  
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
        caseObj.accountId = acc.Id;
        caseObj.Member_Plan__c = mp.Id;
        caseObj.Consumer_ID__c = mp.ConsumerId__c;
        caseObj.Client_Id__c = mp.Client_ID__c;
        caseobj.recordtypeId = rtId;
        insert caseobj;  
        
        String requestsId = caseobj.Id;
        VSPR2_GetPropensityScores props = new VSPR2_GetPropensityScores();
        List<VSPR2_GetPropensityScores.Requests> requests = new List<VSPR2_GetPropensityScores.Requests>(); 
        VSPR2_GetPropensityScores.Requests request = new VSPR2_GetPropensityScores.Requests();
        
        request.caseIdSB = requestsId;
        requests.add(request);
        Test.startTest();
         System.debug('requests ==='+requests[0].caseIdSB);
        results = VSPR2_GetPropensityScores.getPropensityScores(requests);
        System.debug('results ==='+ results[0].IPCode);
        Test.stopTest();
        
        system.assertEquals('IP', results[0].IPCode);
        system.assertEquals('Y', results[0].IPClassification);
        system.assertEquals('N/A', results[0].IPConfidence);
        system.assertEquals('retiree', results[0].IPReason);
        system.assertEquals('2', results[0].IPpriority);
        
        system.assertEquals('OON', results[0].OONCode);
        system.assertEquals('N', results[0].OONClassification);
        system.assertEquals('N/A', results[0].OONConfidence);
        system.assertEquals('ageout', results[0].OONReason);
        system.assertEquals('1', results[0].OONPriority);
    } 

    @isTest
    public static void getScoresOnCase(){
        List<VSPR2_GetPropensityScores.Results> results;
        DVIWebService__c dviCustSetting = testDataFactory.setDVISettings();
        Consumer_Search_Web_Service__c CSCustSetting = testDataFactory.setCSSettings();
        CC_Portal__c ccPortalSettings = testDataFactory.setCCPortalSettings();
        
        Account acc = new Account();
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.FirstName = 'TestDummy';
        acc.LastName = 'TheThird';
        acc.RecordTypeId = rt;
        insert acc;
        
        MemberPlan mp = New MemberPlan();
        mp.ConsumerId__c = '3060323333';
        mp.Division_ID__c = '0001';
        mp.Client_ID__c = '12006950';
        mp.primaryMemberConsumerId__c= '3060323333';
        mp.Name = 'MP-100';
        mp.MemberId = acc.Id;
        insert mp;
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
        caseObj.accountId = acc.Id;
        caseObj.Member_Plan__c = mp.Id;
        caseObj.Consumer_ID__c = mp.ConsumerId__c;
        caseObj.Client_Id__c = mp.Client_ID__c;
        caseobj.recordtypeId = rtId;
        insert caseobj;  
        
        PropensityScores__c ps = new PropensityScores__c();
        ps.Case__c = caseobj.Id;
        ps.ConsumerId__c = mp.ConsumerId__c;
        ps.Classification__c = 'Y';
        ps.Code__c = 'IP';
        ps.Reason__c = 'retiree';
        ps.Priority__c = '2';
        ps.Confidence__c = 'N/A';
        ps.PersonAccount__c = acc.Id;
        insert ps;
        
        PropensityScores__c ps2 = new PropensityScores__c();
        ps2.Case__c = caseobj.Id;
        ps2.ConsumerId__c = mp.ConsumerId__c;
        ps2.Classification__c = 'N';
        ps2.Code__c = 'OON';
        ps2.Reason__c = 'ageout';
        ps2.Priority__c = '1';
        ps2.Confidence__c = 'N/A';
        ps2.PersonAccount__c = acc.Id;
        insert ps2;
		
            
        String requestsId = caseobj.Id;
        VSPR2_GetPropensityScores props = new VSPR2_GetPropensityScores();
        List<VSPR2_GetPropensityScores.Requests> requests = new List<VSPR2_GetPropensityScores.Requests>(); 
        VSPR2_GetPropensityScores.Requests request = new VSPR2_GetPropensityScores.Requests();
        request.caseIdSB = requestsId;
        requests.add(request);
        
        Test.startTest();
        results = VSPR2_GetPropensityScores.getPropensityScores(requests); 
        Test.stopTest();
        
        system.assertEquals('IP', results[0].IPCode);
        system.assertEquals('Y', results[0].IPClassification);
        system.assertEquals('N/A', results[0].IPConfidence);
        system.assertEquals('retiree', results[0].IPReason);
        system.assertEquals('2', results[0].IPpriority);
        
        system.assertEquals('OON', results[0].OONCode);
        system.assertEquals('N', results[0].OONClassification);
        system.assertEquals('N/A', results[0].OONConfidence);
        system.assertEquals('ageout', results[0].OONReason);
        system.assertEquals('1', results[0].OONPriority);
    }
    
    @isTest
    public static void CalloutWithNoScores(){
        Test.setMock(HttpCalloutMock.Class, new VSPR2_GetPropensityCalloutNoScoresMock());
        DVIWebService__c dviCustSetting = testDataFactory.setDVISettings();
        Consumer_Search_Web_Service__c CSCustSetting = testDataFactory.setCSSettings();
        CC_Portal__c ccPortalSettings = testDataFactory.setCCPortalSettings();
        
        Account acc = new Account();
        Id rt = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        acc.FirstName = 'TestDummy';
        acc.LastName = 'TheThird';
        acc.RecordTypeId = rt;
        insert acc;
        
        MemberPlan mp = New MemberPlan();
        mp.ConsumerId__c = '3060323333';
        mp.Division_ID__c = '0001';
        mp.Client_ID__c = '12006950';
        mp.primaryMemberConsumerId__c= '3060323333';
        mp.Name = 'MP-100';
        mp.MemberId = acc.Id;
        insert mp;
        
        
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now();
        insert oAuthtok;
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
        caseObj.accountId = acc.Id;
        caseObj.Member_Plan__c = mp.Id;
        caseObj.Consumer_ID__c = mp.ConsumerId__c;
        caseObj.Client_Id__c = mp.Client_ID__c;
        caseobj.recordtypeId = rtId;
        insert caseobj;  
        
        String requestsId = caseobj.Id;
        VSPR2_GetPropensityScores props = new VSPR2_GetPropensityScores();
        List<VSPR2_GetPropensityScores.Requests> requests = new List<VSPR2_GetPropensityScores.Requests>(); 
        VSPR2_GetPropensityScores.Requests request = new VSPR2_GetPropensityScores.Requests();
        
        request.caseIdSB = requestsId;
        requests.add(request); 
        
        Test.startTest();
        List<VSPR2_GetPropensityScores.Results> resultsList = VSPR2_GetPropensityScores.getPropensityScores(requests);
        System.debug('2 results ==='+ resultsList[0].propensityScoreFieldIP);
        Test.stopTest();
        
        List<PropensityScores__c> updatedScores = new List<PropensityScores__c>();
        updatedScores = [SELECT Id,Offer_To__c,Channel__c,Time_Span_Begin__c FROM PropensityScores__c WHERE Case__c =: requestsId];
        
        system.assertEquals(0, updatedScores.size());
        system.assertEquals('No Offer', resultsList[0].propensityScoreFieldIP); 
        system.assertEquals('No Offer', resultsList[0].propensityScoreFieldOON); 
    }
}