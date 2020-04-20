public class VSPR33_outboundCheckoxCalculator {
    
    public static List<Tier_Benefit__c> premierTier(List<Tier_Benefit__c> tbList){
        Map<Id, Set<Id>> ptTb = new Map<Id, Set<Id>>();
        Map<Id, Id> tbPb = new Map<Id, Id>();
        Map<Id, Tier_Benefit__c> tbMap = new Map<Id, Tier_Benefit__c>();

        for (Tier_Benefit__c tb: tbList) {
            if (!ptTb.containsKey(tb.Premier_Tier__c)) {
                ptTb.put(tb.Premier_Tier__c, new Set<Id>{tb.Id});
            }else {
                Set<Id> s = new Set<Id>(ptTb.get(tb.Premier_Tier__c));
                s.add(tb.Id);
                ptTb.put(tb.Premier_Tier__c, s);
            }
            tbPb.put(tb.Id, tb.Benefit__c);
            tbMap.put(tb.Id, tb);
        }

        return outboundCheckoxCalculator(tbMap, ptTb, tbPb);
    }

    private static List<Tier_Benefit__c> outboundCheckoxCalculator(Map<Id, Tier_Benefit__c> tbMap, Map<Id, Set<Id>> ptTb, Map<Id, Id> tbPb){

        Set<Id> premierBenefitIdSet = new Set<Id>(tbPb.values());
        List<Premier_Tier__c> premierTierList = [Select Id, Status__c from Premier_Tier__c where Id in :ptTb.keySet() and (Status__c = 'Active' /*or Status__c = 'Inactive'*/)];
        Map<Id, Premier_Benefit__c> premierBenefitMap = new Map<Id, Premier_Benefit__c>([Select Id, Status__c from Premier_Benefit__c where Id in :premierBenefitIdSet and (Status__c = 'Active' /*or Status__c = 'Inactive'*/)]);
        List<Tier_Benefit__c> tierBenefitToUpdate = new List<Tier_Benefit__c>(); 

        for(Premier_Tier__c pt : premierTierList){
            if(ptTb.containsKey(pt.Id)){
                for (Id i : ptTb.get(pt.Id)) {
                    if (premierBenefitMap.containsKey(tbPb.get(i))) {
                        if (tbMap.get(i).Send_Outbound_Message__c != true) {
                            Tier_Benefit__c tb = tbMap.get(i);
                            tb.Send_Outbound_Message__c = true;
                            tierBenefitToUpdate.add(tb);
                        }
                    }
                }
            }
        } 
        return tierBenefitToUpdate;
    }
}