/***************************************************
Edgar Perez, Implementation Engineer

7/25/2017 by Jitesh Bhatia
Fixed the issue that happens when the user clicks 
save where the last modified field is updated for 
all the records in the related list, even if the 
record has not been modified.

Brief Description: Renders an Opportunity related list
on the Contact Role record that shows all open Opportunities
and allows the user to modify the stage and lost reason for 
each Opportunity directly from the related list. 
****************************************************/
public class DS_OpportunityRelatedListExt {
     Public List<Opportunity> opps{get;set;}

     private Map<Id, Opportunity> oppsToUpdate; 
     private Map<Id, String> stages; 
     private Map<Id, String> lostReasons; 
     private Contact_Role__c currentContactRole; 
     private List<Opportunity> originalOpps; 

    ApexPages.StandardController controller;
    
    public DS_OpportunityRelatedListExt(ApexPages.StandardController controller){
        this.controller = controller; //needed?
        this.stages = new Map<Id, String>(); 
        this.lostReasons = new Map<Id, String>(); 
        this.oppsToUpdate = new Map<Id, Opportunity>(); 

        ID ContactRoleID = ApexPages.currentPage().getParameters().get('Id');
        currentContactRole = [SELECT ID,Account__c,Contact__c FROM Contact_Role__c WHERE id=:ContactRoleID];
        opps = [SELECT Name,CloseDate,Amount,StageName,Owner.Name,Description,Line_of_Business__c,RecordTypeId,DS_Description__c,Lost_Reason__c FROM Opportunity WHERE AccountId =: currentContactRole.Account__c AND ((NOT StageName like '%closed%') OR (StageName = 'Closed Won' AND CloseDate = LAST_N_DAYS:30))];  

    }
    
    public PageReference updateValues(){
        //Query the Opps each time a user saves
        originalOpps = [SELECT Name,CloseDate,Amount,StageName,Owner.Name,Description,Line_of_Business__c,RecordTypeId,DS_Description__c,Lost_Reason__c FROM Opportunity WHERE AccountId =: currentContactRole.Account__c AND ((NOT StageName like '%closed%') OR (StageName = 'Closed Won' AND CloseDate = LAST_N_DAYS:30))];  

        //Store the original Opportunity field values
        for (Opportunity opp : originalOpps)
        {
            stages.put(opp.Id, opp.StageName); 
            lostReasons.put(opp.Id, opp.Lost_Reason__c); 
        }

        system.debug('Opps =' + opps); 
        System.debug('Opp Stages =' + stages); 
        System.debug('Opp Lost Reasons =' + lostReasons);

        //Check whether the user changed any of the Opportunity fields
        for (Opportunity opp : opps)
        {
            if (opp.StageName != stages.get(opp.Id) || opp.Lost_Reason__c != lostReasons.get(opp.Id))
                oppsToUpdate.put(opp.Id, opp); 

            //Remove the Opportunity that is not updated
            else 
                oppsToUpdate.remove(opp.Id); 
        }

        if (!oppsToUpdate.isEmpty())
        {
            try{
                update oppsToUpdate.values();
            }

            catch (Exception e)
            {
                DialSource.DSDenaliErrorEmail.sendError('DS_OpportunityRelatedListExt', e); 
            }
        }

        return null;
    }
}