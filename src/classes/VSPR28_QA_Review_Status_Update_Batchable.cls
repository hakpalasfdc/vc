global class VSPR28_QA_Review_Status_Update_Batchable implements Database.Batchable<sObject>,Database.AllowsCallouts{

     global final String Query;
    
    global VSPR28_QA_Review_Status_Update_Batchable(String q){
        Query =q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    
    global void execute(Database.BatchableContext BC, List<sObject> scope){
        
        Set<Id> qaRec = new Set<Id>();
        
        for(sobject s : scope){
            QA_Review__c T = (QA_Review__c)s;
            qaRec.add(T.Id);
        }
        
        if(!qaRec.isEmpty()){
            List<QA_Review__c> qaRectoUpd = new List<QA_Review__c>();
            List<QA_Review__c> allQARec = [Select Id, QA_Review_Status__c from QA_Review__c Where Id IN :qaRec];
            
            for(QA_Review__c updList :allQARec){
                updList.QA_Review_Status__c = 'Closed - Non-responder';
                qaRectoUpd.add(updList);
            }
            
            if(!qaRectoUpd.isEmpty()){
                update qaRectoUpd;
            }
            
        }
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
    }
}