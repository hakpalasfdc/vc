/*
   Writen Date : 27th May 2016.
   Related Object : Case.
   Related Case : Case 9044.
   Description :Test class for  trgCaseAgeCalculation Trigger and CaseAgeCalculationHandler Apex Class
*/
@isTest
public class trgCaseAgeCalculationTest{
    public static testmethod void trgEmailAlertandCaseAgeCalculationMethod(){
         DVIWebService__c di = new DVIWebService__c(Name='DVI Values',DVI_Web_Service__c='Test',DVI_Token_Header__c='test');
        insert di;
        
        List<case> CaseList=new List<case>();
        List<case> UpdatedCaseList=new List<case>();
        List<CaseRecordType__c> CaseRecordTypeList=new List<CaseRecordType__c>();
                
        RecordType rt = new RecordType();
        rt = [Select id,name from RecordType where name = 'Customer Care' and sobjectType = 'Case' LIMIT 1];
        Id RecordTypeID = [Select id,name from RecordType where name != 'Customer Care' and sobjectType = 'Case' LIMIT 1].id;
        CaseRecordType__c CaseRecordType=new CaseRecordType__c();
        CaseRecordType.Id__c= rt.id;
        CaseRecordType.name='VSP Global Full Id';
        
        CaseRecordTypeList.add(CaseRecordType);
        //insert CaseRecordType;
        
        CaseRecordType__c CaseRecordType1=new CaseRecordType__c();
        CaseRecordType1.Id__c= rt.id;
        CaseRecordType1.name='Customer Care';
        
        CaseRecordTypeList.add(CaseRecordType1);
        //insert CaseRecordType1;
        
        insert CaseRecordTypeList;
        system.assertEquals(CaseRecordTypeList.size(),2);
       
       system.assertNotEquals(CaseRecordType.id,null);
       
       Escalated_Queue_Name__c Escalated_Queue_Name=new Escalated_Queue_Name__c();
       Escalated_Queue_Name.name='Error Queue';
       Escalated_Queue_Name.Escalated_Q_Name__c='Error Queue';
       insert Escalated_Queue_Name;
       system.assertNotEquals(Escalated_Queue_Name.id,null); 
       
        for(integer i=0;i<10;i++)
        {
            Case c=new Case();
            c.Origin='Web';
            c.Subject='test';
            c.Description='test';
            c.Line_of_Business__c='Altair';
            c.status='New';
            c.Severity__c='Minor';
            c.Type='Request';
            c.Product__c='Premier';
            c.In_Danger_of_Missing_for_High_Priority__c = false;
            c.Auto_Assign__c = false;
            c.Classification__c='Billing';
            CaseList.add(c);
        }
        
        Test.StartTest();
            insert CaseList;
            for(Case c:CaseList){
                c.status='Closed';
                c.Origin='Email';
                c.Case_Age_2__c = 21.00;
                c.In_Danger_of_Missing_for_High_Priority__c = true;
                UpdatedCaseList.add(c);
            }
            update UpdatedCaseList;
            update UpdatedCaseList;
        Test.StopTest();
    }
}