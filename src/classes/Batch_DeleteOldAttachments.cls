global class Batch_DeleteOldAttachments implements Database.Batchable<sObject>{
 
global final date x = (date.newinstance(system.now().year(),system.now().month(),system.now().day())).addMonths(-25); 
//global final date x = (date.newinstance(system.now().year(),system.now().month(),system.now().day())).addDays(-10); 
global final datetime x2 = datetime.newinstance(x.year(),x.month(),x.day());

global final String gstrQuery = 'select ID, parentId from Attachment where CreatedDate <=: x2';
     global Database.QueryLocator start(Database.BatchableContext BC){
     return Database.getQueryLocator(gstrQuery);
     }
    
global void execute(Database.BatchableContext BC, List<Attachment> scope)
{
     Set<string> cases = new Set<string>();
     
     for(Attachment a : scope)
     {
        if(a.ParentId != null){
            cases.add(a.ParentId);
        }
     }
     
     List<Case> casesQ = [SELECT id
                            FROM Case 
                           WHERE id in: cases
                             AND RecordType.Name = 'Customer Care'];
                            
     Set<Attachment> Set2Delete = new Set<Attachment>();
     
     for(Attachment aX : scope){
         for(integer i = 0; i < casesQ.size(); i++){    
             if(aX.parentId == casesQ[i].Id){
                 Set2Delete.add(aX);
             }    
         }
     }
     
     List<EmailMessage> emailQ = [SELECT id
                                    FROM EmailMessage 
                                   WHERE id in: cases];
     
     for(Attachment aX2 : scope){
         for(integer i = 0; i < emailQ.size(); i++){    
             if(aX2.parentId == emailQ[i].Id){
                 Set2Delete.add(aX2);
             }    
         }
     }   
                    
     List<Attachment> List2Delete = new List<Attachment>(Set2Delete);
     
     delete List2Delete;
}

global void finish(Database.BatchableContext BC){
}

}