///Test Class for VSPR25b_UpdateContactEndDate

@isTest
public class VSPR25b_UpdateContactEndDate_Test {
    
    @TestSetup
    public static void testNewContactNR(){
        
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
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'VSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        
        insert gt; 
        
        General_Table__c gt2 = new General_Table__c();
        gt2.Name = 'VSP6';
        gt2.Table__c = 'PRS6';
        gt2.Status__c = 'Active';
        
        insert gt2; 
        
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
        con.Vision_Care_End_Date__c = System.today() + 3;
        con.Vision_Care_Effective_Date__c =  System.today() - 3;
        con.Degree__c = 'OD';
        con.NPI__c = '1073919239';
        con.Doctor_ID__c = '654654654';
        con.Gender__c = 'Male';
        con.Birthdate__c = Date.newInstance(1990, 07, 31);
        con.RecordTypeId = professionalRecordTypeId;
        con.Vision_Care_Term_Reason__c = gt2.Id;
        //below part added by Vikhyat on 08/28/2019
        con.Phone = '9617147714';
        
        insert con;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = acc1.Id;
        cr.Contact__c = con.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Start_Date__c = System.today();
        cr.Fee_Code__c = 'NA';
        
        insert cr;
        
        Network_Relationship__c nr = new Network_Relationship__c();
        nr.Contact_Role__c = cr.Id;
        nr.Program_ID__c = gt.Id;
        
        Network_Relationship__c nr2 = new Network_Relationship__c();
        nr2.Contact_Role__c = cr.Id;
        nr2.Program_ID__c = gt.Id;
        nr2.Program_End_Date__c = System.today()+1;
        
        test.starttest();
        insert nr;
     //   insert nr2;
        test.stoptest();
        
    }
    public static testmethod void testUpdateNRFutureEndDate() {
        Contact_Role__c cr = [SELECT Id from Contact_Role__c WHERE Contact__r.FirstName = 'Eye' and Account__r.Name = 'Business Account Name'];
        Network_Relationship__c nr = [SELECT Id from Network_Relationship__c WHERE Contact_Role__c = :cr.Id AND Program_End_Date__c = NULL LIMIT 1]; 
        nr.Program_End_Date__c = System.today() + 3;
        
        test.starttest();
        update nr;
        test.stoptest();    
    }
    
    public static testmethod void testUpdateNRPastwithEndDate() {
        Contact_Role__c cr = [SELECT Id from Contact_Role__c WHERE Contact__r.FirstName = 'Eye' and Account__r.Name = 'Business Account Name'];
        Network_Relationship__c nr = [SELECT Id from Network_Relationship__c WHERE Contact_Role__c = :cr.Id LIMIT 1];
        nr.Program_End_Date__c = System.today() - 3;
        
        test.starttest();
        update nr;
        test.stoptest();
    }
    
    public static testmethod void testUpdateNRBlankEndDate() {
        Contact_Role__c cr = [SELECT Id from Contact_Role__c WHERE Contact__r.FirstName = 'Eye' and Account__r.Name = 'Business Account Name'];
        Network_Relationship__c nr = [SELECT Id from Network_Relationship__c WHERE Contact_Role__c = :cr.Id LIMIT 1];
        nr.Program_End_Date__c = null;
        
        test.starttest();
        update nr;
        test.stoptest();
    }    
    
    public static testmethod void testUpdateNR1RPCWithProgramEndDate() {
        
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
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'VSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        
        insert gt; 
        
        General_Table__c gt2 = new General_Table__c();
        gt2.Name = '1PRC';
        gt2.Table__c = 'PRS6';
        gt2.Status__c = 'Active';
        
        insert gt2; 
        
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
        con.Vision_Care_End_Date__c = System.today() + 3;
        con.Vision_Care_Effective_Date__c =  System.today() - 3;
        con.Degree__c = 'OD';
        con.NPI__c = '1073919238';
        con.Doctor_ID__c = '654654655';
        con.Gender__c = 'Male';
        con.Birthdate__c = Date.newInstance(1990, 07, 31);
        con.RecordTypeId = professionalRecordTypeId;
        con.Vision_Care_Term_Reason__c = gt2.Id;
        //Below part added by Vikhyat on 08/28/2019
        con.Phone = '1234567890';
        
        insert con;

        Test.starttest();

        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = acc1.Id;
        cr.Contact__c = con.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Start_Date__c = System.today();
        cr.Fee_Code__c = 'NA';
        
        insert cr;
        
        
        Network_Relationship__c nr = new Network_Relationship__c();
        nr.Contact_Role__c = cr.Id;
        nr.Program_ID__c = gt.Id;
        nr.Program_End_Date__c = System.today()+1;
          
        Network_Relationship__c nr2 = new Network_Relationship__c();
        nr2.Contact_Role__c = cr.Id;
        nr2.Program_ID__c = gt.Id;
        nr2.Program_End_Date__c = System.today()+10;
        
        //test.starttest();
        insert nr;
        insert nr2;
        test.stoptest();
    } 
}