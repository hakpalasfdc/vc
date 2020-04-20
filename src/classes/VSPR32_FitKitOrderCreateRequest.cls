public class VSPR32_FitKitOrderCreateRequest {
    public VSPR32_FitKitOrderOpportunityHeader Opp_Header {get; set;}
    public VSPR32_FitKitOrderOpportunityItem Opp_Item {get; set;}
    
    public VSPR32_FitKitOrderCreateRequest (Opportunity opportunity) {
        Opp_Header = new VSPR32_FitKitOrderOpportunityHeader();
        Opp_Header.Opportunity = opportunity.Id;
        Opp_Item = new VSPR32_FitKitOrderOpportunityItem(opportunity);
    }
    
    public VSPR32_FitKitOrderCreateRequest (VSPR32_InvocableFitKitOrderRequest request) {
        Opp_Header = new VSPR32_FitKitOrderOpportunityHeader();
        Opp_Header.Opportunity = request.opportunityId;
        Opp_Item = new VSPR32_FitKitOrderOpportunityItem(request);
    }

}