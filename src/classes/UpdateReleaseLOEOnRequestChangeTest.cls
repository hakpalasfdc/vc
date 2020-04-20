@isTest
private class UpdateReleaseLOEOnRequestChangeTest{

    static testMethod void test_UseCase1(){
        test.startTest();
        
        Release__c release_Obj = new Release__c(Name = 'Name438');
        Insert release_Obj; 
        
        Request__c request_Obj = new Request__c(Nudge__c = false);
        request_Obj.Request_Title__c='UseCase11-1';

        request_Obj.Release__c = release_Obj.id;
        Insert request_Obj; 
        Delete request_Obj;
        test.stopTest();
    }
}