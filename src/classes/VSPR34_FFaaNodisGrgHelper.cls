public class VSPR34_FFaaNodisGrgHelper {

    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();

    @InvocableMethod(label='Update GRG Exclusive VSP and Free Fitting Indicator' description='Updating the Practice Exclusive VSP Patient Offers and Free Fitting and Adjustments Indicator based on the Business Account corresponding values')
    public static void grgFFaaNodisUpdate(List<Id> busAccId){
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

        List<Account> busAccList = [Select id, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c from Account where recordTypeId = :businessRecordTypeID and id in :grgrBusAccIdMap.values() and VC__c = true and (Free_Fitting_and_Adjustments__c = true or Exclusive_VSP_Patient_Offers__c = false)];

        Set<Id> busAccFFaaSet = new Set<Id>();
        Set<Id> busAccNodisSet = new Set<Id>(); 

        for(Account a: busAccList){
            if(!a.Exclusive_VSP_Patient_Offers__c){
                busAccNodisSet.add(a.Id);
            }
            if(a.Free_Fitting_and_Adjustments__c){
                busAccFFaaSet.add(a.Id);
            }
        }

        List<Global_Rewards_Group__c> grgListToUpdate = new List<Global_Rewards_Group__c>();

        for (Id i: grgIdSet) {
            Global_Rewards_Group__c grg = new Global_Rewards_Group__c();
            grg.Id = i;
            /*Boolean check = false;
            Boolean bool = false;*/
            Boolean ffaa = false;
            Boolean nodis = false;
            for(Id grgrI: grgGrgrIdMap.get(i)){
                if(grgrBusAccIdMap.containsKey(grgrI)){
                    if(ffaa && nodis){
                        break;
                    }else{
                        if(busAccNodisSet.contains(grgrBusAccIdMap.get(grgrI))){
                            if(!nodis){
                                nodis = true;
                                //bool = true;
                            }
                        }
                        if(busAccFFaaSet.contains(grgrBusAccIdMap.get(grgrI))){
                            if(!ffaa){
                                ffaa = true;
                                //bool = true;
                            }
                        }
                    }
                }
            }
            
            if(nodis){
                grg.Exclusive_VSP_Patient_Offers__c = false;
            }else{
                grg.Exclusive_VSP_Patient_Offers__c = true;
            }

            if(!ffaa){
                grg.Free_Fitting_and_Adjustments__c = false;
            }else{
                grg.Free_Fitting_and_Adjustments__c = true;
            }
            
            grgListToUpdate.add(grg);

        }

        if(grgListToUpdate.size()>0){
            update grgListToUpdate;
        }
    }

    /*public static void test(List<Id> busAccId){
        List<Global_Rewards_Group_Relationship__c> grgrList = [Select id, Child_Account__c, Global_Rewards_Group__c from Global_Rewards_Group_Relationship__c where Child_Account__c in :busAccId and Status__c = 'Active'];
        Set<Id> grgIdSet = new Set<Id>();
        List<Global_Rewards_Group__c> grgToUpdateList = new List<Global_Rewards_Group__c>();
        Map<Id, Global_Rewards_Group__c> grgMap = new Map<Id, Global_Rewards_Group__c>();

        for(Global_Rewards_Group_Relationship__c grgr: grgrList){
            grgMap.put(grgr.Global_Rewards_Group__c, new Global_Rewards_Group__c(Id = grgr.Global_Rewards_Group__c, Exclusive_VSP_Patient_Offers__c = true, Free_Fitting_and_Adjustments__c = false));
            //grgIdSet.add(grgr.Global_Rewards_Group__c);
        }

        AggregateResult[] busAccNODISCount =   [SELECT Global_Rewards_Group__c, Count(Id) Total 
                                                    FROM Global_Rewards_Group_Relationship__c 
                                                    WHERE Global_Rewards_Group__c IN :grgMap.keySet() AND 
                                                    Status__c = 'Active' AND
                                                    Child_Account__r.VC__c = True AND
                                                    //Child_Account__r.Status__c = 'A' AND
                                                    //Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                    //(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                    Child_Account__r.recordTypeId = :businessRecordTypeID AND 
                                                    //Child_Account__r.Contract_Type__c != NULL AND 
                                                    Child_Account__r.Exclusive_VSP_Patient_Offers__c = false  
                                                    GROUP BY Global_Rewards_Group__c];

        AggregateResult[] busAccFreeFittingCount =  [SELECT Global_Rewards_Group__c, Count(Id) Total 
                                                         FROM Global_Rewards_Group_Relationship__c 
                                                         WHERE Global_Rewards_Group__c IN :grgMap.keySet() AND Status__c = 'Active' AND
                                                         Child_Account__r.VC__c = True AND
                                                         //Child_Account__r.Status__c = 'A' AND
                                                         // Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                         // (Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                         Child_Account__r.RecordTypeId = :businessRecordTypeID AND 
                                                         Child_Account__r.Free_Fitting_and_Adjustments__c = true
                                                         Group By Global_Rewards_Group__c];

        for(Global_Rewards_Group__c grg: grgMap.values()){
            for(AggregateResult ag: busAccNODISCount){
                if((Id)ag.get('Global_Rewards_Group__c') == grg.Id){
                    grg.Exclusive_VSP_Patient_Offers__c = false;
                }
            }
            for(AggregateResult ag: busAccFreeFittingCount){
                if((Id)ag.get('Global_Rewards_Group__c') == grg.Id){
                    grg.Free_Fitting_and_Adjustments__c = true;
                }
            }
            grgToUpdateList.add(grg);
        }

        if(grgToUpdateList.size()>0){
            update grgToUpdateList;
        }
    }*/
}