public class VSPR13_CaseExtensionController
{
    public Case objCase {get;set;}
    public Contact objcontact {get;set;}
    public String contactid{get;set;}
    public String acc{get;set;}
    

    public VSPR13_CaseExtensionController(ApexPages.StandardController controller) {
         objCase = new Case();
         this.objcontact = new Contact();
         this.objcontact = (Contact)controller.getrecord();  
         String AccountId = ApexPages.currentPage().getParameters().get('accid'); 
         objcontact.AccountId = (Id)AccountId;   
    }

          
   
    public PageReference save()
    {    
       try
       {          
          Insert objcontact;
          
          objCase.ContactId = objcontact.Id;
          objCase.AccountId = objcontact.AccountId;
                   
          Insert objCase;             
          
          PageReference pageRef = new pageReference('/apex/VSPR5_ContactRenameTab?id=' + objcontact.Id 
                                                      + '&salutation=' + objcontact.Salutation
                                                      + '&fname=' + objcontact.FirstName
                                                      + '&lname=' + objcontact.LastName);
          pageRef.setRedirect(true);
          return pageRef; 
       }
           
      catch(DmlException ex){
          ApexPages.addmessages(ex);
          return null;
       }
    }
   public PageReference cancel(){
       PageReference pageRef = new pageReference('/003/o');
       pageRef.setRedirect(true);
       return pageRef;        
   }
        
        
   public PageReference doSaveAndNew(){
    try
    {    
        Insert objcontact;
        
        objCase.ContactId = objcontact.Id;
          objCase.AccountId = objcontact.AccountId;
                   
          Insert objCase;  
           
        
        PageReference pageRef = new pageReference('/apex/Test?accid='+objcontact.AccountId+'&retURL=%2F003K000000pBTKt&save_newsfdc.override=1');
        pageRef.setRedirect(true);       
        return pageRef;
   }catch(DmlException ex){
      ApexPages.addmessages(ex);
      return null;
   }
   /*
    //Contact and Contact Role values are reset and 'Common Account Name' field is prepopulated with AccountId upon clicking save&new button 
    Id acctId = objcontact.AccountId;
    objcontact = new Contact();
    objcontact.AccountId = acctId ;    
    objCrole = new Contact_Role__c();
    objCrole.Start_Date__c = date.today();
    return null;
   */
   }
     
  }