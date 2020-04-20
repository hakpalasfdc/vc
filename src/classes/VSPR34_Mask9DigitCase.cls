public class VSPR34_Mask9DigitCase {
    
    public static boolean VSPR34_Mask9DigitCaseInsert_recursion = true;
    public static void Mask9DigitCaseInsert(List<Case> newCaseLst){
        
        if(VSPR34_Mask9DigitCaseInsert_recursion = true){
            VSPR34_Mask9DigitCaseInsert_recursion = false;
            
            system.debug('***** entered VSPR34_Mask9DigitCase.Mask9DigitCaseInsert ***** ');
            
            List<Case> caseList = new List<Case>();
            Id ccCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
            Id cdCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client Delivery').getRecordTypeId();
            Id eyeconicCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
            
            for(Case c:newCaseLst){
                if((c.Description <> null || c.Subject <> null) && (c.RecordTypeId == ccCaseRecordTypeId || c.RecordTypeId == cdCaseRecordTypeId || c.RecordTypeId == eyeconicCaseRecordTypeId)){
                    system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& RECORDTYPE NAME &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +c.RecordType.Name);
                    system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& RECORDTYPE NAME &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +c.recordTypeId);
                    caseList.add(c);
                    
                }
            }
            
            if(!caseList.isEmpty()){ 
                Mask9DigitHandler.methodMask9DigitSubject(caseList);
            }   
        }
    }
    
    public static boolean VSPR34_Mask9DigitCaseUpdate_recursion = true;
    public static void Mask9DigitCaseUpdate(List<Case> newCaseLst, Map<Id,Case> oldCaseMap){
        
        if(VSPR34_Mask9DigitCaseUpdate_recursion){
            VSPR34_Mask9DigitCaseUpdate_recursion = false;
            
            List<Case> caseList = new List<Case>();
            system.debug('***** entered VSPR34_Mask9DigitCase.Mask9DigitCaseUpdate ***** ');
            Id profileId = userinfo.getProfileId();
            String profileName =[Select Name from Profile where Id=:profileId limit 1].Name;
            Id ccCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
            Id cdCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Client Delivery').getRecordTypeId();
            Id eyeconicCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
            
            for(Case c:newCaseLst){
                /*     if( ((c.Description != null) && (c.Description != trigger.oldMap.get(c.id).Description)) ||
((c.Subject != null && c.Subject != '') && (c.Subject != trigger.oldMap.get(c.id).Subject)) ){
profileId = userinfo.getProfileId();
profileName =[Select Name from Profile where Id=:profileId limit 1].Name;               
} */
                
                if( ( ((c.Description != null && c.Description != '') && (c.Description != oldCaseMap.get(c.id).Description)) ||
                     ((c.Subject != null && c.Subject != '') && (c.Subject != oldCaseMap.get(c.id).Subject)) ) && 
                   (profileName == 'VSP Customer Support Management User' || profileName == 'System Administrator' || 
                    profileName == 'VSP Technical User' || profileName == 'VSP LOB Admin User') && (c.recordTypeID == ccCaseRecordTypeId || c.RecordTypeId == cdCaseRecordTypeId || c.recordTypeId == eyeconicCaseRecordTypeId)){
                        caseList.add(c);
                    }
            }
            
            if(!caseList.isEmpty()){ 
                Mask9DigitHandler.methodMask9DigitSubject(caseList);
            } 
            
        }
    }
}