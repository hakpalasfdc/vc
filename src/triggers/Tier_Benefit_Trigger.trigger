trigger Tier_Benefit_Trigger on Tier_Benefit__c (before insert, before update,before delete, after insert, after update, after delete, after undelete) {

    if(Trigger.isAfter){
        if(Trigger.isInsert){
            vsp_tierBenefitTriggerHelper.outboundCheckoxAfterInsert(trigger.new);

        }
    }

}