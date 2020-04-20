public class VSPR31_Update_GRG_End_Date {
    
    public static boolean VSPR31_Update_GRG_End_Date_recursion = true;
    public void VSPR31_Update_GRG_End_Date(List<Global_Rewards_Group_Relationship__c> newTrigger,Map<Id,Global_Rewards_Group_Relationship__c> oldRecs){
        
        if(VSPR31_Update_GRG_End_Date_recursion){
            VSPR31_Update_GRG_End_Date_recursion = false;
            
            system.debug('***** entered VSPR31_Update_GRG_End_Date ***** ');
            Set<id> grgIdSet = new Set<Id>();

            for(Global_Rewards_Group_Relationship__c grgR: newTrigger){
                
                if(oldRecs !=null){
                    system.debug('GRG Record Type' + grgR.Global_Rewards_Group__r.RecordType.Name );
                    if(grgR.End_Date__c != oldRecs.get(grgR.Id).End_Date__c && grgR.Start_Date__c != Null){
                        grgIdSet.add(grgR.Global_Rewards_Group__c);
                    }
                }
                else{
                    if(grgR.Start_Date__c != Null){
                        grgIdSet.add(grgR.Global_Rewards_Group__c);
                    }
                }
            }
            
            
            if(!grgIdSet.isEmpty()){
                
                List<Global_Rewards_Group__c> grgToUpd = new List<Global_Rewards_Group__c>();
                
                List<Global_Rewards_Group__c> grgLst = [SELECT Id, Status__c, End_Date__c,
                                                        (SELECT End_Date__c FROM Global_Rewards_Group__r ORDER BY End_Date__c DESC NULLS FIRST LIMIT 1)
                                                        FROM Global_Rewards_Group__c 
                                                        WHERE Id IN :grgIdSet AND RecordType.Name != 'Tax ID Rollup'];
                
                
                for(Global_Rewards_Group__c grg :grgLst){
                    for(Global_Rewards_Group_Relationship__c grgR :grg.Global_Rewards_Group__r){
						grg.End_Date__c = grgR.End_Date__c;                        
                        grgToUpd.add(grg);
                        break;
                    }
                }
                
                system.debug('grgToUpd ' + grgToUpd);
                if(!grgToUpd.isEmpty()){
                    List<String> exception_List = new List<String>();
                    Database.SaveResult[] SaveResultList = Database.update(grgToUpd,false); 
                    
                    for(integer i =0; i<SaveResultList.size();i++){
                        String msg='';
                        If(!SaveResultList[i].isSuccess()){
                            
                            msg += 'Group Reward Group Record Id: ' + grgToUpd.get(i).id + '\n'+'Error: "';        
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
    }
}