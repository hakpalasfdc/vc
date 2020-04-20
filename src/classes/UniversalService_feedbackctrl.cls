public class UniversalService_feedbackctrl {
    /*
    public Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();
    Public string Comments {get;set;}      
    String[] reasons = new String[]{};
    //public Universal_Service__kav filterid;
    public string cbkId {get; set;}
    //public Universal_Service__kav stpf{get;set;}
    public String sfUrl=URL.getSalesforceBaseUrl().getHost();   
    public List<Universal_Service__DataCategorySelection> CatDetails;  
    //public Universal_Service__kav cbk {get; set;}   
    public Boolean hiddenvaluesflag {get;set;} 
    public Boolean toolbarflag {get;set;}      
    public string ID=apexpages.currentpage(). getParameters().get('id');
    public boolean x;
    public Boolean highlightVersionComments{get;set;} 
    public Boolean checkIfDraft{get;set;}
    
    public UniversalService_Feedbackctrl(ApexPages.KnowledgeArticleVersionStandardController controller) {
        hiddenvaluesflag=false;
        toolbarflag = true;
        //stpf=(Universal_Service__kav)controller.getRecord();           
        //Getting the Article ID                                      
        cbkId = apexpages.currentpage(). getParameters().get('id');       
        //cbk = new Universal_Service__kav();
        /*
        if(cbkId != null && cbkId != '') { 
            //Querying Data from ArticleType            
            cbk = [Select Id,Article_Details__c,Keyword__c, Support_Queue_Steps__c,Version_Comments__c,LastPublishedDate,Title,UrlName, PublishStatus, ArticleType, ArticleNumber, CreatedById, OwnerId from Universal_Service__kav where id=:stpf.id AND KnowledgeArticleId =: cbkId ];           
            filterid=[SELECT Id,UrlName FROM Universal_Service__kav WHERE ArticleNumber =: cbk.ArticleNumber AND id=:stpf.id];                
            CatDetails= [Select DataCategoryName,DataCategoryGroupName from Universal_Service__DataCategorySelection where ParentId =:filterid.Id];                                         
        }
        */
        /*
        if(cbk.LastPublishedDate != null){
            if((cbk.LastPublishedDate.date().addDays(30))  < DateTime.now().date()){
                highlightVersionComments = false;
            }else{
                highlightVersionComments = true;
            } 
        } 
        
         if(cbk.PublishStatus == 'Draft'){
            checkIfDraft = true;
        }
        
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
    
    public void setCatDetails(List<Universal_Service__DataCategorySelection> catDetailsList) {       
        this.CatDetails = catDetailsList;       
    } 
    
    public String getart() {
        return ID;      
    }
    
    public String getsfurll() {
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

    public List<Universal_Service__DataCategorySelection> getCategory() {
        return CatDetails;
    }
    
    // Creating an Article FeedBack from ArticleFeedback tab in VFP
    public PageReference saveclick() {
        ArticleFeedbackObj = new Article_Feedback__c();                    
        ArticleFeedbackObj.Article_ID__c=ID;
        //ArticleFeedbackObj.Article_Title__c=cbk.Title;
        //ArticleFeedbackObj.Article_Type__c=cbk.ArticleType;        
        //ArticleFeedbackObj.Article_URL__c=cbk.UrlName;
        ArticleFeedbackObj.Comments__c=Comments;
         if(ArticleFeedbackObj.Comments__c == '' || ArticleFeedbackObj.Comments__c == null){
           ApexPages.addMessage(new ApexPages.Message ( ApexPages.Severity.ERROR, 'Article Feedback Error: You must enter Comments and select at least one Reason'));
           toolbarflag = false;
           return null;
        }
       
        ArticleFeedbackObj.Data_Category__c = '';
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
	*/
}