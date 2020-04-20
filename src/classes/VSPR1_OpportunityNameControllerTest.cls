/* 
* Class Name: VSPR1_OpportunityNameControllerTest
* Created By: Amit Shinde, 08/11/2015
* Description: Test Class for VSPR1_OpportunityNameController
* Updates:
*/

@isTest(SeeAllData = true)
public class VSPR1_OpportunityNameControllerTest {
    static testMethod void unitTest(){
        
        // Insert sample Account 
        Account acc = new Account();
        acc.Name = 'Sample Account 0';
        acc.Status__c = 'New';
        acc.Account_Type__c = 'Business Account';
        acc.Altair_Standard__c = '001';
        acc.Altair_Field_Rep__c = '001'; 
        acc.Altair_Key_Account__c = '001';
        acc.Altair_Exception__c = '001'; 
        acc.Altair_Hybrid_Bebe__c = '001'; 
        acc.Ophthalmic_Business_Consultant__c = '001'; 
        acc.Optics_Contact_Lens_Consultant__c = '001'; 
        acc.Marchon_Key_Account__c = '001'; 
        acc.Marchon_Close_Out__c = '001'; 
        acc.Marchon_Optical__c = '001'; 
        acc.Marchon_Retail__c = '001';
        acc.VC_EDS_NA__c = '001'; 
        acc.Global_Business_Development_Manager__c = '001';
        acc.Global_Business_Development_Partner__c = '001';
        acc.VC_Relationship_Manager__c = '001'; 
        acc.Optics_Wholesale__c = '001'; 
        acc.Eyefinity_Inside_Sales__c = '001'; 
        acc.Eyefinity_Outside_Sales__c = '002';
        insert acc;
        
        // Insert Oportunity record with account id but without record Type
        Opportunity opty0 = new Opportunity();
        opty0.Name = 'Sample Opty 0';
        opty0.AccountId = acc.Id;
        opty0.Line_of_Business__c = 'Optics';
        opty0.Product_Program__c = 'SampleText 0';
        opty0.StageName = 'Prospect';
        opty0.Probability = 10;
        opty0.Closedate = system.today();                           
        opty0.Planned_Closed_Month__c = 'December'; 
        insert opty0;  
        
        // Insert Oportunity record with account id and record Type 'VSP Opportunity'.
        Opportunity opty1 = new Opportunity();
        opty1.Name = 'Sample Opty 1';
        opty1.AccountId = acc.Id;
        //get Opportunity Record Type Id for 'VSP Opportunity'
        String strRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Opportunity' and Name='VSP Opportunity'].Id;
        opty1.RecordTypeId = strRecordTypeId;
        opty1.Line_of_Business__c = 'Optics';
        opty1.Product_Program__c = 'SampleText 1';
        opty1.StageName = 'Prospect';
        opty1.Probability = 10;
        opty1.Closedate = system.today();                           
        opty1.Planned_Closed_Month__c = 'December'; 
        insert opty1;
        
        
        //Insert Oportunity record with account id and record Type 'New Release Opportunity'.
        Opportunity opty2 = new Opportunity();
        opty2.Name = 'Sample Opty 2';
        opty2.AccountId = acc.id;
        //get Opportunity Record Type Id for 'New Release Opportunity'
        String strRecordTypeId2=[SELECT Id from RecordType where SObjectType = 'Opportunity' and Name='New Release Opportunity'].Id;
        opty2.RecordTypeId = strRecordTypeId2;
        opty2.Line_of_Business__c = 'Optics';
        opty2.Product_Program__c = 'SampleText 2';
        opty2.StageName = 'Prospect';
        opty2.Probability = 10;
        opty2.Closedate = system.today();                           
        opty2.Planned_Closed_Month__c = 'March';    
        insert opty2;
        
        // Insert Oportunity record without account id and record Type.
        Opportunity opty3 = new Opportunity();
        opty3.Name = 'Sample Opty 3';
        opty3.Line_of_Business__c = 'Optics';
        opty3.Product_Program__c = 'SampleText';
        opty3.StageName = 'Prospect';
        opty3.Probability = 10;
        opty3.Closedate = system.today();                           
        opty3.Planned_Closed_Month__c = 'December'; 
        insert opty3;
        
        // Page reference with account id but without record Type
        PageReference pageRef0 = Page.VSPR1_OpportunityName;   
        pageRef0.getParameters().put('accid', acc.id);
        pageRef0.getParameters().put('id',opty0.id);    
        System.Test.setCurrentPage(pageRef0); 
        ApexPages.StandardController sc0 = new ApexPages.standardController(opty0);
        VSPR1_OpportunityNameController controller0 = new VSPR1_OpportunityNameController(sc0);
        controller0.getRecDetails();
        
        // Page reference with account id and record Type 'VSP Opportunity'.
        PageReference pageRef1 = Page.VSPR1_OpportunityName;   
        pageRef1.getParameters().put('accid', acc.id);
        pageRef1.getParameters().put('id',opty1.id);
        pageRef1.getParameters().put('RecordType',opty1.RecordTypeId);
        System.Test.setCurrentPage(pageRef1); 
        ApexPages.StandardController sc1 = new ApexPages.standardController(opty1);
        VSPR1_OpportunityNameController controller1 = new VSPR1_OpportunityNameController(sc1);
        controller1.getRecDetails();
        
        // Page reference with account id and record Type 'VSP Consignment Opportunity'.
        PageReference pageRef2 = Page.VSPR1_OpportunityName;   
        pageRef1.getParameters().put('accid', acc.id);
        pageRef2.getParameters().put('id',opty2.id);  
        pageRef2.getParameters().put('RecordType',opty2.RecordTypeId);
        System.Test.setCurrentPage(pageRef2); 
        ApexPages.StandardController sc2 = new ApexPages.standardController(opty2);
        VSPR1_OpportunityNameController controller2 = new VSPR1_OpportunityNameController(sc2);
        controller2.getRecDetails();
        
        // Page reference without account id and record Type.
        PageReference pageRef3 = Page.VSPR1_OpportunityName;
        pageRef3.getParameters().put('id',opty3.id);        
        System.Test.setCurrentPage(pageRef3); 
        ApexPages.StandardController sc3 = new ApexPages.standardController(opty3);
        VSPR1_OpportunityNameController controller3 = new VSPR1_OpportunityNameController(sc3);
        controller3.getRecDetails();
    }
}