///Test Class for VSPR26_PopulateResolutionContact
@isTest
public class VSPR26_PopulateResolutionContact_Test {
    
    @TestSetup
    public static void testNewCase(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Technical User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u){
            
            test.starttest();
            insert new Case_Resolution__c(Name = 'Level - Claims', Topic__c = 'Level', Reason_for_Contact__c = 'Claims', Resolution_of_Contact__c = 'Provided Claim(s) Information for Customer');
            insert new Case_Resolution__c(Name = 'Level - COB', Topic__c = 'Level', Reason_for_Contact__c = 'COB', Resolution_of_Contact__c = 'Provided Coverage/Claims Coordination of Benefits Information with Customer');
            insert new Case_Resolution__c(Name = 'Level - Cost', Topic__c = 'Level', Reason_for_Contact__c = 'Cost', Resolution_of_Contact__c = 'Provided cost of Glasses information for Customer');    
            insert new Case_Resolution__c(Name = 'Level - Dr List', Topic__c = 'Level', Reason_for_Contact__c = 'Dr List', Resolution_of_Contact__c = 'Provided Dr List for Customer');    
            
            DVIWebService__c dviWeb = new DVIWebService__c(); 
            dviWeb.Name = 'DVI Values';
            insert dviWeb;
            
            
            Id eyeconicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Eyeconic').getRecordTypeId();
            Id customerCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Care').getRecordTypeId();
            //      List<Case> lstCase = new List<Case>();
            Case custCase = new Case();
            custCase.RecordTypeId = customerCaseRecordTypeId;
            custCase.Subject = 'Test Customer Case';
            custCase.Description = 'Test Customer Description';
            custCase.Type = 'Issue';
            custCase.Product__c = 'Level';
            custCase.Reason_for_Contact__c = 'Claims;COB;Cost';
            custCase.Origin = 'Phone';
            
            //   lstCase.add(custCase);
            
            insert custCase;
            
            test.stoptest();
        }
    }
    public static testmethod void testUpdateCustCase() {
        Case custCase = [SELECT Id from Case WHERE Subject = 'Test Customer Case' AND Type = 'Issue' AND Product__c = 'Level'];
        
        custCase.Reason_for_Contact__c = 'Claims;COB;Cost;Dr List';
        update custCase;
    }
    
}