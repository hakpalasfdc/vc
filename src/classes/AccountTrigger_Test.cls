//Dated:08-11-2016
//Description:Test class to cover the trigger AccountTrigger and AccountTrigger_Handler class
@isTest
public class AccountTrigger_Test {
    public static testmethod void AccountTriggerTestMethod() {
        
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='1234567893';
        insert acc;
        system.assertNotEquals(null, acc.id);
 //       AccountTrigger_Handler.handleBeforeInsert(new List<Account>{acc});
        test.stoptest();
        
    }
    
    public static testmethod void ContactTriggerTestMethod1() {
        
         try{
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='123';
        insert acc;
        
  //      AccountTrigger_Handler.handleBeforeInsert(new List<Account>{acc});
            
        
            
      
        test.stoptest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
        
    }
    public static testmethod void ContactTriggerTestMethod2() {
        try{
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='5555555555';
        insert acc;
   //       AccountTrigger_Handler.handleBeforeInsert(new List<Account>{acc});  
        
            
      
        test.stoptest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
    }
    public static testmethod void ContactTriggerTestMethod3() {
         try{
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='1555555555';
        insert acc;
            
        
          CreateDateTime.CreateDateFromPicklist('08:12PM');
          CreateDateTime.CreateDateFromPicklist('08:12');   
      
        test.stoptest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
        
    }
    public static testmethod void ContactTriggerTestMethod4() {
        try{
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='abs';
        insert acc;
            
   //     AccountTrigger_Handler.handleBeforeInsert(new List<Account>{acc});
            
      
        test.stoptest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
        
    }

    public static testmethod void testLevelAccount() {
        
        test.starttest();
        Account acc= new Account();
        acc.Name='name';
        acc.NPI_Type_2__c='1234567893';
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Practice Account');
        acc.RecordTypeId =  rtByName.getRecordTypeId();        
        insert acc;
        
        
        Schema.RecordTypeInfo rtByName1 =  rtMapByName.get('Business Account');                
        Account acc1= new Account();
        acc1.Name='name';
        acc1.NPI_Type_2__c='1234567893';       
        acc1.Level__c = true; 
        acc1.ParentId = acc.id;       
        acc1.RecordTypeId =  rtByName1.getRecordTypeId();      
        insert acc1;             
        test.stoptest();
        
    }

}