//still to cover for VC__c == true and when VC__c == false

public class VSPR33_RetinalImageHelper {
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    private static final Date todayDate = System.today();
    private static final String retinal = 'RTLIM';

    public void beforeInsert(List<Account> triggerNew){

        for(Account a: triggerNew){
            if(a.recordTypeId == businessRecordTypeID && a.VC__c /*&& a.ParentId != null*/ && a.Service_Offering_s__c != null){
                businessAccountRetinalCalculator(a);
            }
        }

    }

    public void beforeUpdate(List<Account> triggerNew, Map<Id, Account> oldMap){

        for (Account a: triggerNew) {
            if(a.recordTypeId == businessRecordTypeID && oldMap.get(a.Id).recordTypeId == businessRecordTypeID && (a.Service_Offering_s__c != oldMap.get(a.Id).Service_Offering_s__c || a.VC__c != oldMap.get(a.Id).VC__c)){
                if(a.VC__c && a.Service_Offering_s__c != null){
                    businessAccountRetinalCalculator(a);
                }else{
                    a.Retinal_Imaging_Indicator__c = false;
                }
            }
        }
    }

    private void businessAccountRetinalCalculator(Account a){
        if(a.Service_Offering_s__c.contains(retinal)){
            if (!a.Retinal_Imaging_Indicator__c) {
                a.Retinal_Imaging_Indicator__c = true;
            }
        }else{
            if(a.Retinal_Imaging_Indicator__c){
                a.Retinal_Imaging_Indicator__c = false;
            }
        }
    }

    @InvocableMethod(label='Update Practice Retinal Image Indicator' description='Updating the Practice Retinal Image Indicator based on the Business Account Retinal Indicator value')
    public static void practiceAccountRetinalCalculator(List<Account> busAccList){
        Set<Id> pracAccIdSet = new Set<Id>();
        Set<Id> busAccIdSet = new Set<Id>();

        for(Account a: busAccList){
            if(a.recordTypeId == businessRecordTypeID /*&& a.VC__c*/){
                pracAccIdSet.add(a.ParentId);
                busAccIdSet.add(a.Id);
            }
        }

        processPracticeAccUpdate(pracAccIdSet);      
    }

    private static void processPracticeAccUpdate(Set<Id> pracIdSet){
        List<Account> practiceAccList = [Select Id, VC__c, Retinal_Imaging_Indicator__c from Account where recordTypeId = :practiceRecordTypeID and id in :pracIdSet /*and VC__c = true*/];
        List<Account> businessAccList = [Select Id, ParentId, Retinal_Imaging_Indicator__c from Account where recordTypeId =:businessRecordTypeID and ParentId in :pracIdSet and VC__c = true and Retinal_Imaging_Indicator__c = true];

        //Map<Id, List<Account>> pracBusAccMap = new Map<Id, List<Account>>();
        Set<Id> practiceIdSet = new Set<Id>();
        List<Account> practiceAccToUpd = new List<Account>();

        for(Account a: businessAccList){
            //if(a.Retinal_Imaging_Indicator__c){
                practiceIdSet.add(a.ParentId);
            //}
        }

        for(Account a: practiceAccList){
            if(!a.VC__c){
                a.Retinal_Imaging_Indicator__c = false;
                practiceAccToUpd.add(a);
            }else {
               if(practiceIdSet.contains(a.Id)){
                   if(!a.Retinal_Imaging_Indicator__c){
                       a.Retinal_Imaging_Indicator__c = true;
                       practiceAccToUpd.add(a);
                    }
                }else{
                    if(a.Retinal_Imaging_Indicator__c){
                        a.Retinal_Imaging_Indicator__c = false;
                        practiceAccToUpd.add(a);
                    }
                } 
            }

            /*if(practiceIdSet.contains(a.Id)){
                if(!a.Retinal_Imaging_Indicator__c){
                    a.Retinal_Imaging_Indicator__c = true;
                    practiceAccToUpd.add(a);
                }
            }else{
                if(a.Retinal_Imaging_Indicator__c){
                    a.Retinal_Imaging_Indicator__c = false;
                    practiceAccToUpd.add(a);
                }
            }*/
        }
        update practiceAccToUpd;
    }

}