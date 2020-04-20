global class VspOauthCalloutMock implements HttpCalloutMock {
 global HTTPResponse respond(HTTPRequest req) {
  System.debug('Mock class');       
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('grant_type')){
            res.setBody('{  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",  "token_type":"bearer",  "expires_in":3600,  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",  "scope":"create",  "state":"12345678"}');
        }else{
            String body = '{"statusType":"OK","entity":{"consumers":[{"firstName":"ABCDEF","lastName":"GHIJKL","primaryMemberName":"ABCDEF GHIJKL","consumerId":"999999999","primaryMemberConsumerId":"312397511","clientId":"30023319","divId":"0061","expandedId":"U35696729","addresses":[{"street1":"14 MAIN ST","city":"ANYTOWN","stateCode":"MA","zipCode":"02771"}],"consumerStatus":"Active","clientStatus":"Active","clientDivisionStatus":"Active","coverageCode":"Member + Famiy",';
            body += '"clientName":"RBSELECT HEALTHPLAN (CIG VIS)","clientDivisionName":"ALL CITIZENS ACTIVE - FULL","populationIndicator": "C","strategicAlliance": "AMERL",';
            body += '"dependents":[{"firstName": "JKLM","lastName": "STUV","consumerId": "999999993","relationToMember": "S"}],';
            body += '"relationToMember":"M","primaryMemberConsumerId": "999999999","dateOfBirth":"19580816","phones":[{"number":"3366838","prefix":"508"}]}]},"entityType":"com.vsp.api.salesforce.consumerexperience.model.ConsumerExperienceSearchResult","status":200}';
            res.setBody(body);
        }
        res.setStatusCode(200);
        return res;
    }
   
}