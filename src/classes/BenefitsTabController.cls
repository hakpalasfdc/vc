public class BenefitsTabController{
	/*
    public CatTabDefault__c BenefitsTab {get; set;}   
    public list<CatTabDefault__c> catset {get; set;}
    public String defaultlink {get; set;}   
    public String sidebarlink {get; set;}    
    public String links;   
         //Constructor with no arguments 
    public BenefitsTabController() {
        
        catset = CatTabDefault__c.getAll().values();
        
        //BenefitsTab = CatTabDefault__c.getInstance('Benefits');       
        
        //SOQL to search articles filtered by Data-Categories
        
        //SOQL to retrieve data from
        defaultlink= [SELECT Topic_Links__c FROM Knowledge__kav WHERE PublishStatus = 'online' AND Language = 'en_US' AND Title ='Benefits'].Topic_Links__c;
        sidebarlink= [SELECT Links__c FROM Knowledge__kav WHERE PublishStatus = 'online' AND Language = 'en_US' AND Title ='Sidebar Benefits'].Links__c;
        
         }         
          
    public String getBenefitscatlinks() {
        return links;      
    }
    
    public String getdefaultlink() {
        return defaultlink;      
    }
    
    public String getsidebarlink() {
        return sidebarlink;      
    }
	*/
}