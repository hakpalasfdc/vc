public class VSPR25b_UpdateContactEndDate {
    
    public static boolean VSPR25b_UpdateContactDate_recursion = true;
    public void VSPR25b_UpdateContactEndDate(List<Network_Relationship__c> newTrigger,Map<Id,Network_Relationship__c> oldRecs){
        
        if(VSPR25b_UpdateContactDate_recursion){
            VSPR25b_UpdateContactDate_recursion = false;
            Date ConEndDate;
            Map<id,Date> MapIdWithDate=new Map<id,Date>();
            system.debug('***** entered VSPR25b_UpdateContactDate ***** ');
            Set<id> conID=new Set<Id>();
            
            
            for(Network_Relationship__c nr: newTrigger){
                
                system.debug('***** Provider_Name__c ***** ' + nr.Provider_Name__c);
                system.debug('***** oldRecs ***** ' + oldRecs);
                system.debug('***** nr.Provider_Name__r.Vision_Care_End_Date__c ***** ' + nr.Contact_Role__r.Contact__r.Vision_Care_End_Date__c);
                
                
                if(oldRecs !=null){
                    if(nr.Program_End_Date__c != oldRecs.get(nr.Id).Program_End_Date__c 
                       || oldRecs.get(nr.Id).Program_End_Date__c == null && nr.Program_End_Date__c != null 
                       || nr.Program_End_Date__c == null && nr.Provider_Name__r.Vision_Care_End_Date__c != null 
                       || nr.Program_End_Date__c != null && nr.Provider_Name__r.Vision_Care_End_Date__c == null){
                           system.debug('***** TESTING CONTACT ID ***** ' + nr.Provider_Name__c);
                           conID.add(nr.Provider_Name__c); 
                           
                       }
                }
                else{
                    //  if(nr.Program_End_Date__c == null && nr.Provider_Name__r.Vision_Care_End_Date__c != null || nr.Program_End_Date__c != null && nr.Provider_Name__r.Vision_Care_End_Date__c == null || nr.Program_End_Date__c > System.today() && nr.Provider_Name__r.Vision_Care_End_Date__c != null){
                    if(nr.Provider_Name__c != null){
                        conID.add(nr.Provider_Name__c); 
                    }
                    //   }
                    
                }
                
                
            }
            
            
            if(!conID.isEmpty()){
                system.debug('***** conID ***** ' + conID);
                
                
                Map<String,Date> maxEndDateMap = new Map<String,Date>();
                Map<String,Date> ActivemaxEndDateMap = new Map<String,Date>();
                Map<String,Date> ActiveBlankEndDateMap = new Map<String,Date>();
                Set<Contact> updateConSet =new Set<Contact>();
                List<Network_Relationship__c> ActivemaxEndDateList = 
                    [SELECT id,Program_End_Date__c,Contact_Role__r.Contact__c, Provider_Name__c
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__r.Contact__c in : conID AND Program_End_Date__c !=NULL
                     ORDER BY Program_End_Date__c ASC];
                
                List<Network_Relationship__c> ActiveBlankEndDateList = 
                    [SELECT id,Program_End_Date__c,Contact_Role__r.Contact__c, Provider_Name__c
                     FROM Network_Relationship__c 
                     WHERE Contact_Role__r.Contact__c in : conID AND Program_End_Date__c = NULL];
                
                
                system.debug('ActivemaxEndDateList ' + ActivemaxEndDateList);
                system.debug('ActiveBlankEndDateList ' + ActiveBlankEndDateList);
                
                for(Network_Relationship__c accX: ActivemaxEndDateList){
                    ActivemaxEndDateMap.put(accX.Provider_Name__c,accX.Program_End_Date__c);
                }
                
                for(Network_Relationship__c accX: ActiveBlankEndDateList){
                    ActiveBlankEndDateMap.put(accX.Provider_Name__c,accX.Program_End_Date__c);
                }
                
                system.debug('ActivemaxEndDateMap' + ActivemaxEndDateMap);
                system.debug('ActiveBlankEndDateMap '+ ActiveBlankEndDateMap);
                List<Contact> contoUpdtoActive = 
                    [SELECT id,Vision_Care_End_Date__c, Vision_Care_Term_Reason__c
                     FROM Contact 
                     WHERE Id =: conID]; 
                
                
                List<General_Table__c> GT_List = new List<General_Table__c>();
                
                for(General_Table__c GT : [SELECT id FROM General_Table__c WHERE Name = '1PRC' AND Table__c = 'PRS6' AND Status__c = 'Active']){
                    GT_List.add(GT);
                }        
                
                for(Contact actCon: contoUpdtoActive){                 
                    if(ActiveBlankEndDateMap.keySet().contains(actCon.Id)){
                        actCon.Vision_Care_End_Date__c = null;
                        actCon.Bypass_VC_Validation_Rules__c = true;
                        updateConSet.add(actCon);
                    }
                    else{
                        if(!GT_List.isEmpty()){
                            actCon.Vision_Care_End_Date__c = ActivemaxEndDateMap.get(actCon.Id);
                            actCon.Vision_Care_Term_Reason__c = GT_List[0].id;
                            actCon.Bypass_VC_Validation_Rules__c = true;
                            updateConSet.add(actCon);  
                        }
                        else{
                            actCon.Vision_Care_End_Date__c = ActivemaxEndDateMap.get(actCon.Id);
                            actCon.Bypass_VC_Validation_Rules__c = true;
                            updateConSet.add(actCon);  
                            
                        }
                    }                    
                }
                List<Contact> updateCon = new List<Contact>(updateConSet);
                if(!updateCon.isEmpty()){
                    update updateCon;
                }                
            }
        }
    }
}