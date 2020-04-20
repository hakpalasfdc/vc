@isTest
private class CDSearchControllerTestClass {
    static testMethod void validateDataCategoryGroupInfo(){
        DataCategoryGroupInfo[] dataCategoryGroupInfo =
        DataCategoryUtil.getInstance().getAllCategoryGroups();
        CDSearchController cdSearchControllerObj = new CDSearchController();
        System.assertEquals(cdSearchControllerObj.getDataCategoryGroupInfo().size(),
        dataCategoryGroupInfo.size());
    }

    static testMethod void testClassVariables() {
        CDSearchController cdSearchControllerObj = new CDSearchController();
        cdSearchControllerObj.refreshSearchResult();
        System.assertEquals(cdSearchControllerObj.getCurrentPageNumber(),1.0);
        cdSearchControllerObj.next();
        System.assertEquals(cdSearchControllerObj.getCurrentPageNumber(),1.0);
        cdSearchControllerObj.previous();
        System.assertEquals(cdSearchControllerObj.getCurrentPageNumber(),1.0);
        System.assertEquals(cdSearchControllerObj.getPrevRequired(),false);
        System.assertEquals(cdSearchControllerObj.getNextRequired(),false);
    }

    static testMethod void validateCategoryKeyword() {
        CDSearchController cdSearchControllerObj = new CDSearchController();
        DataCategoryGroupInfo[] categoryGroups =
        DataCategoryUtil.getInstance().getAllCategoryGroups();
        String categoryCondition = '';
        for (DataCategoryGroupInfo categoryGroup : categoryGroups) {
            ApexPages.currentPage().getParameters().put('categoryType_'+categoryGroup.getName(),'All');
            if(categoryCondition==''){
                categoryCondition=categoryCondition+categoryGroup.getName() + ':' +
                System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
            }else {
                categoryCondition=categoryCondition + ',' +categoryGroup.getName() + ':' +
                System.currentPageReference().getParameters().Get('categoryType_'+categoryGroup.getName());
            }
        }
        System.assertEquals(categoryCondition, cdSearchControllerObj.getCategoryKeyword());
    }
}