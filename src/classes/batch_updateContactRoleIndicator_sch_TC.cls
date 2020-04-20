@isTest
private class batch_updateContactRoleIndicator_sch_TC {
    
    public static String CRON_EXP = '0 00 00 * * ?';
    
    static testmethod void test() {
        
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Account a = new Account();
        a.Name = 'testAcct';
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.LastName = 'testLastName';
        insert c;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = a.Id;
        cr.Contact__c = c.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Start_Date__c = system.today();
        insert cr;
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'PRSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        insert gt;
        
      //  Test.startTest();
        Network_Relationship__c nr = new Network_Relationship__c();
        nr.Contact_Role__c = cr.Id;
        nr.Program_ID__c = gt.Id;
        nr.Program_Effective_Date__c = system.today();
        insert nr;
     //   Test.stopTest();
        Test.startTest();
        
        String jobId = batch_updateContactRoleIndicator_sch.scheduleMe();
        
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
        
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Account a = new Account();
        a.Name = 'testAcct';
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.LastName = 'testLastName';
        insert c;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = a.Id;
        cr.Contact__c = c.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Start_Date__c = system.today();
        insert cr;
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'PRSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        insert gt;
        
        Test.startTest();
        Network_Relationship__c nr = new Network_Relationship__c();
        nr.Contact_Role__c = cr.Id;
        nr.Program_ID__c = gt.Id;
        nr.Program_Effective_Date__c = system.today() - 33;
        nr.Program_End_Date__c = system.today() - 3;
        insert nr;
        Test.stopTest();
      //  Test.startTest();
        
        String jobId = batch_updateContactRoleIndicator_sch.scheduleMe();
        
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
        
      //  Test.stopTest();
        
    }
    
    static testmethod void test3() {
        
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Account a = new Account();
        a.Name = 'testAcct';
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.LastName = 'testLastName';
        insert c;
        
        Contact_Role__c cr = new Contact_Role__c();
        cr.Account__c = a.Id;
        cr.Contact__c = c.Id;
        cr.Type__c = 'Doctor-Owner';
        cr.Start_Date__c = system.today();
        insert cr;
        
        General_Table__c gt = new General_Table__c();
        gt.Name = 'PRSP';
        gt.Table__c = 'PRSP';
        gt.Status__c = 'Active';
        insert gt;
        
        Test.startTest();
        
        String jobId = batch_updateContactRoleIndicator_sch.scheduleMe();
        
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