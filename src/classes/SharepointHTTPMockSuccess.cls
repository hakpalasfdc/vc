@isTest
global class SharepointHTTPMockSuccess implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        System.assertEquals('https://services.vsp.com/api/File/Upload', req.getEndpoint());
        System.assertEquals('POST', req.getMethod());
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"Sharepoint":"test"}');
        res.setStatusCode(201);
        return res;
    }
}