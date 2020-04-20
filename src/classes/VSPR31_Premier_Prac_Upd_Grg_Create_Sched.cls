global class VSPR31_Premier_Prac_Upd_Grg_Create_Sched implements Schedulable {

    global void execute(SchedulableContext sc){
        
    //    String Query; 
    //    Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
   //     Query = 'SELECT Id, Tax_ID__c, Premier_Tax_ID_Roll_Up_Account__c, Tier_Agreement_Type__c FROM Account WHERE IsDeleted = false AND Tax_ID__c != Null AND recordTypeId = \'' + accRecordTypeId + '\''; 
    //    system.debug('Query='+Query);
        List<User> batchUserLst = new List<User>();
        for(User batchRunningUser : [SELECT Id, Bypass_Account_Process__c FROM User WHERE Id = :UserInfo.getUserId()]){
            if(batchRunningUser.Bypass_Account_Process__c == False){
                batchRunningUser.Bypass_Account_Process__c = True;
                batchUserLst.add(batchRunningUser);
            }
        }
        if(!batchUserLst.isEmpty()){
            update batchUserLst;
        }        
        
        VSPR34_GRG_Tax_Id_Child_Group_Batch batch = new VSPR34_GRG_Tax_Id_Child_Group_Batch();
        database.executeBatch(batch,100);
        
    }
}