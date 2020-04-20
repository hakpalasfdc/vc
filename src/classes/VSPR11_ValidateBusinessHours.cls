/**
* Class Name: VSPR19b_ValidateBusinessHours
* Date: April 26, 2017
* Project: Release 11
* @author: eightCloud
* @description: Validates the Open and Close times for Account Business Hours
*/

public class VSPR11_ValidateBusinessHours{
    public static boolean VSPR11_ValidateBusinessHours_recursion = true;
    //method holds logic of trigger ValidateBusinessHoursTrigger
    public void VSPR11_ValidateBusinessHours(List<Account> newTrigger){
        
        if(VSPR11_ValidateBusinessHours_recursion){
        VSPR11_ValidateBusinessHours_recursion = false;
            system.debug('***** entered VSPR11_ValidateBusinessHours ***** ');
            for(Account a : newTrigger){
                
                // for monday
                if(a.Monday_Open__c != null && a.Monday_Close__c == null){ a.addError('Monday must have both an Open and Close time.');
                }
                if(a.Monday_Open__c == null && a.Monday_Close__c != null){ a.addError('Monday must have both an Open and Close time.');  
                }  
                if(a.Monday_Open__c != null && a.Monday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Monday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Monday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Monday Open time must be less than Monday Close time.');        
                    }
                    
                }
                
                // for Tuesday
                if(a.Tuesday_Open__c != null && a.Tuesday_Close__c == null){
                    a.addError('Tuesday must have both an Open and Close time.');
                }
                if(a.Tuesday_Open__c == null && a.Tuesday_Close__c != null){ a.addError('Tuesday must have both an Open and Close time.');  
                }  
                if(a.Tuesday_Open__c != null && a.Tuesday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Tuesday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Tuesday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Tuesday Open time must be less than Tuesday Close time.');        
                    }
                    
                } 
                
                // for wednesday
                if(a.Wednesday_Open__c != null && a.Wednesday_Close__c == null){ a.addError('Wednesday must have both an Open and Close time.');
                }
                if(a.Wednesday_Open__c == null && a.Wednesday_Close__c != null){ a.addError('Wednesday must have both an Open and Close time.'); 
                }   
                if(a.Wednesday_Open__c != null && a.Wednesday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Wednesday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Wednesday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Wednesday Open time must be less than Wednesday Close time.');        
                    }
                    
                }
                
                // for Thursday
                if(a.Thursday_Open__c != null && a.Thursday_Close__c == null){ a.addError('Thursday must have both an Open and Close time.');
                }
                if(a.Thursday_Open__c == null && a.Thursday_Close__c != null){ a.addError('Thursday must have both an Open and Close time.'); 
                }   
                if(a.Thursday_Open__c != null && a.Thursday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Thursday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Thursday_Close__c);
                    if(Mon1 >= Mon2 ){  a.addError('Thursday Open time must be less than Thursday Close time.');        
                    }
                    
                } 
                
                // for Friday
                if(a.Friday_Open__c != null && a.Friday_Close__c == null){  a.addError('Friday must have both an Open and Close time.');
                }
                if(a.Friday_Open__c == null && a.Friday_Close__c != null){  a.addError('Friday must have both an Open and Close time.');  
                }  
                if(a.Friday_Open__c != null && a.Friday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Friday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Friday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Friday Open time must be less than Friday Close time.');        
                    }
                    
                } 
                    
                // for saturday
                if(a.Saturday_Open__c != null && a.Saturday_Close__c == null){ a.addError('Saturday must have both an Open and Close time.');
                }
                if(a.Saturday_Open__c == null && a.Saturday_Close__c != null){ a.addError('Saturday must have both an Open and Close time.');  
                }  
                if(a.Saturday_Open__c != null && a.Saturday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Saturday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Saturday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Saturday Open time must be less than Saturday Close time.');        
                    }
                    
                }
                
                // for Sunday
                if(a.Sunday_Open__c != null && a.Sunday_Close__c == null){ a.addError('Sunday must have both an Open and Close time.');
                }
                if(a.Sunday_Open__c == null && a.Sunday_Close__c != null){ a.addError('Sunday must have both an Open and Close time.'); 
                }   
                if(a.Sunday_Open__c != null && a.Sunday_Close__c != null){
                    Datetime Mon1 = CreateDateTime.CreateDateFromPicklist(a.Sunday_Open__c);
                    Datetime Mon2 = CreateDateTime.CreateDateFromPicklist(a.Sunday_Close__c);
                    if(Mon1 >= Mon2 ){ a.addError('Sunday Open time must be less than Sunday Close time.');        
                    }
                    
                }
               
            }
        system.debug('***** exiting VSPR11_ValidateBusinessHours ***** ');
        }
    }
}