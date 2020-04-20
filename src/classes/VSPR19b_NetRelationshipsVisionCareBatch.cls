global class VSPR19b_NetRelationshipsVisionCareBatch implements Database.Batchable <sObject>
{  
   Date yesterdayDate = Date.Today().addDays(-1);
   String docType = 'S - School Faculty Provider';
   global final String query = 'SELECT Id, Name, AccountId, Vision_Care_Relationship_Type_s__c, Doctor_Type__c, Vision_Care_End_Date__c, Vision_Care_Effective_Date__c, RecordType.Name, VC__c FROM Contact WHERE (Vision_Care_End_Date__c >: yesterdayDate OR Vision_Care_End_Date__c = NULL) AND Vision_Care_Effective_Date__c != NULL AND Doctor_Type__c =: docType';    
   String reltype = ''; 
   Account a = new Account(); Contact c = new Contact(); 
   List<Contact> updateContactList = new List<Contact>();
   List<ID> idList = new List<ID>();
   List<Account> accountIDList = new List<Account>();
   Set<Contact> updateContactSet = new Set<Contact>();
            
   //Start method of Batch class 
   global Database.QueryLocator start(Database.BatchableContext bc)    
   {
     return Database.getQueryLocator(query);
   }
     
   //Execute method of Batch class
   global void execute(Database.BatchableContext bc, List<Contact> contactList)
   {
     for(Contact c : contactList)
     { 
        if(c.AccountId != NULL)
           idList.add(c.AccountId); 
     }
  
     for(Contact c : contactList)
     {      
         if(c.VC__c == TRUE && c.RecordType.Name == 'Eye Care Professional')
         {
                   relType = '';        
                   if(c.Vision_Care_Relationship_Type_s__c != '')  c.Vision_Care_Relationship_Type_s__c = '';  
                
                    if(c.Doctor_Type__c == 'S - School Faculty Provider')
                    {
                     if(!relType.contains('School Provider'))  relType += ' School Provider ';
                    }
                
                    Account a = [SELECT ID, Vision_Care_Effective_Date__c, Location_Type__c FROM Account WHERE ID =: c.AccountID LIMIT 1];
                
                    if(a != null)
                    {     
                        if(a.Vision_Care_Effective_Date__c != null && a.Location_Type__c == 'F - Laser Vision Correction (LVC)')
                        {
                            if(!relType.contains('Facility Provider')) relType += ', Facility Provider ';    
                        }
                        else if(a.Vision_Care_Effective_Date__c != null && a.Location_Type__c == 'A - Affiliate Provider Location')
                        {   
                           if(!relType.contains('Affiliate Provider'))
                           {
                             relType += ', Affiliate Provider ';
                           }
                        }
                        else if(a.Vision_Care_Effective_Date__c != null && a.Location_Type__c == 'M - VSP Member Location')
                        {
                           if(!relType.contains('VSP Member Provider')) relType += ', VSP Member Provider ';
    
                        }        
                        else if(a.Vision_Care_Effective_Date__c != null && a.Location_Type__c == 'X - Client Authorized Location (GAP)')
                        {
                           if(!relType.contains('Client Authorized Provider')) relType += ', Client Authorized Provider ';
    
                        }
                          
                     }  //end of account null check
                     
                     c.Vision_Care_Relationship_Type_s__c = relType; 
                     if(!updateContactSet.contains(c)) { updateContactSet.add(c); }
            
              }  //end of ECP check
         } //contact list check          
       
       if(updateContactSet.size() >0) { updateContactList.addAll(updateContactSet); UPDATE updateContactList; }
   }
    
    //finish method of Batch class
    global void finish(Database.BatchableContext bc)
    {
         System.Debug('Batch Job Complete !');
    }

}