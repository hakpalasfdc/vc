@isTest
public class TestPPPCalculator {
    
    private static testmethod void TestCopyToCase()
    {
        DVIWebService__c dviCustSetting = new DVIWebService__c();
        dviCustSetting.name = 'DVI Values';
        dviCustSetting.DVI_Web_Service__c = 'webserviceURL'; 
        dviCustSetting.DVI_Token_Header__c = 'tokenheader';
        insert dviCustSetting;
        
        case caseobj = new case(); 
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Vision Benefits').getRecordTypeId();
        caseobj.recordtypeId = rtId;
        insert caseobj;          

        String result = PPPCalcController.getcopytocase('1', '1', '100','','','','',caseobj.Id);
        result = PPPCalcController.getcopytocase('2', '2', '200','','','','',caseobj.Id);
        result = PPPCalcController.getcopytocase('3', '3', '300','','','','',caseobj.Id);
        result = PPPCalcController.getcopytocase('4', '4', '400','','','','',caseobj.Id);
        result = PPPCalcController.getcopytocase('5', '5', '500','','','','',caseobj.Id);
        result = PPPCalcController.getcopytocase('6', '6', '600','','','','',caseobj.Id);
        System.assertEquals('Success', result);        
    }
}