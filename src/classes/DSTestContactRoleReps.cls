/***************************************************
Caileigh Brown, Implementation Engineer, 12/20/2016

Iterations:
1/3/2016
1/31/17, Caileigh Brown


Brief Description: Test for Trigger to copy User ID to
connect the User to Contact_Role. 
****************************************************/

@isTest
public class DSTestContactRoleReps{
    @isTest
    public static void testContactRoleUpdate()
    {
        List<User> saps = new List<User>();
        for(User u : [SELECT Id, MarketingID__c FROM User WHERE MarketingID__c <> null])
        {
            if(saps.size() <= 5 && u.MarketingID__c.startsWithIgnoreCase('ALT-R1'))
            {
                saps.add(u);
            } else if(saps.size() > 5){
                break;
            }
        }
        System.debug('DialSource : saps : ' + saps);
        //Setup Account, Contact, Contact_Role__c, Profile, and User necessary to make a Contact_Role__C Insert successfully for gat.
        Account Accts = new Account(Name = 'testgatacct', Altair_Standard__c = saps[0].MarketingID__c, Altair_Field_Rep__c = saps[1].MarketingID__c,
                                    Altair_Hybrid_Bebe__c = saps[2].MarketingID__c, Altair_Key_Account__c = saps[3].MarketingID__c);
        Contact_Role__c cr = new Contact_Role__c();
        Contact ctcts = new Contact(lastName = 'mctest');
        System.debug('DialSource : Accts : ' + Accts);
        
        List<User> altairs = [SELECT Id, Altair_SAP_Number__c FROM User WHERE Altair_SAP_Number__c <> null LIMIT 4];
        System.debug('DialSource : Altairs : ' + altairs);
        //Setup Account, Contact, Contact_Role__c, Profile, and User necessary to make a Contact_Role__C Insert successfully for AltairReps.
        Account AcctsAltair = new Account(Name = 'testgatacct');//For sap
        AcctsAltair.Altair_Reps__c = '' + altairs[0].Altair_SAP_Number__c + ',' + altairs[1].Altair_SAP_Number__c + ',' + altairs[2].Altair_SAP_Number__c + ',' + altairs[3].Altair_SAP_Number__c;
        Contact_Role__c cr2 = new Contact_Role__c();
        Contact ctcts2 = new Contact(lastName = 'mctest');
        
        
        
        
        //Begin Test.
        Test.startTest();

        
        //Initial DML. Accounts and Users first to avoid insertion error on Contact_Role__c insertion.

        insert Accts;
        insert AcctsAltair;
        

        ctcts.AccountId = Accts.Id;
        ctcts2.AccountId = AcctsAltair.Id;
        insert ctcts;
        insert ctcts2;

        
        cr.Account__c = Accts.Id;
        cr.Contact__c = ctcts.Id;
        cr2.Account__c = AcctsAltair.Id;
        cr2.Contact__c = ctcts2.Id;
        insert cr;
        insert cr2;
        
        //Test for AltairRepID.
        
        List<User> userList = [SELECT ID, Altair_SAP_Number__c FROM User];
        List<Contact_Role__c> crList = [SELECT ID FROM Contact_Role__c WHERE ID = :cr.Id];
        //userList[0].lastname = 'test mctesterson';
        //update userList;
        //update crList;
  
        System.debug('Programmer : CrList' + crList);
       	/*DSScheduledContactRoleReps TestObj = new DSScheduledContactRoleReps();
        String sch = '0 0 8 13 2 ?';
        system.schedule('Test DSScheduledContactRoleReps', sch, TestObj);*/
        
        DSBatchContactRoleReps batchJob = new DSBatchContactRoleReps();
        database.executebatch(batchJob);


        Test.stopTest();
    }
    
    
    
}