/** 
     * Class Name: VSPR1_RelocateControllerTest
     * @author: Jinky M. N. Salvador
     * Date: 12.JUL.2013 
     * Requirement/Project Name: VSP 
     * @description: Test class for VSPR1_RelocateController class.  
     */

public class VSPR1_RelocateControllerTest {
    
    static testMethod void unitTest() {     
        
        List<Account> accList = new List<Account>();
        for(integer i=0;i<2;i++){
            Account acc = new Account();
            acc.Name = 'Sample Account';
            acc.Status__c = 'New';
            accList.add(acc);
        }
        
        insert accList;
        
        Contact cont = new Contact();
        cont.AccountId = accList[0].id;
        cont.LastName = 'Sample Contact';
        cont.Birthdate__c = system.today();
        cont.Vision_Care_Network_Provider__c = true;
        cont.Marketing_Name__c = 'Marketing Name';
        insert cont;
        
        Contact_Role__c cRole = new Contact_Role__c();
        cRole.Account__c = accList[0].id;
        cRole.Contact__c = cont.Id;
        cRole.Type__c = 'Accounting';
        cRole.Start_Date__c = system.today();
        insert cRole;
        
        Task task = new Task();
        task.WhoId = cont.id;
        task.Status = 'Not Started';
        task.Subject = 'Sample Subject';
        insert task;
        
        PageReference pageRef = Page.VSPR1_Relocate;      
        pageRef.getParameters().put('cid',cont.id);
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(cRole);
        // create an instance of the controller
        VSPR1_RelocateController controller = new VSPR1_RelocateController(sc);
        controller.getcRole();
        /*
        controller.oContactRole.Contact__r.BirthDate = system.today();
        controller.oContactRole.Type__c = 'Doctor';
        controller.oContactRole.Start_Date__c = system.today();
        controller.oContactRole.End_Date__c = system.today();
        controller.oContactRole.Account__c = accList[1].id; 
        */       
        controller.DoSave();
        
        cont.Birthdate__c = null;
        cont.AccountId = accList[1].id;
        update cont;
        controller.getcRole();
        
        List<Contact> contList =  new List<Contact>();
        for(integer i=0;i<2;i++){
            Contact newCont = new Contact();
            newCont.AccountId = accList[0].id;
            newCont.LastName = 'Sample Contact';
            newCont.Birthdate__c = system.today();
            newCont.Marketing_Name__c = 'Marketing Name';
            newCont.Vision_Care_Network_Provider__c = true;
            contList.add(newCont);
        }
        insert contList;
        
        delete cont;       
    }
    
     static testMethod void unitTest2() {     
        
        List<Account> accList = new List<Account>();
        for(integer i=0;i<2;i++){
            Account acc = new Account();
            acc.Name = 'Sample Account';
            acc.Status__c = 'New';
            accList.add(acc);
        }
        
        insert accList;
        
        Contact cont = new Contact();
        cont.AccountId = accList[0].id;
        cont.LastName = 'Sample Contact';
        cont.Birthdate__c = system.today();
        cont.Vision_Care_Network_Provider__c = true;
        cont.Marketing_Name__c = 'Marketing Name';
        insert cont;
        
        Contact_Role__c cRole = new Contact_Role__c();
        cRole.Account__c = accList[0].id;
        cRole.Contact__c = cont.Id;
        cRole.Type__c = 'Accounting';
        cRole.Start_Date__c = system.today();
        cRole.End_Date__c = system.today() - 1;
         try{ 
              Test.startTest();
        insert cRole;
              Test.stopTest();
         }
         catch(DMLException e){
             System.debug('>>> ERROR ='+e);
             system.assert(e.getMessage().contains('Setting the “Contact Role End date” that precedes the “Contact Role Start Date” is not allowed'), 'message=' + e.getMessage());
         }
         
        Task task = new Task();
        task.WhoId = cont.id;
        task.Status = 'Not Started';
        task.Subject = 'Sample Subject';
        insert task;
        
        PageReference pageRef = Page.VSPR1_Relocate;      
        pageRef.getParameters().put('cid',cont.id);
        System.Test.setCurrentPage(pageRef); 
        //Instantiate and construct the controller class.     
        ApexPages.StandardController sc = new ApexPages.standardController(cRole);
        // create an instance of the controller
        VSPR1_RelocateController controller = new VSPR1_RelocateController(sc);
        controller.getcRole();
         controller.Roletype = 'Test';
         controller.curRoleEndDate = Date.today();
        /*
        controller.oContactRole.Contact__r.BirthDate = system.today();
        controller.oContactRole.Type__c = 'Doctor';
        controller.oContactRole.Start_Date__c = system.today();
        controller.oContactRole.End_Date__c = system.today();
        controller.oContactRole.Account__c = accList[1].id; 
        */  
          
             
        controller.DoSave();
             
         
        cont.Birthdate__c = null;
        cont.AccountId = accList[1].id;
        update cont;
        controller.getcRole();
        
        List<Contact> contList =  new List<Contact>();
        for(integer i=0;i<2;i++){
            Contact newCont = new Contact();
            newCont.AccountId = accList[0].id;
            newCont.LastName = 'Sample Contact';
            newCont.Birthdate__c = system.today();
            newCont.Marketing_Name__c = 'Marketing Name';
            newCont.Vision_Care_Network_Provider__c = true;
            contList.add(newCont);
        }
        insert contList;
        
        delete cont; 
       
         
    }
}