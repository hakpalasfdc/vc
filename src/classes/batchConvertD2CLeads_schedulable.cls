global class batchConvertD2CLeads_schedulable implements Schedulable{

    public static String sched = '0 00 00 * * ?';  //Every Day at Midnight 

    global static String scheduleMe() {
        batchConvertD2CLeads_schedulable SC = new batchConvertD2CLeads_schedulable(); 
        return System.schedule('batchConvertD2CLeads', sched, SC);
    }
    
    global void execute(SchedulableContext sc) {
    
        batchConvertD2CLeads bON = new batchConvertD2CLeads();
        ID batchprocessid = Database.executeBatch(bON,500);           
    }
    
}