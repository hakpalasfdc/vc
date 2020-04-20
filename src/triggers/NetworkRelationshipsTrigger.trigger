/*
* Trigger Name: NetworkRelationshipsTrigger
* @author: Katherine Boothe
* Date: February 14, 2017
* @description: Trigger to populate Network Relationship object
*/


trigger NetworkRelationshipsTrigger on Network_Relationship__c (before insert, before update,before delete, after insert, after update, after delete, after undelete) {
    
    if(Trigger.isBefore){
        
        if(trigger.isInsert || trigger.isUpdate){
            
            //  VSPR19b_restrictOverlappingNR.goDo(trigger.new);
            
            VSPR19b_NetworkRelationshipsBL updateContactRole = new VSPR19b_NetworkRelationshipsBL();
            updateContactRole.conRoleNetRelBeforeTriggerMethod(trigger.new);
            
            VSPR25b_ValidateCHOICNetwork validateCHOIC = new VSPR25b_ValidateCHOICNetwork();
            validateCHOIC.VSPR19b_ValidateCHOICNetworkMethod(trigger.new,trigger.oldmap);
            
            
        }
        
        if(Trigger.isInsert){ 
            
            VSPR25b_ValidateMedicaidLicense validateMedLicense = new VSPR25b_ValidateMedicaidLicense();
            validateMedLicense.VSPR19B_ValidateMedicaidLicenseMethod(trigger.new,trigger.old,trigger.newmap,trigger.oldmap); //Also uses NetworkRelTriggerForProgramIdHandler for applyActiveCostcoPIToNewDoctor
        }
        
        if(Trigger.isDelete){
            
            VSPR25b_ValidateClaimsPriced validateClaims = new VSPR25b_ValidateClaimsPriced(); //Restrict users from deleting a Network Relationship if Claims Priced = Y
            validateClaims.validateClaimsPriced(trigger.old);
        }
    }
    
    if(Trigger.isAfter){
        
        if(trigger.isInsert){
            
            VSPR19b_restrictOverlappingNR.goDo(trigger.new);
            
        }
        
        if(trigger.isInsert || trigger.isupdate || trigger.isdelete){
            
            VSPR25b_CheckVSPnetworkProvider VSPnetworkProvider = new VSPR25b_CheckVSPnetworkProvider();
            VSPnetworkProvider.VSPR19b_checkVSPnetworkProviderMethod(trigger.Old,trigger.new,trigger.oldMap);
            
            VSPR25b_ActiveFutureDateVisionCareRels activeFutureDateVisionCare = new VSPR25b_ActiveFutureDateVisionCareRels();
            activeFutureDateVisionCare.activeFutureDatedVisionCareRels(trigger.new,trigger.old);
        }
        
        if(trigger.isInsert || trigger.isUpdate){
            
            VSPR25b_ApplyProgramIds applyProgramId = new VSPR25b_ApplyProgramIds();
            applyProgramId.VSPR19b_Apply_Program_IDsMethod(trigger.new,trigger.oldMap);
            
            VSPR25b_ValidateMedicaidLicense validateMedLicense = new VSPR25b_ValidateMedicaidLicense();
            validateMedLicense.VSPR19B_ValidateMedicaidLicenseMethod(trigger.new,trigger.old,trigger.newmap,trigger.oldmap);//Also uses NetworkRelTriggerForProgramIdHandler for applyActiveCostcoPIToNewDoctor
            
            VSPR25b_UpdateContactEndDate updateConEndDate = new VSPR25b_UpdateContactEndDate();
            updateConEndDate.VSPR25b_UpdateContactEndDate(trigger.new,trigger.oldmap);
            
            VSPR30_UpdateNetRelRoleID updateRoleID = new VSPR30_UpdateNetRelRoleID();
            updateRoleID.VSPR30_UpdateNetRelRoleID(trigger.new,trigger.oldmap);
               
        }   
        
        if(trigger.isUpdate){
            
            VSPR25b_ContRoleNetRel conRoleNetRel = new VSPR25b_ContRoleNetRel();
            conRoleNetRel.conRoleNetRelAfterTriggerMethod(trigger.new);
            
        }
        
        
    }
}