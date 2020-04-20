public class VSPR9_OrderDetailWrapper{
    public String accountNumber{get;set;}
    public String accountName{get;set;}
    public String rxNumber{get;set;}
    public String invoiceNumber{get;set;}
    public String patientName{get;set;}
    public String labNID{get;set;}
    public String labNumber{get;set;}
    public String labName{get;set;}
    public String labStationStatus{get;set;}
    public String dateAtStation{get;set;}
    public String dateEntered{get;set;}
    
    public String actualShipDate{get;set;}
    
    public String orderStatus{get;set;}
    public String orderType{get;set;}
    public String orderNumber{get;set;}
    public String guid{get;set;}
    
    public String shipMethod{get;set;}
    public String shipDesc{get;set;}
    public String trackNumber{get;set;}
    public String trackURL{get;set;}
    
    public String estimatedShipDate{get;set;}
    
    public String safetyFrameIndicator{get;set;}
    
    public String surfaceIndicator{get;set;}
    public String digitalLensIndicator{get;set;}
    public String coatingIndicator{get;set;}
    public String finishIndicator{get;set;}
    public String subContractType{get;set;}
    public String breakage{get;set;}
    public String frameName{get;set;}
    public String frameManufacturer{get;set;}
    
    public String redoSubmitTime{get;set;}
    public String redoInvoiceNumber{get;set;}
    public String redoDVITime{get;set;}
    
    public Details vsponeLensOrderHistory{get;set;}
    public Details vsponeLensOrderNotes{get;set;}
    public Details labAccount{get;set;}
    
    public class Details{
        public String href;
        public String type;
        public String rel;
    }    
}