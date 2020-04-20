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
@istest(seealldata=true)
private class QNewsAttachmentTrigger_Test {

    static testMethod void myUnitTest() {
    
        Test.startTest();
        
        QNews__c obj = new QNews__c();
        List<QNews__c> lst = new List<QNews__c>();
        
        obj.Article_Title__c = 'Test Case';
        obj.Article_Type__c = 'Test Case';
        obj.Article_Version_Number__c = 'Test';
        obj.Best_Practice__c = true;
        obj.Data_Category__c = 'New';
        obj.Data_Category_Group__c = 'Phone';
        obj.Data_Category_Selection_Id__c = 'Issue';
        obj.Federal_Compliance__c = true;
        obj.ForSharePointService__c = true;
        
        insert obj;
        
        Test.stopTest();
    }
}