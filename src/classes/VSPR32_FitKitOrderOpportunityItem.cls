public class VSPR32_FitKitOrderOpportunityItem {
    public String Fitkit_Number {get; set;}
    public String Qty {get; set;}
    public String Name {get; set;}
    public String Street {get; set;}
    public String Country {get; set;}
    public String PostalCd {get; set;}
    public String City {get; set;}
    public String Region {get; set;}
    public String Telephone {get; set;}
    
    public VSPR32_FitKitOrderOpportunityItem (String Fitkit_Number, String Qty, String Name, String Street, String Country, String PostalCd, String city, String Region, String Telephone) {
        this.Fitkit_Number = Fitkit_Number;
        this.Qty = Qty;
        this.Name = Name;
        this.Street = Street;
        this.Country = Country;
        this.PostalCd = PostalCd;
        this.City = City;
        this.Region = Region;
        this.Telephone = Telephone;
    }
    
    public VSPR32_FitKitOrderOpportunityItem (Opportunity opportunity) {
        this.Fitkit_Number = Fitkit_Number;
        this.Qty = Qty;
        this.Name = Name;
        this.Street = Street;
        this.Country = Country;
        this.PostalCd = PostalCd;
        this.City = City;
        this.Region = Region;
        this.Telephone = Telephone;
    }
    
    public VSPR32_FitKitOrderOpportunityItem (VSPR32_InvocableFitKitOrderRequest request) {
        this.Fitkit_Number = request.Fitkit_Number;
        this.Qty = request.Qty;
        this.Name = request.Name;
        this.Street = request.Street;
        this.Country = request.Country;
        this.PostalCd = request.PostalCd;
        this.City = request.City;
        this.Region = request.Region;
        this.Telephone = request.Telephone;
    }
}