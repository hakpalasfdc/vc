//Batch scheduler class for running the Premier Daily jobs which use Effective Date and End Dates in calculation.
//Created by Vikhyat as part of SFDC-11988 on 11/07/2019

global class VSPR33_PremierDailyBatch2_Sch implements Schedulable {
    global void execute(SchedulableContext sc){
        VSPR33_vcCalculatorBatch job = new VSPR33_vcCalculatorBatch();
        Id jobId = Database.executeBatch(job, 50);
    }
}