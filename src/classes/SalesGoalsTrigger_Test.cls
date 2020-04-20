/**
 * Class Name: SalesGoalsTrigger_Test
 * Associated Trigger Name: SalesGoalsTrigger
 * @author: Katherine Boothe
 * Date: July 12, 2017
 * @description: Test Class for Sales Goal object Trigger.
 */
@isTest
public class SalesGoalsTrigger_Test {
    public static testmethod void SalesGoalsTriggerTestMethod1(){
        test.startTest();
        Sales_Goals__c goals = new Sales_Goals__c();
        goals.Goal__c = 10000.00;
        goals.Goal_Type__c = 'Dollars';
        goals.Goal_Timeline__c = 'Quarterly';
        goals.Goal_Year__c = '2017';
        goals.Line_of_Business__c = 'Optics';
        goals.Territory_Code__c = 'VE01';
        insert goals;
        system.assertNotEquals(null,goals.Id);
        
        test.stopTest();
         
    }    

        public static testmethod void SalesGoalsTriggerTestMethod2(){
        test.startTest();
        Sales_Goals__c goals = new Sales_Goals__c();
        goals.Goal__c = 10000.00;
        goals.Goal_Type__c = 'Dollars';
        goals.Goal_Timeline__c = 'Quarterly';
        goals.Goal_Year__c = '2017';
        goals.Line_of_Business__c = 'Optics';
        goals.Territory_Code__c = null;
        insert goals;
        system.assertNotEquals(null,goals.Id);
        
        test.stopTest();
         
    }    

}