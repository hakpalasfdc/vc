global class VSPR31_Premier_Prac_Upd_Grg_Create_Sched implements Schedulable {

    global void execute(SchedulableContext sc){
        
        String Query; 
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        Query = 'SELECT Id, Tax_ID__c, Premier_Tax_ID_Roll_Up_Account__c, Tier_Agreement_Type__c FROM Account WHERE IsDeleted = false AND Tax_ID__c != Null AND recordTypeId = \'' + accRecordTypeId + '\''; 
        system.debug('Query='+Query);
        
        VSPR31_Premier_Prac_Upd_Grg_Create_Batch batch = new VSPR31_Premier_Prac_Upd_Grg_Create_Batch(Query);
        database.executeBatch(batch,50);
        
    }
}