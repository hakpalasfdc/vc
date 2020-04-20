/**
* Class Name: VSPR19b_UpdateVisionCareCurrentCustomer
* Date: 
* Project: PROS Decommission
* @author: eightCloud
* @description: Populates the Vision Care Current Customer indicators on Business Accounts based on Vision Care Effective Date
*                and Location Type.
*/

public class VSPR19b_UpdateVisionCareCurrentCustomer{

    public static boolean VSPR19b_UpdateVisionCareCurrentCustomer_recursion = true;
    
    public void VSPR19b_UpdateVisionCareCurrentCustomer(List<Account> newTrigger){
        
        if(VSPR19b_UpdateVisionCareCurrentCustomer_recursion){
        VSPR19b_UpdateVisionCareCurrentCustomer_recursion = false;

            system.debug('***** entered VSPR19b_UpdateVisionCareCurrentCustomer ***** ');
            Set<Account> mtnsToUpdateSet = new Set<Account>();
            
            String accRecordTypeId = [SELECT Id 
                                      FROM RecordType 
                                      WHERE SObjectType = 'Account' 
                                      AND Name='Business Account'].Id;
            
            for(Account acc: newTrigger){
                if(acc.RecordTypeId == accRecordTypeId && acc.Location_Type__c == 'M - VSP Member Location' && 
                   acc.Vision_Care_Effective_Date__c <= system.today() &&
                   (acc.Vision_Care_End_Date__c >= system.today() || acc.Vision_Care_End_Date__c == NULL)){
                        Account a = new Account(id=acc.Id);
                        a.Vision_Care_VSP_Network_Provider__c = TRUE;
                        a.Vision_Care_VSP_Affiliate__c = FALSE;
                        a.Vision_Care_VSP_Other__c = FALSE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet.add(a);       
                }            
            }

            for(Account acc2: newTrigger){
                if(acc2.RecordTypeId == accRecordTypeId && acc2.Location_Type__c == 'A - Affiliate Provider Location' && 
                   acc2.Vision_Care_Effective_Date__c <= system.today() &&
                   (acc2.Vision_Care_End_Date__c >= system.today() || acc2.Vision_Care_End_Date__c == NULL)){
                        Account a = new Account(id=acc2.Id);
                        a.Vision_Care_VSP_Affiliate__c = TRUE;
                        a.Vision_Care_VSP_Network_Provider__c = FALSE;
                        a.Vision_Care_VSP_Other__c = FALSE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet.add(a);       
                }   
            }

            for(Account acc3: newTrigger){
                if(acc3.RecordTypeId == accRecordTypeId && acc3.Location_Type__c == 'F - Laser Vision Correction (LVC)' && 
                   acc3.Vision_Care_Effective_Date__c <= system.today() &&
                   (acc3.Vision_Care_End_Date__c >= system.today() || acc3.Vision_Care_End_Date__c == NULL)){
                        Account a = new Account(id=acc3.Id);
                        a.Vision_Care_VSP_Affiliate__c = FALSE;
                        a.Vision_Care_VSP_Network_Provider__c = FALSE;
                        a.Vision_Care_VSP_Other__c = TRUE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet.add(a);       
                }   
            }

            for(Account acc4: newTrigger){
                if(acc4.RecordTypeId == accRecordTypeId && acc4.Location_Type__c == 'X - Client Authorized Location (GAP)' && 
                   acc4.Vision_Care_Effective_Date__c <= system.today() &&
                   (acc4.Vision_Care_End_Date__c >= system.today() || acc4.Vision_Care_End_Date__c == NULL)){
                        Account a = new Account(id=acc4.Id);
                        a.Vision_Care_VSP_Affiliate__c = FALSE;
                        a.Vision_Care_VSP_Network_Provider__c = FALSE;
                        a.Vision_Care_VSP_Other__c = TRUE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet.add(a);       
                }   
            }

            List<Account> mtnsToUpdate = new List<Account>(mtnsToUpdateSet); 
            if(!mtnsToUpdate.isEmpty()) {
                update mtnsToUpdate;
            } 


            /*
            Set<Account> mtnsToUpdateSet3 = new Set<Account>();
            For(Account acc3: newTrigger){
                if(acc3.RecordTypeId == accRecordTypeId && acc3.Location_Type__c != 'M - VSP Member Location' && 
                   acc3.Location_Type__c != 'A - Affiliate Provider Location' &&
                   acc3.Location_Type__c != NULL &&
                   acc3.Vision_Care_Effective_Date__c <= system.today() &&
                   (acc3.Vision_Care_End_Date__c >= system.today() || acc3.Vision_Care_End_Date__c == NULL)){
                        Account a = new Account(id=acc3.Id);
                        a.Vision_Care_VSP_Other__c = TRUE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet3.add(a);       
                }

                List<Account> mtnsToUpdate3 = new List<Account>(mtnsToUpdateSet3); 
                if(!mtnsToUpdate3.isEmpty()) {
                    update mtnsToUpdate3;
                }    
                
            }

            Set<Account> mtnsToUpdateSet4 = new Set<Account>();
            For(Account acc4: newTrigger){
                if(acc4.RecordTypeId == accRecordTypeId && acc4.Location_Type__c == NULL){
                        Account a = new Account(id=acc4.Id);
                        a.Vision_Care_VSP_Network_Provider__c = FALSE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet4.add(a);       
                }

                List<Account> mtnsToUpdate4 = new List<Account>(mtnsToUpdateSet4); 
                if(!mtnsToUpdate4.isEmpty()) {
                    update mtnsToUpdate4;
                }    
                
            }

            Set<Account> mtnsToUpdateSet5 = new Set<Account>();
            For(Account acc5: newTrigger){
                if(acc5.Vision_Care_End_Date__c < system.today() &&
                   acc5.Vision_Care_End_Date__c != NULL){
                        Account a = new Account(id=acc5.Id);
                        a.Vision_Care_VSP_Affiliate__c = FALSE;
                        a.Vision_Care_VSP_Network_Provider__c = FALSE;
                        a.Vision_Care_VSP_Other__c = FALSE;
                        a.Bypass_VC_Validation_Rules__c = TRUE;
                        mtnsToUpdateSet5.add(a);       
                }

                List<Account> mtnsToUpdate5 = new List<Account>(mtnsToUpdateSet5); 
                if(!mtnsToUpdate5.isEmpty()) {
                    update mtnsToUpdate5;
                }    
                
            }
            */

        system.debug('***** exiting VSPR19b_UpdateVisionCareCurrentCustomer ***** ');
        }
    }
}