global class VSPR28_QA_Review_Status_Update_Schedule implements Schedulable {

    global void execute(SchedulableContext sc){
        
        String Query;
        Date tDate = Date.today().addDays(-45);   ///Date 45 days ago
        String sDate = String.valueOf(tDate);
        sDate = sDate.removeEnd(' 00:00:00');        /// remove the time from the date
        Query = 'Select Id FROM QA_Review__c WHERE DocuSign_Completion_Date__c = null AND Original_DocuSign_Sent_Date__c < ' + sDate + ')';
        //Query = 'Select Id FROM QA_Review__c';
        system.debug('Query= '+Query);
        system.debug('testDate= '+tDate);
        system.debug('testDate= '+sDate);
        
        
       // VSPR28_QA_Review_Purge_Batchable batch = new VSPR28_QA_Review_Purge_Batchable(Query);
       // database.executeBatch(batch,100);
    }
}