global class VSPR16_consumerMockGen implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        
        // Create a fake response

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('grant_type')){
        	res.setBody('{  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",  "token_type":"bearer",  "expires_in":3600,  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",  "scope":"create",  "state":"12345678"}');
        }else{
        	res.setBody('[{"policyKey":{"clientId":"30077646","divisionId":"0001"},"memberships":[{"consumerId":"167875183","name":{"firstName":"VADIM","lastName":"KHRAMOV"},"suppliedFirstName":"VADIM","suppliedLastName":"KHRAMOV","memberPolicyKey":{"clientId":"30077646","divisionId":"0001"},"status":"A","relationToSubscriber":"Member","dateOfBirth":"1901-05-07"}],"memberCoverageCode":"Unknown","policyEffectiveDate":"2017-10-01","classId":"0001","self":{"href":"https://api.vspglobal.com:443/memberpolicy-web/memberpolicies/30077646-0001-0167875183?asofdate=2018-01-15","type":"application/vnd.vsp.memberpolicy","rel":"self"},"clientName":"TRINET HR IV, LLC"}]');
        }
        res.setStatusCode(200);
        return res;
    }
}