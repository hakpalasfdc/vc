public class QAReviewTrigger_Handler {
    
    public static boolean VSP_QA_Review_Update_Recursion = true;    
    public static void VSP_QA_Review_Update(List<QA_Review__c> newTrigger, Map<Id, QA_Review__c> oldMap){
        if(VSP_QA_Review_Update_Recursion){
            VSP_QA_Review_Update_Recursion = false;
            
            system.debug('*****entered VSP_QA_Review_Update_Recursion ****');
            
            Set<Id> qaRecIds = new Set<Id>();
            for(QA_Review__c nQA: newTrigger){
                system.debug('***** oldMap ***** ' + oldMap);
                
                if(oldMap != null){
                    if(nQA.Contact_Role__c != oldMap.get(nQA.Id).Contact_Role__c){
                        qaRecIds.add(nQA.Id);
                    }                     
                }
                else{
                    qaRecIds.add(nQA.Id);
                }
            }
            if(!qaRecIds.isEmpty()){
                
                List<QA_Review__c> qaRectoUpd = new List<QA_Review__c>();
                List<QA_Review__c> allQARec = [SELECT Id, Contact_Role__r.Contact__c, Contact_Role__r.Contact__r.Email, Contact_Role__r.Contact__r.FirstName, Contact_Role__r.Contact__r.LastName, Contact_Role__r.Contact__r.Degree__c,
                                               Contact_Role__r.Account__r.Vision_Care_Location_Key__c FROM QA_Review__c WHERE Id IN :qaRecIds];
                
                for(QA_Review__c updQA :allQARec){
                    string formalName = updQA.Contact_Role__r.Contact__r.FirstName + ' ' + updQA.Contact_Role__r.Contact__r.LastName + ', ' + updQA.Contact_Role__r.Contact__r.Degree__c;
                    updQA.Provider_Name__c = updQA.Contact_Role__r.Contact__c;
                    updQA.Provider_Formal_Name__c = formalName;
                    updQA.Vision_Care_Location_Key__c = updQA.Contact_Role__r.Account__r.Vision_Care_Location_Key__c;
                    updQA.Audit_Email__c = updQA.Contact_Role__r.Contact__r.Email;
                    qaRectoUpd.add(updQA);
                }
                
                system.debug('qaRectoUpd List '+ qaRectoUpd);
                
                if(!qaRectoUpd.isEmpty()){
                    update qaRectoUpd;
                }
            } 
        }
    }
    
}