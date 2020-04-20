@isTest
private class VSPR1_AccountDML_Test{
  @testSetup
  static void setupTestData(){
    test.startTest();
    Account account_Obj = new Account(Name = 'Name226', ShippingStreet = 'PratapNagar', ShippingCity = 'Jaipur', ShippingState = 'Raj', 
                                      ShippingPostalCode = '302022', ShippingCountry = 'India', Has_Contact__c = true, High_Profile__c = true, MDM_Location_Keys__c = 'MDM_L140',
                                      Vision_Care_VSP_Network_Provider__c = false);
    Insert account_Obj; 
    test.stopTest();
  }

  static testMethod void test_getAccountDetails_UseCase1(){
    List<Account> account_Obj  =  [SELECT Id, ShippingCity,MDM_Location_Keys__c, ShippingCountry, ShippingState, Physical_County__c,
                                                 ShippingStreet, ShippingPostalCode, Has_Contact__c FROM Account];
    System.assertEquals(true,account_Obj.size()>0);
    VSPR1_AccountDML obj01 = new VSPR1_AccountDML();
    VSPR1_AccountDML.getAccountDetails(new Set<Id>());
  }
}