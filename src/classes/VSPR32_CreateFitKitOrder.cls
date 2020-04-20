global class VSPR32_CreateFitKitOrder {
    @InvocableMethod(label='Create Fit Kit Order' description='Sends an HTTP message to SAP to create Fit Kit Order.')
    global static void execute(List<VSPR32_InvocableFitKitOrderRequest> requests) { 
        VSPR32_FitKitOrderCreateRequest createRequest = new VSPR32_FitKitOrderCreateRequest(requests.get(0));
       // createRequest.Opp_Item.region = 'US'; //delete after test
        String fitKitRequestAsJson = JSON.serialize(createRequest);
        VSPR32_SapCreateFitKitOrderCallout.createFitKitOrder(fitKitRequestAsJson);
    }

}