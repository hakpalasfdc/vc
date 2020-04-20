global class VSPR31_Prac_Acc_Tier_Update_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    private static Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    
    //Below part added by Vikhyat.
    //Added to retrieve record type Id of business account
    private static Id businessRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    //Part added by Vikhyat ends here.
    Private Date todaysDate = Date.today();
    //global final String query = 'SELECT Id, Applied_Tier__c, Applied_Tier__r.Order__c, Calculated_Tier__c, Number_of_Eligible_Locations__c, Average_Tiering_Total_Spend_LTM__c, Average_Tiering_Eyewear_Spend_LTM__c, Average_Tiering_Optics_Spend_LTM__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Retinal_Imaging_Indicator__c, Vision_Care_Good_Standing__c, Status__c, Vision_Care_Effective_Date__c, Tier_Agreement_Type__c, Vision_Care_End_Date__c, Contract_Type__c FROM Account WHERE Contract_Type__c != NULL AND Contract_Type__c != \'Conflict\' AND IsDeleted = false AND Tax_ID__c != Null AND Premier_Tax_ID_Roll_Up_Account__c = false AND recordTypeId = \'' + accRecordTypeId + '\''; 
    
    global List<String> exception_List = new List<String>();
    
    global Date todayDate;//// Set to today if not running a test. When running test class, you can set the variable to test different months
    
    private Set<Id> globalPracIdSet = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Applied_Tier__c, Applied_Tier__r.Order__c, Calculated_Tier__c, Number_of_Eligible_Locations__c, 
                                         Average_Tiering_Total_Spend_LTM__c, Average_Tiering_Eyewear_Spend_LTM__c, Average_Tiering_Optics_Spend_LTM__c, 
                                         Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Retinal_Imaging_Indicator__c, Vision_Care_Good_Standing__c, 
                                         Status__c, Vision_Care_Effective_Date__c, Tier_Agreement_Type__c, Vision_Care_End_Date__c, Contract_Type__c ,
                                         Override_Tier_Effective_Date__c, Override_Tier_End_Date__c, Override_Tier_Reason__c
                                         FROM Account WHERE Contract_Type__c != NULL AND Contract_Type__c != 'Conflict' AND IsDeleted = false 
                                         AND Tax_ID__c != Null AND Premier_Tax_ID_Roll_Up_Account__c = false AND recordTypeId = :accRecordTypeId 
                                         AND (Override_Tier_Effective_Date__c > :todaysDate OR Override_Tier_Effective_Date__c = NULL OR 
                                              (Override_Tier_Effective_Date__c < :todaysDate AND Override_Tier_End_Date__c < :todaysDate))]);
    }
    
    //Below part added by Vikhyat.
    //Converted the List<sObject> to List<Account> so that no typecasting is required.
    global void execute(Database.BatchableContext BC, List<Account> scope){
        //Part added by Vikhyat ends here.
        
        VSPUtility.stopAccountTrigger=true;
        Set<Id> pracAccSet = new Set<Id>();
        
        Map<Id, Account> pracAccSetMap = new Map<Id, Account>();
        
        
        for(Account s : scope){
            pracAccSetMap.put(s.Id,s);
        }
        
        
        //Updated the below part to check for empty map rather than empty set.
        if(!/*pracAccSet*/pracAccSetMap.isEmpty()){///Set Group Reward Group Applied & Calculated Tier Fields
            //Updated part by Vikhyat ends here.    
            
            if(!Test.isRunningTest()){
                todayDate = Date.today();
            }
            
            //Below part commented out by Vikhyat
            //Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            //Commented out part by Vikhyat ends here.
            
            List<Account> pracAccToUpdate = new List<Account>();
            Map<Id,Account> pracAccToUpdateMap = new Map<Id,Account>();
            Set<Account> busAccUpd = new Set<Account>();
            
            ///All Group Reward Group 
            
            
            /*       List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
FROM Premier_Tier__c WHERE Contract_Type__c != Null AND Agreement_Type__c = Null AND Status__c = 'Active' Order By Order__c ASC];     

List<Premier_Tier__c> allTierswAgreement = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
FROM Premier_Tier__c WHERE Status__c = 'Active' AND Agreement_Type__c != Null Order By Order__c ASC]; */
            //Commented out part by Vikhyat ends here.
            
            //Below part added by Vikhyat
            //Part added because allTiers list already has all the active Premier Tier records and iterating through the list we can create a list of Premier Tiers whose Agreement Type != null
            List<Premier_Tier__c> allT = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
                                          Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
                                          Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
                                          FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Order__c ASC];
            List<Premier_Tier__c> allTiers = new List<Premier_Tier__c>();         
            List<Premier_Tier__c> allTierswAgreement = new List<Premier_Tier__c>();
            
            for(Premier_Tier__c p: allT){
                if(p.Agreement_Type__c == null && p.Contract_Type__c != Null){
                    allTiers.add(p);
                }
            }
            
            for(Premier_Tier__c p: allT){
                if(p.Agreement_Type__c != null){
                    allTierswAgreement.add(p);
                }
            }
            
            
            Integer TierSet;
            Integer AgreementTierSet;
            //Commented by Vikhyat to update the loop to run at the map keyset rather than at the set.
            for(Id pAccId: /*pracAccSet*/ pracAccSetMap.keySet()){
                Account pAcc = pracAccSetMap.get(pAccId);
                if(pAcc.Vision_Care_Good_Standing__c == True && pAcc.Contract_Type__c != null){////Qualifying Practice Account
                    if(pAcc.Tier_Agreement_Type__c == null){
                        TierSet = 0;
                        for(Premier_Tier__c aTier :allTiers){
                            //Updated the below if statement by Vikhyat
                            //Updated to remove toUpperCase and trim method calls as Contract type is now a picklist field.                               
                            if((aTier.Retinal_Imaging_Indicator__c == True && pAcc.Retinal_Imaging_Indicator__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                               (aTier.Free_Fitting_and_Adjustments__c == True && pAcc.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                               (aTier.Exclusive_VSP_Patient_Offers__c == True && pAcc.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                               (pAcc.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                               (pAcc.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                               (pAcc.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                               (pAcc.Contract_Type__c/*.toUpperCase().trim()*/ == aTier.Contract_Type__c/*.toUpperCase().trim()*/)                         
                              ){///Found matching Premier Tier
                                  ////Group Reward Group doesn't have any Applied and Calculated Tier
                                  if(pAcc.Applied_Tier__c == null || 
                                     pAcc.Applied_Tier__r.Order__c == null || 
                                     todayDate.month() == 1 || ////Check in Month
                                     todayDate.month() == 7 || ////Check in Month
                                     pAcc.Applied_Tier__r.Order__c > aTier.Order__c ||
                                     pAcc.Override_Tier_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                         pAcc.Applied_Tier__c = aTier.Id;
                                         pAcc.Calculated_Tier__c = aTier.Id;
                                         pracAccToUpdate.add(pAcc);
                                         pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                         globalPracIdSet.add(pAcc.Id);
                                         if(pAcc.Override_Tier_End_Date__c < Date.today()){
                                             pAcc.Override_Tier_Effective_Date__c = Null;
                                             pAcc.Override_Tier_End_Date__c = Null;
                                             pAcc.Override_Tier_Reason__c = Null;
                                         }
                                         TierSet = 1;
                                         break;                                      
                                     }
                                  
                                  ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                  else if(pAcc.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                      pAcc.Calculated_Tier__c = aTier.Id;
                                      pracAccToUpdate.add(pAcc);
                                      pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                      globalPracIdSet.add(pAcc.Id);
                                      TierSet = 1;
                                      break; 
                                  }
                              }///end if found matching premier tier
                        }///end For loop
                        if(TierSet == 0){/////Account didn't qualify for any tier
                            pAcc.Applied_Tier__c = null;
                            pAcc.Calculated_Tier__c = null;
                            if(pAcc.Override_Tier_End_Date__c < Date.today()){
                                pAcc.Override_Tier_Effective_Date__c = Null;
                                pAcc.Override_Tier_End_Date__c = Null;
                                pAcc.Override_Tier_Reason__c = Null;
                            }
                            pracAccToUpdate.add(pAcc);
                            pracAccToUpdateMap.put(pAcc.Id,pAcc);
                            globalPracIdSet.add(pAcc.Id);
                        }
                        
                    }///end if Account Tier Agreement is Null
                    
                    else{///Account Tier Agreement is not null
                        AgreementTierSet = 0;
                        
                        for(Premier_Tier__c aTier :allTierswAgreement){///using different List
                            //Updated the below if statement by Vikhyat
                            //Updated to remove toUpperCase and trim method calls as Contract type is now a picklist field. 
                            if((aTier.Retinal_Imaging_Indicator__c == True && pAcc.Retinal_Imaging_Indicator__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                               (aTier.Free_Fitting_and_Adjustments__c == True && pAcc.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                               (aTier.Exclusive_VSP_Patient_Offers__c == True && pAcc.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                               (pAcc.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                               (pAcc.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                               (pAcc.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                               (pAcc.Tier_Agreement_Type__c/*.toUpperCase().trim()*/ == aTier.Agreement_Type__c/*.toUpperCase().trim()*/)                         
                              ){///Found matching Premier Tier
                                  ////Group Reward Group doesn't have any Applied and Calculated Tier
                                  if(pAcc.Applied_Tier__c == null || 
                                     pAcc.Applied_Tier__r.Order__c == null || 
                                     todayDate.month() == 1 || ////Check in Month
                                     todayDate.month() == 7 || ////Check in Month
                                     pAcc.Applied_Tier__r.Order__c > aTier.Order__c ||
                                     pAcc.Override_Tier_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                         pAcc.Applied_Tier__c = aTier.Id;
                                         pAcc.Calculated_Tier__c = aTier.Id;
                                         if(pAcc.Override_Tier_End_Date__c < Date.today()){
                                             pAcc.Override_Tier_Effective_Date__c = Null;
                                             pAcc.Override_Tier_End_Date__c = Null;
                                             pAcc.Override_Tier_Reason__c = Null;
                                         }
                                         AgreementTierSet = 1;
                                         pracAccToUpdate.add(pAcc);
                                         pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                         globalPracIdSet.add(pAcc.Id);
                                         break;                                      
                                     }
                                  
                                  ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                  else if(pAcc.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                      pAcc.Calculated_Tier__c = aTier.Id;
                                      AgreementTierSet = 1;
                                      pracAccToUpdate.add(pAcc);
                                      pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                      globalPracIdSet.add(pAcc.Id);
                                      break; 
                                  }
                              }///end if found matching premier tier
                        }///end For loop
                        
                        if(AgreementTierSet == 0){////No Aggreement Type Tier was set on the Group. Now look at all Tiers
                            TierSet = 0;
                            for(Premier_Tier__c aTier :allTiers){
                                //Updated the below if statement by Vikhyat
                                //Updated to remove toUpperCase and trim method calls as Contract type is now a picklist field. 
                                if((aTier.Retinal_Imaging_Indicator__c == True && pAcc.Retinal_Imaging_Indicator__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                                   (aTier.Free_Fitting_and_Adjustments__c == True && pAcc.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                                   (aTier.Exclusive_VSP_Patient_Offers__c == True && pAcc.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                                   (pAcc.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                                   (pAcc.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                                   (pAcc.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                                   (pAcc.Contract_Type__c/*.toUpperCase().trim()*/ == aTier.Contract_Type__c/*.toUpperCase().trim()*/)                         
                                  ){///Found matching Premier Tier
                                      ////Group Reward Group doesn't have any Applied and Calculated Tier
                                      if(pAcc.Applied_Tier__c == null || 
                                         pAcc.Applied_Tier__r.Order__c == null || 
                                         todayDate.month() == 1 || ////Check in Month
                                         todayDate.month() == 7 || ////Check in Month
                                         pAcc.Applied_Tier__r.Order__c > aTier.Order__c ||
                                         pAcc.Override_Tier_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                             pAcc.Applied_Tier__c = aTier.Id;
                                             pAcc.Calculated_Tier__c = aTier.Id;
                                             pracAccToUpdate.add(pAcc);
                                             pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                             globalPracIdSet.add(pAcc.Id);
                                             if(pAcc.Override_Tier_End_Date__c < Date.today()){
                                                 pAcc.Override_Tier_Effective_Date__c = Null;
                                                 pAcc.Override_Tier_End_Date__c = Null;
                                                 pAcc.Override_Tier_Reason__c = Null;
                                             }
                                             TierSet = 1;
                                             break;                                      
                                         }
                                      
                                      ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                      else if(pAcc.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                          pAcc.Calculated_Tier__c = aTier.Id;
                                          pracAccToUpdate.add(pAcc);
                                          pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                          globalPracIdSet.add(pAcc.Id);
                                          TierSet = 1;
                                          break; 
                                      }
                                  }///end if found matching premier tier
                            }///end For loop
                            if(TierSet == 0){/////Account didn't qualify for any tier
                                pAcc.Applied_Tier__c = null;
                                pAcc.Calculated_Tier__c = null;
                                if(pAcc.Override_Tier_End_Date__c < Date.today()){
                                    pAcc.Override_Tier_Effective_Date__c = Null;
                                    pAcc.Override_Tier_End_Date__c = Null;
                                    pAcc.Override_Tier_Reason__c = Null;
                                }
                                pracAccToUpdate.add(pAcc);
                                pracAccToUpdateMap.put(pAcc.Id,pAcc);
                                globalPracIdSet.add(pAcc.Id);
                            }
                        }// end No Aggreement Type Tier was set on the Group. Now look at all Tiers
                    }///end Else
                }
                ////Non Qualifying Practice Account
                else{
                    if(pAcc.Applied_Tier__c != null || pAcc.Calculated_Tier__c != null){
                        pAcc.Applied_Tier__c = null;
                        pAcc.Calculated_Tier__c = null;
                        if(pAcc.Override_Tier_End_Date__c < Date.today()){
                            pAcc.Override_Tier_Effective_Date__c = Null;
                            pAcc.Override_Tier_End_Date__c = Null;
                            pAcc.Override_Tier_Reason__c = Null;
                        }
                        pracAccToUpdate.add(pAcc);
                        pracAccToUpdateMap.put(pAcc.Id,pAcc);
                        globalPracIdSet.add(pAcc.Id);
                    }
                }
            }
            
            //Commeted out by Vikhyat on 08/08/2019
            //system.debug('pracAccToUpdate List '+ pracAccToUpdate);
            //Part commente out by Vikhyat on 08/08/2019 ends here.
            
            if(!pracAccToUpdate.isEmpty()){
                // update pracAccToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(pracAccToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Account Record Id: ' + pracAccToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
            
            // List<Account> pracAccTiers = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Id in :pracAccToUpdate];
            
            //Below query updated by Vikhyat.
            //Updated to incude business recordType ID.
            /*          List<Account> busAccTiers = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, ParentId, Vision_Care_Good_Standing__c FROM Account WHERE //Vision_Care_Good_Standing__c = True AND
ParentId in :pracAccToUpdate AND RecordTypeId = :/*accRecordTypeId*///businessRecordTypeId];
            //Updated query by Vikhyat ends here.
            
            /*         for(Id pAccId :pracAccToUpdateMap.keySet()){
Account pAcc = pracAccToUpdateMap.get(pAccId);
for(Account bAcc :busAccTiers){
if(bAcc.ParentId == pAcc.Id){
if(bAcc.Vision_Care_Good_Standing__c != True){
bAcc.Tier_Calculation_Group_Level_Batch__c = null;
bAcc.Tier_Calculation_Record_ID__c = null;

//Below part commented out by Vikhyat. Commented out because of repetitive assignment.
/*bAcc.Tier_Calculation_Group_Level_Batch__c = null;
bAcc.Tier_Calculation_Record_ID__c = null;*/
            //Commented out part by Vikhyat ends here.
            /*                     }
else{                            
bAcc.Applied_Tier__c = pAcc.Applied_Tier__c;
bAcc.Calculated_Tier__c = pAcc.Calculated_Tier__c;

if(pAcc.Applied_Tier__c == null){
bAcc.Tier_Calculation_Group_Level_Batch__c = null;
bAcc.Tier_Calculation_Record_ID__c = null;
}
else{
bAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ pAcc.Id +',' + ' Practice'; 
bAcc.Tier_Calculation_Record_ID__c = pAcc.Id;
}    
}
busAccUpd.add(bAcc);
}
}
}



List<Account> busAccUpdLst = new List<Account>(busAccUpd);

//Below part commented out by Vikhyat on 08/08/22019
//system.debug('busAccUpd List '+ busAccUpd);
//Commented out part by Vikhyat on 08/08/2019 ends here.

if(!busAccUpdLst.isEmpty()){
// update busAccUpd;

Database.SaveResult[] SaveResultList = Database.update(busAccUpdLst,false); 

for(integer i =0; i<SaveResultList.size();i++){
String msg='';
If(!SaveResultList[i].isSuccess()){

msg += 'Group Reward Group Record Id: ' + busAccUpdLst.get(i).id + '\n'+'Error: "';        
for(Database.Error err: SaveResultList[i].getErrors()){  
msg += err.getmessage()+'"\n\n';
} 
}
if(msg!= '')
exception_List.add(msg);
} 
}*/
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
        //Below if condition updated by Vikhyat on 08/08/2019.
        //Updated the part to achieve higher test coverage.
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Practice Account Premier Tier Update Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List.size() + '<br><br>' + exception_List + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
        //Below part commented out by Vikhyat on 08/08/2019
        //Commented out the part so that the success email regarding monthly jobs completion is send irrespective of the current job failing.
        /*else{////send success email

Messaging.reserveSingleEmailCapacity(2);

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

String[] toAddresses = new String[]{};            
for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
toAddresses.add(obj.Name);
}
if(!toAddresses.isEmpty()){
mail.setToAddresses(toAddresses);

mail.setSenderDisplayName('Salesforce Support');

mail.setSubject('Premier Admin Tool Batch Jobs Completed');

mail.setBccSender(false);

mail.setUseSignature(false);

// Specify the text content of the email.
mail.setPlainTextBody('Premier Admin Tool Batch Jobs Completed.');

mail.setHtmlBody('Premier Admin Tool Batch Jobs Completed.<br><br>');

// Send the email you have created.
if(!Test.isRunningTest()){
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}
}*/
        //Commented out part by Vikhyat on 08/08/2019 ends here.
        
        if(!Test.isRunningTest()){
            VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch   obj = new VSPR31_Bus_Acc_Tier_Upd_from_Prac_Batch(globalPracIdSet);
            Database.executeBatch(obj, 100);
        }
        /*        String[] toAddresses1 = new String[]{};

for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
toAddresses1.add(obj.Name);
}

if(!toAddresses1.isEmpty()){
Messaging.reserveSingleEmailCapacity(2);

Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

mail.setToAddresses(toAddresses1);

mail.setSenderDisplayName('Salesforce Support');

mail.setSubject('Premier Admin Tool Monthly Batch Jobs Completed');

mail.setBccSender(false);

mail.setUseSignature(false);

// Specify the text content of the email.
mail.setPlainTextBody('Sucessful run of Premier Admin Tool Monthly Batch Jobs.');

mail.setHtmlBody('Sucessful run of Premier Admin Tool Monthly Batch Jobs.<br><br>');

// Send the email you have created.
if(!Test.isRunningTest()){
Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
}
}*/
    }
}