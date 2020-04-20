///Test Class for VSPR19b_ContactRoleTrigger_Handler
@isTest(SeeAllData=False)
public class VSPR25_ContactRoleTrigger_Handler_Test {

    
    public static testmethod void testUpdateContactRole() {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u){

            Account acc= new Account();
            acc.Name='Practice Account Name';
            acc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc.Tax_ID__c = '123456789';
            acc.Phone = '1234567890';
            acc.ShippingStreet = '123 Test Street';
            acc.ShippingCity = 'Somewhere';
            acc.ShippingState = 'CA';
            acc.ShippingPostalCode = '90210';
            acc.ShippingCountry = 'USA';
            acc.Practice_Business_Type__c = 'S - Sole Proprietor';
            acc.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
            acc.Payment_Method__c = 'Direct Deposit';
            acc.Payment_Distribution__c = 'Practice Account';
            Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
            
            acc.RecordTypeId =  practiceRecordTypeId;        
            insert acc;
            system.debug('++++++++++++++++++++++++++++  TestClassAccId  ++++++++++++++++++++++++++++++++++++++++++++++' + acc.Id);
            
            Account acc1= new Account();
            Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            acc1.Name='Business Account Name';       
            acc1.ParentId = acc.id;
            acc1.Fax = '123456789';
            acc1.ShippingStreet = '123 Test Street';
            acc1.ShippingCity = 'Somewhere';
            acc1.ShippingState = 'CA';
            acc1.ShippingPostalCode = '90210';
            acc1.ShippingCountry = 'USA';
            acc1.Vision_Care_Location_Phone_Number__c = '123456789';
            acc1.Eyefinity_Access__c = 'B - Basic';
            acc1.Location_Type__c = 'A - Affiliate Provider Location';
            acc1.Tax_ID__c = '123456789';
            acc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc1.Vision_Care_End_Date__c = System.today() + 3;
            acc1.RecordTypeId =  businessRecordTypeId; 
            
            insert acc1;  
            
            General_Table__c gt2 = new General_Table__c();
            gt2.Name = 'LEFT';
            gt2.Table__c = 'PRS6';
            gt2.Status__c = 'Active';
            
            insert gt2;
            Id reacId;
            List<General_Table__c> checkReac = new List<General_Table__c>([SELECT Id from General_Table__c WHERE Table__c = 'PRS6' AND Name = 'REAC' LIMIT 1]);
            if(checkReac.size() == 0){
                General_Table__c gt3 = new General_Table__c();
                gt3.Name = 'REAC';
                gt3.Table__c = 'PRS6';
                gt3.Status__c = 'Active';
                insert gt3;
                reacId = gt3.Id;
            }
            else{
                reacId = checkReac[1].id;  
            }
            
            
            Contact con = new Contact();
            Id professionalRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Eye_Care_Professional').getRecordTypeId();
            con.FirstName = 'Eye';
            con.LastName = 'Doc';
            con.AccountId = acc1.Id;
            con.Doctor_Type__c = 'M - VSP Member Doctor';
            con.Vision_Care_End_Date__c = null;
            con.Vision_Care_Effective_Date__c =  System.today() - 3;
            con.Degree__c = 'OD';
            con.NPI__c = '1073919239';
            con.Doctor_ID__c = '654654654';
            con.Gender__c = 'Male';
            con.Birthdate__c = Date.newInstance(1990, 07, 31);
            con.RecordTypeId = professionalRecordTypeId;
            con.Phone = '1234445656';
            insert con;
            
            Contact_Role__c cr = new Contact_Role__c();
            cr.Account__c = acc1.Id;
            cr.Contact__c = con.Id;
            cr.Type__c = 'Doctor-Employee';
            cr.Start_Date__c = System.today();
            cr.Fee_Code__c = 'NA';
            
            insert cr;
            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            
            insert gt;
            
            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Program_ID__c = gt.Id;
            
            test.starttest();
            insert nr;
            //test.stoptest();
            
            //Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            Network_Relationship__c NetRel = [SELECT Id, Contact_Role__r.Account__r.Id from Network_Relationship__c 
                                              WHERE Contact_Role__r.Account__r.RecordTypeId = :businessRecordTypeId 
                                              AND Contact_Role__r.Account__r.ParentId != NULL 
                                              AND Contact_Role__r.Contact__r.Vision_Care_Effective_Date__c != NULL
                                              AND (Program_End_Date__c >= TODAY OR Program_End_Date__c = null ) LIMIT 1];
            Contact_Role__c cr1 = [SELECT Id, End_Date__c from Contact_Role__c WHERE Id = :NetRel.Contact_Role__r.Id]; 
            cr1.End_Date__c = System.today() + 3;
            cr1.Total_Doctor_Hours__c = 88;
            //test.startTest();
            update cr1;
            test.stopTest();
        }
    }
    @isTest
    public static void testCreateContactRole() {
        // This code runs as the system user
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        //User u = [SELECT Id FROM User WHERE Email='standarduser@vsp.com' LIMIT 1];

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
        
        test.startTest();
        /*Account ba = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c 
                      FROM Account 
                      WHERE Name = 'Business Account Name' AND Tax_ID__c = '123456789' AND RecordTypeId =: businessRecordTypeId LIMIT 1];
        Contact c = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId =: ba.Id LIMIT 1];*/
        
        System.runAs(u){
             Account acc= new Account();
            acc.Name='Practice Account Name';
            acc.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc.Tax_ID__c = '123456789';
            acc.Phone = '1234567890';
            acc.ShippingStreet = '123 Test Street';
            acc.ShippingCity = 'Somewhere';
            acc.ShippingState = 'CA';
            acc.ShippingPostalCode = '90210';
            acc.ShippingCountry = 'USA';
            acc.Practice_Business_Type__c = 'S - Sole Proprietor';
            acc.Fee_Calculation_Code__c = 'N - New Calculated Fee Schedule';
            acc.Payment_Method__c = 'Direct Deposit';
            acc.Payment_Distribution__c = 'Practice Account';
            Id practiceRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Practice_Account').getRecordTypeId();
            
            acc.RecordTypeId =  practiceRecordTypeId;        
            insert acc;
            system.debug('++++++++++++++++++++++++++++  TestClassAccId  ++++++++++++++++++++++++++++++++++++++++++++++' + acc.Id);
            
            Account acc1= new Account();
            //Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Business_Account').getRecordTypeId();
            acc1.Name='Business Account Name';       
            acc1.ParentId = acc.id;
            acc1.Fax = '123456789';
            acc1.ShippingStreet = '123 Test Street';
            acc1.ShippingCity = 'Somewhere';
            acc1.ShippingState = 'CA';
            acc1.ShippingPostalCode = '90210';
            acc1.ShippingCountry = 'USA';
            acc1.Vision_Care_Location_Phone_Number__c = '123456789';
            acc1.Eyefinity_Access__c = 'B - Basic';
            acc1.Location_Type__c = 'A - Affiliate Provider Location';
            acc1.Tax_ID__c = '123456789';
            acc1.Vision_Care_Effective_Date__c = Date.newInstance(2018, 07, 01);
            acc1.Vision_Care_End_Date__c = System.today() + 3;
            acc1.RecordTypeId =  businessRecordTypeId; 
            
            insert acc1;

            Contact con = new Contact();
            Id professionalRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Eye_Care_Professional').getRecordTypeId();
            con.FirstName = 'Eye';
            con.LastName = 'Doc';
            con.AccountId = acc1.Id;
            con.Doctor_Type__c = 'M - VSP Member Doctor';
            con.Vision_Care_End_Date__c = null;
            con.Vision_Care_Effective_Date__c =  System.today() - 3;
            con.Degree__c = 'OD';
            con.NPI__c = '1073919239';
            con.Doctor_ID__c = '654654654';
            con.Gender__c = 'Male';
            con.Birthdate__c = Date.newInstance(1990, 07, 31);
            con.RecordTypeId = professionalRecordTypeId;
            con.Phone = '1234445656';
            insert con;

            Contact_Role__c cr = new Contact_Role__c();
            cr.Account__c = acc1.Id;
            cr.Contact__c = con.Id;
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = System.today();
            cr.Fee_Code__c = 'NA';
            
            insert cr;
        }

        Account ba = [SELECT Id, Name, Vision_Care_Effective_Date__c, Vision_Care_End_Date__c 
                      FROM Account 
                      WHERE Name = 'Business Account Name' AND Tax_ID__c = '123456789' AND RecordTypeId =: businessRecordTypeId LIMIT 1];
        Contact c = [SELECT Id, FirstName, LastName FROM Contact WHERE AccountId =: ba.Id LIMIT 1];

        system.assertNotEquals(null, [SELECT Id, Account__c, Contact__c FROM Contact_Role__C WHERE Account__c =: ba.id AND Contact__c =: c.Id LIMIT 1]);
        test.stopTest();
    }
}