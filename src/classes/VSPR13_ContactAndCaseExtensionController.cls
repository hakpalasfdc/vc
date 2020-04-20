public class VSPR13_ContactAndCaseExtensionController
{
    public Case objCase {get;set;}
    public Contact objcontact {get;set;}
    public String contactid{get;set;}
    public String acc{get;set;}
    public String selectedrecordType{get;set;}
    public String caseSelectedRecordType{get;set;}
   
    public VSPR13_ContactAndCaseExtensionController(ApexPages.StandardController controller) {
         Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
         objCase = new Case(); 
         this.objcontact = new Contact(); 
         this.objcontact = (Contact)controller.getrecord();  
         String AccountId = ApexPages.currentPage().getParameters().get('accid'); objcontact.AccountId = (Id)AccountId;     
         objcontact.AccountId = '0010U00000onxlU'; //AS part of the POST-DEPLOYMENT STEP this is to be changed to account ID : 001U000001jMD3W (of 'VSP Consumer' account)         
         //Case defaults
         objCase.Line_of_Business__c = 'Retail'; 
         objCase.Origin = 'Phone'; 
         objCase.Type = 'Issue'; 
       //  objCase.RecordTypeId = CaseRecordType__c.getInstance('Eyeconic').Id__c;    
         objCase.RecordTypeId = caseRecordTypeId;
    }     
    
    public PageReference save()
    {    
       try
       {                
          if(selectedrecordType == 'Consumer') { 
            String strRecordTypeId=[SELECT Id 
                                    FROM RecordType 
                                    WHERE SObjectType = 'Contact' 
                                    AND Name='Consumer'].Id; 
                                    objcontact.RecordTypeId = strRecordTypeId; }
          if(caseSelectedRecordType == 'Eyeconic') { 
            String caseRecordTypeId=[SELECT Id 
                                     FROM RecordType 
                                     WHERE SObjectType = 'Case' 
                                     AND Name='Eyeconic'].Id; 
                                     objCase.RecordTypeId = caseRecordTypeId; }
          objcase.AccountId = objcontact.AccountId;           
          Insert objCase; Insert objcontact;
          objCase.ContactId = objcontact.Id; 
          objCase.AccountId = objcontact.AccountId; 
          Upsert objCase;       
          
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
       PageReference pageRef = new pageReference('/003/o'); pageRef.setRedirect(true);
       return pageRef;        
   }
    
   public PageReference doSaveAndNew(){ try { if(selectedrecordType == 'Consumer'){ String strRecordTypeId=[SELECT Id FROM RecordType WHERE SObjectType = 'Contact' AND Name='Consumer'].Id; objcontact.RecordTypeId = strRecordTypeId;} if(caseSelectedRecordType == 'Eyeconic'){ String caseRecordTypeId=[SELECT Id FROM RecordType WHERE SObjectType = 'Case' AND Name='Eyeconic'].Id; objCase.RecordTypeId = caseRecordTypeId;}
          objcase.AccountId = objcontact.AccountId; Insert objCase; Insert objcontact; objCase.ContactId = objcontact.Id; objCase.AccountId = objcontact.AccountId; Upsert objCase;  PageReference pageRef = new pageReference('/apex/VSPR5_ContactVFP?accid='+objcontact.AccountId+'&retURL=%2F003K000000pBTKt&save_newsfdc.override=1'); pageRef.setRedirect(true); return pageRef; } catch(DmlException ex){ ApexPages.addmessages(ex); return null;}
   
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