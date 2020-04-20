@isTest(SeeAllData=false)
private class VSPR26_ContactTriggerTest {
    /*This is a test class for the ContactTrigger_Handler*/
    @testSetup private static void createContact(){
        //public static testmethod void createContact(){
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com'; 
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        System.runAs(u){
        
            //Create Practice Account/Parent Account
            Id acrtPA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
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
            Id acrtBA = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
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
            
            Id eyeCareRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Eye_Care_Professional').getRecordTypeId();
            Contact con = new Contact();
            con.FirstName = 'Eye';
            con.LastName = 'Tennis';
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
            //system.assertNotEquals(null, con.id);
            //system.assertNotEquals(null, con.Vision_Care_End_Date__c);
            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Table__c = 'PRSP';
            insert gt;
            
            Contact_Role__c cr = new Contact_Role__c();
            cr.Account__c = baacc.Id;
            cr.Contact__c = con.Id;
            //cr.Start_Date__c = date.today().adddays(-30);
            cr.Type__c = 'Doctor-Owner';
            insert cr;
            
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
    //When a contact has a contact role associated to a BA and has a PA.
    private static testmethod void updateContactBA(){  
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com'; 
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        
        //System.runAs(u){
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Table__c = 'PRS6';
            gt.Status__c = 'Active';
            insert gt;
        
            Contact con = [SELECT Id, FirstName, LastName, Doctor_ID__c, Vision_Care_End_Date__c FROM Contact WHERE LastName = 'Tennis' AND NPI__c = '1073919239' Limit 1];
            con.Vision_Care_End_Date__c = date.today().adddays(+30);
            con.Vision_Care_Term_Reason__c = gt.Id;
            update con;
            test.startTest();
            ContactTrigger_Handler.VisionCareEndDateNotFuture(new List<id>{con.id});
            test.stopTest(); 
        //}       
    }
    //Update Doctor Ids should hit the error message from ContactTrigger_Handler class.
    private static testmethod void updateContactBA2(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
        System.runAs(u){
            Contact con = [SELECT Id, FirstName, LastName, Doctor_ID__c, Vision_Care_End_Date__c FROM Contact WHERE LastName = 'Tennis' AND NPI__c = '1073919239' Limit 1];
            con.Doctor_ID__c = 'NewDoc122';
            test.startTest();
            try{
                update con;
            }
            catch(Exception e){
                //System.assert(e.getMessage().contains('Another Contact'));
            }
            ContactTrigger_Handler.VisionCareEndDateNotFuture(new List<id>{con.Id});
            test.stopTest();
        }
    }
    
    //Updates Vision_Care_End_Date__c
    private static testmethod void updateContactBA3(){
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@vsp.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='VSP Network Recruitment User'];
        User u = new User(Alias = 'standt', Email='standarduser@vsp.com',
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                          LocaleSidKey='en_US', ProfileId = p.Id,
                          TimeZoneSidKey='America/Los_Angeles',
                          UserName=uniqueUserName);
       // System.runAs(u){
            General_Table__c gt = new General_Table__c();
            gt.Name = 'VSP';
            gt.Table__c = 'PRS6';
            gt.Status__c = 'Active';
            insert gt;
            
            Contact con = [SELECT Id, FirstName, LastName, Doctor_ID__c, Vision_Care_End_Date__c FROM Contact WHERE LastName = 'Tennis' AND NPI__c='1073919239' Limit 1];
            con.Vision_Care_End_Date__c = date.today().adddays(+30);
            con.Vision_Care_Term_Reason__c = gt.Id;
            update con;
            test.startTest();
            ContactTrigger_Handler.VisionCareEndDateFuture(new List<id>{con.id});
            test.stopTest();        
        //}
    }
}