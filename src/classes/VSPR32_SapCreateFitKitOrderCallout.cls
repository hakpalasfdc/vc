public class VSPR32_SapCreateFitKitOrderCallout {
    @future(callout=true)
    public static void createFitKitOrder(String fitkitRequestJson) {
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setMethod('POST');

        SAP_Basic_Auth_Webservice__c setting = SAP_Basic_Auth_Webservice__c.getInstance(System.UserInfo.getProfileId());
        String endpoint = setting.endpoint_url__c;
        String authHeader = setting.authorization_header__c;     
        httpRequest.setEndpoint(endpoint);//'https://websapp1d01.vsp.com/RESTAdapter/VSP/FitkitOrderCreate');
        String bodyAsJson = fitkitRequestJson;
        System.debug('request='+bodyAsJson);
        httpRequest.setBody(bodyAsJson);
        httpRequest.setHeader('Authorization', 'Basic ' + authHeader);
        HTTP httpClient = new HTTP();
        HttpResponse createResponse = httpClient.send(httpRequest);
        Integer code = createResponse.getStatusCode();
        if (code >= 300) {
            System.debug('SAP FitKit Request not successful.');
                // do something if not successful?
            throw new VSPR32_SAPRequestException('SAP FitKit Order Create callout failed status_code='+code);
        }
    }
}