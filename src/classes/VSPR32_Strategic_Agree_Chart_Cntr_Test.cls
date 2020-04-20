@istest
public class VSPR32_Strategic_Agree_Chart_Cntr_Test {

    Private Static testmethod void TestStrategicController(){
        Id optyRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Strategic Agreement Opportunity').getRecordTypeId();
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account pAcc = new Account();
        pAcc.Name = 'Test Account';
        insert pAcc;
        
        Opportunity strategicOpty = new Opportunity();
        strategicOpty.AccountId = pAcc.Id;
        strategicOpty.Name = 'Test Strategic Opty '+ Date.today();
        strategicOpty.StageName = 'Prospect';
		strategicOpty.Line_of_Business__c = 'Optics';
		strategicOpty.Product_Program__c = 'TEXT';
		strategicOpty.CloseDate = Date.today();
		insert strategicOpty;
        
        Test.startTest();
        ApexPages.StandardController stdOpty = new ApexPages.StandardController(strategicOpty);
        VSPR32_Strategic_Agree_Chart_Controller myctrllr = new VSPR32_Strategic_Agree_Chart_Controller(stdOpty);
        myctrllr.EdittheSection();
        myctrllr.cancelOpty();
        myctrllr.EdittheSection();
		strategicOpty.VSPOne_Commitment_Year_1__c = 100;
		myctrllr.saveOpty();
        Test.stopTest();
        
        strategicOpty = [SELECT Id, VSPOne_Commitment_Year_1__c FROM Opportunity WHERE Account.Name = 'Test Account' LIMIT 1];
        system.assertEquals(strategicOpty.VSPOne_Commitment_Year_1__c, 100);
    }
}