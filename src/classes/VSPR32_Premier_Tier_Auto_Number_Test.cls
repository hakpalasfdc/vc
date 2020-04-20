@isTest
private class VSPR32_Premier_Tier_Auto_Number_Test {
    
    @testSetup private static void createTierRecords(){
        
        Premier_Tier__c t = new Premier_Tier__c();
        t.Name = 'Ultimate Tier';
        t.Hierarchy_Action__c = 'Top_Tier';
        t.Hierarchy_Selection__c = NULL;
        t.Description__c = 'Ultimate Tier Test';
        t.Effective_Date__c = Date.today() - 5; 
        //t.End_Date__c = Date.today() +10;
        t.Status__c = 'Active';
        t.Contract_Type__c = 'Affiliate'; 
        Test.startTest();
        insert t;
        Test.stopTest();
    }
    private testmethod static void createNewTier(){
        
        try{
            Premier_Tier__c p = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Ultimate Tier'];
            p.Tier_Name_AutoNumber__c = 32000;
            update p;
            
            Premier_Tier__c t = new Premier_Tier__c();
            t.Name = 'Ultimate Tier 2';
            t.Hierarchy_Action__c = '<'; 
            t.Hierarchy_Selection__c = p.Id;
            t.Description__c = 'Ultimate Tier Test';
            t.Effective_Date__c = Date.today() - 5; 
            //t.End_Date__c = Date.today() +10;
            t.Status__c = 'Active';
            t.Contract_Type__c = 'Affiliate'; //Contract Ultimate Tier
            
            Test.startTest();
            insert t;
            Test.stopTest();
        }
        catch(Exception e){
           
            System.Assert(e.getMessage().contains('The Max Number of Tiers has been met'));
        }
        
    }
    
    private testmethod static void deleteTier(){
        
        Premier_Tier__c p = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Ultimate Tier'];
        Premier_Tier__c t = new Premier_Tier__c();
            t.Name = 'Ultimate Tier 2';
            t.Hierarchy_Action__c = '<'; 
            t.Hierarchy_Selection__c = p.Id;
            t.Description__c = 'Ultimate Tier Test';
            t.Effective_Date__c = Date.today() - 5; 
            //t.End_Date__c = Date.today() +10;
            t.Status__c = 'Active';
            t.Contract_Type__c = 'Affiliate'; //Contract Ultimate Tier
            
            Test.startTest();
            insert t;
        	delete t;
            Test.stopTest();
        
        p = [SELECT Id, Tier_Name_Id__c, Tier_Name_AutoNumber__c FROM Premier_Tier__c WHERE Name = 'Ultimate Tier'];
        system.assertEquals(p.Tier_Name_Id__c, 1);
        system.assertEquals(p.Tier_Name_AutoNumber__c, 2);
    }    
}