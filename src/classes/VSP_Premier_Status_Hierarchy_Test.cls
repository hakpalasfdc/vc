@isTest
public class VSP_Premier_Status_Hierarchy_Test {
    
    @TestSetup
    static void testData(){
        
        Premier_Tier__c FirstT = new Premier_Tier__c();
        FirstT.Name = 'First';
        FirstT.Description__c = 'First Description';
        FirstT.Effective_Date__c = system.today();
        FirstT.Hierarchy_Action__c = 'Top_Tier';
        FirstT.Status__c = 'Active';
        FirstT.Contract_Type__c = 'Contract Top Tier Test1';
        
        insert FirstT;
        
        Premier_Tier__c SecondT = new Premier_Tier__c();
        SecondT.Name = 'Second';
        SecondT.Description__c = 'Second Description';
        SecondT.Effective_Date__c = system.today();
        SecondT.Hierarchy_Action__c = '<';
        SecondT.Hierarchy_Selection__c = FirstT.Id;
        SecondT.Status__c = 'Active';
        SecondT.Contract_Type__c = 'Contract 2';
        
        insert SecondT;
        
        Premier_Tier__c ThirdT = new Premier_Tier__c();  
        ThirdT.Name = 'Third';
        ThirdT.Description__c = 'Third Description';
        ThirdT.Effective_Date__c = system.today() - 2;
        ThirdT.End_Date__c = system.today() + 3;
        ThirdT.Hierarchy_Action__c = '<';
        ThirdT.Hierarchy_Selection__c = SecondT.Id;
        ThirdT.Status__c = 'Active';
        ThirdT.Contract_Type__c = 'Contract 3';
        
        insert ThirdT;
    }
    
    static testmethod void updateRecords(){    
        //  Premier_Tier__c second = [Select Id FROM Premier_Tier__c WHERE Name = 'Second'];      
        Premier_Tier__c third = [Select Id, Status__c FROM Premier_Tier__c WHERE Name = 'Third']; 
        //   second.Effective_Date__c = Date.today() - 1;
        third.End_Date__c = system.today() - 1;
        Test.startTest();
        //   update second;
        update third;
        //   system.assertEquals('Inactive', third.Status__c);
        Test.stopTest();      
    }
    
    static testmethod void updateRecords2(){
        
        Premier_Tier__c first = [Select Id, Status__c FROM Premier_Tier__c WHERE Name = 'First']; 
        first.End_Date__c = system.today() - 1;
        
        Test.startTest();
        update first;
        Test.stopTest();      
    }
    
    static testmethod void insertNew(){
        
        Premier_Tier__c third = [Select Id, Status__c FROM Premier_Tier__c WHERE Name = 'Third'];
        Premier_Tier__c forth = new Premier_Tier__c();  
        forth.Name = 'Forth';
        forth.Description__c = 'Forth Description';
        forth.Effective_Date__c = system.today() - 5;
        forth.Hierarchy_Action__c = '<';
        forth.Hierarchy_Selection__c = third.Id;
        forth.Status__c = 'Inactive';
        forth.Contract_Type__c = 'Contract 4';
        
        Test.startTest();
        insert forth;
        Test.stopTest();
    }
    
    static testmethod void insertNew2(){
        
        Premier_Tier__c third = [Select Id, Status__c FROM Premier_Tier__c WHERE Name = 'Third'];
        Premier_Tier__c forth = new Premier_Tier__c();  
        forth.Name = 'Forth';
        forth.Description__c = 'Forth Description';
        forth.Effective_Date__c = system.today() - 5;
        forth.Hierarchy_Action__c = 'Top_Tier';
        forth.Status__c = 'Inactive';
        forth.Contract_Type__c = 'Contract 4';
        
        Test.startTest();
        insert forth;
        Test.stopTest();
    }
    
}