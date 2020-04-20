global class VSP_All_Con_Role_VSP_Net_Pro_Sch implements Schedulable{    
    global void execute(SchedulableContext sc) {
        VSP_All_Con_Role_VSP_Net_Pro_Batch batch = new VSP_All_Con_Role_VSP_Net_Pro_Batch();
        database.executeBatch(batch,500);
    }    
}