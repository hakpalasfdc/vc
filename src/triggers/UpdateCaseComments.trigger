trigger UpdateCaseComments on CaseComment (after insert, after update) {
 Set<Id> caseIds = new Set<Id>();
    for ( CaseComment cc : Trigger.new ) {
        caseIds.add(cc.ParentId);
    }
    Case[] updateCase = [select id from Case where Id in :caseIds];
    try{
    update updateCase;
    }catch(Exception e){}
}