public class QuestController9{

    public CatTabDefault__c QuestTab {get; set;}
    public list<CatTabDefault__c> catset {get; set;}
    
    
    public String Sidebarlinks  {get; set;}
         //Constructor with no arguments 
    public QuestController9() {
        
        catset = CatTabDefault__c.getAll().values();
        QuestTab = CatTabDefault__c.getInstance('Dr Info');           
        //SOQL to search articles filtered by Data-Categories
        
        //SOQL to retrieve data from categoryTabLinkk article Type
        Sidebarlinks= [SELECT Links__c FROM Knowledge__kav 
        WHERE PublishStatus = 'online' AND Language = 'en_US' AND UrlName =: QuestTab.Category_Links__c].Links__c;      
         }         
    
           
    public String getSidebarlinks() {
        return Sidebarlinks;      
    }
    
    
}