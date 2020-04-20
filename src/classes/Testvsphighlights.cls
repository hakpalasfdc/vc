/**
* Class Name: Testvsphighlights
* @author: Eagle Creek    
* Date: 25.OCT.2018
* Requirement/Project Name: VSPGlobalSales
* @description: Test class for the retrievel of custom settings value for vsphighlights.
*/
@isTest
public class Testvsphighlights {
   static testmethod void Testvsphighlights()
    {
   /* vsphighlights__c vsphighlights = new vsphighlights__c();         
    vsphighlights.Name = 'FourthLine';        
    vsphighlights.displaytext__c = '4th Highlights';   
	vsphighlights.URL__c = 'Highlight4';  
    insert vsphighlights;
	
	Map<String, vsphighlights__c> whattoknow = vsphighlights__c.getall();
    vsphighlights__c highllightURL = whattoknow.get('FourthLine');          
	String distext = highllightURL.displaytext__c;
	string URLval  = highllightURL.URL__c;
    System.debug(distext);	*/
        
      vsphighlights vs = new vsphighlights();
      System.debug(vs.vspheadln);
     
    }

}