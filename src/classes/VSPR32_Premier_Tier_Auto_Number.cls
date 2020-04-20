public class VSPR32_Premier_Tier_Auto_Number {
    
    public static boolean VSPR32_Premier_Tier_Auto_Recursion = true;
    public static void set_Auto_Number(List<Premier_Tier__c> newTierRecs){
        if(VSPR32_Premier_Tier_Auto_Recursion){
            VSPR32_Premier_Tier_Auto_Recursion = false;
            
            List<Premier_Tier__c> ptLst = [SELECT Tier_Name_Id__c, Tier_Name_AutoNumber__c FROM Premier_Tier__c WHERE Tier_Name_AutoNumber__c != NULL ORDER BY Tier_Name_AutoNumber__c DESC LIMIT 1];
            
            Integer autoNum;            
            
            if(ptLst.isEmpty()){
                autoNum = 0;
            }
            else{
                autoNum = integer.valueof(ptLst[0].Tier_Name_AutoNumber__c); 
            }
            for(Premier_Tier__c nRec :newTierRecs){
                autoNum++;
                if(autoNum == 32001){
                    nRec.addError('The Max Number of Tiers has been met');
                }
                nRec.Tier_Name_AutoNumber__c = autoNum;
                nRec.Tier_Name_Id__c = autoNum;
            }
        }
    }
    
    public static boolean VSPR32_Premier_Tier_Delete_Auto_Number = true;
    public static void skip_Auto_Number(Map<Id,Premier_Tier__c> tierIdMap){
        if(VSPR32_Premier_Tier_Delete_Auto_Number){
            VSPR32_Premier_Tier_Delete_Auto_Number = false;
            
            List<String> exception_List = new List<String>();
            List<Premier_Tier__c> updTLst = new List<Premier_Tier__c>();
            List<Premier_Tier__c> ptLst = [SELECT Tier_Name_Id__c, Tier_Name_AutoNumber__c FROM Premier_Tier__c WHERE Id NOT IN :tierIdMap.keySet() 
                                           AND Tier_Name_AutoNumber__c != NULL ORDER BY Tier_Name_AutoNumber__c DESC LIMIT 1];
            
            List<Premier_Tier__c> delTier = tierIdMap.values();
            Integer highstNum = 0;
            for(Premier_Tier__c deloop :delTier){
                if(highstNum < integer.valueOf(deloop.Tier_Name_AutoNumber__c)){
                   highstNum = integer.valueOf(deloop.Tier_Name_AutoNumber__c);
                }                
            }
            for(Premier_Tier__c updOldTier :ptLst){
                
                if(updOldTier.Tier_Name_AutoNumber__c < highstNum){
                    updOldTier.Tier_Name_AutoNumber__c = highstNum;
                    updTLst.add(updOldTier);
                }
            }
            
            if(!updTLst.isEmpty()){
                update updTLst;    
            } 
            
        }
    }
}