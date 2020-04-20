@isTest
private class testAccountHierarchy{
    
    static testMethod void testAccountHierarchy(){
        
        AccountHierarchyTestData.createTestHierarchy();
        
        Account topAccount      = [ Select id, name from account where name = 'HierarchyTest0' limit 1 ];
          
        Account[] accountList   = [ Select id, parentID, name from account where name like 'HierarchyTest%' ];
        
        test.startTest();  
        
        PageReference AccountHierarchyPage = Page.AccountHierarchyPage;
        Test.setCurrentPage( AccountHierarchyPage );
        ApexPages.currentPage().getParameters().put( 'id', topAccount.id );
        
        // Instanciate Controller
        AccountStructure controller = new AccountStructure(new ApexPages.StandardController(new Account()));
        
        // Call Methodes for top account
        controller.setcurrentId( null );
        AccountStructure.ObjectStructureMap[] smt1 = new AccountStructure.ObjectStructureMap[]{};
            smt1 = controller.getObjectStructure();
        System.Assert( smt1.size() > 0, 'Test failed at Top account, no Id' );
        
        controller.setcurrentId( String.valueOf( topAccount.id ) );
        AccountStructure.ObjectStructureMap[] smt2 = new AccountStructure.ObjectStructureMap[]{};
            smt2 = controller.getObjectStructure();
        System.Assert( smt2.size() > 0, 'Test failed at Top account, with Id: '+smt2.size() );
        
        //Call ObjectStructureMap methodes
        smt2[0].setnodeId( '1234567890' );
        smt2[0].setlevelFlag( true );
        smt2[0].setlcloseFlag( false );
        smt2[0].setnodeType( 'parent' );
        smt2[0].setcurrentNode( false );
        smt2[0].setaccount( topAccount );
        
        String nodeId       = smt2[0].getnodeId();
        Boolean[] levelFlag = smt2[0].getlevelFlag();
        Boolean[] closeFlag = smt2[0].getcloseFlag();
        String nodeType     = smt2[0].getnodeType();
        Boolean currentName = smt2[0].getcurrentNode();
        Account smbAccount  = smt2[0].getaccount();
           
        test.stopTest();
    }
    
    static testMethod void testAccountHierarchy2(){
        
        AccountHierarchyTestData.createTestHierarchy();
        
        Account middleAccount   = [ Select id, parentID, name from account where name = 'HierarchyTest4' limit 1 ];
        
        // Instanciate Controller
        AccountStructure controller = new AccountStructure(new ApexPages.StandardController(new Account()));
        test.startTest();  
        // Call Methodes for middle account
        controller.setcurrentId( String.valueOf( middleAccount.id ) );
        AccountStructure.ObjectStructureMap[] smm = new AccountStructure.ObjectStructureMap[]{};
            smm = controller.getObjectStructure();
        System.Assert( smm.size() > 0, 'Test failed at middle account' );
        test.stopTest();
    }
    
    static testMethod void testAccountHierarchy3(){
        
        AccountHierarchyTestData.createTestHierarchy();
        
        Account bottomAccount   = [ Select id, parentID, name from account where name = 'HierarchyTest9' limit 1 ];
        
        // Instanciate Controller
        AccountStructure controller = new AccountStructure(new ApexPages.StandardController(new Account()));
        test.startTest();  
        // Call Methodes for bottom account
        controller.setcurrentId( String.valueOf( bottomAccount.id ) );
        AccountStructure.ObjectStructureMap[] smb = new AccountStructure.ObjectStructureMap[]{};
            smb = controller.getObjectStructure();
        System.Assert( smb.size() > 0, 'Test failed at top account' );
        test.stopTest();
    }
    
    static testMethod void testAccountHierarchy4(){
        
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        ////Accounts
        Account prac = new Account();
        prac.Name = 'Prac Test Name';
        prac.RecordTypeId = accRecordTypeId;
        prac.Vision_Care_Effective_Date__c = Date.today();
        prac.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        test.startTest(); 
        insert prac;
        
        Account prac2 = new Account();
        prac2.Name = 'Prac2 Test Name';
        prac2.RecordTypeId = accRecordTypeId;
        prac2.Vision_Care_Effective_Date__c = Date.today();
        prac2.Vision_Care_Practice_Exception__c = 'AOFF - Non-VSP Location';
        prac2.ParentId = prac.Id;
        insert prac2;
        
        Account busacc = new Account();
        busacc.Name = 'Bus Test Name';
        busacc.RecordTypeId = accBusRecordTypeId;
        busacc.ParentId = prac.Id;
        busacc.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        busacc.Vision_Care_Effective_Date__c = Date.today();
        
        insert busacc;
        
        Account busacc2 = new Account();
        busacc2.Name = 'Bus Test Name';
        busacc2.RecordTypeId = accBusRecordTypeId;
        busacc2.ParentId = prac2.Id;
        busacc2.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        busacc2.Vision_Care_Effective_Date__c = Date.today();
        
        insert busacc2;
        
        //////Contacts
        Contact busContact = new Contact();
        busContact.FirstName = 'Con First Name';
        busContact.LastName = 'Con Last Name';
        busContact.AccountId = busacc.Id;
        busContact.Vision_Care_Doctor_Exception__c = 'ABO - Not ABO Certified';
        busContact.Vision_Care_Effective_Date__c = Date.today();
        
        insert busContact;
        
        Contact pracContact = new Contact();
        pracContact.FirstName = 'Con First Name';
        pracContact.LastName = 'Con Last Name';
        pracContact.AccountId = prac2.Id;
        pracContact.Vision_Care_Doctor_Exception__c = 'ABO - Not ABO Certified';
        pracContact.Vision_Care_Effective_Date__c = Date.today();
        
        insert pracContact;
        
        //////Contacts
        Contact busContact2 = new Contact();
        busContact2.FirstName = 'Con First Name';
        busContact2.LastName = 'Con Last Name';
        busContact2.AccountId = busacc2.Id;
        busContact2.Vision_Care_Doctor_Exception__c = 'ABO - Not ABO Certified';
        busContact2.Vision_Care_Effective_Date__c = Date.today();
        
        insert busContact2;
        
        
        /////Contact Roles
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = busacc.Id;
        cr.Contact__c = busContact.Id;
        
        insert cr;
        
        Contact_Role__c cr2 = new Contact_Role__c();
        cr2.Account__c = prac2.Id;
        cr2.Contact__c = pracContact.Id;
        
        insert cr2;
        
        Contact_Role__c cr3 = new Contact_Role__c();
        cr3.Account__c = busacc2.Id;
        cr3.Contact__c = busContact2.Id;
        
        insert cr3;
        
        // Instanciate Controller
        AccountStructure controller = new AccountStructure(new ApexPages.StandardController(new Account()));
        
        
        controller.setcurrentId( String.valueOf( prac.id ) );
        AccountStructure.ObjectStructureMap[] smb = new AccountStructure.ObjectStructureMap[]{};
            smb = controller.getObjectStructure();
        
        test.stopTest();
    }
    
    static testMethod void testAccountHierarchy5(){
        
        Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        
        Account busacc = new Account();
        busacc.Name = 'Bus Test Name';
        busacc.RecordTypeId = accBusRecordTypeId;
        //   busacc.ParentId = prac.Id;
        busacc.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        busacc.Vision_Care_Effective_Date__c = Date.today();
        test.startTest();
        insert busacc;
        
        Account busacc2 = new Account();
        busacc2.Name = 'Bus Test Name';
        busacc2.RecordTypeId = accBusRecordTypeId;
        busacc2.ParentId = busacc.Id;
        busacc2.Vision_Care_Location_Exception__c = 'AGT - Agreement Non-Compliance';
        busacc2.Vision_Care_Effective_Date__c = Date.today();
        
        insert busacc2;
        
        //////Contacts
        Contact busContact = new Contact();
        busContact.FirstName = 'Con First Name';
        busContact.LastName = 'Con Last Name';
        busContact.AccountId = busacc.Id;
        busContact.Vision_Care_Doctor_Exception__c = 'ABO - Not ABO Certified';
        busContact.Vision_Care_Effective_Date__c = Date.today();
        
        insert busContact;
        
        //////Contacts
        Contact busContact2 = new Contact();
        busContact2.FirstName = 'Con First Name';
        busContact2.LastName = 'Con Last Name';
        busContact2.AccountId = busacc2.Id;
        busContact2.Vision_Care_Doctor_Exception__c = 'ABO - Not ABO Certified';
        busContact2.Vision_Care_Effective_Date__c = Date.today();
        
        insert busContact2;
        
        /////Contact Roles
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = busacc.Id;
        cr.Contact__c = busContact.Id;
        
        insert cr;
        
        
        Contact_Role__c cr3 = new Contact_Role__c();
        cr3.Account__c = busacc2.Id;
        cr3.Contact__c = busContact2.Id;
        
        insert cr3;
        
        // Instanciate Controller
        AccountStructure controller = new AccountStructure(new ApexPages.StandardController(new Account()));
        
        controller.setcurrentId( String.valueOf( busacc.id ) );
        AccountStructure.ObjectStructureMap[] smb = new AccountStructure.ObjectStructureMap[]{};
            smb = controller.getObjectStructure();
        
        test.stopTest();
    }
}