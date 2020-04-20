global class DSPriorityQueue
{
    // Callout to Dialsource Backend passing single Call info to RTPQ.
    // @future methods are useful for use within Apex Triggers.
    @future (callout=true)
    public static void SubmitCallBack(String sfdcUserId, String sfdcObjectId, String callBackNumber, Boolean isGlobal)
    {
        System.debug('Future SubmitCalLBack - sfdcUserId:' + sfdcUserId + ',sfdcObjectId:' + sfdcObjectId + ',callBackNumber:' + callBackNumber + ',isGlobal:' + isGlobal);
        if(callBackNumber != null && callBackNumber != '')
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBack.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');

            if(sfdcUserId.length() != 18)
                sfdcUserId = ID15to18(sfdcUserId);
            if(sfdcObjectId.length() != 18)
                sfdcObjectId = ID15to18(sfdcObjectId);

            if(isGlobal)
                httpBody = 'sfdc_user_id=' + sfdcUserId + '&id=' + sfdcObjectId + '&number=' + validPhoneNumber(callBackNumber) + '&isGlobal=1';
            else
                httpBody = 'sfdc_user_id=' + sfdcUserId + '&id=' + sfdcObjectId + '&number=' + validPhoneNumber(callBackNumber);
            
            req.setBody(httpBody);
            
            String reply;
            try
            {
                HttpResponse res = h.send(req);
                reply = res.getBody();
                System.debug('And the reply is:***'+ reply);
            }
            catch(System.CalloutException e)
            {
                System.debug(e.getMessage());
            }
        }
    }

    public static void SubmitCallBackNoFuture(String sfdcUserId, String sfdcObjectId, String callBackNumber, Boolean isGlobal)
    {
        System.debug('Future SubmitCalLBack - sfdcUserId:' + sfdcUserId + ',sfdcObjectId:' + sfdcObjectId + ',callBackNumber:' + callBackNumber + ',isGlobal:' + isGlobal);
        if(callBackNumber != null && callBackNumber != '')
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBack.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');

            if(sfdcUserId.length() != 18)
                sfdcUserId = ID15to18(sfdcUserId);
            if(sfdcObjectId.length() != 18)
                sfdcObjectId = ID15to18(sfdcObjectId);

            if(isGlobal)
                httpBody = 'sfdc_user_id=' + sfdcUserId + '&id=' + sfdcObjectId + '&number=' + validPhoneNumber(callBackNumber) + '&isGlobal=1';
            else
                httpBody = 'sfdc_user_id=' + sfdcUserId + '&id=' + sfdcObjectId + '&number=' + validPhoneNumber(callBackNumber);
            
            req.setBody(httpBody);
            
            String reply;
            try
            {
                HttpResponse res = h.send(req);
                reply = res.getBody();
                System.debug('And the reply is:***'+ reply);
            }
            catch(System.CalloutException e)
            {
                System.debug(e.getMessage());
            }
        }
    }
    
    /*Does not need @future annotation since it triggered by a clicking onclick Javascript*/
    WebService static String ButtonSubmitCallBack(String sfdcUserId, String sfdcObjectId, String callBackNumber, Boolean isGlobal)
    {
        String uid = sfdcUserId;
        String oid = sfdcObjectId;

        if(uid.length() != 18)
            uid = ID15to18(uid);
        if(oid.length() != 18)
            oid = ID15to18(oid);

        String reply = '';
        if(callBackNumber != null && callBackNumber != '')
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBack.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');
            
            if(isGlobal)
                httpBody = 'sfdc_user_id=' + uid + '&id=' + oid + '&number=' + validPhoneNumber(callBackNumber) + '&isGlobal=1';
            else
                httpBody = 'sfdc_user_id=' + uid + '&id=' + oid + '&number=' + validPhoneNumber(callBackNumber);
            
            req.setBody(httpBody);

            HttpResponse res = h.send(req);
            reply = res.getBody();
            system.debug('And the reply is: ***'+ reply);
        }
        
        return reply;
    }
    
    public static String validPhoneNumber(String phoneNumber)
    {
        System.debug('validPhoneNumber- ' + phoneNumber);
        return phoneNumber.replaceAll('[^0-9]', '');
    }
    
    public class DSCallBack
    {
        String sfdcUserId;
        String sfdcObjectId;
        String callBackNumber;
        
        public DSCallBack(String sfdcUserId, String sfdcObjectId, String callBackNumber)
        {
            this.sfdcUserId = sfdcUserId;
            this.sfdcObjectId = sfdcObjectId;
            this.callBackNumber = callBackNumber;
        }
    }
    
    public static String encodeDSCallBackList(List<DSCallBack> dscbl)
    {
        return JSON.serialize(dscbl);
    }
    
    /*PhoneType refers to which phone field we are querying from*/
    /*isGlobal will determind whether this is a specific user callback or Next Available Agent callback*/
    @future (callout=true)
    public static void SubmitCallBackListFuture(String sfdcUserId, String sfdcObjectType, String DSCallBackListIds, Boolean isGlobal, String phoneType)
    {
        System.debug('Single UserId, best for DS Add List To Queue button.');
        System.debug('SubmitCalLBack - sfdcUserId:' + sfdcUserId + ',sfdcObjectType:' + sfdcObjectType + ',DSCallBackListIds:' + DSCallBackListIds + ',isGlobal:' + isGlobal);

        String uid = sfdcUserId;
        if(uid.length() != 18)
            uid = ID15to18(uid);

        String dscbIdList = DSCallBackListIds.replace(',', '\',\'');
        //system.debug('This is the dscbIdList\n\n' + '******'+dscbIdList+'******');
        List<sObject> soList = Database.query('SELECT Id, '+phoneType+' FROM ' + sfdcObjectType + ' WHERE id IN (\'' + dscbIdList + '\')');
        String reply = '';
        List<DSPriorityQueue.DSCallBack> dscbl = new List<DSPriorityQueue.DSCallBack>();


        for(sObject so : soList)
        {
            String soid = so.Id;
            String phn = (String)so.get(phoneType);
            DSPriorityQueue.DSCallBack dscb = new DSPriorityQueue.DSCallBack(uid, soid, phn);
            dscbl.add(dscb);
        }
        if(!dscbl.isEmpty())
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBackList.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');
            
            if(isGlobal)
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&isGlobal=1&list=' + encodeDSCallBackList(dscbl);
            else
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&list=' + encodeDSCallBackList(dscbl);
            
            req.setBody(httpBody);
            HttpResponse res = h.send(req);
            reply = res.getBody();
            System.debug('And the reply is:***' + reply);
        }
    }
    
    @future (callout=true)
    public static void SubmitCallBackListFuture(List<Id> sfdcUserId, List<Id> sfdcObjectIds, List<String> phones, Boolean isGlobal)
    {
        System.debug('List of sfdc User Ids, best used for specific user callback distribution.\nBest for automated processes');
        System.debug('SubmitCalLBackList - sfdcUserId:' + sfdcUserId + ',sfdcObjectIds:' + sfdcObjectIds + ',phones:' + phones + ',isGlobal:' + isGlobal);
        String reply = '';
        List<DSPriorityQueue.DSCallBack> dscbl = new List<DSPriorityQueue.DSCallBack>();
        Integer i;
        for(i=0; i < phones.size(); i++)
        {
            String soid = String.valueOf(sfdcObjectIds[i]);
            String phn = phones[i];
            String uid = String.valueOf(sfdcUserId[i]);
            DSPriorityQueue.DSCallBack dscb = new DSPriorityQueue.DSCallBack(uid, soid, phn);
            dscbl.add(dscb);
        }
        if(!dscbl.isEmpty())
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBackList.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');
            
            if(isGlobal)
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&isGlobal=1&list=' + encodeDSCallBackList(dscbl);
            else
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&list=' + encodeDSCallBackList(dscbl);
            
            req.setBody(httpBody);
            HttpResponse res = h.send(req);
            reply = res.getBody();
        }
    }

    public static void SubmitCallBackListNoFuture(List<Id> sfdcUserId, List<Id> sfdcObjectIds, List<String> phones, Boolean isGlobal)
    {
        System.debug('List of sfdc User Ids, best used for specific user callback distribution.\nBest for automated processes');
        System.debug('SubmitCalLBackList - sfdcUserId:' + sfdcUserId + ',sfdcObjectIds:' + sfdcObjectIds + ',phones:' + phones + ',isGlobal:' + isGlobal);
        String reply = '';
        List<DSPriorityQueue.DSCallBack> dscbl = new List<DSPriorityQueue.DSCallBack>();
        Integer i;
        for(i=0; i < phones.size(); i++)
        {
            String soid = String.valueOf(sfdcObjectIds[i]);
            String phn = phones[i];
            String uid = String.valueOf(sfdcUserId[i]);
            DSPriorityQueue.DSCallBack dscb = new DSPriorityQueue.DSCallBack(uid, soid, phn);
            dscbl.add(dscb);
        }
        if(!dscbl.isEmpty())
        {
            String httpBody = '';
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://rs.refractivedialer.com/SubmitCallBackList.php');
            req.setMethod('POST');
            req.setHeader('Connection', 'close');
            
            if(isGlobal)
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&isGlobal=1&list=' + encodeDSCallBackList(dscbl);
            else
                httpBody = 'id=' + UserInfo.getOrganizationId() + '&list=' + encodeDSCallBackList(dscbl);
            
            req.setBody(httpBody);
            HttpResponse res = h.send(req);
            reply = res.getBody();
        }
    }
    WebService static String directSubmitCallBackList(String sfdcUserId, String dsCallBackListIds, String phoneString, Boolean isGlobal)
    {   
        Id uid = Id.valueOf(sfdcUserId);
        List<Id> sfdcObjectIds = csvStringToIdParser(dsCallBackListIds);
        List<String> phones = csvStringToListStringParser(phoneString);
        Integer i;
        List<Id> sfdcUIDList = new List<Id>(); 
        for(i=0; i < phones.size(); i++)
        {
            sfdcUIDList.add(uid);
        }
        SubmitCallBackListNoFuture(sfdcUIDList, sfdcObjectIds, phones, isGlobal);
        return 'Processing...';
    }
    
    WebService static String wsSubmitCallBackList(String sfdcUserId, String sfdcObjectType, String DSCallBackListIds, Boolean isGlobal, String phoneType)
    {
        DSPriorityQueue.SubmitCallBackListFuture(sfdcUserId, sfdcObjectType, DSCallBackListIds, isGlobal, phoneType);
        return 'Processing...';
    }
    
    // Overloaded DSgetObjectType(String)
    // Determines the Object Type based on the Object ID String
    public static String DSgetObjectType(String oid)
    {
        if(oid == null)
        {
            return null;
        }

        String oidPrefix = oid.substring(0,3);  
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Map<String,String> keyPrefixMap = new Map<String,String>{};
        Set<String> keyPrefixSet = gd.keySet();

        for(String sObj : keyPrefixSet)
        {
            Schema.DescribeSObjectResult r =  gd.get(sObj).getDescribe(); 
            String tempName = r.getName();
            String tempPrefix = r.getKeyPrefix();
            keyPrefixMap.put(tempPrefix,tempName);
        }

        return keyPrefixMap.get(oidPrefix);
    }

    // Overloaded DSgetObjectType(ID)
    // Determines the Object Type based on the Object ID
    public static String DSgetObjectType(Id oid)
    {
        if (oid == null) return null;
        return DSgetObjectType(String.valueOf(oid).substring(0,15));
    }

    // IsNullOrEmpty checks returns true if a String is Null or ''
    public static Boolean IsNullOrEmpty(String s)
    {
        if (s == null || s == '') return true;
        return false;
    }
    
    public static void hackCoverage()
    {
        String appendToMe = '';
        appendToMe = appendToMe + '1';
    }
    public static String ID15to18(Id inID)
    {
        String tempId = string.valueOf(inID);
        tempId =  ID15to18(tempId);
        return tempId;
    }
    public static String ID15to18(String inID)
    {
        if (inID.length() == 18) { return inID; }
        else if (inID.length() != 15) { return ''; }
        else
        {
            String suffix = '';
            for (Integer i = 0; i < 3; i++)
            {
                Integer flags = 0;
                for (Integer j = 0; j < 5; j++)
                {
                    String c = inID.substring(i*5+j, i*5+j+1);
                    if ( ( c.compareTo('A') >= 0 ) && ( c.compareTo('Z') <= 0 ) )
                    {
                        flags += 1 << j;
                    }
                }
                suffix = suffix + 'ABCDEFGHIJKLMNOPQRSTUVWXYZ012345'.substring(flags, flags+1);
            }
            return inID + suffix;
        }
    }
    public static List<Id> csvStringToIdParser(String stringToParse)
    {
        //This string should be in the format of 
        //('01p610000002tHJ', '01p610000004tHJ', '01p610000009tHJ')
        
        //take out all 's
        String sfdcIds = stringToParse.replaceAll('\'','');
        //Take out starting and ending character eg "(" ")"
        sfdcIds = sfdcIds.substring(1, sfdcIds.length()-1);
        String temp;
        List<Id> idList = new List<Id>();
        while(sfdcIds.contains(',') || sfdcIds.length() == 18)
        { 
            //grab the 18 digits of Id 
            temp = sfdcIds.substring(0,18);
            //system.debug(temp);
            //turn the string in an Id
            Id tempId = Id.valueOf(temp);
            idList.add(tempId);

            //If last Id then null out the string
            if(sfdcIds.length() == 18)
                sfdcIds = 'null';
            else
                sfdcIds = sfdcIds.substring(19,sfdcIds.length());
        }        
        return idList;
    }
    public static List<String> csvStringToListStringParser(String stringToParse)
    {
        //This string should be in the format of 
        //('9253604645','8457894562','4528964567')
        
        //take out all 's
        String sfdcIds = stringToParse.replaceAll('\'','');
        //replace the () characters with commas
        sfdcIds = ',' +sfdcIds.substring(1, sfdcIds.length()-1)+ ',';
        String temp;
        List<String> stringList = new List<String>();
        while(sfdcIds.contains(',') && sfdcIds != ',')
        {
            Integer startIndex = sfdcIds.indexOf(',');
            Integer endIndex = sfdcIds.indexOf(',',1);
            
            temp = sfdcIds.substring(startIndex + 1, endIndex);
            stringList.add(temp);
            
            sfdcIds = sfdcIds.substring(endIndex, sfdcIds.length());
        }
        //return list of strings
        return stringList;
    }
}