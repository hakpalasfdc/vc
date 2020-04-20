/*
* 2016 eightCloud + VSP
* 8/14/2018 Shravani Chigullapally - Updated code to handle Premier reports
* Apex client to interact with RESTify API
*
*
*/

global class RestifyClient_v2 {
    private static final RESTify_Settings__c apiSettings = RESTify_Settings__c.getInstance();
    private static final string HTTP_VERB = apiSettings.HTTP_VERB__c;
    private static final string END_POINT = apiSettings.END_POINT__c;
    private static final string PATH = apiSettings.PATH__c;
    private static final string ACCESS_KEY = apiSettings.ACCESS_KEY__c;
    private static final string SECRET_KEY = apiSettings.SECRET_KEY__c;

    //RESTify does not accept milliseconds, strip them out
    public static final string now = JSON.serialize(DateTime.now()).remove('"');
    public static final string TIME_STAMP = now.mid(0,now.length()-5)+'Z';
    public static String reportType;
    public static Integer acctIDSize;

    //webservice which will be invoked via toolkit API + javascript button
    webservice static String getReport(String AccountID) {
        reportType = AccountID;
        if(AccountID.contains('Practice')){
            acctIDSize = AccountID.length()-8;
        }
        if(AccountID.contains('Premier')){
            acctIDSize = AccountID.length()-7;
        }
        String acctID = AccountID.substring(0,acctIDSize);
        Practice_Report_Settings__c query = Practice_Report_Settings__c.getInstance();
        Map<String,String> parameterMap = new Map<String,String>(getParameterMap(acctID, query));
        return initiateCallout(parameterMap,acctID);
    }
        
    //private method to initiate callout to RESTify
    private static String initiateCallout(Map<String,String> parameterMap,String AccountID) {
        HTTP http = new HTTP();
        HTTPRequest req = new HTTPRequest();
        HTTPResponse res = new HTTPResponse();
        req.setEndpoint(END_POINT+PATH+'?' + generateEncodedParameters(parameterMap));
        req.setHeader('Authorization','bearer ' + ACCESS_KEY + ':' + generateSignature(parameterMap));
        req.setHeader('Content-type', 'application/json');
        req.setHeader('IBM-RESTify-Timestamp',TIME_STAMP);
        req.setHeader('IBM-RESTify-Tag','Salesforce');
        req.setHeader('Accept','application/pdf');
        req.setMethod('GET');
        req.setTimeout(120000);
        try {
            res = http.send(req);
            String headers = '';
            for(String key : res.getHeaderKeys()) {
                headers += '' + key + ':' + (key == null ? '' : res.getHeader(key)) + ', ';
            }
            system.debug(   ' HTTP Callout' + '\n'+'Request: ' + '\n' + req.toString() + '\n' +
            ' Response: ' + '\n' + res.toString() + '\n' +
            ' Headers: ' + '\n' + headers + '\n' +
            ' Response Body: ' + '\n' + res.getBody());
            if(res.getStatusCode() != 200) {
                return + 'HTTP_STATUS_CODE' + res.getStatusCode() + res.getBody();
            } else {
                return + 'HTTP_STATUS_CODE' + res.getStatusCode() + EncodingUtil.base64Encode(res.getBodyAsBlob());
            }
        } catch (Exception e) {
            return  ' HTTP Callout' + '\n'+'Request: ' + req.toString() + '\n' +
            ' Error: ' + String.valueOf(e);
        }
    }

    //helper method to generate parameter map
    private static Map<String,String> getParameterMap(String AccountID, Practice_Report_Settings__c settings) {
        Map<String,String> responseMap = new Map<String,String>();
        if(AccountID == '' || AccountID == ' ' || AccountID == null) {
            responseMap.put('Message 1', ' String AccountID cannot be null or blank!');
        }
        if(settings == null) {
            responseMap.put('Message 2', ' Practice_Report_Settings__c settings cannot be null!');
        }
        if(responseMap.size() > 0) {
                responseMap.put('Error', ' RestifyClient.getParameterMap(String AccountID, Practice_Report_Settings__c settings)');
                return responseMap;
        }
        try {
            Map<String,String> filters = new Map<String,String>(getFilters(settings));
            String taxID = [SELECT Id, Tax_ID__c FROM Account WHERE Id =: AccountID].Tax_ID__c;
            String recordTypeName = [SELECT Id, RecordType.Name FROM Account WHERE Id =: AccountID].RecordType.Name;
            String mdm_Combo_Key = ([SELECT Id, MDM_Combo_Key__c FROM Account WHERE Id =: AccountID].MDM_Combo_Key__c).leftPad(25,'0');
            String busAccRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Account' and Name='Business Account'].Id;
            String pracAccRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
            
            system.debug('++++++++++++++++++pracAccRecordTypeId+++++++++++++++++++++' +pracAccRecordTypeId);
            
            
            if(reportType.contains('Practice')){
                responseMap.put('folder','PRACTICEF');
                responseMap.put('selection','[{"field":"PRACTICEF","property":"PRACTICEF"}]');
                responseMap.put('filter','[{"field":"PRACTICEF","value":"'+taxID+filters.get('yq')+'","op":"eq"},{"field":"POSTING DATE","value":["'+filters.get('postingDate-from')+'","'+filters.get('postingDate-to')+'"],"op":"btw"}]');
            }
            if(reportType.contains('Premier') && recordTypeName == 'Business Account'){
                responseMap.put('folder','PREMIERO');
                responseMap.put('selection','[{"field":"PREMIERO","property":"SECTION ID"}]');
                responseMap.put('filter','[{"field":"SECTION ID","value":"'+taxID+mdm_Combo_Key+filters.get('yq')+'","op":"eq"},{"field":"POSTING DATE","value":["'+filters.get('postingDate-from')+'","'+filters.get('postingDate-to')+'"],"op":"btw"}]');
            }   
            if(reportType.contains('Premier') && recordTypeName == 'Practice Account'){
                system.debug('++++++++++++++++++recordType+++++++++++++++++++++');
                responseMap.put('folder','PREMIERV');
                responseMap.put('selection','[{"field":"PREMIERV","property":"SECTION ID"}]');
                responseMap.put('filter','[{"field":"SECTION ID","value":"'+taxID+filters.get('yq')+'","op":"eq"},{"field":"POSTING DATE","value":["'+filters.get('postingDate-from')+'","'+filters.get('postingDate-to')+'"],"op":"btw"}]');
            }           
                    
        } catch(QueryException e) {
            responseMap.put('Error', ' RestifyClient.getParameterMap(String AccountID, DateTime practiceReportDate)');
            responseMap.put('Message 1', 'Invalid AccountId "' + AccountID + '"... ' + String.valueOf(e));
        } catch(Exception e) {
            responseMap.put('Error', ' RestifyClient.getParameterMap(String AccountID, DateTime practiceReportDate)');
            responseMap.put('Message 1', String.valueOf(e));
        }
        return responseMap;
    }

    //helper method to create filters used in callout
    private static Map<String,String> getFilters(Practice_Report_Settings__c settings) {
        if(settings == null || settings.Posting_Date_From__c == null || settings.Posting_Date_To__c == null) {
            return new Map<String,String>{  'Error: ' => 'RestifyClient.getFilters(Practice_Report_Settings__c settings',
            'Message: '=> 'error, invalid practice report settings! Dates cannot be null!'};
        }
        Map<String,String> dateMapFROM = new Map<String,String>{'1'=>'0101','2'=>'0101','3'=>'0101','4'=>'0401','5'=>'0401','6'=>'0401','7'=>'0701','8'=>'0701','9'=>'0701','10'=>'1001','11'=>'1001','12'=>'1001'};
        Map<String,String> dateMapTO = new Map<String,String>{  '1'=>'0331','2'=>'0331','3'=>'0331','4'=>'0630','5'=>'0630','6'=>'0630','7'=>'0930','8'=>'0930','9'=>'0930','10'=>'1231','11'=>'1231','12'=>'1231'};
        return new Map<String,String>{  'postingDate-from'=>String.valueOf(settings.Posting_Date_From__c.year())+dateMapFROM.get(String.valueOf(settings.Posting_Date_From__c.month())),
        'postingDate-to'=>String.valueOf(settings.Posting_Date_To__c.year())+dateMapTO.get(String.valueOf(settings.Posting_Date_To__c.month())),
        'yq'=>'Y'+settings.Year__c+settings.Quarter__c};
    }

    //helper method to generate signature
    private static string generateSignature (Map<String,String> parameterMap) {
        string dataToSign = HTTP_VERB + '\n' + 
        END_POINT + '\n' + 
        PATH + '\n' + 
        generateEncodedParameters(parameterMap) + '\n' +
        ACCESS_KEY + '\n' + 
        TIME_STAMP;        
        dataToSign = dataToSign.replace('SECTION+ID','SECTION%20ID');                    
        System.debug(' CLIENT SIGN BLOCK' + '\n' + '=====================' + '\n' + dataToSign + '\n' + '=====================');
        //1. Use SHA256 to calculate the HMAC
        Blob HMAC_raw = Crypto.generateMac('HmacSHA256', Blob.valueOf(dataToSign), Blob.valueOf(SECRET_KEY));
        //2. Encode the HMAC using Base64 hash
        String HMAC_base64 = EncodingUtil.base64Encode(hmac_raw);
        //3. Remove any space, endline character at the end of the resulting sequence
        return HMAC_base64.removeEnd(' ');
    }

    //helper method to sort and generate encoded parameters (used in signature)
    private static String generateEncodedParameters(Map<String,String> parameterMap) {
        List<String> sortedKeys = new List<String>();
        String paramString = '';
        for(String key : parameterMap.keySet()) {
            sortedKeys.add(key);
        }
        sortedKeys.sort();
        for(Integer i=0; i<sortedKeys.size(); i++) {
            if(i+1 < sortedKeys.size()) {
                paramString += sortedKeys[i] + '=' + EncodingUtil.urlEncode(parameterMap.get(sortedKeys[i]), 'UTF-8') + '&';
            } else {
                paramString += sortedKeys[i] + '=' + EncodingUtil.urlEncode(parameterMap.get(sortedKeys[i]), 'UTF-8');
            }
        }
        //The SFDC EncodingUtil.urlEncode engine converts spaces into '+' but RESTify only accepts spaces encoded as '%20'
        return paramString.replace('POSTING+DATE','POSTING%20DATE');
    }
}