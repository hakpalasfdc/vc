@isTest
public class Mask9DigitHandlerTest{
    public static testmethod void testMask9DigitHandlerTestMethod(){
    
        DVIWebService__c di = new DVIWebService__c(Name='DVI Values',DVI_Web_Service__c='Test',DVI_Token_Header__c='test');
        insert di;
    
        List<Case> caseList=new List<Case>();
        List<Case> updatedCaseList=new List<Case>();
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
        
        Escalated_Queue_Name__c Escalated_Queue_Name=new Escalated_Queue_Name__c();
        Escalated_Queue_Name.name='Error Queue';
        Escalated_Queue_Name.Escalated_Q_Name__c='Error Queue';
        insert Escalated_Queue_Name;
        system.assertNotEquals(Escalated_Queue_Name.id,null); 
        
        for(integer i=0;i<10;i++){
            Case c=new Case();
            c.Origin='Web';
            c.Subject='Your AC No. 45-4567687.\r\n\r\n\r\nhas\r\n been  credited with 5000\r\n\r\nand available Bal. is 54000.\r\n Thanks '+i;
            c.Description='Your SSN No. is 45-4567677 and 567-987-101.';
            c.Line_of_Business__c='Altair';
            c.status='New';
            c.Severity__c='Minor';
            c.Type='Request';
            c.Product__c='Premier';
            c.In_Danger_of_Missing_for_High_Priority__c = false;
            c.Auto_Assign__c = false;
            c.Classification__c='Billing';
            c.RecordTypeID=RecordTypeID;
            caseList.add(c);
        } 
        
        System.assertEquals(caseList.size(),10);
        
        Case c1=new Case();
            c1.Origin='Web';
            c1.Subject='';
            c1.Description='';
            c1.Line_of_Business__c='Altair';
            c1.status='New';
            c1.Severity__c='Minor';
            c1.Type='Request';
            c1.Product__c='Premier';
            c1.In_Danger_of_Missing_for_High_Priority__c = false;
            c1.Auto_Assign__c = false;
            c1.Classification__c='Billing';
            c1.RecordTypeID = RecordTypeID;
        caseList.add(c1);
        System.assertEquals(c1.id,null);
        
        Test.StartTest();
        System.debug('##### CaseList = > '+CaseList.size());
        insert CaseList;
        System.assertNotEquals(c1.id,null);
            
            for(Case c:CaseList){
                c.status='Closed';
                c.Subject='SSN No.changed  from 45-4567677 to 567-987-101. Your AC No. 45-4567687\r\n has been  credited with 5000 and available Bal. is 54000.';
                c.Description='Your SSN No. has been changed  from 45-4567677 to 567-987-101. Your AC No. 45-4567687\r\n has been  credited with 5000 and available Bal. is 54000. Your AC No. 45-4567687.\r\n\r\n\r\nhas\r\n been  credited with 5000\r\n\r\nand available Bal. is 54000.\r\n Thanks';
                UpdatedCaseList.add(c);
            }
            
            update UpdatedCaseList; 
            
                EmailMessage em = new EmailMessage();
                em.FromAddress = 'salesforcretest@vsp.com';
                em.Subject = 'Test Email 001  SSN No. 11-111-1111.';
                em.ParentId = c1.id;
                em.TextBody = 'Your SSN No. is 45-4567677 and 567-987-101. Your AC No. 45-4567687\r\n has been  credited with 5000 and available Bal. is 54000. Your AC No. 45-4567687.\r\n\r\n\r\nhas\r\n been  credited with 5000\r\n\r\nand available Bal. is 54000.\r\n Thanks'; 

            insert em; 
            
                em.TextBody = 'Thank You.';
                em.Subject = 'Test 11-111-1111';

            update em;
            
            
        Test.StopTest();
    
    }
}