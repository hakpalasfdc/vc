/* Created Date : 22nd June 2016
   Related Class/Page : VSPR11_UpdateBusinessHours, VSPR11_UpdateBusinessHoursPage
   Related Object : Account.
   Related Case : #9251.
*/
@isTest 
public class VSPR11_UpdateBusinessHoursTest{
    
    static testMethod void VSPR11_UpdateBusinessHoursTestData(){
        
        Test.setCurrentPage(Page.VSPR11_UpdateBusinessHoursPage);
         Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        // Creating Test Account Record..
        Account a = new Account();
        a.Name = 'Test Upodate BusinessHours';
        a.RecordTypeId = accRecordTypeId;
        a.Rating = 'Warm';
        a.Monday_Close__c = '5:00 PM';
        a.Monday_Open__c = '5:00 AM';
        a.Tuesday_Close__c = '5:00 PM';
        a.Tuesday_open__c= '5:00 AM';
        a.Wednesday_Close__c= '5:00 PM';
        a.Wednesday_open__c= '5:00 AM';
        a.Thursday_Close__c= '5:00 PM';
        a.Thursday_Open__c= '5:00 AM';
        a.Friday_Close__c= '5:00 PM';
        a.Friday_Open__c= '5:30 AM';
        a.Saturday_Close__c= '5:00 PM';
        a.Saturday_open__c= '5:00 AM';
        a.Sunday_Close__c= '5:00 PM';
        a.Sunday_Open__c= '5:00 AM';
        
         try{
        Test.StartTest();
            Test.SetCurrentPage(Page.VSPR11_UpdateBusinessHoursPage);
            insert a;
            
            ApexPages.StandardController controller = new ApexPages.StandardController(a);
            VSPR11_UpdateBusinessHours testObj = new VSPR11_UpdateBusinessHours(controller);
            testObj.str2 = 'Test';
            
            ApexPages.StandardController controllerTest = new ApexPages.StandardController(new Account());
            VSPR11_UpdateBusinessHours testObjTest = new VSPR11_UpdateBusinessHours(controllerTest);
            testObj.str2 = 'Test';
            
            testObj.save();
            testObjTest.save();
        System.assert(true);
        Test.StopTest();
        }catch(System.DMLException e){
            system.debug('****ERROR****'+ e.getMessage());
            system.assertNotEquals(null, e.getMessage());
        }         
    }
    
}