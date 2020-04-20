@isTest
public class VSPR25b_ValidateClaimsPriced_Test {
   
    static testMethod void updateNetworkRel(){
        
             Id recTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
                account acc1 = new account();
                acc1.name='test';
                acc1.recordTypeId = recTypeId;
                acc1.email__c='abc@gmail.com';
              
                acc1.Fax = '223456';
                acc1.Phone = '96532';
                acc1.shippingStreet = '1112US';
                acc1.Account_Type__c = 'Business Account';
                acc1.Zipcode__c= '01001' ;
                
                acc1.Vision_Care_Effective_Date__c=date.today();
            VSPUtility.stopAccountTrigger=true;
                insert acc1;
               
                contact con = new contact();
                con.accountid=acc1.id;
                con.lastname='xyz';
                con.firstname='rar';
                con.Marketing_Name__c='mat';
                con.npi__c='1851364921';
                con.Salutation = 'Dr.';
                con.Birthdate__c = Date.Parse('5/15/2015');
                con.Phone = '96532';
                con.Degree__c ='OD';
                con.CAQH_ID__c='9999';
                con.Doctor_Type__c='S - School Faculty Provider';
                con.Email ='test@123.com';
                con.Vision_Care_Effective_Date__c=date.today();
              //  con.Vision_Care_End_Date__c=date.today().adddays(2);
              //  con.Date_of_CMS_Medicare_Application_Submiss__c = Date.Today();
                con.Ethnicity__c ='Other';
                con.Medicare_ID_Number__c ='Med11';
                con.Accommodates_Children_0_3_years__c = True;
                con.Accommodates_Children_3_5_years__c = True;
                con.Specializes_in_Hard_to_fit_Contacts__c = True;
                con.Specializes_in_Low_Vision__c = True;
                con.Specializes_in_Vision_Therapy__c = True;
                insert con;
              //  system.assertNotEquals(con.Email,'test@12345.com');
                
                Contact_Role__c role = new Contact_Role__c();
                role.Account__c = acc1.id; 
                role.contact__c  = Con.id;
                role.Type__c  = 'Doctor-Employee';
                role.Start_Date__c = Date.Today();
        		role.VSP_Network_Provider__c = TRUE;
                insert role;
                
        		General_Table__c GT = new General_Table__c();
        		GT.Name = 'VSP';
        		GT.Table__c = 'PRSP';
        		GT.Status__c = 'Active';
        		insert GT;
        
        		General_Table__c GT1 = new General_Table__c();
        		GT1.Name = 'CHOIC';
        		GT1.Table__c = 'PRSP';
        		GT1.Status__c = 'Active';
        		insert GT1;
        
        		Network_Relationship__c netRel = new Network_Relationship__c();
        		netRel.Contact_Role__c = role.Id;
        		netRel.Program_ID__c = GT1.Id;
        		netRel.Program_Effective_Date__c = Date.today();
                netRel.Claims_Priced__c = 'Y';
        		insert netRel;
        
        try{delete netRel;}
        catch(Exception e){System.assertEquals(true, ApexPages.hasMessages(), 'A claim has been priced against this Network Relationship. It cannot be deleted.');}
        		    
                
        		
        
        
        
    }

}