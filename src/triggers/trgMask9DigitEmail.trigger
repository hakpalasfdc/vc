trigger trgMask9DigitEmail on EmailMessage (before insert, before update) {
   
    List<EmailMessage> emailMessageList = new List<EmailMessage>();
   
   for(EmailMessage e:Trigger.New){
      
        if(Trigger.isInsert){
            //if((e.TextBody <> null || e.Subject <> null) && string.valueOf(e.Parentid).startsWith('500')){
            if((e.TextBody <> null || e.Subject <> null)){
                emailMessageList.add(e);
            }
        }
        
        if(Trigger.isUpdate){
      
            if((e.TextBody <> null || e.Subject <> null) && trigger.oldMap.get(e.id).TextBody <> e.TextBody && string.valueOf(e.Parentid).startsWith('500')){
                emailMessageList.add(e);
            }
        }
    } 
    
    if(emailMessageList.size()>0){ 
        //Mask9DigitHandler.methodMask9DigitBody(emailMessageList);
        Mask9DigitHandler.methodMask9DigitEmailSubject(emailMessageList);
    } 
   
}