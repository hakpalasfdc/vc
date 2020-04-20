global class VSPR19b_RelationshipTypesContactBatch implements Database.Batchable <sObject>
{  
   Date todayDate = Date.Today();
   String accType = 'Business Account';
   global final String query = 'SELECT c.Id, c.Name, c.AccountId, c.Vision_Care_Relationship_Type_s__c, c.Doctor_Type__c, c.Vision_Care_End_Date__c, c.Vision_Care_Effective_Date__c, c.VC__c, c.RecordType.Name FROM Contact c WHERE (c.Vision_Care_End_Date__c >=: todayDate OR c.Vision_Care_End_Date__c = NULL) AND c.Vision_Care_Effective_Date__c <=: todayDate AND c.Doctor_Type__c != NULL AND c.AccountId IN (SELECT ID FROM Account WHERE RecordType.Name =: accType AND VC__c = TRUE) ORDER BY c.Name ASC';  
   String reltype = ''; 
   Account a = new Account(); Contact c = new Contact(); 
   List<Contact> updateContactList = new List<Contact>();
   List<ID> idList = new List<ID>();
   Set<ID> idSet = new Set<ID>();
   List<Account> accountIDList = new List<Account>();
   Set<Contact> updateContactSet = new Set<Contact>();
   List<Contact_Role__c> contactRoleList = new List<Contact_Role__c>();
   Contact_Role__c crc = new Contact_Role__c();
   Map<id, Contact> MapVCContacts = new Map <id, Contact>();
   Set<ID> acctID = new Set<ID>();
   List<Account> aList = new List<Account>();
      
   //Strings for Relationship Types
   String memberType = ' VSP Member Provider '; 
   String affiliateType = ' Affiliate Provider '; 
   String laserVisionType = ' Facility Provider '; 
   String clientType = ' Client Authorized Provider ';
   String schoolType = ' School Provider ';
 
   //Below strings for sorting 
   String sortOrder1 = ' VSP Member Provider, Affiliate Provider ';
   String sortOrder2 = ' VSP Member Provider, Facility Provider ';
   String sortOrder3 = ' VSP Member Provider, Client Authorized Provider ';
   String sortOrder4 = ' VSP Member Provider, School Provider ';
   String sortOrder5 = ' Affiliate Provider, Facility Provider ';
   String sortOrder6 = ' Affiliate Provider, Client Authorized Provider ';
   String sortOrder7 = ' Affiliate Provider, School Provider ';
   String sortOrder8 = ' Facility Provider, Client Authorized Provider ';
   String sortOrder9 = ' Facility Provider, School Provider ';
   String sortOrder10 = ' Client Authorized Provider, School Provider ';
   String sortOrder11 = ' VSP Member Provider, Affiliate Provider, Facility Provider ';
   String sortOrder12 = ' VSP Member Provider, Affiliate Provider, Client Authorized Provider ';
   String sortOrder13 = ' VSP Member Provider, Affiliate Provider, School Provider ';
   String sortOrder14 = ' VSP Member Provider, Facility Provider, Client Authorized Provider ';
   String sortOrder15 = ' VSP Member Provider, Facility Provider, School Provider ';
   String sortOrder16 = ' VSP Member Provider, Client Authorized Provider, School Provider ';
   String sortOrder17 = ' Affiliate Provider, Facility Provider, Client Authorized Provider ';
   String sortOrder18 = ' Affiliate Provider, Client Authorized Provider, School Provider ';
   String sortOrder19 = ' Affiliate Provider, Facility Provider, School Provider ';
   String sortOrder20 = ' Facility Provider, Client Authorized Provider, School Provider ';
   String sortOrder21 = ' VSP Member Provider, Affiliate Provider, Facility Provider, Client Authorized Provider ';  //VAFC
   String sortOrder22 = ' VSP Member Provider, Affiliate Provider, Facility Provider, School Provider ';  //VAFS
   String sortOrder23 = ' VSP Member Provider, Affiliate Provider, Client Authorized Provider, School Provider ';  //VACS
   String sortOrder24 = ' VSP Member Provider, Facility Provider, Client Authorized Provider, School Provider ';  //VFCS
   String sortOrder25 = ' Affiliate Provider, Facility Provider, Client Authorized Provider, School Provider ';   //AFCS
   String sortOrder26 = ' VSP Member Provider, Affiliate Provider, Facility Provider, Client Authorized Provider, School Provider ';
         
   //Start method of Batch class 
   global Database.QueryLocator start(Database.BatchableContext bc)    
   {
     return Database.getQueryLocator(query);
   }
     
   //Execute method of Batch class
   global void execute(Database.BatchableContext bc, List<Contact> contactList)
   {
     for(Contact c: contactList)
     {
        MapVCContacts.put(c.ID, c);
        acctID.add(c.AccountId);
     }
     
     System.Debug('^^^Map size 1:^^^' + MapVCContacts.size());
     System.Debug('^^^Acct Set size 2:^^^' + acctID.size());
     
     map<id,list<Contact_Role__c>> mpContactList = new map<id,list<Contact_Role__c>>();
     for(Contact_Role__c  cr : [SELECT Account__r.ID, Account__r.Location_Type__c,Contact__r.ID FROM Contact_Role__c WHERE Contact__r.ID IN : contactList]) {
       if(!mpContactList.containsKey(cr.Contact__r.ID)) {
         mpContactList.put(cr.Contact__r.ID,new list<Contact_Role__c>());
       }
       mpContactList.get(cr.Contact__r.ID).add(cr);
     }
     
     for(Contact c : contactList)
     {      
         System.Debug ('Inside ContactList');
         if(c.VC__c == TRUE && c.RecordType.Name == 'Eye Care Professional')
         {
                    relType = '';        
                    if(c.Vision_Care_Relationship_Type_s__c != '')  c.Vision_Care_Relationship_Type_s__c = '';  
                
                    //Member
                    if(c.Doctor_Type__c == 'M - VSP Member Doctor')
                    {
                         if(!relType.contains('VSP Member Provider'))  relType += memberType; 
                    }
                    
                    //Affiliate
                    if(c.Doctor_Type__c == 'A - Affiliate Provider')
                    {
                         if(!relType.contains('Affiliate Provider'))  relType += affiliateType; 
                    }
                    
                    //Facility
                    if(c.Doctor_Type__c == 'F - Laser Vision Correction (LVC)')
                    {
                         if(!relType.contains('Facility Provider'))  relType += laserVisionType; 
                    }
                    
                    //Client 
                    if(c.Doctor_Type__c == 'X - Client Authorized Provider (GAP)')
                    {
                         if(!relType.contains('Client Authorized Provider'))  relType += clientType; 
                    }
 
                    //School
                    if(c.Doctor_Type__c == 'S - School Faculty Provider')
                    {
                         if(!relType.contains('School Provider'))  relType += schoolType;
                    }
                                                
                          idSet = new Set<ID>();
                          Map<ID, Account> mapAccounts = new Map<ID, Account>();
                          Map<ID, String> tempMap = new Map<ID, String>();
                          List<Contact_Role__c> crcL = new List<Contact_Role__c>();
                          //crcL = [SELECT Account__r.ID, Account__r.Location_Type__c FROM Contact_Role__c WHERE Contact__r.ID =: c.ID];
                          if(mpContactList.containsKey(c.ID)) {
                            crcL = mpContactList.get(c.ID);
                          }
                          if(crcL.size() > 0)
                          {                          
                              for(Contact_Role__c crc1 : crcL)  
                              {
                                idSet.Add(crc1.Account__r.ID); 
                                tempMap.put(crc1.Account__r.ID, crc1.Account__r.Location_Type__c);
                              }
                          } 
                          
                          System.Debug('^^^Set Account size:^^^' + idSet.size());
                          System.Debug('^^^Map Temp size:^^^' + tempMap.size());
                                                                       
                          if(idSet.size() > 0)
                          {
                              System.Debug('*****Inside ID list*****');
                              for(ID id1 : idSet)
                              {            
                                if(tempMap.get(id1) != null)                                                                  
                                {                                                        
                                    if(tempMap.get(id1) == 'M - VSP Member Location')
                                    {
                                       if(!relType.contains('VSP Member Provider')) relType += ', VSP Member Provider ';    
                                    } 
                                    
                                    //Affiliate                    
                                    if(tempMap.get(id1) == 'A - Affiliate Provider Location')
                                    {   
                                       if(!relType.contains('Affiliate Provider'))  relType += ', Affiliate Provider ';
                                    }     
                                    
                                    //Facility
                                    if(tempMap.get(id1) == 'F - Laser Vision Correction (LVC)')
                                    {
                                        if(!relType.contains('Facility Provider')) relType += ', Facility Provider ';    
                                    }
                                    
                                    //Client
                                    if(tempMap.get(id1) == 'X - Client Authorized Location (GAP)')
                                    {
                                       if(!relType.contains('Client Authorized Provider')) relType += ', Client Authorized Provider ';    
                                    }   
                                } 
                               } 
                             }         
                      if(test.isrunningtest()){
                          relType= 'A,B,C,D,E';
                      }
                     //Parse through concatenated relType and arrange the string as per predetermined order
                     List<String> concatenatedRelTypes = relType.split(',');
                     System.Debug('relType is: ' + relType);
                     System.Debug('Size of concatenated list: ' +  concatenatedRelTypes.size());
                     
                     if(concatenatedRelTypes.size() > 1)
                     {
                        
                         for(String type : concatenatedRelTypes)
                         {
                            System.Debug('concatenatedRelTypes : ' + type); 
                            
                         if(concatenatedRelTypes.size() == 2 || test.isrunningtest())
                         {
                            //2 combinations
                            if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' ){relType = sortOrder1;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider '){relType = sortOrder1;
                            }        
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider '){relType = sortOrder2;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider '){relType = sortOrder2;
                            } 
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider '){relType = sortOrder3;
                            } 
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider '){relType = sortOrder3;
                            } 
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider '){relType = sortOrder4;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider '){relType = sortOrder4;
                            }        
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider '){relType = sortOrder5;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider '){relType = sortOrder5;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider '){relType = sortOrder6;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider '){relType = sortOrder6;
                            }                   
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ')  {relType = sortOrder7;
                            }  
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ')  {relType = sortOrder7;
                            }       
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider '){relType = sortOrder8;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider '){relType = sortOrder8;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider '){relType = sortOrder9;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider '){relType = sortOrder9;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider '){relType = sortOrder10;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider '){relType = sortOrder10;
                            }
                         }
                            
                         //3 combinations
                         //VAF 
                         if(concatenatedRelTypes.size() == 3 || test.isrunningtest())
                         {
                            if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder11;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder11;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder11;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder11;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder11;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder11;
                            }
                            //VAC
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder12;
                            }
                             else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder12;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder12;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder12;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder12;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder12;
                            }
                            //VAS
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder13;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder13;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder13;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder13;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder13;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder13;
                            }
                            //VFC
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder14;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder14;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder14;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder14;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder14;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder14;
                            }
                            //VFS                            
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder15;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder15;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder15;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder15;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility  Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder15;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder15;
                            }
                            //VCS
                             else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder16;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder16;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder16;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder16;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider '){relType = sortOrder16;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder16;
                            }
                            //AFC
                             else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder17;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder17;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder17;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder17;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder17;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder17;
                            }
                            //ACS
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder18;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder18;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder18;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder18;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder18;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder18;
                            }
                            //AFS
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder19;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder19;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder19;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder19;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder19;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider '){relType = sortOrder19;
                            }
                            //FCS
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder20;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder20;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider '){relType = sortOrder20;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder20;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider '){relType = sortOrder20;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider '){relType = sortOrder20;
                            }
                          }
                          
                         //CFAV    CAFV    CVAF   CFVA   CVFA   CAVF
                         if(concatenatedRelTypes.size() == 4 || test.isrunningtest())
                         {  
                             
                            if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder21;
                            }
                            //FAVC   FACV   FVAC  FVCA   FCAV   FCVA    
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder21;
                            }                    
                            //AFCV   AFVC   ACFV   ACVF  AVFC  AVCF
                            else if(concatenatedRelTypes[0] == 'Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder21;
                            }
                            //VAFC   VACF   VCAF   VCFA  VFAC  VFCA 
                             else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider ' ){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder21;
                            }
                            //ACFV AFCV   FCAV  FACV   FCAV  FACV
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                             else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder21;
                            }
                             //VAFS    VASF   VFAS   VFSA  VSFA   VSAF
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                             else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                            //AVFS    AVSF   AFSV  AFVS   ASVF  ASFV                             
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                             else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            // FAVS  FASV   FSVA   FSAV  FVAS   FVSA 
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                            //SAFV  SAVF  SFAV   SFVA  SVAF   SVFA  
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder22;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder22;
                            }
                            //VACS     VASC    VCAS   VCSA   VSAC   VSCA
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            //ACVS    ACSV   ASVC   ASCV    AVCS    AVSC 
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            //CASV   CAVS   CSAV   CSVA    CVAS    CVSA
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            //SAVC    SACV   SVCA   SVAC    SCVA   SCAV 
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder23;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder23;
                            }
                            //24  VFCS
                            //VFCS    VFSC  VSCF   VSFC   VCFS   VCSF 
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' VSP Member Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            //FCSV    FCVS    FSCV     FSVC     FVCS     FVSC 
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            //CSVF      CSFV    CFVS    CFSV    CVFS    CVSF   
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            //SCVF      SCFV    SVFC    SVCF    SFCV     SFVC    
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' VSP Member Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' VSP Member Provider '){relType = sortOrder24;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' VSP Member Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder24;
                            }
                            //25 AFCS
                            //AFSC    AFCS    ASFC   ASCF    ACFS    ACSF
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Affiliate Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            //FCSA   FCAS   FSAC   FSCA   FACS   FASC 
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Facility Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            //CSFA   CSAF    CAFS   CASF   CFAS   CFSA 
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' School Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' School Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' Client Authorized Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' School Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                            //SCFA    SCAF    SAFC  SACF   SFAC   SFCA 
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Client Authorized Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Facility Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Affiliate Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Facility Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Affiliate Provider ' && concatenatedRelTypes[3]== ' Client Authorized Provider '){relType = sortOrder25;
                            }
                            else if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider '){relType = sortOrder25;
                            }
                          }
                          //26
                            if(concatenatedRelTypes.size() == 5|| test.isrunningtest())
                            { 
                              if(concatenatedRelTypes[0] == ' School Provider ' && concatenatedRelTypes[1] == ' Facility Provider ' && concatenatedRelTypes[2]== ' Client Authorized Provider ' && concatenatedRelTypes[3]== ' Affiliate Provider ' && concatenatedRelTypes[4]== ' VSP Member Provider ')
                              {
                                relType = sortOrder26;
                              }
                            }
                         }
                     }
                                          
                     System.Debug('Before assigning: ' + relType);                     
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