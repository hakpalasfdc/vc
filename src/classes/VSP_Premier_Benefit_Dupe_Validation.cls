public class VSP_Premier_Benefit_Dupe_Validation {
    public static boolean VSP_Premier_Benefit_Dupe_Validation_Recursion = true;
    public static void VSP_Premier_Benefit_Dupe_Validation(List<Premier_Benefit__c> newBenefitRecs){
        VSP_Premier_Benefit_Dupe_Validation_Recursion = false;
        system.debug('***** entered VSP_Premier_Benefit_Dupe_Validation ***** ');
        
        Set<String> newBenefitName = new Set<String>();
        Set<Id> cloneSourceIds = new Set<Id>();
        Set<Id> newBenId = new Set<Id>();
        Map<Id,Premier_Benefit__c> newBenMap = new Map<Id,Premier_Benefit__c>();
        for(Premier_Benefit__c nBenRec :newBenefitRecs){
            newBenefitName.add(nBenRec.Name);
            newBenMap.put(nBenRec.Id,nBenRec);
            newBenId.add(nBenRec.Id);
            if(nBenRec.isClone()){
                cloneSourceIds.add(nBenRec.getCloneSourceId());
            }
        }
        
        System.debug('Benifit Name ' + newBenefitName);
        
        
        if(!newBenefitName.isEmpty()){
            
            List<Premier_Benefit__c> exBenefitList = [Select Id, Name, Benefit_Type__c From Premier_Benefit__c
                                                      Where Name IN :newBenefitName
                                                      AND Id NOT IN :newBenefitRecs];
            
            if(!exBenefitList.isEmpty()){
                for(Premier_Benefit__c newRec :newBenefitRecs){
                    for(Premier_Benefit__c exRec :exBenefitList){
                        if(exRec.Name == newRec.Name && exRec.Benefit_Type__c == newRec.Benefit_Type__c){
                            newRec.addError('This benefit already exists');
                        }
                    }
                    
                }
                
            }
        }
        
        if(!cloneSourceIds.isEmpty()){
            List<Premier_Benefit__c> cloneBenefitLst = [Select Id, Status__c FROM Premier_Benefit__c Where Id IN :cloneSourceIds];
            
            for(Premier_Benefit__c prior :cloneBenefitLst){
                for(Id newId :newBenId){
                    Premier_Benefit__c currRec = newBenMap.get(newId);
                    if(currRec.getCloneSourceId() == prior.Id && prior.Status__c == 'Future'){
                        currRec.addError('You can not clone a Future Benefit');
                    }
                }                
            }
        }
    }
    public static boolean VSPR32_VSP_Premier_Benefit_Delete_Recursion = true;
    public static void delete_VSPR32_VSP_Premier_Benefit_Validation(List<Premier_Benefit__c> benefitRecs){
        if(VSPR32_VSP_Premier_Benefit_Delete_Recursion){
            VSPR32_VSP_Premier_Benefit_Delete_Recursion = false;
            
            System.debug('***Entered Delete Record VSPR32_VSP_Premier_Benefit_Validation***');
            
            List<Profile> getUserProfile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
            String profileName = getUserProfile[0].Name;

            if(profileName != 'System Administrator' && profileName != 'VSP Technical User'){

                System.debug('User Profile : ' + profileName);
                for(Premier_Benefit__c pb: benefitRecs){
                    
                    System.debug('***benefitRecs*** ' + benefitRecs);
                    if(pb.Status__c != 'Future')
                    {
                        pb.addError('You cannot delete an Active or Inactive benefit');  
                    }
                }  
            }
        }
    }    
}