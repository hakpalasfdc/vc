public class CaseAgeCalculationBatchSchedule implements Schedulable {
    // Cron Trigger Run after every 30 minutes
    public static String sched = '0 30 * * * ?';  
    
    // CaseAgeCalculationBatchSchedule Method for Scheduling batch job
    public void CaseAgeCalculationBatchSchedule() {
        CaseAgeCalculationBatchSchedule SC = new CaseAgeCalculationBatchSchedule(); 
        String schduleId =  System.schedule('CaseAgeCalculationBatch Scheduler', sched, SC);
    }
    
    // Execute method of Schdulable interface for Executing batch job
    public void execute(SchedulableContext sc)
    {
        String q = 'Select id, CaseNumber, ClosedDate, CreatedDate, Case_Age_2__c, ';
               q += ' Priority, Email_Last_Sent__c, Email_Last_Received__c, Origin, recordType.Name  ';
               q += ' from Case where recordType.Name=\'Customer Care\'';
        CaseAgeCalculationBatch b = new CaseAgeCalculationBatch(q);
        ID batchprocessID = Database.executebatch(b, 80);
        System.debug('Processed Job ID ---'+'   '+batchprocessID);
    }
}