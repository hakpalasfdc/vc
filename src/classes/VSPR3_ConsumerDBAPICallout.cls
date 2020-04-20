public class VSPR3_ConsumerDBAPICallout {
    public static HTTPResponse getConsumers(String requestBody){
        HTTPResponse consumerResp = new HttpResponse();
        String webServiceURL = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Web_Service__c;
        String tokenHeader = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Token_Header__c;
        String requestEndPoint = webServiceURL+'/as/token.oauth2';
		String authorizationHeader = 'Basic '+ tokenHeader; 
        String access_token='';   
        String consumerIDEndPoint = webServiceURL+'/sfdc-consumer-exp/SFDCConsumers';
		HttpRequest oauthReq = new HttpRequest(); 
        Http oauthHttp = new Http(); 
        
		oauthReq.setEndpoint(requestEndPoint); 
		oauthReq.setMethod('POST');
		oauthReq.setHeader('Accept', 'application/json');
		oauthReq.setHeader('Authorization', authorizationHeader); 
		oauthReq.setHeader('Content-Type', 'application/x-www-form-urlencoded');
		oauthReq.setBody('grant_type=client_credentials&scope=read:vc.sfdc_consumer_exp');
		oauthReq.setTimeout(2 * 60 * 1000);
						   
        HTTPResponse oauthResp = oauthHttp.send(oauthReq); 
        String oauthRespJSON = oauthResp.getBody();
        JSONParser parser = JSON.createParser(oauthRespJSON);
        
        while(parser.nextToken()!=null){
            if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                parser.nextToken();
                access_token += parser.getText();
            }
        }     
							  
        HttpRequest memReq = new HttpRequest(); 
        memReq.setEndpoint(consumerIDEndPoint); 
        memReq.setMethod('POST');
        memReq.setHeader('Accept','application/json');
        memReq.setHeader('Content-Type','application/json');
        memReq.setBody('{'+requestBody+'}');
        memReq.setHeader('Authorization', 'Bearer ' + access_token); 
        Http memHttp = new Http(); 
        consumerResp = memHttp.send(memReq);
        
        return consumerResp;
    }
}