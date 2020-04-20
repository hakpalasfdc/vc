/**
* Class Name: vspresourcelinks
* @author: Eagle Creek    
* Date: 25.OCT.2018
* Requirement/Project Name: VSPGlobalSales
* @description: This class read the custom settings values for the external links displayed in the VSPGlobalSales community. The value can be changed from the custom settings at any time.
*/

public class vspresourcelinks
{
    public List<vspresourcelinks__c> vsplinks {get;set;}
   
    public vspresourcelinks()
    {
        Map<String,vspresourcelinks__c> allvsplk = vspresourcelinks__c.getAll();
        vsplinks = allvsplk.values();
    }  
   
}