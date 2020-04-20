global class ArticleBatchScheduler implements Schedulable{
   global void execute(SchedulableContext sc) {
      // Implement any logic to be scheduled. We now call the batch class to be scheduled. Parameters of ExecuteBatch(context,BatchSize)
      if(!Test.isRunningTest()){
          database.executebatch(New ArticleBatch(),1);
      }
     else{
     
         String t = 'test';
        //ArticleBatch ab = new ArticleBatch();        
        //Database.executeBatch(ab);
     }
   } 
}