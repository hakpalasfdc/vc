public class VSPR2_CCPortal_Controller {
    Public String ccpURL {get;set;}
    public void VSPR2_CCPortal_Controller(){
        ccpURL = CC_Portal__c.getValues('Environment').Base_URL__c;
		ccpURL += CC_Portal__c.getValues('Environment').Ready_URL__c;
    }
}