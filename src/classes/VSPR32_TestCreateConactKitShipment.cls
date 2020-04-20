@isTest
public class VSPR32_TestCreateConactKitShipment {

    public static testmethod void testContactKitShipment() {
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        String expectedOppId = setUpData();
        req.requestURI = '/services/apexrest/ContactKitOrderShipments/'; 
        VSPR32_ContactsKitShipmentRequest ship = new VSPR32_ContactsKitShipmentRequest();
        ship.opportunityId= expectedOppId;
        String expectedSapOrder = 'expectedSapOrder';
        ship.SapOrderNumber = expectedSapOrder;
        List<VSPR32_ContactsKitShipment> trackNumbers = new List<VSPR32_ContactsKitShipment>();
        VSPR32_ContactsKitShipment firstShipment = new VSPR32_ContactsKitShipment();
        String expectedTrackingNumber = 'expectedTrackingNumber';
        firstShipment.trackingNumber = expectedTrackingNumber;
        trackNumbers.add(firstShipment);
        ship.SapOrderShipments = trackNumbers;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(ship));
        RestContext.request = req;
        VSPR32_CreateContactKitShipmentResource.createConatctsShipment();
        
        List<Contacts_Kit_Shipment__c> shipments = [select Name, UPS_Tracking_Url__c from Contacts_Kit_Shipment__c where Name=: expectedSapOrder];
        System.assertEquals(1, shipments.size());
        String baseUrl = 'https://www.ups.com/WebTracking?loc=en_US&tracknum=';
        System.assertEquals(baseUrl+expectedTrackingNumber, shipments.get(0).UPS_Tracking_Url__c);
        
        List<Opportunity> opps = [select Shipping_Status__c from Opportunity where Id=: expectedOppId];
        System.assertEquals('Shipped', opps.get(0).Shipping_Status__c);
    }
    
    public static testmethod void testCreateContactsOrderShipmentWithShipStatus() {
        String expectedOppId = setUpData();
        String baseUrl = 'https://www.ups.com/WebTracking?loc=en_US&tracknum=';
        System.debug(expectedOppId);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactKitOrderShipments/'; 
        VSPR32_ContactsKitShipmentRequest ship = new VSPR32_ContactsKitShipmentRequest();
        ship.opportunityId= expectedOppId;
        String expectedSapOrder = 'expectedSapOrder';
        ship.SapOrderNumber = expectedSapOrder;
        String expectedStatus = 'ExpectedStatus';
        ship.orderStatus = expectedStatus;
        List<VSPR32_ContactsKitShipment> trackNumbers = new List<VSPR32_ContactsKitShipment>();
        VSPR32_ContactsKitShipment firstShipment = new VSPR32_ContactsKitShipment();
        String expectedTrackingNumber = 'expectedTrackingNumber';
        firstShipment.trackingNumber = expectedTrackingNumber;
        trackNumbers.add(firstShipment);
        ship.SapOrderShipments = trackNumbers;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(ship));
        RestContext.request = req;

        VSPR32_CreateContactKitShipmentResource.createConatctsShipment();
        List<Opportunity> opps = [select Shipping_Status__c, SAP_Order_Status__C, Tracking_Info__c from Opportunity where Id=: expectedOppId];
        
        System.assertEquals(expectedStatus, opps.get(0).Shipping_Status__c);
        System.assertEquals(expectedStatus, opps.get(0).SAP_Order_Status__C);
        System.assertEquals(baseUrl+expectedTrackingNumber, opps.get(0).Tracking_Info__c);
        
    }
    
    public static testmethod void testMultipleTrackingNumbers() {
        String expectedOppId = setUpData();
        String baseUrl = 'https://www.ups.com/WebTracking?loc=en_US&tracknum=';
        System.debug(expectedOppId);
        Test.startTest();
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();
        req.requestURI = '/services/apexrest/ContactKitOrderShipments/'; 
        VSPR32_ContactsKitShipmentRequest ship = new VSPR32_ContactsKitShipmentRequest();
        ship.opportunityId= expectedOppId;
        String expectedSapOrder = 'expectedSapOrder';
        ship.SapOrderNumber = expectedSapOrder;
        String expectedStatus = 'ExpectedStatus';
        ship.orderStatus = expectedStatus;
        List<VSPR32_ContactsKitShipment> trackNumbers = new List<VSPR32_ContactsKitShipment>();
        VSPR32_ContactsKitShipment firstShipment = new VSPR32_ContactsKitShipment();
        String expectedTrackingNumber = 'expectedTrackingNumber';
        firstShipment.trackingNumber = expectedTrackingNumber;
        trackNumbers.add(firstShipment);
        
        VSPR32_ContactsKitShipment secondShipment = new VSPR32_ContactsKitShipment();
        String secondExpectedTrackingNumber = 'secondExpectedTrackingNumber';
        secondShipment.trackingNumber = secondExpectedTrackingNumber;
        trackNumbers.add(secondShipment);
        
        ship.SapOrderShipments = trackNumbers;
        req.httpMethod = 'POST';
        req.requestBody = Blob.valueOf(JSON.serialize(ship));
        RestContext.request = req;
        
        VSPR32_CreateContactKitShipmentResource.createConatctsShipment();
        
        List<Contacts_Kit_Shipment__c> shipments = [select Name, UPS_Tracking_Url__c from Contacts_Kit_Shipment__c where Name=: expectedSapOrder];
        System.assertEquals(2, shipments.size());

        
        List<Opportunity> opps = [select Shipping_Status__c, SAP_Order_Status__C, Tracking_Info__c from Opportunity where Id=: expectedOppId];
        
        System.assertEquals(expectedStatus, opps.get(0).Shipping_Status__c);
        System.assertEquals(expectedStatus, opps.get(0).SAP_Order_Status__C);
        // assert that comma delimited values are present for tracking from task
        System.assertEquals(baseUrl+expectedTrackingNumber+'%20'+secondExpectedTrackingNumber, opps.get(0).Tracking_Info__c);
        
    }
    
    private static String setUpData() {
       
        Account account = new Account(name='test account'); 
        insert account;
        Opportunity opp = new Opportunity(name ='Fit Kit Test opp');
        opp.AccountId = account.Id;
        opp.End_Date__c = Date.today();
        opp.CloseDate = Date.today();
        opp.Product_Program__c = 'Test';
        opp.StageName = 'Closed/Won';
        opp.Tracking_Info__c = 'http:\\google.com';
        opp.Planned_Closed_Month__c = 'May';
        insert opp;
        
        return opp.Id;
    }
}