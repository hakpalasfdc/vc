global class VSPR33b_Bus_Acc_Curr_Cust_Flg_Sch implements Schedulable{

    global void execute(SchedulableContext sc) {
		VSPR33b_Bus_Acc_Curr_Cust_Flg_Batch batch = new VSPR33b_Bus_Acc_Curr_Cust_Flg_Batch();
        database.executeBatch(batch,100);
	}
}