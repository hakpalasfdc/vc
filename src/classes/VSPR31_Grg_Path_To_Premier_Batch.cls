global class VSPR31_Grg_Path_To_Premier_Batch implements Database.Batchable<sObject>, Database.Stateful{
    
    
    global final String query = 'SELECT Id, RecordType.Name, Contract_Type__c FROM Global_Rewards_Group__c WHERE IsDeleted = false AND Status__c != \'Inactive\''; 
    
    global List<String> exception_List = new List<String>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    //below part updated to make it List<Global_Rewards_Group__c>
    global void execute(Database.BatchableContext BC, /*List<sObject>*/ List<Global_Rewards_Group__c> scope){
        
        Set<Id> grpAccSet = new set<Id>();
        
        Map<Id,Global_Rewards_Group__c> grpAccSetMap = new Map<Id,Global_Rewards_Group__c>();
        Map<Id, Set<String>> taxIDGrpMap = new Map<Id, Set<String>>();
        
        //Below code commented out by Vikhyat on 08/12/2019
        /*for(sobject s : scope){
Global_Rewards_Group__c T = (Global_Rewards_Group__c)s;
grpAccSet.add(T.Id);
grpAccSetMap.put(T.Id,T);
}*/
        //Commented out part by Vikhyat ends here.
        for(Global_Rewards_Group__c s : scope){
            grpAccSet.add(s.Id);
            grpAccSetMap.put(s.Id,s);
        }
        //Below part added by Vikhyat
        
        if(!grpAccSet.isEmpty()){
            List<Global_Rewards_Group__c> grgToUpdate = new List<Global_Rewards_Group__c>();
            Map<Id,List<Decimal>> busAccTotalPurchasesMap = new Map<Id,List<Decimal>>();
            Map<Id,List<Decimal>> busAccFramePurchasesMap = new Map<Id,List<Decimal>>();
            Map<Id,List<Decimal>> busAccLensPurchasesMap = new Map<Id,List<Decimal>>();
            
            Map<Id, Set<Id>> actvCountMap = new Map<Id,Set<Id>>();
            
            Map<Id, Set<Id>> avgGRGMap = new Map<Id,Set<Id>>();
            Map<Id, Account> accMap = new Map<Id,Account>();
            
            //  Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
            Id accBusRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
            
            
            List<Global_Rewards_Group_Relationship__c> allBusAccAvg1 = [SELECT Child_Account__r.Total_Location_Spend_LTM__c, Child_Account__r.Eyewear_Location_Spend_LTM__c, Child_Account__r.Optics_Location_Spend_LTM__c, 
                                                                        Active__c, Child_Account__c, End_Date__c, Global_Rewards_Group__c, 
                                                                        Start_Date__c
                                                                        FROM Global_Rewards_Group_Relationship__c 
                                                                        WHERE (Global_Rewards_Group__c IN :grpAccSet
                                                                               AND Child_Account__r.RecordTypeId = :accBusRecordTypeId 
                                                                               AND Child_Account__r.Vision_Care_Good_Standing__c = True AND Child_Account__r.VC__c = True
                                                                               AND Status__c = 'Active') 
                                                                        OR
                                                                        (Global_Rewards_Group__c IN :grpAccSet 
                                                                         AND Child_Account__r.RecordTypeId = :accBusRecordTypeId 
                                                                         AND Child_Account__r.Non_VC_Exception__c = True
                                                                         AND Status__c = 'Active')];  
            
            for(Global_Rewards_Group_Relationship__c grgr :allBusAccAvg1){
                
                if(avgGRGMap.containsKey(grgr.Global_Rewards_Group__c)){
                    Set<Id> existGRGR = avgGRGMap.get(grgr.Global_Rewards_Group__c);
                    existGRGR.add(grgr.Child_Account__c);
                    avgGRGMap.put(grgr.Global_Rewards_Group__c, existGRGR);
                }
                else{
                    avgGRGMap.put(grgr.Global_Rewards_Group__c, new Set<Id>{grgr.Child_Account__c});
                }
                
            }
            
            List<Account> allBusAccAvg  = [SELECT Id, Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c 
                                           FROM Account 
                                           WHERE ((RecordTypeId = :accBusRecordTypeId AND Vision_Care_Good_Standing__c = True AND VC__c = True) 
                                                  OR (RecordTypeId = :accBusRecordTypeId AND Non_VC_Exception__c = True))
                                           AND
                                           Id IN (SELECT Child_Account__c 
                                                  FROM Global_Rewards_Group_Relationship__c WHERE Status__c = 'Active'
                                                  AND Global_Rewards_Group__c IN :grpAccSet)];
            
            for(Account a :allBusAccAvg){                
                accMap.put(a.Id, a);
            }
            
            
            List<Global_Rewards_Group_Relationship__c> busActiveAccCount =
                /*     AggregateResult[] busActiveAccCount =  */[SELECT Global_Rewards_Group__c, Child_Account__c
                                                                 FROM Global_Rewards_Group_Relationship__c 
                                                                 WHERE Global_Rewards_Group__c IN :grpAccSet AND Status__c = 'Active' AND
                                                                 Child_Account__r.Vision_Care_Good_Standing__c = True AND Child_Account__r.VC__c = True AND 
                                                                 //Child_Account__r.Status__c = 'A' AND
                                                                 //Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                                 //(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                                 Child_Account__r.RecordTypeId = :accBusRecordTypeId]; //AND 
            //Child_Account__r.Contract_Type__c != NULL
            // Group By Global_Rewards_Group__c];
            // 
            // 
            // 
            for(Global_Rewards_Group_Relationship__c busAcc :busActiveAccCount){
                
                if(actvCountMap.containsKey(busAcc.Global_Rewards_Group__c)){
                    Set<Id> existGRGR = actvCountMap.get(busAcc.Global_Rewards_Group__c);
                    existGRGR.add(busAcc.Child_Account__c);
                }
                else{
                    actvCountMap.put(busAcc.Global_Rewards_Group__c, new Set<Id>{busAcc.Child_Account__c});
                }
            }
            
            List<Global_Rewards_Group_Relationship__c> busAccContractTypeLst = [SELECT Global_Rewards_Group__c, Child_Account__r.Contract_Type__c, Global_Rewards_Group__r.Name
                                                                                FROM Global_Rewards_Group_Relationship__c 
                                                                                WHERE Global_Rewards_Group__c IN :grpAccSet AND Status__c = 'Active' AND
                                                                                Child_Account__r.Vision_Care_Good_Standing__c = True AND Global_Rewards_Group__r.RecordType.Name = 'Tax ID Rollup' AND
                                                                                Child_Account__r.VC__c = True AND
                                                                                //Child_Account__r.Status__c = 'A' AND
                                                                                //Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                                                //(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                                                Child_Account__r.RecordTypeId = :accBusRecordTypeId];
            
            //Below aggregate query updated to include retinal image indicator rather than service offerings. Updated by Vikhyat
            //commented by vikhyat as part of SFDC-12492
            /*AggregateResult[] busAccRetinalImgCount =  [SELECT Global_Rewards_Group__c, Count(Id) Total 
                                                        FROM Global_Rewards_Group_Relationship__c 
                                                        WHERE Global_Rewards_Group__c IN :grpAccSet AND Status__c = 'Active' AND
                                                        Child_Account__r.Vision_Care_Good_Standing__c = True AND Child_Account__r.VC__c = True AND 
                                                        //Child_Account__r.Status__c = 'A' AND
                                                        //Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND 
                                                        //(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                        Child_Account__r.RecordTypeId = :accBusRecordTypeId AND 
                                                        //Child_Account__r.Contract_Type__c != NULL AND 
                                                        //Child_Account__r.Service_Offering_s__c includes ('RTLIM - Retinal Imaging')
                                                        //below code added by Vikhyat as part of SFDC-10005
                                                        Child_Account__r.Retinal_Imaging_Indicator__c = true
                                                        Group By Global_Rewards_Group__c];*/
            
            AggregateResult[] busAccNODISCount =   [SELECT Global_Rewards_Group__c, Count(Id) Total 
                                                    FROM Global_Rewards_Group_Relationship__c 
                                                    WHERE Global_Rewards_Group__c IN :grpAccSet AND Status__c = 'Active' AND
                                                    Child_Account__r.Vision_Care_Good_Standing__c = True AND Child_Account__r.VC__c = True AND
                                                    //Child_Account__r.Status__c = 'A' AND
                                                    //Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                    //(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                    Child_Account__r.RecordTypeId = :accBusRecordTypeId AND 
                                                    //Child_Account__r.Contract_Type__c != NULL AND 
                                                    Child_Account__r.Participation_Exclusions__c includes ('NODIS – Opts out of discounts')  
                                                    Group By Global_Rewards_Group__c];
            
            
            AggregateResult[] busAccFreeFittingCount =  [SELECT Global_Rewards_Group__c, Count(Id) Total 
                                                         FROM Global_Rewards_Group_Relationship__c 
                                                         WHERE Global_Rewards_Group__c IN :grpAccSet AND Status__c = 'Active' AND
                                                         Child_Account__r.Vision_Care_Good_Standing__c = True AND Child_Account__r.VC__c = True AND
                                                         //Child_Account__r.Status__c = 'A' AND
                                                         // Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
                                                         // (Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
                                                         Child_Account__r.RecordTypeId = :accBusRecordTypeId AND 
                                                         //  Child_Account__r.Contract_Type__c != NULL AND 
                                                         Child_Account__r.Service_Offering_s__c includes ('FFAA - Free Fitting and Adjustments')
                                                         Group By Global_Rewards_Group__c];
            
            
            /*    AggregateResult[] busEndDate =  [SELECT Global_Rewards_Group__c, Count(Id) Total 
FROM Global_Rewards_Group_Relationship__c 
WHERE Global_Rewards_Group__c IN :grpAccSet AND Start_Date__c <= Today AND (End_Date__c > TODAY OR End_Date__c = Null) AND
Child_Account__r.Vision_Care_Good_Standing__c = True //AND 
//Child_Account__r.Status__c = 'A' AND
//Child_Account__r.Vision_Care_Effective_Date__c <= TODAY AND
//(Child_Account__r.Vision_Care_End_Date__c >= TODAY OR Child_Account__r.Vision_Care_End_Date__c = null) AND
// Child_Account__r.RecordTypeId = :accBusRecordTypeId //AND 
//Child_Account__r.Contract_Type__c != NULL
Group By Global_Rewards_Group__c];*/
            
            
            
            
            
            Integer setSize;
            for(Id grpId: grpAccSet){
                Global_Rewards_Group__c grp = grpAccSetMap.get(grpId);
                
                //Below part commented out by Vikhyat
                //System.debug('grp for loop '+ grp.Id);
                //Commented out part by Vikhyat ends.
                
                grp.Premier_Location_Count_Future__c = 0;
                /*      if(grp.End_Date__c == null){
grp.End_Date__c = Date.today();
}*/
                grp.Average_Tiering_Total_Spend_LTM__c = 0;
                grp.Average_Tiering_Eyewear_Spend_LTM__c = 0;
                grp.Average_Tiering_Optics_Spend_LTM__c = 0;
                //commented by vikhyat as part of SFDC-12492
                //grp.Retinal_Imaging_Indicator_Future__c = false;
                grp.Exclusive_VSP_Patient_Offers__c = true;
                grp.Free_Fitting_and_Adjustments__c = true;
                
                ///for Grg Tax ID Rollup contract type
                for(Global_Rewards_Group_Relationship__c busAcc :busAccContractTypeLst){
                    if(busAcc.Global_Rewards_Group__c == grp.Id){
                        
                        if(taxIDGrpMap.containsKey(grp.Id)){
                            Set<String> existingvalue = taxIDGrpMap.get(grp.Id);
                            existingvalue.add(busAcc.Child_Account__r.Contract_Type__c);
                            taxIDGrpMap.put(grp.Id, existingvalue);
                        }
                        else{
                            taxIDGrpMap.put(grp.Id, new Set<String>{busAcc.Child_Account__r.Contract_Type__c});
                        } 
                        
                    }
                }
                
                if(taxIDGrpMap.containsKey(grp.Id)){
                    setSize = taxIDGrpMap.get(grp.Id).size();
                    
                    if(setSize == 1){
                        Set<String> valueset = taxIDGrpMap.get(grp.Id);
                        for(String contype :valueset){
                            grp.Contract_Type__c = contype;
                            break;
                        }
                    }
                    else{
                        grp.Contract_Type__c = 'Conflict';
                        grp.Applied_Tier__c = Null;
                        grp.Calculated_Tier__c = Null;
                    }                        
                }
                if(!taxIDGrpMap.containsKey(grp.Id) && grp.RecordType.Name == 'Tax ID Rollup'){
                    grp.Contract_Type__c = 'Conflict';
                    grp.Applied_Tier__c = Null;
                    grp.Calculated_Tier__c = Null;
                }
                
                
                if(grp.RecordType.Name != 'Tax ID Rollup' || grp.Contract_Type__c != 'Conflict'){
                    
                    /////Calculate Number of Eligible Locations
                    //         for(AggregateResult ar : busActiveAccCount){
                    //             if(ar.get('Global_Rewards_Group__c') == grp.Id){                   
                    //                 grp.Premier_Location_Count_Future__c = ((decimal)ar.get('Total'));
                    //             }                  
                    //         }
                    
                    if(actvCountMap.containsKey(grp.Id)){ 
                        
                        grp.Premier_Location_Count_Future__c = actvCountMap.get(grp.Id).size();
                    }
                    /////Calculate Group End Date
                    /*     for(AggregateResult ar : busEndDate){
if(ar.get('Global_Rewards_Group__c') == grp.Id){                   
grp.End_Date__c = null;
}
}*/
                    
                    /////Set Retinal Imaging Indicator
                    //commented by vikhyat as part of sfdc-12492
                    /*for(AggregateResult ar1 :busAccRetinalImgCount){
                        if(ar1.get('Global_Rewards_Group__c') == grp.Id){
                            grp.Retinal_Imaging_Indicator_Future__c = true;
                        }
                    }*/
                    
                    //////Set Exclusive VSP Patient Offers
                    for(AggregateResult ar2 :busAccNODISCount){
                        if(ar2.get('Global_Rewards_Group__c') == grp.Id){
                            grp.Exclusive_VSP_Patient_Offers__c = false;
                        }
                    }
                    
                    
                    ///Set Free Fitting and Adjustments
                    for(AggregateResult ar3 :busAccFreeFittingCount){
                        if(ar3.get('Global_Rewards_Group__c') == grp.Id){
                            grp.Free_Fitting_and_Adjustments__c = false;
                        }
                    }//end Aggregate3 For Loop
                    
                    //////Calculate the Avg for Total_Location_Spend_LTM__c, Eyewear_Location_Spend_LTM__c, Optics_Location_Spend_LTM__c
                    //
                    if(avgGRGMap.containsKey(grp.Id)){
                        for(Id accId :avgGRGMap.get(grp.Id)){
                            Account acc = accMap.get(accId);
                            if(acc != null){
                                if(busAccTotalPurchasesMap.containsKey(grp.Id)){
                                    List<Decimal> existingvalue = busAccTotalPurchasesMap.get(grp.Id);
                                    if(acc.Total_Location_Spend_LTM__c != null){
                                        existingvalue.add(acc.Total_Location_Spend_LTM__c);
                                        busAccTotalPurchasesMap.put(grp.Id, existingvalue);
                                    }
                                    else{
                                        existingvalue.add(0);
                                        busAccTotalPurchasesMap.put(grp.Id, existingvalue);
                                    }
                                } 
                                else{
                                    if(acc.Total_Location_Spend_LTM__c != null){
                                        busAccTotalPurchasesMap.put(grp.Id, new List<Decimal>{acc.Total_Location_Spend_LTM__c});
                                    }
                                    else{
                                        busAccTotalPurchasesMap.put(grp.Id, new List<Decimal>{0});
                                    }
                                }
                                
                                if(busAccFramePurchasesMap.containsKey(grp.Id)){
                                    List<Decimal> existingvalue = busAccFramePurchasesMap.get(grp.Id);
                                    if(acc.Eyewear_Location_Spend_LTM__c != null){
                                        existingvalue.add(acc.Eyewear_Location_Spend_LTM__c);
                                        busAccFramePurchasesMap.put(grp.Id, existingvalue);
                                    }
                                    else{
                                        existingvalue.add(0);
                                        busAccFramePurchasesMap.put(grp.Id, existingvalue);
                                    }
                                }
                                else{
                                    if(acc.Eyewear_Location_Spend_LTM__c != null){
                                        busAccFramePurchasesMap.put(grp.Id, new List<Decimal>{acc.Eyewear_Location_Spend_LTM__c});
                                    }
                                    else{
                                        busAccFramePurchasesMap.put(grp.Id, new List<Decimal>{0});
                                    }
                                }
                                
                                if(busAccLensPurchasesMap.containsKey(grp.Id)){
                                    List<Decimal> existingvalue = busAccLensPurchasesMap.get(grp.Id);
                                    if(acc.Optics_Location_Spend_LTM__c != null){
                                        existingvalue.add(acc.Optics_Location_Spend_LTM__c);
                                        busAccLensPurchasesMap.put(grp.Id, existingvalue);
                                    }
                                    else{
                                        existingvalue.add(0);
                                        busAccLensPurchasesMap.put(grp.Id, existingvalue);
                                    }
                                }
                                else{
                                    if(acc.Optics_Location_Spend_LTM__c != null){
                                        busAccLensPurchasesMap.put(grp.Id, new List<Decimal>{acc.Optics_Location_Spend_LTM__c});
                                    }
                                    else{
                                        busAccLensPurchasesMap.put(grp.Id, new List<Decimal>{0});
                                    }
                                }
                            }   
                        }
                    }  
                    if(!busAccTotalPurchasesMap.isEmpty()){
                        for(Id key :busAccTotalPurchasesMap.keySet()){
                            if(grp.Id == key){
                                Decimal total = 0;
                                Double tPAvg = 0;
                                Decimal[] totalPurchase = busAccTotalPurchasesMap.get(key);
                                
                                for(Decimal d :totalPurchase){
                                    total += d;
                                }
                                if(grp.Premier_Location_Count_Future__c != 0){
                                    tPAvg = Double.valueOf(total) / grp.Premier_Location_Count_Future__c;
                                }                            
                                grp.Average_Tiering_Total_Spend_LTM__c = tPAvg; 
                            }
                        }
                    }
                    if(!busAccFramePurchasesMap.isEmpty()){
                        for(Id key :busAccFramePurchasesMap.keySet()){
                            if(grp.Id == key){
                                Decimal total = 0;
                                Double fPAvg = 0;
                                Decimal[] framePurchase = busAccFramePurchasesMap.get(key);
                                
                                for(Decimal d :framePurchase){
                                    total += d;
                                }
                                if(grp.Premier_Location_Count_Future__c != 0){
                                    fPAvg = Double.valueOf(total) / grp.Premier_Location_Count_Future__c;
                                }
                                grp.Average_Tiering_Eyewear_Spend_LTM__c = fPAvg; 
                            }
                        }
                    }
                    
                    if(!busAccLensPurchasesMap.isEmpty()){
                        for(Id key :busAccLensPurchasesMap.keySet()){
                            if(grp.Id == key){
                                Decimal total = 0;
                                Double lPAvg = 0;
                                Decimal[] lensPurchase = busAccLensPurchasesMap.get(key);
                                
                                for(Decimal d :lensPurchase){
                                    total += d;
                                }
                                if(grp.Premier_Location_Count_Future__c != 0){
                                    lPAvg = Double.valueOf(total) / grp.Premier_Location_Count_Future__c;
                                }                            
                                grp.Average_Tiering_Optics_Spend_LTM__c = lPAvg; 
                            }
                        }
                    }
                    
                    
                }
                grgToUpdate.add(grp);
            }
            
            //Below part commented out by Vikhyat
            //system.debug('grgToUpdate List '+ grgToUpdate);
            //Commented out part by Vikhyat ends here.
            
            if(!grgToUpdate.isEmpty()){
                //  update grgToUpdate;
                
                Database.SaveResult[] SaveResultList = Database.update(grgToUpdate,false); 
                
                for(integer i =0; i<SaveResultList.size();i++){
                    String msg='';
                    If(!SaveResultList[i].isSuccess()){
                        
                        msg += 'Group Record Id: ' + grgToUpdate.get(i).id + '\n'+'Error: "';        
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
        
        //Updated the below if condition to include Test.isRunningTest so that the part runs when test class is run.
        //Updated by Vikhyat
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
                
                mail.setSubject('Premier Admin Tool Batch Job failure - Group Path to Premier Update Failed');
                
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
        
        
        /*VSPR31_Grg_Tier_Update_Batch obj = new VSPR31_Grg_Tier_Update_Batch();
Database.executeBatch(obj, 200);*/
        
        if(!Test.isRunningTest()){
            //below part commented by Vikhyat on 08/23/2019
            //VSPR31_AgreementType job = new VSPR31_AgreementType();
            //commented out part by Vikhyat on 08/23/2019 ends here.

            //below part added by Vikhyat on 08/23/2019
            //VSPR31_TierAgreementTypePracticeAccount job = new VSPR31_TierAgreementTypePracticeAccount(); 
            
            //updated to SFDC
            VSPR33_RetinalImagingGrgBatch job = new VSPR33_RetinalImagingGrgBatch();
            Database.executeBatch(job);
        }
        
    }
}