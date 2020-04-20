@isTest

private class  Batch_DeleteOldAttachments_Test{

Static testMethod void myUnitTest_Batch_DeleteOldAttachments(){
        
        Account a = new Account();
        a.Name = 'Test Account';
        insert a;
        
        Attachment attach=new Attachment();    
        attach.Name='Unit Test Attachment';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=a.id;
        attach.createddate = (datetime.newinstance(system.now().year(),system.now().month(),system.now().day())).addMonths(-27);
        insert attach;
            
    
    Batch_DeleteOldAttachments batchToExecute=new Batch_DeleteOldAttachments();
    test.startTest();
    ID batchprocessid=Database.executeBatch(batchToExecute);
    test.stopTest();
    System.abortJob(batchprocessid);
        


    
}

}