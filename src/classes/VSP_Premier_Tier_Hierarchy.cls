public class VSP_Premier_Tier_Hierarchy {
    
    public static boolean VSP_Tier_Hierarchy_recursion = true;
    public void VSP_Tier_Hierarchy_Update(List<Premier_Tier__c> newTrigger, Map<Id,Premier_Tier__c> oldRecs){
        
        if(VSP_Tier_Hierarchy_recursion){
            VSP_Tier_Hierarchy_recursion = true;
            system.debug('*****entered VSP_Tier_Hierarchy_Update ****');
            //   Set<Id> TierIdUpdate = new Set<Id>();
            Map<Id,Premier_Tier__c> tierHierarchy = new Map<Id, Premier_Tier__c>();
            Map<Id,Premier_Tier__c> tierInactive = new Map<Id, Premier_Tier__c>();
            Map<Id,Premier_Tier__c> toptierActive = new Map<Id, Premier_Tier__c>();
            Map<Id,Premier_Tier__c> toptierInactive = new Map<Id, Premier_Tier__c>();
            
            
            for(Premier_Tier__c nT: newTrigger){
                
                system.debug('***** oldRecs ***** ' + oldRecs);
                system.debug('***** newTrigger ***** ' + newTrigger);
                if(oldRecs != null){
                    //                  if((nT.Hierarchy_Action__c != oldRecs.get(nT.Id).Hierarchy_Action__c ||
                    //                      nT.Hierarchy_Selection__c != oldRecs.get(nT.Id).Hierarchy_Selection__c ||
                    //                      nT.Status__c != oldRecs.get(nT.Id).Status__c) && nT.Status__c == 'Active' && nT.Hierarchy_Selection__c != null){
                    if(nT.Status__c == 'Active' && nT.Hierarchy_Selection__c != null){
                        system.debug('***** TESTING TIER ID ***** ' + nT.Id);
                        //          TierIdUpdate.add(nT.Id);
                        tierHierarchy.put(nT.Id, nT);
                    }
                    else if(oldRecs.get(nT.Id).Status__c == 'Active' && nT.Status__c == 'Inactive' && nT.Hierarchy_Selection__c != null){
                        
                        tierInactive.put(nT.Id, nT);
                    }
                    else if(nT.Status__c != oldRecs.get(nT.Id).Status__c && nT.Status__c == 'Active' && nT.Hierarchy_Action__c == 'Top_Tier'){
                        
                        toptierActive.put(nT.Id, nT);
                    }
                    else if(oldRecs.get(nT.Id).Status__c == 'Active' && nT.Status__c == 'Inactive' && nT.Hierarchy_Action__c == 'Top_Tier'){
                        
                        toptierInactive.put(nT.Id, nT);
                    }
                }
                
                
            }          
            ////Active Tiers
            if(!tierHierarchy.isEmpty()){
                List<Premier_Tier__c> TierToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierByPassToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' AND IsDeleted = false];// Where Id in :TierIdUpdate];
                
                
                
                
                
                for(Premier_Tier__c mpTier :tierHierarchy.values()){
                    for(Premier_Tier__c aTiers: allTiers){
                        if(aTiers.Hierarchy_Selection__c == mpTier.Hierarchy_Selection__c && aTiers.Id != mpTier.Id){
                            aTiers.Hierarchy_Selection__c = mpTier.Id;
                            aTiers.Bypass_Validation__c = True;
                            TierToUpdate.add(aTiers);
                        }
                        
                        
                        
                    }
                    
                }
                
                if(!TierToUpdate.isEmpty()){
                    system.debug('TierToUpdate List '+ TierToUpdate);
                    update TierToUpdate;
                    
                    
                    
                    for(Premier_Tier__c bypass :TierToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierByPassToUpdate.add(bypass);
                    }
                    if(!TierByPassToUpdate.isEmpty()){
                        system.debug('TierByPassToUpdate List '+ TierByPassToUpdate);
                        update TierByPassToUpdate;
                        
                        VSP_Tier_Hierarchy_Order_Delete(TierToUpdate); 
                    }
                }
                else{
                    VSP_Tier_Hierarchy_Order();
                }
                //   VSP_Tier_Hierarchy_Order();
            }
            
            ////Inactive Tiers
            if(!tierInactive.isEmpty()){
                
                List<Premier_Tier__c> TierInActToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierByPassInActToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' AND IsDeleted = false];// Where Id in :TierIdUpdate];
                
                for(Premier_Tier__c mpTier :tierInactive.values()){
                    for(Premier_Tier__c aTiers: allTiers){
                        if(aTiers.Hierarchy_Selection__c == mpTier.Id){
                            aTiers.Hierarchy_Selection__c = mpTier.Hierarchy_Selection__c;
                            aTiers.Bypass_Validation__c = True;
                            TierInActToUpdate.add(aTiers);
                            
                        }
                    }
                    
                }
                
                if(!TierInActToUpdate.isEmpty()){
                    system.debug('TierInActToUpdate List '+ TierInActToUpdate);
                    update TierInActToUpdate;
                    
                    for(Premier_Tier__c bypass :TierInActToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierByPassInActToUpdate.add(bypass);
                    }
                    if(!TierByPassInActToUpdate.isEmpty()){
                        system.debug('TierByPassInActToUpdate List '+ TierByPassInActToUpdate);
                        update TierByPassInActToUpdate;
                        
                        VSP_Tier_Hierarchy_Order_Delete(TierInActToUpdate);
                    }
                    
                }
                else{
                    VSP_Tier_Hierarchy_Order();
                }
                
            }
            
            ////Active Top Tier
            if(!toptierActive.isEmpty()){
                
                List<Premier_Tier__c> TierTopToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierTopByPassToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' AND IsDeleted = false];// Where Id in :TierIdUpdate];
                
                for(Premier_Tier__c mpTier :toptierActive.values()){
                    for(Premier_Tier__c aTiers: allTiers){
                        if(aTiers.Hierarchy_Action__c == 'Top_Tier' && aTiers.Id != mpTier.Id){
                            aTiers.Hierarchy_Selection__c = mpTier.Id;
                            aTiers.Hierarchy_Action__c = '<';
                            aTiers.Bypass_Validation__c = True;
                            TierTopToUpdate.add(aTiers);
                            
                        }
                    }
                    
                }
                if(!TierTopToUpdate.isEmpty()){
                    system.debug('TierTopToUpdate List '+ TierTopToUpdate);
                    update TierTopToUpdate;
                    
                    for(Premier_Tier__c bypass :TierTopToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierTopByPassToUpdate.add(bypass);
                    }
                    if(!TierTopByPassToUpdate.isEmpty()){
                        system.debug('TierTopByPassToUpdate List '+ TierTopByPassToUpdate);
                        update TierTopByPassToUpdate;
                        
                        VSP_Tier_Hierarchy_Order_Delete(TierTopToUpdate);
                    }
                }
                else{
                    VSP_Tier_Hierarchy_Order();
                }
            }
            
            ////Inactive Top Tier
            if(!toptierInactive.isEmpty()){
                
                List<Premier_Tier__c> TierTopInactiveToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierTopByPassInactiveToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' AND IsDeleted = false];// Where Id in :TierIdUpdate];
                
                
                for(Premier_Tier__c mpTier :toptierInactive.values()){
                    for(Premier_Tier__c aTiers: allTiers){
                        if(aTiers.Hierarchy_Selection__c == mpTier.Id){
                            aTiers.Hierarchy_Selection__c = NULL;
                            aTiers.Hierarchy_Action__c = 'Top_Tier';
                            aTiers.Bypass_Validation__c = True;
                            TierTopInactiveToUpdate.add(aTiers);
                            
                        }
                    }
                    
                }
                
                if(!TierTopInactiveToUpdate.isEmpty()){
                    system.debug('TierTopInactiveToUpdate List '+ TierTopInactiveToUpdate);
                    update TierTopInactiveToUpdate;
                    
                    for(Premier_Tier__c bypass :TierTopInactiveToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierTopByPassInactiveToUpdate.add(bypass);
                    }
                    if(!TierTopByPassInactiveToUpdate.isEmpty()){
                        system.debug('TierTopByPassInactiveToUpdate List '+ TierTopByPassInactiveToUpdate);
                        update TierTopByPassInactiveToUpdate;
                        
                        VSP_Tier_Hierarchy_Order_Delete(TierTopInactiveToUpdate);
                    }
                }
                else{
                    VSP_Tier_Hierarchy_Order();
                }
            }
            
        }
    }
    
    public static boolean VSP_Tier_Hierarchy_Delete_recursion = true;
    public void VSP_Tier_Hierarchy_Delete(List<Premier_Tier__c> newTrigger, Map<Id,Premier_Tier__c> oldRecs){
        
        if(VSP_Tier_Hierarchy_Delete_recursion){
            VSP_Tier_Hierarchy_Delete_recursion = false;
            
            
            system.debug('*****entered VSP_Tier_Hierarchy_Delete ****');
            //      Map<Id,Premier_Tier__c> tierDeleteActive = new Map<Id, Premier_Tier__c>();
            Set<Id> tierDeleteActive = new Set<Id>(); 
            Map<Id,Premier_Tier__c> toptierDeleteActive = new Map<Id, Premier_Tier__c>();
            
            
            for(Premier_Tier__c nT: newTrigger){
                system.debug('***** oldRecs ***** ' + oldRecs);
                system.debug('***** newTrigger ***** ' + newTrigger);
                
                if(nT.Status__c == 'Active' && nT.Hierarchy_Selection__c != null){
                    //      tierDeleteActive.put(nT.Id, nT);
                    tierDeleteActive.add(nT.Id);
                }
                else if (nT.Status__c == 'Active' && nT.Hierarchy_Action__c == 'Top_Tier'){
                    // toptierDeleteActive.put(nT.Id, nT);
                    tierDeleteActive.add(nT.Id);
                }
            }
            
            if(!tierDeleteActive.isEmpty()){
                system.debug('***** tierDeleteActive ***** ' + tierDeleteActive);
                List<Premier_Tier__c> TierDelActToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierDelActByPassToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Status__c FROM Premier_Tier__c WHERE Id in :tierDeleteActive];// Where Id in :TierIdUpdate];
                
                
                for(Premier_Tier__c delTier: allTiers){
                    delTier.Status__c = 'Inactive';
                    delTier.Bypass_Validation__c = True;
                    TierDelActToUpdate.add(delTier);
                }
                
                if(!TierDelActToUpdate.isEmpty()){
                    system.debug('TierDelActToUpdate List '+ TierDelActToUpdate);
                    update TierDelActToUpdate;
                    
                    for(Premier_Tier__c bypass :TierDelActToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierDelActByPassToUpdate.add(bypass);
                    }
                    if(!TierDelActByPassToUpdate.isEmpty()){
                        system.debug('TierDelActByPassToUpdate List '+ TierDelActByPassToUpdate);
                        update TierDelActByPassToUpdate;
                    }
                }
                
                
            }///endtierDeleteActive_isEmpty if
            
        }
    }
    
    public static boolean VSP_Tier_Hierarchy_Order_recursion = true;
    public static void VSP_Tier_Hierarchy_Order(){
        
        if(VSP_Tier_Hierarchy_Order_recursion){
            VSP_Tier_Hierarchy_Order_recursion = false;
            
            
            system.debug('*****entered VSP_Tier_Hierarchy_Order ****');
            List<Premier_Tier__c> TierOrderToUpdate = new List<Premier_Tier__c>();
            List<Premier_Tier__c> TierByPassToUpdate = new List<Premier_Tier__c>();
            List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Hierarchy_Action__c DESC];
            Map<Integer,Id> tierOrder = new Map<Integer, Id>();
            Integer tierNumber = allTiers.size();
            Integer count = 1;
            Id parentId;
            
            while(count <= tierNumber){
                for(Premier_Tier__c aTier :allTiers){
                    if( aTier.Hierarchy_Action__c == 'Top_Tier' && parentId == null){
                        tierOrder.put(count,aTier.Id);
                        parentId = aTier.Id;
                        count++;
                    }
                    else if(parentId == aTier.Hierarchy_Selection__c){
                        tierOrder.put(count,aTier.Id);
                        parentId = aTier.Id;
                        count++;
                    }
                    else{
                        continue;
                    }
                    system.debug('parentId ' + parentId);
                    system.debug('count ' + count);
                    system.debug('tierNumber ' + tierNumber);
                }
            }
            parentId = null;
            system.debug('tierOrder ' + tierOrder);
            for(Premier_Tier__c aTiers: allTiers){
                for(Integer ord :tierOrder.keySet()){
                    //            for(Premier_Tier__c mapOrder :tierOrder.values()){
                    
                    if(tierOrder.get(ord) == aTiers.Id){ //&& (mapOrder.Order__c != aTiers.Order__c || aTiers.Order__c == Null)){
                        aTiers.Order__c = ord;
                        aTiers.Bypass_Validation__c = True;
                        TierOrderToUpdate.add(aTiers);
                    }
                    //               }
                }
            }///end for
            
            if(!TierOrderToUpdate.isEmpty()){
                system.debug('TierOrderToUpdate List '+ TierOrderToUpdate);
                update TierOrderToUpdate;
                
                for(Premier_Tier__c bypass :TierOrderToUpdate){
                    bypass.Bypass_Validation__c = false;
                    TierByPassToUpdate.add(bypass);
                }
                if(!TierByPassToUpdate.isEmpty()){
                    system.debug('TierByPassToUpdate List '+ TierByPassToUpdate);
                    update TierByPassToUpdate;
                }
            }
        }
    }
    
    public static boolean VSP_Tier_Hierarchy_Order_Delete_recursion = true;
    public void VSP_Tier_Hierarchy_Order_Delete(List<Premier_Tier__c> newTrigger){////Used to pass in list
        
        if(VSP_Tier_Hierarchy_Order_Delete_recursion){
            VSP_Tier_Hierarchy_Order_Delete_recursion = false;
            system.debug('*****entered VSP_Tier_Hierarchy_Order ****');
            Set<Id> tierDeleteActive = new Set<Id>(); 
            Map<Id,Premier_Tier__c> mapTier = new Map<Id, Premier_Tier__c>();
            for(Premier_Tier__c nT: newTrigger){
                
                system.debug('***** newTrigger ***** ' + newTrigger);
                
                if(nT.Status__c == 'Active' && nT.Hierarchy_Selection__c != null){
                    tierDeleteActive.add(nT.Id);
                    mapTier.put(nT.Id,nT);
                }
                else if (nT.Status__c == 'Active' && nT.Hierarchy_Action__c == 'Top_Tier'){
                    tierDeleteActive.add(nT.Id);
                    mapTier.put(nT.Id,nT);
                }
            }
            
            if(!tierDeleteActive.isEmpty()){
                List<Premier_Tier__c> TierOrderToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> TierByPassToUpdate = new List<Premier_Tier__c>();
                List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Status__c FROM Premier_Tier__c WHERE Status__c = 'Active' // Order By Hierarchy_Action__c DESC];
                                                  AND Id not in :tierDeleteActive Order By Hierarchy_Action__c DESC];
                Map<Integer,Id> tierOrder = new Map<Integer, Id>();
                allTiers.addall(mapTier.values());
                Integer tierNumber = allTiers.size();
                Integer count = 1;
                Id parentId;
                system.debug('***** allTiers ***** ' + allTiers);
                while(count < tierNumber){
                    for(Premier_Tier__c aTier :allTiers){
                        if( aTier.Hierarchy_Action__c == 'Top_Tier' && parentId == null){
                            tierOrder.put(count,aTier.Id);
                            parentId = aTier.Id;
                            count++;
                        }
                        else if(parentId == aTier.Hierarchy_Selection__c){
                            tierOrder.put(count,aTier.Id);
                            parentId = aTier.Id;
                            count++;
                        }
                        
                        system.debug('parentId ' + parentId);
                        system.debug('count ' + count);
                    }
                }
                system.debug('tierOrder ' + tierOrder);
                for(Premier_Tier__c aTiers: allTiers){
                    for(Integer ord :tierOrder.keySet()){
                        //            for(Premier_Tier__c mapOrder :tierOrder.values()){
                        
                        if(tierOrder.get(ord) == aTiers.Id){ //&& (mapOrder.Order__c != aTiers.Order__c || aTiers.Order__c == Null)){
                            aTiers.Order__c = ord;
                            aTiers.Bypass_Validation__c = True;
                            TierOrderToUpdate.add(aTiers);
                        }
                        //               }
                    }
                }///end for
                
                if(!TierOrderToUpdate.isEmpty()){
                    system.debug('TierOrderToUpdate List '+ TierOrderToUpdate);
                    update TierOrderToUpdate;
                    
                    for(Premier_Tier__c bypass :TierOrderToUpdate){
                        bypass.Bypass_Validation__c = false;
                        TierByPassToUpdate.add(bypass);
                    }
                    if(!TierByPassToUpdate.isEmpty()){
                        system.debug('TierByPassToUpdate List '+ TierByPassToUpdate);
                        update TierByPassToUpdate;
                    }
                }
            }
        }
    }
    
}