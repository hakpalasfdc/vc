@isTest
//Test class for VSPR33c_Bus_Acc_Daily_Tier_Batch
private class VSPR33c_Bus_Acc_Daily_Tier_Test {
    public static Datetime twoMonthsAgo = Datetime.now().addDays(-60);
    @TestSetup
    static void testData(){
        //Used to test the exception in the class
        Exception_handler_Email__c toAddress = new Exception_handler_Email__c();
        toAddress.Name = 'test@vsp.com';
        insert toAddress;
        
        Premier_Admin_Email__c toAddress2 = new Premier_Admin_Email__c();
        toAddress2.Name = 'test2@vsp.com';
        insert toAddress2;
        
        ////Premier_Tier__c Affiliate 1
        Premier_Tier__c aff1 = new Premier_Tier__c();
        aff1.Name = 'Affiliate 1';
        aff1.Hierarchy_Action__c = 'Top_Tier';
        aff1.Description__c = 'Affiliate 1 Tier';
        aff1.Effective_Date__c = Date.today();
        aff1.Contract_Type__c = 'Affiliate';
        aff1.Status__c = 'Active';
        aff1.Order__c = 1;
        insert aff1;
        
        ////Premier_Tier__c Affiliate 2
        Premier_Tier__c aff2 = new Premier_Tier__c();
        aff2.Name = 'Affiliate 2';
        aff2.Hierarchy_Action__c = '<';
        aff2.Hierarchy_Selection__c = aff1.Id;
        aff2.Description__c = 'Affiliate 2 Tier';
        aff2.Effective_Date__c = Date.today();
        aff2.Contract_Type__c = 'Affiliate';
        aff2.Status__c = 'Active';
        aff2.Order__c = 2;
        insert aff2;
        
        ////Premier_Tier__c Independent 1
        Premier_Tier__c in1 = new Premier_Tier__c();
        in1.Name = 'Independent 1';
        in1.Hierarchy_Action__c = '<';
        in1.Hierarchy_Selection__c = aff2.Id;
        in1.Description__c = 'Independent 1 Tier';
        in1.Effective_Date__c = Date.today();
        in1.Contract_Type__c = 'Independent';
        in1.Status__c = 'Active';
        in1.Order__c = 3;
        insert in1;
        
        ////Premier_Tier__c Independent 2
        Premier_Tier__c in2 = new Premier_Tier__c();
        in2.Name = 'Independent 2';
        in2.Hierarchy_Action__c = '<';
        in2.Hierarchy_Selection__c = in1.Id;
        in2.Description__c = 'Independent 2 Tier';
        in2.Effective_Date__c = Date.today();
        in2.Contract_Type__c = 'Independent';
        in2.Status__c = 'Active';
        in2.Order__c = 4;
        insert in2;
        
        ////Premier_Tier__c School 1
        Premier_Tier__c school1 = new Premier_Tier__c();
        school1.Name = 'School 1';
        school1.Hierarchy_Action__c = '<';
        school1.Hierarchy_Selection__c = in2.Id;
        school1.Description__c = 'School 1 Tier';
        school1.Effective_Date__c = Date.today();
        school1.Contract_Type__c = 'School';
        school1.Status__c = 'Active';
        school1.Order__c = 5;
        insert school1;
        
        ////Premier_Tier__c School 2
        Premier_Tier__c school2 = new Premier_Tier__c();
        school2.Name = 'School 2';
        school2.Hierarchy_Action__c = '<';
        school2.Hierarchy_Selection__c = school1.Id;
        school2.Description__c = 'School 2 Tier';
        school2.Effective_Date__c = Date.today();
        school2.Contract_Type__c = 'School';
        school2.Status__c = 'Active';
        school2.Order__c = 6;
        insert school2;
    }
    
    public static testmethod void tierAtPracticeLevel(){
        VSPUtility.stopAccountTrigger=true;
        Premier_Tier__c aff1 = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Affiliate 1'];
        Premier_Tier__c in2 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'Independent 2'];
        Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id pracAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account pracAcc = new Account();
        pracAcc.Name = 'Practice Account';
        pracAcc.Tax_ID__c = '123456789';
        pracAcc.Vision_Care_Good_Standing__c = True;
        pracAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-2);
        pracAcc.Contract_Type__c = 'Affiliate';
        pracAcc.Applied_Tier__c = aff1.Id;
        pracAcc.Calculated_Tier__c = aff1.Id;
        pracAcc.VC__c = True;
        pracAcc.RecordTypeId = pracAccRecordTypeId;
        insert pracAcc;
        
        Account busAcc = new Account();
        busAcc.Name = 'Business Account 1';
        busAcc.Tax_ID__c = '111111111';
        busAcc.Vision_Care_Good_Standing__c = True;
        busAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-2);
        busAcc.Contract_Type__c = 'Affiliate';
        busAcc.Applied_Tier__c = aff1.Id;
        busAcc.Calculated_Tier__c = aff1.Id;
        busAcc.VC__c = True;
        busAcc.ParentId = pracAcc.Id;
        busAcc.RecordTypeId = busAccRecordTypeId;
        insert busAcc;
        
        Account busAcc1 = new Account();
        busAcc1.Name = 'Business Account 2';
        busAcc1.Tax_ID__c = '222222222';
        busAcc1.Vision_Care_Good_Standing__c = True;
        busAcc1.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc1.Contract_Type__c = 'Affiliate';
        busAcc1.VC__c = True;
        busAcc1.ParentId = pracAcc.Id;
        busAcc1.RecordTypeId = busAccRecordTypeId;
        insert busAcc1;
        
        Account busAcc2 = new Account();
        busAcc2.Name = 'Business Account 3';
        busAcc2.Tax_ID__c = '333333333';
        busAcc2.Vision_Care_Good_Standing__c = True;
        busAcc2.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc2.Contract_Type__c = 'Independent';
        busAcc2.VC__c = True;
        busAcc2.ParentId = pracAcc.Id;
        busAcc2.RecordTypeId = busAccRecordTypeId;
        insert busAcc2;
        
        
        Test.startTest();
        /*  String EXP = '0 0 1 * * ?';

VSPR33b_Bus_Acc_Daily_Tier_Sch sch = new VSPR33b_Bus_Acc_Daily_Tier_Sch();

system.Schedule('Business Account Daily Premier Tier Test', EXP, sch);*/
        
        VSPR33c_Bus_Acc_Daily_Tier_Batch ba = new VSPR33c_Bus_Acc_Daily_Tier_Batch();  
        Database.executeBatch(ba,100);
        
        Test.stopTest();
        
        busAcc1 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 2'];
        busAcc2 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 3'];
        system.assertEquals(aff1.Id, busAcc1.Applied_Tier__c);
        system.assertEquals(in2.Id, busAcc2.Applied_Tier__c);
    }
    
    public static testmethod void tierAtGRGLevelTaxId(){
        VSPUtility.stopAccountTrigger=true;
        Id grpTaxIdRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Tax ID Rollup').getRecordTypeId();
        Premier_Tier__c aff1 = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Affiliate 1'];
        Premier_Tier__c in2 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'Independent 2'];
        Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id pracAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account pracAcc = new Account();
        pracAcc.Name = 'Practice Account';
        pracAcc.Tax_ID__c = '123456789';
        pracAcc.Vision_Care_Good_Standing__c = True;
        pracAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-60);
        pracAcc.Contract_Type__c = 'Rollup';
        //   pracAcc.Applied_Tier__c = aff1.Id;
        //    pracAcc.Calculated_Tier__c = aff1.Id;
        pracAcc.VC__c = True;
        pracAcc.RecordTypeId = pracAccRecordTypeId;
        pracAcc.Premier_Tax_ID_Roll_Up_Account__c = True;
        insert pracAcc;
        
        Test.setCreatedDate(pracAcc.Id, twoMonthsAgo);
        
        Global_Rewards_Group__c taxIdGRG = new Global_Rewards_Group__c();
        taxIdGRG.Name = 'Tax ID GRG';
        taxIdGRG.Parent_Account__c = pracAcc.Id;
        taxIdGRG.Start_Date__c = Date.today();
        taxIdGRG.RecordTypeId = grpTaxIdRecordTypeId;
        taxIdGRG.Contract_Type__c = 'Affiliate';
        taxIdGRG.Applied_Tier__c = aff1.Id;
        taxIdGRG.Calculated_Tier__c = aff1.Id; 
        insert taxIdGRG;
        
        Global_Rewards_Group_Relationship__c pracGRGR = new Global_Rewards_Group_Relationship__c();
        pracGRGR.Child_Account__c = pracAcc.Id;
        pracGRGR.Global_Rewards_Group__c = taxIdGRG.Id;
        pracGRGR.Start_Date__c = Date.today();
        insert pracGRGR;
        
        
        Account busAcc = new Account();
        busAcc.Name = 'Business Account 1';
        busAcc.Tax_ID__c = '111111111';
        busAcc.Vision_Care_Good_Standing__c = True;
        busAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-60);
        busAcc.Contract_Type__c = 'Affiliate';
        busAcc.Applied_Tier__c = aff1.Id;
        busAcc.Calculated_Tier__c = aff1.Id;
        busAcc.VC__c = True;
        busAcc.ParentId = pracAcc.Id;
        busAcc.RecordTypeId = busAccRecordTypeId;
        insert busAcc;
        
        Test.setCreatedDate(busAcc.Id, twoMonthsAgo);
        
        Global_Rewards_Group_Relationship__c busGRGR = new Global_Rewards_Group_Relationship__c();
        busGRGR.Child_Account__c = busAcc.Id;
        busGRGR.Global_Rewards_Group__c = taxIdGRG.Id;
        busGRGR.Start_Date__c = Date.today();
        insert busGRGR;
        
        
        Account busAcc1 = new Account();
        busAcc1.Name = 'Business Account 2';
        busAcc1.Tax_ID__c = '222222222';
        busAcc1.Vision_Care_Good_Standing__c = True;
        busAcc1.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc1.Contract_Type__c = 'Affiliate';
        busAcc1.VC__c = True;
        busAcc1.ParentId = pracAcc.Id;
        busAcc1.RecordTypeId = busAccRecordTypeId;
        insert busAcc1;
        
        Account busAcc2 = new Account();
        busAcc2.Name = 'Business Account 3';
        busAcc2.Tax_ID__c = '333333333';
        busAcc2.Vision_Care_Good_Standing__c = True;
        busAcc2.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc2.Contract_Type__c = 'Independent';
        busAcc2.VC__c = True;
        busAcc2.ParentId = pracAcc.Id;
        busAcc2.RecordTypeId = busAccRecordTypeId;
        insert busAcc2;
        
        
        Test.startTest();
        /*  String EXP = '0 0 1 * * ?';

VSPR33b_Bus_Acc_Daily_Tier_Sch sch = new VSPR33b_Bus_Acc_Daily_Tier_Sch();

system.Schedule('Business Account Daily Premier Tier Test', EXP, sch);*/
        
        VSPR33c_Bus_Acc_Daily_Tier_Batch ba = new VSPR33c_Bus_Acc_Daily_Tier_Batch();  
        Database.executeBatch(ba,100);
        
        Test.stopTest();
        
        busAcc1 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 2'];
        busAcc2 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 3'];
        system.assertEquals(aff1.Id, busAcc1.Applied_Tier__c);
        system.assertEquals(in2.Id, busAcc2.Applied_Tier__c);
    }
    
    public static testmethod void tierAtGRGLevelTaxIdFalse(){
        VSPUtility.stopAccountTrigger=true;
        Id grpRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        Premier_Tier__c aff1 = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Affiliate 1'];
        Premier_Tier__c in1 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'Independent 1'];
        Premier_Tier__c school2 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'School 2'];
        Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id pracAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account pracAcc = new Account();
        pracAcc.Name = 'Practice Account';
        pracAcc.Tax_ID__c = '123456789';
        pracAcc.Vision_Care_Good_Standing__c = True;
        pracAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-60);
        pracAcc.Contract_Type__c = 'Conflict';
        //   pracAcc.Applied_Tier__c = aff1.Id;
        //    pracAcc.Calculated_Tier__c = aff1.Id;
        pracAcc.VC__c = True;
        pracAcc.RecordTypeId = pracAccRecordTypeId;
        pracAcc.Premier_Tax_ID_Roll_Up_Account__c = False;
        insert pracAcc;
        
        
        Test.setCreatedDate(pracAcc.Id, twoMonthsAgo);
        
        Account busAcc = new Account();
        busAcc.Name = 'Business Account 1';
        busAcc.Tax_ID__c = '111111111';
        busAcc.Vision_Care_Good_Standing__c = True;
        busAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-60);
        busAcc.Contract_Type__c = 'Affiliate';
        busAcc.Applied_Tier__c = aff1.Id;
        busAcc.Calculated_Tier__c = aff1.Id;
        busAcc.VC__c = True;
        busAcc.ParentId = pracAcc.Id;
        busAcc.RecordTypeId = busAccRecordTypeId;
        insert busAcc;
        
        Test.setCreatedDate(busAcc.Id, twoMonthsAgo);
        
        Global_Rewards_Group__c con1GRG = new Global_Rewards_Group__c();
        con1GRG.Name = 'PREMIER - '+pracAcc.Tax_ID__c+ ' - ' + busAcc.Contract_Type__c;
        con1GRG.Parent_Account__c = pracAcc.Id;
        con1GRG.Start_Date__c = Date.today();
        con1GRG.RecordTypeId = grpRecordTypeId;
        con1GRG.Contract_Type__c = 'Affiliate';
        con1GRG.Applied_Tier__c = aff1.Id;
        con1GRG.Calculated_Tier__c = aff1.Id; 
        insert con1GRG;
        
        
        Global_Rewards_Group_Relationship__c busGRGR = new Global_Rewards_Group_Relationship__c();
        busGRGR.Child_Account__c = busAcc.Id;
        busGRGR.Global_Rewards_Group__c = con1GRG.Id;
        busGRGR.Start_Date__c = Date.today();
        insert busGRGR;
        
        
        Account busAcc1 = new Account();
        busAcc1.Name = 'Business Account 2';
        busAcc1.Tax_ID__c = '222222222';
        busAcc1.Vision_Care_Good_Standing__c = True;
        busAcc1.Vision_Care_Effective_Date__c = Date.today().addDays(-60);
        busAcc1.Contract_Type__c = 'Independent';
        busAcc1.VC__c = True;
        busAcc1.ParentId = pracAcc.Id;
        busAcc1.RecordTypeId = busAccRecordTypeId;
        busAcc1.Applied_Tier__c = in1.Id;
        busAcc1.Calculated_Tier__c = in1.Id;
        insert busAcc1;
        
        Test.setCreatedDate(busAcc1.Id, twoMonthsAgo);
        
        
        Global_Rewards_Group__c con2GRG = new Global_Rewards_Group__c();
        con2GRG.Name = 'PREMIER - '+pracAcc.Tax_ID__c+ ' - ' + busAcc1.Contract_Type__c;
        con2GRG.Parent_Account__c = pracAcc.Id;
        con2GRG.Start_Date__c = Date.today();
        con2GRG.RecordTypeId = grpRecordTypeId;
        con2GRG.Contract_Type__c = 'Independent';
        con2GRG.Applied_Tier__c = in1.Id;
        con2GRG.Calculated_Tier__c = in1.Id; 
        insert con2GRG;
        
        
        Global_Rewards_Group_Relationship__c bus2GRGR = new Global_Rewards_Group_Relationship__c();
        bus2GRGR.Child_Account__c = busAcc1.Id;
        bus2GRGR.Global_Rewards_Group__c = con2GRG.Id;
        bus2GRGR.Start_Date__c = Date.today();
        insert bus2GRGR;
        
        Account busAcc2 = new Account();
        busAcc2.Name = 'Business Account 3';
        busAcc2.Tax_ID__c = '333333333';
        busAcc2.Vision_Care_Good_Standing__c = True;
        busAcc2.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc2.Contract_Type__c = 'Independent';
        busAcc2.VC__c = True;
        busAcc2.ParentId = pracAcc.Id;
        busAcc2.RecordTypeId = busAccRecordTypeId;
        insert busAcc2;
        
        
        Account busAcc4 = new Account();
        busAcc4.Name = 'Business Account 4';
        busAcc4.Tax_ID__c = '444444444';
        busAcc4.Vision_Care_Good_Standing__c = True;
        busAcc4.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc4.Contract_Type__c = 'School';
        busAcc4.VC__c = True;
        busAcc4.ParentId = pracAcc.Id;
        busAcc4.RecordTypeId = busAccRecordTypeId;
        insert busAcc4;
        
        
        Test.startTest();
        /*  String EXP = '0 0 1 * * ?';

VSPR33b_Bus_Acc_Daily_Tier_Sch sch = new VSPR33b_Bus_Acc_Daily_Tier_Sch();

system.Schedule('Business Account Daily Premier Tier Test', EXP, sch);*/
        
        VSPR33c_Bus_Acc_Daily_Tier_Batch ba = new VSPR33c_Bus_Acc_Daily_Tier_Batch();  
        Database.executeBatch(ba,100);
        
        Test.stopTest();
        
        busAcc2 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 3'];
        busAcc4 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 4'];
        system.assertEquals(in1.Id, busAcc2.Applied_Tier__c);
        system.assertEquals(school2.Id, busAcc4.Applied_Tier__c);
    }
    
    public static testmethod void newPracticeandBusAccMidMonth(){
        VSPUtility.stopAccountTrigger=true;
        Id grpRecordTypeId = Schema.SObjectType.Global_Rewards_Group__c.getRecordTypeInfosByName().get('Contract Type').getRecordTypeId();
        Premier_Tier__c aff2 = [SELECT Id FROM Premier_Tier__c WHERE Name = 'Affiliate 2'];
        Premier_Tier__c in2 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'Independent 2'];
        Premier_Tier__c school2 = [SELECT Id, Status__c, Order_Formula__c FROM Premier_Tier__c WHERE Name = 'School 2'];
        Id busAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id pracAccRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
        
        Account pracAcc = new Account();
        pracAcc.Name = 'Practice Account';
        pracAcc.Tax_ID__c = '123456789';
        pracAcc.Vision_Care_Good_Standing__c = True;
        pracAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        // pracAcc.Contract_Type__c = 'Conflict';
        //   pracAcc.Applied_Tier__c = aff1.Id;
        //    pracAcc.Calculated_Tier__c = aff1.Id;
        pracAcc.VC__c = True;
        pracAcc.RecordTypeId = pracAccRecordTypeId;
        pracAcc.Premier_Tax_ID_Roll_Up_Account__c = True;
        insert pracAcc;
        
        
        
        
        Account busAcc = new Account();
        busAcc.Name = 'Business Account 1';
        busAcc.Tax_ID__c = '111111111';
        busAcc.Vision_Care_Good_Standing__c = True;
        busAcc.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc.Contract_Type__c = 'Affiliate';
        busAcc.VC__c = True;
        busAcc.ParentId = pracAcc.Id;
        busAcc.RecordTypeId = busAccRecordTypeId;
        insert busAcc;
        
        Account busAcc1 = new Account();
        busAcc1.Name = 'Business Account 2';
        busAcc1.Tax_ID__c = '222222222';
        busAcc1.Vision_Care_Good_Standing__c = True;
        busAcc1.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc1.Contract_Type__c = 'Independent';
        busAcc1.VC__c = True;
        busAcc1.ParentId = pracAcc.Id;
        busAcc1.RecordTypeId = busAccRecordTypeId;
        insert busAcc1;  
        
        Account busAcc2 = new Account();
        busAcc2.Name = 'Business Account 3';
        busAcc2.Tax_ID__c = '333333333';
        busAcc2.Vision_Care_Good_Standing__c = True;
        busAcc2.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc2.Contract_Type__c = 'Independent';
        busAcc2.VC__c = True;
        busAcc2.ParentId = pracAcc.Id;
        busAcc2.RecordTypeId = busAccRecordTypeId;
        insert busAcc2;
        
        
        Account busAcc4 = new Account();
        busAcc4.Name = 'Business Account 4';
        busAcc4.Tax_ID__c = '444444444';
        busAcc4.Vision_Care_Good_Standing__c = True;
        busAcc4.Vision_Care_Effective_Date__c = Date.today().addDays(-1);
        busAcc4.Contract_Type__c = 'School';
        busAcc4.VC__c = True;
        busAcc4.ParentId = pracAcc.Id;
        busAcc4.RecordTypeId = busAccRecordTypeId;
        insert busAcc4;
        
        
        Test.startTest();
        /*  String EXP = '0 0 1 * * ?';

VSPR33b_Bus_Acc_Daily_Tier_Sch sch = new VSPR33b_Bus_Acc_Daily_Tier_Sch();

system.Schedule('Business Account Daily Premier Tier Test', EXP, sch);*/
        
        VSPR33c_Bus_Acc_Daily_Tier_Batch ba = new VSPR33c_Bus_Acc_Daily_Tier_Batch();  
        Database.executeBatch(ba,100);
        
        Test.stopTest();
        busAcc = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 1'];  
        busAcc1 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 2'];
        busAcc2 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 3'];
        busAcc4 = [SELECT Id, Applied_Tier__c, Calculated_Tier__c FROM Account WHERE Name = 'Business Account 4'];
        system.assertEquals(aff2.Id, busAcc.Applied_Tier__c);
        system.assertEquals(in2.Id, busAcc1.Applied_Tier__c);
        system.assertEquals(in2.Id, busAcc2.Applied_Tier__c);
        system.assertEquals(school2.Id, busAcc4.Applied_Tier__c);
    }
}