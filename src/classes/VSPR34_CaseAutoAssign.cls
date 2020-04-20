public class VSPR34_CaseAutoAssign {
    
    public static boolean VSPR34_setPracticeAccountProdAssets_recursion = true;
    public static void setPracticeAccountProdAssets(List<Case> newCaseLst){
        
        if(VSPR34_setPracticeAccountProdAssets_recursion){
            VSPR34_setPracticeAccountProdAssets_recursion = false;
            
            system.debug('***** entered VSPR34_CaseAutoAssign.setPracticeAccountProdAssets ***** ');
            
            List<Id> caseIds = new List<Id>{};
                for (Case c:newCaseLst) {
                    if(c.Auto_Assign__c == true){
                        caseIds.add(c.Id);
                    }
                }
            
            if(!caseIds.isEmpty()){
                List<Case> cases = new List<Case>{}; 
                    for(Case c : [Select Id from Case where Id in :caseIds]){
                        Database.DMLOptions dmo = new Database.DMLOptions();
                        dmo.assignmentRuleHeader.useDefaultRule = true;
                        c.setOptions(dmo);
                        cases.add(c);
                    }
                Database.upsert(cases);
            }
        }
    }
}