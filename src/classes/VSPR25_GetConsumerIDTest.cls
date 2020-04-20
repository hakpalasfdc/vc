@isTest(SeeAllData=false)
public class VSPR25_GetConsumerIDTest {   
/*
    //Test method for when a Case Record Type = Eyeconic and a Contact Record Type = Consumer.
    static testMethod void myCaseUnitTest() {
        DVIWebService__c dviWeb = new DVIWebService__c();
        //dviWeb.DVI_Token_Header__c = 'c2ZkYy1wcm92aWRlcjpwa3BaTUpPMw==';
        //dviWeb.DVI_Web_Service_Version__c = '2.7' ;
        //dviWeb.DVI_Web_Service__c = 'https://api.vspglobal.com	';
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        //Create an Account
        Id recordtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'TestDummy';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact for case
        Id conRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        //c.Email = 'Crazy1234@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();    
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.SuppliedName = c.FirstName + ' ' + c.LastName; 
        cases.SuppliedEmail = 'testdummy@test.com';
        
        insert cases;       
    }    
    //Test method for when a Case Record Type = Eyeconic and a Contact Record Type = Eye Care Professional and has and Account Associated to it.
    public static testMethod void myCaseUnitTest1(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'TestDummy';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;    
        insert c;
        
        //Createa a case
        Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();      
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = 'TESTING EYECONIC';
        cases.SuppliedName = c.FirstName + ' ' + c.LastName; 
        cases.SuppliedEmail = 'testdummy@test.com';
        cases.AccountId = acc.Id;
        insert cases;
        
    }
    
    public static testMethod void myCaseUnitTest2(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();
        Contact c = new Contact();
        c.FirstName = 'TEST1';
        c.LastName = 'DUMMY1';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'testdummy2@test.com';
        c.Personal_Email__c = 'testdummy2@test.com';        
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Eyeconic'].id;       
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        //cases.SuppliedName = c.FirstName + ' ' + c.LastName;
        cases.SuppliedName = 'Henry' + ' ' + 'Osborn';
        cases.SuppliedEmail = 'testdummy@test.com';
        cases.AccountId = acc.id;
        insert cases;        
    }   
    //Method for when Case Record Type Eyeconic and has no Contact.
    public static testMethod void myCaseUnitTest3(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Eyeconic'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = 'TESTING EYECONIC';
        cases.SuppliedName = 'Henry' + ' ' + 'Osborn';
        cases.SuppliedEmail = 'testdummy@test.com';
        insert cases;
        
    } 
    
    public static testMethod void myCaseUnitTest4(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = [SELECT Id from recordType where Name = 'Eye Care Professional' and sObjectType = 'Contact' limit 1].Id;
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'TestDummy@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Customer Care'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n No \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n September 3, 1982 \nMember Name: \n Test abcd \n';
        cases.Description+= '\n Sender Name: \n test test.com \n';
        cases.SuppliedName = c.FirstName + ' ' + c.LastName;
        cases.AccountId = acc.Id;
        insert cases;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        
    }
    
    public static testMethod void myCaseUnitTest5(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = [SELECT Id from recordType where Name = 'Eye Care Professional' and sObjectType = 'Contact' limit 1].Id;
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'TestDummy@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Customer Care'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n February 3, 1982 \nMember Name: \n Test Dummy \n';
        cases.Description+= '\n Sender Name: \n test test.com \n';
        cases.SuppliedEmail = c.Email;
        insert cases;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        
    }
    
    public static testMethod void myCaseUnitTest6(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = [SELECT Id from recordType where Name = 'Eye Care Professional' and sObjectType = 'Contact' limit 1].Id;
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'TestDummy@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Customer Care'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n No \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n August 3, 1982 \nMember Name: \n Test Dummy \n';
        cases.Description+= '\n Sender Name: \n Test Dummy \n';
        cases.SuppliedEmail = c.Email;
        insert cases;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        
    }
    
    static void soslQueryMethod(){
        
        Id conRecType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Eye Care Professional').getRecordTypeId();
        Contact c = new Contact();
        c.FirstName = 'TEST1';
        c.LastName = 'DUMMY1';
        //c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'testdummy2@test.com';
        c.Personal_Email__c = 'testdummy2@test.com';        
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Eyeconic'].id;       
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        //cases.SuppliedName = c.FirstName + ' ' + c.LastName;
        cases.SuppliedName = 'Henry' + ' ' + 'Osborn';
        cases.SuppliedEmail = 'testdummy1@test.com';
        //cases.AccountId = acc.id;
        insert cases;          
    }
    
    public static testMethod void myCaseUnitTest7(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = [SELECT Id from recordType where Name = 'Eye Care Professional' and sObjectType = 'Contact' limit 1].Id;
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'TestDummy@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Customer Care'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n July 3, 1982 \nMember Name: \n Test Dummy \n';
        cases.Description+= '\n Sender Name: \n Test Dummy \n';
        cases.SuppliedEmail = c.Email;
        insert cases;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        
    }
    public static testMethod void myCaseUnitTest8(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Create an Account
        Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
        Account acc = new Account();
        acc.Name = 'VSP Consumer';
        acc.RecordTypeId = recordtype;
        insert acc;
        
        //Create a Contact
        Id conRecType = [SELECT Id from recordType where Name = 'Consumer' and sObjectType = 'Contact' limit 1].Id;
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'Dummy';
        c.AccountId = acc.Id;
        c.RecordTypeId = conRecType;
        c.Email = 'TestDummy@test.com';
        insert c;
        
        //Createa a case
        Id caseRecType = [select id from recordtype where sObjectType='Case' and name='Customer Care'].id;
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n June 3, 1982 \nMember Name: \n Test Dummy \n';
        cases.Description+= '\n Sender Name: \n Test Dummy \n';
        cases.SuppliedEmail = c.Email;
        insert cases;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
        
    }
    
    public static testmethod void myCaseUnitTest9(){
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        insert dviWeb;
        
        //Createa a case for Janurary
        Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Case cases = new Case();
        cases.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases.RecordTypeId = caseRecType;
        cases.Origin = 'Email';
        cases.Line_of_Business__c = 'Global Customer Care';
        cases.Type = 'Issue';
        cases.Status = 'New';
        cases.Product__c = 'Eyeconic USC';
        cases.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n January 3, 1982 \nMember Name: \n Test Dummy \n';
        cases.Description+= '\n Sender Name: \n Test Dummy \n';
        //cases.SuppliedEmail = c.Email;
        insert cases;
        
        
        //Createa a case for March
        //Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Case cases2 = new Case();
        cases2.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases2.RecordTypeId = caseRecType;
        cases2.Origin = 'Email';
        cases2.Line_of_Business__c = 'Global Customer Care';
        cases2.Type = 'Issue';
        cases2.Status = 'New';
        cases2.Product__c = 'Eyeconic USC';
        cases2.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases2.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n March 3, 1982 \nMember Name: \n Test Dummy \n';
        cases2.Description+= '\n Sender Name: \n Test Dummy \n';
        //cases.SuppliedEmail = c.Email;
        insert cases2;
        
        //Createa a case for April
        //Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Case cases3 = new Case();
        cases3.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases3.RecordTypeId = caseRecType;
        cases3.Origin = 'Email';
        cases3.Line_of_Business__c = 'Global Customer Care';
        cases3.Type = 'Issue';
        cases3.Status = 'New';
        cases3.Product__c = 'Eyeconic USC';
        cases3.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases3.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n April 3, 1982 \nMember Name: \n Test Dummy \n';
        cases3.Description+= '\n Sender Name: \n Test Dummy \n';
        //cases.SuppliedEmail = c.Email;
        insert cases3;
        
        //Createa a case for May
        //Id caseRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
        Case cases4 = new Case();
        cases4.Subject = 'Sample Subject';
        //cases.ContactId = c.Id;
        cases4.RecordTypeId = caseRecType;
        cases4.Origin = 'Email';
        cases4.Line_of_Business__c = 'Global Customer Care';
        cases4.Type = 'Issue';
        cases4.Status = 'New';
        cases4.Product__c = 'Eyeconic USC';
        cases4.Description = '\n VSP Member: \n Yes \nIs this a complaint? \n No \nLast Four of SSN or Member ID: \n 6677 \n';
        cases4.Description+= '\n E-mail Address: \n TestDummy@test.com< \nDate of Birth: \n May 3, 1982 \nMember Name: \n Test Dummy \n';
        cases4.Description+= '\n Sender Name: \n Test Dummy \n';
        //cases.SuppliedEmail = c.Email;
        insert cases4;
        Test.setMock(HttpCalloutMock.class, new VSPR16_consumerMockGen());
    }
*/
}