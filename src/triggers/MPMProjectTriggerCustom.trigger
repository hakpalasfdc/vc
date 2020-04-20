trigger MPMProjectTriggerCustom on MPM4_BASE__Milestone1_Project__c (after update) {
	MPM_Plus_Task_Customization.pullAccountToTaskFromProjectAccountAdded(trigger.new);
}