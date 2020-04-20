public class VSPR31_GRGR_Validation {
    public static boolean VSPR31_GRGR_Validation_Recursion = true;
    public static void new_VSPR31_GRG_Validation(List<Global_Rewards_Group_Relationship__c> newTrigger){
        if(VSPR31_GRGR_Validation_Recursion){
            VSPR31_GRGR_Validation_Recursion = false;
            
            System.debug('***Entered New Record VSPR31_GRG_Validation***');
            Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
            Id grpTaxIdRollupContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
            
            List<Profile> getUserProfile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
            String profileName = getUserProfile[0].Name;
            
            if(profileName != 'System Administrator'){
                
                System.debug('User Profile : ' + profileName);
                
                Set<Id> grgId = new Set<Id>();           
                
                for(Global_Rewards_Group_Relationship__c grgr: newTrigger){
                    
                    System.debug('***newTrigger*** ' + newTrigger);
                    if(grgr.Global_Rewards_Group__c != null)
                    {
                        grgId.add(grgr.Global_Rewards_Group__c);
                        System.debug('grgId : ' + grgId);
                    }
                    if(!grgId.isEmpty()){
                        List<Global_Rewards_Group_Relationship__c> grgRecord = [SELECT Id, Name, Global_Rewards_Group__r.RecordTypeID 
                                                                                FROM Global_Rewards_Group_Relationship__c 
                                                                                WHERE Global_Rewards_Group__c IN :grgId];
                        System.debug('grgRecord : '+ grgRecord);
                        
                        for(Global_Rewards_Group_Relationship__c newGRGR : grgRecord){
                            if((newGRGR.Global_Rewards_Group__r.RecordTypeID == grpContractRecordTypeId || newGRGR.Global_Rewards_Group__r.RecordTypeID == grpTaxIdRollupContractRecordTypeId))
                            {
                                grgr.addError('You cannot add or edit Relationships on this Global Rewards Group');                      
                            }
                        }
                    }
                } 
            }
        }
    }
    
    public static boolean VSPR31_GRGR_Validation_Delete_Recursion = true;
    public static void delete_VSPR31_GRG_Validation(List<Global_Rewards_Group_Relationship__c> grgrRecords){
        if(VSPR31_GRGR_Validation_Delete_Recursion){
            VSPR31_GRGR_Validation_Delete_Recursion = false;
            
            System.debug('***Entered Delete Record VSPR31_GRG_Validation***');
            Id grpContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
            Id grpTaxIdRollupContractRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup & Contract Type').getRecordTypeId();
            
            List<Profile> getUserProfile = [SELECT Id, Name FROM Profile WHERE Id = :userinfo.getProfileId() LIMIT 1];
            String profileName = getUserProfile[0].Name;
            
            if(profileName != 'System Administrator'){
                
                System.debug('User Profile : ' + profileName);
                
                Set<Id> grgId = new Set<Id>();
                
                for(Global_Rewards_Group_Relationship__c grgr: grgrRecords){
                    
                    System.debug('***grgrRecords*** ' + grgrRecords);
                    if(grgr.Global_Rewards_Group__c != null)
                    {
                        grgId.add(grgr.Global_Rewards_Group__c);
                        System.debug('grgId : ' + grgId);
                    }
                    if(!grgId.isEmpty()){
                        List<Global_Rewards_Group_Relationship__c> grgRecord = [SELECT Id, Name, Global_Rewards_Group__r.RecordTypeID 
                                                                                FROM Global_Rewards_Group_Relationship__c 
                                                                                WHERE Global_Rewards_Group__c IN :grgId];
                        System.debug('grgRecord : '+ grgRecord);
                        
                        for(Global_Rewards_Group_Relationship__c newGRGR : grgRecord){
                            if((newGRGR.Global_Rewards_Group__r.RecordTypeID == grpContractRecordTypeId || newGRGR.Global_Rewards_Group__r.RecordTypeID == grpTaxIdRollupContractRecordTypeId)){
                                   grgr.addError('You cannot add or edit Relationships on this Global Rewards Group');                      
                               }
                        }
                    }
                }  
            }
        }
    } 
}