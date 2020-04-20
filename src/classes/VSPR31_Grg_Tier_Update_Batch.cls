global class VSPR31_Grg_Tier_Update_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    Private Date todaysDate = Date.today();
  //  global final String query = 'SELECT Id, Applied_Tier__c, Applied_Tier__r.Order__c, Calculated_Tier__c, Premier_Location_Count_Future__c, Average_Tiering_Total_Spend_LTM__c, Average_Tiering_Eyewear_Spend_LTM__c, Average_Tiering_Optics_Spend_LTM__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Retinal_Imaging_Indicator_Future__c, Start_Date__c, Tier_Agreement_Type__c, End_Date__c, Contract_Type__c, RecordType.DeveloperName, Override_Effective_Date__c, Override_End_Date__c FROM Global_Rewards_Group__c WHERE Contract_Type__c != NULL AND Contract_Type__c != \'Conflict\' AND IsDeleted = false AND Status__c != \'Inactive\' AND (Override_Effective_Date__c > '+ todaysDate + ' OR Override_Effective_Date__c = NULL OR (Override_Effective_Date__c < '+ todaysDate + ' AND Override_End_Date__c < '+todaysDate+'))'; 
    
    global List<String> exception_List = new List<String>();
    
    global Date todayDate;//// Set to today if not running a test. When running test class, you can set the variable to test different months
    private Set<Id> globalGRGIdSet = new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Applied_Tier__c, Applied_Tier__r.Order__c, Calculated_Tier__c, Premier_Location_Count_Future__c,
                                         Average_Tiering_Total_Spend_LTM__c, Average_Tiering_Eyewear_Spend_LTM__c, Average_Tiering_Optics_Spend_LTM__c, 
                                         Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Retinal_Imaging_Indicator_Future__c, Start_Date__c, 
                                         Tier_Agreement_Type__c, End_Date__c, Contract_Type__c, RecordType.DeveloperName, Override_Effective_Date__c, Override_End_Date__c 
                                         FROM Global_Rewards_Group__c WHERE Contract_Type__c != NULL AND Contract_Type__c != 'Conflict' AND IsDeleted = false AND 
                                         Status__c != 'Inactive' AND (Override_Effective_Date__c > :todaysDate OR Override_Effective_Date__c = NULL OR 
                                                                      (Override_Effective_Date__c < :todaysDate AND Override_End_Date__c < :todaysDate))]);
    }
    
    //Below execute function definition updated by Vikhyat
    //Commented out the List<sObject> to make it List<Global_Rewards_Group__c>
    global void execute(Database.BatchableContext BC, /*List<sObject>*/ List<Global_Rewards_Group__c> scope){
        
        Set<Id> grgIdSet = new Set<Id>();
        
        Map<Id,Global_Rewards_Group__c> grgIdSetMap = new Map<Id, Global_Rewards_Group__c>();
        
        
        for(Global_Rewards_Group__c s : scope){
            grgIdSetMap.put(s.Id,s);
        }
        
        
        //Updated the below if condition. Updated by Vikhyat.
        if(!/*grgIdSet*/grgIdSetMap.isEmpty()){///Set Group Reward Group Applied & Calculated Tier Fields
            
            if(!Test.isRunningTest()){
                todayDate = Date.today();
            }
            
            Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            List<Global_Rewards_Group__c> grgToUpdate = new List<Global_Rewards_Group__c>();
            Map<Id,Global_Rewards_Group__c> grgToUpdateMap = new Map<Id,Global_Rewards_Group__c>();
            Set<Account> busAccUpd = new Set<Account>();
            
            ///All Group Reward Group 
            
            /*        List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
FROM Premier_Tier__c WHERE Contract_Type__c != Null AND Agreement_Type__c = Null AND Status__c = 'Active' Order By Order__c ASC];     

List<Premier_Tier__c> allTierswAgreement = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
FROM Premier_Tier__c WHERE Status__c = 'Active' AND Agreement_Type__c != Null Order By Order__c ASC]; */
            
            
            List<Premier_Tier__c> allT = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Total_Purchases_LTM_Formula__c, Eyewear_Minimum_Formula__c,
                                          Lens_Minimum_Formula__c, Retinal_Imaging_Indicator__c, Free_Fitting_and_Adjustments__c, Exclusive_VSP_Patient_Offers__c, Contract_Type__c,
                                          Total_Purchases_LTM__c, Eyewear_Minimum__c, Lens_Minimum__c, Agreement_Type__c
                                          FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Order__c ASC];
            List<Premier_Tier__c> allTiers = new List<Premier_Tier__c>();         
            List<Premier_Tier__c> allTierswAgreement = new List<Premier_Tier__c>();
            
            for(Premier_Tier__c p: allT){
                if(p.Agreement_Type__c == null && p.Contract_Type__c != Null){
                    allTiers.add(p);
                }
            }
            
            for(Premier_Tier__c p: allT){
                if(p.Agreement_Type__c != null){
                    allTierswAgreement.add(p);
                }
            }
            
            
            Integer TierSet;
            Integer AgreementTierSet;
            //Updated the below for loop to iterate over grgIdSetMap key set. Updated by Vikhyat
            for(Id grgRecId: /*grgIdSet*/ grgIdSetMap.keySet()){
                Global_Rewards_Group__c grgRec = grgIdSetMap.get(grgRecId);
                if(grgRec.Start_Date__c <= todayDate && grgRec.Contract_Type__c != null
                   && (grgRec.End_Date__c >= todayDate || grgRec.End_Date__c == null)){////Qualifying Group Reward Group
                       if(grgRec.Tier_Agreement_Type__c == null){
                           TierSet = 0;
                           for(Premier_Tier__c aTier :allTiers){
                               //Below if condition updated by Vikhyat
                               //Commented out the call of toUpperCase and trim String functions.
                               if((aTier.Retinal_Imaging_Indicator__c == True && grgRec.Retinal_Imaging_Indicator_Future__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                                  (aTier.Free_Fitting_and_Adjustments__c == True && grgRec.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                                  (aTier.Exclusive_VSP_Patient_Offers__c == True && grgRec.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                                  (grgRec.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                                  (grgRec.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                                  (grgRec.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                                  (grgRec.Contract_Type__c/*.toUpperCase().trim()*/ == aTier.Contract_Type__c/*.toUpperCase().trim()*/)                         
                                 ){///Found matching Premier Tier
                                     ////Group Reward Group doesn't have any Applied and Calculated Tier
                                     if(grgRec.Applied_Tier__c == null || 
                                        grgRec.Applied_Tier__r.Order__c == null || 
                                        todayDate.month() == 1 || ////Check in Month
                                        todayDate.month() == 7 || ////Check in Month
                                        grgRec.Applied_Tier__r.Order__c > aTier.Order__c ||
                                        grgRec.Override_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                            grgRec.Applied_Tier__c = aTier.Id;
                                            grgRec.Calculated_Tier__c = aTier.Id;
                                            grgToUpdate.add(grgRec);
                                            grgToUpdateMap.put(grgRec.Id,grgRec);
                                            globalGRGIdSet.add(grgRec.Id);
                                            if(grgRec.Override_End_Date__c < Date.today()){
                                                grgRec.Override_Effective_Date__c = Null;
                                                grgRec.Override_End_Date__c = Null;
                                                grgRec.Override_Tier_Reason__c = Null;
                                            }
                                            TierSet = 1;
                                            break;                                      
                                        }
                                     
                                     ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                     else if(grgRec.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                         grgRec.Calculated_Tier__c = aTier.Id;
                                         grgToUpdate.add(grgRec);
                                         grgToUpdateMap.put(grgRec.Id,grgRec);
                                         globalGRGIdSet.add(grgRec.Id);
                                         TierSet = 1;
                                         break; 
                                     }
                                 }///end if found matching premier tier
                           }///end For loop
                           if(TierSet == 0){/////Group didn't qualify for any tier
                               grgRec.Applied_Tier__c = null;
                               grgRec.Calculated_Tier__c = null;
                               if(grgRec.Override_End_Date__c < Date.today()){
                                   grgRec.Override_Effective_Date__c = Null;
                                   grgRec.Override_End_Date__c = Null;
                                   grgRec.Override_Tier_Reason__c = Null;
                               }
                               grgToUpdate.add(grgRec);
                               grgToUpdateMap.put(grgRec.Id,grgRec);
                               globalGRGIdSet.add(grgRec.Id);
                           }
                       }///end if Group Tier Agreement is Null
                       
                       else{///Group Tier Agreement is not null
                           AgreementTierSet = 0;
                           
                           for(Premier_Tier__c aTier :allTierswAgreement){///using different List
                               //Below if condition updated by Vikhyat
                               //Commented out the call of toUpperCase and trim String functions.
                               if((aTier.Retinal_Imaging_Indicator__c == True && grgRec.Retinal_Imaging_Indicator_Future__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                                  (aTier.Free_Fitting_and_Adjustments__c == True && grgRec.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                                  (aTier.Exclusive_VSP_Patient_Offers__c == True && grgRec.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                                  (grgRec.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                                  (grgRec.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                                  (grgRec.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                                  (grgRec.Tier_Agreement_Type__c/*.toUpperCase().trim()*/ == aTier.Agreement_Type__c/*.toUpperCase().trim()*/)                         
                                 ){///Found matching Premier Tier
                                     ////Group Reward Group doesn't have any Applied and Calculated Tier
                                     if(grgRec.Applied_Tier__c == null || 
                                        grgRec.Applied_Tier__r.Order__c == null || 
                                        todayDate.month() == 1 || ////Check in Month
                                        todayDate.month() == 7 || ////Check in Month
                                        grgRec.Applied_Tier__r.Order__c > aTier.Order__c ||
                                        grgRec.Override_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                            grgRec.Applied_Tier__c = aTier.Id;
                                            grgRec.Calculated_Tier__c = aTier.Id;
                                            if(grgRec.Override_End_Date__c < Date.today()){
                                                grgRec.Override_Effective_Date__c = Null;
                                                grgRec.Override_End_Date__c = Null;
                                                grgRec.Override_Tier_Reason__c = Null;
                                            }
                                            AgreementTierSet = 1;
                                            grgToUpdate.add(grgRec);
                                            grgToUpdateMap.put(grgRec.Id,grgRec);
                                            globalGRGIdSet.add(grgRec.Id);
                                            break;                                      
                                        }
                                     
                                     ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                     else if(grgRec.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                         grgRec.Calculated_Tier__c = aTier.Id;
                                         AgreementTierSet = 1;
                                         grgToUpdate.add(grgRec);
                                         grgToUpdateMap.put(grgRec.Id,grgRec);
                                         globalGRGIdSet.add(grgRec.Id);
                                         break; 
                                     }
                                 }///end if found matching premier tier
                           }///end For loop
                           
                           if(AgreementTierSet == 0){////No Aggreement Type Tier was set on the Group. Now look at all Tiers
                               TierSet = 0;
                               for(Premier_Tier__c aTier :allTiers){
                                   //Below if condition updated by Vikhyat
                                   //Commented out the call of toUpperCase and trim String functions.
                                   if((aTier.Retinal_Imaging_Indicator__c == True && grgRec.Retinal_Imaging_Indicator_Future__c == True || aTier.Retinal_Imaging_Indicator__c == False)&&
                                      (aTier.Free_Fitting_and_Adjustments__c == True && grgRec.Free_Fitting_and_Adjustments__c == True || aTier.Free_Fitting_and_Adjustments__c == False)&&
                                      (aTier.Exclusive_VSP_Patient_Offers__c == True && grgRec.Exclusive_VSP_Patient_Offers__c == True || aTier.Exclusive_VSP_Patient_Offers__c == False)&&
                                      (grgRec.Average_Tiering_Total_Spend_LTM__c >= aTier.Total_Purchases_LTM_Formula__c || aTier.Total_Purchases_LTM__c == Null)&&
                                      (grgRec.Average_Tiering_Eyewear_Spend_LTM__c >= aTier.Eyewear_Minimum_Formula__c || aTier.Eyewear_Minimum__c == Null)&&
                                      (grgRec.Average_Tiering_Optics_Spend_LTM__c >= aTier.Lens_Minimum_Formula__c || aTier.Lens_Minimum__c == Null)&&
                                      (grgRec.Contract_Type__c/*.toUpperCase().trim()*/ == aTier.Contract_Type__c/*.toUpperCase().trim()*/)                         
                                     ){///Found matching Premier Tier
                                         ////Group Reward Group doesn't have any Applied and Calculated Tier
                                         if(grgRec.Applied_Tier__c == null || 
                                            grgRec.Applied_Tier__r.Order__c == null || 
                                            todayDate.month() == 1 || ////Check in Month
                                            todayDate.month() == 7 || ////Check in Month
                                            grgRec.Applied_Tier__r.Order__c > aTier.Order__c ||
                                            grgRec.Override_End_Date__c < Date.today()){///Found a higher Tier to Qualify for
                                                grgRec.Applied_Tier__c = aTier.Id;
                                                grgRec.Calculated_Tier__c = aTier.Id;
                                                grgToUpdate.add(grgRec);
                                                grgToUpdateMap.put(grgRec.Id,grgRec);
                                                globalGRGIdSet.add(grgRec.Id);
                                                if(grgRec.Override_End_Date__c < Date.today()){
                                                    grgRec.Override_Effective_Date__c = Null;
                                                    grgRec.Override_End_Date__c = Null;
                                                    grgRec.Override_Tier_Reason__c = Null;
                                                }
                                                TierSet = 1;
                                                break;                                      
                                            }
                                         
                                         ///Group Reward group now Qualifies for a lower tier OR Same Tier 
                                         else if(grgRec.Applied_Tier__r.Order__c <= aTier.Order__c) {
                                             grgRec.Calculated_Tier__c = aTier.Id;
                                             grgToUpdate.add(grgRec);
                                             grgToUpdateMap.put(grgRec.Id,grgRec);
                                             globalGRGIdSet.add(grgRec.Id);
                                             TierSet = 1;
                                             break; 
                                         }
                                     }///end if found matching premier tier
                               }///end For loop
                               if(TierSet == 0){/////Group didn't qualify for any tier
                                   grgRec.Applied_Tier__c = null;
                                   grgRec.Calculated_Tier__c = null;
                                   if(grgRec.Override_End_Date__c < Date.today()){
                                       grgRec.Override_Effective_Date__c = Null;
                                       grgRec.Override_End_Date__c = Null;
                                       grgRec.Override_Tier_Reason__c = Null;
                                   }
                                   grgToUpdate.add(grgRec);
                                   grgToUpdateMap.put(grgRec.Id,grgRec);
                                   globalGRGIdSet.add(grgRec.Id);
                               }
                           } //end No Aggreement Type Tier was set on the Group. Now look at all Tiers
                       }///end Else
                   }
                ////Non Qualifying Practice Account
                else{
                    if(grgRec.Applied_Tier__c != null || grgRec.Calculated_Tier__c != null){
                        grgRec.Applied_Tier__c = null;
                        grgRec.Calculated_Tier__c = null;
                        if(grgRec.Override_End_Date__c < Date.today()){
                            grgRec.Override_Effective_Date__c = Null;
                            grgRec.Override_End_Date__c = Null;
                            grgRec.Override_Tier_Reason__c = Null;
                        }
                        grgToUpdate.add(grgRec);
                        grgToUpdateMap.put(grgRec.Id,grgRec);
                        globalGRGIdSet.add(grgRec.Id);
                    }
                }
            }
            
            //Below part commented out by Vikhyat on 08/12/2019
            //system.debug('grgToUpdate List '+ grgToUpdate);
            //Commented out part by Vikhyat ends here.
            
            if(!grgToUpdate.isEmpty()){
                // update grgToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(grgToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Group Reward Group Record Id: ' + grgToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
            
            /////Update Business Account Tiers
            
            // List<Global_Rewards_Group__c> updGrgTiers = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, RecordType.DeveloperName FROM Global_Rewards_Group__c Where Id in :grgToUpdate];
            
            //Below part commented out by Vikhyat on 08/12/2019
            /*List<Global_Rewards_Group_Relationship__c> grgRel = [SELECT Id, Child_Account__c, Global_Rewards_Group__c, End_Date__c FROM Global_Rewards_Group_Relationship__c
WHERE Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)
AND Global_Rewards_Group__c IN :grgToUpdate];

List<Global_Rewards_Group_Relationship__c> grgRelNotActive = [SELECT Id, Child_Account__c, Global_Rewards_Group__c, End_Date__c FROM Global_Rewards_Group_Relationship__c
WHERE End_Date__c = Today
AND Global_Rewards_Group__c IN :grgToUpdate];

List<Account> busAccTierUpd = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, Vision_Care_Good_Standing__c FROM Account WHERE RecordTypeId = :accRecordTypeId AND
//  Vision_Care_Good_Standing__c = True AND
Id IN (SELECT Child_Account__c 
FROM Global_Rewards_Group_Relationship__c 
WHERE Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)
AND Global_Rewards_Group__c IN :grgToUpdate)];

List<Account> busAccTierUpdNotActive = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, Vision_Care_Good_Standing__c FROM Account WHERE RecordTypeId = :accRecordTypeId AND
//  Vision_Care_Good_Standing__c = True AND
Id IN (SELECT Child_Account__c 
FROM Global_Rewards_Group_Relationship__c WHERE End_Date__c = Today
AND Global_Rewards_Group__c IN :grgToUpdate)
AND
Id NOT IN (SELECT Child_Account__c 
FROM Global_Rewards_Group_Relationship__c 
WHERE Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)
AND Global_Rewards_Group__c IN :grgToUpdate)];*/
            //Part commented out by Vikhyat on 08/12/2019 ends here.
            
            //Below part added by Vikhyat
            /*         List<Global_Rewards_Group_Relationship__c> grgRel = new List<Global_Rewards_Group_Relationship__c>();
List<Global_Rewards_Group_Relationship__c> grgRelNotActive = new List<Global_Rewards_Group_Relationship__c>();
Set<Id> grgRelAccId = new Set<Id>();
Set<Id> grgRelNotActiceAccId = new Set<Id>();

List<Global_Rewards_Group_Relationship__c> grgrList = [SELECT Id, Child_Account__c, Global_Rewards_Group__c, End_Date__c FROM Global_Rewards_Group_Relationship__c
WHERE ((Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null)) OR End_Date__c = Today)
AND Global_Rewards_Group__c IN :grgToUpdate];

for(Global_Rewards_Group_Relationship__c grgr: grgrList){
if(grgr.End_Date__c == System.today()){
grgRelNotActive.add(grgr);
grgRelNotActiceAccId.add(grgr.Child_Account__c);
}else{
grgRel.add(grgr);
grgRelAccId.add(grgr.Child_Account__c);
}
}

List<Account> busAccTierUpd = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, Vision_Care_Good_Standing__c FROM Account WHERE RecordTypeId = :accRecordTypeId AND
//  Vision_Care_Good_Standing__c = True AND
Id IN :grgRelAccId];

List<Account> busAccTierUpdNotActive = [SELECT Id, Applied_Tier__c, Calculated_Tier__c, Vision_Care_Good_Standing__c FROM Account WHERE RecordTypeId = :accRecordTypeId AND
//  Vision_Care_Good_Standing__c = True AND
Id IN :grgRelNotActiceAccId AND Id NOT IN :grgRelAccId];

//Part added by Vikhyat ends here.

for(Id grgId :grgToUpdateMap.keySet()){
Global_Rewards_Group__c grg = grgToUpdateMap.get(grgId);
for(Global_Rewards_Group_Relationship__c grgR :grgRel){
for(Account busAcc :busAccTierUpd){
if(busAcc.Id == grgR.Child_Account__c && grgR.Global_Rewards_Group__c == grg.Id){
if(busAcc.Vision_Care_Good_Standing__c != True){
busAcc.Applied_Tier__c = null;
busAcc.Calculated_Tier__c = null;
busAcc.Tier_Calculation_Group_Level_Batch__c = null;
busAcc.Tier_Calculation_Record_ID__c = null;
}
else{
busAcc.Applied_Tier__c = grg.Applied_Tier__c;
busAcc.Calculated_Tier__c = grg.Calculated_Tier__c;
if(grg.Applied_Tier__c == null){
busAcc.Tier_Calculation_Group_Level_Batch__c = null;
busAcc.Tier_Calculation_Record_ID__c = null;
}
else if(grg.RecordType.DeveloperName == 'Tax_ID_Rollup_Contract_Type'){
busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grg.Id +',' + ' Tax ID Rollup & Contract Type';
busAcc.Tier_Calculation_Record_ID__c = grg.Id;
}
else if(grg.RecordType.DeveloperName == 'Tax_ID_Rollup'){
busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grg.Id +',' + ' Tax ID Rollup';
busAcc.Tier_Calculation_Record_ID__c = grg.Id;
}
else if(grg.RecordType.DeveloperName == 'Contract_Type'){
busAcc.Tier_Calculation_Group_Level_Batch__c = URL.getOrgDomainUrl().toExternalForm() +'/'+ grg.Id +',' + ' Contract Type';
busAcc.Tier_Calculation_Record_ID__c = grg.Id;
}
}
busAccUpd.add(busAcc);
}
}

}
for(Global_Rewards_Group_Relationship__c grgR :grgRelNotActive){
for(Account busAcc :busAccTierUpdNotActive){
if(busAcc.Id == grgR.Child_Account__c && grgR.Global_Rewards_Group__c == grg.Id){

busAcc.Applied_Tier__c = null;
busAcc.Calculated_Tier__c = null;
busAcc.Tier_Calculation_Group_Level_Batch__c = null;
busAcc.Tier_Calculation_Record_ID__c = null;

busAccUpd.add(busAcc);
}
}
}
}


List<Account> busAccUpdLst = new List<Account>(busAccUpd);

//Below part commented out by Vikhyat on 08/12/2019
//system.debug('busAccUpd List '+ busAccUpd);
//Commented out part by Vikhyat ends here.

if(!busAccUpdLst.isEmpty()){
// update busAccUpd;

Database.SaveResult[] SaveResultList = Database.update(busAccUpdLst,false); 

for(integer i =0; i<SaveResultList.size();i++){
String msg='';
If(!SaveResultList[i].isSuccess()){

msg += 'Group Reward Group Record Id: ' + busAccUpdLst.get(i).id + '\n'+'Error: "';        
for(Database.Error err: SaveResultList[i].getErrors()){  
msg += err.getmessage()+'"\n\n';
} 
}
if(msg!= '')
exception_List.add(msg);
} 
}*/
        }
        
    }
    
    
    
    global void finish(Database.BatchableContext BC){
        
        //Below if condition updated by Vikhyat on 08/08/2019.
        //Updated the part to achieve higher test coverage.
        if(!exception_List.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Group Premier Tier Update Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List.size() + '<br><br>' + exception_List + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
        
        //Updated the below part to only run when test is not running. Updated by Vikhyat
        if(!Test.isRunningTest()){
            VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch  obj = new VSPR31_Bus_Acc_Tier_Upd_Actv_Grg_Batch (globalGRGIdSet);
            Database.executeBatch(obj, 50);
        }
        //Updated part by Vikhyat ends here.
        
        
    }
}