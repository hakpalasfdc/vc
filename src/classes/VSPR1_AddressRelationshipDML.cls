/**
 * Class Name: VSPR1_AddressRelationshipDML
 * @author: Marvin B. Gatchalian
 * Date: 18.JUNE.2013
 * Requirement/Project Name: VSP
 * @description: Handles all DML for the Address Relationship Custom object.
 */

public class VSPR1_AddressRelationshipDML { 
    
    public static List<Address_Relationship__c> getAddressRelationDetails(Set<Id> addressIds){
       system.debug('>>> Enter getAddressRelationDetails');
        List<Address_Relationship__c> AddressesR = [Select Account__c, address__c, createdDate, status__c from 
                                                    Address_Relationship__c where address__c IN: addressIds order by address__c desc];
        return AddressesR;      
    }
    
    public static List<Address_Relationship__c> getAddressRelationbyAccount(Set<Id> accountIds){
        system.debug('>>> Enter getAddressRelationbyAccount');
       List<Address_Relationship__c> AddressesR = [Select Account__c, address__c, Address_Type__c, LastModifiedDate, status__c from 
                                                  Address_Relationship__c where Status__c = 'Active' and Address_Type__c = 'Physical'
                                                   and Account__c IN: accountIds order by LastModifiedDate desc];
               
        return AddressesR;      
    } 
   

    
}