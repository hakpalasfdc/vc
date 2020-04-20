public class CoreBenefits_Feedbackctrl {
    /*
    public Article_Feedback__c ArticleFeedbackObj = new Article_Feedback__c();
    Public string Comments {get;set;}      
    String[] reasons = new String[]{};
    //public Core_Benefit__kav filterid;
    public string cbkId {get; set;}
    //public Core_Benefit__kav cbpf{get;set;}
    public String sfUrl=URL.getSalesforceBaseUrl().getHost();   
    public List<Core_Benefit__DataCategorySelection> CatDetails ;
    //public Core_Benefit__kav cbk {get; set;}
    public Boolean hiddenvaluesflag {get;set;}
    public Boolean toolbarflag {get;set;}   
    public string ID=apexpages.currentpage().getParameters().get('id');
    //public boolean x;  
    public Boolean highlightVersionComments{get;set;} 
    public Boolean checkIfDraft{get;set;}
    
    public CoreBenefits_Feedbackctrl(ApexPages.KnowledgeArticleVersionStandardController controller) {
        hiddenvaluesflag=false;
        toolbarflag = true;
        //cbpf=(Core_Benefit__kav)controller.getRecord();     
        //Getting the Article ID                  
        cbkId = apexpages.currentpage(). getParameters().get('id');      
        //cbk = new Core_Benefit__kav();
        if(cbkId != null && cbkId != '') {
            //Querying Data from ArticleType         
            //cbk = [Select Id, Title,Exam__c,Lens__c,UrlName, LastPublishedDate,Version_Comments__c, Lens_Enhancements__c, PublishStatus, Frame__c,Contacts__c,Support_Queue_Steps__c,Doctor_Network__c,Lab__c,Additional_Benefits__c, Keyword__c, ArticleType, ArticleNumber, CreatedById, OwnerId from Core_Benefit__kav where id=:cbpf.id  AND KnowledgeArticleId =: cbkId];           
            //filterid=[SELECT Id,UrlName FROM Core_Benefit__kav WHERE ArticleNumber =: cbk.ArticleNumber AND id=:cbpf.id ];                
            //CatDetails= [Select DataCategoryName,DataCategoryGroupName from Core_Benefit__DataCategorySelection where ParentId =:filterid.Id];                               
        }
        /*
        if(cbk.LastPublishedDate != null){
            if((cbk.LastPublishedDate.date().addDays(30))  < DateTime.now().date()){
                highlightVersionComments = false;
            }
            else{
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
    
    public void setCatDetails(List<Core_Benefit__DataCategorySelection> catDetailsList) {
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

    public List<Core_Benefit__DataCategorySelection> getCategory() {
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
        if(ArticleFeedbackObj.Comments__c == '' || ArticleFeedbackObj.Comments__c == null ){
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
           return null;
           toolbarflag = false;
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