@isTest
public class VSPR32_FitKitOrderTest {

    static testmethod void testCreateFitKtiOrder() {
        
        //Below part inserted by Vikhyat on 10/02/2019
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        Sap_Basic_Auth_Webservice__c sap = new Sap_Basic_Auth_Webservice__c();
        sap.SetupOwnerId = p.Id;
        sap.authorization_header__c = 'dgajshdasjdasadas';
        sap.endpoint_url__c = 'https://websapp1d01.vsp.com/RESTAdapter/VSP/FitkitOrderCreate';
        insert sap;
        //Part added by Vikhyat ends here
        
        Test.setMock(HttpCalloutMock .class, new VSPR32_FitKitCalloutMock());
        List<VSPR32_InvocableFitKitOrderRequest> requests = new List<VSPR32_InvocableFitKitOrderRequest>();
        VSPR32_InvocableFitKitOrderRequest request = new VSPR32_InvocableFitKitOrderRequest();
        request.City = 'Sac';
        request.Country = 'US';
        request.Name = 'Tester Testing';
        request.Qty = '1';
        request.PostalCd = '11111';
        request.opportunityId = 'test';
        request.Region = 'US';
        request.Street = '1234 test st';
        requests.add(request);
        VSPR32_CreateFitKitOrder.execute(requests);
    }
}