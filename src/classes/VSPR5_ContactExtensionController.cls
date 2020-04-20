public class VSPR5_ContactExtensionController
{
    public Contact_Role__c objCrole {get;set;}
    public Contact objcontact {get;set;}
    public String contactid{get;set;}
    public String acc{get;set;}
    public Boolean renderFlagVisionCareDetails {get; set;}
    
    public String clientRecordTypeId{get;set;}
    public String consumerRecordTypeId{get;set;}
    public String ECPRecordTypeId{get;set;}
    

    public VSPR5_ContactExtensionController(ApexPages.StandardController controller) {
         renderFlagVisionCareDetails = false;
         objCrole = new Contact_Role__c();
         this.objcontact = new Contact();
         this.objcontact = (Contact)controller.getrecord();  
         String AccountId = ApexPages.currentPage().getParameters().get('accid'); 
         objcontact.AccountId = (Id)AccountId;   
         clientRecordTypeId = New_Contact_and_ContactRole__c.getInstance('Client').Id__c;
         consumerRecordTypeId = New_Contact_and_ContactRole__c.getInstance('Consumer').Id__c;
         ECPRecordTypeId = New_Contact_and_ContactRole__c.getInstance('ECP').Id__c;
         
         Id profileId = userinfo.getProfileId();
         String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
         Id userId = userInfo.getUserId();
         
         List<PermissionSetAssignment> listPSA = [SELECT id, PermissionSetId
                                        FROM PermissionSetAssignment
                                        WHERE AssigneeId = :userId];
        Set<Id> ids = new set<Id>();
        for (PermissionSetAssignment PSA : listPSA) {
            ids.add(PSA.PermissionSetId);
        }

        List<PermissionSet> listPS = [Select name from PermissionSet where id in :ids];
        System.debug('#### listPS: ' + listPS);
        boolean permissionSetFound = false;
        for (PermissionSet PS: listPS) {
            if (PS.Name == 'Credentialing_Data_Manager')                permissionSetFound = true;
        }
        
        System.debug('#### permissionSetFound ' + permissionSetFound);
         
        if (profileName == 'VSP Network Recruitment User' || profileName == 'VSP Network Recruitment Management User' || profileName == 'System Administrator' || permissionSetFound == true)
            renderFlagVisionCareDetails = true;
    }

          
   
    public PageReference save()
    {    
       try
       {          
          Insert objcontact;
          
          objCrole.Contact__c = objcontact.Id;
          objCrole.Account__c = objcontact.AccountId;
          
          if((objcontact.RecordTypeId != clientRecordTypeId ) && (objcontact.RecordTypeId != consumerRecordTypeId)){    
              Insert objCrole; 
          }            
          
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
        
        objCrole.Contact__c = objcontact.Id;
        objCrole.Account__c = objcontact.AccountId;
        
        if((objcontact.RecordTypeId != clientRecordTypeId ) && (objcontact.RecordTypeId != consumerRecordTypeId)){   
              Insert objCrole; 
          }
           
        
        PageReference pageRef = new pageReference('/apex/VSPR5_ContactVFP?accid='+objcontact.AccountId+'&retURL=%2F003K000000pBTKt&save_newsfdc.override=1');
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