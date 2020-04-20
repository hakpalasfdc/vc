@isTest
public class VSP_Premier_Benefit_Dupe_Validation_Test {
    
    @TestSetup
    public static void testData(){
        //Get the profile to use for a new user so that we can run methods as that user.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Premier Support User' LIMIT 1];
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
        
        Premier_Benefit__c firstBenefit = new Premier_Benefit__c();
        firstBenefit.Name = 'First Benefit';
        firstBenefit.Benefit_Type__c = 'Currency';
        firstBenefit.Benefit_Amount__c = 10;
        firstBenefit.Effective_Date__c = system.today(); 
        firstBenefit.Description__c = 'Testing Description';
        firstBenefit.Status__c = 'Active';
        
        insert firstBenefit;
    } 
    @isTest
    public static void insertDup(){
        
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        
        System.runAs(u){
            try{
                Test.startTest();
                
                Premier_Benefit__c dupFirstBenefit = new Premier_Benefit__c();
                dupFirstBenefit.Name = 'First Benefit';
                dupFirstBenefit.Benefit_Type__c = 'Currency';
                dupFirstBenefit.Benefit_Amount__c = 10;
                dupFirstBenefit.Effective_Date__c = system.today();
                dupFirstBenefit.Description__c = 'Testing Description';
                
                insert dupFirstBenefit;
                
                Test.stopTest();
            }
            catch(Exception e){
                system.assert(e.getMessage().contains('This benefit already exists'));
            }
        }
    }
    
    @isTest
    public static void cloneBenefit(){
        
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
         
        Premier_Benefit__c pb = [SELECT Name, Benefit_Type__c, Benefit_Amount__c, Effective_Date__c, Status__c FROM Premier_Benefit__c WHERE Name = 'First Benefit' LIMIT 1];	
        
        pb.Status__c = 'Future';
        pb.Effective_Date__c = System.today().addDays(1);
        update pb;
        
        System.runAs(u){
            try{
                Test.startTest();
                
                //Test the isClone() method from the class
                Premier_Benefit__c clonePB = pb.clone(false, false, false, false);
                insert clonePB;
                
                Test.stopTest();
            }
            catch(Exception e){
                system.assert(e.getMessage().contains('You can not clone a Future Benefit'));
            }
        }
    }
    @isTest
    public static void deleteBenefit(){
        
        User u = [SELECT Id, Username FROM User WHERE Email = 'Test007@noemail.com' LIMIT 1];
        Premier_Benefit__c pb = [SELECT Name, Benefit_Type__c, Benefit_Amount__c, Effective_Date__c, Status__c FROM Premier_Benefit__c WHERE Name = 'First Benefit' LIMIT 1];
        
        System.runAs(u){
            try{
                Test.startTest();

                delete pb;
                
                Test.stopTest();
            }
            catch(Exception e){
                system.assert(e.getMessage().contains('You cannot delete an Active or Inactive benefit'));
            }
        }
    }
    

}