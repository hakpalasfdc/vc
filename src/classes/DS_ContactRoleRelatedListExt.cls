public class DS_ContactRoleRelatedListExt {
    Public List<Contact_Role__c> contactRoles{get;set;}
    ApexPages.StandardController controller;    
    
    public DS_ContactRoleRelatedListExt(ApexPages.StandardController controller){
        this.controller = controller;
        ID ContactRoleID = ApexPages.currentPage().getParameters().get('Id');
        Contact_Role__c c = [SELECT Account__c,id FROM Contact_Role__c WHERE id=:ContactRoleID];
        contactRoles = [SELECT Name, id, Contact__c , Contact__r.Email,Contact_Role_Phone__c,Contact_Role_Type__c,Account__c, Altair_Contact__c, Altair_Campaigns__c FROM Contact_Role__c WHERE Account__c =: c.Account__c AND id !=: c.id];
        
        Map<String, Integer> campaignsByContactIdMap = new Map<String, Integer>();
        for(Contact_Role__c cr : contactRoles){
            campaignsByContactIdMap.put(cr.Contact__c, getCampainsByContactId(cr.Contact__c).size());
            cr.Altair_Campaigns__c = campaignsByContactIdMap.get(cr.Contact__c);
        }
        
    }
    
    public List<Campaign> getCampainsByContactId(String contactId)
    {
        List<Campaign> campaignList = new List<Campaign>();
        List<CampaignMember> campaignMemberList = new List<CampaignMember>();
        List<Campaign> campaignListFiltered = new List<Campaign>();
        
        campaignMemberList = [Select Id, Title, Campaign.Id From CampaignMember where Contact.Id = :contactId];     
        
        for(CampaignMember cm : campaignMemberList){
            campaignList.add(cm.Campaign);
        }
        
        //Date dt = Date.TODAY()-90;
        campaignListFiltered = [Select Id From Campaign where Id IN :campaignList AND Line_of_Business__c IN ('Altair', 'Marchon') AND (StartDate >= TODAY OR StartDate = LAST_N_DAYS:90)];
        
        /*
        for(Campaign cmp : campaignList){
            if(cmp.Line_of_Business__c == 'Altair' && (cmp.StartDate >= Date.TODAY() || cmp.StartDate < Date.TODAY()-90)){
                campaignListFiltered.add(cmp);
            }
        }
        */
        
        return campaignListFiltered;
    }
    
    public PageReference queueRecords(){
        //may need to update contactRoles list for checkbox value to save
        String queue = '';
        System.debug('contact role before for loop: ' + contactRoles);
        System.debug('queue string is: ' + queue);
        //SubmitCallBackListFuture(String sfdcUserId, String sfdcObjectType, String DSCallBackListIds, Boolean isGlobal, String phoneType)
        //DSPriorityQueue.SubmitCallBackListFuture(UserInfo.getUserId(),'Contact_Role__c',queue,False,'Contact_Role_Phone__c');
        update contactRoles; //needed?
        return null;
    }
}