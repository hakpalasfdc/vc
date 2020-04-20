public class vsp_tierBenefitTriggerHelper {
    
    public static void outboundCheckoxAfterInsert(List<Tier_Benefit__c> newTb){
        //update VSPR33_outboundCheckoxCalculator.premierTier(newTb);
        List<Tier_Benefit__c> tbList = new List<Tier_Benefit__c>();
        for (Tier_Benefit__c tb : newTb) {
            tbList.add(new Tier_Benefit__c(Id = tb.Id, Premier_Tier__c = tb.Premier_Tier__c, Benefit__c = tb.Benefit__c, Send_Outbound_Message__c = tb.Send_Outbound_Message__c));
        }
        update VSPR33_outboundCheckoxCalculator.premierTier(tbList);
    }

}