global class VspOauthTokenFactory {
    
   // public static VspAccessToken retrieveNewToken() {
    public static String retrieveNewToken() {
        HttpRequest tokenRequest = new HttpRequest();
         String access_token='';
        tokenRequest.setMethod('POST');
        tokenRequest.setHeader('content-type', 'application/x-www-form-urlencoded');
        String authorizationHeaderValue = 'Basic ' + Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Token_Header__c;
        tokenRequest.setHeader('Authorization', authorizationHeaderValue); // 'Basic c2ZkYy1zb2ZpLWFwcDpiQUJlYTczbXRua2Rld2dWcWlhZDVFZ1ZqUjdiMEJvWW1MYVBzNnBLa1JTYklyQ3lwS3lGcmFrcGd1N2tqT1BV'); // use custom setting for value
        String body = 'grant_type=client_credentials&scope=read:vc.sfdc_consumer_exp'; // maybe use custom setting for value
        tokenRequest.setTimeout(2 * 60 * 1000);
        tokenRequest.setBody(body);
        System.debug('tokenRequest ' + tokenRequest.getBody());
        String tokenEndpointUrl = Consumer_Search_Web_Service__c.getInstance('Consumer Search Values').Consumer_Search_Web_Service__c +'/as/token.oauth2';
        tokenRequest.setEndpoint(tokenEndpointUrl);  //'https://api-staging.vspglobal.com/as/token.oauth2'); // get from custom setting
        System.debug('newoauthReq ==='+tokenRequest);
        Http oauthHttp = new Http();
        VspAccessToken newToken = null;
          
        try {
        	//newToken = (VspAccessToken)JSON.deserialize(http.send(tokenRequest).getBody(), VspAccessToken.class);
        	HTTPResponse oauthResp = oauthHttp.send(tokenRequest); //This just gets the access token                      
            String oauthRespJSON=oauthResp.getBody();
            System.debug('newoauthRespJSON = '+ oauthRespJSON);
            
            
            JSONParser parser=JSON.createParser(oauthRespJSON);
               while(parser.nextToken()!=null){
                  if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                        parser.nextToken();
                        access_token+=parser.getText();
                     
                  }
               }     
            
        } catch (Exception e) {
            
        }
      //  return newToken;
        System.debug('New Token successfully generated = '+ access_token);    
        return access_token;
    }
    public static void updateOauthToken(String newTokenValue, Integer expires_in) {
        // going to use optimistic updates and just fail gracefully, if it is locked then it is being updted and next user will be fine.
        VspOauthToken__c theOauthTokenForUpdate = getTokenObject(); 
        theOauthTokenForUpdate.access_token__c = newTokenValue;
        System.debug(expires_in);
        theOauthTokenForUpdate.expires_in__c = Decimal.valueOf(expires_in);
        theOauthTokenForUpdate.granted_at__c = DateTime.now();
        update theOauthTokenForUpdate;
    }
    
    public static void updateOauthTokenForMaxTries(String newTokenValue, Integer expires_in, Integer tries, Integer maxAttempts) {        
        try {
            VspOauthToken__c theOauthTokenForUpdate = getTokenObject();
            theOauthTokenForUpdate.access_token__c = newTokenValue;
            System.debug(expires_in);
            theOauthTokenForUpdate.expires_in__c = Decimal.valueOf(expires_in);
            theOauthTokenForUpdate.granted_at__c = DateTime.now();
            update theOauthTokenForUpdate;
        } catch(QueryException e) {
            if (tries <= maxAttempts) {
                Integer nextTry = tries + 1;
                updateOauthTokenForMaxTries(newTokenValue, expires_in - 1, nextTry, maxAttempts);
            }
        }

    }
    public static VspOauthToken__c getTokenObject() {
        VspOauthToken__c token = null;
        List<VspOauthToken__c> tokens = [Select Id, access_token__c, granted_at__c, expires_in__c From VspOauthToken__c WHERE tokenId__c = 'primary' Limit 1];
        System.debug('token size' + tokens.size());
        if (tokens.size() > 0) {
        	token = tokens.get(0);
        }
          else
        {
        VspOauthToken__c oAuthtok = new VspOauthToken__c(); 
        oAuthtok.tokenId__c = 'primary';
        oAuthtok.access_token__c = 'eyJhbGciOiJSUzUxMiIsImtpZCI6IkFTWU0tU1RHIiwicGkuYXRtIjoiNyJ9.eyJzY29wZSI6WyJyZWFkOnZjLnNmZGNfY29uc3VtZXJfZXhwIl0sImNsaWVudF9pZCI6InNmZGMtc29maS1hcHAiLCJpc3MiOiJodHRwczovL2xvZ2luLXJhbmNobzEuc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiYXVkIjoiaHR0cHM6Ly9hcGktc3RhZ2luZy52c3BnbG9iYWwuY29tIiwiZXhwIjoxNTcwNzE1MjY0fQ.hKZQ3N_oY8dRoU7yOGIhDouwz28kqih9SjLa-QflbrwnqGzDvj2EzRYIrK2tsFpHQ2Fucxw5ooZHKUkt-OL7Qr2bmfCnsuYFiJ_Ah59vOtJvDcUonRzHj8txxQ5EJUxtukxve7Ptj3uK62yaYfTV7G0wHzFjD0VIIsKbwXY4Gl2JOh2MkVvbaodrlj44SdhwT32IiSyYWDugLA3cvD_6_6al8ztYbG_PFO0LICH0oZjYXZ1IOQ5Tgnux3XPQ0k1Fatf8vcS7XFAYHdTi77T_-LjHKmTcGqGQm62jSsHBrNJqxlnp30lErvPcJSEii_-eD6VgHIvqp65jH4OXJ3lwNA';
        oAuthtok.expires_in__c = 1799;       
        oAuthtok.granted_at__c = DateTime.now().AddDays(-10) ;
        insert oAuthtok; 
        System.debug('New Token Record Added' + oAuthtok.Id);
        token = oAuthtok;
        }
        System.debug('TOKEN =='+token);
        return token;
    }
    
   // public static void updateToken(VspOauthToken__c oauthTokenObject, VspAccessToken thisToken) {
      public static void updateToken(VspOauthToken__c oauthTokenObject, String thisToken) {
         System.debug('attmepting Update of token ' + thisToken);
        //updateOauthTokenForMaxTries(token.access_token, token.expires_in, 1);
      //  oauthTokenObject.access_token__c = thisToken.access_token;
        oauthTokenObject.access_token__c = thisToken;
       // System.debug(thisToken.expires_in);
        //oauthTokenObject.expires_in__c = Decimal.valueOf(thisToken.expires_in);
        oauthTokenObject.expires_in__c = 1799;
        oauthTokenObject.granted_at__c = DateTime.now();
        update oauthTokenObject;
        
    }
    
    public static boolean isExpired(VspOauthToken__c thisOauthTokenObject) {
        DateTime nowDT = DateTime.now();
        System.debug('now='+nowDT);
        Long now = nowDT.getTime();	
        Long expiresIn = 1;
        if (thisOauthTokenObject.expires_in__c != null) {        
        	expiresIn = thisOauthTokenObject.expires_in__c.longValue();
        }
        DateTime grantedAt = thisOauthTokenObject.granted_at__c;
        System.debug('grantedat='+grantedAt);
        System.debug('expiresIn='+expiresIn);
        System.debug('Is Expired'+((now - grantedAt.getTime()) >= (expiresIn * 1000)));
        return ((now - grantedAt.getTime()) >= (expiresIn * 1000));
    }
   
}