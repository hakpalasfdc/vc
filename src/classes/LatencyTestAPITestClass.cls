@isTest
Public class LatencyTestAPITestClass {
        static testMethod void Validate1KbPayload() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/TestLatency/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Integer sizeInKb = 1;
        String payloadOf1kb = VSPToSFLatencyTestAPI.getPayload(sizeInKb);
        Integer actualPayloadSize = payloadOf1kb.length();
        System.assertEquals(1024, actualPayloadSize, 'Payload should be 1kb but was ' + actualPayloadSize);
        Test.stopTest();
    }
    static testMethod void Validate5KbPayload() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/TestLatency/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Integer sizeInKb = 5;
        String payloadOf5kb = VSPToSFLatencyTestAPI.getPayload(sizeInKb);
        Integer actualPayloadSize = payloadOf5kb.length();
        System.assertEquals(5120, actualPayloadSize, 'Payload should be kb but was ' + actualPayloadSize);
        Test.stopTest();
    }
    
    static testMethod void Validate10KbPayload() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/TestLatency/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Integer sizeInKb = 10;
        String payloadOf10kb = VSPToSFLatencyTestAPI.getPayload(sizeInKb);
        Integer actualPayloadSize = payloadOf10kb.length();
        System.assertEquals(10240, actualPayloadSize, 'Payload should be 10kb but was ' + actualPayloadSize);
        Test.stopTest();
    }
    
    static testMethod void Validate1000KbPayload() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/TestLatency/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Integer sizeInKb = 1000;
        String payloadOf1000kb = VSPToSFLatencyTestAPI.getPayload(sizeInKb);
        Integer actualPayloadSize = payloadOf1000kb.length();
        System.assertEquals(1024000, actualPayloadSize, 'Payload should be 1000kb but was ' + actualPayloadSize);
        Test.stopTest();
    }
    
    static testMethod void emptyPayload() {
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
        req.requestURI = '/TestLatency/';  
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;

        Test.startTest();
        Integer sizeInKb = 1001;
        String payloadOf10kb = VSPToSFLatencyTestAPI.getPayload(sizeInKb);
        Integer actualPayloadSize = payloadOf10kb.length();
        System.assertEquals(0, actualPayloadSize, 'Payload should be 0kb but was ' + actualPayloadSize);
        Test.stopTest();
    }
}