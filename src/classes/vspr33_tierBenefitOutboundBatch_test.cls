@isTest public class vspr33_tierBenefitOutboundBatch_test {

    @IsTest
    static void testmethod1(){
        
        Exception_Handler_Email__c email = new Exception_Handler_Email__c();
        email.Name = 'test@test.net';
        insert email;
        
        Premier_Tier__c pt = new Premier_Tier__c();
        pt.Name = 'Premier Test Tier 1';
        pt.Hierarchy_Action__c = 'Top_Tier';
        pt.Description__c = 'Qwerty';
        pt.Effective_Date__c = System.today();
        pt.Contract_Type__c = 'CAT2';
        insert pt;

        List<Premier_Benefit__c> pbList = new List<Premier_Benefit__c>();

        Premier_Benefit__c pb1 = new Premier_Benefit__c();
        pb1.Name = 'Premier Test Benefit 1';
        pb1.Description__c = 'Qwerty';
        pb1.Benefit_Type__c = 'Currency';
        pb1.Benefit_Amount__c = 1234;
        pb1.Effective_Date__c = System.today();
        pb1.Status__c = 'Active';
        pbList.add(pb1);
        //insert pb;

        Premier_Benefit__c pb2 = new Premier_Benefit__c();
        pb2.Name = 'Premier Test Benefit 2';
        pb2.Description__c = 'Qwerty';
        pb2.Benefit_Type__c = 'Checkbox';
        pb2.Benefit_Checkbox__c = true;
        pb2.Effective_Date__c = System.today();
        pb2.Status__c = 'Active';
        pbList.add(pb2);

        insert pbList;

        /*Premier_Tier__c pt1 = [Select id from Premier_Tier__c where Name = 'Premier Test Tier 1'];
        Premier_Benefit__c pb1 = [Select Id from Premier_Benefit__c where Name = 'Premier Test Benefit 1'];*/

        //Test.startTest();

        List<Tier_Benefit__c> tbList = new List<Tier_Benefit__c>();

        Tier_Benefit__c tb1 = new Tier_Benefit__c();
        tb1.Premier_Tier__c = pt.Id;
        tb1.Benefit__c = pbList[0].Id;
        //insert tb;
        tbList.add(tb1);

        Tier_Benefit__c tb2 = new Tier_Benefit__c();
        tb2.Premier_Tier__c = pt.Id;
        tb2.Benefit__c = pbList[1].Id;
        //insert tb;
        tbList.add(tb2);

        insert tbList;

        //Test.stopTest();

        List<Tier_Benefit__c> benefitsList = [Select id, Send_Outbound_Message__c from Tier_Benefit__c];
        //System.assertEquals(true, tb1.Send_Outbound_Message__c);

        for(Tier_Benefit__c t: benefitsList){
            System.assertEquals(true, t.Send_Outbound_Message__c);
        }

        Tier_Benefit__c tb3 = benefitsList[0];
        tb3.Send_Outbound_Message__c = false;
        update tb3;

        Test.startTest();

        vspr33_tierBenefitOutboundBatch job = new vspr33_tierBenefitOutboundBatch();
        Id jobId = Database.executeBatch(job);

        Test.stopTest();

        Tier_Benefit__c tb4 = [Select id, Send_Outbound_Message__c from Tier_Benefit__c where id = :tb3.Id];
        System.assertEquals(true, tb4.Send_Outbound_Message__c);

    }
}