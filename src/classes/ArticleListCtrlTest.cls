/* Created Date : 22nd June 2016.
   Related Case : #9251.
   Related Object : CatTabDefault__c (Custom Setting)
   Related Class : ArticleListCtr.
   Description : Code Coverage of related class shoud be 90 or greater than 90 %.
*/

@isTest
public class ArticleListCtrlTest{
    static testMethod void ArticleListCtrlTeatData(){
        List<CatTabDefault__c> my_SettingList = new List<CatTabDefault__c>();
        
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting  = new CatTabDefault__c(
            Name = 'Adjustments',Category_Links__c='Vision_Care:Adjustments',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000Cbgd',Search_Category__c='Sidebar-Adjustments');
        my_SettingList.add(my_Setting);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting1  = new CatTabDefault__c(
            Name = 'Authorization',Category_Links__c='Sidebar-Authorization',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbYT',Search_Category__c='Vision_Care:Authorization');
        my_SettingList.add(my_Setting1);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting2  = new CatTabDefault__c(
            Name = 'Benefits',Category_Links__c='Sidebar-Benefits',
            Default_Article__c='apex/SingleTopic_VFP?id=kA7U0000000Caq6',Search_Category__c='Vision_Care:Benefits');
        my_SettingList.add(my_Setting2);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting3  = new CatTabDefault__c(
            Name = 'Client Exceptions',Category_Links__c='Sidebar-Client-Exceptions',
            Default_Article__c='apex/SingleTopic_VFP?id=kA7U0000000CasW',Search_Category__c='Vision_Care:Client_Exceptions');
        my_SettingList.add(my_Setting3);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting4  = new CatTabDefault__c(
            Name = 'COB',Category_Links__c='Sidebar-COB',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000Cbbh',Search_Category__c='Vision_Care:COB');
        my_SettingList.add(my_Setting4);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting5  = new CatTabDefault__c(
            Name = 'Compliance',Category_Links__c='Sidebar-Compliance',
            Default_Article__c='apex/SingleTopic_VFP?id=kA7U0000000Casb',Search_Category__c='Vision_Care:Miscellaneous');
        my_SettingList.add(my_Setting5);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting6  = new CatTabDefault__c(
            Name = 'Determine Payment',Category_Links__c='Sidebar-Determining',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbaA',Search_Category__c='Vision_Care:Determine_Payment');
        my_SettingList.add(my_Setting6);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting7  = new CatTabDefault__c(
            Name = 'Dr Info',Category_Links__c='Sidebar-Doctor-Info',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbYn',Search_Category__c='Vision_Care:Network');
        my_SettingList.add(my_Setting7);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting8  = new CatTabDefault__c(
            Name = 'Eligibility',Category_Links__c='Sidebar-Eligibility',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbgT',Search_Category__c='Vision_Care:Eligibility');
        my_SettingList.add(my_Setting8);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting9  = new CatTabDefault__c(
            Name = 'Phone Book',Category_Links__c='Sidebar-Phone',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbhM',Search_Category__c='Vision_Care:Miscellaneous');
        my_SettingList.add(my_Setting9);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting10  = new CatTabDefault__c(
            Name = 'QNews',Category_Links__c='Sidebar-QNews',
            Default_Article__c='apex/QNewsList_VFP',Search_Category__c='Vision_Care:Customer_Care');
        my_SettingList.add(my_Setting10);
        // Create Test records for Custom  CatTabDefault__c Setting
        CatTabDefault__c my_Setting11  = new CatTabDefault__c(
            Name = 'Submit',Category_Links__c='Sidebar-Submit',
            Default_Article__c='apex/Multi_Topic_VFP?id=kA5U0000000CbXa',Search_Category__c='Vision_Care:Submitting');
        my_SettingList.add(my_Setting11);
        
        // Start Test
        Test.StartTest();
            // Insert Test records for Custom  CatTabDefault__c Setting
            insert my_SettingList;
            // Create Object of ArticleListCtrl Class and call the method for the code coverage
            ArticleListCtrl testObj = new ArticleListCtrl();
            testObj.SearchString = 'test';
            testObj.getPrevRequired();
            testObj.getNextRequired();
            testObj.previous();
            testObj.getCurrentPageNumber();
            testObj.next();
        Test.StopTest();
    }
}