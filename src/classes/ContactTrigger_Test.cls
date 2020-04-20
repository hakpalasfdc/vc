//Dated:08-11-2016
//Description:Test class to cover the trigger ContactTrigger and ContactTrigger_Handler class
@isTest
public class ContactTrigger_Test {
    public static testmethod void ContactTriggerTestMethod() {
        test.starttest();
        Contact con= new Contact();
        con.LastName='name';
        con.FirstName='test';
        con.NPI__c='1234567893';
        insert con;
        system.assertNotEquals(null, con.id);
        test.stoptest();
                
    }
    
    public static testmethod void ContactTriggerTestMethod1() {
        try{
        test.starttest();
        Contact con2= new Contact();
        con2.LastName='name';
        con2.NPI__c='123';
        insert con2;
        test.stopTest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }        
    }
    
     public static testmethod void ContactTriggerTestMethod2() {
        try{
        test.starttest();
        Contact con3= new Contact();
        con3.LastName='name';
        con3.NPI__c='5555555555';
        insert con3;
        test.stopTest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }        
    }
    
    public static testmethod void ContactTriggerTestMethod3() {
        try{
        test.starttest();
        Contact con4= new Contact();
        con4.LastName='name';
        con4.NPI__c='1555555555';
        insert con4;
        test.stopTest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }        
    }
    
    public static testmethod void ContactTriggerTestMethod4() {
        try{
        test.starttest();
        Contact con1= new Contact();
        con1.LastName='name';
        con1.FirstName='test';
        con1.NPI__c='abc';
        insert con1;
        test.stopTest();
        }
        catch(exception e){
            system.debug(e.getMessage());
        }
    }
}