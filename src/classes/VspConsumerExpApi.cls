/*
 * This is a wrapper class that manaages REST requests from SFDC to Consumer Experience API, or VSP if generalized.
 * This class attempts to use the access token value stored at VspOauthToken__c custom object, if it is expired it will 
 * request a new token from VSP and then attempt to update the token optimistically.
 * 
 * 
*/

public class VspConsumerExpApi {
    private static Integer maxTries = 5;  
    public static HTTPResponse getSFDCConsumers(String query) {
       return processRestRequest(query,  VspOauthTokenFactory.getTokenObject(), '/sfdc-consumer-exp/SFDCConsumers');
    }

    private static HTTPResponse processRestRequest(String query, VspOauthToken__c oauthTokenObject, String endpoint) { 
        String access_token=''; 
        boolean isExpired = VspOauthTokenFactory.isExpired(oauthTokenObject);
        String body = null;
        String webServiceURL = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Web_Service__c;
        String requestURL = webServiceURL+ endPoint;
        HttpResponse memResp = new HttpResponse();
        VspAccessToken newVspAccesstoken = null;
        System.debug('token isexpired='+isExpired);

        if (isExpired) {
            //-- token is expired, get fresh one from VSP
            System.debug('Token Expired, New Token being generated');
            memResp = postRequestAndUpdateTokenObject(requestUrl, query, oauthTokenObject);
            body = memResp.getBody();
        } else {
            //-- token record is not expired so lets try to use it
            System.debug('Existing token is used to connect with Consumer DB');
            HttpRequest memReq = buildRequest(requestURL, oauthTokenObject.access_token__c, query);     
            Http memHttp = new Http();
            try{
            	memResp = memHttp.send(memReq);
            }
            catch(System.CalloutException e){
				memResp.setStatusCode(503);
                memResp.setBody(e.getMessage());
            }
            System.debug('memResp=processRestRequest=='+memReq);
            body = memResp.getbody();  
            System.debug('memResp=processRestRequest=='+ memResp.getStatusCode());
            System.debug('memResp=processRestRequest=='+body);
        }      
        if (memResp != null && memResp.getStatusCode() == 401) {
            //-- token is expired but was not detected as such or token is just not good, so get a new one do the request again and update the token    
            System.debug('Consumer DB API status code 401, Regenerate new Token');
            body = postRequestAndUpdateTokenObject(requestUrl, query, oauthTokenObject).getBody();
        }
        
        return memResp;
    }
    
    private static HttpResponse postRequestAndUpdateTokenObject(String requestUrl, String query, VspOauthToken__c oauthTokenObject) {
       	// VspAccessToken newVspAccesstoken = VspOauthTokenFactory.retrieveNewToken();
		String newVspAccesstoken = VspOauthTokenFactory.retrieveNewToken();
        System.debug('newVspAccesstoken='+ newVspAccesstoken);       
        //System.debug('newVspAccesstok - 2 ='+newVspAccesstoken1);
      	//  HttpRequest memReq = buildRequest(requestURL, newVspAccesstoken.access_token, query);
        HttpRequest memReq = buildRequest(requestURL, newVspAccesstoken , query);
        System.debug('newmemReq=postRequestAndUpdateTokenObject'+ memReq.getBody());
        Http memHttp = new Http();
        HttpResponse memResp = new HttpResponse();
        
        try{
           memResp = memHttp.send(memReq);
        }
        catch(System.CalloutException e){
            memResp.setStatusCode(503);
            memResp.setBody(e.getMessage());
        }
        
        System.debug('newmemResp==='+memResp);
        if (memResp.getStatusCode() == 200) {
         // tryTokenUpdate(oauthTokenObject, newVspAccesstoken);
            tryTokenUpdate(oauthTokenObject, newVspAccesstoken);
        }
        return memResp;
    }
    
    /* hypothetical request for providers to illustrate the pattern
	public static String getProvider(String jsonQuery) {
        return processRestRequest(jsonQuery, 1, null, VspOauthTokenFactory.getTokenObject(), '/provider-web/providers');
    } */
    
    //-- Not going to be too eager with updating token so some extra calls may get through
  	//  private static void tryTokenUpdate(VspOauthToken__c oauthTokenObject, VspAccessToken vspAccessToken) {
  	private static void tryTokenUpdate(VspOauthToken__c oauthTokenObject, String vspAccessToken) {    
        try{
			if (vspAccessToken != null) {
            	VspOauthTokenFactory.updateToken(oauthTokenObject, vspAccessToken);
            }
        }catch (Exception e) {
        	System.debug(e.getStackTraceString());
        }
	}
    
    private static HttpRequest buildRequest(String webServiceURL, String tokenHeader, String requestBody) {
        string jsonBody;
        HttpRequest memReq = new HttpRequest();
        String consumerIDEndPoint = webServiceURL;
        Decimal timeoutDec = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Timeout_milliseconds__c;
        Integer timeoutInt;
        
        if(timeoutDec > 0 && timeoutDec <= 120000){
            timeoutInt = timeoutDec.intValue(); //convert to integer 
        }
        else{
            timeoutInt = 10000; //10 seconds
        }

        memReq.setTimeout(timeoutInt);
        memReq.setEndpoint(consumerIDEndPoint); 
        memReq.setMethod('POST');
        memReq.setHeader('Accept','application/json');
        memReq.setHeader('Content-Type','application/json');
        SYSTEM.DEBUG('###consumerIDEndPoint  = '+ consumerIDEndPoint);
        SYSTEM.DEBUG('### Q = '+ requestBody);
        String APItype = requestBody.substring(0,2);
        requestBody=requestBody.substring(2,requestBody.length());
        System.debug('APItype+requestBody ====' + APItype+requestBody);
        if (APItype =='CS') 
        {
            jsonBody='{'+requestBody+'}';
        }
        else
        {
            jsonBody = requestBody;
        }
        memReq.setBody(jsonBody);  
        System.debug('AccessToken='+tokenHeader);
        String memHeaders = 'Bearer ' + tokenHeader;
        memReq.setHeader('Authorization', memHeaders); 
        System.debug('memReq=buildRequest=='+memReq);
        return memReq;
    }
}