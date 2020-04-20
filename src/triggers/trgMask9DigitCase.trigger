trigger trgMask9DigitCase on Case (before insert, before update) {
  
    List<Case> caseList = new List<Case>();
    String ccCaseRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Case' and Name='Customer Care'].Id;
    String cdCaseRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Case' and Name='Client Delivery'].Id;
    String eyeconicCaseRecordTypeId=[SELECT Id from RecordType where SObjectType = 'Case' and Name='Eyeconic'].Id;
    
    for(Case c:Trigger.New){
      
        if(Trigger.isInsert){
            if((c.Description <> null || c.Subject <> null) && (c.RecordTypeId == ccCaseRecordTypeId || c.RecordTypeId == cdCaseRecordTypeId || c.RecordTypeId == eyeconicCaseRecordTypeId)){
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& RECORDTYPE NAME &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +c.RecordType.Name);
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& RECORDTYPE NAME &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +c.recordTypeId);
                caseList.add(c);
                
            }
        }
        
        if(Trigger.isUpdate){
            String profileName;
            Id profileId;
            if( ((c.Description != null) && (c.Description != trigger.oldMap.get(c.id).Description)) ||
                           ((c.Subject != null && c.Subject != '') && (c.Subject != trigger.oldMap.get(c.id).Subject)) ){
                profileId = userinfo.getProfileId();
                profileName =[Select Name from Profile where Id=:profileId limit 1].Name;               
            } 
            
            if( ( ((c.Description != null && c.Description != '') && (c.Description != trigger.oldMap.get(c.id).Description)) ||
                           ((c.Subject != null && c.Subject != '') && (c.Subject != trigger.oldMap.get(c.id).Subject)) ) && 
                           (profileName == 'VSP Customer Support Management User' || profileName == 'System Administrator' || 
                            profileName == 'VSP Technical User' || profileName == 'VSP LOB Admin User') && (c.recordTypeID == ccCaseRecordTypeId || c.RecordTypeId == cdCaseRecordTypeId || c.recordTypeId == eyeconicCaseRecordTypeId)){
                caseList.add(c);
            }
        }
    } 
    if(caseList.size()>0){ 
        //Mask9DigitHandler.methodMask9DigitDescription(caseList);
        Mask9DigitHandler.methodMask9DigitSubject(caseList);
    }   
}