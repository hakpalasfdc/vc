public class VSPR9_AccountOrderSummaryController {

    // Define the variables for disabling and enabling previous and next buttons and when an error message should be shown 
    public Boolean disablePrevious{get;set;}
    public Boolean disableNext{get;set;}
    public String orderDetailsEndPoint{get;set;}
    public Map<Integer,String> mapOffset{get;set;}
    public Integer intOffsetMapKey = 0;
               
    public Integer intAgeSetMapKey = 0;
               
    public Boolean showDataTable{get;set;}
    public Boolean mainErrorMEssage{get;set;}
               
    public Map<Integer,String> ageMap{get;set;}
    public Integer ageMapKey = 0;
    public Integer nextAge{get;set;}
    public Integer previousAge{get;set;}
     
    // Defining and assigning the variables for web service URL, token header and version with the values given in the custom settings for DVI web service
    public String webServiceURL = DVIWebService__c.getInstance('DVI Values').DVI_Web_Service__c;
    public String tokenHeader = DVIWebService__c.getInstance('DVI Values').DVI_Token_Header__c;
    public String webServiceVersion = DVIWebService__c.getInstance('DVI Values').DVI_Web_Service_Version__c;
    
    // defining instances for VSPR9_OrderSummariesWrapper class 
    public List<VSPR9_OrderSummariesWrapper> lstOrderSummaryDetails{get;set;}
    
    public String accountNumber{get;set;}
    public String searchOnPatientName{get;set;}
    public String searchOnRxNumber{get;set;}
    public String searchOnInvoiceNumber{get;set;}
    public String serviceException{get;set;}
            
    // Declaring and assigning the sort direction and sort field
    private String sortDirection = 'DESC';
    private String sortExp = 'invoicenumber';
        
    public Id accountId{get;set;}
   public Integer nextPosition{get;set;}
    public Integer previousPosition{get;set;}
        
    public List<VSPR9_ShippingMethodDetailsWrapper> lstShippingMethodDetails{get;set;}
    public String strLabOrdersURL{get;set;}
        
    public Map<String,Object> deserializeMap = new Map<String,Object>();
    public String vspLensorderDetailsUrl{get;set;}
    public Map<String,String> rxnumberHrefMap{get;set;}
        
    public Boolean redoSubmission{get;set;}
    
    
    // Constructor with default values
    public VSPR9_AccountOrderSummaryController(){
        mapOffset = new Map<Integer,String>(); 
                              
        ageMap = new Map<Integer,String>();
                              
        previousPosition = 0;
        orderDetailsEndPoint = webServiceURL + '/';
        disablePrevious = true; 
        disableNext = false;
        showDataTable = true;
        mainErrorMEssage = false;
        system.debug('++++++++++++++++++++++++++ CUSTOM SETTING VALUES +++++++++++++++++++++++++++++' + webServiceURL + ', ' + tokenHeader + ', ' + webServiceVersion );    
    } 

    

    // method that takes the sort expression and direction on which field you are working on 
    public String sortExpression{
        get{ 
            return sortExp; 
        }
        set{ 
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
    
    // getter and setter for sort direction 
    public String getSortDirection(){
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value){ 
        sortDirection = value; 
    } 
 
    // method that shows on which columns/fields sorting can be done 
    public void SortData() { 
        if(sortDirection == 'DESC'){
            VSPR9_OrderSummariesWrapper.SORT_DIR = VSPR9_OrderSummariesWrapper.SortDirection.DESCENDING;
        }else{
            VSPR9_OrderSummariesWrapper.SORT_DIR = VSPR9_OrderSummariesWrapper.SortDirection.ASCENDING;
        }
    
        if(sortExpression == 'patientname'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.patientName;
        }else if(sortExpression == 'labname'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.labName;
        }else if(sortExpression == 'location'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.labStationStatus;
        }else if(sortExpression == 'rxnumber'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.rxNumber;
        }else if(sortExpression == 'invoicenumber'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.invoiceNumber;
        }else if(sortExpression == 'entereddate'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.dateEntered;
        }else if(sortExpression == 'estimatedshipdate'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.estimatedShipDate;
        }else if(sortExpression == 'locationatdate'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.dateAtStation;
        }else if(sortExpression == 'shipdate'){
            VSPR9_OrderSummariesWrapper.SORT_FIELD = VSPR9_OrderSummariesWrapper.SortField.actualShipDate;
        }
        lstOrderSummaryDetails.sort(); 
    } 
    
    //Method that displays the shipping methods 
    public void getShipMethodDetails(){
        accountNumber = ApexPages.currentPage().getParameters().get('optickey');
        String access_token = getAccessToken();
        HttpRequest labReq = new HttpRequest(); 
                
        orderDetailsEndPoint = webServiceURL + '/lab-vsponelensordersapi-web/labaccounts?account='+accountNumber.replaceAll('^0+(?!$)', '');
        labReq.setEndpoint(orderDetailsEndPoint); 
        labReq.setMethod('GET');

        labReq.setHeader('Accept','application/json;version='+webServiceVersion);

        String labHeaders = 'Bearer ' + access_token; 
        labReq.setHeader('Authorization', labHeaders); 
        List<Object> labOrders = new List<Object>(); 

        Http labHttp = new Http(); 
        HTTPResponse labResp;
        if(!Test.isRunningTest()){
            try{
                labReq.setTimeout(2 * 60 * 1000);
                labResp = new HttpResponse();
                labResp = labHttp.send(labReq);                
            }catch(CalloutException ex){
                serviceException = 'Error';
                labResp = null;
                HandleException(ex);
            } 
        }else{
            labResp = AccountOrderSummaryTest_Helper.labAccountResponse();
        }
        List<Object> lstShipMethods = new List<Object>();
        lstShippingMethodDetails = new List<VSPR9_ShippingMethodDetailsWrapper>();
        System.debug('-------------------------labResp-----------------------'+labResp);
        try{
            if(labResp !=null && labResp.getBody()!=null && !labResp.getBody().equalsIgnoreCase('')){
                System.debug('-------------------------body-----------------------'+labResp.getBody());
                deserializeMap = (Map<String,Object>)JSON.deserializeUntyped(labResp.getBody());
                system.debug('--------orders--------'+deserializeMap);
                if(deserializeMap!=null && deserializeMap.size()>0){
                    Map<String,Object> labAccountDetails=(Map<String,Object>)deserializeMap.get('labAccount');
                    system.debug('-----------------------------------------------------temp1----------------------------------------------------------'+labAccountDetails);
                    system.debug('-----------------------------------------------------temp2----------------------------------------------------------'+(List<Object>)deserializeMap.get('shipMethods'));
                    system.debug('-----------------------------------------------------temp3----------------------------------------------------------'+(Map<String,Object>)deserializeMap.get('vsponeLensOrders'));
                    lstShipMethods = (List<Object>)deserializeMap.get('shipMethods');
                    if(lstShipMethods != null && lstShipMethods.size() > 0){
                        for(object obj:lstShipMethods){
                            String strJsonNew = JSON.serialize(obj);
                            VSPR9_ShippingMethodDetailsWrapper shipObj = (VSPR9_ShippingMethodDetailsWrapper)JSON.deserialize(strJsonNew, VSPR9_ShippingMethodDetailsWrapper.class);
                            lstShippingMethodDetails.add(shipObj);
                        }
                    }
                    system.debug('-----------------------------------------------------lstShippingMethodDetails----------------------------------------------------------'+lstShippingMethodDetails);
                    Map<String,Object> laborderURLMap =  (Map<String,Object>)deserializeMap.get('vsponeLensOrders');                    
                    if(laborderURLMap !=null && laborderURLMap .size()>0){
                    
                        strLabOrdersURL = (String)laborderURLMap.get('href');
                    }
                    
                }
            }
          
        }catch(Exception e){
            serviceException = 'ABCD';
            HandleException(e); 
        }
        system.debug('-----------------------------------------------------strLabOrdersURL-------------------------------'+strLabOrdersURL);
        getAccountOrderSummaryDetails();
    }
    
    //Method that displays the Order Summaries by taking URL from LabAccount payload
    public void getAccountOrderSummaryDetails(){
        accountNumber = ApexPages.currentPage().getParameters().get('optickey');
        accountNumber = accountNumber.trim();
        accountNumber = accountNumber.replaceAll('(\\s+)', ' ');
                
        setAccountNumberValue();
        //system.debug('----------------------------------------OPTIC KEY IS -------------------------------------------------------------------'+accountNumber);

        orderDetailsEndPoint = strLabOrdersURL; 
               
        List<VSPR9_OrderSummariesWrapper> orderDetails = fetchAccountOrderDetails(orderDetailsEndPoint);
        if(lstOrderSummaryDetails.size()>0){
            showDataTable = true;
            processTheRecords();
            disablePrevious = true;
            disableNext = false;
            nextPosition = mapOffset.size();
            previousPosition = nextPosition-1;
                                             
            nextAge = ageMap.size();
            previousAge = nextAge-1;
                                             
            if(lstOrderSummaryDetails.size()< 20)
                disableNext = true;
        }else{
            showDataTable = false;
            mainErrorMEssage = true;
            disablePrevious = true;
            disableNext = true;
        } 
        system.debug('-----mapOffset---FIRSTTIME-----'+mapOffset);
        system.debug('-----mapOffset---FIRSTTIME--SIZE---'+mapOffset.size());
        system.debug('-----nextPosition---FIRSTTIME-----'+nextPosition); 
        system.debug('-----previousPosition---FIRSTTIME-----'+previousPosition); 
                              
                              system.debug('-----mapOffset---FIRSTTIME-----'+ageMap);
        system.debug('-----mapOffset---FIRSTTIME--SIZE---'+ageMap.size());
        system.debug('-----nextPosition---FIRSTTIME-----'+nextAge); 
        system.debug('-----previousPosition---FIRSTTIME-----'+previousAge);
                              
    }
    
    //Method that queries to get the SFDC Account and direct to SFDC account page when clicked on account name 
    public void setAccountNumberValue(){
        Integer opticKeyLength;
        if(accountNumber!=null)
            opticKeyLength = accountNumber.length();
        String strTemp = '';
        for(Integer i=0;i<10-opticKeyLength;i++){
            strTemp = strTemp+'0';
        }
        String strAccountNumber = strTemp + accountNumber;
        system.debug('-----------strAccountNumber-------'+strAccountNumber);
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' and Name='Business Account' LIMIT 1];
        system.debug('------------RT-------------'+rt);
        accountId = null;
        if(rt!=null){
            for(Account obj:[Select Id,Optics_Key__c from Account where (Optics_Key__c!=null and  Optics_Key__c!='' and Optics_key__c like :('%' + strAccountNumber + '%')) and RecordTypeId=:rt.Id]){
                
                system.debug('!!!!!!!!!!!!!!!!!!!!!!! OPTIC KEY !!!!!!!!!!!!!!!!!!!!!!!!!!' +obj.Optics_Key__c);
                List<String> opticKeys = obj.Optics_Key__c.split(', ');
                system.debug('!!!!!!!!!!! opticKeys !!!!!!!!!!!!!!!!!!!!!' +opticKeys);
                
                for(String str : opticKeys){
                    if(str.equals(strAccountNumber))
                        accountId = obj.Id;
                }
            }      
            system.debug('-----------accountId -------'+accountId ); 
        }
    }
    
    // this method is used to get the access token by requesting the web service 
    public String getAccessToken(){
        HttpRequest oauthReq = new HttpRequest(); 
        String access_token='';
        try{
            //URL for the OAuth to get the Access Token goes here
            oauthReq.setEndpoint(webServiceURL + '/as/token.oauth2?grant_type=client_credentials&scope=laborder_view'); 

            oauthReq.setMethod('POST');
            String authorizationHeader = 'Basic '+ tokenHeader; 
            oauthReq.setHeader('Authorization', authorizationHeader); 
            oauthReq.setTimeout(2 * 60 * 1000);
            
            Http oauthHttp = new Http(); 
            HTTPResponse oauthResp = oauthHttp.send(oauthReq); 
            
            String oauthRespJSON=oauthResp.getBody();
            JSONParser parser=JSON.createParser(oauthRespJSON);
            while(parser.nextToken()!=null){
                if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                    parser.nextToken();
                    access_token+=parser.getText();
                }
            }            
        }catch(Exception e){
            serviceException = 'ABCD';
            HandleException(e);  
        }
        system.debug('access token is ----------------------------' + access_token);
        return access_token;
    }    
    
    //Method that handles the exception and send an email to email addresses listed in the custom setting 
    public PageReference HandleException(Exception e){
        List<Messaging.Singleemailmessage> emailMessages = new List<Messaging.Singleemailmessage>();
        String[] toEmailsIds = new String[]{};
               
        for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
            toEmailsIds.add(obj.Name);
        }
       
        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        if(toEmailsIds!=null && toEmailsIds.size()>0){
            email.setToAddresses(toEmailsIds);
            email.setSubject('Exception Occured while calling the DVI Web Service');
            
            if(e!=null && e.getMessage()!=null)
                email.setPlainTextBody('Exception occured while calling the service-------- the exception message is ------->'+e.getMessage()) ;
            else
                email.setPlainTextBody('Exception Occured!!');
                
            emailMessages.add(email);
            Messaging.sendEmail(emailMessages);
        }
        //PageReference pageRef = new PageReference('/apex/Exception_Handler');
        //pageRef.setRedirect(true);
        //return pageRef;
        
         ApexPages.Message myMsg;
         if(serviceException!=null && serviceException!='' && serviceException == 'Error'){
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An unexpected error has occured. Please try again. <br><br> If you continue to see this message, contact <a href = "mailto:BPRE@vsp.com"> BPRE@vsp.com </a> ');
         }else{
            myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'An unexpected error has occured. <br><br> Please report the issue to <a href = "mailto:BPRE@vsp.com"> BPRE@vsp.com </a> ');
            //serviceException = '';
         }
        ApexPages.addMessage(myMsg);
        return null;
    }
               
    public void processTheRecords(){
        String hrefURL, age;
        Map<String,Object> nextMap =  (Map<String,Object>)deserializeMap.get('next');                    
        if(nextMap !=null && nextMap .size()>0){
            hrefURL = (String)nextMap.get('href');
        }
        system.debug('&&&&&&&&&&&&&&&&&&& hrefURL &&&&&&&&&&&&&&&&&&&&&&&&&&&&' +hrefURL);
        age = hrefURL.substring(hrefURL.indexof('&age=')+5, hrefURL.indexof('&offset='));
        system.debug('&&&&&&&&&&&&&&&&&&& age &&&&&&&&&&&&&&&&&&&&&&&&&&&&' +age);
                              
        if(deserializeMap!=null && deserializeMap.size()>0 && deserializeMap.get('offsetId')!=null && deserializeMap.get('offsetId')!=''){
            if(mapOffset!=null && ageMap != null){
                Set<String> offSetMapValueSet = new Set<String>();
                
                List<String> ageMapValueSet = new List<String>();
                
                for(String obj:mapOffset.values())
                    offSetMapValueSet.add(obj);
                for(String obj:ageMap.values())
                    ageMapValueSet.add(obj);
                if(!offSetMapValueSet.contains((String)deserializeMap.get('offsetId'))){
                    intOffsetMapKey = intOffsetMapKey+1;
                    mapOffset.put(intOffsetMapKey,(String)deserializeMap.get('offsetId'));
                    disablePrevious = false;
                    disableNext = false;
                }
                    
                
                
                intAgeSetMapKey = intAgeSetMapKey+1;
                ageMap.put(intAgeSetMapKey,age);
                    
                    
                
                /*
                if(!ageMapValueSet.contains(age)){
                    intAgeSetMapKey = intAgeSetMapKey+1;
                    ageMap.put(intAgeSetMapKey,age);
                }
                */
                
                
                
            }
        }else{
            disableNext = true;
            disablePrevious = false;
        }
    }

    // this method executes when clicked on next button 
    public void nextPage(){
        system.debug('-----nextPosition---1111111--'+nextPosition);
        system.debug('-----mapOffset---1111111--'+mapOffset);
        if(accountNumber!=null){
            accountNumber = accountNumber.trim();
            accountNumber = accountNumber.replaceAll('(\\s+)', ' ');
        }
        if(mapOffset!=null && mapOffset.size()>0 && ageMap!=null && ageMap.size()>0){
            if(nextPosition!=null && nextPosition>0 && nextAge!=null && nextAge>0){
                                             
                orderDetailsEndPoint = webServiceURL + '/lab-vsponelensordersapi-web/vsponelensorders?account='+accountNumber.replaceAll('^0+(?!$)', '')+'&age='+ageMap.get(nextAge)+'&offset='+mapOffset.get(nextPosition);
                                                            
            }
        } 
        lstOrderSummaryDetails = fetchAccountOrderDetails(orderDetailsEndPoint);
        system.debug('-----lstOrderSummaryDetails---1111111--'+lstOrderSummaryDetails);
        if(lstOrderSummaryDetails!=null && lstOrderSummaryDetails.size()>0 ){
            processTheRecords();
            Integer temp = nextPosition;
            previousPosition = temp-1;
            nextPosition = nextPosition +1;
                                             
            Integer temp2 = nextAge;
            previousAge = temp2-1;
            nextAge = temp2 +1;
                                             
            disablePrevious = false;

            if(lstOrderSummaryDetails.size() < 20)
                disableNext = true;
        }
        else{
            system.debug('--------else----NEXT--------');
            disableNext = true;
            disablePrevious = false;
            Integer temp = nextPosition;
            previousPosition = temp-1;
                                             
            Integer temp2 = nextAge;
            previousAge = temp2-1;
                                             
            showDataTable = false;
            mainErrorMEssage = false;
        }
        
        sortDirection = 'DESC';
        sortExp = 'invoicenumber';

        system.debug('--------else----showDataTable--------'+showDataTable);
        system.debug('--------mapOffset----NEXT--------'+mapOffset);
        system.debug('--------mapOffset----NEXT--SIZE------'+mapOffset.size());
        system.debug('--------nextPosition-----NEXT-------'+nextPosition);
        system.debug('--------previousPosition----NEXT--------'+previousPosition);
        
        system.debug('--------ageMap----NEXT--------'+ageMap);
        system.debug('--------ageMap----NEXT--SIZE------'+ageMap.size());
        system.debug('--------nextAge-----NEXT-------'+nextAge);
        system.debug('--------previousAge----NEXT--------'+previousAge);
    }

    
    // this method executes when clicked on previous button 
    public void previousPage(){
        system.debug('--------previousPosition-----PREV-------'+previousPosition);
        system.debug('--------mapOffset----PREV--------'+mapOffset);
        if(mapOffset!=null && mapOffset.size()>0 && ageMap!=null && ageMap.size()>0){
            showDataTable = true;
            mainErrorMEssage = false;
            if(previousPosition!=null && previousPosition>0 && previousAge!=null && previousAge>0){
                String temp = mapOffset.get(previousPosition);
                                                            String temp2 = ageMap.get(previousAge);
                if(accountNumber!=null){
                    accountNumber = accountNumber.trim();
                    accountNumber = accountNumber.replaceAll('(\\s+)', ' ');
                }
                                                            orderDetailsEndPoint = webServiceURL + '/lab-vsponelensordersapi-web/vsponelensorders?account='+accountNumber.replaceAll('^0+(?!$)', '')+'&age='+temp2+'&offset='+temp;
                disablePrevious = false;
                disableNext = false;
                Integer i = previousPosition;
                nextPosition = i+1;
                previousPosition = previousPosition-1;
                                                            
                Integer i2 = previousAge;
                nextAge = i2+1;
                previousAge = previousAge-1;
            }else{
                accountNumber = accountNumber.trim();
                accountNumber = accountNumber.replaceAll('(\\s+)', ' ');
                    
                orderDetailsEndPoint =  webServiceURL + '/lab-vsponelensordersapi-web/vsponelensorders?account='+accountNumber.replaceAll('^0+(?!$)', '');
                disablePrevious = true;
                disableNext = false;
                nextPosition = previousPosition+1;
                previousPosition = 0;
                nextAge = nextAge+1;
                previousAge = 0;
            }
            system.debug('--------orderDetailsEndPoint----PREV--------'+orderDetailsEndPoint);
            lstOrderSummaryDetails = fetchAccountOrderDetails(orderDetailsEndPoint);
            system.debug('--------lstOrderSummaryDetails------------'+lstOrderSummaryDetails);
            if(lstOrderSummaryDetails!=null && lstOrderSummaryDetails.size()>0){
                processTheRecords();
                if(lstOrderSummaryDetails.size() < 20)
                    disableNext = true;
            }
        } 
        
        sortDirection = 'DESC';
        sortExp = 'invoicenumber';

        system.debug('--------nextPosition-----PREV-------'+nextPosition);
        system.debug('--------previousPosition----PREV--------'+previousPosition);
        system.debug('--------mapOffset----PREV--------'+mapOffset);
        system.debug('--------mapOffset----PREV--SIZE------'+mapOffset.size());
    }
    
    
    //this method takes the web service URL as the parameter and makes a HTTP request to get the response and de-serializes the data 
    public List<VSPR9_OrderSummariesWrapper> fetchAccountOrderDetails(String orderDetailsEndPoint){ 
        system.debug('-------------------------------------------------------------------------------------------------------------------------'+orderDetailsEndPoint);
        rxnumberHrefMap = new map<String,String>();
        String access_token = getAccessToken();
        HttpRequest labReq = new HttpRequest(); 
        
        HTTPResponse labResp;
        List<Object> labOrders = new List<Object>(); 
        if(orderDetailsEndPoint != null){
            labReq.setEndpoint(orderDetailsEndPoint); 
        
            labReq.setMethod('GET');
         
            //Version Number is specified here
            labReq.setHeader('Accept','application/json;version='+webServiceVersion);    
            String labHeaders = 'Bearer ' + access_token; 
            labReq.setHeader('Authorization', labHeaders);             
            labReq.setTimeout(2 * 60 * 1000);
            Http labHttp = new Http(); 
            
            if(!Test.isRunningTest()){
                try{
                    //labReq.setTimeout(10);
                    labResp = labHttp.send(labReq);
                }catch(CalloutException ex){
                    serviceException = 'Error';
                    labResp = null;
                    HandleException(ex);
                } 
            }else{
                labResp = AccountOrderSummaryTest_Helper.vsponeLensOrdersResponse();
            }
        }
        //System.debug('-------------------------body-----------------------'+labResp.getBody());
        lstOrderSummaryDetails = new List<VSPR9_OrderSummariesWrapper>();
        
        try{
            if(labResp !=null && labResp.getBody()!=null && !labResp.getBody().equalsIgnoreCase('')){
                deserializeMap = (Map<String,Object>)JSON.deserializeUntyped(labResp.getBody());
                system.debug('--------orders--------'+deserializeMap);
                if(deserializeMap!=null && deserializeMap.size()>0)
                    labOrders=(List<Object>)deserializeMap.get('vsponeLensOrders');
            }
            system.debug('-----------------------------------------------------labOrders----------------------------------------------------------'+labOrders); 
            
            if(labOrders != null && labOrders.size() > 0){
                for(object obj:labOrders){
                    String strJsonNew = JSON.serialize(obj);
                    system.debug('-----------strJsonNew---------'+strJsonNew);
                    VSPR9_OrderSummariesWrapper orderObj = (VSPR9_OrderSummariesWrapper)JSON.deserialize(strJsonNew, VSPR9_OrderSummariesWrapper.class);
                    system.debug('--------------------vsponeLensOrderDetail--$$$$$$$$$--------'+orderObj);
                    
                    if(orderObj!=null){
                        rxnumberHrefMap.put(orderObj.RxNumber,orderObj.vsponeLensOrderDetail.href);
                        orderObj.lensOrderUrl = orderObj.vsponeLensOrderDetail.href+'&accountNumber='+accountNumber;
        
                        system.debug('-------------------- orderObj.lensOrderUrl-------'+ orderObj.lensOrderUrl);
                         
                        String strEstShipDate = orderObj.estimatedShipDate; 
                        String strActualShipDate = orderobj.actualShipDate;
                        if(strEstShipDate!=null && !strEstShipDate.equalsIgnoreCase('') && strActualShipDate!=null && !strActualShipDate.equalsIgnoreCase('')){
                            orderObj.estimatedShipDate = ''; 
                        }
            
                        String strUpdatedEstShipDate = orderObj.estimatedShipDate; 
                        if( strUpdatedEstShipDate != null && !strUpdatedEstShipDate.equalsIgnoreCase('') ){ 
                            Date estShipDate = Date.valueOf(strUpdatedEstShipDate ); 
                            if(estShipDate < Date.today()){
                               orderObj.estimatedShipDate = 'Contact VSPOne Lab'; 
                            }
                        }
                        
                        String strStation;
                        if(orderObj.labStationStatus != null){
                            strStation = orderObj.labStationStatus; 
                            if(strStation.equalsIgnoreCase('CUSTOMER SERVICE')){
                                orderObj.estimatedShipDate = 'Contact VSPOne Lab'; 
                            }
                        }
                        if(orderObj.dateEntered != null){
                            orderObj.dateEntered = (orderObj.dateEntered).substring(0,10);
                        }
                        if(orderObj.dateAtStation != null){
                            orderObj.dateAtStation = (orderObj.dateAtStation).substring(0,10);
                        }
            
                        //Condition if the Location is Shipped and Ship Date is empty
                        
                        if(strStation!=null && strStation!='' && (strStation.equalsIgnoreCase('SHIPPED')) && (String.isBlank(strActualShipDate))){
                            orderObj.estimatedShipDate = '';
                            orderObj.actualShipDate = orderObj.dateAtStation;
                        }

                        lstOrderSummaryDetails.add(orderObj);
                    }
                } 
            }
        }catch(Exception e){
            serviceException = 'ABCD';
            HandleException(e);  
        }
        system.debug('-----------rxnumberHrefMap----------'+rxnumberHrefMap);
        return lstOrderSummaryDetails;
    }

    //Code for smart filter
    public void searchOrderDetails(){
        List<VSPR9_OrderSummariesWrapper> lst = new List<VSPR9_OrderSummariesWrapper>();
        //system.debug('------------------------------------------------searchOnPatientName----------------------------------------------------'+searchOnPatientName);
        if(searchOnPatientName!=null && searchOnPatientName!='' && (searchOnRxNumber==null || searchOnRxNumber=='')){
            for(VSPR9_OrderSummariesWrapper obj:lstOrderSummaryDetails){
                String temp = obj.patientName.ToLowerCase();
                if(temp.contains(searchOnPatientName)){
                    lst.add(obj);
                }
        }
        lstOrderSummaryDetails = lst;
        }
        else if(searchOnRxNumber!=null && searchOnRxNumber!='' && (searchOnPatientName==null || searchOnPatientName=='')){
            for(VSPR9_OrderSummariesWrapper obj:lstOrderSummaryDetails){
                String temp = obj.rxNumber.ToLowerCase();
                if(temp.contains(searchOnRxNumber)){
                    lst.add(obj);
                }
        }
        lstOrderSummaryDetails = lst;
        }
        else if(searchOnRxNumber!=null && searchOnRxNumber!='' && (searchOnPatientName!=null && searchOnPatientName!='')){
            for(VSPR9_OrderSummariesWrapper obj:lstOrderSummaryDetails){
                String rxnumber = obj.rxNumber.ToLowerCase();
                String patientname = obj.patientName.ToLowerCase();
                if(rxnumber.contains(searchOnRxNumber) && patientname.contains(searchOnPatientName)){
                    lst.add(obj);
                }
            }
            lstOrderSummaryDetails = lst;
        }
        else{
            getAccountOrderSummaryDetails();
        }
    } 
    
    // this method is executed when searched on account number, patient name, rx number and invoice number and clicked on search button on order summaries page 
    public void getorderDetails(){ 
        String orderDetailsQueryParams = '';
        if(searchOnRxNumber != null && !searchOnRxNumber.equalsIgnoreCase('')){
            searchOnRxNumber = searchOnRxNumber.trim();
            searchOnRxNumber = searchOnRxNumber.replaceAll('(\\s+)', ' ');
            orderDetailsQueryParams = orderDetailsQueryParams + '&rx=' + searchOnRxNumber ;
        } 
        if(searchOnPatientName != null && !searchOnPatientName.equalsIgnoreCase('')){
        
            if(searchOnPatientName.length() > 2){
                searchOnPatientName = searchOnPatientName.trim();
                searchOnPatientName = searchOnPatientName.replaceAll('(\\s+)', ' ');
                orderDetailsQueryParams = orderDetailsQueryParams + '&patient=' + searchOnPatientName;
            }
            else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must supply at least 3 characters to search by patient name. If the patient last name is only 2 characters long, please add a comma to the end of the patient name. (ex. va,).'));
            }
        }
        if(searchOnInvoiceNumber != null && !searchOnInvoiceNumber.equalsIgnoreCase('')){
            searchOnInvoiceNumber = searchOnInvoiceNumber.trim();
            searchOnInvoiceNumber = searchOnInvoiceNumber.replaceAll('(\\s+)', ' ');
            orderDetailsQueryParams = orderDetailsQueryParams + '&invoice=' + searchOnInvoiceNumber ;
        }

        //URL for the Order Summaries Web Service goes here
        setAccountNumberValue();
        if(accountNumber!=null){
            accountNumber = accountNumber.trim();
            accountNumber = accountNumber.replaceAll('(\\s+)', ' ');
        }
        
        system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&  accountNumber &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +accountNumber);
        
        String orderDetailsEndPoint = webServiceURL + '/lab-vsponelensordersapi-web/labaccounts?account='+ accountNumber.replaceAll('^0+(?!$)', '') + orderDetailsQueryParams;
    
        system.debug('--------INISDE search method----'+orderDetailsEndPoint);
    
        HttpRequest labReq = new HttpRequest();  
        labReq.setEndpoint(orderDetailsEndPoint); 
        labReq.setMethod('GET');
            
        String access_token = getAccessToken();
             
        labReq.setHeader('Accept','application/json;version='+webServiceVersion);

        String labHeaders = 'Bearer ' + access_token; 
        labReq.setHeader('Authorization', labHeaders); 
        List<Object> labOrders = new List<Object>(); 

        Http labHttp = new Http(); 
        HTTPResponse labResp;
        if(!Test.isRunningTest()){
            try{
                labReq.setTimeout(2 * 60 * 1000);
                labResp = new HttpResponse();
                labResp = labHttp.send(labReq);
           }catch(CalloutException ex){
                serviceException = 'Error';
                labResp = null;
                HandleException(ex);
            } 
            }else{
                labResp = AccountOrderSummaryTest_Helper.labAccountResponse();
            }
        
            List<Object> lstShipMethods = new List<Object>();
            lstShippingMethodDetails = new List<VSPR9_ShippingMethodDetailsWrapper>();
            //System.debug('-------------INISDE search method--------------body-----------------------'+labResp.getBody());
            
            try{
                if(labResp !=null && labResp.getBody()!=null && !labResp.getBody().equalsIgnoreCase('')){
                    deserializeMap = (Map<String,Object>)JSON.deserializeUntyped(labResp.getBody());
                    system.debug('--------orders--------'+deserializeMap);
                    if(deserializeMap!=null && deserializeMap.size()>0){
                        Map<String,Object> labAccountDetails=(Map<String,Object>)deserializeMap.get('labAccount');
                        system.debug('--------------INISDE search method-----------------------------------------vsponeLensOrders----------------------------------------------------------'+(Map<String,Object>)deserializeMap.get('vsponeLensOrders'));
                   
                        lstShipMethods = (List<Object>)deserializeMap.get('shipMethods');
                        if(lstShipMethods != null && lstShipMethods.size() > 0){
                            for(object obj:lstShipMethods){
                                String strJsonNew = JSON.serialize(obj);
                                VSPR9_ShippingMethodDetailsWrapper shipObj = (VSPR9_ShippingMethodDetailsWrapper)JSON.deserialize(strJsonNew, VSPR9_ShippingMethodDetailsWrapper.class);
                                lstShippingMethodDetails.add(shipObj);
                            }
                        }
                        system.debug('-----------------------------------------------------lstShippingMethodDetails----------------------------------------------------------'+lstShippingMethodDetails);
                        Map<String,Object> laborderURLMap =  (Map<String,Object>)deserializeMap.get('vsponeLensOrders');
                        if(laborderURLMap!=null && laborderURLMap.size()>0){
                            strLabOrdersURL = (String)laborderURLMap.get('href');
                        }else{
                            strLabOrdersURL = null;
                        }
                    }
                }
            }catch(Exception e){
                serviceException = 'ABCD';
                HandleException(e);  
            }
            system.debug('-----------------------------INISDE search method--------------------------strLabOrdersURL-------------------------------'+strLabOrdersURL);
        
            setAccountNumberValue();
            //system.debug('----------------------------------------OPTIC KEY IS -------------------------------------------------------------------'+accountNumber);
    
            //URL for the Order Summaries Web Service goes here
            orderDetailsEndPoint = strLabOrdersURL; 
            
            system.debug('-----------orderDetailsEndPoint fetch------------------------------------------------------'+orderDetailsEndPoint );
            List<VSPR9_OrderSummariesWrapper> orderDetails = fetchAccountOrderDetails(orderDetailsEndPoint);
            system.debug('-----------orderDetailsFetch ------------------------------------------------------'+orderDetails );
                    
            //system.debug('################################################################## orderDetails ' + orderDetails); 
            nextPosition = 0;
            previousPosition = 0;
            intOffsetMapKey = 0;
            mapOffset = new Map<Integer,String>(); 
                                             
            nextAge = 0;
            previousAge = 0;
            intAgeSetMapKey = 0;
            ageMap = new Map<Integer,String>(); 
                                             
            if(lstOrderSummaryDetails.size()>0){
                processTheRecords();
                disablePrevious = true;
                disableNext = false;
                nextPosition = mapOffset.size();
                previousPosition = nextPosition-1;
                nextAge = ageMap.size();
                previousAge = nextAge-1;
                if(lstOrderSummaryDetails.size() < 20)
                    disableNext = true;
                showDataTable = true;
                mainErrorMEssage = false;
            }else{
                showDataTable = false;
                disablePrevious = true;
                disableNext = true;
            } 
        
            sortDirection = 'DESC'; 
            sortExp = 'invoicenumber';
        
            system.debug('-----mapOffset---FIRSTTIME-----'+mapOffset);
            system.debug('-----mapOffset---FIRSTTIME--SIZE---'+mapOffset.size());
            system.debug('-----nextPosition---FIRSTTIME-----'+nextPosition); 
            system.debug('-----previousPosition---FIRSTTIME-----'+previousPosition); 
    }    
    
    // This method is used to clear the values in serch fields patient name, rx number and invoice number 
    public void clearSearchDetails(){
        searchOnRxNumber = '';
        searchOnPatientName = '';
        searchOnInvoiceNumber = '';
        getOrderDetails();
                    
        sortDirection = 'DESC';        
        sortExp = 'invoicenumber';
    }
    
    // Wrapper class for Order History data
    public class VSPR9_OrderHistoryWrapper {
        public String labOrderNumber{get;set;}
        public String labInvoice{get;set;}
        public String labNID{get;set;}
        public String labName{get;set;}
        public String labOrderStatus{get;set;}         
        public List<Stations> labStations{get;set;}
    }
        
    public class Stations{
        public String statusDate{get;set;}
        public String status{get;set;}
        public String labName{get;set;}            
    }
    
    public List<VSPR9_OrderDetailWrapper> lstOrderDetailInformation{get;set;}
    public List<String> lensOrderHistoryURLLst{get;set;}
    public List<String> lensOrderNotesURLLst{get;set;}
    public List<VSPR9_OrderHistoryWrapper> vsponeLensOrderHistorylist{get;set;}
    public List<VSPR9_OrderNotesWrapper> vsponeLensOrderNotesList{get;set;}
    public List<Stations> stationList{get;set;}
        
       
    public String strLabName{get;set;}
    public String strStatusDate{get;set;}
    public String strStatus{get;set;}
        
    public String strFrameStatus{get;set;}
    public String strLensSelected{get;set;}
    public String strRedoDescription{get;set;} 
    public boolean displayPopup {get; set;}     
    public boolean disableSubmitRedo{get;set;} 
   
    public String strRedoSubmitTime{get;set;}
   
    public List<SelectOption> getFrameStatusValues(){
        List<SelectOption> temp = new List<SelectOption>();
        temp.add(new SelectOption('',''));
        temp.add(new SelectOption('Lenses Only','Lenses Only'));
        temp.add(new SelectOption('Frame to Come','Frame to Come'));
        temp.add(new SelectOption('Uncut','Uncut'));
        return temp;
    }
    
    public List<SelectOption> getLensValues(){
        List<SelectOption> temp = new List<SelectOption>();
        temp.add(new SelectOption('Both Lenses','Both Lenses'));
        temp.add(new SelectOption('Right Only','Right Only'));
        temp.add(new SelectOption('Left Only','Left Only'));
        return temp;
    }
   
    public void closePopup() {        
        displayPopup = false;    
    }     
    
    public void showPopup() { 
        if(strFrameStatus==null || strFrameStatus==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Edge / Frame Status'));
        }else if(strLensSelected==null || strLensSelected==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select Lenses'));
        }else if(strRedoDescription==null || strRedoDescription==''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter description '));
        }else if(strRedoDescription!=null && strRedoDescription!='' && strRedoDescription.length()>100){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Description should not be more than 100 chanracters '));
        }else{
            displayPopup = true;
        }    
    }
    
    public String redoStatus{get;set;}
    public String redoDescription{get;set;}
    public String redoEdge{get;set;}
    public String redoFrameStatus{get;set;}
    public String redoEyes{get;set;}
    
    
    public String strCode{get;set;}
    public String strEdge{get;set;}
    public String strFrameStatusVal{get;set;}
    public String strEyes{get;set;}
    public String strGUID{get;set;}
    public String strOrderNumber{get;set;}
    
    public String strAccountNumber{get;set;}
    public String strInvoiceNumber{get;set;}
    public String strlabNID{get;set;}
    
    public String strEdgeFrameStatusInfo{get;set;}
    public String strLenses{get;set;}
    
    
    // This method is for REDO functionality 
    public void submitRedoDetails(){
        displayPopup = false;   
        redoSubmission = true;
                
        //String strGUID,strOrderNumber;
        //String strEdge,strFrameStatusVal,strEyes;
        strCode = DVIWebService__c.getInstance('DVI Values').Redo_Code__c;
        
        system.debug('--------------- REDO CODE -----------------------------'+strCode);
                
        if(lstOrderDetailInformation!=null && lstOrderDetailInformation.size()>0){
            strGUID = lstOrderDetailInformation.get(0).guid;
            strOrderNumber = lstOrderDetailInformation.get(0).orderNumber;
            strAccountNumber = lstOrderDetailInformation.get(0).accountNumber;
            strInvoiceNumber = lstOrderDetailInformation.get(0).invoiceNumber;
            strlabNID = lstOrderDetailInformation.get(0).labNID;
        }
                
        Datetime dt = Datetime.now();
        String orderDate = dt.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');
                
        system.debug('---------------- orderDate   -----------------------'+orderDate);
                
        if(strFrameStatus!=null && strFrameStatus!=''){
            if(strFrameStatus.equalsIgnoreCase('Lenses Only')){
                strEdge = 'N';
                strFrameStatusVal = 'L';
                strEdgeFrameStatusInfo = 'Lenses Only';
            }
            if(strFrameStatus.equalsIgnoreCase('Frame to Come')){
                strEdge = 'E';
                strFrameStatusVal = 'N';
                strEdgeFrameStatusInfo = 'Frame to Come';
            }
            if(strFrameStatus.equalsIgnoreCase('Uncut')){
                strEdge = 'U';
                strFrameStatusVal = 'L';
                strEdgeFrameStatusInfo = 'Uncut';
            }
        }
        if(strLensSelected!=null && strLensSelected!=''){
            if(strLensSelected.equalsIgnoreCase('Both Lenses')){
                strEyes = 'B';
                strLenses = 'Both Lenses';
            }
            if(strLensSelected.equalsIgnoreCase('Right Only')){
                strEyes = 'R';
                strLenses = 'Right Only';
            }
            if(strLensSelected.equalsIgnoreCase('Left Only')){
                strEyes = 'L';
                strLenses = 'Left Only';
            }
        }
        system.debug('---------------strGUID-----------'+strGUID);
        system.debug('---------------strOrderNumber-----------'+strOrderNumber);
        system.debug('---------------strRedoDescription-----------'+strRedoDescription);
        system.debug('---------------orderDate-----------'+orderDate);
        system.debug('---------------strEdge-----------'+strEdge);
        system.debug('---------------strFrameStatusVal-----------'+strFrameStatusVal);
        system.debug('---------------strEyes-----------'+strEyes);
        system.debug('---------------strCode-----------'+strCode);
        
        
        JSONGenerator generator = JSON.createGenerator(true);  
        generator.writeStartObject();    
        
        if(strAccountNumber != null && strAccountNumber != '')
        generator.writeStringField('accountNumber', strAccountNumber);
        if(strInvoiceNumber != null && strInvoiceNumber != '')
        generator.writeStringField('invoiceNumber', strInvoiceNumber);
        if(strlabNID != null && strlabNID != '')
        generator.writeStringField('labNID', strlabNID);
          
        generator.writeStringField('orderNumber', strOrderNumber);   
        generator.writeStringField('jobGUID', strGUID);   
        generator.writeStringField('notes', strRedoDescription);   
        generator.writeStringField('orderDate', orderDate);     
                
        generator.writeFieldName('warranty');
        generator.writeStartObject();     
        generator.writeObjectField('code', strCode); 
        generator.writeObjectField('edge', strEdge); 
        generator.writeObjectField('frameStatus', strFrameStatusVal); 
        generator.writeObjectField('eyes', strEyes); 
        generator.writeEndObject();
                
        generator.writeEndObject();    
        
        String strBody = generator.getAsString();

        system.debug('---------------strBody-----------'+strBody);
                
        String token = getAccessToken();
        HttpResponse response;
                
        Http http = new Http();
        HttpRequest request = new HttpRequest();
                
        String redoHeader = 'Bearer ' + token;
        String redoURL = webServiceURL + '/lab-vsponelensordersapi-web/vsponelensorderredo';
                
        request.setHeader('Authorization', redoHeader);
        request.setHeader('Accept', 'application/json;version='+webServiceVersion);
        request.setHeader('Content-Type', 'application/json');
                
        request.setEndpoint(redoURL);
        request.setMethod('POST');
        request.setBody(strBody);
        
        request.setTimeout(2 * 60 * 1000);
        
        if(!Test.isRunningTest()){
            try{
                response = new HttpResponse();
                response = http.send(request);
            }catch(Exception e){
               serviceException = 'Error';
                response = null;
                HandleException(e);
            } 
        }else{
            response = AccountOrderSummaryTest_Helper.redoResponse();
        }
        
        String redoResp;
        
        if(response != null){
            redoResp = response.getBody(); 
        }
        system.debug('************* redoResp  ***********'+redoResp );
        
        /*
        String redoResp = '{'+
            '    \"orderNumber\": \"764572730\",'+
            '    \"jobGUID\": \"2CF5C689-368D-4430-B20F-3E61F8312EE6\",'+
            '    \"notes\": \"AR Warranty Lens Only Jane Doe JP\",'+
            '    \"requestedGUID\": \"2669ee34-ab1a-48ba-a5e3-62d5bab3fd43\",'+
            '    \"orderDate\": \"2015-05-07\",'+
            '    \"warranty\": {'+
            '        \"code\": \"REDO\",'+
            '        \"edge\": \"E\",'+
            '        \"frameStatus\": \"N\",'+
            '        \"eyes\": \"B\"'+
            '    },'+
            '    \"status\": \"Unresolved\",'+
            '    \"description\": \"REDO completed\"'+
            '}';
        */
        try{
            if(redoResp != null && !redoResp.equalsIgnoreCase('')){
                Map<String, Object> mapDeserializeData = (Map<String, Object>)JSON.deserializeUntyped(redoResp);
                System.debug('-------mapDeserializeData------'+mapDeserializeData);
                         
                if(mapDeserializeData!=null && mapDeserializeData.size()>0){
                    redoStatus = (String)mapDeserializeData.get('status');
                    if(redoStatus == null){
                        redoStatus = '';
                    }
                    
                    if(redoStatus.equalsIgnoreCase('Unresolved')){
                        redoStatus = 'Submitted';
                    }
                    
                    if(redoStatus.equalsIgnoreCase('success')){
                        redoStatus = 'Submitted';
                    }
                    
                    if(redoStatus.equalsIgnoreCase('Failure')){
                        redoStatus = 'Failed';
                        strEdgeFrameStatusInfo = '';
                        strLenses = '';
                    }
                    
                    system.debug('****************** redoStatus *****************************'+ redoStatus);
                      
                    redodescription = (String)mapDeserializeData.get('description');
                    system.debug('***************** redodescription **************************' + redodescription);
                      
                    Map<String, Object> mapDeserializeData2 = (Map<String, Object>)mapDeserializeData.get('warranty');
                    if(mapDeserializeData2!=null && mapDeserializeData2.size()>0){
                        redoEdge = (String)mapDeserializeData2.get('edge');
                        redoFrameStatus = (String)mapDeserializeData2.get('frameStatus');
                        redoEyes = (String)mapDeserializeData2.get('eyes');
                        if(redoEdge == null || redoFrameStatus == null || redoEyes == null){
                            redoEdge = '';
                            redoFrameStatus = '';
                            redoEyes = '';
                        }  
                    }                  
                }
            }
        }catch(Exception e){
            serviceException = 'ABCD';
            HandleException(e);  
        }   
        
        getOrderHistory();
        
        disableSubmitRedo = true;
        strFrameStatus='';
        strLensSelected = '';
        strRedoDescription = '';  
    }
    
    //This method displays the lab order detail data
    public void getOrderHistory(){
           
        disableSubmitRedo = false;
        
        String urlvalue = ApexPages.currentPage().getParameters().get('url');
        if(urlvalue!=null && urlvalue!=''){
            String[] strArray = urlvalue.split('account=',urlvalue.length());
            accountNumber = strArray[1].substring(0,strArray[1].indexof('&'));
        }
        
        Integer opticKeyLength;
        if(accountNumber!=null)
            opticKeyLength = accountNumber.length();
        String strTemp = '';
        for(Integer i=0;i<10-opticKeyLength;i++){
            strTemp = strTemp+'0';
        }
        String strAccountNumber = strTemp+accountNumber;
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' and Name='Business Account' LIMIT 1];
        system.debug('------------RT-------------'+rt);
        
        accountId = null; 
        if(rt!=null){
             for(Account obj:[Select Id,Optics_Key__c from Account where (Optics_Key__c!=null and  Optics_Key__c!='' and Optics_key__c like :('%' + strAccountNumber + '%')) and RecordTypeId=:rt.Id]){
                
                system.debug('!!!!!!!!!!!!!!!!!!!!!!! ORDER HISTORY - OPTIC KEY !!!!!!!!!!!!!!!!!!!!!!!!!!' +obj.Optics_Key__c);
                List<String> opticKeys = obj.Optics_Key__c.split(', ');
                system.debug('!!!!!!!!!!! ORDER HISTORY - opticKeys !!!!!!!!!!!!!!!!!!!!!' +opticKeys);
                for(String str : opticKeys){
                    if(str.equals(strAccountNumber))
                        accountId = obj.Id;
                }
            }      
            system.debug('-----------accountId -------'+accountId);
        }
        system.debug('--------accountNumber------'+accountNumber);
                 
        String access_token = getAccessToken();
        String labHeaders = 'Bearer ' + access_token; 
                
        HttpRequest labReq = new HttpRequest();        
        labReq.setEndpoint(urlvalue);
        labReq.setMethod('GET');
        labReq.setHeader('Accept','application/json;version='+webServiceVersion);        
        labReq.setHeader('Authorization', labHeaders); 
        labReq.setTimeout(2 * 60 * 1000);
        Http labHttp = new Http(); 
        HTTPResponse labResp;
        if(!Test.isRunningTest()){
            try{
                labResp = new HTTPResponse();
                labResp = labHttp.send(labReq);
            }catch(CalloutException e){
               serviceException = 'Error';
                labResp = null;
                HandleException(e);
            } 
        }else{
            labResp = AccountOrderSummaryTest_Helper.vsponeLensOrderDetailResponse();
        }
        
        lstOrderDetailInformation = new List<VSPR9_OrderDetailWrapper>();
        lensOrderHistoryURLLst = new List<String>();
        lensOrderNotesURLLst = new List<String>();
        
        try{
            if(labResp!=null){
                String historyResp = labResp.getBody();
                System.debug('-------historyResp ------'+historyResp );
                if( historyResp != null && !historyResp.equalsIgnoreCase('') ){
        
                    Map<String, Object> mapDeserializeHistoryData = (Map<String, Object>)JSON.deserializeUntyped(labResp.getBody());
                    System.debug('-------mapDeserializeHistoryData------'+mapDeserializeHistoryData);
                        
                    List<Object> vsponeLensOrderDetail = (List<Object>)mapDeserializeHistoryData.get('vsponeLensOrderDetail');   
                    system.debug('--------vsponeLensOrderDetail---------'+vsponeLensOrderDetail);
                    
                    if(vsponeLensOrderDetail != null && vsponeLensOrderDetail.size() > 0){
                        for(Object obj : vsponeLensOrderDetail){
                            String strLensOrderJson = JSON.serialize(obj);             
                            VSPR9_OrderDetailWrapper lensOrderObj = (VSPR9_OrderDetailWrapper)JSON.deserialize(strLensOrderJson, VSPR9_OrderDetailWrapper.class);
                             
                            lensOrderHistoryURLLst.add(lensOrderObj.vsponeLensOrderHistory.href);
                            lensOrderNotesURLLst.add(lensOrderObj.vsponeLensOrderNotes.href);
                             
                            system.debug('********************** lensOrderObj  ******************************'+lensOrderObj);
                              
                            system.debug('********************** lensOrderHistoryURLLst  ******************************'+lensOrderHistoryURLLst);
                            system.debug('********************** lensOrderNotesURLLst    ******************************'+lensOrderNotesURLLst);
                             
                            strLabName = lensOrderObj.labName;
                            strStatusDate = lensOrderObj.dateAtStation;
                            strStatus = lensOrderObj.labStationStatus;
                            
                            
                            if(lensOrderObj.redoSubmitTime != null && !lensOrderObj.redoSubmitTime.equalsIgnoreCase('')){
                                strRedoSubmitTime = lensOrderObj.redoSubmitTime;
                                disableSubmitRedo = true;
                            }else{
                                strRedoSubmitTime = '';
                            }
                            
                            if(strRedoSubmitTime != null && strRedoSubmitTime != ''){
                                strRedoSubmitTime = (strRedoSubmitTime).substring(0,10) + ' ' + (strRedoSubmitTime).substring(11,19);
                            }
                            
                            system.debug('++++++++++++++++++ strRedoSubmitTime ++++++++++++++++++++++++++++++++++++++++++++' +strRedoSubmitTime);
                             
                            String strActualShipDate;
                            String strEstShipDate = lensOrderObj.estimatedShipDate;                  
                            String strStation = lensOrderObj.labStationStatus; 
                             
                            if(strEstShipDate!=null && !strEstShipDate.equalsIgnoreCase('') && strActualShipDate!=null && !strActualShipDate.equalsIgnoreCase('')){
                                lensOrderObj.estimatedShipDate = ''; 
                            }
                            
                            String strUpdatedEstShipDate = lensOrderObj.estimatedShipDate; 
                            if( strUpdatedEstShipDate != null && !strUpdatedEstShipDate.equalsIgnoreCase('') ){ 
                                Date estShipDate = Date.valueOf(strUpdatedEstShipDate); 
                                if(estShipDate < Date.today()){
                                    lensOrderObj.estimatedShipDate = 'Contact VSPOne Lab'; 
                                }
                            }
                            
                            if(strStation != null && !strStation.equalsIgnoreCase('')){
                                if(strStation.equalsIgnoreCase('CUSTOMER SERVICE')){
                                    lensOrderObj.estimatedShipDate = 'Contact VSPOne Lab'; 
                                }
                            }
                            
                            if(strStation!=null && strStation!='' && (strStation.equalsIgnoreCase('SHIPPED')) && (String.isBlank(strActualShipDate))){
                                lensOrderObj.estimatedShipDate = '';
                                lensOrderObj.actualShipDate = lensOrderObj.dateAtStation;
                            }
                            
                            strActualShipDate = lensOrderObj.actualShipDate;
                            
                            if(strActualShipDate == null || strActualShipDate.equalsIgnoreCase('')){
                                disableSubmitRedo = true;
                            }         
                            
                            if(lensOrderObj.safetyFrameIndicator != null && lensOrderObj.safetyFrameIndicator.equals('0')){
                                lensOrderObj.safetyFrameIndicator = 'No';
                            }
                            else if(lensOrderObj.safetyFrameIndicator != null && lensOrderObj.safetyFrameIndicator.equals('1')){
                                lensOrderObj.safetyFrameIndicator = 'Yes';
                            }
                            
                            if(lensOrderObj.surfaceIndicator != null && lensOrderObj.surfaceIndicator.equals('0')){
                                lensOrderObj.surfaceIndicator= 'No';
                            }
                            else if(lensOrderObj.surfaceIndicator != null && lensOrderObj.surfaceIndicator.equals('1')){
                                lensOrderObj.surfaceIndicator = 'Yes';
                            }
                                                     
                            if(lensOrderObj.coatingIndicator!= null && lensOrderObj.coatingIndicator.equals('0')){
                                lensOrderObj.coatingIndicator = 'No';
                            }
                            else if(lensOrderObj.coatingIndicator!= null && lensOrderObj.coatingIndicator.equals('1')){
                                lensOrderObj.coatingIndicator = 'Yes';
                            }
                             
                            if(lensOrderObj.finishIndicator!= null && lensOrderObj.finishIndicator.equals('0')){
                                lensOrderObj.finishIndicator = 'No';
                            }
                            else if(lensOrderObj.finishIndicator!= null && lensOrderObj.finishIndicator.equals('1')){
                                lensOrderObj.finishIndicator = 'Yes';
                            }
                                                     
                            if(lensOrderObj.digitalLensIndicator != null && lensOrderObj.digitalLensIndicator.equals('0')){
                                lensOrderObj.digitalLensIndicator = 'No';
                            }
                            else if(lensOrderObj.digitalLensIndicator != null && lensOrderObj.digitalLensIndicator.equals('1')){
                                lensOrderObj.digitalLensIndicator = 'Yes';
                            }
                                                     
                            if(lensOrderObj.subContractType != null && lensOrderObj.subContractType.equals('0')){
                                lensOrderObj.subContractType = 'No';
                            }
                            else if(lensOrderObj.subContractType != null && lensOrderObj.subContractType.equals('1')){
                                lensOrderObj.subContractType = 'Yes';
                            }                       
                             
                            system.debug('-----------lensOrderObj ---------'+lensOrderObj);
                            lstOrderDetailInformation.add(lensOrderObj);
                             
                        }
                        system.debug('@@@@@@@@@@@@@@@@@@@@@@@@@@   lstOrderDetailInformation   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  '+lstOrderDetailInformation.size());       
                    }
                       
                }
                getLensOrderHistoryData(lensOrderHistoryURLLst);
                getLensOrderNotesData(lensOrderNotesURLLst);
            }
        }catch(Exception e){
            serviceException = 'ABCD';
            HandleException(e);  
        }
    } 
    
    // This method displays the Notes information
    public void getLensOrderNotesData(List<String> lensOrderNotesURLLst){
        
        vsponeLensOrderNotesList = new List<VSPR9_OrderNotesWrapper>();
       if(lensOrderNotesURLLst != null && lensOrderNotesURLLst.size() > 0){    
            for(String url : lensOrderNotesURLLst){
                String access_token = getAccessToken();
                                            
                String labHeaders = 'Bearer ' + access_token; 
                        
                HttpRequest labReq = new HttpRequest();        
                labReq.setEndpoint(url);
                labReq.setMethod('GET');
                labReq.setHeader('Accept','application/json;version='+webServiceVersion);        
                labReq.setHeader('Authorization', labHeaders); 
                labReq.setTimeout(2 * 60 * 1000); 
                Http labHttp = new Http(); 
                HTTPResponse labResp;
                if(!Test.isRunningTest()){
                    try{
                        labResp = new HTTPResponse();
                        labResp = labHttp.send(labReq); 
                    }catch(CalloutException ex){
                        serviceException = 'Error';
                        labResp = null;
                        HandleException(ex);
                    } 

                }else{
                    labResp = AccountOrderSummaryTest_Helper.vsponeLensOrderNotesResponse();
                }
                    
                String historyResp;
                if(labResp!=null)
                    historyResp = labResp.getBody();
                System.debug('-------historyResp ------'+historyResp );
                    
                /*
                String historyResp = '{'+
                    '    \"receivedDate\": \"2015-05-14\",'+
                    '    \"vsponeLensOrderNotes\": ['+
                    '        {'+
                    '            \"labNID\": \"33643\",'+
                    '            \"labName\": \"VSPOne San Diego\",'+
                    '            \"labNumber\": \"961\",'+
                    '            \"labInvoice\": \"461974\",'+
                    '            \"noteSeq\": \"2\",'+
                    '            \"jobNote\": \"Per Victor please add 1.0mm to top of B msmt/1.0mm to bottom of B msmt.  Seg. Ht. @21.0mm OU.\",'+
                    '            \"createdBy\": \"VC\",'+
                    '            \"jobNoteTS\": \"2015-05-14T16:19:00.000-07:00\"'+
                    '        },'+
                    '        {'+
                    '            \"labNID\": \"33643\",'+
                    '            \"labName\": \"VSPOne Dallas\",'+
                    '            \"labNumber\": \"961\",'+
                    '            \"labInvoice\": \"461974\",'+
                    '            \"noteSeq\": \"1\",'+
                    '            \"jobNote\": \"~ADD 2MM ALL AROUND - MODIFY SEG HT ACCORDING TO NEW LENS  \",'+
                    '            \"createdBy\": \"CB\",'+
                    '            \"jobNoteTS\": \"2015-05-14T15:54:00.000-07:00\"'+
                    '        }'+
                    '    ]'+
                    '}';
                */
                try{    
                    if( historyResp!= null && !historyResp.equalsIgnoreCase('') ){
                        Map<String, Object> mapDeserializeData = (Map<String, Object>)JSON.deserializeUntyped(historyResp);
                        System.debug('-------mapDeserializeData------'+mapDeserializeData);
                                            
                        if(mapDeserializeData!=null && mapDeserializeData.size()>0){
                            List<Object> vsponeLensOrderNotesDetails = (List<Object>)mapDeserializeData.get('vsponeLensOrderNotes');
                            system.debug('--------vsponeLensOrderNotesDetails -----------------------------------------------'+vsponeLensOrderNotesDetails);
                                                
                            if(vsponeLensOrderNotesDetails!=null && vsponeLensOrderNotesDetails.size()>0){
                                for(Object obj : vsponeLensOrderNotesDetails){
                                    String strJsonNew = JSON.serialize(obj);   
                                                    
                                    VSPR9_OrderNotesWrapper lensOrderObj = (VSPR9_OrderNotesWrapper)JSON.deserialize(strJsonNew, VSPR9_OrderNotesWrapper.class);
                                    system.debug('--------lensOrderObj-----------------------------------------------'+lensOrderObj); 
                                                    
                                    lensOrderObj.jobNoteTS = (lensOrderObj.jobNoteTS).substring(0,23);                                                 
                                    vsponeLensOrderNotesList.add(lensOrderObj);
                                }
                                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& vsponeLensOrderNotesList  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' + vsponeLensOrderNotesList);
                            }
                        }
                            
                    }
                }catch(Exception e){
                    serviceException = 'ABCD';
                    HandleException(e);  
                }
            }
        }
    }
    
    // This method displays the order history data
    public void getLensOrderHistoryData(List<String> lensOrderHistoryURLLst){
            
        vsponeLensOrderHistorylist = new List<VSPR9_OrderHistoryWrapper>();
        if(lensOrderHistoryURLLst != null && lensOrderHistoryURLLst.size() > 0){
            for(String url : lensOrderHistoryURLLst){
                String access_token = getAccessToken();
                                                
                String labHeaders = 'Bearer ' + access_token; 
                                
                HttpRequest labReq = new HttpRequest();        
                labReq.setEndpoint(url);
                labReq.setMethod('GET');
                labReq.setHeader('Accept','application/json;version='+webServiceVersion);        
                labReq.setHeader('Authorization', labHeaders); 
                labReq.setTimeout(2 * 60 * 1000);
                Http labHttp = new Http(); 
                HTTPResponse labResp;
                if(!Test.isRunningTest()){
                    labResp = new HTTPResponse();
                    try{
                        labResp = labHttp.send(labReq); 
                    }catch(CalloutException ex){
                        serviceException = 'Error';
                        labResp = null;
                        HandleException(ex);
                    } 
                }else{
                    labResp = AccountOrderSummaryTest_Helper.vsponeLensOrderHistoryResponse();
                }
                        
                String historyResp;
                if(labResp != null)
                    historyResp = labResp.getBody();
                System.debug('-------historyResp ------'+historyResp );
                
                /*
                String historyResp = '{'+
                    '    \"vsponeLensOrderHistory\": {'+
                    '        \"lensOrderLabHistory\": ['+
                    '            {'+
                    '                \"labOrderNumber\": \"764961226\",'+
                    '                \"labInvoice\": \"461974\",'+
                    '                \"labNID\": \"33643\",'+
                    '                \"labName\": \"VSPOne San Diego\",'+
                    '                \"labOrderStatus\": \"I\",'+
                    '                \"labStations\": ['+
                    '                    {'+
                    '                        \"statusDate\": \"2015-05-16\",'+
                    '                        \"status\": \"Coating\"'+
                    '                    },'+
                    '                    {'+
                    '                        \"statusDate\": \"2015-05-16\",'+
                    '                        \"status\": \"COATING\"'+
                    '                    },'+
                    '                    {'+
                    '                        \"statusDate\": \"2015-05-15\",'+
                    '                        \"status\": \"SURFACE\"'+
                    '                    },'+
                    '                    {'+
                    '                        \"statusDate\": \"2015-05-15\",'+
                    '                        \"status\": \"STOCK ROOM\"'+
                    '                    },'+
                    '                    {'+
                    '                        \"statusDate\": \"2015-05-15\",'+
                    '                        \"status\": \"ORDER ENTRY\"'+
                    '                    }'+
                    '                ]'+
                    '            }'+
                    '        ]'+
                    '    }'+
                    '}';
                */
                
                stationList = new List<Stations>();
                try{
                    if( historyResp!= null && !historyResp.equalsIgnoreCase('') ){
                        Map<String, Object> mapDeserializeData = (Map<String, Object>)JSON.deserializeUntyped(historyResp);
                        System.debug('-------mapDeserializeData------'+mapDeserializeData);
                                        
                        if(mapDeserializeData!=null && mapDeserializeData.size()>0){
                            Map<String, Object> mapDeserializeData2 = (Map<String, Object>)mapDeserializeData.get('vsponeLensOrderHistory');
                            system.debug('--------mapDeserializeData2 -----------------------------------------------'+mapDeserializeData2);
                                            
                            if(mapDeserializeData2!=null && mapDeserializeData2.size()>0){
                                List<Object> vsponeLensOrderHistoryDetails = (List<Object>)mapDeserializeData2.get('lensOrderLabHistory');
                                system.debug('--------vsponeLensOrderHistoryDetails-----------------------------------------------'+vsponeLensOrderHistoryDetails);
                                            
                                if(vsponeLensOrderHistoryDetails!=null && vsponeLensOrderHistoryDetails.size()>0){
                                    for(Object obj : vsponeLensOrderHistoryDetails){
                                        String strJsonNew = JSON.serialize(obj);   
                                                        
                                        VSPR9_OrderHistoryWrapper lensOrderObj = (VSPR9_OrderHistoryWrapper)JSON.deserialize(strJsonNew, VSPR9_OrderHistoryWrapper.class);
                                        system.debug('--------lensOrderObj-----------------------------------------------'+lensOrderObj);      
                                        vsponeLensOrderHistorylist.add(lensOrderObj);
                                    }
                                    
                                    for(VSPR9_OrderHistoryWrapper lensOrder : vsponeLensOrderHistorylist){
                                        system.debug('-------------------------------------------------------------------------------------------------------------------------');
                                        system.debug('----------------------------------------------------------------------------labOrderStatus: ' + lensOrder.labOrderStatus);
                                                                    
                                        for(Stations station : lensOrder.labStations){
                                            station.labName = lensOrder.labName;
                                            system.debug('----------------------------------------------------------------------------station: ' + station);
                                            
                                            station.statusDate = (station.statusDate).substring(0,10) + ' ' + (station.statusDate).substring(11,19);
                                              
                                            stationList.add(station);
                                        }
                                    }
                                }else{
                                    setDefaultSationListValues();
                                }
                            }else{
                                setDefaultSationListValues();
                            }
                        }else{
                            setDefaultSationListValues();
                        }
                    }
                    else{
                        setDefaultSationListValues();
                    }
                }catch(Exception e){
                    serviceException = 'ABCD';
                    HandleException(e);  
                }
            }
        }
    }
    
    // This method is executed when there are no results returned for order history data 
    public void setDefaultSationListValues(){
        stationList = new List<Stations>();
        Stations obj = new Stations();
                
        obj.labName = lstOrderDetailInformation.get(0).labName;
        obj.status = lstOrderDetailInformation.get(0).labStationStatus;
        obj.statusDate = lstOrderDetailInformation.get(0).dateAtStation;
                
        stationList.add(obj);
    }
    
}