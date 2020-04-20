global class VSPR31_Premier_Tier_Update_Batch implements Database.Batchable<sObject>, Database.Stateful {
    
    //  global final String query = 'SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c WHERE IsDeleted = false';
    global List<String> exception_List_Tier_Upd = new List<String>();
    global List<String> exceptionList = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Effective_Date__c, End_Date__c, Status__c FROM Premier_Tier__c WHERE Status__c != 'Inactive' AND IsDeleted = false]);
    }
    
    global void execute(Database.BatchableContext BC, List<Premier_Tier__c> scope){
        VSPUtility.stopPremierTrigger = true;
        Map<Id, Premier_Tier__c> Tiers = new Map<Id, Premier_Tier__c>();
        
        for(Premier_Tier__c s: scope){
            Tiers.put(s.Id, s.clone(true, true, false, false));
        }
        
        if(Tiers.size() > 0){
            List<Premier_Tier__c> TierToUpdate = new List<Premier_Tier__c>();
            
            for(Premier_Tier__c tr: scope){
                if(tr.Effective_Date__c > Date.today()){
                    tr.Status__c = 'Future';                    
                }
                else if(tr.Effective_Date__c <= Date.today() && (tr.End_Date__c >= Date.today() || tr.End_Date__c == NULL)){
                    tr.Status__c = 'Active';
                }
                else{
                    tr.Status__c = 'Inactive';
                }
                //Added this so that only status of tiers which are actually updated get added to the list to be updated.
                if(tr.Status__c != Tiers.get(tr.Id).Status__c){
                    TierToUpdate.add(tr);
                }
            }
            
            if(!TierToUpdate.isEmpty()){
                // update TierToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(TierToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Premier Tier Record Id: ' + TierToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"<br/>';
                        } 
                    }
                    if(msg!= '')
                        exception_List_Tier_Upd.add(msg);
                } 
            }
        }
        
        
        /////Update Tier Order
        //
        //
        List<Premier_Tier__c> TierOrderToUpdate = new List<Premier_Tier__c>();
        List<Premier_Tier__c> TierOrderToUpdateParent = new List<Premier_Tier__c>();
        List<Premier_Tier__c> TierOrderToUpdateByPass = new List<Premier_Tier__c>();
        List<Premier_Tier__c> allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Status__c, Hierarchy_Selection__r.Status__c, Hierarchy_Selection__r.Hierarchy_Selection__c FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Hierarchy_Action__c DESC, Order__c ASC, CreatedDate DESC];
        Map<Integer,Id> tierOrder = new Map<Integer, Id>();
        Integer tierNumber = allTiers.size();
        Integer count = 1;
        Id parentId;
        Map<String,Premier_Tier__c> tierMap = new Map<String, Premier_Tier__c>();
        Premier_Tier__c nxTier = new Premier_Tier__c();
        
        /////Moving tiers parent if multiple exist///
        for(Premier_Tier__c tMap :allTiers){
            if(tMap.Hierarchy_Selection__c !=null){
                if(tMap.Hierarchy_Selection__r.Status__c == 'Active'){
                    if(tierMap.containsKey(tMap.Hierarchy_Selection__c)){
                        Premier_Tier__c newParTier = tierMap.get(tMap.Hierarchy_Selection__c);
                        tMap.Hierarchy_Selection__c = newParTier.Id;
                        TierOrderToUpdateParent.add(tMap);
                    }
                    else{
                        tierMap.put(tMap.Hierarchy_Selection__c, tMap);
                    }
                }
                else{
                    tMap.Hierarchy_Selection__c = tMap.Hierarchy_Selection__r.Hierarchy_Selection__c;
                    TierOrderToUpdateParent.add(tMap);
                }
                
            }
            else{
                if(tierMap.containsKey('Top Tier')){
                    Premier_Tier__c newParTier = tierMap.get('Top Tier');
                    tMap.Hierarchy_Selection__c = newParTier.Id;
                    tMap.Hierarchy_Action__c = '<';
                    TierOrderToUpdateParent.add(tMap);
                }
                else{
                    tierMap.put('Top Tier', tMap);
                }
            }
        }
        
        
        
        
        if(!TierOrderToUpdateParent.isEmpty()){
            // update TierToUpdate;
            tierMap.clear();
            Database.SaveResult[] SaveResultList = Database.update(TierOrderToUpdateParent,false); 
            
            for(integer i =0; i<SaveResultList.size();i++){
                String msg='';
                If(!SaveResultList[i].isSuccess()){
                    
                    msg += 'Premier Tier Record Id: ' + TierOrderToUpdateParent.get(i).id + '\n'+'Error: "';        
                    for(Database.Error err: SaveResultList[i].getErrors()){  
                        msg += err.getmessage()+'"<br/>';
                    } 
                }
                if(msg!= '')
                    exception_List_Tier_Upd.add(msg);
            }
            
            allTiers = [SELECT Id, Hierarchy_Action__c, Hierarchy_Selection__c, Order__c, Status__c, Hierarchy_Selection__r.Status__c, Hierarchy_Selection__r.Hierarchy_Selection__c FROM Premier_Tier__c WHERE Status__c = 'Active' Order By Hierarchy_Action__c DESC, Order__c ASC, CreatedDate DESC];
            for(Premier_Tier__c tMap :allTiers){
                if(tMap.Hierarchy_Selection__c !=null){
                    tierMap.put(tMap.Hierarchy_Selection__c, tMap); 
                }
            }
        }
        
        
        //    while(count <= tierNumber){
        for(Premier_Tier__c aTier :allTiers){
            if( aTier.Hierarchy_Action__c == 'Top_Tier' && parentId == null){
                aTier.Order__c = count;
                aTier.Bypass_Validation__c = true;
                TierOrderToUpdate.add(aTier);
                // tierOrder.put(count,aTier.Id);
                parentId = aTier.Id;
                count++;
            }
            else if(aTier.Hierarchy_Action__c != 'Top_Tier' && parentId == null){
                aTier.Order__c = count;
                aTier.Bypass_Validation__c = true;
                aTier.Hierarchy_Action__c = 'Top_Tier';
                aTier.Hierarchy_Selection__c = null;
                TierOrderToUpdate.add(aTier);
                // tierOrder.put(count,aTier.Id);
                parentId = aTier.Id;
                count++;
            }
            else if(tierMap.get(parentId) != null){
                
                nxTier = tierMap.get(parentId);
                nxTier.Order__c = count;
                nxTier.Bypass_Validation__c = true;
                // tierOrder.put(count,nxTier.Id);
                TierOrderToUpdate.add(nxTier);
                parentId = nxTier.Id;
                count++;
            }
            else{
                continue;
            }
        }
        //     }
        parentId = null;
        
        if(!TierOrderToUpdate.isEmpty()){
            // update TierToUpdate;
            
            Database.SaveResult[] SaveResultList = Database.update(TierOrderToUpdate,false); 
            
            for(integer i =0; i<SaveResultList.size();i++){
                String msg='';
                If(!SaveResultList[i].isSuccess()){
                    
                    msg += 'Premier Tier Record Id: ' + TierOrderToUpdate.get(i).id + '\n'+'Error: "';        
                    for(Database.Error err: SaveResultList[i].getErrors()){  
                        msg += err.getmessage()+'"<br/>';
                    } 
                }
                if(msg!= '')
                    exception_List_Tier_Upd.add(msg);
            }
            
            for(Premier_Tier__c byPass :TierOrderToUpdate){
                byPass.Bypass_Validation__c = false;
                TierOrderToUpdateByPass.add(byPass);
            }
            
            if(!TierOrderToUpdateByPass.isEmpty()){
                // update TierToUpdate;
                
                SaveResultList = Database.update(TierOrderToUpdateByPass,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Premier Tier Record Id: ' + TierOrderToUpdateByPass.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"<br/>';
                        } 
                    }
                    if(msg!= '')
                        exception_List_Tier_Upd.add(msg);
                }
            }
            
        }
        
        
    }
    
    global void finish(Database.BatchableContext BC){
        
        //Added Test.isRunningTest() to allow to run the part when test is running        
        if(!exception_List_Tier_Upd.isEmpty() || Test.isRunningTest()){          
            
            String[] toAddresses = new String[]{};
                
                for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
                    toAddresses.add(obj.Name);
                }
            
            if(!toAddresses.isEmpty()){
                Messaging.reserveSingleEmailCapacity(2);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                
                mail.setToAddresses(toAddresses);
                
                mail.setSenderDisplayName('Salesforce Support');
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Tier Status Update Failed');
                
                mail.setBccSender(false);
                
                mail.setUseSignature(false);
                
                // Specify the text content of the email.
                mail.setPlainTextBody('Number of records failed = ' + exception_List_Tier_Upd.size());
                
                mail.setHtmlBody('Number of records failed = ' + exception_List_Tier_Upd.size() + '<br><br>' + exception_List_Tier_Upd + '<br><br>');
                
                // Send the email you have created.
                if(!Test.isRunningTest()){
                    Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
                }
            }
            
        }
        
        
        if(!Test.isRunningTest()){
            VSPR33c_Bus_Acc_Daily_Tier_Batch batch = new VSPR33c_Bus_Acc_Daily_Tier_Batch();
            database.executeBatch(batch,100);
        }
    }
}