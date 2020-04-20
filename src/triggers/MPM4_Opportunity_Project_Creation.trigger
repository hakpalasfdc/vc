trigger MPM4_Opportunity_Project_Creation on Opportunity (after insert, after update) {
String oppoRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Opportunity' and Name='Shift Opportunity'].Id;
Boolean oldOppIsWon = false;
Boolean newOppIsWon = true;
Opportunity oldOpp;
List<Opportunity> oppList = new List<Opportunity>{}; 
for(Opportunity o : Trigger.new){

oppList.add(o);
system.debug('***************' +oppList);
}


if(Trigger.isAfter){ 
for(Opportunity o : oppList){


if(Trigger.oldMap != null){
oldOpp = Trigger.oldMap.get(o.Id);
oldOppIsWon = oldOpp.StageName.equals('Closed Won');
}
newOppIsWon = o.StageName.equals('Closed Won');

if (o.recordTypeId == oppoRecordTypeId && (!oldOppIsWon && newOppIsWon) ){
system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    Type pcu = System.Type.forName('MPM4_BASE', 'Milestone1_Project_Creation_Utility');
          if(pcu != null){
          system.debug('+++++++++++++++++++++++++++++++++');
            MPM4_BASE.Milestone1_Project_Creation_Utility projCreationUtil = 

(MPM4_BASE.Milestone1_Project_Creation_Utility) pcu.newInstance();
          if(Trigger.isAfter){
          system.debug('old map value is' + trigger.oldMap);
          system.debug('new map value is' + trigger.newMap);
projCreationUtil.CreateChildProject(trigger.oldMap, trigger.newMap, new Map<string, object>{
'projectCreationField' => 'Project_Type__c',
'projectLookupField1' => 'MPM4_BASE__Opportunity__c',
'projectLookupField2' => 'MPM4_BASE__Account__c',
'secondaryLookup' => 'AccountId',
'projectNamingConventionField' => 'Shift_Opportunity_Account_Name__c'
});
          }
     }  
 }
 }
}
}