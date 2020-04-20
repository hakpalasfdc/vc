public class EligibilityTabController{
	/*
    public String param1 { get; set; }
    public String param2 { get; set; }
    public String DefaultLink { get; set;} 

    public String sidebarlinks;

    Public string Comments {get;set;}      
    String[] reasons = new String[]{};
    public knowledge__kav filterid;
    public string cbkId {get; set;}
    //public Multi_Topic__kav mtpf{get;set;}
    public String sfURL=URL.getSalesforceBaseUrl().getHost();   
  //  public List<Multi_Topic__DataCategorySelection> CatDetails;  
    public knowledge__kav cbk {get; set;}
    public Boolean hiddenvaluesflag {get;set;} 
    public Boolean toolbarflag {get;set;}      
    public string ID=apexpages.currentpage(). getParameters().get('id');
    //public boolean x;
    public Boolean highlightVersionComments{get;set;} 
    public Boolean checkIfDraft{get;set;}
     public Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();
    
  /*  public MultiTopic_Feedbackctrl(ApexPages.KnowledgeArticleVersionStandardController controller) {
        hiddenvaluesflag=false;
        toolbarflag = true;
        //mtpf=(Multi_Topic__kav)controller.getRecord();           
        //Getting the Article ID 
        cbkId = apexpages.currentpage(). getParameters().get('id');                             
        //cbk = new Multi_Topic__kav();
        if(cbkId != null && cbkId != '') {
            //Querying Data from ArticleType            
            //cbk = [Select Id, LastPublishedDate,Version_Comments__c,Support_Queue_Steps__c, Title,Topic_Links__c, PublishStatus, Article_Details__c, Keyword__c, UrlName, ArticleType, ArticleNumber, CreatedById, OwnerId from Multi_Topic__kav where id=:mtpf.id  AND KnowledgeArticleId =: cbkId];           
            //filterid=[SELECT Id,UrlName FROM Multi_Topic__kav WHERE ArticleNumber =: cbk.ArticleNumber AND id=:mtpf.id ];                
            //CatDetails= [Select DataCategoryName,DataCategoryGroupName from Multi_Topic__DataCategorySelection where ParentId =:filterid.Id];          
        } 
       
        if(cbk.LastPublishedDate != null){
            if((cbk.LastPublishedDate.date().addDays(30))  < DateTime.now().date()){
                highlightVersionComments = false;
            }
            else{
                highlightVersionComments = true;
            } 
        }  
     
         //if(cbk.PublishStatus == 'Draft'){
         //   checkIfDraft = true;
        //}
            
    }
    
    //Multi-Picklist values for Reasons
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Broken Link','Broken Link'));
        options.add(new SelectOption('Page Unclear','Page Unclear'));
        options.add(new SelectOption('Missing Information','Missing Information'));
        options.add(new SelectOption('Hard to Find Page','Hard to Find Page'));
        options.add(new SelectOption('Other','Other'));
        return options;
    }
    
    public String[] getReasons() {
    	return reasons;
    }
            
    public void setreasons(String[] reasons) {
    	this.reasons = reasons;
    }   
      /*  
    public void setCatDetails(List<Multi_Topic__DataCategorySelection> catDetailsList) {
        this.CatDetails = catDetailsList;
    } 
    
    public String getart() {
        return ID;      
    }
    
    public String getsfURLl() {
        return sfURL;      
    }
    
    public Article_Feedback__c getArticleFeedbackObj(){
      return ArticleFeedbackObj;
    }
    
    public void setArticleFeedbackObj(Article_Feedback__c ArticleFeedbackObj){
      this.ArticleFeedbackObj = ArticleFeedbackObj;
    }
    
    public String getReturnid() {
        return cbkId;
    }
/*
    public List<Multi_Topic__DataCategorySelection> getCategory() {
        return CatDetails;
    }
  
    // Creating an Article FeedBack from ArticleFeedback tab in VFP
    public PageReference saveclick() {
        ArticleFeedbackObj = new Article_Feedback__c();           
        ArticleFeedbackObj.Article_Title__c=cbk.Title;
        ArticleFeedbackObj.Article_ID__c=cbkId;        
        ArticleFeedbackObj.Article_URL__c=sfURL+'/'+cbkId;       
        ArticleFeedbackObj.Comments__c=Comments;
        
        if(ArticleFeedbackObj.Comments__c == '' || ArticleFeedbackObj.Comments__c == null){
           ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Article Feedback Error: You must enter Comments and select at least one Reason'));
           toolbarflag = false;
           return null;
        }

        ArticleFeedbackObj.Data_Category__c = '';
        /*
        if(CatDetails != null && !CatDetails.isEmpty()) {
             for(Integer i=0; i < CatDetails.size(); i++) {
                if(ArticleFeedbackObj.Data_Category__c != '')
                ArticleFeedbackObj.Data_Category__c = ArticleFeedbackObj.Data_Category__c + ';';
                ArticleFeedbackObj.Data_Category__c = ArticleFeedbackObj.Data_Category__c+CatDetails[i].DataCategoryName;
                ArticleFeedbackObj.Data_Category_Group__c=CatDetails[i].DataCategoryGroupName;
            }
        }
        
        ArticleFeedbackObj.Reason__c = '';
        if(reasons != null && !reasons.isEmpty()) {
            for(Integer i=0; i < reasons.size(); i++) {
                ArticleFeedbackObj.Reason__c = ArticleFeedbackObj.Reason__c+';'+reasons[i];
            }        
        }
        if(ArticleFeedbackObj.Reason__c == '' || ArticleFeedbackObj.Reason__c == null){
           ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Article Feedback Error: You must select at least one Reason'));
           toolbarflag = false;
           return null;
        }
        insert ArticleFeedbackObj;
        reasons = new List<String>();
        comments = '';
        ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.INFO, 'Successfully Inserted.'));
        toolbarflag = true;
        return null;    
    }   
        
    public PageReference setParams()
    {
        String sidetitle = 'Sidebar '+param1;
    	hiddenvaluesflag=false;
        toolbarflag = true;
        //mtpf=(Multi_Topic__kav)controller.getRecord();           
        //Getting the Article ID 
        switch on param1 {
            when 'Eligibility' {cbkId = 'kaH1g0000004ChREAU';} //apexpages.currentpage(). getParameters().get('id');  
            when 'Benefits' {cbkId = 'kaH1g0000004Gj7EAE';}   ///kaH1g0000004Gj7EAE  kaH1g0000004ELTEA2
            when 'Authorization' {cbkId = 'kaH1g0000004GjCEAU';}//kaH1g0000004CrEEAU';}
            when 'COB' {cbkId = 'kaH1g0000004ChCEAU';}
            when 'Adjustments' {cbkId = 'kaH1g0000004ChVEAU';}
            when 'Determining' {cbkId = 'kaH1g0000004GjHEAU';}//kaH1g0000004Cr9EAE';}
            when 'Client Exceptions' {cbkId = 'kaH1g0000004GjWEAU';}//kaH1g0000004EFjEAM';}
            when 'Doctor Info' {cbkId = 'kaH1g0000004GjREAU';}//kaH1g0000004CqmEAE';}
            when 'Processing' {cbkId = 'kaH1g0000004GjMEAU';}//kaH1g0000004Cr3EAE';}
            when 'Submit' {cbkId = 'kaH1g0000004CqoEAE';}
            when 'Compliance' {cbkId = 'kaH1g0000004GinEAE';}//kaH1g0000004GinTEA2';}
            when'Phone' {cbkId = 'kaH1g0000004ChbEAE';}
        }  
        
        cbk = [Select Id, Keyword__c,Article_Details__c, LastPublishedDate, Title, UrlName, ArticleNumber, CreatedById, OwnerId,Version_Comments__c,Topic_Links__c, Support_Queue_Steps__c, VersionNumber from knowledge__kav where id=:cbkId];           
        filterid=[SELECT Id,UrlName,Topic_Links__c FROM knowledge__kav WHERE ArticleNumber =: cbk.ArticleNumber AND id=:cbkId ];                
     
        //    CatDetails= [Select DataCategoryName,DataCategoryGroupName from Multi_Topic__DataCategorySelection where ParentId =:filterid.Id];          
        
      
        if(cbk.LastPublishedDate != null){
            if((cbk.LastPublishedDate.date().addDays(30))  < DateTime.now().date()){
                highlightVersionComments = false;
            }
            else{
                highlightVersionComments = true;
            } 
        }  
           
        sidebarlinks = [SELECT Links__c FROM knowledge__kav where title =:sidetitle AND PublishStatus='OnLine' AND Language='en_US' Limit 1].Links__c;

     //   DefaultLink= [SELECT Article__c FROM Article_Type_Link__c WHERE Name =:param1 Limit 1].Article__c;
        
        return null;
    }   
     
    public EligibilityTabController() {
    	String strX = ApexPages.currentPage().getParameters().get('param1');
    }
  
    public String getcbkId() {
    	return cbkId;      
    }
  
    public String getDefaultLink() {
        return Defaultlink;      
    }
    
    public String getEligicatlinks() {
        return sidebarlinks;      
    }

    public Knowledge__kav getcbk() {
        return cbk;      
    }

    public String getsfURL() {
        return sfURL;      
    }
	*/
}