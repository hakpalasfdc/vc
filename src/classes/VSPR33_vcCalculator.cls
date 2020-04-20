public class VSPR33_vcCalculator {
    private static final Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static final Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    //private static String practiceException;
    private static final Date todayDate = System.today();

    public void vcCalculationBeforeInsert(List<Account> newTrigger){
        for(Account a: newTrigger){
            if((a.recordTypeId == businessRecordTypeID || a.recordTypeId == practiceRecordTypeID) && a.Vision_Care_Effective_Date__c != null){

                if(a.Vision_Care_Effective_Date__c <= todayDate && (a.Vision_Care_End_Date__c == null || a.Vision_Care_End_Date__c >= todayDate)){
                    a.VC__c = true;
                }
            }
        }
    }

    public void vcCalculationBeforeUpdate(List<Account> newTrigger, Map<Id, Account> oldMap){

        for(Account a: newTrigger){
            if(((a.recordTypeId == businessRecordTypeID && oldMap.get(a.Id).recordTypeId == businessRecordTypeID) || (a.recordTypeId == practiceRecordTypeID && oldMap.get(a.Id).recordTypeId == practiceRecordTypeID)) && 
            ((a.Vision_Care_Effective_Date__c != oldMap.get(a.Id).Vision_Care_Effective_Date__c && a.Vision_Care_Effective_Date__c != null) || a.Vision_Care_End_Date__c != oldMap.get(a.Id).Vision_Care_End_Date__c)){

                if(a.Vision_Care_Effective_Date__c <= todayDate && (a.Vision_Care_End_Date__c == null || a.Vision_Care_End_Date__c >= todayDate)){
                    if(!a.VC__c){
                        a.VC__c = true;
                    }
                }else{
                    if (a.VC__c) {
                        a.VC__c = false;
                    }
                }
            }
        }
    }
}