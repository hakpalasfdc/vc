//Wrapper class for Order Summaries for an Account with all the attributes and fields defined which implements Comparable interface for sorting on each column 
public class VSPR9_OrderSummariesWrapper implements Comparable{
    public String accountName{get;set;}
    public String rxNumber{get;set;}
    public String invoiceNumber{get;set;}
    public String patientName{get;set;}
    public String labNID{get;set;}
    public String labNumber{get;set;}
    public String labName{get;set;}
    public String labStationStatus{get;set;}
    public string dateAtStation{get;set;}
    public string dateEntered{get;set;}
    public string orderStatus{get;set;}
    public string orderType{get;set;}
    public string orderNumber{get;set;} 
    public string guid{get;set;}
    
    public string shipMethod{get;set;}
    public string shipDesc{get;set;}
    public string trackNumber{get;set;}
    public string trackURL{get;set;}
    
    public string estimatedShipDate{get;set;}
    public string actualShipDate{get;set;}
    public String lensOrderUrl{get;set;}
    
    public LensOrderDetails vsponeLensOrderDetail{get;set;}
    
    public class LensOrderDetails{
        public String href{get;set;}
        public String type;
        public String rel;
    }   
    //Which field should be considered for sorting 
    public enum SortField { patientName, labName, rxNumber, labStationStatus, invoiceNumber, dateEntered, estimatedShipDate, dateAtStation, actualShipDate } 

    // Sorting direction ASCENDING or DESCENDING
    public enum SortDirection { ASCENDING, DESCENDING } 

    // default sorting would be ascending
    public static SortDirection SORT_DIR = SortDirection.ASCENDING;
    
    // default sorting would be on name
    public static SortField SORT_FIELD = SortField.patientName; 
    
    //Comparable.compareTo() implementation 
    public Integer compareTo(Object other) {
        if (SORT_FIELD == SortField.patientName) {
            return compareToPatientName(other);
        } else if (SORT_FIELD == SortField.labName) {
            return compareToLabName(other);
        } else if (SORT_FIELD == SortField.labStationStatus) {
            return compareToLocation(other);
        } else if (SORT_FIELD == SortField.rxNumber) {
            return compareToRx(other);
        } else if(SORT_FIELD == SortField.invoiceNumber){
            return compareToInvoiceNumber(other);
        } else if(SORT_FIELD == SortField.dateEntered){
            return compareToDateEntered(other);
        } else if(SORT_FIELD == SortField.estimatedShipDate){
            return compareToEstimatedShipDate(other);
        } else if(SORT_FIELD == SortField.dateAtStation){
            return compareToDateAtStation(other);
        } else if(SORT_FIELD == SortField.actualShipDate){
            return compareToActualShipDate(other);
        } 

        return 0;
    }

    // Compares PATIENT NAME field
    Integer compareToPatientName(Object obj) {
        String objPatientName = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).patientName: ''; 
        objPatientName = objPatientName != null ? objPatientName : '';
        
        String currentPatientName = this != null ? this.patientName : '';
        currentPatientName = currentPatientName != null ? currentPatientName : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentPatientName.compareTo(objPatientName); 
        else
            return objPatientName.compareTo(currentPatientName);
    } 

    // Compares LAB NAME field
    Integer compareToLabName(Object obj) {
        String objLabName = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).labName: ''; 
        objLabName = objLabName != null ? objLabName : '';
        
        String currentLabName = this != null ? this.labName : '';
        currentLabName = currentLabName != null ? currentLabName : '';
        
        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentLabName.compareTo(objLabName); 
        else
            return objLabName.compareTo(currentLabName);
    } 
    
    // Compares Location field
    Integer compareToLocation(Object obj) {
       String objLocation = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).labStationStatus: '';
        objLocation = objLocation != null ? objLocation : '';

       String currentLocation = this != null ? this.labStationStatus : '';
        currentLocation = currentLocation != null ? currentLocation : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentLocation.compareTo(objLocation); 
        else
            return objLocation.compareTo(currentLocation);
    } 
    
    // Compares Rx field 
    Integer compareToRx(Object obj) {
        String objRx = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).rxNumber: ''; 
        objRx = objRx != null ? objRx : '';

        String currentRx = this != null ? this.rxNumber : '';
        currentRx = currentRx != null ? currentRx : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentRx.compareTo(objRx); 
        else
            return objRx.compareTo(currentRx);
    }
    
    // Compares Invoice field 
    Integer compareToInvoiceNumber(Object obj) {
        String objInvoiceNumber = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).invoiceNumber: ''; 
        objInvoiceNumber = objInvoiceNumber != null ? objInvoiceNumber : '';

        String currentInvoiceNumber = this != null ? this.invoiceNumber : '';
        currentInvoiceNumber = currentInvoiceNumber != null ? currentInvoiceNumber : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentInvoiceNumber.compareTo(objInvoiceNumber); 
        else
            return objInvoiceNumber.compareTo(currentInvoiceNumber);
    }
    
    // Compares Date Entered field
    Integer compareToDateEntered(Object obj) {
        String objDateEntered = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).dateEntered: ''; 
        objDateEntered = objDateEntered != null ? objDateEntered : '';

        String currentDateEntered = this != null ? this.dateEntered : '';
        currentDateEntered = currentDateEntered != null ? currentDateEntered : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentDateEntered.compareTo(objDateEntered); 
        else
            return objDateEntered.compareTo(currentDateEntered);
    }
    
    // Compares Estimated Ship Date field
    Integer compareToEstimatedShipDate(Object obj) {
        String objEShipDate = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).estimatedShipDate : '';
        objEShipDate = objEShipDate != null ? objEShipDate : ''; 

        String currentEShipDate = this != null ? this.estimatedShipDate : ''; 
        currentEShipDate = currentEShipDate != null ? currentEShipDate : ''; 

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentEShipDate.compareTo(objEShipDate); 
        else
            return objEShipDate.compareTo(currentEShipDate);
    } 

    // Compares Date at Station field 
    Integer compareToDateAtStation(Object obj) {
        String objDateAtStation = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).dateAtStation: ''; 
        objDateAtStation = objDateAtStation != null ? objDateAtStation : '';

        String currentDateAtStation = this != null ? this.dateAtStation : '';
        currentDateAtStation = currentDateAtStation !=null ? currentDateAtStation : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentDateAtStation.compareTo(objDateAtStation); 
        else
            return objDateAtStation.compareTo(currentDateAtStation);
    } 
    
    // Compares Actual Ship Date field
    Integer compareToActualShipDate(Object obj) {
        String objActualShipDate = obj != null ? ((VSPR9_OrderSummariesWrapper)obj).actualShipDate: ''; 
        objActualShipDate = objActualShipDate != null ? objActualShipDate : '';

        String currentActualShipDate = this != null ? this.actualShipDate: '';
        currentActualShipDate = currentActualShipDate !=null ? currentActualShipDate : '';

        if (SORT_DIR == SortDirection.ASCENDING) 
            return currentActualShipDate.compareTo(objActualShipDate); 
        else
            return objActualShipDate.compareTo(currentActualShipDate);
    } 

}