/**
* Class Name: VSPR19b_PopulateBankName
* Date: May 12, 2017
* Project: PROS Decommission
* @author: Kiran Penmatsa
* @description: Populates Bank Name given the routing number
*/

public class VSPR19b_PopulateBankName_Handler{
    public static boolean isExecuting = false;
    public static boolean VSPR19b_PopulateBankName_Handler_recursion = true;
    
    public void VSPR19b_PopulateBankName_Handler(List<Account> newTrigger){
        
        if(VSPR19b_PopulateBankName_Handler_recursion ){
            String pracAccRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
    String busAccRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Business Account'].Id;
    
        VSPR19b_PopulateBankName_Handler_recursion = false;
        
            //if( VSPR19b_PopulateBankName_Handler.isExecuting ){
            //    return;
            //}
            //VSPR19b_PopulateBankName_Handler.isExecuting = true; 
            system.debug('***** entered VSPR19b_PopulateBankName_Handler ***** ');
    
            Set<string> allBankRoutingNbrs = new Set<string>();
            for(Account a : newTrigger){
                if(a.RecordTypeId == pracAccRecordTypeId || a.RecordTypeId == busAccRecordTypeId){
                    if( a.Bank_Routing_Number__c != null){
                        String aBankRoutingNbr = a.Bank_Routing_Number__c;  
                        allBankRoutingNbrs.add(aBankRoutingNbr);
                    }
                }
            }
            system.debug('allBankRoutingNbrs: '+allBankRoutingNbrs);
            List<General_Table__c> geoCode = 
                [SELECT id, Name, Code_Description__c 
                 FROM General_Table__c 
                 WHERE Table__c = 'PRS1211' 
                 AND Status__c = 'Active'
                 AND Name =: allBankRoutingNbrs];
            system.debug('geoCode: '+geoCode);
            map<string,string> geoCodeCD = new Map<string,string>();
            for(General_Table__c gt : geoCode){
                geoCodeCD.put(gt.Name,gt.Code_Description__c);
            }
            system.debug('geoCodeCD: '+geoCodeCD);
    
            map<string,Integer> count1 = new Map<string,Integer>();
            AggregateResult[] geoCodeCounts = 
                [SELECT Name Id, COUNT(Id) geoCodeCount 
                 FROM General_Table__c 
                 WHERE Name != NULL 
                 AND Table__c = 'PRS1211'
                 AND Status__c = 'Active'
                 AND Name =: allBankRoutingNbrs
                 GROUP BY Name];
            system.debug('geoCodeCounts: '+geoCodeCounts);
            for(AggregateResult ar : geoCodeCounts){
                    count1.put((string)ar.get('Id'), (Integer)ar.get('geoCodeCount'));
            }
            system.debug('count1: '+count1);
    
            List<Account> accIds = new List<Account>();
            for(Account a : newTrigger){
                if(a.RecordTypeId == pracAccRecordTypeId || a.RecordTypeId == busAccRecordTypeId){
                    
                    Account dup  = new Account(Id = a.Id);          
                    if(count1.get(a.Bank_Routing_Number__c) == 0){
                        dup.Bank_Name__c   = '';
                        dup.Bypass_VC_Validation_Rules__c = true;
                    }
                    if(count1.get(a.Bank_Routing_Number__c) == 1){
                        dup.Bank_Name__c = geoCode[0].Code_Description__c; 
                        dup.Bypass_VC_Validation_Rules__c = true;
                    }
                    accIds.add(dup);
                }
            }
            update accIds;
            system.debug('***** exiting VSPR19b_PopulateBankName_Handler ***** ');
        }
    }
}