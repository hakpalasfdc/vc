public with sharing class QNewsAttachmentUtility{

    public void saveAttachmentToQNews(List<QNews__c> lstQNews){
        List<Attachment> attachments = new List<Attachment>();
        try{
            for(QNews__c qnewsObj:lstQNews){
                if(qnewsObj.ForSharePointService__c==true && qnewsObj.Article_Type__c!='') {
                    String strContent = '<HTML><head><meta http-equiv="Content-Type" content="text/html; charset=utf-8" /><title>HTML TO WORD</title></head><BODY >';
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Additional_Benefits')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Exam__c,Lens__c,Lens_Enhancements__c,Frame__c,Contacts__c,Doctor_Network__c,Lab__c,Support_Queue_Steps__c from Knowledge__kav where Id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Exam' + ': ' +obj.Exam__c + '</P>';
                            strContent = strContent + '<P>' + 'Lens' + ': ' +obj.Lens__c + '</P>';
                            strContent = strContent + '<P>' + 'Lens Enhancement ' + ': ' +obj.Lens_Enhancements__c + '</P>';
                            strContent = strContent + '<P>' + 'Frame' + ': ' +obj.Frame__c + '</P>';
                            strContent = strContent + '<P>' + 'Contacts" value' + ': ' +obj.Contacts__c + '</P>';
                            strContent = strContent + '<P>' + 'Doctor Network' + ': ' +obj.Doctor_Network__c + '</P>';
                            strContent = strContent + '<P>' + 'Lab' + ': ' +obj.Lab__c + '</P>';
                            strContent = strContent + '<P>' + 'Supportqueue Steps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Single_Topic')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'SupportQueueSteps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Support_Queue')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'SupportQueueSteps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Universal_Service')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'SupportQueueSteps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('C_G_Article')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'SupportQueueSteps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Procedure')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Procedure__c,Additional_Information__c,Keywords__c, Review_Date__c  from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Procedure' + ': ' +obj.Procedure__c + '</P>';
                            strContent = strContent + '<P>' + 'Additional Information' + ': ' +obj.Additional_Information__c + '</P>';
                            strContent = strContent + '<P>' + 'Keywords' + ': ' +obj.Keywords__c + '</P>';
                            strContent = strContent + '<P>' + 'Review Date' + ': ' +obj.Review_Date__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('External_Publication')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Details__c, Version_Comments__c  from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Details' + ': ' +obj.Details__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Core_Benefit')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Exam__c,Lens__c,Lens_Enhancements__c,Frame__c,Contacts__c,Doctor_Network__c,Lab__c,Support_Queue_Steps__c,Additional_Benefits__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Exam' + ': ' +obj.Exam__c + '</P>';
                            strContent = strContent + '<P>' + 'Lens' + ': ' +obj.Lens__c + '</P>';
                            strContent = strContent + '<P>' + 'Lens Enhancement ' + ': ' +obj.Lens_Enhancements__c + '</P>';
                            strContent = strContent + '<P>' + 'Frame' + ': ' +obj.Frame__c + '</P>';
                            strContent = strContent + '<P>' + 'Contacts" value' + ': ' +obj.Contacts__c + '</P>';
                            strContent = strContent + '<P>' + 'Doctor Network' + ': ' +obj.Doctor_Network__c + '</P>';
                            strContent = strContent + '<P>' + 'Lab' + ': ' +obj.Lab__c + '</P>';
                            strContent = strContent + '<P>' + 'Additional Benefits' + ': ' +obj.Additional_Benefits__c + '</P>';
                            strContent = strContent + '<P>' + 'SupportQueueSteps' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Multi_Topic')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Topic_Links__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'Topic Links' + ': ' +obj.Topic_Links__c + '</P>';
                            strContent = strContent + '<P>' + 'Support Queue Steps ' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Multi_Topic_Details')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Article_Details__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Article Details' + ': ' +obj.Article_Details__c + '</P>';
                            strContent = strContent + '<P>' + 'Support Queue Steps ' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    if(qnewsObj.Article_Type__c.equalsIgnoreCase('Open_Enrollment')){
                        for(Knowledge__kav obj:[Select Id,Title,ArticleNumber,VersionNumber,LastPublishedDate,Version_Comments__c,Enrollment_Start_Date__c,Enrollment_End_Date__c,Benefit_Effective_Data__c,General_Description__c,Benefit__c,Eligibility__c,How_To_Enroll__c,Premiums_and_Billing__c,Confirmation__c,Change_Cancel__c,Support_Queue_Steps__c from Knowledge__kav where id=:qnewsObj.Version_History_Version_Id__c]){
                            strContent = strContent + '<P>' + 'Title' + ': ' +obj.Title + '</P>';
                            strContent = strContent + '<P>' + 'ArticleNumber' + ': ' +obj.ArticleNumber + '</P>';
                            strContent = strContent + '<P>' + 'VersionNumber' + ': ' +obj.VersionNumber + '</P>';
                            strContent = strContent + '<P>' + 'LastPublishedDate' + ': ' +obj.LastPublishedDate + '</P>';
                            strContent = strContent + '<P>' + 'Enrollment Start Date' + ': ' +obj.Enrollment_Start_Date__c + '</P>';
                            strContent = strContent + '<P>' + 'Enrollment End Date ' + ': ' +obj.Enrollment_End_Date__c + '</P>';
                            strContent = strContent + '<P>' + 'Benefits Effective Date ' + ': ' +obj.Benefit_Effective_Data__c + '</P>';
                            strContent = strContent + '<P>' + 'General Description ' + ': ' +obj.General_Description__c + '</P>';
                            strContent = strContent + '<P>' + 'Benefits ' + ': ' +obj.Benefit__c + '</P>';
                            strContent = strContent + '<P>' + 'Eligibility ' + ': ' +obj.Eligibility__c + '</P>';
                            strContent = strContent + '<P>' + 'How to Enroll ' + ': ' +obj.How_To_Enroll__c + '</P>';
                            strContent = strContent + '<P>' + 'Premiums and Billing ' + ': ' +obj.Premiums_and_Billing__c + '</P>';
                            strContent = strContent + '<P>' + 'Confirmation ' + ': ' +obj.Confirmation__c + '</P>';
                            strContent = strContent + '<P>' + 'Change or Cancel ' + ': ' +obj.Change_Cancel__c + '</P>';
                            strContent = strContent + '<P>' + 'Support Queue Steps ' + ': ' +obj.Support_Queue_Steps__c + '</P>';
                            strContent = strContent + '<P>' + 'Version Comments' + ': ' +obj.Version_Comments__c + '</P>';
                        }
                    }
                    
                    strContent = strContent + '</BODY></HTML>';
                    Attachment attachmentPDF = new Attachment();
                    attachmentPDF.parentId = qnewsObj.Id;
                    //attachmentPDF.Name = qnewsObj.Article_Title__c + '.doc';
                    attachmentPDF.Name = qnewsObj.Article_Title__c;
                    system.debug('attachmentPDF.Name = '+qnewsObj.Article_Title__c);
                    attachmentPDF.body = Blob.valueOf(strContent); 
                    attachments.add(attachmentPDF);
                    //insert attachmentPDF;
                    
                    system.debug('-----attachmentPDF--------'+attachmentPDF);
                }
            }
            if(attachments!=null && attachments.size()>0)
                insert attachments;
        }
        catch(Exception e)
        {
            system.debug('--------Exception occured---------'+e);
        }
    }
}