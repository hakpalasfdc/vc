/**
 * Class Name: VSPR1_AccountDML
 * @author: Jinky M.N. Salvador
 * Date: 27.MAY.2013
 * Requirement/Project Name: VSP
 * @description: Handles all DML for the Account object.
 */
    
    /**
    * Class Name: VSPR1_AccountDML 
    * @author: Marvin B. Gatchalian
    * Date: 18.JUNE.2013
    * Requirement/Project Name: VSP
    * @description: Addded method getAccountDetails to retrieve address information.
    */
 
 
 public class VSPR1_AccountDML { 
/*    
    public static void updateAccountDetails(Map<Id,Double> accountsNetProv, Boolean hasContact) {
    system.debug('>>> Enter updateAccountDetails'); 
    
    public static void updateAccountDetails(Map<Id,Double> accountsNetProv, Map<Id,Double> accountsHighProf) {
    
        Set <Id> accountIds = accountsNetProv.keySet();
        List<Account> accountDetails = [Select Vision_Care_VSP_Network_Provider__c,High_Profile__c, Has_Contact__c  from Account where id IN: accountIds];
        
        for (Account account : accountDetails){
            account.Has_Contact__c = hasContact;
            System.debug('>>>>hasContactAccount' + hasContact);
           if (accountsNetProv.get(account.id) > 0){
                account.Vision_Care_VSP_Network_Provider__c = true;
            }
            else{
                account.Vision_Care_VSP_Network_Provider__c = false;
            }
            
            if (accountsHighProf.get(account.id) > 0){
                account.High_Profile__c = true;
            }
            else{
                account.High_Profile__c = false;
            }
            
            System.debug('>>>>Account VSP Network Provider' + account.Vision_Care_VSP_Network_Provider__c);
            //System.debug('>>>>Account High Profile' + account.High_Profile__c);
        }
        update accountDetails;
    }
 */   
    public static List<Account> getAccountDetails(Set<Id> ids) {
        system.debug('>>> Enter getAccountDetails');
        List<Account> AccountAddresses = [select Id, ShippingCity,MDM_Location_Keys__c, ShippingCountry, ShippingState, Physical_County__c,
                                                 ShippingStreet, ShippingPostalCode, Has_Contact__c
                                                 from Account where id IN :ids];
        
        return AccountAddresses;    
        
    }
    
}