public class VSPR34_AutoContactCreation {
    
    public static boolean VSPR34_AutoContactCreation_recursion = true;
    public static void AutoContactCreation(List<Case> newCaseLst){
        
        if(VSPR34_AutoContactCreation_recursion){
            VSPR34_AutoContactCreation_recursion = false;
            
            system.debug('***** entered VSPR34_AutoContactCreation.AutoContactCreation ***** ');
            
            Set<Id> setIds = new Set<Id>();
            
            for(Case c:newCaseLst){
                setIds.add(c.id);
            }
            
            if(!setIds.isEmpty()){
                VSPR16_GetConsumerID.getConsumerID2(setIds);
            }
        }
    }
}