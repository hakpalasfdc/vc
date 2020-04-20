public class VSPR26_PopulateResolutionContact {
    
    public static boolean VSPR26_PopulateResolutionContact_recursion = true;
    public void setResolution(List<Case> newCaselst,Map<Id,Case> mpOldCase) {
        
        if(VSPR26_PopulateResolutionContact_recursion){
            VSPR26_PopulateResolutionContact_recursion = false;
            system.debug('***** VSPR26_PopulateResolutionContact ***** ');
            Id eyeconicRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Eyeconic').getRecordTypeId();
            Id customerCaseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Customer_Care').getRecordTypeId();
            Set<id> caseId=new Set<Id>();
            Set<String> setTopic = new Set<String>();
            Set<String> setReason = new Set<String>();
            Map<id, Case> mapCase = new Map<Id, Case>();
            for(Case cs : newCaselst){
                
                if(mpOldCase !=null && (cs.RecordTypeId == eyeconicRecordTypeId || cs.RecordTypeId == customerCaseRecordTypeId)){
                    if(cs.Reason_for_Contact__c != mpOldCase.get(cs.Id).Reason_for_Contact__c
                       ||mpOldCase.get(cs.Id).Reason_for_Contact__c == null && cs.Reason_for_Contact__c !=null
                       ||mpOldCase.get(cs.Id).Reason_for_Contact__c != null && cs.Reason_for_Contact__c ==null){
                           caseId.add(cs.Id);
                           mapCase.put(cs.Id,cs);
                           setTopic.add(cs.Product__c);
                           if(cs.Reason_for_Contact__c ==null){
                               
                           }
                           else{
                               List<String> lstString = cs.Reason_for_Contact__c.split(';');
                               for(String t: lstString){
                                   setReason.add(t);
                               }
                           }
                           //  setReason.add(cs.Reason_for_Contact__c);
                       }
                }
                else{
                    if(cs.Reason_for_Contact__c != null && (cs.RecordTypeId == eyeconicRecordTypeId || cs.RecordTypeId == customerCaseRecordTypeId)){
                        caseId.add(cs.Id);
                        mapCase.put(cs.Id,cs);
                        setTopic.add(cs.Product__c);
                        List<String> lstString = cs.Reason_for_Contact__c.split(';');
                        for(String t: lstString){
                            setReason.add(t);
                        }
                    }
                }
            }
            
            if(!caseId.isEmpty()){
                system.debug('***** caseId set ***** ' + caseId);
                system.debug('***** mapCase map ***** ' + mapCase);
                system.debug('***** setTopic ***** ' + setTopic);
                system.debug('***** setReason ***** ' + setReason);
                
                List<Case_Resolution__c> resList = [SELECT Id, Name, Topic__c, Reason_for_Contact__c, Resolution_of_Contact__c 
                                                    FROM Case_Resolution__c
                                                    WHERE Topic__c in :setTopic
                                                    AND Reason_for_Contact__c in :setReason];
                
                
                system.debug('***** resList List ***** ' + resList);
                
                if(!resList.isEmpty() && resList != null){
                    Set<String> resolutionSet = new set<String>();
                    String resolutionString = '';
                    map<Id, String> caseUpd = new map<Id, String>();
                    for(Case updCase: mapCase.values()){
                        for(Case_Resolution__c cr: resList){
                            if(cr.Resolution_of_Contact__c != null
                               && cr.Topic__c == updCase.Product__c 
                               && updCase.Reason_for_Contact__c.contains(cr.Reason_for_Contact__c)){
                                   
                                   resolutionSet.add(cr.Resolution_of_Contact__c);
                               }
                        }
                    }
                    
                    system.debug('***** resolutionSet ***** ' + resolutionSet);
                    
                    for(String s:resolutionSet){
                        System.debug('TESTING++++++ s' + s);
                        if(resolutionString == ''){
                            resolutionString = s;
                        }
                        else{
                            resolutionString = resolutionString + ';' + s;
                        }
                        
                    }
                    
                    
                    for(Case setResolution : mapCase.values()){
                        
                        setResolution.Resolution_of_Contact__c = resolutionString;
                    }
                    
                    
                }
                else{
                    for(Case setResolution :mapCase.values()){
                        setResolution.Resolution_of_Contact__c = null;
                    }
                }
                
            }
            
        }
        
    }
    
    
}