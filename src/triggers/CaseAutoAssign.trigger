trigger CaseAutoAssign on Case (after insert) {
    List<Id> caseIds = new List<Id>{};
    for (Case c:trigger.new) {
        if(c.Auto_Assign__c == true){
            caseIds.add(c.Id);
        }
    }
    List<Case> cases = new List<Case>{}; 
    for(Case c : [Select Id from Case where Id in :caseIds]){
        Database.DMLOptions dmo = new Database.DMLOptions();
        dmo.assignmentRuleHeader.useDefaultRule = true;
        c.setOptions(dmo);
        cases.add(c);
    }
    Database.upsert(cases);
}