@isTest(SeeAllData=false)
private class VSP_Premier_Tier_Dupe_Validation_Test {
    //Create test data
    @testSetup private static void createTierRecords(){
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
        
        //Create new Top Tier
        Premier_Tier__c t = new Premier_Tier__c();
        t.Name = 'Ultimate Tier';
        t.Hierarchy_Action__c = 'Top_Tier'; //SObjectType.Premier_Tier__c.Fields.Hierarchy_Action__c.PickListValues[1].getValue();
        t.Hierarchy_Selection__c = NULL;
        t.Description__c = 'Ultimate Tier Test';
        t.Effective_Date__c = Date.today() - 5; 
        //t.End_Date__c = Date.today() +10;
        t.Status__c = 'Active';
        t.Contract_Type__c = 'Affiliate'; //Contract Ultimate Tier
        t.Agreement_Type__c = 'DOLP1';
        insert t;
        
        //Create new Low Tier assigned to Top Tier
        Premier_Tier__c qt = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Ultimate Tier' LIMIT 1];
        
        Premier_Tier__c lt = new Premier_Tier__c();
        lt.Name = 'Low Tier';
        lt.Hierarchy_Action__c = '<';
        lt.Hierarchy_Selection__c = qt.Id;
        lt.Description__c = 'Low Tier Test';
        lt.Effective_Date__c = Date.today() - 1;
        lt.End_Date__c = Date.today() +1; 
        lt.Status__c = 'Active';
        lt.Contract_Type__c = 'AOP';//Contract Low Tier
        lt.Agreement_Type__c = 'DOLP1';
        insert lt;
        
        //Create new Low Tier assigned to Low Tier
        Premier_Tier__c qt2 = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Low Tier' LIMIT 1];
        
        Premier_Tier__c lt2 = new Premier_Tier__c();
        lt2.Name = 'Low Tier2';
        lt2.Hierarchy_Action__c = '<';
        lt2.Hierarchy_Selection__c = qt2.Id;
        lt2.Description__c = 'Low Tier Test2';
        lt2.Effective_Date__c = Date.today() - 1;
        lt2.Status__c = 'Future';
        lt2.Contract_Type__c = 'CAT2';//Contract Low Tier2
        lt2.Agreement_Type__c = 'DOLP1';
        insert lt2;
        
    } 
    //Create a new dupe Tier where Effective date and End date are within the range of an existing Tier
    @isTest
    private static void testInsertDupeTierRecord(){
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        Premier_Tier__c qt = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Status__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Low Tier' AND Status__c = 'Active' LIMIT 1];
        
        System.runAs(u){
            
            Premier_Tier__c t = new Premier_Tier__c();
            t.Name = 'Low Tier';
            t.Hierarchy_Action__c = '<';
            t.Hierarchy_Selection__c = qt.Id;
            t.Description__c = 'Low Tier Test';
            t.Effective_Date__c = qt.Effective_Date__c;
            t.End_Date__c = qt.Effective_Date__c + 5;
            t.Contract_Type__c = 'AOP';//Contract Low Tier
            t.Agreement_Type__c = 'DOLP1';
            try{
                insert t;
            } catch(DmlException e){
                System.assert(e.getMessage().contains('Tier with same Name, Agreement Type and Contract Type exists within the date range'),e.getMessage());
            }                          
        }
    }
    //Create a new duped Tier where it's effective date is not null but it's end date is
    @isTest 
    private static void testInsertDupeTierRecord2(){   
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        Premier_Tier__c qt = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Status__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Low Tier' AND Status__c = 'Active' LIMIT 1];
        
        System.runAs(u){
            
            Premier_Tier__c t2 = new Premier_Tier__c();
            t2.Name = 'Low Tier';
            t2.Hierarchy_Action__c = '<';
            t2.Hierarchy_Selection__c = qt.Id;
            t2.Description__c = 'Low Tier Test';
            t2.Effective_Date__c = qt.Effective_Date__c;
            t2.Contract_Type__c = 'AOP';//Contract Low Tier
            t2.Agreement_Type__c = 'DOLP1';
            try{
                insert t2;
            } catch(DmlException e){
                System.assert(e.getMessage().contains('Tier with same Name, Agreement Type and Contract Type exists within the date range'),e.getMessage());
            }  
        }
    }
        //Create a new duped Tier where it's the existing tier's end date is null
    @isTest 
    private static void testInsertDupeTierRecord3(){   
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        Premier_Tier__c qt = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Status__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Low Tier2' AND (Status__c = 'Active' OR Status__c = 'Future') LIMIT 1];
        
        System.runAs(u){
            
            Premier_Tier__c t3 = new Premier_Tier__c();
            t3.Name = 'Low Tier2';
            t3.Hierarchy_Action__c = '<';
            t3.Hierarchy_Selection__c = qt.Id;
            t3.Description__c = 'Low Tier Test';
            t3.Effective_Date__c = qt.Effective_Date__c + 1;
            t3.Contract_Type__c = 'CAT2';//Contract Low Tier2
            t3.Agreement_Type__c = 'DOLP1';
            try{
                insert t3;
            } catch(DmlException e){
                System.assert(e.getMessage().contains('Tier with same Name, Agreement Type and Contract Type exists within the date range'),e.getMessage());
            }  
        }
    }
    
      @isTest 
    private static void testUpdateTierName(){   
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        Premier_Tier__c qt = [SELECT Id, Name, Hierarchy_Action__c, Hierarchy_Selection__c, Effective_Date__c, End_Date__c, Status__c, Contract_Type__c FROM Premier_Tier__c
                              WHERE Name = 'Low Tier2' AND (Status__c = 'Active' OR Status__c = 'Future') LIMIT 1];
        
        System.runAs(u){
            
           qt.Name = 'LOW TIER';
            
            try{
                update qt;
            } catch(DmlException e){
                System.assert(e.getMessage().contains('Tier Name must be unique'),e.getMessage());
            }  
        }
    }
}