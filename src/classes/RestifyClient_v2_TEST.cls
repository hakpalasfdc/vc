/*
 * 2016 eightCloud + VSP
 *
 * Test class for Apex client to interact with RESTify API
 *
 * 
 */
@isTest
private class RestifyClient_v2_TEST {

    @testSetup static void init() {
        Account a = new Account(Name = 'Test Account', Tax_ID__c = '123456789');
        insert a;

        RESTify_Settings__c apiSettings = new RESTify_Settings__c();
        apiSettings.END_POINT__c = 'https://reports.vsp.com:443';
        apiSettings.PATH__c = '/ecm/query';
        apiSettings.HTTP_VERB__c = 'GET';
        apiSettings.ACCESS_KEY__c = 'access_key';
        apiSettings.SECRET_KEY__c = 'secret_key';
        insert apiSettings;
        
        Practice_Report_Settings__c query = new Practice_Report_Settings__c();
        query.Year__c = 'YYYY';
        query.Quarter__c = 'QX';
        query.Posting_Date_From__c = Date.newInstance(System.now().year(), System.now().month(), System.now().day());
        query.Posting_Date_To__c = Date.newInstance(System.now().year(), System.now().month()+3, System.now().day());
        insert query;
    }

    @isTest static void callout200() {
        Test.startTest();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('RESTify200');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        String acctId = [SELECT Id FROM Account LIMIT 1].Id + 'Practice';
        String response = RestifyClient_v2.getReport(acctId);
        // Verify response received contains values returned by the mock response, which is based on the static resource payload example
        System.assertEquals('HTTP_STATUS_CODE200SFRUUF9TVEFUVVNfQ09ERTIwMGV5SmpiM1Z1ZENJNklqRWlMQ0p6ZEdGeWRDSTZJakFpTENKd1lXZGxJam9pTWpVaUxDSnBkR1Z0Y3lJNlczc2lVRkpCUTFSSlEwVkdJam9pTkRjeE1UazVPVEl5V1RJd01UWlJNU0o5WFgwPQ==', response);

        Test.stopTest();
    }

    @isTest static void callout500() {
        Test.startTest();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('RESTify500');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        String acctId = [SELECT Id FROM Account LIMIT 1].Id + 'Practice';
        String response = RestifyClient_v2.getReport(acctId);
        // Verify response received contains values returned by the mock response, which is based on the static resource payload example
        System.assertEquals('HTTP_STATUS_CODE500{"request": "RSrQ6boKyh","code": "500","message": "Document not found","trace": ""}', response);

        Test.stopTest();
    }

    @isTest static void callout403() {
        Test.startTest();

        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('RESTify403');
        mock.setStatusCode(403);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, mock);
        String acctId = [SELECT Id FROM Account LIMIT 1].Id + 'Practice';
        String response = RestifyClient_v2.getReport(acctId);
        // Verify response received contains values returned by the mock response, which is based on the static resource payload example
        System.assertEquals('HTTP_STATUS_CODE403{"request": "e0rAGc4lDX","code": "403","message": "Invalid signature"}', response);

        Test.stopTest();
    }
    
}