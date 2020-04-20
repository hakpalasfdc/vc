/* Created Date : 21th June 2016
   Related Case : #9251
   Related Object : Account
   Related Class : VSPR2_UpdateAccountBatch, VSPR2_UpdateAccountBatchSchedule.
*/
@isTest
public class VSPR2_UpdateAccountBatchScheduleTest{
    
    static testMethod void VSPR2_UpdateAccountBatchTest(){
        Id RecordTypeId = [Select id from recordType where sObjectType = 'Account' AND Name ='Pending Account'].id;
        System.debug('### RecordTypeId = '+RecordTypeId);
        List<Account> accList = new List<Account>();
        for(Integer i = 0; i<=10; i++){
             Account acc = new Account();
             acc.Name = 'Test Account';
             acc.Industry = 'Education';
             acc.Rating = 'Hot';
             acc.RecordTypeID = RecordTypeId;
             accList.add(acc);
        }
        
        Test.startTest();
            insert accList;
            System.debug('#### accList = > '+accList);
            VSPR2_UpdateAccountBatch testBatch = new VSPR2_UpdateAccountBatch();
            Database.executeBatch(testBatch);
        Test.StopTest();
        
    }
}