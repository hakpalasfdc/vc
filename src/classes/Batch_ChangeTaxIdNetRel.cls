global class Batch_ChangeTaxIdNetRel implements Database.Batchable<sObject>{

global List<Account> lstBusinessAccounts;
global Date accTEMP_Vision_Care_End_Date;
global Date acc_Vision_Care_End_Date;
global Date acc_Vision_Care_Effective_Date;
global Map<String,String> lbaMap;
 
string soql = 'SELECT Id,Program_ID__c,Program_End_Date__c,Directory_End_Date__c,Account_Name__c,Contact_Role__c, Provider_Name__c, Vision_Care_Location_Key__c, Fee_Code__c,LVC_Negotiated_Discount__c, Account_Name__r.Vision_Care_Effective_Date__c, Account_Name__r.Vision_Care_End_Date__c, Program_Effective_Date__c, Bypass_VC_Validation_Rules__c FROM Network_Relationship__c WHERE Account_Name__c IN :lstBusinessAccounts';
 
//global final String gstrQuery = ( Test.isRunningTest() ? 'SELECT Id FROM Network_Relationship__c WHERE name != null LIMIT 1' : soql );
global final String gstrQuery = ( soql );

global Database.QueryLocator start(Database.BatchableContext BC){
    return Database.getQueryLocator(gstrQuery);
}
    
global void execute(Database.BatchableContext BC, List<Network_Relationship__c> scope){

    list<Network_Relationship__c> lstBizNetRelationShip = new list<Network_Relationship__c>();     

    for(Network_Relationship__c net : scope){

            if(net.Program_Effective_Date__c > accTEMP_Vision_Care_End_Date){             
                Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                bizNetRelExist.Program_End_Date__c = accTEMP_Vision_Care_End_Date;        
                bizNetRelExist.Directory_End_Date__c = accTEMP_Vision_Care_End_Date; 
                bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                lstBizNetRelationShip.add(bizNetRelExist);
            }

            if(net.Program_Effective_Date__c <= system.today() && 
                net.Program_End_Date__c != NULL && 
                net.Program_End_Date__c > accTEMP_Vision_Care_End_Date){
                Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                bizNetRelExist.Program_End_Date__c = accTEMP_Vision_Care_End_Date;        
                bizNetRelExist.Directory_End_Date__c = accTEMP_Vision_Care_End_Date; 
                bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                lstBizNetRelationShip.add(bizNetRelExist);

                Network_Relationship__c bizNetRel = new Network_Relationship__c();
                bizNetRel.Contact_Role__c = net.Contact_Role__c;
                bizNetRel.Account_Name__c = net.Account_Name__c;
                bizNetRel.Program_ID__c = net.Program_ID__c;         
                bizNetRel.Program_Effective_Date__c = acc_Vision_Care_Effective_Date;
                bizNetRel.Program_End_Date__c = acc_Vision_Care_End_Date; 
                bizNetRel.Directory_End_Date__c = acc_Vision_Care_End_Date; 
                bizNetRel.Provider_Name__c = net.Provider_Name__c;
                bizNetRel.Vision_Care_Location_Key__c = lbaMap.get(net.Account_Name__c);
                bizNetRel.Fee_Code__c = net.Fee_Code__c;
                bizNetRel.LVC_Negotiated_Discount__c = net.LVC_Negotiated_Discount__c;
                bizNetRel.Bypass_VC_Validation_Rules__c = true;
                lstBizNetRelationShip.add(bizNetRel);
            }

            if(net.Program_Effective_Date__c <= system.today() && net.Program_End_Date__c == NULL) {
                Network_Relationship__c bizNetRelExist = new Network_Relationship__c(Id=net.Id);
                bizNetRelExist.Program_End_Date__c = accTEMP_Vision_Care_End_Date;        
                bizNetRelExist.Directory_End_Date__c = accTEMP_Vision_Care_End_Date; 
                bizNetRelExist.Bypass_VC_Validation_Rules__c = true;
                lstBizNetRelationShip.add(bizNetRelExist);

                Network_Relationship__c bizNetRel = new Network_Relationship__c();
                bizNetRel.Contact_Role__c = net.Contact_Role__c;
                bizNetRel.Account_Name__c = net.Account_Name__c;
                bizNetRel.Program_ID__c = net.Program_ID__c;         
                bizNetRel.Program_Effective_Date__c = acc_Vision_Care_Effective_Date;
                bizNetRel.Program_End_Date__c = acc_Vision_Care_End_Date; 
                bizNetRel.Directory_End_Date__c = acc_Vision_Care_End_Date; 
                bizNetRel.Provider_Name__c = net.Provider_Name__c;
                bizNetRel.Vision_Care_Location_Key__c = lbaMap.get(net.Account_Name__c);
                bizNetRel.Fee_Code__c = net.Fee_Code__c;
                bizNetRel.LVC_Negotiated_Discount__c = net.LVC_Negotiated_Discount__c;
                bizNetRel.Bypass_VC_Validation_Rules__c = true;
                lstBizNetRelationShip.add(bizNetRel);
            } 

            if(!lstBizNetRelationShip.isEmpty()) { 
                upsert lstBizNetRelationShip;                      
            } 
    }

}

global void finish(Database.BatchableContext BC){
}

}