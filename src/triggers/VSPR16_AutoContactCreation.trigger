trigger VSPR16_AutoContactCreation on Case (after insert) {
        List<Id> caseIds = new List<Id>{};
        
        if(Trigger.isInsert){
            for(Case c:Trigger.New){
                caseIds.add(c.id);
            }
        }
        
        Set<Id> setIds = new Set<Id>(caseIds);
        VSPR16_GetConsumerID.getConsumerID2(setIds);
}