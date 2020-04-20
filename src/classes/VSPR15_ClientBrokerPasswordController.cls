public with sharing class VSPR15_ClientBrokerPasswordController{

     public String firstName{get;set;} 
     public String lastName{get;set;} 
     public String accountId{get;set;} 
     
     public PageReference reportList(){
        
        //URL = 'http://schqvbid:8080/ibi_apps/WFServlet?&IBIF_wfdescribe=XMLRUN&IBIF_ex=crm_siebel_srch&FIRSTNAME=';
        
        if((lastName == ''||lastName == null) && (accountId == '' || accountId == null)){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Last Name and/or Account Id must contain a search value'));
            return null;
        }
        
        else{
            return new PageReference('http://schqvbip:8080/ibi_apps/WFServlet?&IBIF_wfdescribe=XMLRUN&IBIF_ex=crm_siebel_srch&FIRSTNAME='+ firstName.trim() + '&LASTNAME=' + lastName.trim() + '&GROUPID=' + accountId.trim());
        
        }
        
      }  

}