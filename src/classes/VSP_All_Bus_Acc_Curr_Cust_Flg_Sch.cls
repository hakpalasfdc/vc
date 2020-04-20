global class VSP_All_Bus_Acc_Curr_Cust_Flg_Sch implements Schedulable{

    global void execute(SchedulableContext sc) {
		VSP_All_Bus_Acc_Curr_Cust_Flg_Batch batch = new VSP_All_Bus_Acc_Curr_Cust_Flg_Batch();
        database.executeBatch(batch,100);
	}
}