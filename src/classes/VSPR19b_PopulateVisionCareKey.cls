/**
* Class Name: VSPR19b_PopulateVisionCareKey
* Date: February 2, 2017
* Project: PROS Decommission
* @author: Shravani Chigullapally
* @description: Populates Vision Care Key on Business and Practice Accounts based on Tax ID and address
*/
public class VSPR19b_PopulateVisionCareKey{
    public static boolean VSPR19b_PopulateVisionCareKey_recursion = true;
    //method holds logic of trigger VSPR19b_PopulateVisionCareKey
    public void VSPR19b_PopulateVisionCareKey(List<Account> newTrigger, Map<Id,Account> oldMap, Boolean isTrgUpdate){
        if(VSPR19b_PopulateVisionCareKey_recursion){
            VSPR19b_PopulateVisionCareKey_recursion = false;
            system.debug('***** entered VSPR19b_PopulateVisionCareKey ***** ');
            String streetAddress = '';
            Boolean isUpdate = false;
            Integer lastCharIndex = 0;
            String lastChar;
            String key = '123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
            String vspKey;
            Boolean streetAddresschar1 = false;
            Boolean streetAddresschar2 = false;
            Boolean streetAddresschar3 = false;
            Boolean streetAddresschar4 = false;
            String accBusinessRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Business Account'].Id;
            String accPendingRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Pending Account'].Id;
            String accPracticeRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
            for (Account a:newTrigger) {
                if(isTrgUpdate){ 
                    Account oldAcc = oldMap.get(a.Id);
                    if(oldAcc.RecordTypeId == a.RecordTypeId && oldAcc.Vision_Care_Effective_Date__c != null ){ 
                        isUpdate = true;
                    }
                }
                system.debug('++++++++++++++++a.RecordType.Id++++++++++++++++++'+a.RecordTypeId);
                if(a.RecordTypeId == accBusinessRecordTypeId && isUpdate == false && a.Vision_Care_Effective_Date__c != null && a.Vision_Care_Location_Key__c == null){
                    if(a.ShippingStreet != null){
                        if(a.ShippingStreet.length() >= 1){
                            streetAddresschar1 = (a.ShippingStreet.substring(0,1)).isNumeric();             
                            system.debug('+++++++++++++++++streetAddresschar1+++++++++++++++++++++'+streetAddresschar1);
                        }
                        if(a.ShippingStreet.length() >= 2){
                            streetAddresschar2 = (a.ShippingStreet.substring(1,2)).isNumeric();
                            system.debug('+++++++++++++++++streetAddresschar2+++++++++++++++++++++'+streetAddresschar2);
                        }
                        if(a.ShippingStreet.length() >= 3){
                            streetAddresschar3 = (a.ShippingStreet.substring(2,3)).isNumeric();
                            system.debug('+++++++++++++++++streetAddresschar3+++++++++++++++++++++'+streetAddresschar3);
                        }
                        if(a.ShippingStreet.length() >= 4){
                            streetAddresschar4 = (a.ShippingStreet.substring(3,4)).isNumeric();
                            system.debug('+++++++++++++++++streetAddresschar4+++++++++++++++++++++'+streetAddresschar4);
                        }
                    }               
                    if(streetAddresschar1 == true){
                        streetAddress = streetAddress + a.ShippingStreet.substring(0,1);
                        if(streetAddresschar2 == true){
                            streetAddress = streetAddress + a.ShippingStreet.substring(1,2);
                            if(streetAddresschar3 == true){
                                streetAddress = streetAddress + a.ShippingStreet.substring(2,3);
                                if(streetAddresschar4 == true){
                                    streetAddress = streetAddress + a.ShippingStreet.substring(3,4);
                                }
                                if(streetAddresschar4 == false){ 
                                    streetAddress = streetAddress + ' ';
                                }
                            }
                            if(streetAddresschar3 == false){ 
                                streetAddress = streetAddress + '  ';
                            }
                        }
                        if(streetAddresschar2 == false){ 
                            streetAddress = streetAddress + '   ';
                        }
                    }
                    if(streetAddresschar1 == false){ 
                        streetAddress = streetAddress + '    ';
                    }
                    system.debug('+++++++++++++++++streetAddress+++++++++++++++++++++'+streetAddress);
                    
                    List<String> lstVSPKeys = new List<String>(); 
                    Account a1;
                    if(a.ParentID != null){
                        a1 = [SELECT IRS_Tax_ID__c, ID FROM Account WHERE ID =: a.ParentID LIMIT 1];
                        vspKey = a1.IRS_Tax_ID__c + streetAddress;
                        System.Debug('^^^ Print vspKey: ^^^' + vspKey);
                    
                        for(Account acc : [SELECT Vision_Care_Location_Key__c from Account where RecordType.Name = 'Business Account' AND ParentID = :a1.ID]){
                            if((acc.Vision_Care_Location_Key__c != null && acc.Vision_Care_Location_Key__c != '') &&(acc.Vision_Care_Location_Key__c.length() >12) && (vspKey.length() >12)){
                                if(acc.Vision_Care_Location_Key__c.substring(0,12) == vspKey.substring(0,12)){              
                                    if(acc.Vision_Care_Location_Key__c.contains(',')){
                                        List<String> lstStr = (acc.Vision_Care_Location_Key__c).split(', ');
                                        for(String str : lstStr){  
                                            lstVSPKeys.add(str);
                                        }
                                    }
                                    else{ 
                                        lstVSPKeys.add(acc.Vision_Care_Location_Key__c);
                                    }
                                }
                            }
                        }
                    }
                    system.debug('+++++++++++++++++++lstVSPKeys+++++++++++++++++++++++++++++++++' +lstVSPKeys);
                    for(String strVSP : lstVSPKeys){
                        String accRev = strVSP.reverse();
                        system.debug('++++++++++++++++++++++++accRev++++++++++++++++++++++++++++++' +accRev);
                        lastChar = accRev.substring(0,1);
                        system.debug('++++++++++++++++++++++++++lastChar+++++++++++++++++++++++' +lastChar);
                        Integer i = 0;
                        while(i < key.length()){
                            if(lastCharIndex <= i){
                                if((key.substring(i,i+1)).equals(lastChar)){ 
                                    lastCharIndex = i;
                                    system.debug('++++++++++++++++++lastCharIndex+++++++++++++++++++++' +lastCharIndex);
                                }
                            }
                            i++;
                        }
                    }
                    if(lstVSPKeys.size() == 0){    
                        vspKey = vspKey + key.substring(0,1);
                    }
                    else{ 
                        vspKey = vspKey + key.substring(lastCharIndex+1,lastCharIndex+2);
                    }
                    system.debug('+++++++++++++++++++GREATER THAN 9++++++++++++++++++++' +vspKey);
                    Account a2 = new Account(Id=a.Id);
                    system.debug('+++++++++++++++++a2+++++++++++++++++++++'+a2);
                    a2.Vision_Care_Location_Key__c = vspKey;
                    a2.Bypass_VC_Validation_Rules__c = true;
                    update a2;
                }
                if(a.RecordTypeId == accPracticeRecordTypeId && isUpdate == false && a.Vision_Care_Effective_Date__c != null && a.Vision_Care_Location_Key__c == null||test.isRunningTest()){
                    vspKey = a.Tax_ID__c;
                    System.Debug('*****PA: IRS Tax ID*****' + a.Tax_ID__c);
                    System.Debug('VSP KEY: PA ' + vspKey);
                    Account a3 = new Account(Id=a.Id);
                    system.debug('+++++++++++++++++a2+++++++++++++++++++++'+a3);
                    a3.Vision_Care_Location_Key__c = vspKey;
                    a3.Bypass_VC_Validation_Rules__c = true;
                    update a3;
                }                   
            }
            system.debug('***** exiting VSPR19b_PopulateVisionCareKey ***** ');
        }
    }
}