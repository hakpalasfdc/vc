/**
* Class Name: VSPR19b_PopulateGeoCode
* @author: Katherine Boothe
* Date: April 20, 2017
* Project: PROS Decommission
* @description: Handles populating the VSP Geo Code and Physical County based on the ZIP Code.
*/ 

public class VSPR19b_PopulateGeoCode_Handler {
    public static boolean VSPR19b_PopulateGeoCode_Handler_recursion = true;
    Boolean isUpdate = false;
    public void VSPR19b_PopulateGeoCode_Handler(List<Account> newTrigger, Map<Id, Account> oldMap, Boolean isTrgUpdate){
        if(VSPR19b_PopulateGeoCode_Handler_recursion ){
            String pracAccRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Practice Account'].Id;
            String busAccRecordTypeId = [SELECT Id from RecordType where SObjectType = 'Account' and Name='Business Account'].Id;
            VSPR19b_PopulateGeoCode_Handler_recursion = false;
            system.debug('***** entered VSPR19b_PopulateGeoCode_Handler ***** ');
            List<Account> accIds = new List<Account>();
            Set<string> allshippingPostalCode5Char = new Set<string>();
            for(Account a : newTrigger){
                if(a.RecordTypeId == pracAccRecordTypeId || a.RecordTypeId == busAccRecordTypeId){
                    if( a.ShippingPostalCode != null && a.ShippingPostalCode.length() >4){
                        String shippingPostalCode5Char = a.ShippingPostalCode.substring(0,5);  
                        allshippingPostalCode5Char.add(shippingPostalCode5Char);
                    }
                }
                if(isTrgUpdate){
                    isUpdate = true;
                }
            }
            system.debug('allshippingPostalCode5Char: '+allshippingPostalCode5Char);
            List<General_Table__c> geoCode = [SELECT id, Name, Additional_Information__c, Additional_Information_2__c, Code_Description__c FROM General_Table__c WHERE Table__c = 'CLM2305' AND Status__c = 'Active' AND Name =: allshippingPostalCode5Char];
            system.debug('geoCode: '+geoCode);
            map<string,string> geoCodeCD = new Map<string,string>();
            map<string,string> geoCodeAI = new Map<string,string>();
            map<string,string> geoCodeAI2 = new Map<string,string>();
            for(General_Table__c gt : geoCode){
                geoCodeCD.put(gt.Name,gt.Code_Description__c);
                geoCodeAI.put(gt.Name,gt.Additional_Information__c);
                geoCodeAI2.put(gt.Name,gt.Additional_Information_2__c);
            }
            system.debug('geoCodeCD: '+geoCodeCD);
            system.debug('geoCodeAI: '+geoCodeAI);
            system.debug('geoCodeAI2: '+geoCodeAI2);
    
            map<string,Integer> count1 = new Map<string,Integer>();
            AggregateResult[] geoCodeCounts = [SELECT Name Id, COUNT(Id) geoCodeCount FROM General_Table__c WHERE Name != NULL AND Table__c = 'CLM2305' AND Status__c = 'Active'
            AND Name =: allshippingPostalCode5Char GROUP BY Name];
            system.debug('geoCodeCounts: '+geoCodeCounts);
            for(AggregateResult ar : geoCodeCounts){
                count1.put((string)ar.get('Id'), (Integer)ar.get('geoCodeCount'));
            }
            system.debug('count1: '+count1);

            for(Account a : newTrigger){
                String shippingPostalCode5CharX;
                if(a.RecordTypeId == pracAccRecordTypeId || a.RecordTypeId == busAccRecordTypeId){
                    if( a.ShippingPostalCode != null && a.ShippingPostalCode.length() >4){
                        shippingPostalCode5CharX = a.ShippingPostalCode.substring(0,5);
                    }
                    Account dup  = new Account(Id = a.Id);   
                    system.debug('shippingPostalCode5CharX: '+shippingPostalCode5CharX);
                    system.debug('count1.get(shippingPostalCode5CharX): '+count1.get(shippingPostalCode5CharX));
                    if(count1.get(shippingPostalCode5CharX) == 0 || count1.get(shippingPostalCode5CharX) == null){
                        if(a.RecordTypeId == busAccRecordTypeId){
                            dup.VSP_GeoCode__c  = ''; 
                            dup.Physical_County__c  = '';
                            dup.Physical_County_Code__c = '';
                            dup.Bypass_VC_Validation_Rules__c = true;
                        }
                        if(a.RecordTypeId == pracAccRecordTypeId){
                            dup.Physical_County__c  = '';
                            dup.Physical_County_Code__c = '';
                            dup.Bypass_VC_Validation_Rules__c = true;
                        }
                    }
                    if(count1.get(shippingPostalCode5CharX) == 1){
                        if(a.RecordTypeId == busAccRecordTypeId){
                            dup.VSP_GeoCode__c = geoCodeCD.get(shippingPostalCode5CharX);
                            dup.Physical_County__c = geoCodeAI.get(shippingPostalCode5CharX);
                            dup.Physical_County_Code__c = geoCodeAI2.get(shippingPostalCode5CharX);
                            dup.Bypass_VC_Validation_Rules__c = true;
                        }
                        if(a.RecordTypeId == pracAccRecordTypeId){
                            dup.Physical_County__c = geoCodeAI.get(shippingPostalCode5CharX);
                            dup.Physical_County_Code__c = geoCodeAI2.get(shippingPostalCode5CharX);
                            dup.Bypass_VC_Validation_Rules__c = true;
                        }
                    }
                    if(isUpdate){
                        Account oldAcc = oldMap.get(a.Id);
                        if(oldAcc.ShippingPostalCode == null){ 
                            dup.Physical_County__c = '';
                            dup.VSP_GeoCode__c = '';
                            dup.Physical_County_Code__c = '';
                        }  
                    }
                    accIds.add(dup);
                }
            }
            system.debug('accIds: '+accIds);
            update accIds;   
            system.debug('***** exiting VSPR19b_PopulateGeoCode_Handler ***** ');
        }
    }
}