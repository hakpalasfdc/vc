/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(seealldata=false)
private class VSPR19b_RelationshipTypesConBatch1Test {

    static testMethod void myUnitTest() {
        /*uery = 'SELECT c.Id, c.Name, c.AccountId, c.Vision_Care_Relationship_Type_s__c, 
        
        c.Doctor_Type__c, c.Vision_Care_End_Date__c, c.Vision_Care_Effective_Date__c,
         c.VC__c, c.RecordType.Name FROM Contact c WHERE
          (c.Vision_Care_End_Date__c >=: todayDate OR c.Vision_Care_End_Date__c = NULL) 
          AND c.Vision_Care_Effective_Date__c <=: todayDate AND 
          c.AccountId IN  ORDER BY c.Name ASC'; 
          */ 

            list<account> lstAcnt = new list<account>();
                Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc = new account();
                acc.name='test';
                acc.recordTypeId = recordtype;
                acc.email__c='abc@gmail.com';
                acc.Tax_ID__c = '345433589';
                acc.Fax = '223456';
                acc.Phone = '96532';
                acc.shippingStreet = '11US';
                acc.Account_Type__c = 'Business Account';
                acc.Zipcode__c= '01001' ;
                acc.Account_Group_Sub_Type__c='ab';
                acc.Vision_Care_Effective_Date__c=date.today();
                acc.Vision_Care_End_Date__c=date.today().adddays(2);
                acc.Location_type__c='M - VSP Member Location';
                Test.StartTest();
                VSPUtility.stopAccountTrigger=true;
                insert acc;
               
                contact con = new contact();
                con.accountid=acc.id;
                con.lastname='xyz';
                con.firstname='rar';
                con.Marketing_Name__c='mat';
                con.npi__c='1851364921';
                con.Salutation = 'Dr.';
                con.Birthdate__c = Date.Parse('5/15/2015');
                con.Phone = '96532';
                con.Degree__c ='OD';
                con.CAQH_ID__c='9999';
                con.Doctor_Type__c='M - VSP Member Doctor';
                con.Email ='test@123.com';
                con.Vision_Care_Effective_Date__c=date.today();
                con.Vision_Care_End_Date__c=date.today().adddays(2);
                con.Date_of_CMS_Medicare_Application_Submiss__c = Date.Today();
                con.Ethnicity__c ='Other';
                con.Medicare_ID_Number__c ='Med11';
                con.Accommodates_Children_0_3_years__c = True;
                con.Accommodates_Children_3_5_years__c = True;
                con.Specializes_in_Hard_to_fit_Contacts__c = True;
                con.Specializes_in_Low_Vision__c = True;
                con.Specializes_in_Vision_Therapy__c = True;
                insert con;
                system.assertNotEquals(con.Email,'test@12345.com');
                
                Contact_Role__c role = new Contact_Role__c();
                role.Account__c = acc.id; 
                role.contact__c  = Con.id;
                role.Type__c  = 'Doctor-Employee';
                role.Start_Date__c = Date.Today();
                insert role;
                
                Network_Recruitment__c net = new Network_Recruitment__c();
                net.npi__c='1851364921';
                net.Recruitment_Type__c='Doctor Initiated';
                net.Recruitment_Status__c = 'New Lead';
                net.Doctor_id__c='12345';
                net.Additional_Office_Locations__c ='11234 Arizona Phoenix A38 11234';
                net.Contact_Role__c = role.id;
                net.ownerId = userInfo.getUserId();
                insert net;
                system.assertEquals(net.Recruitment_Status__c,'New Lead');
                system.assertEquals(net.Recruitment_Type__c,'Doctor Initiated');
                
                task t = new task();
                t.whatID =net.id;
                t.Subject ='Duplicate VSP  Doctor Request Submitted';
                t.Type ='Outbound Call';
                t.Status = 'Not Started';
                t.Priority ='Normal';
                t.ActivityDate =Date.Today() + 7; 
                t.ReminderDateTime =DateTime.Now().addHours(48);
                t.OwnerId  = net.ownerId;
                insert t;
                VSPUtility.stopAccountTrigger=true;
                update acc;
                
                
                VSPR9_AutoGenerateNetworkRecruitment autoGen = new VSPR9_AutoGenerateNetworkRecruitment();
                
                
                
                VSPR9_AutoGenerateNetworkRecruitment autoGenerateNw = new VSPR9_AutoGenerateNetworkRecruitment();
             VSPR19b_RelationshipTypesContactBatch activeNetRelsVC = new VSPR19b_RelationshipTypesContactBatch();
   			Database.ExecuteBatch(activeNetRelsVC,1); 
   			Test.StopTest();
         
        
    }
    
    static testMethod void myUnitTest2() {
        /*uery = 'SELECT c.Id, c.Name, c.AccountId, c.Vision_Care_Relationship_Type_s__c, 
        
        c.Doctor_Type__c, c.Vision_Care_End_Date__c, c.Vision_Care_Effective_Date__c,
         c.VC__c, c.RecordType.Name FROM Contact c WHERE
          (c.Vision_Care_End_Date__c >=: todayDate OR c.Vision_Care_End_Date__c = NULL) 
          AND c.Vision_Care_Effective_Date__c <=: todayDate AND 
          c.AccountId IN  ORDER BY c.Name ASC'; 
          */ 

            list<account> lstAcnt = new list<account>();
                Id recordtype =[select Id from recordType where Name ='Business Account' and sObjectType ='Account' limit 1].Id;
                account acc = new account();
                acc.name='test';
                acc.recordTypeId = recordtype;
                acc.email__c='abc@gmail.com';
                acc.Tax_ID__c = '345433589';
                acc.Fax = '223456';
                acc.Phone = '96532';
                acc.shippingStreet = '11US';
                acc.Account_Type__c = 'Business Account';
                acc.Zipcode__c= '01001' ;
                acc.Account_Group_Sub_Type__c='ab';
                acc.Vision_Care_Effective_Date__c=date.today();
                acc.Vision_Care_End_Date__c=date.today().adddays(2);
                acc.Location_type__c='M - VSP Member Location';
                Test.StartTest();
                VSPUtility.stopAccountTrigger=true;
                insert acc;
               
                contact con = new contact();
                con.accountid=acc.id;
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
                con.Vision_Care_End_Date__c=date.today().adddays(2);
                con.Date_of_CMS_Medicare_Application_Submiss__c = Date.Today();
                con.Ethnicity__c ='Other';
                con.Medicare_ID_Number__c ='Med11';
                con.Accommodates_Children_0_3_years__c = True;
                con.Accommodates_Children_3_5_years__c = True;
                con.Specializes_in_Hard_to_fit_Contacts__c = True;
                con.Specializes_in_Low_Vision__c = True;
                con.Specializes_in_Vision_Therapy__c = True;
                insert con;
                system.assertNotEquals(con.Email,'test@12345.com');
                
                Contact_Role__c role = new Contact_Role__c();
                role.Account__c = acc.id; 
                role.contact__c  = Con.id;
                role.Type__c  = 'Doctor-Employee';
                role.Start_Date__c = Date.Today();
                insert role;
                
                Network_Recruitment__c net = new Network_Recruitment__c();
                net.npi__c='1851364921';
                net.Recruitment_Type__c='Doctor Initiated';
                net.Recruitment_Status__c = 'New Lead';
                net.Doctor_id__c='12345';
                net.Additional_Office_Locations__c ='11234 Arizona Phoenix A38 11234';
                net.Contact_Role__c = role.id;
                net.ownerId = userInfo.getUserId();
                insert net;
                system.assertEquals(net.Recruitment_Status__c,'New Lead');
                system.assertEquals(net.Recruitment_Type__c,'Doctor Initiated');
                
                task t = new task();
                t.whatID =net.id;
                t.Subject ='Duplicate VSP  Doctor Request Submitted';
                t.Type ='Outbound Call';
                t.Status = 'Not Started';
                t.Priority ='Normal';
                t.ActivityDate =Date.Today() + 7; 
                t.ReminderDateTime =DateTime.Now().addHours(48);
                t.OwnerId  = net.ownerId;
                insert t;
                VSPUtility.stopAccountTrigger=true;
                update acc;
                
                DSSendtoBackend av=new DSSendtoBackend(userinfo.getuserid(),role.id,'23424',system.now());
                DSSendtoQueue.sobjectsListRequests sd=new DSSendtoQueue.sobjectsListRequests();
                sd.UID=userinfo.getuserid();
                sd.OBID=role.id;
                sd.phoneNum='23424';
                sd.callBackTime=system.now();
                DSSendtoQueue.DSSendtoQueue(new List<DSSendtoQueue.sobjectsListRequests>{sd});
                
                
                
                
                
                
   			VSPR19b_NetRelationshipsVisionCareBatch activeNetRelsVC1 = new VSPR19b_NetRelationshipsVisionCareBatch();
   			Database.ExecuteBatch(activeNetRelsVC1,1); 
   			Test.StopTest();
   			
   			VSPR2_UpdateContactRoleBatch hj=new VSPR2_UpdateContactRoleBatch();
   			Database.ExecuteBatch(hj,1); 
         
        
    }
}