public class VSPR34_FFAA_Update {
    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    public static boolean VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate_Recursion = true;
    
    public void VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate(List<Account> triggerNew, Map<Id, Account> oldMap){
        if(VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate_Recursion){
            VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate_Recursion = false;
            
            system.debug('VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate_Recursion: ' + VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate_Recursion);
            system.debug('***** entered VSPR34_FFAA_Update_CheckBAFFAABeforeInserUpdate ***** ');
            
            //List<Account> baToUpdate = new List<Account>();
            
            for(Account a: triggerNew) { 
                //System.debug('NEW Participation Exclusions: ' + a.Participation_Exclusions__c);
                //System.debug('OLD Participation Exclusions: ' + oldMap.get(a.Id).Participation_Exclusions__c);
                //System.debug('NEW VC__c: ' + a.VC__c);
                //System.debug('OLD VC__c: ' + oldMap.get(a.Id).VC__c);
                if(oldMap != null && oldMap.get(a.Id).RecordTypeId == businessRecordTypeID){
                    if(a.VC__c != oldMap.get(a.id).VC__c 
                       || oldMap.get(a.Id).Participation_Exclusions__c != null && a.Participation_Exclusions__c == null 
                       || oldMap.get(a.Id).Participation_Exclusions__c == null && a.Participation_Exclusions__c != null
                       || a.Participation_Exclusions__c != oldMap.get(a.Id).Participation_Exclusions__c){
                           
                           if(a.VC__c){
                               if(a.Participation_Exclusions__c == null || !a.Participation_Exclusions__c.contains('NOFFAA – Opts out of free fittings and adjustments')){
                                   a.Free_Fitting_and_Adjustments__c = true; 
                               }  
                               else{                                    
                                   if(a.Free_Fitting_and_Adjustments__c == true){
                                       a.Free_Fitting_and_Adjustments__c = false;
                                   }
                               } 
                               
                               if(a.Participation_Exclusions__c == null || !a.Participation_Exclusions__c.contains('NODIS – Opts out of discounts')){
                                   a.Exclusive_VSP_Patient_Offers__c = true; 
                               }  
                               else{                                    
                                   if(a.Exclusive_VSP_Patient_Offers__c == true){
                                       a.Exclusive_VSP_Patient_Offers__c = false;
                                   }
                               } 
                           }
                           else{ //When VC is false and if the BA Free Fitting is false set the flag back to True
                               if(//a.Participation_Exclusions__c == null || a.Participation_Exclusions__c != null && 
                                   a.Free_Fitting_and_Adjustments__c == false){
                                       a.Free_Fitting_and_Adjustments__c = true; 
                                   } 
                               //When BA VC is false and had Exclusive VSP Patient Offers
                               if(oldMap.get(a.Id).Exclusive_VSP_Patient_Offers__c == true){
                                   a.Exclusive_VSP_Patient_Offers__c = false; 
                               }
                           }
                       }
                }
                //New record only for before insert
                else{
                    System.debug('New Record VC: ' + a.VC__c);
                    System.debug('New Record Participation Exclusion: ' + a.Participation_Exclusions__c);
                    if(a.VC__c && a.RecordTypeId == businessRecordTypeID){
                        if(a.Participation_Exclusions__c == null || !a.Participation_Exclusions__c.contains('NOFFAA – Opts out of free fittings and adjustments')){
                            a.Free_Fitting_and_Adjustments__c = true;
                        }
                        else{
                            a.Free_Fitting_and_Adjustments__c = false;      
                        }
                        
                        if(a.Participation_Exclusions__c == null || !a.Participation_Exclusions__c.contains('NODIS – Opts out of discounts')){
                            a.Exclusive_VSP_Patient_Offers__c = true;
                        }
                        else{
                            a.Exclusive_VSP_Patient_Offers__c = false;      
                        }                           
                    }
                }
                System.debug('BA Free Fitting: ' + a.Free_Fitting_and_Adjustments__c);
            }
            system.debug('***** existing VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate ***** ');
        }
    }
    
    //commented out by Vikhyat
    /*public static boolean VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = true;
    public void VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate(List<Account> triggerNew, Map<Id, Account> oldMap){
        if(VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion){
            VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion = false;
            
            system.debug('VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion: ' + VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate_Recursion);
            system.debug('***** entered VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate ***** ');
            
            Set<Id> paId = new Set<Id>();
            Set<Id> baId = new Set<Id>();
            
            for(Account ba: triggerNew){
                System.debug('NEW Participation Exclusions: ' + ba.Participation_Exclusions__c);
                System.debug('OLD Participation Exclusions: ' + oldMap.get(ba.Id).Participation_Exclusions__c);
                if(oldMap != null && oldMap.get(ba.Id).RecordTypeId == businessRecordTypeID){
                    if(ba.VC__c != oldMap.get(ba.Id).VC__c
                       || (oldMap.get(ba.Id).Participation_Exclusions__c != null && ba.Participation_Exclusions__c == null
                           || oldMap.get(ba.Id).Participation_Exclusions__c == null && ba.Participation_Exclusions__c != null
                           || ba.Participation_Exclusions__c != oldMap.get(ba.Id).Participation_Exclusions__c)){
                               system.debug('NEW BA ParentId: ' + ba.ParentId);
                               system.debug('OLD BA ParentId: ' + oldMap.get(ba.ParentId));
                               
                               if(ba.ParentId != null){
                                   paId.add(ba.ParentId);
                                   baId.add(ba.Id);
                               }
                               
                               
                           }
                } 
            }
            System.debug('Practice Account Id After: ' + paId);
            //If the BA has a PA associated to it then we will want to update the PA
            if(!paId.isEmpty()){
                List<Account> paList = [SELECT Id
                                        FROM Account 
                                        WHERE recordTypeId =:practiceRecordTypeID and Id in :paId];
                //Get all Business Account where if All of them have a Participation_Exlcusions__c then we set the Free Fitting Adjustment Checkbox to False
                List<Account> baList = [SELECT Id, ParentId, Participation_Exclusions__c, VC__c 
                                        FROM Account 
                                        WHERE recordTypeId =:businessRecordTypeID AND ParentId in :paId AND VC__c = true];
                
                List<Account> paToUpdate = new List<Account>();
                
                Map<Id, List<Account>> mapPrA = new Map<Id, List<Account>>();
                for(Account pa: baList){
                    if(mapPrA.containsKey(pa.ParentId)){
                        List<Account> existingValues = mapPrA.get(pa.ParentId);
                        existingValues.add(pa);
                        mapPra.put(pa.ParentId, existingValues);
                    }
                    else{
                        mapPrA.put(pa.ParentId, new List<Account>{pa});
                    }
                }
                
                for(Account practAccnt: paList){
                    
                    practAccnt.Free_Fitting_and_Adjustments__c = false;

                    practAccnt.Exclusive_VSP_Patient_Offers__c = false;

                    List<Account> mapPraValues = mapPrA.get(practAccnt.Id);
                    
                    if(mapPraValues != Null){
                        for(Account ba: mapPraValues){
                            //system.debug('ba Partcipation: ' + ba.Participation_Exclusions__c);
                            //system.debug('ba VC__c: ' + ba.VC__c);
                            if(ba.VC__c && (ba.Participation_Exclusions__c == null || !ba.Participation_Exclusions__c.contains('NOFFAA – Opts out of free fittings and adjustments'))){
                                practAccnt.Free_Fitting_and_Adjustments__c = true;
                                break;
                            }
                        }

                        //Included by Vikhyat
                        for(Account ba: mapPraValues){
                            //system.debug('ba Partcipation: ' + ba.Participation_Exclusions__c);
                            //system.debug('ba VC__c: ' + ba.VC__c);
                            if(ba.VC__c && (ba.Participation_Exclusions__c == null || !ba.Participation_Exclusions__c.contains('NODIS – Opts out of discounts'))){
                                practAccnt.Exclusive_VSP_Patient_Offers__c = true;
                                break;
                            }
                        }
                    }
                    system.debug('pracAccnt Free Fitting Adjustment: ' + practAccnt.Free_Fitting_and_Adjustments__c);
                    paToUpdate.add(practAccnt);
                }
                if(!paToUpdate.isEmpty()){
                    update paToUpdate;
                }
            }
            
            system.debug('baId: ' + baId);
            if(!baId.isEmpty()){
                Set<Id> grgId = new Set<Id>();
                List<Global_Rewards_Group_Relationship__c> grgrList = [SELECT Id, Status__c, Child_Account__c, Global_Rewards_Group__c
                                                                       FROM Global_Rewards_Group_Relationship__c 
                                                                       WHERE Child_Account__c IN :baId 
                                                                       AND Status__c = 'Active'];
                
                for(Global_Rewards_Group_Relationship__c grgr: grgrList){
                    if(grgr.Global_Rewards_Group__c != null){
                        grgId.add(grgr.Global_Rewards_Group__c);
                    }
                }
                system.debug('grgId: ' + grgId);
                if(!grgId.isEmpty()){
                    List<Global_Rewards_Group_Relationship__c> grgrBAList = [SELECT Id, Status__c, Child_Account__c, Global_Rewards_Group__c, Child_Account__r.Participation_Exclusions__c, Child_Account__r.VC__c
                                                                             FROM Global_Rewards_Group_Relationship__c 
                                                                             WHERE Global_Rewards_Group__c IN :grgId 
                                                                             AND Status__c = 'Active' 
                                                                             AND Child_Account__r.RecordTypeId =: businessRecordTypeID
                                                                             AND Global_Rewards_Group__r.Status__c = 'Active'];
                    
                    Map<Id, List<Global_Rewards_Group_Relationship__c>> grgrMAP = new Map<Id, List<Global_Rewards_Group_Relationship__c>>();
                    if(!grgrBAList.isEmpty()){
                        for(Global_Rewards_Group_Relationship__c grgrBA: grgrBAList){
                            if(grgrMAP.containsKey(grgrBA.Global_Rewards_Group__c)){
                                List<Global_Rewards_Group_Relationship__c> existingValues = grgrMAP.get(grgrBA.Global_Rewards_Group__c);
                                existingValues.add(grgrBA);
                                grgrMAP.put(grgrBA.Global_Rewards_Group__c, existingValues);
                            }
                            else{
                                grgrMAP.put(grgrBA.Global_Rewards_Group__c, new List<Global_Rewards_Group_Relationship__c>{grgrBA});
                            }
                        }
                        
                        system.debug('grgrMAP: ' + grgrMAP);
                        if(!grgrMAP.isEmpty()){
                            List<Global_Rewards_Group__c> grgBAList = [SELECT Id, Free_Fitting_and_Adjustments__c
                                                                       FROM Global_Rewards_Group__c
                                                                       WHERE Id IN: grgrMAP.keySet()];
                            
                            List<Global_Rewards_Group__c> grgToUpdate = new List<Global_Rewards_Group__c>();
                            
                            for(Global_Rewards_Group__c grgUpd: grgBAList){
                                grgUpd.Free_Fitting_and_Adjustments__c = false;
                                
                                //Included by Vikhyat
                                grgUpd.Exclusive_VSP_Patient_Offers__c = false;
                                
                                List<Global_Rewards_Group_Relationship__c> grgrUpdValues = grgrMAP.get(grgUpd.Id);
                                if(grgrUpdValues != Null){
                                    for(Global_Rewards_Group_Relationship__c grgrUpd: grgrUpdValues){
                                        if(grgrUpd.Child_Account__r.VC__c && (grgrUpd.Child_Account__r.Participation_Exclusions__c == null 
                                                                              || !grgrUpd.Child_Account__r.Participation_Exclusions__c.contains('NOFFAA – Opts out of free fittings and adjustments'))){
                                                                                  grgUpd.Free_Fitting_and_Adjustments__c = true; 
                                                                                  break;
                                                                              }
                                    }

                                    //included by vikhyat
                                    for(Global_Rewards_Group_Relationship__c grgrUpd: grgrUpdValues){
                                        if(grgrUpd.Child_Account__r.VC__c && (grgrUpd.Child_Account__r.Participation_Exclusions__c == null 
                                                                              || !grgrUpd.Child_Account__r.Participation_Exclusions__c.contains('NODIS – Opts out of discounts'))){
                                                                                  grgUpd.Exclusive_VSP_Patient_Offers__c = true; 
                                                                                  break;
                                                                              }
                                    }
                                }
                                grgToUpdate.add(grgUpd);
                            }
                            if(!grgToUpdate.isEmpty()){
                                update grgToUpdate;
                            }
                        }
                    }
                }
            }
            system.debug('***** exiting VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate ***** ');
        }
    }*/

    @InvocableMethod(label='Update Practice Exclusive VSP and Free Fitting Indicator' description='Updating the Practice Exclusive VSP Patient Offers and Free Fitting and Adjustments Indicator based on the Business Account corresponding values')
    public static void practiceAccountFFaaNodisUpdate(List<Account> busAccountList){

        Set<Id> pracIdSet = new Set<Id>();

        for(Account a: busAccountList){
            if(a.recordTypeId == businessRecordTypeID){
                pracIdSet.add(a.ParentId);
            }
        }

        processPracticeAccountUpdate(pracIdSet);

    }

	private static void processPracticeAccountUpdate(Set<Id> pracIdSet){
        List<Account> practiceAccountList = [Select Id, Exclusive_VSP_Patient_Offers__c, Free_Fitting_and_Adjustments__c, VC__c from Account where Id in :pracIdSet and recordTypeId = :practiceRecordTypeID];
        List<Account> businessAccountList = [Select Id, ParentId, Exclusive_VSP_Patient_Offers__c, Free_Fitting_and_Adjustments__c from Account where recordTypeId = :businessRecordTypeID and ParentId in :pracIdSet and VC__c = true and (Exclusive_VSP_Patient_Offers__c = false or Free_Fitting_and_Adjustments__c = true)];

        Set<Id> practiceIdFFAASet = new Set<Id>();
        Set<Id> practiceIdNODISSet = new Set<Id>();
        Set<Id> practiceIdSet = new Set<Id>();
        List<Account> practiceAccToUpd = new List<Account>();

        for(Account a: businessAccountList){
            if(!a.Exclusive_VSP_Patient_Offers__c){
                practiceIdNODISSet.add(a.ParentId);
                practiceIdSet.add(a.ParentId);
            }
            if(a.Free_Fitting_and_Adjustments__c){
                practiceIdFFAASet.add(a.ParentId);
                practiceIdSet.add(a.ParentId);
            }
        }

        for(Account a: practiceAccountList){
            Boolean bool = false;
            if(!a.VC__c){
                a.Exclusive_VSP_Patient_Offers__c = false; 
                a.Free_Fitting_and_Adjustments__c = false;
                bool = true;
            }else{
                if(practiceIdSet.contains(a.Id)){
                    if(practiceIdNODISSet.contains(a.Id)){
                        if(a.Exclusive_VSP_Patient_Offers__c){
                            a.Exclusive_VSP_Patient_Offers__c = false;
                            bool = true;
                        }
                    }else{
                        if(!a.Exclusive_VSP_Patient_Offers__c){
                            a.Exclusive_VSP_Patient_Offers__c = true;
                            bool = true;
                        }
                    }

                    if(practiceIdFFAASet.contains(a.Id)){
                        if(!a.Free_Fitting_and_Adjustments__c){
                            a.Free_Fitting_and_Adjustments__c = true;
                            bool = true;
                        }
                    }else{
                        if(a.Free_Fitting_and_Adjustments__c){
                            a.Free_Fitting_and_Adjustments__c = false;
                            bool = true;
                        }
                    }
                }else{
                    if(a.Free_Fitting_and_Adjustments__c){
                        a.Free_Fitting_and_Adjustments__c = false;
                        bool = true;
                    }

                    if(!a.Exclusive_VSP_Patient_Offers__c){
                        a.Exclusive_VSP_Patient_Offers__c = true;
                        bool = true;
                    }
                }
            }
            if(bool){
                practiceAccToUpd.add(a);
            }
        }

        if(practiceAccToUpd.size()>0){
            update practiceAccToUpd;
        }
	} 
}