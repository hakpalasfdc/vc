global class batchConvertD2CLeads implements Database.Batchable<sObject>{
      //All Leads with D2C_Batch_Qualify__c = True will be converted to Person Acocunts
      //Need to update Lead with isConverted = true??
      global final String gstrQuery = ( Test.isRunningTest() ? 
      'SELECT Id, LeadSource, Consumer_ID__c, FirstName, LastName, Gender__c, D2C_Pre_Sales_Opt_In__c, Email, Phone, Date_of_Birth__c, Street, City, State, PostalCode, Country, Lead_Source_Details__c, Eloqua_Contact_ID__c, Subscriber_Status__c, Purchase_Channel__c, IP_Purchase_Date__c, Company FROM Lead WHERE name != null LIMIT 1' : 
      'SELECT Id, Consumer_ID__c, LeadSource, FirstName, LastName, Gender__c, D2C_Pre_Sales_Opt_In__c, Email, Phone, Date_of_Birth__c, Street, City, State, PostalCode, Country, Lead_Source_Details__c, Eloqua_Contact_ID__c, Subscriber_Status__c, Purchase_Channel__c, IP_Purchase_Date__c, Company FROM Lead WHERE D2C_Batch_Qualify__c = TRUE' ); 
      
      global Database.QueryLocator start(Database.BatchableContext BC){
          return Database.getQueryLocator(gstrQuery);
      }
      
      global void execute(Database.BatchableContext BC, List<Lead> scope){
      
      System.debug('###Got to Batch job and size of leads ='+ scope.size());  
      
      List<string> leadConsumerIds = new List<string>();
      Set<string> leadAccNames = new Set<string>();
      
      Id prsAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();    
      
      for(Lead l : scope){
          leadConsumerIds.add(l.Consumer_ID__c);         
          leadAccNames.add(l.firstName + ' '+ l.lastName);
      }
      
      //Get all the records that are ther that match o Consumer ID - in perfect worled there shoudl not be any
      AggregateResult[] countD2Caccounts = 
          [SELECT consumerId__c ci, count(ID) myCount
            FROM Account
            WHERE consumerId__c =: leadConsumerIds
            AND RecordType.Name = 'Person Account'
            GROUP BY ConsumerID__c];
      
      Map <string,integer> mapUniquePsAccMatch = new Map <string,integer>();
      List<Account> d2cAccountCreate = new List<Account>();
      
      if(!countD2Caccounts.isEmpty()){  //There exists accounts with matching ConsumerIDs
          for(AggregateResult ar : countD2Caccounts){
              if((integer)ar.get('myCount') == 1)
                mapUniquePsAccMatch.put((string)ar.get('ci'),(integer)ar.get('myCount'));
          }
      }
      
      //Now get the Person Accounts that match 
      Map<Id, Account> matchedPSAccList = new Map<Id, Account>([SELECT Id, ConsumerID__c, RecordTypeId
            FROM Account
            WHERE ConsumerID__c =: mapUniquePsAccMatch.KeySet() AND RecordType.Name = 'Person Account']);
      System.debug('### matchedPSAccList size = '+ matchedPSAccList.size());
      
      list<Database.LeadConvert> leadConvertMerged = new list<Database.LeadConvert>();  //List of Leads that already exist as PAs
      list<Database.LeadConvert> leadConvertCreate = new list<Database.LeadConvert>();
      
      for(Lead l : scope){
          if(!matchedPSAccList.isEmpty()){  //Found matching PAs
          System.debug('### matched PSAcc');
              for(Account ps : matchedPSAccList.values()){
                if(l.Consumer_ID__c == ps.ConsumerID__c){
                   system.debug('### found consumerID'); 
                  //convert Lead into exising PS Account
                  Database.LeadConvert lc = new database.LeadConvert();
                  lc.setLeadId(l.Id);
                  lc.setAccountId(ps.Id);
                  if(l.IP_Purchase_Date__c !=null){lc.convertedStatus = 'IP Enrolled';}
                  else{lc.convertedStatus = 'Group Enrolled';}
                  lc.setDoNotCreateOpportunity(true);
                  
                  leadConvertMerged.add(lc);
                }
              }
          }
          else{            
              //convert Lead into new Account & Contact
              System.debug('### create new Account');
              Database.LeadConvert lc = new database.LeadConvert();
              lc.setLeadId(l.Id);
              if(l.IP_Purchase_Date__c !=null)
                {lc.convertedStatus = 'IP Enrolled';}
              else
                {lc.convertedStatus = 'Group Enrolled';}            
              lc.setDoNotCreateOpportunity(true);
              lc.AccountId = null;  //Force it to create Person Account
              //lc.ConsumerId__c = l.Consumer_ID__c;
              leadConvertCreate.add(lc);
          }
      }
      System.debug('### leadConvertCreate size = '+ leadConvertCreate.size());
      List<Database.LeadConvertResult> lcrMerged = new List<Database.LeadConvertResult>();
      List<Database.LeadConvertResult> lcrCreated = new List<Database.LeadConvertResult>();
      
      if(!leadConvertMerged.isEmpty())
          lcrMerged = Database.convertLead(leadConvertMerged, false);
      System.debug('### size of leadConvertMerged = '+ leadConvertMerged.size());
      
      if(!leadConvertCreate.isEmpty())
          lcrCreated = Database.convertLead(leadConvertCreate, false);    //This converts the Leads - false means keep going if one fails
         
      System.debug('### lcrCreated = '+ lcrCreated.size()); 
      
      List<Account> lcrMergedAccounts = new List<Account>();
      List<Account> lcrCreatedAccounts = new List<Account>(); 
            
      List<Account> accountMerge = new List<Account>();
      List<Account> accountCreate = new List<Account>();
      
      List<Lead> leadUpdate = new List<Lead>();
      
      Map<ID,ID> l2Cmap = new Map<ID,ID>();
      
      for(Database.LeadConvertResult dlcr : lcrMerged){
        if(dlcr.isSuccess()){
        System.debug('### is Success Merged');
          Account mCont = new Account(Id = dlcr.getAccountId());
          //lcrMergedAccounts.add(mCont);
          l2Cmap.put(dlcr.getAccountId(),dlcr.getLeadId());
        }
      }
    
      for(Database.LeadConvertResult dlcr2 : lcrCreated){
      System.debug('### dlcr2 = '+dlcr2.geterrors());
        if(dlcr2.isSuccess()){
        System.debug('### is Success Created');
          Account cCont = new Account(Id = dlcr2.getAccountId());
          lcrCreatedAccounts.add(cCont);
          l2Cmap.put(dlcr2.getAccountId(),dlcr2.getLeadId());
        }
      }
      
      List<Account> lcrCreatedAccounts2 = 
          [SELECT Id, ConsumerID__c, RecordTypeId
            FROM Account
            WHERE Id =: lcrCreatedAccounts
            AND RecordType.Name = 'Person Account'];
      
      for(Lead l : scope){
          if(!matchedPSAccList.isEmpty()){
              for(Account cY : matchedPSAccList.values()){
                  if(l.Id == l2Cmap.get(cY.Id) && prsAccRTId == cY.RecordTypeId){                    
                      
                      system.debug('MERGE Account'); //merge contact
                      Account cX = new Account(Id = cY.Id);

                      if(l.FirstName != NULL){
                          cX.Marketing_Name__pc = l.FirstName;
                      }

                      if(l.LastName != NULL){
                          cX.LastName = l.LastName;
                      }
                      if(l.Gender__c != NULL){
                          cX.Gender__pc = l.Gender__c;
                      }
                      if(l.D2C_Pre_Sales_Opt_In__c != NULL){
                          cX.D2C_Pre_Sales_Opt_In__pc = l.D2C_Pre_Sales_Opt_In__c;
                      }
                      if(l.Email != NULL){
                          cX.Other_Email__pc = l.Email;
                      }
                      if(l.Phone != NULL){
                          cX.Phone = l.Phone;  
                      }
                      if(l.Date_of_Birth__c != NULL){
                          cX.Birthdate__pc = l.Date_of_Birth__c;
                      }
                      if(l.Street != NULL){
                          cX.PersonMailingStreet = l.Street;
                      }
                      if(l.City != NULL){
                          cX.PersonMailingCity = l.City;
                      }
                      if(l.State != NULL){
                          cX.PersonMailingState = l.State;
                      }
                      if(l.PostalCode != NULL){
                          cX.PersonMailingPostalCode = l.PostalCode;
                      }
                      if(l.Country != NULL){
                          cX.PersonMailingCountry = l.Country;
                      }
                      if(l.Subscriber_Status__c != NULL){
                          cX.Subscriber_Status__pc = l.Subscriber_Status__c;
                      }
                      if(l.Purchase_Channel__c != NULL){
                          cX.Purchase_Channel__pc = l.Purchase_Channel__c;
                      }
                      if(l.Consumer_ID__c != NULL){
                          cX.ConsumerID__c = l.Consumer_ID__c;
                      }
                      if(l.IP_Purchase_Date__c != NULL){
                          cX.IP_Purchase_Date__pc = l.IP_Purchase_Date__c;
                      }
                      accountMerge.add(cX);
                  }
              }
          }
          
          if(!lcrCreatedAccounts2.isEmpty()){
              for(Account cY : lcrCreatedAccounts2){
                  if(l.Id == l2Cmap.get(cY.Id)){

                    // updating Business Accounts into Person Accounts
                    cY.RecordTypeId=prsAccRTId;
                  }
              }            
          }
    System.debug('### lcrCreatedAccounts2 size = '+ lcrCreatedAccounts2.size());
      for(Account acc : lcrCreatedAccounts2){
        if(l.Id == l2Cmap.get(acc.Id) && prsAccRTId == acc.RecordTypeId){
          
          system.debug('### CREATED Account last name = '+ l.LastName); //updating newly converted Person Accounts
          Account cZ = new Account(Id = acc.Id);
          cZ.Marketing_Name__pc = l.FirstName;
          cZ.FirstName = l.FirstName; 
          cZ.LastName = l.LastName;
          cZ.Gender__pc = l.Gender__c;
          cZ.Other_Email__pc = l.Email;
          cZ.Phone = l.Phone;  
          cZ.Birthdate__pc = l.Date_of_Birth__c;
          cZ.PersonMailingStreet = l.Street;
          cZ.PersonMailingCity = l.City;
          cZ.PersonMailingState = l.State;
          cZ.PersonMailingPostalCode = l.PostalCode;
          cZ.PersonMailingCountry = l.Country;
          cZ.PersonLeadSource = l.LeadSource;  
          cZ.Contact_Source_Details__pc = l.Lead_Source_Details__c;
          cZ.Eloqua_Contact_ID__pc = l.Eloqua_Contact_ID__c;
          cZ.Subscriber_Status__pc = l.Subscriber_Status__c;
          cZ.Purchase_Channel__pc = l.Purchase_Channel__c;
          cZ.ConsumerID__c = l.Consumer_ID__c;
          cZ.D2C_Pre_Sales_Opt_In__pc = l.D2C_Pre_Sales_Opt_In__c;
          cZ.D2C_Contact__pc = TRUE;
          //cZ.RecordTypeId = consumerAccountRT; This logic is applicable when person account is not enabled in org, disabling it because Person Accounts are Enabled
          cZ.IP_Purchase_Date__pc = l.IP_Purchase_Date__c;
          //cZ.id = accVSPConsumerId; This logic is applicable when person account is not enabled in org, disabling it because Person Accounts are Enabled
          accountCreate.add(cZ);
        }
      }      
      
      //Business Account converted into Person Account
      update lcrCreatedAccounts2;    
      
      if(!accountMerge.isEmpty()){
          update accountMerge;
      }
      System.debug('### account create size = '+ accountcreate.size());
      if(!accountCreate.isEmpty()){
          update accountCreate;
      }
  ////Account Clean up
      List<Account> EmptyAccounts = [Select Id,Name from Account where Id not In (select AccountId from Contact) AND CreatedDate = Today AND Name IN :leadAccNames];
      if(!EmptyAccounts.isEmpty()){
          delete EmptyAccounts;
      }
    }
  }

  global void finish(Database.BatchableContext BC){}
      
  }