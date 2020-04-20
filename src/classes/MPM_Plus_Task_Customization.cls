public class MPM_Plus_Task_Customization {
    
    public static void pullAccountToTask(List<MPM4_BASE__Milestone1_Task__c> triggeredTasks) {
        Id projectId = triggeredTasks[0].MPM4_BASE__ProjectId__c;
        
        MPM4_BASE__Milestone1_Project__c accountId = [SELECT MPM4_BASE__Account__c FROM MPM4_BASE__Milestone1_Project__c WHERE Id = :projectId LIMIT 1][0];
        
        for(MPM4_BASE__Milestone1_Task__c triggeredTask : triggeredTasks) {
            triggeredTask.Account_Name__c = accountId.MPM4_BASE__Account__c;
        }
        
    }
    
    public static void pullAccountToTaskFromProjectAccountAdded(List<MPM4_BASE__Milestone1_Project__c> triggeredProjects) {
        Id projectId = triggeredProjects[0].Id;
        
        String truncatedProjectId = String.valueOf(projectId).substring(0, 15);
        system.debug(truncatedProjectId);
        List<MPM4_BASE__Milestone1_Task__c> tasksToUpdate = [SELECT Id, Account_Name__c FROM MPM4_BASE__Milestone1_Task__c WHERE MPM4_BASE__ProjectId__c = :truncatedProjectId];
        
        for(MPM4_BASE__Milestone1_Task__c taskToUpdate : tasksToUpdate) {
            taskToUpdate.Account_Name__c = triggeredProjects[0].MPM4_BASE__Account__c;
        }
        
        upsert tasksToUpdate;
    }
}