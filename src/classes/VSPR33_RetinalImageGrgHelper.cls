public class VSPR33_RetinalImageGrgHelper {
    
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

    @InvocableMethod(label='Update GRG Retinal Image Indicator' description='Updating the GRG Retinal Image Indicator based on the Business Account Retinal Indicator value')
    public static void updateGrgIndicator(List<Id> busAccId) {

        List<Global_Rewards_Group_Relationship__c> grgrList = [Select id, Child_Account__c, Global_Rewards_Group__c from Global_Rewards_Group_Relationship__c where Child_Account__c in :busAccId and Status__c = 'Active'];
        Set<Id> grgIdSet = new Set<Id>();

        for(Global_Rewards_Group_Relationship__c grgr: grgrList){
            grgIdSet.add(grgr.Global_Rewards_Group__c);
        }
        
        List<Global_Rewards_Group_Relationship__c> allGrgrList = [Select id, Child_Account__c, Global_Rewards_Group__c from Global_Rewards_Group_Relationship__c where Global_Rewards_Group__c in :grgIdSet and Child_Account__r.recordTypeId = :businessRecordTypeID and Status__c = 'Active'];
        Map<Id, Set<Id>> grgGrgrIdMap = new Map<Id, Set<Id>>();
        Map<Id, Id> grgrBusAccIdMap = new Map<Id, Id>();

        for(Global_Rewards_Group_Relationship__c grgr: allGrgrList){
            if(!grgGrgrIdMap.containsKey(grgr.Global_Rewards_Group__c)){
                grgGrgrIdMap.put(grgr.Global_Rewards_Group__c, new Set<iD>{grgr.Id});
            }else{
                Set<Id> s = new Set<Id>(grgGrgrIdMap.get(grgr.Global_Rewards_Group__c));
                s.add(grgr.Id);
                grgGrgrIdMap.put(grgr.Global_Rewards_Group__c, s);
            }
            grgrBusAccIdMap.put(grgr.Id, grgr.Child_Account__c);
        }

        List<Account> busAccList = [Select id, Retinal_Imaging_Indicator__c from Account where recordTypeId = :businessRecordTypeID and id in :grgrBusAccIdMap.values()];

        Map<Id, Boolean> busAccRetinalMap = new Map<Id, Boolean>();

        for(Account a: busAccList){
            busAccRetinalMap.put(a.Id, a.Retinal_Imaging_Indicator__c);
        }

        List<Global_Rewards_Group__c> grgListToUpdate = new List<Global_Rewards_Group__c>();
        Map<Id, Boolean> grgRetinalMap = new Map<Id, Boolean>();

        for (Id i: grgIdSet) {
            Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
            grg.Id = i;
            Boolean check = false;
            for(Id grgrI: grgGrgrIdMap.get(i)){
                if(grgrBusAccIdMap.containsKey(grgrI)){
                    if(busAccRetinalMap.containsKey(grgrBusAccIdMap.get(grgrI))){
                        if(busAccRetinalMap.get(grgrBusAccIdMap.get(grgrI)) && /*count == 0*/ !check){ //test the break statement with multiple grgr and account combinations.
                            check = true;
                            break;
                        }
                    }
                }
            }
            if(check){
                grg.Retinal_Imaging_Indicator_Future__c = true;
                grgListToUpdate.add(grg);
            }else{
                //Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
                //grg.Id = i;
                grg.Retinal_Imaging_Indicator_Future__c = false;
                grgListToUpdate.add(grg);
            }
        }

        if(grgListToUpdate.size()>0){
            update grgListToUpdate;
        }
    }
}