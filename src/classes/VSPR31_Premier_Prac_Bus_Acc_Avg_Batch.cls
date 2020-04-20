global class VSPR31_Premier_Prac_Bus_Acc_Avg_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    global final String Query;
    
    global List<String> exception_List = new List<String>();
    private static Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private Set<Id> pAccIdSet = new Set<Id>();
    
    global VSPR31_Premier_Prac_Bus_Acc_Avg_Batch(Set<Id> prAccId){
        pAccIdSet = prAccId;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Tax_ID__c, Premier_Tax_ID_Roll_Up_Account__c, Tier_Agreement_Type__c 
                                         FROM Account
                                         WHERE Id IN :pAccIdSet]);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
        
        VSPUtility.stopAccountTrigger=true;
        
        Map<Id,Account> pracAccSetSameContractType = new Map<Id,Account>();
        for(Account s : scope){
            pracAccSetSameContractType.put(s.Id,s);
        }
        
        
        
        
        ////Premier 1.0/////
        if(!pracAccSetSameContractType.isEmpty()){ 
            List<Global_Rewards_Group_Relationship__c> grgRLstUpd = new List<Global_Rewards_Group_Relationship__c>();
            List<Account> pracAccToUpdate = new List<Account>();
            
            Map<Id,List<Decimal>> busAccTotalPurchasesMap = new Map<Id,List<Decimal>>();
            Map<Id,List<Decimal>> busAccFramePurchasesMap = new Map<Id,List<Decimal>>();
            Map<Id,List<Decimal>> busAccLensPurchasesMap = new Map<Id,List<Decimal>>();
            ///////////////if contract type is all the same//////////////
            //
            //
            
            
            /*    List<Account> busAccCTquery = [Select Id, Name, Contract_Type__c, ParentId FROM Account Where ParentId in :pracAccSetSameContractType AND
Vision_Care_Good_Standing__c = True AND Status__c = 'A' AND
Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
RecordTypeId = :accBusRecordTypeId AND Contract_Type__c != NULL];*/
            
            List<Global_Rewards_Group_Relationship__c> existBusGrpRelation = [SELECT Active__c, Child_Account__c, Global_Rewards_Group__c, Global_Rewards_Group__r.Name, Start_Date__c, 
                                                                              End_Date__c, Global_Rewards_Group__r.RecordTypeId, Child_Account__r.ParentId
                                                                              FROM Global_Rewards_Group_Relationship__c WHERE Child_Account__r.ParentId IN :pracAccSetSameContractType.keySet() AND End_Date__c = NULL];
            
            List<Account> allBusAccAvg = [SELECT ParentId, Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c, Contract_Type__c 
                                          FROM Account 
                                          WHERE (ParentId in :pracAccSetSameContractType.keySet() 
                                                 AND Vision_Care_Good_Standing__c = True AND VC__c = True
                                                 AND RecordTypeId = :accBusRecordTypeId)
                                          OR
                                          (ParentId in :pracAccSetSameContractType.keySet()
                                           AND RecordTypeId = :accBusRecordTypeId
                                           AND Non_VC_Exception__c = True)];
            
            
            AggregateResult[] busActiveAccCount =  [SELECT ParentId, Count(Id) Total 
                                                    FROM Account 
                                                    Where ParentId in :pracAccSetSameContractType.keySet() 
                                                    AND Vision_Care_Good_Standing__c = True AND VC__c = True
                                                    //   AND Status__c = 'A' 
                                                    //  AND Vision_Care_Effective_Date__c <= TODAY 
                                                    //  AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) 
                                                    AND Contract_Type__c != NULL AND
                                                    RecordTypeId = :accBusRecordTypeId
                                                    Group By ParentId];
            
            //below part commented out by Vikhyat as part of SFDC-10005
            /*AggregateResult[] busAccRetinalImgCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType.keySet() AND
                                                        Vision_Care_Good_Standing__c = True AND VC__c = True AND
                                                        //Status__c = 'A' AND
                                                        //Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
                                                        Service_Offering_s__c includes ('RTLIM - Retinal Imaging') AND
                                                        RecordTypeId = :accBusRecordTypeId
                                                        Group By ParentId];*/
            
			//FFAA - Free Fitting and Adjustments is no longer a value in Service Offering (s) field
            //Commented by TonyKh as part of SFDC-12851
            /*AggregateResult[] busAccFreeFittingCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType.keySet() AND
                                                         Vision_Care_Good_Standing__c = True AND VC__c = True AND
                                                         // Status__c = 'A' AND
                                                         // Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
                                                         Service_Offering_s__c includes ('FFAA - Free Fitting and Adjustments') AND
                                                         RecordTypeId = :accBusRecordTypeId
                                                         Group By ParentId];*/
            
            //Commented by Vikhyat as part of SFDC-13052
            /*AggregateResult[] busAccNODISCount =  [SELECT ParentId, Count(Id) Total FROM Account Where ParentId in :pracAccSetSameContractType.keySet() AND
                                                   Vision_Care_Good_Standing__c = True AND VC__c = True AND
                                                   //Status__c = 'A' AND
                                                   //Vision_Care_Effective_Date__c <= TODAY AND (Vision_Care_End_Date__c >= TODAY OR Vision_Care_End_Date__c = null) AND
                                                   Participation_Exclusions__c includes ('NODIS – Opts out of discounts')  AND
                                                   RecordTypeId = :accBusRecordTypeId
                                                   Group By ParentId];*/      
            
            
            
            for(Id pAccId: pracAccSetSameContractType.keySet()){
                Account pAcc = pracAccSetSameContractType.get(pAccId);
                System.debug('pAcc for loop '+ pAcc.Id);
                pAcc.Premier_Location_Count_Future__c = 0;
                pAcc.Total_Average_Purchases_LTM_Calculated__c = 0;
                pAcc.Average_Frame_Purchases_LTM_Calculated__c = 0;
                pAcc.Average_Lens_Purchases_LTM_Calculated__c = 0;
                //below part commented out by Vikhyat as part of SFDC-10005
                //pAcc.Retinal_Imaging_Indicator__c = false;
                
                //Commented out by Vikhyat as part of SFDC-13052
                /*pAcc.Exclusive_VSP_Patient_Offers__c = true;
                pAcc.Free_Fitting_and_Adjustments__c = true;*/
                
                //   pAcc.Contract_Type__c = null; //For Contract Type of a Practice Account
                
                for(AggregateResult ar : busActiveAccCount){
                    if(ar.get('ParentId') == pAcc.Id){                   
                        pAcc.Premier_Location_Count_Future__c = ((decimal)ar.get('Total'));
                        //       pAcc.Total_Average_Purchases_LTM_Calculated__c = ((decimal)ar.get('Total_Average_Purchases_LTM')); 
                        //      pAcc.Average_Frame_Purchases_LTM_Calculated__c = ((decimal)ar.get('Average_Frame_Purchases_LTM__c'));
                        //     pAcc.Average_Lens_Purchases_LTM_Calculated__c = ((decimal)ar.get('Average_Lens_Purchases_LTM__c')); 
                    }
                }//end Aggregate For Loop
                
                //below part commented out by Vikhyat as part of SFDC-10005
                /*for(AggregateResult ar1 :busAccRetinalImgCount){
                    if(ar1.get('ParentId') == pAcc.Id){
                        pAcc.Retinal_Imaging_Indicator__c = true;
                    }
                }*///end Aggregate1 For Loop
                

                //Commented out by Vikhyat as part of SFDC-13052
                /*for(AggregateResult ar2 :busAccNODISCount){
                    if(ar2.get('ParentId') == pAcc.Id){
                        pAcc.Exclusive_VSP_Patient_Offers__c = false;
                    }
                }*///end Aggregate2 For Loop
                
                //Commented by TonyKh as part of SFDC-12851
                /*for(AggregateResult ar3 :busAccFreeFittingCount){
                    if(ar3.get('ParentId') == pAcc.Id){
                        pAcc.Free_Fitting_and_Adjustments__c = false;
                    }
                }//end Aggregate3 For Loop*/
                
                /*          for(Account busAccCT : busAccCTquery){ //Set Contract Type of a Practice Account
if(busAccCT.ParentId == pAcc.Id){

pAcc.Contract_Type__c = busAccCT.Contract_Type__c;
break;

}
}*///end Contract Type Update
                
                
                /////end any Business Account Group Reward Relationships that are still active////
                for(Global_Rewards_Group_Relationship__c grgR :existBusGrpRelation){
                    if(grgR.Child_Account__r.ParentId == pAcc.Id){
                        grgR.End_Date__c = Date.today();
                        grgRLstUpd.add(grgR);
                    }
                }
                
                //////Calculate the Avg for Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Lens_Purchases_LTM__c
                for(Account busAccAvg :allBusAccAvg){
                    if(busAccAvg.ParentId == pAcc.Id){
                        if(busAccTotalPurchasesMap.containsKey(busAccAvg.ParentId)){
                            List<Decimal> existingvalue = busAccTotalPurchasesMap.get(busAccAvg.ParentId);
                            if(busAccAvg.Total_Location_Spend_LTM__c != null){
                                existingvalue.add(busAccAvg.Total_Location_Spend_LTM__c);
                                busAccTotalPurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                            else{
                                existingvalue.add(0);
                                busAccTotalPurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                        } 
                        else{
                            if(busAccAvg.Total_Location_Spend_LTM__c != null){
                                busAccTotalPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Total_Location_Spend_LTM__c});
                            }
                            else{
                                busAccTotalPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
                            }
                        }
                        
                        if(busAccFramePurchasesMap.containsKey(busAccAvg.ParentId)){
                            List<Decimal> existingvalue = busAccFramePurchasesMap.get(busAccAvg.ParentId);
                            if(busAccAvg.Eyewear_Location_Spend_LTM__c != null){
                                existingvalue.add(busAccAvg.Eyewear_Location_Spend_LTM__c);
                                busAccFramePurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                            else{
                                existingvalue.add(0);
                                busAccFramePurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                        }
                        else{
                            if(busAccAvg.Eyewear_Location_Spend_LTM__c != null){
                                busAccFramePurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Eyewear_Location_Spend_LTM__c});
                            }
                            else{
                                busAccFramePurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
                            }
                        }
                        
                        if(busAccLensPurchasesMap.containsKey(busAccAvg.ParentId)){
                            List<Decimal> existingvalue = busAccLensPurchasesMap.get(busAccAvg.ParentId);
                            if(busAccAvg.Optics_Location_Spend_LTM__c != null){
                                existingvalue.add(busAccAvg.Optics_Location_Spend_LTM__c);
                                busAccLensPurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                            else{
                                existingvalue.add(0);
                                busAccLensPurchasesMap.put(busAccAvg.ParentId, existingvalue);
                            }
                        }
                        else{
                            if(busAccAvg.Optics_Location_Spend_LTM__c != null){
                                busAccLensPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{busAccAvg.Optics_Location_Spend_LTM__c});
                            }
                            else{
                                busAccLensPurchasesMap.put(busAccAvg.ParentId, new List<Decimal>{0});
                            }
                        }
                        
                    }                    
                }//////finish for loop Avg Calc
                
                if(!busAccTotalPurchasesMap.isEmpty()){
                    for(Id key :busAccTotalPurchasesMap.keySet()){
                        if(pAcc.Id == key){
                            Decimal total = 0;
                            Double tPAvg = 0;
                            Decimal[] totalPurchase = busAccTotalPurchasesMap.get(key);
                            
                            for(Decimal d :totalPurchase){
                                total += d;
                            }
                            if(pAcc.Premier_Location_Count_Future__c != 0){
                                tPAvg = Double.valueOf(total) / pAcc.Premier_Location_Count_Future__c;
                            }                                
                            pAcc.Total_Average_Purchases_LTM_Calculated__c = tPAvg; 
                        }
                    }
                }
                if(!busAccFramePurchasesMap.isEmpty()){
                    for(Id key :busAccFramePurchasesMap.keySet()){
                        if(pAcc.Id == key){
                            Decimal total = 0;
                            Double fPAvg = 0;
                            Decimal[] framePurchase = busAccFramePurchasesMap.get(key);
                            
                            for(Decimal d :framePurchase){
                                total += d;
                            }
                            if(pAcc.Premier_Location_Count_Future__c != 0){
                                fPAvg = Double.valueOf(total) / pAcc.Premier_Location_Count_Future__c;
                            }                                
                            pAcc.Average_Frame_Purchases_LTM_Calculated__c = fPAvg; 
                        }
                    }
                }
                
                if(!busAccLensPurchasesMap.isEmpty()){
                    for(Id key :busAccLensPurchasesMap.keySet()){
                        if(pAcc.Id == key){
                            Decimal total = 0;
                            Double lPAvg = 0;
                            Decimal[] lensPurchase = busAccLensPurchasesMap.get(key);
                            
                            for(Decimal d :lensPurchase){
                                total += d;
                            }
                            if(pAcc.Premier_Location_Count_Future__c != 0){
                                lPAvg = Double.valueOf(total) / pAcc.Premier_Location_Count_Future__c;
                            }                                
                            pAcc.Average_Lens_Purchases_LTM_Calculated__c = lPAvg; 
                        }
                    }
                }
                
                pracAccToUpdate.add(pAcc);
            }
            
            system.debug('pracAccToUpdate List '+ pracAccToUpdate);
            if(!pracAccToUpdate.isEmpty()){
                //  update pracAccToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(pracAccToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Account Record Id: ' + pracAccToUpdate.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
            
            system.debug('grgRLstUpd List '+ grgRLstUpd);
            if(!grgRLstUpd.isEmpty()){
                //  update grgRLstUpd;
                
                Database.SaveResult[] SaveResultList = Database.update(grgRLstUpd,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Account Record Id: ' + grgRLstUpd.get(i).id + '\n'+'Error: "';        
                        for(Database.Error err: SaveResultList[i].getErrors()){  
                            msg += err.getmessage()+'"\n\n';
                        } 
                    }
                    if(msg!= '')
                        exception_List.add(msg);
                } 
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        
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
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Practice Update Failed');
                
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
        
        if(!Test.isRunningTest()){
            VSPR31_Grg_Path_To_Premier_Batch obj = new VSPR31_Grg_Path_To_Premier_Batch();
            Database.executeBatch(obj, 100);
        }
    }
}