global class ArchiveArticleToSharepoint implements Database.Batchable<SObject>,Database.AllowsCallouts,Database.Stateful {
    global List<Id> archivedIds = new List<Id>();
    public class SharepointException extends Exception{}
    global List<Attachment> atts = new List<Attachment>();
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String strQuery = 'Select Id,ForSharePointService__c,Article_Type__c from QNews__c where ForSharePointService__c=true';
        system.debug('====================strQuery ========================================='+strQuery );
        return Database.getQueryLocator(strQuery);
    }

    global void execute(Database.BatchableContext BC,List<QNews__c> lst) {
        Map<Id,String> qnewsMap = new Map<Id,String>();
        system.debug('----------lst---------'+lst);
        Set<Id> qNewsIds = new Set<Id>();
        for(QNews__c obj:lst){
            qNewsIds.add(obj.Id); 
            qnewsMap.put(obj.Id,obj.Article_Type__c);  
        }
		system.debug('----------qNewsIds---------'+qNewsIds);
        system.debug('----------qnewsMap---------'+qnewsMap);
        Map<String,Blob> dataToSend = new Map<String,Blob>();
        String strURL='';
        
        //List<Attachment> lstAtt = [Select Id,Name,Body,parentId from Attachment where parentId in :qNewsIds];
        for(Attachment att:[Select Id,Name,Body,parentId from Attachment where parentId in :qNewsIds]){
            String strSharePointURL='';
            
            String specialChars = '~,#,%,&,*,{,},:,<,>,?,|,_,/,",\\,.'; 
            String title = att.Name;
            
            for(integer i=0; i<specialChars.split(',').size(); i++)
            	title = title.replace(specialChars.split(',')[i], '');

            system.debug('-------------att.ParentId---------------'+att.ParentId);
            if(qnewsMap.get(att.parentId)=='Procedure'){
            	strSharePointURL = 'Vault';
            }
            if(qnewsMap.get(att.parentId)=='External_Publication'){
            	strSharePointURL = 'FAQ';
            }
                
            system.debug('----------att---------'+att);
            //Blob b = Blob.valueOf(EncodingUtil.base64Encode(att.Body));
            Blob b = att.Body;
            system.debug('------body-----'+b.toString());
            String endPoint = 'https://services.vsp.com/api/File/Upload';

            JSONGenerator generator = JSON.createGenerator(true);  
            generator.writeStartObject();      
            generator.writeStringField('ExtensionData', 'null');   
            generator.writeBlobField('FileContents', att.Body);   
            generator.writeStringField('FileName', title + '.doc');   
            generator.writeStringField('LibraryName', 'Documents');     
            generator.writeStringField('Password', SharePointWebService__c.getInstance('Credentials').Password__c); 
            
            system.debug('----------------------------------strSharePointURL---------------------------------------------------------------------' +strSharePointURL);
            if(strSharePointURL!=null && strSharePointURL!='' && strSharePointURL.equalsIgnoreCase('Vault') )
                generator.writeStringField('SPWebURL', 'https://visionserviceplan.sharepoint.com/sites/SalesforceKnowledge/TheVaultArchive/');
            else if(strSharePointURL!=null && strSharePointURL!='' && strSharePointURL.equalsIgnoreCase('FAQ') )
                generator.writeStringField('SPWebURL', 'https://visionserviceplan.sharepoint.com/sites/SalesforceKnowledge/GlobalExternalKnowledgeArchive/');
            else
                generator.writeStringField('SPWebURL', 'https://visionserviceplan.sharepoint.com/sites/SalesforceKnowledge/QuestArchive/');
            
            generator.writeStringField('ShallOverwrite', 'true');  
            generator.writeStringField('UserName', SharePointWebService__c.getInstance('Credentials').UserName__c);  
            generator.writeEndObject();    

            String strBody = generator.getAsString();

            system.debug('----------------------------------strBody---------------------------------------------------------------------' +strBody);
            try{
                HttpRequest req = new HttpRequest();    
                req.setEndpoint(endpoint);   
                req.setMethod('POST');
                req.setHeader('Content-Type','application/json;charset=utf-8');
                req.setBody(strBody);
                req.setTimeout(2 * 60 * 1000);
                Http labHttp = new Http();     
                HTTPResponse labResp = labHttp.send(req);
                
                system.debug('----------------------------------labResp---------------------------------------------------------------------' +labResp.getBody());
                if(labResp.getStatusCode() == 200 || labResp.getStatusCode() == 201){
                    archivedIds.add(att.ParentId);
                }
                else{
                    throw new SharepointException('Sharepoint Webservice Archive Exception. QNews Id: '+att.ParentId+' StatusCode:'+LabResp.getStatusCode()+'. Message Body:'+labResp.getBody());
                }
            }Catch(SharepointException se){
                String exceptionText = se.getMessage();
                sendExceptionEmail(exceptionText);
            }Catch(Exception e){
                String exceptionText = 'Exception occured while calling the SharePoint web service-------- the exception message is ------->'+e.getMessage();
                sendExceptionEmail(exceptionText);
            }
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        List<QNews__c> temp = new List<QNews__c>();
        List<QNews__c> externalPublicationArticleData = new List<QNews__c>();
        Set<Id> qnews = new Set<Id>();
        for(QNews__c obj:[Select Id,ForSharePointService__c,Article_Type__c from QNews__c where ForSharePointService__c=true and Id IN: archivedIds]){
            obj.ForSharePointService__c = false;
            if(obj.Article_Type__c=='External_Publication'){
                externalPublicationArticleData.add(obj);
            }else{
                temp.add(obj);
            }
            qnews.add(obj.Id);
            
        }
        List<Attachment> atts = [Select Id,ParentId from Attachment where ParentId in:temp];
        system.debug('----------------------------------atts---------------------------------------------------------------------' +atts);
        system.debug('----------------------------------temp---------------------------------------------------------------------' +temp);
        
        delete atts;
        delete externalPublicationArticleData;
        update temp;
    }
    
    global void sendExceptionEmail(String exceptionText){
        system.debug('------------Exception occured in ArchiveArticleToSharepoint -------'+exceptionText);
        List<Messaging.Singleemailmessage> emailMessages = new List<Messaging.Singleemailmessage>();
        String[] toEmailsIds = new String[]{};
            
		for(Exception_Handler_Email__c obj:[select Name from Exception_Handler_Email__c]){
        	toEmailsIds.add(obj.Name);
        }

        Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();
        if(toEmailsIds!=null && toEmailsIds.size()>0){
            email.setToAddresses(toEmailsIds);
            email.setSubject('Exception Occured while calling the SharePoint Web Service');
            
            if(exceptionText != null)
                email.setPlainTextBody(exceptionText) ;
            else
                email.setPlainTextBody('Exception Occured!!');
            
            emailMessages.add(email);
            if(!Test.isRunningTest()){
            	Messaging.sendEmail(emailMessages);
            }
        }
    }
}