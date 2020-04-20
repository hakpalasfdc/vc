global class VSPR3_ConsumerSearchMock_Code500 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('grant_type')){
            res.setBody('{  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",  "token_type":"bearer",  "expires_in":3600,  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",  "scope":"create",  "state":"12345678"}');
        }else{
            String body = '"error": "com.vsp.salesforce.sfdcconsumerexp.exception.SFDCConsumerBuildException","description": "com.vsp.salesforce.sfdcconsumerexp.exception.RetrieveConsumerFailedException: org.springframework.web.client.HttpClientErrorException: 400 null Your request encountered the following exceptions, please fix your request accordingly and try again. Following consumer link was not successful. Your request encountered the following exceptions, please fix your request accordingly and try again. Exception encountered during SFDC Consumer build operation"';
            res.setBody(body);
        }
        res.setStatusCode(500);
        return res;
    } 
}