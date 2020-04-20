global class VSPR3_ConsumerSearchMock_Code503 implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        if(req.getEndpoint().contains('grant_type')){
            res.setBody('{  "access_token":"MTQ0NjJkZmQ5OTM2NDE1ZTZjNGZmZjI3",  "token_type":"bearer",  "expires_in":3600,  "refresh_token":"IwOGYzYTlmM2YxOTQ5MGE3YmNmMDFkNTVk",  "scope":"create",  "state":"12345678"}');
        }else{
            String body = 'Read timed out';
            res.setBody(body);
        }
        res.setStatusCode(503);
        return res;
    } 
}