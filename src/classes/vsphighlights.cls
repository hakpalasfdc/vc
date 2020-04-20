/**
* Class Name: vspheadlines
* @author: Eagle Creek    
* Date: 25.OCT.2018
* Requirement/Project Name: VSPGlobalSales
* @description: This class read the custom settings values for 
    1. Highlights Information displayed in the community page
    2. Community page link for the automatic login
    3. Article location to display the details when the user click on the Highlights/what to know hyperlink
*/


public class vsphighlights
{
    public List<vsphighlights__c> vspheadln {get;set;}
    public List<vspportallink__c> vspportal {get;set;}
    public List<vspcommunityurl__c> vspurl {get;set;}
   
    public vsphighlights()
    {
        Map<String,vsphighlights__c> allvspheadln = vsphighlights__c.getAll();
        vspheadln = allvspheadln .values();
        
        Map<String,vspportallink__c> allvspportal = vspportallink__c.getAll();
        vspportal = allvspportal.values();
        
        Map<String,vspcommunityurl__c> allvspurl = vspcommunityurl__c.getAll();
        vspurl = allvspurl.values();
    }  
   
}