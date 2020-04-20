@isTest(seeAllData=true)
public class VSPR15_ClientBrokerControllerTest{
static testMethod void myUnitTest() {

    VSPR15_ClientBrokerPasswordController v1 = new VSPR15_ClientBrokerPasswordController();
        v1.firstName = '';
        v1.lastName = '';
        v1.accountId = '';
        
        v1.reportList();
        
    }
    
}