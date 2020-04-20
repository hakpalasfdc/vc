trigger MPMTaskTriggerCustom on MPM4_BASE__Milestone1_Task__c (before insert) {
	MPM_Plus_Task_Customization.pullAccountToTask(trigger.new);
}