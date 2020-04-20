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
private class DSTaskVMCountTest {

    static testMethod void myUnitTest() {
    	
    	Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc1 = new account();
                acc1.name='VSP Consumer';
                acc1.recordTypeId = recordtype;
                acc1.email__c='abc@gmail.com';
                acc1.Tax_ID__c = '345433589';
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '11US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                acc1.Account_Group_Sub_Type__c='ab';
                acc1.Vision_Care_Location_Key__c='371580129635 2';
                acc1.Vision_Care_End_Date__c=date.today().adddays(-3);
                insert acc1;
    	  Contact c = new Contact();
            
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.AccountId = acc1.Id;
            insert c;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today().adddays(-2);
            cr.End_Date__c = date.today().adddays(30);
            cr.Account__c = acc1.Id;
            cr.Contact__c = c.Id;
            insert cr;
            
            task t=new task();
            t.whoid=c.id;
            t.whatid=cr.id;
            t.subject='test';
            t.description='test';
            insert t;
    	
        // TO DO: implement unit test
        DSTaskVMCount.sobjectsListRequests s=new DSTaskVMCount.sobjectsListRequests();
        s.TaskIdRequest=t.id;
        s.WhatIdRequest=cr.id;
        s.SubjectRequest='test : tet';
        DSTaskVMCount.DSSendtoQueue(new List<DSTaskVMCount.sobjectsListRequests>{s});
    }
}