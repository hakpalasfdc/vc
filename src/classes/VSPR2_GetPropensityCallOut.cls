global class VSPR2_GetPropensityCallOut {
    global static HTTPResponse getConsumerAPIResponse(String jsonBody){
        //String webServiceURL = DVIWebService__c.getInstance('DVI Values').DVI_Web_Service__c;
        //String tokenHeader = DVIWebService__c.getInstance('DVI Values').DVI_Token_Header__c;   
        String webServiceURL = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Web_Service__c;
        String tokenHeader = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Token_Header__c;     
        String requestEndPoint = webServiceURL+'/as/token.oauth2';  
        String access_token = '';
        String authorizationHeader = 'Basic '+ tokenHeader;
        String consumerIDEndPoint = webServiceURL+'/sfdc-consumer-exp/SFDCConsumers';
        
        HttpRequest oauthReq = new HttpRequest(); 
        oauthReq.setEndpoint(requestEndPoint); 
        oauthReq.setMethod('POST');
        oauthReq.setHeader('Accept', 'application/json');
        oauthReq.setHeader('Authorization', authorizationHeader); 
        oauthReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        oauthReq.setBody('grant_type=client_credentials&scope=read:vc.sfdc_consumer_exp');
        oauthReq.setTimeout(2 * 60 * 1000);
                
        Http oauthHttp = new Http(); 
        HTTPResponse oauthResp = oauthHttp.send(oauthReq); //This just gets the access token  
        String oauthRespJSON = oauthResp.getBody();
        JSONParser parser = JSON.createParser(oauthRespJSON);
            
        while(parser.nextToken()!=null){
            if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                parser.nextToken();
                access_token+=parser.getText();
            }
        }     

        String memHeaders = 'Bearer ' + access_token; 
        HttpRequest memReq = new HttpRequest(); 
        memReq.setEndpoint(consumerIDEndPoint); 
        memReq.setMethod('POST');
        memReq.setHeader('Accept','application/json');
        memReq.setHeader('Content-Type','application/json');
        memReq.setBody(jsonBody);
        memReq.setHeader('Authorization', memHeaders); 

        Http memHttp = new Http(); 
        HTTPResponse memResp = new HttpResponse();
        memResp = memHttp.send(memReq);
        return memResp;
    }
}