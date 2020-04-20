/**
* Class Name: VSPR1_Relocate
* @author: Marvin B. Gatchalian
* Date: 27.MAY.2013
* Requirement/Project Name: VSP
* @description: Handles relocation of contact to new Account and can create contact role.
*/


public class VSPR1_RelocateController {

    public string Roletype {get;set;}
    public string Myid {get;set;}   
    public string CurrentAccount {get;set;}
    public string CurrentAccountid {get;set;}
    public Contact_Role__c oContactRole;
    public string contactID {get;set;}
    public Contact contact {get;set;}
    public DateTime curRoleEndDate {get;set;}
    public List<Contact_Role__c> cRoleList;
    public Contact_Role__c oldContRole {get;set;} 
    public Boolean endDateValError {get;set;}
    
    public VSPR1_RelocateController(ApexPages.StandardController controller) {
        this.oContactRole = (Contact_Role__c)controller.getRecord();
        contactID = ApexPages.currentPage().getParameters().get('cid'); 
        Myid = contactID;
        Initialize();
    }
    
    Private void Initialize (){
        contact  = new Contact();
        contact  = [SELECT Account.name, AccountID,Birthdate__c from Contact  where id = :contactID];
        CurrentAccount = contact.Account.name;
        CurrentAccountid = contact.AccountId;
        
    }
    
    public List<Contact_Role__c> getcRole () {
          cRoleList = [Select Type__c,Contact__r.Birthdate__c from Contact_Role__c where 
          Account__c= :CurrentAccountid and Contact__c = :contactID];
          //system.assertEquals(cRoleList.size(),10);
          //cRoleList[0].Contact__r.BirthDate = null;
          
          try{              
                oldContRole = [Select id, Contact__r.Birthdate__c from Contact_Role__c LIMIT 1];
                oldContRole.Contact__r.Birthdate__c = null;
              
              //oldContRole = [Select id, Contact__r.BirthDate from Contact_Role__c where Account__c= :CurrentAccountid and Contact__c = :contactID LIMIT 1];              
                             
          }catch( Exception ex ){
          } 
          return cRoleList;
    }

   // public List<SelectOption> getRoletypes() {
   //     List<SelectOption> options = new List<SelectOption>();
   //   List<Schema.picklistEntry> PL = Contact_Role__c.fields.Type__c.getDescribe().getpicklistvalues();
   //     for(schema.PickListEntry p:PL){
   //         options.add(new selectoption(p.getLabel(), p.getvalue()));
   //   }
   //    return options;
   // }
      
    
     public Pagereference DoSave() {
        endDateValError = false;
        
        //system.assertEquals(a.Contact__r.BirthDate,date.today());
        
        //PageReference pageRef = new PageReference('/');
        //List <Contact_Role__c> a = getcrole();
        //system.assertequals (a[0].BirthDate, a[0].BirthDate + 1);
    
        Contact oContact = [select id,Accountid, Birthdate__c from Contact where id = :contactID];
        oContact.accountid = oContactRole.Account__c;
        oContact.IsFromVFPage__c = true;  
        
            
        //try{
        Savepoint sp = Database.setSavepoint();
                                                    
            update oContact;
            oContact.IsFromVFPage__c = false;
            update oContact;               
         //}catch( Exception ex ){
          //}
        
        
        
        /*
        Account account = [select id,Status__c from Account where id = :oContact.accountid LIMIT 1];
        account.Status__c = 'Pending Account';
        try{
           update account;            
          }catch( Exception ex ){
          }
        */
        
        /*
        Set<String> incStatus = new Set<String>();
        incStatus.add('Completed');
        incStatus.add('Deferred');
        */
                
        //List<Task> tasks = [Select WhoId, WhatId, Status from Task where Status NOT IN: incStatus and WhoId =: oContact.id];
        List<Task> tasks = [Select WhoId, WhatId, Status from Task where WhoId =: oContact.id];
        for (Task task : tasks){
            //.debug('Task-----' + task);
            if(!(task.Status == 'Completed' || task.Status == 'Deferred')){
                task.Status = 'Pending New Contact';
            }
            task.WhatId = CurrentAccountid;
            //task.WhoId = null;
            
            
            
        }
        //try{
           update tasks;            
          //}catch( Exception ex ){
          //}
        try{
            Contact_Role__c oContactR = new Contact_Role__c();
        oContactR.Contact__c = contactID;
        oContactR.Account__c = oContactRole.Account__c;
        oContactR.Type__c = oContactRole.Type__c;
        oContactR.Start_Date__c = oContactRole.Start_Date__c;
        oContactR.End_Date__c = oContactRole.End_Date__c;
        //oContactR.Status__c = 'Active';
        //system.assertEquals(a.Contact__r.BirthDate, oContactRole.End_Date__c);
        insert oContactR;
        
        List<Contact_Role__c> updateOldcRole = [Select Type__c,Contact__r.Birthdate__c from Contact_Role__c where Account__c= :CurrentAccountid and Contact__c = :contactID];
        for(Contact_Role__c old : updateOldcRole){
            //system.assertEquals(a.Contact__r.BirthDate,date.today());
            old.End_Date__c = oldContRole.Contact__r.Birthdate__c;
        }
        //try{
           update updateOldcRole;            
          //}catch( Exception ex ){
          //}                
        return new PageReference('/' + oContact.id);
        }catch (DmlException e){
            Database.rollback(sp);
            String error = e.getMessage();
            String validError = 'Setting the “Contact Role End date” that precedes the “Contact Role Start Date” is not allowed';
            
            if (error.contains(validError)){
                //system.assertEquals(error,'hi');
                    endDateValError = true;
                    //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Setting the “Contact Role End date” that precedes the “Contact Role Start Date” is not allowed.');
                    //ApexPages.addMessage(msg);
                    
                }
            return null;    
        }
        
        
        
    }
}