@isTest
public class VSPR31_GRGR_Validation_Test {
    @testSetup
    public static void VSPR31_GRGR_Validation_Test_Data(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        Id grpTaxIdRollupContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
        
        //Get the profile to use for a new user so that we can run methods as that user.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Premier Support User' LIMIT 1];
        User u = new User();
        u.LastName = 'Test';
        u.Alias = 'Test007';
        u.Username = 'Test007@noemail.com.test';
        u.Email = 'Test007@noemail.com';
        u.profileId = p.Id;   
        u.emailencodingkey = 'UTF-8';
        u.languagelocalekey = 'en_US';
        u.localesidkey = 'en_US';
        u.timezonesidkey = 'America/Los_Angeles';
        u.country = 'United States';
        insert u;
        
        Account pa = new Account();
        pa.Name = 'Practe Test Account';
        pa.RecordTypeId = accRecordTypeId;
        pa.Status__c = 'A';
        pa.Vision_Care_Effective_Date__c = system.today() - 15;
        pa.Tax_ID__c = '123456789';
        insert pa;
        
        Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
        grg.RecordTypeId = grpContractRecordTypeId;
        grg.Name = 'CONTRACTTYPETESTGRP';
        grg.Start_Date__c = System.Today()-10;
        grg.Tier_Agreement_Type__c = null;
        grg.End_Date__c = null;
        grg.Contract_Type__c = 'Independent';
        insert grg;
        
        Global_Rewards_Group_Relationship__c grgr = new Global_Rewards_Group_Relationship__c();
        grgr.Active__c = True;
        grgr.Child_Account__c = pa.Id;
        grgr.End_Date__c = null;
        grgr.Global_Rewards_Group__c = grg.Id;
        grgr.Start_Date__c = System.Today()-10;
        insert grgr; 
        
        Global_Rewards_Group__c grg2 = new Global_Rewards_Group__c();
        grg2.RecordTypeId = grpTaxIdRollupContractRecordTypeId;
        grg2.Name = 'TAXIDROLLUPCONTRACTTESTGRP';
        grg2.Start_Date__c = System.Today()-10;
        grg2.Tier_Agreement_Type__c = null;
        grg2.End_Date__c = null;
        grg2.Contract_Type__c = 'Independent';
        insert grg2;
        
        Global_Rewards_Group_Relationship__c grgr2 = new Global_Rewards_Group_Relationship__c();
        grgr2.Active__c = True;
        grgr2.Child_Account__c = pa.Id;
        grgr2.End_Date__c = null;
        grgr2.Global_Rewards_Group__c = grg2.Id;
        grgr2.Start_Date__c = System.Today()-10;
        insert grgr2; 
    }
    @isTest
    public static void VSPR31_GRGR_Validation_Test_UpdateMethod(){
        Global_Rewards_Group__c grg = [SELECT Id, RecordTypeId FROM Global_Rewards_Group__c WHERE Name = 'CONTRACTTYPETESTGRP' LIMIT 1];
        Global_Rewards_Group_Relationship__c grgr = [SELECT Id FROM Global_Rewards_Group_Relationship__c WHERE Global_Rewards_Group__c =: grg.Id LIMIT 1];

        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        System.runAs(u){
            grgr.End_Date__c = System.Today()+10;
            try{
                update grgr;
            } catch(DmlException e){
                System.assert(e.getMessage().contains('You cannot add or edit Relationships on this Global Rewards Group'),e.getMessage());
            }                          
        }
    }
    @isTest
    public static void VSPR31_GRGR_Validation_Test_DeleteMethod(){
        Global_Rewards_Group__c grg = [SELECT Id, RecordTypeId FROM Global_Rewards_Group__c WHERE Name = 'TAXIDROLLUPCONTRACTTESTGRP' LIMIT 1];        
        Global_Rewards_Group_Relationship__c grgr = [SELECT Id FROM Global_Rewards_Group_Relationship__c WHERE Global_Rewards_Group__c =: grg.Id LIMIT 1];
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        System.runAs(u){
            try{
                delete grgr;

            } catch(DmlException e){
                System.assert(e.getMessage().contains('You cannot add or edit Relationships on this Global Rewards Group'),e.getMessage());
            }                          
        }
    }
}