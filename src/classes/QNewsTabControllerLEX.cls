public class QNewsTabControllerLEX{   

    public CatTabDefault__c QNewsTab{get; set;}     
    public list<CatTabDefault__c> catset {get; set;}
    public String links;    
    
//Constructor with no arguments 
    public QNewsTabControllerLEX() {       
        catset = CatTabDefault__c.getAll().values();            
        QNewsTab = CatTabDefault__c.getInstance('QNews');  
        
        //SOQL to retrieve data from    
        if(QNewsTab.Category_Links__c != null && QNewsTab.Category_Links__c != '') {
        links = [SELECT Links__c FROM knowledge__kav where title ='Sidebar-QNews' AND PublishStatus='OnLine' AND Language='en_US' Limit 1].Links__c;

            //links= [SELECT Links__c FROM Category_Tab_Link__kav WHERE PublishStatus = 'online' AND Language = 'en_US' AND UrlName =: QNewsTab.Category_Links__c].Links__c;            
        }                       
    }                        
    public String getQNewscatlinks() {
        return links;      
    }

}