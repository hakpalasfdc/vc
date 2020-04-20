/**
 * Class Name: VSPR1_AddressDML
 * @author: Marvin B. Gatchalian
 * Date: 18.JUNE.2013
 * Requirement/Project Name: VSP
 * @description: Handles all DML for the Address Custom object.
 */

public class VSPR1_AddressDML { 

    //public static List<Address__c> getAddressDetails(Set<Id> ids){
     //system.debug('>>> Enter getAddressDetails');
      //List<Address__c> Addresses = [Select id from Address__c where id IN: ids];
      //return Addresses;        
   // }
    
    public static List<Address__c> getAddressPhysicalOnly(Set<Id> ids){
        system.debug('>>> Enter getAddressPhysicalOnly');
        List<Address__c> Addresses = [Select a.Zip__c, a.SystemModstamp, 
                                             a.Street__c, a.State__c, a.OwnerId,
                                             a.Name, a.LastModifiedDate, a.LastModifiedById, 
                                             a.LM_MASTER_SKEY__c, a.IsDeleted, a.Id, 
                                             a.CreatedDate, a.CreatedById, a.Country__c, 
                                             a.City__c, a.County__c
                                             From Address__c a where id IN: ids order by a.CreatedDate desc];
       
       // Below query is a backup before address type field is move to address relationship object 
       // List<Address__c> Addresses = [Select a.Zip__c, a.SystemModstamp, 
       //                                      a.Street__c, a.State__c, a.OwnerId,
       //                                      a.Name, a.LastModifiedDate, a.LastModifiedById, 
       //                                      a.LM_MASTER_SKEY__c, a.IsDeleted, a.Id, 
       //                                      a.CreatedDate, a.CreatedById, a.Country__c, 
       //                                      a.City__c, a.Address_Type__c 
       //                                      From Address__c a where Address_Type__c = 'Physical' 
       //                                      and id IN: ids order by a.CreatedDate desc];
        return Addresses;       
    }
}