global class VSPR28_QA_Review_Purge_Schedule implements Schedulable {
    
    global void execute(SchedulableContext sc){
        
        String Query;
        Date tDate = Date.today().addMonths(-126);   ///Date 10 years and 6 months ago
        String sDate = String.valueOf(tDate);
        sDate = sDate.removeEnd(' 00:00:00');        /// remove the time from the date
        Query = 'Select Id FROM QA_Review__c WHERE Review_Date_Scheduled__c < ' + sDate + ' OR (QA_Review_Status__c IN (\'Completed Audit Pass\',\'Completed Audit Failed\') AND Result_Letter_Date__c < ' + sDate + ')';
        //Query = 'Select Id FROM QA_Review__c';
        system.debug('Query= '+Query);
        system.debug('testDate= '+tDate);
        system.debug('testDate= '+sDate);
        
        
        VSPR28_QA_Review_Purge_Batchable batch = new VSPR28_QA_Review_Purge_Batchable(Query);
        database.executeBatch(batch,100);
    }
}