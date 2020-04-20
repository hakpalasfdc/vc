public class VSPR11_UpdateBusinessHours {
    public Account acc{get;set;}
    public string str {get;set;}
    public string str2 {get;set;}
    public VSPR11_UpdateBusinessHours(ApexPages.StandardController controller) {  acc = (Account) controller.getRecord();
    }
    
    public pagereference save(){
        try{  update acc;str = 'true1';return null;}
        catch(Exception e){
            /*
            if(e.getMessage().contains('Monday') || e.getMessage().contains('Tuesday') ||e.getMessage().contains('Wednesday') || e.getMessage().contains('Thursday') ||
            e.getMessage().contains('Friday') || e.getMessage().contains('Saturday') || e.getMessage().contains('Sunday')){
                
            }
            else{
                //ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
               // ApexPages.addMessage(myMsg);
               //ApexPages.addMessages(e);
            } */
            ApexPages.addMessages(e);
            return null;    
        }
        
        
    }
    
    

}