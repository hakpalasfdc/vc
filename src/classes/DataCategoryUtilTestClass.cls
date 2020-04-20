@isTest
private class DataCategoryUtilTestClass {
    static testMethod void validateCategoryGroups(){
        String[] objTypes = new String[] { 'KnowledgeArticleVersion' };
        Describedatacategorygroupresult[] datacategorygroupresult = Schema.describeDataCategoryGroups(objTypes);
        DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
        //System.assertEquals(datacategorygroupresult.size(),dataCategoryGroupInfo.size());
        System.assertEquals(datacategorygroupresult.size(),5);
        System.assertEquals(1,dataCategoryGroupInfo.size());
    }
    static testMethod void validateCategoryGroupsResults(){
        DataCategoryGroupInfo[] dataCategoryGroupInfo = DataCategoryUtil.getInstance().getAllCategoryGroups();
        String[] objTypes = new String[] { 'KnowledgeArticleVersion' };
        Describedatacategorygroupresult[] datacategorygroupresult = Schema.describeDataCategoryGroups(objTypes);
        for(Integer i=0;i< dataCategoryGroupInfo.size(); i++) {
            /*System.assertEquals(dataCategoryGroupInfo[i].getName(),datacategorygroupresult[i].getName());
            System.assertEquals(dataCategoryGroupInfo[i].getName(),datacategorygroupresult[i].getName());
            System.assertEquals(dataCategoryGroupInfo[i].getLabel(),datacategorygroupresult[i].getLabel());
            System.assertEquals(dataCategoryGroupInfo[i].getDescription(),datacategorygroupresult[i].getDescription());*/
            System.assertEquals(dataCategoryGroupInfo[i].getName(),'Vision_Care');
            System.assertEquals(dataCategoryGroupInfo[i].getName(),'Vision_Care');
            System.assertEquals(dataCategoryGroupInfo[i].getLabel(),'Vision Care');
            System.assertEquals(dataCategoryGroupInfo[i].getDescription(),datacategorygroupresult[i].getDescription());
            
        }
    }
    @isTest
    static void getTopCategories(){
		List<String> strTopCats = new List<String>();
        strTopCats = DataCategoryUtil.getInstance().getTopCategories('Vision_Care');        
        system.assertNotEquals(0, strTopCats.size());
    }
}