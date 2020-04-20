@isTest
public class VSPR2_CCPortal_Controller_Test {
	@isTest
    public static void getCCPUrl(){
        CC_Portal__c ccCustSetting = new CC_Portal__c();
        ccCustSetting.name = 'Environment';
        ccCustSetting.Base_URL__c = 'https://ccp-test.vsp.com';
        ccCustSetting.Ready_URL__c = '/csrportal/ctiEvent/answered?SalesforceReadOnlyMode=True';
        insert ccCustSetting;

        VSPR2_CCPortal_Controller ccController = new VSPR2_CCPortal_Controller();
		ccController.VSPR2_CCPortal_Controller();
		String ccp = ccController.ccpURL;
        
        system.assertEquals('https://ccp-test.vsp.com/csrportal/ctiEvent/answered?SalesforceReadOnlyMode=True',ccp);
    }
}