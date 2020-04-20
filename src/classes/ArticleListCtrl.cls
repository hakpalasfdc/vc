public class ArticleListCtrl {
    public CatTabDefault__c AdjustmentsTab {get; set;}  
    public CatTabDefault__c AuthorizationTab {get; set;}     
    public list<CatTabDefault__c> catset {get; set;}
    public CatTabDefault__c BenefitsTab {get; set;}         
    public CatTabDefault__c Client_ExceptionsTab {get; set;}
    public CatTabDefault__c COBTab {get; set;}
    public CatTabDefault__c ComplianceTab {get; set;}     
    public CatTabDefault__c Determine_PaymentTab{get; set;}
    public CatTabDefault__c Dr_InfoTab {get; set;}  
    public CatTabDefault__c EligibilityTab {get; set;}   
    public CatTabDefault__c Phone_BookTab {get; set;} 
    public CatTabDefault__c ProcessingTab {get; set;}  
    public CatTabDefault__c SubmitTab {get; set;}    
    public CatTabDefault__c QNewsTab {get; set;}   
    
    public ArticleListCtrl(){
        catset = CatTabDefault__c.getAll().values();            
        EligibilityTab = CatTabDefault__c.getInstance('Eligibility');    
        BenefitsTab = CatTabDefault__c.getInstance('Benefits');       
        AuthorizationTab = CatTabDefault__c.getInstance('Authorization');
        SubmitTab = CatTabDefault__c.getInstance('Submit');
        Determine_PaymentTab= CatTabDefault__c.getInstance('Determining Payment');
        ProcessingTab= CatTabDefault__c.getInstance('Processing');
        COBTab = CatTabDefault__c.getInstance('COB');
        AdjustmentsTab = CatTabDefault__c.getInstance('Adjustments');
        Dr_InfoTab = CatTabDefault__c.getInstance('Dr Info');
        Client_ExceptionsTab = CatTabDefault__c.getInstance('Client Exceptions');
        ComplianceTab = CatTabDefault__c.getInstance('Escalations');
        Phone_BookTab = CatTabDefault__c.getInstance('Phone_Book');
        QNewsTab = CatTabDefault__c.getInstance('QNews');
        
        //SOQL to search articles filtered by Data-Categories
        String qryString ='SELECT Id, title, UrlName, LastPublishedDate,LastModifiedById FROM KnowledgeArticleVersion WHERE (PublishStatus = \'online\' and Language = \'en_US\')';
        List<KnowledgeArticleVersion> articleList= Database.query(qryString);
        maxSize = articleList.size() ;
    } 
    public String searchstring{get;set;}    
    Integer currentPage = 1;
    Integer maxSize = 1;
    private Static Final Integer PAGE_NUMBER = 10;  
    
    public boolean getPrevRequired() {
        return currentPage > 1;
    }
    
    public boolean getNextRequired() {
        return currentPage * PAGE_NUMBER < maxSize;
    } 
       
    public PageReference previous() {
        if(this.currentPage > 1)
            this.currentPage = this.currentPage - 1;
        return null;
    }
    
    public Decimal getCurrentPageNumber() {
        return this.currentPage;
    }   
    
    public PageReference next() {
        if(maxSize > this.currentPage * PAGE_NUMBER) {
            this.currentPage = this.currentPage + 1;
        }
        return null;
    }           
}