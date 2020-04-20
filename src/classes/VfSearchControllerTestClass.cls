@isTest
private class VfSearchControllerTestClass {
    static testMethod void validateDataCategoryGroupInfo(){
        DataCategoryGroupInfo[] dataCategoryGroupInfo =
        DataCategoryUtil.getInstance().getAllCategoryGroups();
        VfSearchController vfSearchControllerObj = new VfSearchController();
        System.assertEquals(vfSearchControllerObj.getDataCategoryGroupInfo().size(),
        dataCategoryGroupInfo.size());
    }

    static testMethod void testClassVariables() {
        VfSearchController vfSearchControllerObj = new VfSearchController();
        vfSearchControllerObj.refreshSearchResult();
        System.assertEquals(vfSearchControllerObj.getCurrentPageNumber(),1.0);
        vfSearchControllerObj.next();
        System.assertEquals(vfSearchControllerObj.getCurrentPageNumber(),1.0);
        vfSearchControllerObj.previous();
        System.assertEquals(vfSearchControllerObj.getCurrentPageNumber(),1.0);
        System.assertEquals(vfSearchControllerObj.getPrevRequired(),false);
        System.assertEquals(vfSearchControllerObj.getNextRequired(),false);
    }
 
    static testMethod void validateCategoryKeyword() {
        VfSearchController vfSearchControllerObj = new VfSearchController();
        PageReference qSearchPage = new PageReference('/apex/qsearch_vfp');
        Test.setCurrentPage(qSearchPage);
        
        DataCategoryGroupInfo[] categoryGroups = DataCategoryUtil.getInstance().getAllCategoryGroups();
        String categoryCondition = '';
        for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
            ApexPages.currentPage().getParameters().put('categoryType_'+categoryGroup.getName(),'Benefits');
            if(categoryCondition==''){
                categoryCondition=categoryCondition+categoryGroup.getName() + ':' +
                System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
            }else {
                categoryCondition=categoryCondition + ',' +categoryGroup.getName() + ':' +
                System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
            }
        }
        System.assertEquals('Vision_Care:Benefits', vfSearchControllerObj.getCategoryKeyword());
    }
    
    @isTest
    static void getTopCategories(){
        VfSearchController vfSearchControllerObj = new VfSearchController();
        List<String> topCategories = new List<String>();
        topCategories = vfSearchControllerObj.getTopCategories();
        system.assertNotEquals(0, topCategories.size());
    }
    
}