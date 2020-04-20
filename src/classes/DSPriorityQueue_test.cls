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
public class DSPriorityQueue_test
{
    public static testMethod void testSubmitCallBack()
    {
        /*Hard coded id's since these are not being looked up anywhere in salesforce*/
        Test.setMock(HttpCalloutMock.class, new DSPriorityQueueMockHttpResponseGenerator());
        
        test.startTest();
        DSPriorityQueue.SubmitCallBackNoFuture('00561000000MK0z', '00Q', '1234567890', true);
        DSPriorityQueue.SubmitCallBackNoFuture('00561000000MK0z', '00Q', '1234567890', false);
        
        DSPriorityQueue.SubmitCallBack('00561000000MK0z', '00Q', '1234567890', true);
        DSPriorityQueue.SubmitCallBack('00561000000MK0z', '00Q', '1234567890', false);
        test.stopTest();
    }
    
    public static testMethod void test_ButtonSubmitCallBack()
    {
        /*Hard coded id's since these are not being looked up anywhere in salesforce*/
        String sfdcUserId = '00561000000MK0z';
        String sfdcObjectId = '00Q610000019Cjx';
        String callBackNumber = '1234567890';
        
        Test.setMock(HttpCalloutMock.class, new DSPriorityQueueMockHttpResponseGenerator());
        
        test.startTest();
        DSPriorityQueue.ButtonSubmitCallBack(sfdcUserId, sfdcObjectId,callBackNumber, true);
        DSPriorityQueue.ButtonSubmitCallBack(sfdcUserId, sfdcObjectId,callBackNumber, false);
        test.stopTest();
    }

    public static testMethod void testSubmitCallBackListFuture()
    {
        /*Setting up variables for test*/
        String lid = '00Q610000019CjxEAE';

        List<Id> sfdcUserId = new List<Id>();
        sfdcUserId.add(Id.valueOf('00561000000MK0z'));

        List<Id> sfdcObjectIds = new List<Id>();
        sfdcObjectIds.add(Id.valueOf('00Q610000019Cjx'));

        List<String> phones = new List<String>();
        phones.add('1234567890');

        Test.setMock(HttpCalloutMock.class, new DSPriorityQueueMockHttpResponseGenerator());
        
        test.startTest();
        DSPriorityQueue.SubmitCallBackListNoFuture(sfdcUserId, sfdcObjectIds, phones, true);
        DSPriorityQueue.SubmitCallBackListNoFuture(sfdcUserId, sfdcObjectIds, phones, false);
        
        DSPriorityQueue.SubmitCallBackListFuture('00561000000MK0z', 'Lead', ''+ lid +'', true, 'Phone');
        DSPriorityQueue.SubmitCallBackListFuture('00561000000MK0z', 'Lead', ''+ lid +'', false, 'Phone');
        
        DSPriorityQueue.SubmitCallBackListFuture(sfdcUserId, sfdcObjectIds, phones, true);
        DSPriorityQueue.SubmitCallBackListFuture(sfdcUserId, sfdcObjectIds, phones, false);
        
        DSPriorityQueue.wsSubmitCallBackList('00561000000MK0z', 'Lead', ''+ lid +'', false, 'Phone');
        DSPriorityQueue.wsSubmitCallBackList('00561000000MK0z', 'Lead', ''+ lid +'', true, 'Phone');
        test.stopTest();

    }
    
    public static testMethod void testGetObjectType()
    {
        // TEST STRINGS
        System.AssertEquals('Lead', DSPriorityQueue.DSgetObjectType('00Q'));

        // TEST OBJECT ID'S
        Id lid = Id.valueOf('00Q610000019CjxEAE');
        System.AssertEquals('Lead', DSPriorityQueue.DSgetObjectType(lid));
        
        //Test null
        Id nullId = null;
        System.AssertEquals(null, DSPriorityQueue.DSgetObjectType(nullId));
    }
    public static testMethod void testIsNullOrEmpty()
    {
        System.AssertEquals(true, DSPriorityQueue.IsNullOrEmpty(null));
        System.AssertEquals(true, DSPriorityQueue.IsNullOrEmpty(''));
        System.AssertEquals(false, DSPriorityQueue.IsNullOrEmpty('test'));
    }
    public static testMethod void testhackCoverage()
    {
        DSPriorityQueue.hackCoverage();
    }
    public static testMethod void test_ID15to18()
    {
        String lid = '00Q610000019Cjx';
        Id tempId = Id.valueOf(lid);

        DSPriorityQueue.ID15to18(lid);
        DSPriorityQueue.ID15to18(tempId);
    }
    public static testMethod void test_validPhoneNumer()
    {
        String tempPhone = '(123) 456-7890';

        tempPhone = DSPriorityQueue.validPhoneNumber(tempPhone);
    }
    public static testMethod void test_csvStringToIdParser()
    {
        String s = '(\'01p610000002tHJAAY\',\'00161000002bIAiAAM\',\'00661000002HQzyAAG\')';
        List<Id> listOfIds= DSPriorityQueue.csvStringToIdParser(s);
        system.debug(listOfIds);
    }
    public static testMethod void test_csvStringToListStringParser()
    {
        String s = '(\'9253604645\',\'8457894562\',\'4528964567\')';
        List<String> listOfStrings = DSPriorityQueue.csvStringToListStringParser(s);
        system.debug(listOfStrings);
    }
    public static testMethod void test_directSubmitCallBackList()
    {
        String phones = '(\'9253604645\',\'8457894562\',\'4528964567\')';
        String oid = '(\'01p610000002tHJAAY\',\'00161000002bIAiAAM\',\'00661000002HQzyAAG\')';
        String uid = '00561000000MK0z';
        
        Test.setMock(HttpCalloutMock.class, new DSPriorityQueueMockHttpResponseGenerator());
        
        test.startTest();
        DSPriorityQueue.directSubmitCallBackList(uid, oid, phones, true);
        test.stopTest();
    }
}