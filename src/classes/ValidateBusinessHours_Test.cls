@IsTest(seeAllData=true)
public class ValidateBusinessHours_Test{
    private static testMethod void testValidateBusinessHoursTrigger(){
        Account acc = [Select id,name,Monday_Open__c,Monday_Close__c,Tuesday_Open__c,Tuesday_Close__c,
                       Wednesday_Open__c,Wednesday_Close__c,Thursday_Open__c,Thursday_Close__c,
                       Friday_Open__c,Friday_Close__c,Saturday_Open__c,Saturday_Close__c,Sunday_Open__c,Sunday_Close__c 
                       from account where recordType.name = 'Business Account' limit 1];
                       
        
            Account accCloned = acc.clone();
            insert accCloned;
            accCloned.Monday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Monday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Monday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
            accCloned.Tuesday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Tuesday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Tuesday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
                        accCloned.Wednesday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Wednesday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Wednesday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
                        accCloned.Thursday_Open__c='9:00 AM';
            //below startTest added by Vikhyat on 08/28/2019
            Test.startTest();
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Thursday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Thursday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
                        accCloned.Friday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Friday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Friday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
                        accCloned.Saturday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Saturday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Saturday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            
                        accCloned.Sunday_Open__c='9:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Sunday_Close__c='5:00 AM';
            try{
                update accCloned;
            }
            catch(Exception e){}
            accCloned.Sunday_Open__c=null;
            try{
                update accCloned;
            }
            catch(Exception e){}
            //Below end test added by Vikhyat on 08/28/2019
            Test.stopTest();
    }
}