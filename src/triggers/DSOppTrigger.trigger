trigger DSOppTrigger on Opportunity (before insert, before update) {
     for(Opportunity o : trigger.new){
         if(o.Description != null){
             if(o.Description.length() > 50){
                 o.DS_Description__c = o.Description.substring(0,50);
             }
             else{
                 o.DS_Description__c = o.Description;
             }
         }
         else{
             o.DS_Description__c = null;
         }
     }
}