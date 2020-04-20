//Custom code to work with Stanford's InstaQueue List Button on Opps
global with sharing class DSAddToQueueVSP {
    WebService static String httpPOSTrecord(string urlParams, string phone, string name)
    {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        urlParams = urlParams + '&number='+phone.replaceAll('[^0-9]', '') + '&object_name='+name.replaceAll(' ', '%20');
        system.debug('Params: '+ urlParams);
        req.setMethod('POST');
        req.setHeader('Connection', 'close');
        req.setEndpoint(urlParams);
        String response = '';
        try{
            System.debug('Entered try catch'); 
            HttpResponse res = http.send(req);
            response = res.getBody();
            System.debug('response: ' + response);
        }
        catch(Exception e) {
        } 
        return response;
    }
    
    WebService static String httpPOSTlist(string phoneField, string nameField, string recordIDs, string objectType, string uid, string aid)
    {
        List<Id> contactRoleIds = new List<Id>(); 
        Map<Id, Id> acctsToCrIds = new Map<Id, Id>(); 
        Map<Id, Account> cRsToAccts = new Map<Id, Account>(); 
        Map<Id, Id> contactsToCrIds = new Map<Id, Id>(); 
        Map<Id, Contact> cRsToContact = new Map<Id, Contact>();
        
        System.debug('Fields: ' + phoneField + ':' + nameField + ':' + recordIDs + ':' + objectType + ':' + uid + ':' + aid);
        
        recordIDs = recordIDs.replace(',', '\',\'');
        List<sObject> objectList = Database.query('SELECT Id, '+ phoneField + ',' + nameField + ' FROM ' + objectType + ' WHERE id IN (\'' + recordIDs + '\')');
        System.debug('Object List: ' + objectList);
        
        for (sObject obj : objectList){
            Contact_Role__c copyObj = (Contact_Role__c)obj; 
            contactRoleIds.add(copyObj.Id); 
            acctsToCrIds.put(copyObj.Account__c, copyObj.Id); 
        }
        
        List<Account> accts = [SELECT Name FROM Account WHERE Id IN :acctsToCrIds.keySet()]; 
        
        System.debug('Accounts: ' + accts);
        
        for (Account acct : accts)
            cRsToAccts.put(acctsToCrIds.get(acct.Id), acct);  
        
        for (sObject obj : objectList){
            Contact_Role__c copyObj = (Contact_Role__c)obj; 
            contactRoleIds.add(copyObj.Id); 
            contactsToCrIds.put(copyObj.Contact__c, copyObj.Id); 
        }
        
        List<Contact> contacts = [SELECT Name FROM Contact WHERE Id IN :contactsToCrIds.keySet()]; 
        
        System.debug('Contacts: ' + contacts);
        
        for (Contact contact : contacts)
            cRsToContact.put(contactsToCrIds.get(contact.Id), contact);        
        
        List<DSAddToQueueVSP.recordInfo> records = new List<DSAddToQueueVSP.recordInfo>();
        
        for(sObject obj : objectList){
            //Convert sObject to allow us to access Account.Name
            System.debug('UID: ' + uid);
            System.debug('AID: ' + aid);
            Contact_Role__c copyObj = (Contact_Role__c)obj; 
            System.debug('Account: ' + cRsToAccts.get(copyObj.Id).Name);
            System.debug('Contact Role: ' + obj);
            System.debug('Phone: ' + copyObj.Contact_Role_Phone__c);
            System.debug('Entered'); 
            recordInfo record =  new recordInfo(uid, aid, ((String)obj.get(phoneField)).replaceAll('[^0-9]', ''), (String)obj.get('Id'), cRsToAccts.get(copyObj.Id).Name.replace('&', 'and') + ' : '
                                               + cRsToContact.get(copyObj.Id).Name.replace('&', 'and'));
            records.add(record);
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setHeader('Connection', 'close');
        /*Boolean devmode = [select DialSource__DialSource_Development_Mode__c from User where id = :UserInfo.getUserId()].DialSource__DialSource_Development_Mode__c;
        System.debug('devmode');
        System.debug(devmode);*/
        String url = '';
        /*if (devmode){
            url = 'https://websocket-dev-andrew.dialsource.com:8000/addToQueue';
        }
        else {*/
            url = 'https://ws.dialsource.com:8000/addToQueue';
        //}
        url = url + '?' + 'aid='+aid+'&uid='+uid+'&records='+JSON.serialize(records);
        url = url.replaceAll(' ', '%20');
        req.setEndpoint(url);
        System.debug('aid='+aid+'&uid='+uid+'&records='+JSON.serialize(records));
        //req.setBody('aid='+aid+'&uid='+uid+'&records='+JSON.serialize(records));
        System.debug(req);
        System.debug('records ' + JSON.serialize(records));
        String response = '';
        try{
            System.debug(req);
            HttpResponse res = http.send(req);
            System.debug(res);
            response = res.getBody();
            System.debug('response: ' + response);
        }
        catch(Exception e) {
        } 
        return response;
    }
    
    public class recordInfo
    {
        String uid;
        String aid;
        String object_id;
        String object_name;
        String phone_number;
        
        public recordInfo(String uid, String aid, String phone_number, string object_id, string object_name)
        {
            this.uid = uid;
            this.aid = aid;
            this.phone_number = phone_number;
            this.object_id = object_id;
            this.object_name = object_name;
        }
    }
}