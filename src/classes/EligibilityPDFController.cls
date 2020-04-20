public class EligibilityPDFController{
	
    public String param1 { get; set; }

    public string cbkId {get; set;}
    public String sfURL=URL.getSalesforceBaseUrl().getHost();   
    public knowledge__kav cbk {get; set;}
    public string ID=apexpages.currentpage(). getParameters().get('id');
    //public boolean x;
    public Boolean highlightVersionComments{get;set;} 
    public Boolean checkIfDraft{get;set;}
     public Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();
              
    public String getart() {
        return ID;      
    }
    
    public String getsfurll() {
        //sfURL='https://vsp--knowledge.cs96.my.salesforce.com/';
        return sfURL;      
    }
          
    public String getReturnid() {
        return cbkId;
    }
        
    public PageReference setParams()
    {
    
        String sidetitle = 'Sidebar '+param1;
    system.debug('1'+param1);  

   // hiddenvaluesflag=false;
     //   toolbarflag = true;
        //mtpf=(Multi_Topic__kav)controller.getRecord();           
        //Getting the Article ID
        /* 
        switch on param1 {
        when 'Eligibility' {cbkId = 'kaH1g0000004ChREAU';} //apexpages.currentpage(). getParameters().get('id');  
        when 'Benefits' {cbkId = 'kaH1g0000004ELTEA2';}
        when 'Authorization' {cbkId = 'kaH1g0000004CrEEAU';}
        when 'COB' {cbkId = 'kaH1g0000004ChCEAU';}
        when 'Adjustments' {cbkId = 'kaH1g0000004ChVEAU';}
        when 'Determining' {cbkId = 'kaH1g0000004Cr9EAE';}
        when 'Client Exceptions' {cbkId = 'kaH1g0000004EFjEAM';}
        when 'Doctor Info' {cbkId = 'kaH1g0000004CqmEAE';}
        when 'Processing' {cbkId = 'kaH1g0000004Cr3EAE';}
        when 'Submit' {cbkId = 'kaH1g0000004CqoEAE';}
        when 'Compliance' {cbkId = 'kaH1g0000004EFTEA2';}
        when'Phone' {cbkId = 'kaH1g0000004ChbEAE';}
        }
       */
      //system.debug('param1'+param1);                                    
            cbk = [Select Id, Keyword__c,Article_Details__c, LastPublishedDate, Title, UrlName, ArticleNumber, 
            CreatedById, OwnerId,Version_Comments__c, Topic_Links__c,
            Support_Queue_Steps__c, VersionNumber from knowledge__kav where Title=:param1];                   
        return null;
    }   
     
    public EligibilityPDFController() {
    String strX = ApexPages.currentPage().getParameters().get('param1');       
    system.debug('strX'+strX); 
    }

    public String getcbkId() {
    system.debug(cbkId);        
            return cbkId;      
    }
  
    public Knowledge__kav getcbk() {
        return cbk;      
    }
	
}