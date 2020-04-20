@RestResource(urlMapping='/ContactKitOrderShipments/*')
global with sharing class VSPR32_CreateContactKitShipmentResource {
    @HTTPPost
    global static void createConatctsShipment() {
        VSPR32_ContactsKitShipmentRequest request = (VSPR32_ContactsKitShipmentRequest)JSON.deserialize(RestContext.request.requestBody.toString(), VSPR32_ContactsKitShipmentRequest.class);
        String opportunityId = request.opportunityId;
        String fitKitOrderNumber = request.SapOrderNumber;
        String orderStatus = request.orderStatus;
        String orderDetail = request.statusDetails;
        List<VSPR32_ContactsKitShipment> orders = request.SapOrderShipments;
        if (opportunityId != null && orders!= null && orders.size() != 0) {
            createTrackingOrder(orders, opportunityId, fitKitOrderNumber, orderStatus, orderDetail);
        } else {
            updateOpportunity(opportunityId, orderStatus, fitKitOrderNumber, null, orderDetail);
        }
    }

    private static void createTrackingOrder(List<VSPR32_ContactsKitShipment> shipments, String opportunityId, String fitKitOrderNumber, String orderStatus, String orderDetail) {
        List<Contacts_Kit_Shipment__c> newShipments = new List<Contacts_Kit_Shipment__c>();
        String spaceDelimitedTrackingNumbersForTask = '';
        for (VSPR32_ContactsKitShipment shipment : shipments) {
            Contacts_Kit_Shipment__c newShipment = new Contacts_Kit_Shipment__c();
            String trackingNumber = shipment.trackingNumber;
            newShipment.Opportunity__c = opportunityId;
            String baseUrl = 'https://www.ups.com/WebTracking?loc=en_US&tracknum=';
            newShipment.UPS_Tracking_Url__c = baseUrl+trackingNumber;
            newShipment.Name = fitKitOrderNumber;
            newShipments.add(newShipment);
            if (spaceDelimitedTrackingNumbersForTask == '') {
                spaceDelimitedTrackingNumbersForTask = baseUrl+trackingNumber;
            } else {
                spaceDelimitedTrackingNumbersForTask = spaceDelimitedTrackingNumbersForTask + '%20' + trackingNumber;
            }
            System.debug('taskTrackingNumbers='+spaceDelimitedTrackingNumbersForTask);
        }
        if (newShipments.size() > 0) {
            insert newShipments;
        }
        updateOpportunity(opportunityId, orderStatus, fitKitOrderNumber, spaceDelimitedTrackingNumbersForTask, orderDetail);

    }
    private static void updateOpportunity(String opportunityId, String orderStatus, String sapOrderNumber, String trackingForTask, String orderDetail) {
        Opportunity opportunity = [Select Id, Shipping_Status__c from Opportunity where Id = :opportunityId for update];
        System.debug(opportunity);
        if (orderStatus != null && orderStatus.length() > 0) {
            // SAP can send error status here in rare cases
            opportunity.Shipping_Status__c = orderStatus;
        } else {
            // don't want to change shipping status to shipped unless we have tracking or else task wont be created
            if (trackingForTask != null && trackingForTask != '') {
                opportunity.Shipping_Status__c = 'Shipped';
            }
        }

        if (trackingForTask != null && trackingForTask != '') {
            opportunity.Tracking_Info__c = trackingForTask;
        }
        // sap related opportunity fields
        opportunity.SAP_Order_Status__c = orderStatus;
        opportunity.SAP_Order_Details__c = orderDetail;
        opportunity.SAP_Order_Number__c = sapOrderNumber;
        
        update opportunity;
    }
}