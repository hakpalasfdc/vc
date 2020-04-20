@isTest
public class MPM_Plus_Task_Customization_Behaviour {
	
    static testmethod void shouldUpdateTaskWithAccountWhenNewTaskIsCreated(){
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
		MPM4_BASE__Milestone1_Project__c testProject = new MPM4_BASE__Milestone1_Project__c(Name='Test Project', MPM4_BASE__Account__c=testAccount.Id);
        insert testProject;
        
        MPM4_BASE__Milestone1_Milestone__c testMilestone = new MPM4_BASE__Milestone1_Milestone__c(Name='Test Milestone', MPM4_BASE__Project__c=testProject.Id);
        insert testMilestone;
        
        MPM4_BASE__Milestone1_Task__c testTask = new MPM4_BASE__Milestone1_Task__c(Name='Test Task', MPM4_BASE__Project_Milestone__c=testMilestone.Id);
        insert testTask;
        
        MPM4_BASE__Milestone1_Task__c verifyAccountOnTask = [SELECT Account_Name__c FROM MPM4_BASE__Milestone1_Task__c WHERE Id = :testTask.Id LIMIT 1];
        
        System.assertEquals(testAccount.Id, verifyAccountOnTask.Account_Name__c);
	}
    
    static testmethod void shouldUpdateMPMPlusTaskWithAccountWhenAssignedToProject() {
        Account testAccount = new Account(Name='Test Account');
        insert testAccount;
        
		MPM4_BASE__Milestone1_Project__c testProject = new MPM4_BASE__Milestone1_Project__c(Name='Test Project');
        insert testProject;
        
        MPM4_BASE__Milestone1_Milestone__c testMilestone = new MPM4_BASE__Milestone1_Milestone__c(Name='Test Milestone', MPM4_BASE__Project__c=testProject.Id);
        insert testMilestone;
        
        MPM4_BASE__Milestone1_Task__c testTask = new MPM4_BASE__Milestone1_Task__c(Name='Test Task', MPM4_BASE__Project_Milestone__c=testMilestone.Id);
        insert testTask;
        
        MPM4_BASE__Milestone1_Task__c verifyAccountOnTask = [SELECT Account_Name__c FROM MPM4_BASE__Milestone1_Task__c WHERE Id = :testTask.Id LIMIT 1];
        
        System.assertNotEquals(testAccount.Id, verifyAccountOnTask.Account_Name__c);
        
        testProject.MPM4_BASE__Account__c = testAccount.Id;
        upsert testProject;
        
        verifyAccountOnTask = [SELECT Account_Name__c FROM MPM4_BASE__Milestone1_Task__c WHERE Id = :testTask.Id LIMIT 1];
        
        System.assertEquals(testAccount.Id, verifyAccountOnTask.Account_Name__c);
    }
}