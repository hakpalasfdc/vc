/* Created Date : 22nd June 2016.
   Related Case : #9251.
   Related Object : Contact.
   Related Class : VSPR1_BL
   Description : Code COverage should be 90 or greater than 90 %.
*/
@isTest
public class VSPR1_BLTest{
    static testMethod void VSPR1_BLTestData(){
        
        // Create Test Account
        Account a = new Account();
        a.NAme = 'Test Account';
        
        // Create Test Contact...
        Contact c = new Contact();
        c.FirstName = 'Test';
        c.LastName = 'COnatct';
        
        // Start The Test.....
        Test.StartTest();
            insert a;
            c.AccountID = a.id;
            insert c;
            ApexPages.StandardController controller = new ApexPages.StandardController(c);
            VSPR1_BL testObject = new VSPR1_BL(controller);
            testObject.doRedirect();
        Test.StopTest();
    }
}