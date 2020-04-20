global class batch_updateContactRoleIndicator_sch implements Schedulable{

    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        batch_updateContactRoleIndicator_sch SC = new batch_updateContactRoleIndicator_sch(); 
        return System.schedule('batch_updateContactRoleIndicator', sched, SC);
    }
    
    global void execute(SchedulableContext sc) {
    
        batch_updateContactRoleIndicator bON = new batch_updateContactRoleIndicator();
        ID batchprocessid = Database.executeBatch(bON,1000);           
    }
    
}