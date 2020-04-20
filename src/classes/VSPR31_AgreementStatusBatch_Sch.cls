global class VSPR31_AgreementStatusBatch_Sch implements Schedulable {
    /*private static String sched = '0 00 01 * * ?';  //Every Day: Midnight at 1

	global static String scheduleMe(){
		VSPR31_AgreementStatusBatch_Sch sch = new VSPR31_AgreementStatusBatch_Sch();
		return System.schedule('VSPR31_AgreementStatus_Batch', sched, sch);
	}*/

	global void execute(SchedulableContext sc) {
		//Below part commented as the Agreement Status batch job is no longer required.
		//VSPR31_AgreementStatus_Batch job = new VSPR31_AgreementStatus_Batch();

		//Below part added as the scheduler will be used to call the other batch job.
		VSPR31_AgreementsBusinessAcc_Batch job = new VSPR31_AgreementsBusinessAcc_Batch();
		ID batchJobID = database.executebatch(job);
	}
}