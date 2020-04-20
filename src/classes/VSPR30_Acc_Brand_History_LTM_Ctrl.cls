public class VSPR30_Acc_Brand_History_LTM_Ctrl {
    
    private final Account acc;

    
    public VSPR30_Acc_Brand_History_LTM_Ctrl(ApexPages.StandardController stdController){
        acc = (Account)stdController.getRecord();
        
    }
    
    
    public List<Eyewear_Brand_Sales__c> geteBS(){
        
        List<Eyewear_Brand_Sales__c> eBS = New List<Eyewear_Brand_Sales__c>();
        for(Eyewear_Brand_Sales__c e : [SELECT Id, Last_Date_Ordered__c, Marketing_Group_Description__c, Brand_Code__c, Net_Sales_LTM__c, Net_Frame_Sales_LTM__c FROM Eyewear_Brand_Sales__c WHERE Sales_Org__c = '2010' 
                                        AND Account_ID__c =:acc.Id ORDER BY Brand_Description__c, Marketing_Group_Description__c] ){
            
            if(e.Id != null){
                eBS.add(e); 
            }
            
        }
        return eBS;
        
        
    }
}