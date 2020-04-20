@isTest
public class TestDataFactory {

    public static Id createAccount(String name){
        Account account = new Account(Name = name);
        insert account;
        return account.id;
    }
     public static Id createPersonAccount(String name){
        Account account = new Account(lastName = name);
        RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
        account.Recordtypeid = personAccountRecordType.id;
        insert account;
        return account.id;
    }
    public static MemberPlan createMemberPlan(id aid, String name){
        MemberPlan mp = new MemberPlan(Name = name, MemberId = aid);
        insert mp;
        return mp;
    }
    
    public static Id createArticleEditors(String aType, User u){
        Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Editors').getRecordTypeId();
        Article_Permission__c aPerm = new Article_Permission__c(User__c = u.id,Article_Type__c = aType );
        insert aPerm;
        aPerm.RecordTypeId = rtId;
        update aPerm;
        return aPerm.id;
    }
    
    public static Id createGroupArticleOwners(String aType,String gpEmail){
        Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Article Owners').getRecordTypeId();
        Article_Permission__c aPerm = new Article_Permission__c(Article_Type__c = aType ,Group_Email__c = gpEmail, RecordTypeId = rtId);
        insert aPerm;
        return aPerm.id;
    }
    
    public static Id createUserArticleOwners(String aType,User u){
        Id rtId = Schema.SObjectType.Article_Permission__c.getRecordTypeInfosByName().get('Article Owners').getRecordTypeId();
        Article_Permission__c aPerm = new Article_Permission__c(Article_Type__c = aType ,User__c = u.id, RecordTypeId = rtId);
        insert aPerm;
        return aPerm.id;
    }
    public static Knowledge__kav createKnowledge(string RTName){
        Id rtId = Schema.SObjectType.Knowledge__kav.getRecordTypeInfosByName().get(RTName).getRecordTypeId();
        
        Knowledge__kav article = new Knowledge__kav(
            Title=System.now().millisecond() + 'test',
            summary=System.now().millisecond() + 'xyz',
            urlname=System.now().millisecond() + 'xyz');
        article.recordtypeId = rtId;
        insert article;
        return article;    
    }
    
   public static User createUser(String first, String last){
        
         //Create user
         Profile VSPProfile = [SELECT Id FROM Profile WHERE Name LIKE '%VSP%' Limit 1];
         User user1 = new User(
         Username = System.now().millisecond() + First+ 'test12345@test.com',
         ProfileId = VSPProfile.Id,
         Alias = 'tst1'+first.left(4),
         Email = last+'test12345@test.com',
         EmailEncodingKey = 'UTF-8',
         LastName = last,
         CommunityNickname = last+'12345',
         TimeZoneSidKey = 'America/Los_Angeles',
         LocaleSidKey = 'en_US',
         LanguageLocaleKey = 'en_US'
         ); 
         insert user1;
         return user1;
    }  
   public static DVIWebService__c setDVISettings(){
        DVIWebService__c dviCustSetting = new DVIWebService__c();
        dviCustSetting.name = 'DVI Values';
        dviCustSetting.DVI_Web_Service__c = 'webserviceURL'; 
        dviCustSetting.DVI_Token_Header__c = 'tokenheader';
        insert dviCustSetting;
        return dviCustSetting;
        }
 
   public static CC_Portal__c setCCPortalSettings(){
        CC_Portal__c ccCustSetting = new CC_Portal__c();
        ccCustSetting.name = 'Environment';
        ccCustSetting.Base_URL__c = 'https://ccp-test.vsp.com'; 
       	ccCustSetting.Ready_URL__c = '/csrportal/ctiEvent/answered?SalesforceReadOnlyMode=True';
        insert ccCustSetting;
        return ccCustSetting;
        } 
    public static Consumer_Search_Web_Service__c setCSSettings(){
        Consumer_Search_Web_Service__c CSCustSetting = new Consumer_Search_Web_Service__c();
        CSCustSetting.Name = 'Consumer Search Values';
        CSCustSetting.Consumer_Search_Web_Service__c = 'https://api-staging.vspglobal.com'; 
        CSCustSetting.Consumer_Search_Token_Header__c = 'tokenheader';
        insert CSCustSetting;
        return CSCustSetting;
    }
   
}