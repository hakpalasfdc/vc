@isTest
// Test class for VSPR33_Con_Role_VSP_Net_Provider_Sch
public class VSPR33_Con_Role_VSP_Net_Provider_Test {
    
    @TestSetup
    static void testData(){
        
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
        
        Contact con2 = new Contact();
        //  Id professionalRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Eye_Care_Professional').getRecordTypeId();
        con2.FirstName = 'Eye2';
        con2.LastName = 'Doc2';
        con2.AccountId = acc1.Id;
        con2.Doctor_Type__c = 'M - VSP Member Doctor';
        con2.Vision_Care_End_Date__c = null;
        con2.Vision_Care_Effective_Date__c =  System.today() - 3;
        con2.Degree__c = 'OD';
        con2.NPI__c = '1073919232';
        con2.Doctor_ID__c = '654654652';
        con2.Gender__c = 'Male';
        con2.Birthdate__c = Date.newInstance(1990, 07, 31);
        con2.RecordTypeId = professionalRecordTypeId;
        con2.Phone = '1234445656';
        insert con2;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = acc1.Id;
        cr.Contact__c = con.Id;
        cr.Type__c = 'Doctor-Employee';
        cr.Start_Date__c = System.today();
        cr.Fee_Code__c = 'NA';
        
        insert cr;
        
        Contact_Role__c cr2 = new Contact_Role__c();
        cr2.Account__c = acc1.Id;
        cr2.Contact__c = con2.Id;
        cr2.Type__c = 'Doctor-Employee';
        cr2.Start_Date__c = System.today();
        cr2.Fee_Code__c = 'NA';
        
        insert cr2;
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'VSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        
        insert gt;
        
        Network_Relationship__c nr = new Network_Relationship__c();
        nr.Contact_Role__c = cr.Id;
        nr.Program_ID__c = gt.Id;
        nr.Program_Effective_Date__c = Date.today().addDays(-2);
        nr.Program_End_Date__c = Date.today().addDays(-1);
        
        Network_Relationship__c nr2 = new Network_Relationship__c();
        nr2.Contact_Role__c = cr2.Id;
        nr2.Program_ID__c = gt.Id;
        nr2.Program_Effective_Date__c = Date.today();
        test.starttest();
        insert nr;
        insert nr2;
        
        cr.VSP_Network_Provider__c = TRUE;
        update cr;
        
        cr2.VSP_Network_Provider__c = FALSE;
        update cr2;
        
        test.stopTest();
    }
    
    public static testmethod void runBatch() {
               
        Test.startTest();
        
        String EXP = '0 0 1 * * ?';
        
        VSPR33_Con_Role_VSP_Net_Provider_Sch sch = new VSPR33_Con_Role_VSP_Net_Provider_Sch();
        
        system.Schedule('Contact Role VSP Network Provider Test', EXP, sch);
        
        Test.stopTest();
        //  cr = [SELECT Id, VSP_Network_Provider__c FROM Contact_Role__c];
        //    system.assertEquals(false, cr.VSP_Network_Provider__c);
    }
    
    
}