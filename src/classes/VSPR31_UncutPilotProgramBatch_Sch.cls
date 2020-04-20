global class VSPR31_UncutPilotProgramBatch_Sch implements Schedulable {

	/*private static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

	global static String scheduleMe(){
		VSPR31_UncutPilotProgramBatch_Sch sch = new VSPR31_UncutPilotProgramBatch_Sch();
		return System.schedule('VSPR31_UncutPilotProgramBatch', sched, sch);
	}*/

	global void execute(SchedulableContext sc) {
		VSPR31_UncutPilotProgramBatch job = new VSPR31_UncutPilotProgramBatch();
		ID batchJobID = database.executebatch(job, 1000);
	}
}