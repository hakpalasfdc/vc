@isTest(seeAllData=true)
public class VSPR12_PrintMailingLabelsTest{
        private static testMethod void testPrintLabels(){
        List<Account> acc = [select id,name,ShippingCity,ShippingState,ShippingPostalCode,ShippingStreet from account limit 1];
        System.assertEquals(acc.size(),1);
        apexpages.currentpage().getparameters().put('id',acc[0].id);
        ApexPages.StandardController sc = new ApexPages.StandardController(acc[0]);
        VSPR12_PrintMailingLabels pl = new VSPR12_PrintMailingLabels(sc);
        pl.abc();
        pl.getPrintView();

        
    }
}