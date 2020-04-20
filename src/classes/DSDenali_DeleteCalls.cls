/***************************************************
Jitesh Bhatia, Implementation Engineer, 10/25/2017

Brief Description: Deletes DialSource Denali calls.
****************************************************/
public class DSDenali_DeleteCalls {

	private static List<Task> tasksToDelete = new List<Task>();

	@InvocableMethod (label = 'DialSource Denali Delete Calls')
    public static void gatherData(List<Data> requests)
    {
    	Set<Id> taskIDs = new Set<Id>();

    	for (Data request : requests)
    		taskIDs.add(request.taskID);

    	queryData(taskIDs);
        deleteTasks();
    }

    private static void queryData(Set<Id> taskIDs)
    {
    	tasksToDelete = [SELECT Id FROM Task WHERE Id IN :taskIDs];
    }

    private static void deleteTasks()
    {
    	try{
    		delete tasksToDelete;
    	}

    	catch(DmlException e){
    		System.debug('The following error occured (DSDenali_DeleteCalls): ' + e);
    	}
    }

    public class Data
    {
        @InvocableVariable (required=true)
        public Id taskID;
    }
}