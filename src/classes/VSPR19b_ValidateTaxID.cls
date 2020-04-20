/**
* Class Name: VSPR19b_ValidateTaxID
* Date: June 13, 2017
* Project: PROS Decommission
* @author: Shravani Chigullapally
* @description: Populates Vision Care End Date to a Business Account's related Network Relationship records
*/

public class VSPR19b_ValidateTaxID{
public static boolean VSPR19b_ValidateTaxID_recursion = true;
    //method holds logic of trigger VSPR19b_ValidateTaxID
    public void VSPR19b_ValidateTaxID(List<Account> newTrigger, Map<Id,Account> oldMap, Boolean isTrgUpdate){
        if(VSPR19b_ValidateTaxID_recursion){
            VSPR19b_ValidateTaxID_recursion = false;
            system.debug('***** entered VSPR19b_ValidateTaxID ***** ');
            String last4TaxID, taxID, irsTaxID, accountName;
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            String praAccRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
            List<Account> taxIDMatchOnLast4;
            Boolean matchOnTaxID = false, matchOnIRSTaxID = false;
            //Boolean isUpdateTaxID = false;
            //Boolean isUpdateIRSTaxID = false;
            Boolean isUpdate = false;
            List<Account> taxIDMatch, irsTaxIDMatch;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { 
                return; 
            }
            if(profileName != 'System Administrator' || profileName !='VSP Technical User'){
                for(Account a : newTrigger){
                    if(isTrgUpdate){
                        Account oldAcc = oldMap.get(a.Id);
                        if(oldAcc.Tax_ID__c == a.Tax_ID__c && oldAcc.IRS_Tax_ID__c == a.IRS_Tax_ID__c){
                            isUpdate = true;
                        }
                        //if(oldAcc.IRS_Tax_ID__c == a.IRS_Tax_ID__c){
                            //isUpdateIRSTaxID = true;
                        //}
                    }
                    if(a.Tax_ID__c != null){
                        if(a.RecordTypeId == praAccRecordTypeId){
                            if(!TEST.ISRUNNINGTEST())
                                //last4TaxID = a.Tax_ID__c.substring(5); 
                            taxID = a.Tax_ID__c;
                            accountName = a.Common_Account_Name_Report__c;
                        }                            
                    }
                    if(a.IRS_Tax_ID__c != null){
                        if(a.RecordTypeId == praAccRecordTypeId){                                 
                            irsTaxID = a.IRS_Tax_ID__c;
                            accountName = a.Common_Account_Name_Report__c;
                        }
                    }
                }
                
                if(taxID != NULL) {
                    List<Account> lst = [Select Id, Name, Tax_ID__c, IRS_Tax_ID__c, Common_Account_Name_Report__c from Account where IRS_Tax_ID__c = :taxID and RecordType.Id =:praAccRecordTypeId];
                    if(lst.size() > 0 && lst != null){
                        for(Account a : lst){
                            if(accountName != a.Common_Account_Name_Report__c){
                                matchOnTaxID = true;
                            }
                        }
                    }
                }
                
                if(irsTaxID != NULL) {
                    List<Account> lst = [Select Id, Name, Tax_ID__c, IRS_Tax_ID__c, Common_Account_Name_Report__c from Account where (IRS_Tax_ID__c = :irsTaxID OR Tax_ID__c = :irsTaxID) and RecordTypeId = :praAccRecordTypeId];
                    if(lst.size() > 0 && lst != null){
                        for(Account a : lst){
                            if(accountName != a.Common_Account_Name_Report__c){
                                matchOnIRSTaxID = true;
                            }
                        }
                    }
                }
               
                for(Account acc : newTrigger){
                    if(stoprecursion.runonce()){
                        if(acc.RecordTypeId == praAccRecordTypeId){
                            
                            system.debug('++++++++++++ matchOnTaxID ++++++++++++++++++++' +matchOnTaxID);
                            system.debug('++++++++++++ matchOnIRSTaxID ++++++++++++++++++++' +matchOnIRSTaxID);
                            system.debug('++++++++++++ isUpdate ++++++++++++++++++++' +isUpdate);
                            system.debug('++++++++++++ acc.Tax_ID__c ++++++++++++++++++++' +acc.Tax_ID__c);
                            system.debug('++++++++++++ acc.IRS_Tax_ID__c ++++++++++++++++++++' +acc.IRS_Tax_ID__c);
                        
                            if(matchOnTaxID == true && acc.Tax_ID__c != null && isUpdate == false){
                                acc.id.addError('A Practice Account already exists with this Tax ID.');                   
                            }
                            if(matchOnIRSTaxID == true && acc.IRS_Tax_ID__c != null && isUpdate == false){
                                acc.id.addError('A Practice Account already exists with this IRS Tax ID.');                   
                            }
                            //if(matchOnTaxID == true && matchOnIRSTaxID == true && acc.Tax_ID__c != null && acc.IRS_Tax_ID__c !=null && isUpdate == false ){
                            //    acc.id.addError('A Practice Account already exists with this Tax ID.');                   
                            //}
                        }
                    }
                }
            } 
            system.debug('***** exiting VSPR19b_ValidateTaxID ***** ');  
        }
    }
}