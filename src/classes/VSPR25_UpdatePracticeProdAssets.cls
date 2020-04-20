public class VSPR25_UpdatePracticeProdAssets {
    public static void setPracticeAccountProdAssets(List<Account> listAccount,Map<Id,Account> mpOldAcc) {
       // RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' LIMIT 1];
        Schema.DescribeSObjectResult d = Schema.SObjectType.Account; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        Schema.RecordTypeInfo rtByName =  rtMapByName.get('Business Account');
        String busiAccountRTId =  rtByName.getRecordTypeId();
        map<String,Account> mpPracAccounts = new map<String,Account>();
        for(Account acc : listAccount) {     
            system.debug('-----' + acc.Level__c);
            system.debug('-----' + acc.RecordTypeId);
            system.debug('-----' + acc.ParentId);
            if(acc.RecordTypeId != busiAccountRTId) {
                continue;
            }
            if(acc.ParentId == NULL) {
                continue;
            }
            if(Trigger.isInsert && acc.Products_and_Assets__c != null) {
                mpPracAccounts.put(acc.ParentId,NULL);
            }
            if(Trigger.isUpdate && mpOldAcc.get(acc.Id).Products_and_Assets__c != acc.Products_and_Assets__c) {
                mpPracAccounts.put(acc.ParentId,NULL);
            }
            system.debug('-----' + acc.Level__c);
            if(Trigger.isDelete && acc.Products_and_Assets__c != null) {
                mpPracAccounts.put(acc.ParentId,NULL);
            }
        }    
        if(mpPracAccounts.isEmpty()) {
            return;
        }
        mpPracAccounts = new map<String,Account>([Select Id,Products_and_Assets__c,(Select id from ChildAccounts where  RecordType.Name = 'Business Account' LIMIT 1) 
                                                  FROM Account Where Id IN :mpPracAccounts.keySet()]);
        
        List<Account> busChildAcc = [Select Id,Products_and_Assets__c from Account where ParentId IN :mpPracAccounts.keySet()];
        
        
        
        Set<String> pracProdAssets = new Set<String>();
        String pracAccValues = ''; 
        
        List<String> pracAccProdValues = new List<String>(); 
        for(Account busAcc: busChildAcc ){
            if(busAcc.Products_and_Assets__c != null){
                
                List<String> lstString = busAcc.Products_and_Assets__c.split(';');
                for(String t: lstString){
                    pracProdAssets.add(t);
                }
                
            }
            
        }
        
        for(String s:pracProdAssets){
            System.debug('TESTING++++++ s' + s);
            if(pracAccValues == ''){
                pracAccValues = s;
            }
            else{
                pracAccValues = pracAccValues + ';' + s;
            }
            
        }
        
        
        System.debug('TESTING++++++ pracAccValues' + pracAccValues);
        System.debug('TESTING++++++ pracProdAssets ' + pracProdAssets);
        
        for(Account pracAcc : mpPracAccounts.values()) {
            
            if(!pracAcc.childAccounts.isEmpty()) {
                
                pracAcc.Products_and_Assets__c = pracAccValues;
            }
        }
        if(!mpPracAccounts.isEmpty()) {
            update mpPracAccounts.values();
        }                                        
    }
}