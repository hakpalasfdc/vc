/***************************************************
Displays Campaigns Related list on the Contact Role
that shows all open Altair Campaigns in the last 90 days 
****************************************************/


public class VSPR27_CampaignRelatedListExt {
    Public List<CampaignMember> camps{get;set;}
    private Contact_Role__c currentContactRole;
    ApexPages.StandardController controller;
    
    public VSPR27_CampaignRelatedListExt(ApexPages.StandardController controller){
        this.controller = controller;
        ID contactRoleId = ApexPages.currentPage().getParameters().get('Id');
        currentContactRole = [SELECT ID, Account__c, Contact__c FROM Contact_Role__c WHERE id=:ContactRoleID];
        camps = [SELECT Status, ContactId, Campaign.Name, Campaign.Description, Campaign.StartDate, Campaign.EndDate FROM CampaignMember WHERE ContactId =:currentContactRole.Contact__c  
                 AND Campaign.Line_of_Business__c IN ('Altair', 'Marchon') AND (Campaign.StartDate = LAST_N_DAYS:90 OR Campaign.StartDate >= TODAY)];        
    }
    
    
//    public PageReference queueRecords(){
//        String queue = '';
//        System.debug('queue string is: ' + queue);
//        update contactRoles; //needed?
//        return null;
//    }

    
}