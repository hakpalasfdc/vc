public class VSPR32_Strategic_Agree_Chart_Controller {
    
    public ApexPages.StandardController stdCtrl {get; set;}
    public boolean editSection {get;set;}
    
    public VSPR32_Strategic_Agree_Chart_Controller(ApexPages.standardController std)
    {
        stdCtrl=std;
        
    }
    
    public PageReference saveOpty()
    {
        Opportunity opty=(Opportunity) stdCtrl.getRecord();
        stdCtrl.save();
        editSection = false;
        return null;
    }
    public PageReference EdittheSection()
    {
        editSection = true;
        return null;
    }
    
    public PageReference cancelOpty()
    {
        editSection = false;
        return null;
    }
    
}