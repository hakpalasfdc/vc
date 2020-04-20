///Test Class for VSPR19_AddExceptionToRelatedNRRecords
//Populates Update__c field with the value "True" on associated Network Relationship records when Vision_Care_Location_Exception__c field on Business or  Vision_Care_Practice_Exception__c field on Practice is changed.
@isTest(SeeAllData=False)
public class VSPR25_AddExceptionToRelatedNRRecords_TC {
    //Create test data
    @testSetup private static void createTestRecords(){
        //Define record types
        Id acrtPA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id eyeCareRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Eye_Care_Professional').getRecordTypeId();
        Id acrtBA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';

        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com', EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', 
                ProfileId = p.Id, TimeZoneSidKey='America/Los_Angeles', UserName=uniqueUserName);

        System.runAs(u){
            //Create Practice Account/Parent Account
            Account paacc = new Account();
            paacc.Name='Practice Account Name';
            paacc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            paacc.Tax_ID__c = '123456789';
            paacc.Phone = '1234567890';
            paacc.ShippingStreet = '123 Test Street';
            paacc.ShippingCity = 'Somewhere';
            paacc.ShippingState = 'CA';
            paacc.ShippingPostalCode = '90210';
            paacc.ShippingCountry = 'USA';
            paacc.Practice_Business_Type__c = 'S - Sole Proprietor';
            paacc.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
            paacc.Payment_Method__c = 'Direct Deposit';
            paacc.Payment_Distribution__c = 'Practice Account';
            paacc.RecordTypeId =  acrtPA;        
            insert paacc;

            //Create Business Accont/Child Account      
            Account baacc = new Account();
            baacc.Name='Business Account Name';       
            baacc.ParentId = paacc.id;
            baacc.Fax = '123456789';
            baacc.ShippingStreet = '123 Test Street';
            baacc.ShippingCity = 'Somewhere';
            baacc.ShippingState = 'CA';
            baacc.ShippingPostalCode = '90210';
            baacc.ShippingCountry = 'USA';
            baacc.Vision_Care_Location_Phone_Number__c = '123456789';
            baacc.Eyefinity_Access__c = 'B - Basic';
            baacc.Location_Type__c = 'A - Affiliate Provider Location';
            baacc.Tax_ID__c = '123456789';
            baacc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            baacc.Vision_Care_End_Date__c = System.today() + 3;
            baacc.RecordTypeId =  acrtBA; 
            insert baacc;

            //Create new Contact
            Contact con = new Contact();
            con.FirstName = 'Eye';
            con.LastName = 'Doc';
            con.AccountId = baacc.Id;
            con.Doctor_Type__c = 'M - VSP Member Doctor';
            con.Vision_Care_End_Date__c = null;
            con.Vision_Care_Effective_Date__c =  System.today() - 3;
            con.Degree__c = 'OD';
            con.NPI__c = '1073919239';
            con.Doctor_ID__c = '654654654';
            con.Gender__c = 'Male';
            con.Birthdate__c = Date.newInstance(1990, 07, 31);
            con.RecordTypeId = eyeCareRecordTypeId;
            insert con;

            //Create new Program
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Table__c = 'PRSP';
            insert gt;

            //Create new Contact Role
            Contact_Role__c cr = new Contact_Role__c();
            cr.Account__c = baacc.Id;
            cr.Contact__c = con.Id;
            //cr.Start_Date__c = date.today().adddays(-30);
            cr.Type__c = 'Doctor-Owner';
            insert cr;    

            //Create new Network relationship
            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Program_End_Date__c = NULL;
            nr.Provider_Name__c = con.Id;
            nr.Contact_Role__c = cr.Id;
            nr.Program_ID__c = gt.Id;
            test.startTest();
            insert nr;
            test.stopTest();
        }
    }
       
    public static testmethod void testUpdateBusAcc() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        //System.runAs(u){
            Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            Network_Relationship__c NetRel = [SELECT Id, Contact_Role__r.Account__r.Id from Network_Relationship__c WHERE Contact_Role__r.Account__r.RecordTypeId = :businessRecordTypeId 
            AND Contact_Role__r.Account__r.ParentId != NULL AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL) LIMIT 1];
            Account acc2 = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c from Account WHERE Id = :NetRel.Contact_Role__r.Account__r.Id];       
            acc2.Vision_Care_Location_Exception__c = 'SITE - On-site Clinic';
            test.startTest();
            update acc2;
            test.stopTest();
       // }
    }

    public static testmethod void testUpdatePracticeAcc() {
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);

        //System.runAs(u){
            Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
            Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            Network_Relationship__c NetRel = [SELECT Id, Contact_Role__r.Account__r.Parent.Id from Network_Relationship__c 
            WHERE Contact_Role__r.Account__r.RecordTypeId = :businessRecordTypeId 
            AND Contact_Role__r.Account__r.Parent.RecordTypeId = :practiceRecordTypeId
            AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = NULL) LIMIT 1];
            Account pracAcc = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c from Account WHERE Id = :NetRel.Contact_Role__r.Account__r.Parent.Id];       
            pracAcc.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
            test.startTest();
            update pracAcc;
            test.stopTest();
       // }
    }
}