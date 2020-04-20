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
public class VSPR16_GetConsumerIDTest{

    @isTest
    public static void eyeconicWithId(){
        TestDataFactory.setDVISettings();
        Id personId = TestDataFactory.createPersonAccount('lName');
        Id personConId = [SELECT PersonContactId FROM Account WHERE Id =: personId].PersonContactId;
        Id eyeconicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
        
        Case newCase = new Case();
        newCase.RecordTypeId = eyeconicRecordTypeId;
        newCase.SuppliedEmail = 'web@email.com';
        newCase.SuppliedName = 'Web  Name';
        newCase.ContactId = personConId;
        newCase.Subject = 'subject';
        newCase.Description = 'description';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Retail Ops';
        newCase.Origin = 'Email';
        newCase.OwnerId = '00GU0000001gl6YMAQ';
        
        Test.startTest();
        insert newCase;
        Test.stopTest();
        
        Account personAccount = [SELECT PersonEmail FROM Account WHERE Id =: personId];
        system.assertEquals('web@email.com', personAccount.PersonEmail);
    }    
    
    @isTest
    public static void eyeconicWithOutId(){
        TestDataFactory.setDVISettings();
        Id personId = TestDataFactory.createPersonAccount('lName');
        Id personConId = [SELECT PersonContactId FROM Account WHERE Id =: personId].PersonContactId;
        Account person = [SELECT Personal_Email__pc,PersonEmail FROM Account WHERE Id =: personId];
        person.Personal_Email__pc = 'web1@email.com';
        update person;
        Id perActRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        Id eyeconicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
        List<String> fixedSearchResults = new List<String>();
        fixedSearchResults.add(person.Id);
       	Test.setFixedSearchResults(fixedSearchResults);

        Case newCase = new Case();
        newCase.RecordTypeId = eyeconicRecordTypeId;
        newCase.SuppliedEmail = 'web1@email.com';
        newCase.SuppliedName = 'Web  Name';
        newCase.Subject = 'subject'; 
        newCase.Description = 'description';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Retail Ops'; 
        newCase.Origin = 'Email'; 
        newCase.OwnerId = '00GU0000001gl6YMAQ';
        
        Test.startTest();
        insert newCase;
        Test.stopTest();

        Account personAccount = [SELECT PersonEmail,Personal_Email__pc FROM Account WHERE Id =: personId];
        system.assertEquals('web1@email.com', personAccount.PersonEmail);
    }  

    @isTest
    public static void eyeconicNewPerson(){
        TestDataFactory.setDVISettings();
        Id eyeconicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();

        Case newCase = new Case();
        newCase.RecordTypeId = eyeconicRecordTypeId;
        newCase.SuppliedEmail = 'web1@email.com';
        newCase.SuppliedName = 'Web  Name';
        newCase.Subject = 'subject'; 
        newCase.Description = 'description';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Retail Ops'; 
        newCase.Origin = 'Email'; 
        newCase.OwnerId = '00GU0000001gl6YMAQ';
        
        Test.startTest();
        insert newCase;
        Test.stopTest();

       // List<Account> personAccountList = [SELECT PersonEmail,Personal_Email__pc FROM Account WHERE PersonEmail = 'web1@email.com'];
       List<Case> personAccountList = [SELECT Id FROM Case WHERE SuppliedEmail = 'web1@email.com'];
        system.assertEquals(1, personAccountList.size());
    }
    
    @isTest
    public static void ccNewPerson(){
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        TestDataFactory.setDVISettings();
        Id ccRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        
        Case newCase = new Case(); 
        newCase.RecordTypeId = ccRecordTypeId;
        newCase.Subject = 'subject';
        newCase.Description = 'VSP Member: Yes \nIs this a complaint? No\nLast Four of SSN or Member ID: 6677\n';
    	newCase.Description+= 'E-mail Address: test@test.com<\nDate of Birth: December 3, 1982\nMember Name: test abcd\n';
    	newCase.Description+= 'Sender Name: test test.com\n';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Level';
        newCase.Reason_for_Contact__c = 'COB';
        newCase.Origin = 'Email';
        
        Test.startTest();
        insert newCase;
        Test.stopTest();   
        
      //  List<Account> personList = [SELECT Id FROM Account WHERE PersonEmail = 'test@test.com'];
        List<Case> personList = [SELECT Id FROM case WHERE Subject = 'subject'];
        system.assertEquals(1, personList.size());
    }

    @isTest
    public static void ccWithId(){
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        TestDataFactory.setDVISettings();
        Id personId = TestDataFactory.createPersonAccount('lName');
        Account person = [SELECT Division_Id__pc,Client_ID__pc,Consumer_ID__pc FROM Account WHERE Id =: personId];
        person.Division_Id__pc = '3';
        person.Client_ID__pc = '2';
        person.Consumer_ID__pc = '1';
        update person;
        
        Id personConId = [SELECT PersonContactId FROM Account WHERE Id =: personId].PersonContactId;
        Id ccRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        
        MemberPlan mp = new MemberPlan();
        mp.ConsumerId__c = '1';
        mp.Client_ID__c = '2';
        mp.Division_ID__c = '3';
        mp.MemberId = person.Id;
        mp.Name = 'Test';
        insert mp;
        
        Case newCase = new Case();
        newCase.RecordTypeId = ccRecordTypeId;
        newCase.ContactId = personConId;
        newCase.Subject = 'subject';
        newCase.Description = 'VSP Member: Yes \nIs this a complaint? No\nLast Four of SSN or Member ID: 6677\n';
    	//newCase.Description+= 'E-mail Address: test@test.com<\nDate of Birth: December 3, 1982\nMember Name: test abcd\n';
    	newCase.Description+= 'E-mail Address: test@test.com\nDate of Birth: December 3, 1982\nMember Name: test abcd\n';
    	newCase.Description+= 'Sender Name: test test.com\n';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Level';
        newCase.Reason_for_Contact__c = 'COB';
        newCase.Origin = 'Email';
        newCase.Member_Plan__c = mp.Id;
        
        Test.startTest();
        insert newCase;
        Test.stopTest(); 
        
        person = [SELECT Consumer_ID__pc,PersonEmail FROM Account WHERE Id =: personId];
        system.assertEquals('test@test.com', person.PersonEmail);
        system.assertEquals('167875183', person.Consumer_ID__pc);
    }

    @isTest
    public static void ccWithoutId(){
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        TestDataFactory.setDVISettings();
        Id personId = TestDataFactory.createPersonAccount('lName');
        Account person = [SELECT Division_Id__pc,Client_ID__pc,Consumer_ID__pc FROM Account WHERE Id =: personId];
        person.Division_Id__pc = '3';
        person.Client_ID__pc = '2';
        person.Consumer_ID__pc = '1';
        person.Personal_Email__pc = 'test@test.com';
        update person;
        
        Id personConId = [SELECT PersonContactId FROM Account WHERE Id =: personId].PersonContactId;
        Id ccRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        
        MemberPlan mp = new MemberPlan();
        mp.ConsumerId__c = '1';
        mp.Client_ID__c = '2';
        mp.Division_ID__c = '3';
        mp.MemberId = person.Id;
        mp.Name = 'Test';
        insert mp;
        
        List<String> fixedSearchResults = new List<String>();
        fixedSearchResults.add(person.Id);
       	Test.setFixedSearchResults(fixedSearchResults);
        
        Case newCase = new Case(); 
        newCase.RecordTypeId = ccRecordTypeId;
        newCase.Subject = 'subject';
        newCase.Description = 'VSP Member: Yes \nIs this a complaint? No\nLast Four of SSN or Member ID: 6677\n';
    	//newCase.Description+= 'E-mail Address: test@test.com<\nDate of Birth: December 3, 1982\nMember Name: test abcd\n';
    	newCase.Description+= 'E-mail Address: test@test.com\nDate of Birth: December 3, 1982\nMember Name: test abcd\n';
    	newCase.Description+= 'Sender Name: test test.com\n';
        newCase.Type = 'Issue';
        newCase.Product__c = 'Level';
        newCase.Reason_for_Contact__c = 'COB';
        newCase.Origin = 'Email';
        newCase.Member_Plan__c = mp.Id;
        
        Test.startTest();
        insert newCase;
        Test.stopTest();   
        
        newCase = [SELECT ContactId FROM Case WHERE Id =: newCase.Id];
        person = [SELECT Consumer_ID__pc,PersonEmail,PersonContactId FROM Account WHERE Id =: personId];
        system.assertEquals('167875183', person.Consumer_ID__pc);
        system.assertEquals('test@test.com', person.PersonEmail);
        system.assertEquals(person.PersonContactId, newCase.ContactId);
    }
    
    @isTest
    public static void testSearchConsumer() {
		Test.setMock(HTTPCalloutMock.class, new  VSPR34_SearchConsumerWebCalloutMock());
        HTTPResponse res = VSPR16_GetConsumerID.searchConsumer('access_token', 'webServiceURL', 'memberFirstName', 'memberLastName', 'lastFourSSNORmemberID', 'memberDOB');
        String actualValue = res.getBody();
        String expectedValue = '{"memberships":[{"consumerId":12345678}]}';
        System.assertEquals(actualValue, expectedValue);
        System.assertEquals(200, res.getStatusCode());       
    }
}