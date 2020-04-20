/*
* Class Name: VSPR19b_NetworkRelationshipBL
* @author: Katherine Boothe
* Date: February 14, 2017
* @description: handles all business logic for Network Relationship object
*/

public class VSPR19b_NetworkRelationshipsBL {
    
    public static boolean conRoleNetRelBeforeTriggerMethod_recursion = true;
    public void conRoleNetRelBeforeTriggerMethod(List<Network_Relationship__c> newTrigger){ 
        
        
        if(conRoleNetRelBeforeTriggerMethod_recursion){
            conRoleNetRelBeforeTriggerMethod_recursion = false;
            
            system.debug('***** entered VSPR19b_NetRelBL CONSTRUCTOR ***** ');
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id, Name from Profile where Id = :profileId].Name;
            Skip_Trigger__c skip = Skip_Trigger__c.getInstance();
            if(skip.Skip_Triggers__c) { return;}    
            
            
            
            if(profileName != 'System Administrator' || profileName != 'VSP Technical User' || test.isRunningTest()){
                
                Set<ID> setNetRelRoleIds = new Set<ID>();
                for(Network_Relationship__c netRels : newTrigger)
                {
                    if(netRels.Contact_Role__c != null)
                        setNetRelRoleIds.add(netRels.Contact_Role__c);
                }
                
                MAP<ID, Contact_Role__c> mapConRoltoNetRel = new MAP<ID , Contact_Role__c>([Select Id, Account__c, Contact__c, Type__c, Account_Record_Type__c, User_Profile_Name__c from Contact_Role__c where id in: setNetRelRoleIds AND (Type__c = 'Doctor-Owner' OR Type__c = 'Doctor-Employee')]);
                
                
                for(Network_Relationship__c netRels : newTrigger)
                {
                    if(netRels.Contact_Role__c != null)
                    {
                        
                        if(mapConRoltoNetRel.size() > 0)
                        {     
                          Contact_Role__c c = mapConRoltoNetRel.get(netRels.Contact_Role__c);
                          String accRecType = c.Account_Record_Type__c;
                          String userProfName = c.User_Profile_Name__c;
                          if(accRecType == 'Practice Account' && userProfName != 'System Administrator' && userProfName != 'VSP Technical User'){
                              netRels.addError('A Network Relationship cannot be added to a Practice Account'); 
                          }
                          else{
                             	netRels.Account_Name__c = c.Account__c;
                          		netRels.Provider_Name__c = c.Contact__c;   
                          }
                                      
                      }
                        else
                        {
                            netRels.addError('Contact Role Type must be Doctor-Owner or Doctor-Employee to create a Network Relationship');              
                        }
                    }
                    
                } 
            }
            
        }      
    }
    
}