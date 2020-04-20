/**
 * Trigger Name: VSPR1_AddressBL
 * @author: Marvin B. Gatchalian
 * Date: 18.JUNE.2013
 * Requirement/Project Name: VSP
 * @description: updateAccountAddressInfo method handles updating of Account Address Info.
 */

public with sharing class VSPR1_AddressBL { 
    
    Map<id,Address__c> AddressMap = new Map<id,Address__c>();       
    Map<id,Address_Relationship__c> AddRelMap = new Map<id,Address_Relationship__c>();
    Set<Id> addressIds = new Set< ID >();
    
        public VSPR1_AddressBL(List<Address__c> newTrigger, List<Address__c> oldTrigger, Map<id,Address__c> TriggerMap, Boolean isDelete, Boolean isInsert){
            system.debug('>>> Enter VSPR1_AddressBL');
            AddressMap = TriggerMap;
            
            for(Address__c Address : newTrigger){
                //if (Address.Address_Type__c == 'Physical'){
                    addressIds.add(Address.id);
                //} 
            } 
            updateAccountAddressInfo(); 
            
        }
        
        public void updateAccountAddressInfo() {
           Set<Id> accountIds = new Set<Id>();

            List<Address_Relationship__c> addressRelationIds = VSPR1_AddressRelationshipDML.getAddressRelationDetails(addressIds);
        
             for(Address_Relationship__c AddressR : addressRelationIds){
                accountIds.add(AddressR.Account__c);

           }
          
          /*  Set<Id> accountIds = new Set<Id>();
            List<Account> myAccount = new List<Account>();
            List<Address_Relationship__c> addressRelationIds1 = new List<Address_Relationship__c>();
            id addrresRTempID;
            Map <id,id> AddressRelationShipMap = new Map <id,id>();
            
            //system.assertequals(addressIds, null);
            List<Address_Relationship__c> addressRelationIds = VSPR1_AddressRelationshipDML.getAddressRelationDetails(addressIds);
            Map<id,Address_Relationship__c> AddRelMap = new Map<id,Address_Relationship__c>(VSPR1_AddressRelationshipDML.getAddressRelationDetails(addressIds));
            //system.assertEquals(addressRelationIds.size(), null);
            
            // Get account at create Map Account and Adress
            Map<Id, String> AccIdAccAndAdd = new Map<Id, String>();
             
            for(Address_Relationship__c Address : addressRelationIds){
                //system.debug('>>>AddressId---' + AddressR.address__c);
                accountIds.add(Address.Account__c);
                AccIdAccAndAdd.put(Address.Account__c,String.valueOf(Address.Account__c) + ',' 
                      + String.valueOf(Address.address__c) + ',' + String.valueOf(Address.status__c));
                //AddressRelationShipMap.put(AddressR.Account__c, AddressR.address__c);
            }
            
            myAccount = VSPR1_AccountDML.getAccountDetails(accountIds);
            
            
            List<String> splitted = new List<String>();   
            id curAccountID; 
            id curAddressID;
            String curStatus;
            Address__c tempListAdd = new Address__c();
            
            for (Account curAccount: myAccount){
                    
                  String s = AccIdAccAndAdd.get(curAccount.id);
                    splitted = s.split(',');
                    curAccountID = splitted[0];
                    curAddressID = splitted[1];
                    curStatus = splitted[2];
                    
                        
                        if(AddressMap.containsKey(curAddressID)) {
                            tempListAdd = AddressMap.get(curAddressID);
                        // system.assertEquals(tempListAdd.Address_Type__c, null);
                         //system.assertEquals(1, null);
                            if (curStatus == 'I' || tempListAdd.Address_Type__c != 'Physical') {
                                curAccount.Physical_City__c = '';
                                curAccount.Physical_Country__c = '';
                                curAccount.Physical_State__c = '';
                                curAccount.Physical_Street__c = '';
                                curAccount.Physical_Zip_Code__c = '';
                                curAccount.Physical_Physical_County__c = '';
                            }
                            else if(tempListAdd.Address_Type__c == 'Physical' && curStatus == 'A' ) {
                                curAccount.Physical_City__c = tempListAdd.City__c;
                                curAccount.Physical_Country__c = tempListAdd.Country__c;
                                curAccount.Physical_State__c = tempListAdd.State__c;
                                curAccount.Physical_Street__c = tempListAdd.Street__c;
                                curAccount.Physical_Zip_Code__c = tempListAdd.Zip__c; 
                                curAccount.Physical_Physical_County__c = tempListAdd.County__c;
                            }
                        
                        }
                    

                //system.assertEquals(curAccount.id, null);
                //myCurAddressID =  AddressRelationShipMap.get(curAccount.id);  to get the address id from Mapping
                //System.debug('>>>>UpdateMARVZ' + AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Country__c);
                //system.assertEquals(AddressRelationShipMap.get(curAccount.id), 'asdasd');
                //addrresRTempID = AddressRelationShipMap.get(curAccount.id);
                
                //if (AddressRelationShipMap.containskey(curAccount.id)) {
                //  system.assertEquals(AddressRelationShipMap.size(), null);   
                //}
                
                //if (AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Address_Type__c == 'Physical'){
                    
                    //if ()
                //  addid = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).id;
                //  system.assertEquals(addid, null);
                //  system.assertequals(AddRelMap.get(AddressMap.get(AddressRelationShipMap.get(curAccount.id)).id).status__c, null);
                //  curAccount.Physical_City__c = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).City__c;
                //  curAccount.Physical_Country__c = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Country__c;
                //  curAccount.Physical_State__c = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).State__c;
                //  curAccount.Physical_Street__c = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Street__c;
                //  curAccount.Physical_Zip_Code__c = AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Zip__c;
                //}
                //else if (AddressMap.get(AddressRelationShipMap.get(curAccount.id)).Address_Type__c != 'Physical'){
                //  curAccount.Physical_City__c = '';
                //  curAccount.Physical_Country__c = '';
                //  curAccount.Physical_State__c = '';
                //  curAccount.Physical_Street__c = '';
                //  curAccount.Physical_Zip_Code__c = '';
                    //AccountNoAddress.add(curAccount.id);
                //}
            }
            //system.assertEquals(AccountNoAddress.size(), null);
            //update  myAccount;
            // we need to requery address relationship to get all account regardless of the status          
            //ddressRelationIds = VSPR1_AddressRelationshipDML.getAddressRelationActive(addressIds);
            //for(Address_Relationship__c AddressR : addressRelationIds){
            //  system.debug('>>>AddressId---' + AddressR.address__c);
            //  accountIds.add(AddressR.Account__c);
            //} */
            
            if (accountIds.size() > 0) { 
                VSPR1_FindCorrectAddress.findAddress(accountIds);   
            }
            
        }
}