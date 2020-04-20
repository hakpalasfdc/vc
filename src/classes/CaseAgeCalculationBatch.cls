public with sharing class CaseAgeCalculationBatch implements Database.Batchable <sObject> {
    public final String Query;
    
    // Constructor with string parameter
    public CaseAgeCalculationBatch(String q){
        Query = q;
    }
    
    // Start method of Batch class return list of Record
    public Database.QueryLocator start(Database.BatchableContext bc){
        return Database.getQueryLocator(Query);
    }
    
    // Execute method of Batch class for case age calculation logic
    public void execute(Database.BatchableContext bc, List<sObject> sList){
        List<Case> cList= new List<Case>();
        for(sObject s : sList){
            Case c = (Case)s;
            if(c.recordType.Name != null && c.recordType.Name != '' && c.recordType.Name == 'Customer Care'){
                cList.add(c);
            }
        }
        System.debug('cList::'+ cList);
        if(cList.size()>0)
            CaseAgeCalculationHandler.CalculateCaseAge(cList);
    }
    
    // finish method of Batch class
    public void finish(Database.BatchableContext bc){
        
    }
}