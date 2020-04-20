global class VSPR33_Con_Role_VSP_Net_Provider_Sch implements Schedulable{

    global void execute(SchedulableContext sc) {
		VSPR33_Con_Role_VSP_Net_Provider_Batch batch = new VSPR33_Con_Role_VSP_Net_Provider_Batch();
        database.executeBatch(batch,100);
	}
}