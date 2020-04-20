/*
*
*To mark attachment = true on case, if found on 1st email to case
*/
trigger EmailMessageAttachment on EmailMessage (after insert) { 
  map<Id,EmailMessage> mpCase = new map<Id,EmailMessage>();
  for(EmailMessage em : Trigger.New) {  
      mpCase.put(em.parentid,em); 
  }
  map<Id,Case> mpCaseUpdate = new map<Id,Case>();
  for(Case cs : [select id,CreatedDate, RecordType.Name from Case where Id IN :mpCase.keySet() and RecordType.Name = 'Client Delivery']) {
      EmailMessage em = mpCase.get(cs.Id); 
      Long dt1Long = em.createddate.getTime(); 
      Long dt2Long = cs.createddate.getTime(); 
      Long milliseconds =  dt1Long - dt2Long ; 
      Long seconds = milliseconds / 1000;
    if(seconds < 20 && em.hasAttachment && em.Incoming) { cs.Attachment__c = true; }  mpCaseUpdate.put(cs.Id,cs);
  } update mpCaseUpdate.values(); }