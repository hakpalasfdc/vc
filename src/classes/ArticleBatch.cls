global with sharing class ArticleBatch implements Database.Batchable<string>,Database.AllowsCallouts
{
    public Iterable<string> start(Database.BatchableContext bc)
    {
        return new ArticleBatchIterable();  
    }

    public void execute(Database.BatchableContext bc, List<string> scope)
    {
        //string recordTypeName = scope[0];    
        QNewsUpdateBatch batchClassObj = new QNewsUpdateBatch();
        for(String recordTypeName:scope){
            System.debug('----------------------------------ArticleBatch 14');
        	batchClassObj.insertQnewsData(recordTypeName);
        	System.debug('----------------------------------ArticleBatch 16');
        }
    }

	global void finish(Database.BatchableContext bc){

    	Id batchInstanceId = database.executeBatch(new ArchiveArticleToSharepoint(),10);
     
        AsyncApexJob a = [SELECT id,Status, ApexClassId, JobItemsProcessed, TotalJobItems, NumberOfErrors, CreatedBy.Email FROM AsyncApexJob WHERE id = :bc.getJobId()];   
        String emailMessage = 'Number of records processed ' + a.TotalJobItems +' with '+ a.NumberOfErrors + ' failures.\n';    
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'questadministrator@vsp.com'};
        mail.setToAddresses(toAddresses); 
        //mail.setSenderDisplayName('Batch Job Summary');
        mail.setSubject('Batch job completed');
        mail.setPlainTextBody(emailMessage);
        //mail.setHtmlBody(emailMessage);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });

    }
}