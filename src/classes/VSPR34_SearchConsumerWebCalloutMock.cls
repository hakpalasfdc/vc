@isTest
global class VSPR34_SearchConsumerWebCalloutMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        System.assert(req.getMethod() == 'POST');
        HTTPResponse singleConsumerResponse = new HTTPResponse();
        singleConsumerResponse.setHeader('Content-Type', 'application/json');
        singleConsumerResponse.setBody('{"memberships":[{"consumerId":12345678}]}'); 
        singleConsumerResponse.setStatusCode(200);
        return singleConsumerResponse;            
            
    }

}