@isTest
public class VSPR19b_restrictOverlappingNR_Test {

    @testSetup
    static void testData(){
       
        	User mike = new User();
              mike.Username= 'mike.white911@company.com';
              mike.Email = 'mike.white911@company.com';
              mike.Lastname = 'mike';
              mike.Firstname = 'white';
              mike.Alias = 'mwhite';
              mike.CommunityNickname = 'mwhite01';
              mike.ProfileId = [ select id, name from profile where name = 'VSP Network Recruitment User' ].Id;                         
              mike.TimeZoneSidKey = 'GMT';
              mike.LocaleSidKey = 'en_US';
              mike.EmailEncodingKey = 'ISO-8859-1';
              mike.LanguageLocaleKey = 'en_US';
              insert mike;
        
         List<User> userX = [SELECT Id FROM User WHERE LastName = 'mike'];
        
         system.Assert(userX.size() == 1);
        
          
              // Insert Account Practice Account
            Account pa = new Account();
            pa.Name = 'testPracAccount';
            pa.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Practice Account' AND SObjectType = 'Account'].Id;
            pa.ShippingStreet = '123 Main Street';
            pa.ShippingCity = 'Rancho Cordova';
            pa.ShippingState = 'CA';
            pa.ShippingPostalCode = '95670';
            pa.Vision_Care_Effective_Date__c = date.today();
            pa.IRS_Name__c = 'testPracAccount';
            pa.Tax_ID__c = '555112222';
            pa.IRS_Tax_ID__c = '555112222';
            pa.Practice_Business_Type__c = 'S - Sole Proprietor';
            pa.Fee_Calculation_Code__c = 'O - Old Calculated Fee Schedule';
            pa.Payment_Distribution__c = 'Business Account(s)';
            insert pa;
            List<Account> acctPa = [SELECT Id FROM Account WHERE Id =: pa.Id];
            system.AssertEquals(acctPa.size(),1);
            
            //Insert New Business Account
            Account ba = new Account();
            ba.Name = 'testbizAccount';
            ba.RecordTypeId = [SELECT Id FROM RecordType WHERE Name = 'Business Account' AND SObjectType = 'Account'].Id;
            ba.ParentId = pa.Id;
            ba.Vision_Care_Effective_Date__c = date.today();
            ba.Vision_Care_Location_Phone_Number__c = '(916) 851-4444';
            ba.Eyefinity_Access__c = 'B - Basic';
            ba.Location_Type__c = 'M - VSP Member Location';
            ba.Dispense_Materials__c = true;
            
            
            insert ba;
            List<Account> acctba = [SELECT Id FROM Account WHERE Id =: ba.Id];
            system.AssertEquals(acctba.size(),1);


            
            // Insert Contact
            Contact c = new Contact();
            c.FirstName = 'Rogers';
            c.LastName = 'Hornsby';
            c.NPI__c = '1245653781';
            c.Degree__c = 'OD';
            c.CAQH_ID__c = '123456679';
            c.Doctor_ID__c = '555112333';
            c.Doctor_Type__c = 'M - VSP Member Doctor';
            c.Vision_Care_Effective_Date__c = date.today();
            c.AccountId = ba.Id;
            insert c;

            List<Contact> contX = [SELECT Id FROM Contact WHERE Id =: c.Id];

            system.AssertEquals(contX.size(),1);
            
            Contact_Role__c cr = new Contact_Role__c();
            cr.Type__c = 'Doctor-Owner';
            cr.Start_Date__c = date.today();
            //cr.End_Date__c = date.newInstance(2017,12,31);
            cr.Account__c = ba.Id;
            cr.Contact__c = c.Id;
            cr.Type__c = 'Doctor-Employee';
            insert cr;

            List<Contact_Role__c> controleX = [SELECT Id FROM Contact_Role__c WHERE Id =: cr.Id];

            system.AssertEquals(controleX.size(),1);
            
            General_Table__c gt = new General_Table__c();
            gt.Name = 'TEST11';
            gt.Code_Description__c = 'test5107';
            gt.Table__c = 'PRSP';
            gt.Status__c = 'Active';
            insert gt;

            List<General_Table__c> gentableX = [SELECT Id FROM General_Table__c WHERE Id =: gt.Id];

            system.AssertEquals(gentableX.size(),1);
            test.StartTest();
            Network_Relationship__c nr = new Network_Relationship__c();
            nr.Contact_Role__c = cr.Id;
            nr.Account_Name__c = ba.id;
            nr.Provider_Name__c = c.id;
            nr.Program_ID__c = gt.Id;
            nr.Program_Effective_Date__c = date.today().addMonths(2);
            nr.Program_End_Date__c = date.today().addMonths(6);
            insert nr;
            
            
            nr.Program_Effective_Date__c = date.today();
            nr.Program_End_Date__c = null;
            
             update nr;
            test.stopTest();
            List<Network_Relationship__c> netrelX = [SELECT Id FROM Network_Relationship__c WHERE Id =: nr.Id];

            system.Assert(netrelX.size() == 1);
    }
    
    static testMethod void unitTest_restrictOverlappingNR(){
        
        
   
        User userMike = [SELECT Id FROM User WHERE Lastname = 'mike'];
        System.runAs(userMike ) {
            
            Id crX = [SELECT Id FROM Contact_Role__c].Id;
            Id gtX = [SELECT Id FROM General_Table__c].Id;
            
            
            test.StartTest();
            
            try{
                Network_Relationship__c nr2 = new Network_Relationship__c();
                nr2.Contact_Role__c = crX;
                nr2.Program_ID__c = gtX;
                nr2.Program_Effective_Date__c = date.today();
                nr2.Program_End_Date__c = date.today().addMonths(6);
                insert nr2;
                
               
            }

            catch(Exception e){
    
                Boolean expectedExceptionThrown =  e.getMessage().contains('Network Relationship effective dates must not overlap with existing Network Relationship records.') ? true : false;
    
                System.AssertEquals(expectedExceptionThrown, true);
    
            }
            test.StopTest();
        }    
    }
    
}