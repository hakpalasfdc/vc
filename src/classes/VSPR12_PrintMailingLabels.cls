public class VSPR12_PrintMailingLabels {
    public account acc {get;set;}
    public VSPR12_PrintMailingLabels(ApexPages.StandardController controller) {
        string str = apexpages.currentpage().getparameters().get('id');
        acc = [select id, name,ShippingCity,ShippingState,ShippingPostalCode,ShippingStreet,Attention_To__c  from account where id=:str ];
    }
    
    public void abc(){
        
    }
    
    public String getPrintView()
    {
        return
        '<!--[if gte mso 9]>' +
            '<xml>' +
            '<w:WordDocument>' +
            '<w:View>Print</w:View>' +
            '<w:Zoom>100</w:Zoom>' +
            '<w:DoNotOptimizeForBrowser/>' +
            '</w:WordDocument>' +
            '</xml>' +
            '<![endif]>';
    }
    
}