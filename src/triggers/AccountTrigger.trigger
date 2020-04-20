trigger AccountTrigger on Account (before insert, before update, after insert, after update, after delete, after undelete) {
	if(!VSPUtility.stopAccountTrigger){
    	Id perAccRTId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();    
		List<Account> triggerNewAccounts = new List<Account>();
        List<Account> triggerOldAccounts = new List<Account>();
        
        if(trigger.new != null){
            for(Account acct:trigger.new){
                if(acct.RecordTypeId != perAccRTId){
                    triggerNewAccounts.add(acct);
                }
            }
        }
        
        if(trigger.old != null){
            for(Account acct:trigger.old){
                if(acct.RecordTypeId != perAccRTId){
                    triggerOldAccounts.add(acct);
                }
            }
        }
        
        if(trigger.isBefore){
            if(trigger.isInsert){
                VSPR19b_ValidateTaxID valTaxId = new VSPR19b_ValidateTaxID();
                valTaxId.VSPR19b_ValidateTaxID(triggerNewAccounts, null, false);
                
                VSPR33_vcCalculator vcCalculator = new VSPR33_vcCalculator();
                vcCalculator.vcCalculationBeforeInsert(triggerNewAccounts);
                
                VSPR31_BusAccContractTypeCalculation contractTypeCalculation = new VSPR31_BusAccContractTypeCalculation();
                contractTypeCalculation.ContractTypeCalculationBeforeInsert(triggerNewAccounts);
                
                VSPR33_RetinalImageHelper retinal = new VSPR33_RetinalImageHelper();
                retinal.beforeInsert(triggerNewAccounts);
                
                VSPR34_FFAA_Update ffaa = new VSPR34_FFAA_Update();
                ffaa.VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate(triggerNewAccounts,Trigger.oldmap);
            }
            
            if(trigger.isUpdate){
                VSPR19b_ValidateTaxID valTaxId = new VSPR19b_ValidateTaxID();
                valTaxId.VSPR19b_ValidateTaxID(triggerNewAccounts, trigger.oldmap, true);
                
                VSPR11_ValidateBusinessHours validateBizHrs = new VSPR11_ValidateBusinessHours();
                validateBizHrs.VSPR11_ValidateBusinessHours(triggerNewAccounts);
                
                VSPR33_vcCalculator vcCalculator = new VSPR33_vcCalculator();
                vcCalculator.vcCalculationBeforeUpdate(triggerNewAccounts, trigger.oldMap);
                
                VSPR31_BusAccContractTypeCalculation contractTypeCalculation = new VSPR31_BusAccContractTypeCalculation();
                contractTypeCalculation.ContractTypeCalculationBeforeUpdate(triggerNewAccounts, trigger.oldMap);
                
                VSPR33_RetinalImageHelper retinal = new VSPR33_RetinalImageHelper();
                retinal.beforeUpdate(triggerNewAccounts, trigger.oldMap);
                
                VSPR34_FFAA_Update ffaa = new VSPR34_FFAA_Update();
                ffaa.VSPR34_FFAA_Update_CheckBAFFAABeforeInsertUpdate(triggerNewAccounts,Trigger.oldmap);
            } 
        }
            
        if(trigger.isAfter){
            if(trigger.isInsert){
                VSPR19b_PopulateVisionCareKey popVCKey = new VSPR19b_PopulateVisionCareKey();
                popVCKey.VSPR19b_PopulateVisionCareKey(triggerNewAccounts, null, false);
                
                VSPR19b_PopulateBAVCEndDate bizAcctEndDate = new VSPR19b_PopulateBAVCEndDate();
                bizAcctEndDate.VSPR19b_PopulateBAVCEndDate(triggerNewAccounts, null, false);
                
                VSPR19b_AddVCEndDateAccRelatedRecords relRecVCEndDate = new VSPR19b_AddVCEndDateAccRelatedRecords();
                relRecVCEndDate.VSPR19b_AddVCEndDateAccRelatedRecords(triggerNewAccounts);
                
                VSPR19b_UpdatePracticeAccountEndDate pracAccEndDate = new VSPR19b_UpdatePracticeAccountEndDate();
                pracAccEndDate.VSPR19b_UpdatePracticeAccountEndDate(triggerNewAccounts, null, false, false);
                
                VSPR19b_UpdateVisionCareCurrentCustomer currentCustomer = new VSPR19b_UpdateVisionCareCurrentCustomer();
                currentCustomer.VSPR19b_UpdateVisionCareCurrentCustomer(triggerNewAccounts);
                
                VSPR19b_PopulateGeoCode_Handler popGeoCode = new VSPR19b_PopulateGeoCode_Handler();
                popGeoCode.VSPR19b_PopulateGeoCode_Handler(triggerNewAccounts, null, false); 
                
                VSPR19b_PopulateBankName_Handler popBankName = new VSPR19b_PopulateBankName_Handler();
                popBankName.VSPR19b_PopulateBankName_Handler(triggerNewAccounts);
                
                //VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(Trigger.isDelete ? trigger.old : triggerAccounts,Trigger.oldmap);
                VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(triggerNewAccounts,Trigger.oldmap);
            }
            
            if(trigger.isUpdate){
                VSPR19b_AddExceptionToRelatedNRRecords addException = new VSPR19b_AddExceptionToRelatedNRRecords();
                addException.VSPR19b_AddExceptionToRelatedNRRecords(triggerNewAccounts, trigger.oldmap, true);
                
                VSPR19b_PopulateBAVCEndDate bizAcctEndDate = new VSPR19b_PopulateBAVCEndDate();
                bizAcctEndDate.VSPR19b_PopulateBAVCEndDate(triggerNewAccounts, trigger.oldmap, true);
                
                VSPR19b_PopulateVisionCareKey popVCKey = new VSPR19b_PopulateVisionCareKey();
                popVCKey.VSPR19b_PopulateVisionCareKey(triggerNewAccounts, trigger.oldmap, true);
                
                VSPR19b_AddVCEndDateAccRelatedRecords relRecVCEndDate = new VSPR19b_AddVCEndDateAccRelatedRecords();
                relRecVCEndDate.VSPR19b_AddVCEndDateAccRelatedRecords(triggerNewAccounts);
                
                VSPR19b_UpdatePracticeAccountEndDate pracAccEndDate = new VSPR19b_UpdatePracticeAccountEndDate();
                pracAccEndDate.VSPR19b_UpdatePracticeAccountEndDate(triggerNewAccounts, null, false, false);
                
                VSPR19b_UpdateVisionCareCurrentCustomer currentCustomer = new VSPR19b_UpdateVisionCareCurrentCustomer();
                currentCustomer.VSPR19b_UpdateVisionCareCurrentCustomer(triggerNewAccounts);
                
                //updated by vikhyat
                /*VSPR34_FFAA_Update ffaa = new VSPR34_FFAA_Update();
                ffaa.VSPR34_FFAA_Update_CheckBAFFAAAfterUpdate(triggerNewAccounts,Trigger.oldmap);*/
                
                VSPR19b_PopulateGeoCode_Handler popGeoCode = new VSPR19b_PopulateGeoCode_Handler();
                popGeoCode.VSPR19b_PopulateGeoCode_Handler(triggerNewAccounts, trigger.oldmap, true);  //added this for testing
                
                VSPR19b_PopulateBankName_Handler popBankName = new VSPR19b_PopulateBankName_Handler();
                popBankName.VSPR19b_PopulateBankName_Handler(triggerNewAccounts);
                
                //VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(Trigger.isDelete ? trigger.old : triggerAccounts,Trigger.oldmap);
                VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(triggerNewAccounts,Trigger.oldmap);
                
                VSPR31_BusAccContractTypeCalculation contractTypeCalculation = new VSPR31_BusAccContractTypeCalculation();
                contractTypeCalculation.ContractTypeCalculationAfterUpdate(triggerNewAccounts, trigger.oldMap);
            }
            
            if(trigger.isDelete){
                //VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(Trigger.isDelete ? trigger.old : triggerAccounts,Trigger.oldmap);
                VSPR25_UpdatePracticeProdAssets.setPracticeAccountProdAssets(triggerOldAccounts,Trigger.oldmap);
            }
        }
  	}      
}