/*
@isTest
private class batchConvertD2CLeads_sch_TC {

   public static String CRON_EXP = '0 00 00 * * ?';

   static testmethod void test() {
   
      Lead l = new Lead();
      l.LastName = 'testLast';
      l.Lead_Type__c = 'D2C';
      l.Status = 'Open';
      l.LeadSource = 'Inbound Call';
      l.Company = 'testCompany';
      l.Subscriber_Status__c = 'blah';
      l.Purchase_Channel__c = 'blah';
      l.Consumer_ID__c = '9234987394';
      insert l;
      
      Test.startTest();

      String jobId = batchConvertD2CLeads_schedulable.scheduleMe();
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      //System.assertEquals('2022-03-15 00:00:00', 
      //   String.valueOf(ct.NextFireTime));

      Test.stopTest();

   }
   
   static testmethod void test2() {
      
      Account a = new Account();
      a.Name = 'testAcct';
      insert a;
      
      Contact c1 = new Contact();
      c1.AccountId = a.Id;
      c1.LastName = 'testLast';
      c1.Consumer_ID__c = '9234987394';
      c1.D2C_Contact__c = TRUE;
      insert c1;
      
      Lead l = new Lead();
      l.FirstName = 'testFirst';
      l.LastName = 'testLast';
      l.Gender__c = 'Female';
      l.D2C_Pre_Sales_Opt_In__c = TRUE;
      l.Email = 'bob@gmail.com';
      l.Phone = '9999999999';
      l.Date_of_Birth__c = date.newInstance(2018,1,1);
      l.Street = '1234 Main St.';
      l.City = 'Mainville';
      l.State = 'TN';
      l.PostalCode = '37087';
      l.Subscriber_Status__c = 'blah';
      //l.IP_Enrollment_Date__c = date.newInstance(2017,1,1);
      l.IP_Purchase_Date__c = date.newInstance(2017,1,1);
      l.Purchase_Channel__c = 'test';
      l.Country = 'US';
      l.Lead_Type__c = 'D2C';
      l.Status = 'Open';
      l.LeadSource = 'Inbound Call';
      l.Company = 'testCompany';
      l.Subscriber_Status__c = 'blah';
      l.Purchase_Channel__c = 'blah';
      l.Consumer_ID__c = '9234987394';
      insert l;
      
      Test.startTest();

      String jobId = batchConvertD2CLeads_schedulable.scheduleMe();
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      //System.assertEquals('2022-03-15 00:00:00', 
      //   String.valueOf(ct.NextFireTime));

      Test.stopTest();

   }
}
*/
@isTest //Ian Cornish WIP
private class batchConvertD2CLeads_sch_TC {

   public static String CRON_EXP = '0 00 00 * * ?';

   static testmethod void test() {
   
      Lead l = new Lead();
      l.LastName = 'testLast';
      l.Lead_Type__c = 'D2C';
      l.Status = 'Open';
      l.LeadSource = 'Inbound Call';
      //l.Company = 'testCompany';
      l.Subscriber_Status__c = 'blah';
      l.Purchase_Channel__c = 'blah';
      l.Consumer_ID__c = '9234987394';
      insert l;
      
      Test.startTest();

      String jobId = batchConvertD2CLeads_schedulable.scheduleMe();
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      //System.assertEquals('2022-03-15 00:00:00', 
      //   String.valueOf(ct.NextFireTime));

      Test.stopTest();

   }
   
   static testmethod void test2() {
      
      Account a = new Account();
      a.Name = 'testAcct';
      insert a;
      
      Account c1 = new Account();
      //c1.Id = a.Id;
      c1.LastName = 'testLast';
      c1.Consumer_ID__pc = '9234987394';
      c1.D2C_Contact__pc = TRUE;
      insert c1;
      
      Lead l = new Lead();
      l.FirstName = 'testFirst';
      l.LastName = 'testLast';
      l.Gender__c = 'Female';
      l.D2C_Pre_Sales_Opt_In__c = TRUE;
      l.Email = 'bob@gmail.com';
      l.Phone = '9999999999';
      l.Date_of_Birth__c = date.newInstance(2018,1,1);
      l.Street = '1234 Main St.';
      l.City = 'Mainville';
      l.State = 'TN';
      l.PostalCode = '37087';
      l.Subscriber_Status__c = 'blah';
      //l.IP_Enrollment_Date__c = date.newInstance(2017,1,1);
      l.IP_Purchase_Date__c = date.newInstance(2017,1,1);
      l.Purchase_Channel__c = 'test';
      l.Country = 'US';
      l.Lead_Type__c = 'D2C';
      l.Status = 'Open';
      l.LeadSource = 'Inbound Call';
      //l.Company = 'testCompany';
      l.Subscriber_Status__c = 'blah';
      l.Purchase_Channel__c = 'blah';
      l.Consumer_ID__c = '9234987394';
      insert l;
      
      Test.startTest();

      String jobId = batchConvertD2CLeads_schedulable.scheduleMe();
         
      // Get the information from the CronTrigger API object
      CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, 
         NextFireTime
         FROM CronTrigger WHERE id = :jobId];

      // Verify the expressions are the same
      System.assertEquals(CRON_EXP, 
         ct.CronExpression);

      // Verify the job has not run
      System.assertEquals(0, ct.TimesTriggered);

      // Verify the next time the job will run
      //System.assertEquals('2022-03-15 00:00:00', 
      //   String.valueOf(ct.NextFireTime));

      Test.stopTest();

   }
}