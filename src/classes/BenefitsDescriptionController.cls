public class BenefitsDescriptionController {
    
    public Flow.Interview.Out_of_Network OutofNetworkFlow {get; set;}
    PageReference pageRef;
    
    
    public PageReference finishLocation {
        get {
       
          //  pageRef = new PageReference('/' + newRecordId);
            pageRef = new PageReference('/apex/QuestTab?sfdc.tabName=' + QuestId);
            pageRef.setRedirect(true);
            return pageRef;
        }
        set { pageRef = value; }
    }
    
    public String QuestId {
        get {
           // String strTemp = '';
            String QuestId = '';
            Integer intgr = 0;
            
            if(OutofNetworkFlow != null) {
              //  strTemp = string.valueOf(OutofNetworkFlow.getVariableValue('varContactId'));
                QuestId = string.valueOf(OutofNetworkFlow.getVariableValue('varFinishTabId'));
                intgr = QuestId.indexOf('lid=');
                if(intgr >0){QuestId = QuestId.substring(intgr+4, intgr + 19);}
                
            }
            return QuestId;
        }
        
        set { QuestId = value; }
    }
    
    

}