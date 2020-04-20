public with sharing class VSPR1_FindCorrectAddress { 
    public static List<Account> myAccount;
    
    public static void findAddress(Set<Id> accountIds){
        system.debug('>>> Enter findAddress');
        
        List<Address_Relationship__c> Addresses = new List<Address_Relationship__c>();
        myAccount = new List<Account>(VSPR1_AccountDML.getAccountDetails(accountIds));
        Set<Id> addressIds = new Set<Id>();
        
        system.debug('--------accountIds---'+accountIds);
        Addresses = VSPR1_AddressRelationshipDML.getAddressRelationbyAccount(accountIds); 
         system.debug('--------Addresses---'+Addresses);
         system.debug('--------Addresses------SIZE------'+Addresses.size());
        Map<Id, String> AccIdAccAndAdd = new Map<Id, String>();
        Map<Id, String> AccIdAccAndAdd2 = new Map<Id, String>();
        
         
        List <String> AccAndAdd = new List <String>();
         
        for(Address_Relationship__c Address : Addresses){
                addressIds.add(Address.address__c);
                AccAndAdd.add(String.valueOf(Address.Account__c) + ',' + String.valueOf(Address.address__c));                    

                if (!AccIdAccAndAdd.containsKey(Address.Account__c)) {
                    AccIdAccAndAdd.put(Address.Account__c,String.valueOf(Address.Account__c) + ',' + String.valueOf(Address.address__c) + ',' + String.valueOf(Address.Address_Type__c));
                }
                else {
                    AccIdAccAndAdd2.put(Address.Account__c,String.valueOf(Address.Account__c) + ',' + String.valueOf(Address.address__c) + ',' + String.valueOf(Address.Address_Type__c));
                }

        }

    
        map<id,Address__c> AddressMap = new map<id,Address__c>(VSPR1_AddressDML.getAddressPhysicalOnly(addressIds));
        
        List<String> splitted = new List<String>();  
        List<String> splitted2 = new List<String>(); 
        id curAccountID; 
        id curAddressID;
        id curAccountID2; 
        id curAddressID2;
        Address__c tempListAdd = new Address__c();
    
        if (Addresses.size() <= 0 || AddressMap.size() <= 0 ) {
            for(Account curAccount : myAccount) {
                curAccount.ShippingCity = '';
                curAccount.ShippingCountry = '';
                curAccount.ShippingState = '';
                curAccount.ShippingStreet = '';
                curAccount.ShippingPostalCode = '';
                curAccount.Physical_County__c = '';
                
            }
        }
        else if (Addresses.size() > 0) {
            
            for(Account curAccount : myAccount) {
               
                if (AccIdAccAndAdd.containsKey(curAccount.id)) {
                    String s = AccIdAccAndAdd.get(curAccount.id);
                    splitted = s.split(',');
                    curAccountID = splitted[0];
                    curAddressID = splitted[1];
                }
                else {
                    curAddressID = '000000000000000000';
                }
                
                
                if (AccIdAccAndAdd2.containsKey(curAccount.id)) {
                    String s2 = AccIdAccAndAdd2.get(curAccount.id);
                    splitted2 = s2.split(',');
                    curAccountID2 = splitted2[0];
                    curAddressID2 = splitted2[1];
                }
                else {
                    curAddressID2 = '000000000000000000';
                }
                 
                    
                    if(AddressMap.containsKey(curAddressID) || AddressMap.containsKey(curAddressID2)) {
                        if (AddressMap.containsKey(curAddressID)){
                            tempListAdd = AddressMap.get(curAddressID);
                        }
                        else if (AddressMap.containsKey(curAddressID2)){
                            tempListAdd = AddressMap.get(curAddressID2);
                        }
                                               
                            curAccount.ShippingCity = tempListAdd.City__c;
                            curAccount.ShippingCountry = tempListAdd.Country__c;
                            curAccount.ShippingState = tempListAdd.State__c;
                            curAccount.ShippingStreet = tempListAdd.Street__c;
                            curAccount.ShippingPostalCode = tempListAdd.Zip__c;
                            curAccount.Physical_County__c = tempListAdd.County__c;
                            system.debug('-------curAccount.MDM_Location_Keys__c---------'+curAccount.MDM_Location_Keys__c);
                            if(curAccount.MDM_Location_Keys__c==null || curAccount.MDM_Location_Keys__c=='')
                              curAccount.MDM_Location_Keys__c = tempListAdd.LM_MASTER_SKEY__c;  //Added by Shravani on 07/02/2014
                        

                        
                    }
                    else {
                            
                            curAccount.ShippingCity = '';
                            curAccount.ShippingCountry = '';
                            curAccount.ShippingState = '';
                            curAccount.ShippingStreet = '';
                            curAccount.ShippingPostalCode = '';
                            curAccount.Physical_County__c = '';
                          
                    }
                    
            }
        }
        update  myAccount;
        
    }
    

}