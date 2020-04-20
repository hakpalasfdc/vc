global class VSPR28_QA_Review_Purge_Batchable implements Database.Batchable<sObject>,Database.AllowsCallouts{

    global final String Query;
    
    global VSPR28_QA_Review_Purge_Batchable(String q){
        Query =q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        List<Id> qaRec = new List<Id>();
        
        for(sobject s : scope){
            QA_Review__c T = (QA_Review__c)s;
            qaRec.add(T.Id);
        }
        
        if(!qaRec.isEmpty()){
            
            List<QA_Review__c> alltoDel = [Select Id from QA_Review__c Where Id IN :qaRec];
            
            try{
                delete alltoDel;
            }
            catch(dmlException e){}
            
        }
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}