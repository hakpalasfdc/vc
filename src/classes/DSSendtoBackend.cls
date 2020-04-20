public class DSSendtoBackend implements Queueable, Database.AllowsCallouts{
    ID UID;
    ID OBID;
    String phoneNum;
    Datetime callBackTime;
    //Integer priorityScore;
    //Integer groupNumber;
    
    public DSSendtoBackend(ID UID, ID OBID, String phoneNum, Datetime callBackTime /*Integer priorityScore, Integer groupNumber*/)
    {
        List<Contact_Role__c> CRs = new List<Contact_Role__c>([SELECT Id, Contact_Role_Phone__c  
                                                               FROM Contact_Role__c 
                                                               WHERE Id =: OBID]);
        For (Contact_Role__c CR : CRs)
        {
           phoneNum = CR.Contact_Role_Phone__c;
           system.debug('Phone # = ' + phoneNum);
        }
        this.UID = UID;
        this.OBID = OBID;
        this.phoneNum = phoneNum;
        system.debug('Phone # = ' + this.phoneNum);

        this.callBackTime = callBackTime;
        //this.priorityScore = priorityScore;
        //this.groupNumber = groupNumber;
    } 
    
    public static String validPhoneNum(String phoneNumber)
    {
        System.debug('validPhoneNumber- ' + phoneNumber);
        return phoneNumber.replaceAll('[^0-9]', '');
    }
    
   
    public void execute(QueueableContext context)
    {
        String httpBody = '';
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://devtest.refractivedialer.com/SubmitCallBack.php');
        req.setMethod('POST');
        req.setHeader('Connection', 'close');
        String struId = Id.valueOf(UID);
        String stroId = Id.valueOf(OBID);

        //if(groupNumber == 0)
        //{
         httpBody = 'sfdc_user_id=' + struId + '&id=' + stroId + '&number=' + validPhoneNum(phoneNum) + /*'&priority=' + priorityScore + '&group_id=' + '45'+*/ '&isGlobal=' + False + '&activate_time=' + callBackTime;
        //}
        //else{
            //httpBody = 'sfdc_user_id=' + struId + '&id=' + stroId + '&number=' + validPhoneNum(phoneNum) /*+ '&priority=' + priorityScore + '&group_id=' + groupNumber*/ +'&isGlobal=' + True + '&activate_time=' + callBackTime;
            //}
        req.setBody(httpBody);
        try{
            HttpResponse res = h.send(req);
            System.debug('response' + res.getBody() );
        }
        catch (Exception e){
            System.debug('error, in the exception now');
        }
    }
}