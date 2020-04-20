/**
 * Class Name: VSPR3_NetworkRecruitmentBL
 * @author: karl.wilson.l.tan
 * Date: 16.SEP.2013
 * Requirement/Project Name: VSP
 * @description: Handles all Business Logic for the Network Recruitment object.
 */
 
public class VSPR3_NetworkRecruitmentBL{
 
    public void recruitmentBeforeTriggerMethod(List<Network_Recruitment__c> newTrigger){ 
 
     Set<ID> setNetRolIds = new Set<ID>();
     for(Network_Recruitment__c netRec : newTrigger){
        if(netRec.Contact_Role__c != null)
        setNetRolIds.add(netRec.Contact_Role__c);
    }
     //system.debug('-------------------------------- NetROle ID : ' + setNetRolIds);


     MAP<ID , Contact_Role__c> mapConRol = new MAP<ID , Contact_Role__c>([Select Id, Account__c, Contact__c, CAQH_ID_of_Contact__c, Provider_NPI__c, 
         Phone_of_Account__c, Degree_on_Contact__c, Fax_of_Account__c, Email_of_Account__c, Name_of_Physical_City__c, Name_of_Physical_State__c, Name_of_Physical_Street__c, 
         Name_of_Physical_Zip__c from Contact_Role__c where id in: setNetRolIds]);
     //system.debug('--------------------------------MAP  : ' +mapConRol);

     for(Network_Recruitment__c netConRol : newTrigger)
       {
        if(netConRol.Contact_Role__c != null)
            {
            Contact_Role__c c = mapConRol.get(netConRol.Contact_Role__c);
            //system.debug('--------------------------------Account Name : ' + netConRol.Contact_Role__c);
            
            Contact con = [Select Birthdate__c, Doctor_ID__c from Contact where id = :c.Contact__c];
            Date contactBirthdate = con.Birthdate__c;
            String contactDoctorID = con.Doctor_ID__c;
            
            netConRol.DOB__c = contactBirthdate;
            netConRol.Account_Name_Lookup__c = c.Account__c;                       
            netConRol.CAQH_ID__c = c.CAQH_ID_of_Contact__c;
            netConRol.NPI__c = c.Provider_NPI__c;
            netConRol.Doctor_ID__c = contactDoctorID;    
            netConRol.City__c = c.Name_of_Physical_City__c;
            netConRol.Degree__c = c.Degree_on_Contact__c;
            netConRol.Email__c = c.Email_of_Account__c;
            netConRol.Fax__c = c.Fax_of_Account__c;
            netConRol.Phone__c = c.Phone_of_Account__c;
            netConRol.Provider_Name_Lookup__c = c.Contact__c;
            //netConRol.Provider_Name__c = c.Name_of_Contact__c;
            netConRol.ZIP__c = c.Name_of_Physical_Zip__c;
            netConRol.Street_Address__c = c.Name_of_Physical_Street__c;
            netConRol.State__c = c.Name_of_Physical_State__c;
            
            
            }
       }
    }
    
    public static void recruitmentAfterTriggerMethod(List<Network_Recruitment__c> newTrigger, List<Network_Recruitment__c> oldTrigger, Map<id,Network_Recruitment__c> oldTriggerMap, Boolean isDelete, Boolean isInsert){
    Set<Id> contactIds= new Set<Id>();
    Set<Id> oldcontactIds= new Set<Id>();
     
    if(isDelete){
      for(Network_Recruitment__c oldnetRec : oldTrigger){
         //accountIds.add(oldContact.AccountId);
         contactIds.add(oldTriggerMap.get(oldnetRec.id).Provider_Name_Lookup__c);
       }
    }else{
       for(Network_Recruitment__c netRec : newTrigger){
         if(!isInsert && netRec.Provider_Name_Lookup__c != oldTriggerMap.get(netRec.id).Provider_Name_Lookup__c){
           System.debug('>>>>Update' + oldTriggerMap.get(netRec.id).Provider_Name_Lookup__c);
           oldcontactIds.add(oldTriggerMap.get(netRec.id).Provider_Name_Lookup__c);
           System.debug('>>>>OldContactIds' + oldTriggerMap.get(netRec.id).Provider_Name_Lookup__c);
           System.debug('>>>>NewContactIds' + netRec.Provider_Name_Lookup__c);
         }
         contactIds.add(netRec.Provider_Name_Lookup__c);         
       }
     }
     updateCheckboxFields(contactIds);
     updateCheckboxFields(oldcontactIds);
     System.debug('>>>>ContactIds' + contactIds);
     System.debug('>>>>oldContactIds' + oldcontactIds);      
   }
   
   public static void updateCheckboxFields(Set<Id> contactIds){
     Map<Id,Double> totNetRecInProg = new Map<Id,Double>();
    Double netRecInProgCnt = 0; 
    Boolean hasNetRec;
    
    System.debug('>>>>ContactIds' + contactIds);    
     List<Network_Recruitment__c> netRecDetails = [Select Recruitment_in_Progress_Count__c,Provider_Name_Lookup__c from Network_Recruitment__c where 
                                     Provider_Name_Lookup__c IN: contactIds];
     System.debug('>>>>netRecDetails ' + netRecDetails);
     
     if (netRecDetails.size() > 0){
       System.debug('>>>>netRecDetailsSize' + netRecDetails.size());
       hasNetRec = true;
       System.debug('>>>>hasNetRec' + hasNetRec);
       
       for(Network_Recruitment__c netRecDetail : netRecDetails){
       
         if(totNetRecInProg.containsKey(netRecDetail.Provider_Name_Lookup__c)){         
          netRecInProgCnt = totNetRecInProg.get(netRecDetail.Provider_Name_Lookup__c);
            netRecInProgCnt = netRecInProgCnt + netRecDetail.Recruitment_in_Progress_Count__c;
 
            totNetRecInProg.put(netRecDetail.Provider_Name_Lookup__c,netRecInProgCnt);

            System.debug('>>>>IFnetRecDetail.id' + netRecDetail.id);
            System.debug('>>>>IFnetRecInProgCnt' + netRecInProgCnt);
            
          
        }else{        
          netRecInProgCnt = netRecInProgCnt + netRecDetail.Recruitment_in_Progress_Count__c;

          totNetRecInProg.put(netRecDetail.Provider_Name_Lookup__c,netRecInProgCnt);

            System.debug('>>>>IFnetRecDetail.id' + netRecDetail.id);
            System.debug('>>>>IFnetRecInProgCnt' + netRecInProgCnt);
            
        }      
       }
       System.debug('>>>>totNetRecInProg' + totNetRecInProg);
       
     }else{
       hasNetRec = false;
       System.debug('>>>>hasNetRec ' + hasNetRec );
       for(Id contId : contactIds){
         totNetRecInProg.put(contId,0);         
       }
     }
       
     VSPR3_NetworkRecruitmentDML.updateContactDetails(totNetRecInProg, hasNetRec);
    
    
    
    }

}