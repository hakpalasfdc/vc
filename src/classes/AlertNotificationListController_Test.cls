@isTest
public class AlertNotificationListController_Test {
    
    @isTest
    private static void getAlertsTest(){
      	DVIWebService__c cs1 = new DVIWebService__c();
        cs1.name= 'DVI Values';
        cs1.DVI_Web_Service__c = 'https://api-staging.vspglobal.com';
        insert cs1;
        
        Account acc = new Account();
        acc.Name = 'test1';
        acc.Member_Status__c = 'Active';
        acc.Consumer__c = 'PrimaryMember';
        acc.Client_Id__c = '5678666';    
        //acc.Client_ID__pc = '1234';
        insert acc;
        
        Alerts_and_notification__c alert = new Alerts_and_notification__c();
        alert.Name = 'testing_alert';
        alert.Status__c='Published';
        insert alert;
        
        MemberPlan mp = new MemberPlan();
        mp.Name = 'primary member';
        mp.MemberId = acc.Id;
        mp.Division_ID__c ='1234';
        mp.Client_ID__c ='5678666';
            
        insert mp;
        
        Case cs = new Case();
        cs.AccountId = acc.Id;
        //cs.Alerts_and_Notifications__c = alert.Id;
        cs.Division__c = 'Onsite Clinics';
        cs.Member_Plan__c = mp.Id;
        
        insert cs;
    
        Alert_ID_Criteria__c alertClient = new Alert_ID_Criteria__c();
        alertClient.Alert__c = alert.Id;
        alertClient.DivisionID__c = '1234';
        alertClient.ClientID__c ='5678666';
        insert alertClient;
        System.debug('alertClient:'+alertClient);
    
    
        
        AlertNotificationListController.isAuthorUser();
        AlertNotificationListController.getAlertList(cs.Id);
        AlertNotificationListController.getClientAndDivisionIds(alert.Id);
        AlertNotificationListController.removeAlerts( alert.Id,cs.Id);
        
        
    }
}