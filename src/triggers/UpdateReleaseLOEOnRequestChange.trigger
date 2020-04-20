trigger UpdateReleaseLOEOnRequestChange on Request__c (after update, after insert, before delete) {

    public string releaseId;
    public double requirement_gathering=0.0;
    public double sit=0.0;
    public double but=0.0;
    public double uat=0.0;
    public double design=0.0;
    public double traindep=0.0;
    public double adapt=0.0;
    public double cont=0.0;
    public double total = 0.0;
    integer count=0;
    List<Request__c> requirements = new List<Request__c>();
    List<Release__c> releasesToUpdate = new List<Release__c>{}; // bulk1
    
    if(Trigger.isDelete){
    
        for(Request__c reqold:trigger.old){
            releaseId = reqold.Release__c; 
            requirement_gathering = reqold.Req__c;
            design = reqold.Des__c;
            but = reqold.BUT__c;
            sit = reqold.SIT__c;
            uat = reqold.UAT__c;
            traindep = reqold.TrnDep__c;
            adapt = reqold.Adapt__c;
            cont = (reqold.Req__c + reqold.SIT__c + reqold.BUT__c + reqold.UAT__c + reqold.Des__c + reqold.TrnDep__c + reqold.Adapt__c) * (reqold.Cont__c * 1 / 100); // new2
            total = reqold.TotEst__c;
            
            System.debug('$&&&&&&&&&&&&&$--...amounts to decrement....');
            System.debug('$&&&&&&&&&&&&&$--...requirement_gathering....'+requirement_gathering);
            System.debug('$&&&&&&&&&&&&&$--...design....'+design);
            System.debug('$&&&&&&&&&&&&&$--...but....'+but);
            System.debug('$&&&&&&&&&&&&&$--...sit....'+sit);
            System.debug('$&&&&&&&&&&&&&$--...uat....'+uat);
            System.debug('$&&&&&&&&&&&&&$--...traindep....'+traindep);
            System.debug('$&&&&&&&&&&&&&$--...adapt....'+adapt);
            System.debug('$&&&&&&&&&&&&&$--...cont....'+cont);
            System.debug('$&&&&&&&&&&&&&$--...total....'+total);         
        }
        
        Release__c[] lstrel = [select id, Requirements_Gathering__c, Design__c, Build_Unit_Test__c, PMT2009_SIT__c, PMT2009_UAT__c, 
                                   PMT2009_Train_Deploy__c, Adapt_Ongoing_Support__c, Contingency__c from Release__c where id=: releaseId];
           if (lstrel.size()>0) {
               for (Release__c r:lstrel) {
                   r.Requirements_Gathering__c = r.Requirements_Gathering__c - requirement_gathering;
                   r.Design__c = r.Design__c - design;
                   r.Build_Unit_Test__c = r.Build_Unit_Test__c - but;
                   r.PMT2009_SIT__c = r.PMT2009_SIT__c - sit;
                   r.PMT2009_UAT__c = r.PMT2009_UAT__c - uat;
                   r.PMT2009_Train_Deploy__c = r.PMT2009_Train_Deploy__c - traindep;
                   r.Adapt_Ongoing_Support__c = r.Adapt_Ongoing_Support__c - adapt;
                   r.Contingency__c = r.Contingency__c - cont;
                   
                   update r;
               }
           }
    }

    if(Trigger.isInsert || Trigger.isUpdate) {

        for(Request__c req:trigger.new){
        
            if(req.TotEst__c >= 0) {
            
                releaseId = req.Release__c;
                
                requirements = [Select p.TotEst__c,p.Adapt__c, p.BUT__c, p.Des__c, p.Req__c, p.SIT__c, p.TrnDep__c, p.UAT__c, p.Cont__c from Request__c p where Release__c=: releaseId];
        
                for(Request__c Request :requirements )
                {
                    requirement_gathering=requirement_gathering + Request.Req__c;
                    sit=sit + Request.SIT__c;
                    but=but + Request.BUT__c;
                    uat= uat + Request.UAT__c;
                    design = design + Request.Des__c;
                    traindep = traindep + Request.TrnDep__c;
                    adapt = adapt + Request.Adapt__c;
                    cont = cont + ((Request.Req__c + Request.SIT__c + Request.BUT__c + Request.UAT__c + Request.Des__c + Request.TrnDep__c + Request.Adapt__c) * (Request.Cont__c * 1 / 100)); // new2
                    total= total+ Request.TotEst__c;
                    count++;
               }
               
                System.debug('$&&&&&&&&&&&&&$--...insert / update aggregate amounts....');
                System.debug('$&&&&&&&&&&&&&$--...requirement_gathering....'+requirement_gathering);
                System.debug('$&&&&&&&&&&&&&$--...design....'+design);
                System.debug('$&&&&&&&&&&&&&$--...but....'+but);
                System.debug('$&&&&&&&&&&&&&$--...sit....'+sit);
                System.debug('$&&&&&&&&&&&&&$--...uat....'+uat);
                System.debug('$&&&&&&&&&&&&&$--...traindep....'+traindep);
                System.debug('$&&&&&&&&&&&&&$--...adapt....'+adapt);
                System.debug('$&&&&&&&&&&&&&$--...cont....'+cont);
                System.debug('$&&&&&&&&&&&&&$--...total....'+total);
               
               
               Release__c[] lstrel = [select id, Requirements_Gathering__c, Design__c, Build_Unit_Test__c, PMT2009_SIT__c, PMT2009_UAT__c, 
                                       PMT2009_Train_Deploy__c, Adapt_Ongoing_Support__c, Contingency__c from Release__c where id=: releaseId];
               if (lstrel.size()>0) {
                   for (Release__c r:lstrel) {
                       r.Requirements_Gathering__c = requirement_gathering;
                       r.Design__c = design;
                       r.Build_Unit_Test__c = but;
                       r.PMT2009_SIT__c = sit;
                       r.PMT2009_UAT__c = uat;
                       r.PMT2009_Train_Deploy__c = traindep;
                       r.Adapt_Ongoing_Support__c = adapt;
                       r.Contingency__c = cont;
                       
                       update r;
                   }
               }
            
            }
        
        
        }
    }
}