@isTest
public class ProcessingTabController_Test {
    /*
    public static testMethod void testController(){
        
        CatTabDefault__c st1 = new CatTabDefault__c();
        st1.Name = 'Processing';
        st1.Category_Links__c = 'Sidebar-Processing1';
        st1.Default_Article__c = 'apex/Multi_Topic_VFP?id=kA50B000000L0YB';
        insert st1;
        System.debug('st1 ' + st1);
        
        Category_Tab_Link__kav st = new Category_Tab_Link__kav();
        st.Title = 'Unit Testing';
        st.UrlName = 'Sidebar-Processing1';
        st.Links__c = 'apex/Multi_Topic_VFP?id=kA50B000000L0YB';
        insert st;

        
        Category_Tab_Link__kav stQ = [SELECT Id, Title, UrlName, KnowledgeArticleId, VersionNumber FROM Category_Tab_Link__kav WHERE Id =: st.Id];
        System.debug('stQ ' + stQ);
        //Publish Article
        KbManagement.PublishingService.publishArticle(stQ.KnowledgeArticleId, True);
        
        
        List<Category_Tab_Link__kav> LinkTest =   [SELECT Links__c FROM Category_Tab_Link__kav WHERE PublishStatus = 'online' AND Language = 'en_US'];
        
            system.debug('LinkTest' + LinkTest);
        
        
        List<CatTabDefault__c> ctdList = new List<CatTabDefault__c>();
        
        ProcessingTabController controller = new ProcessingTabController();
        
        ctdList.add(st1);
        
        controller.catset = ctdList;
        
        string links =  controller.getProcessingcatlinks();
        
        system.assertNotEquals(null,links);
        
        
        
    }
    */
}