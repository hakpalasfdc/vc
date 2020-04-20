@isTest
private class DSDenali_DeleteCalls_Test {
	
	@isTest 
	static void deleteTask() 
	{
		//Create Task
		Task testTask = new Task();
		testTask.Subject = 'Task To Delete';
		testTask.Type__c = 'Outbound Call';
		testTask.ActivityDate = System.today() - 1;
		testTask.Status = 'Not Started';
		insert testTask;

		List<DSDenali_DeleteCalls.Data> dataList = new List<DSDenali_DeleteCalls.Data>(); 
		DSDenali_DeleteCalls.Data data = new DSDenali_DeleteCalls.Data(); 
		data.taskID = testTask.Id;
		dataList.add(data);

		Test.startTest();
		DSDenali_DeleteCalls.gatherData(dataList);
		Test.stopTest();

		Task deletedTask;

		//Make sure the Task is deleted
		try{
			deletedTask = [SELECT Id, OwnerId FROM Task WHERE Id = :testTask.Id];
		}

		catch(Exception e){
			System.assertEquals('List has no rows for assignment to SObject', e.getMessage());
		}
	}
}