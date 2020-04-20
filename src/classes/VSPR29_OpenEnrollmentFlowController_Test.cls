//Test class for OpenEnrollmentFlowController
@isTest
private class VSPR29_OpenEnrollmentFlowController_Test {
    private static testMethod void testFinishLocation(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'VSP Full Quest User' LIMIT 1];
        User u = new User();
        u.LastName = 'Test';
        u.Alias = 'Test007';
        u.Username = 'Test007@noemail.com.test';
        u.Email = 'Test007@noemail.com';
        u.profileId = p.Id;   
        u.emailencodingkey = 'UTF-8';
        u.languagelocalekey = 'en_US';
        u.localesidkey = 'en_US';
        u.timezonesidkey = 'America/Los_Angeles';
        u.country = 'United States';
        insert u;
        
        system.runAs(u){
            PageReference pageRef = Page.OpenEnrollmentFlow_VFP;
            Test.setCurrentPage(pageRef);
            
            OpenEnrollmentFlowController fc = new OpenEnrollmentFlowController();
            fc.Open_Enrollment = 'Yes';
            //Any fake value should work
            fc.QuestId = '01rU0000000UYRk';
            fc.finishLocation = new Pagereference('/apex/QuestTab?sfdc.tabName=' + fc.QuestId);              
            
            system.assertNotEquals(null, fc.finishLocation);
            system.assertNotEquals('No', fc.Open_Enrollment, 'Yes');
            system.assertNotEquals(null, fc.QuestId);
            system.debug('QuestId ' + fc.QuestId);
            system.assertEquals(null, fc.flowInstance);
            system.debug('flowInstance ' + fc.flowInstance);
        }
    }
}