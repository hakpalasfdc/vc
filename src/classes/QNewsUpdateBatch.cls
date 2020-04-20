public class QNewsUpdateBatch {
     
	public class QnewsWrapper{
        public String strArticleId{get;set;}
        public String strArticleTitle{get;set;}
        public String strArticleType{get;set;}
        public String strArticleURL{get;set;}
        public String strArticelVersionNumber{get;set;}
        public String strDataCategory{get;set;}
        public String strDataCategoryGroupName{get;set;}
        public String strDataCategorySelectionId{get;set;}
        public DateTime lastPublishedDate{get;set;}
        public String strVersionComments{get;set;}
        public String strVersionHistoryId{get;set;}
        public String strVersionHistoryParentid{get;set;}
        public String strVrsionHistoryVersionId{get;set;} 
        public String strDataCategoryParentId{get;set;} 
    }
    public void insertQnewsData(String strRecType){
        Map<Id,Id> VersionParentMap = new Map<Id,Id>();
        Map<Id,Id> VersionIdMap = new Map<Id,Id>();
        
        List<SObject> lst_versionhistory = Database.Query('SELECT VersionNumber,VersionId,ParentSobjectType,ParentId,Id,EventType,CreatedDate FROM Knowledge__VersionHistory where (EventType=\'KavPublishedNew\' or EventType=\'KavPublished\') and ParentSobjectType = \'Knowledge\' and ParentId in (SELECT knowledgearticleid FROM Knowledge__kav where Article_Record_Type_Name__c = \''+strRecType+'\')');
        
        List<QnewsWrapper> listQnews = new List<QnewsWrapper>();
        Map<String, QnewsWrapper> qnewsMapWithVrsionHistoryVersionIdKey = new Map<String, QnewsWrapper>();
        
        for(SObject obj:lst_versionhistory){
            if(obj.get('versionId')!=null){
                VersionParentMap.put((Id)obj.get('versionId'),(Id)obj.get('ParentId'));
                VersionIdMap.put((Id)obj.get('versionId'),(Id)obj.get('Id'));
            }
        }
        
		system.debug('--------lst_versionhistory------'+lst_versionhistory);   
        system.debug('--------VersionParentMap------'+VersionParentMap);
        system.debug('--------VersionIdMap------'+VersionIdMap); 
                
        if(VersionParentMap!=null && VersionParentMap.size()>0){
            Set<Id> VersionParentSet = VersionParentMap.keySet();
            system.debug('--------VersionParentSet------'+VersionParentSet);
            List<SObject> lst_DataCategory = Database.Query('Select Id,DataCategoryName,DataCategoryGroupName,ParentId from Knowledge__DataCategorySelection where ParentId IN :VersionParentSet');
            system.debug('--------lst_DataCategory------'+lst_DataCategory);
            for(SObject obj:lst_DataCategory){
            	QnewsWrapper qnewsObj = new QnewsWrapper();
                qnewsObj.strDataCategory = (String)obj.get('DataCategoryName');
                qnewsObj.strDataCategoryGroupName = (String)obj.get('DataCategoryGroupName');
                qnewsObj.strDataCategorySelectionId = (String)obj.get('Id');
                qnewsObj.strDataCategoryParentId = (String)obj.get('ParentId');
                listQnews.add(qnewsObj);
            }
            
            system.debug('--------listQnews------'+listQnews);
            
            //List<SObject> lst_ArticleKAV = Database.Query('Select Id,Version_Comments__c,VersionNumber,UrlName,Title,State_Compliance__c,LastPublishedDate,KnowledgeArticleId,Federal_Compliance__c,Best_Practice__c,Article_Record_Type_Name__c From Knowledge__kav where Id IN :VersionParentSet');
            List<SObject> lst_ArticleKAV = Database.Query('Select Id,Version_Comments__c,VersionNumber,UrlName,Title,LastPublishedDate,KnowledgeArticleId,Article_Record_Type_Name__c From Knowledge__kav where Id IN :VersionParentSet');
            Map<String, SObject> articleKAVMap = new Map<String, SObject>();

            for(SObject obj:lst_ArticleKAV){                            
                articleKAVMap.put((String) obj.get('Id'), obj);
            }
            
            for(QnewsWrapper qnewsObj:listQnews){  
				Sobject obj = articleKAVMap.get(qnewsObj.strDataCategoryParentId);
                if(obj != null){
                    qnewsObj.strVersionComments = (String)obj.get('Version_Comments__c');
                    qnewsObj.strArticelVersionNumber = String.valueOf(obj.get('VersionNumber'));
                    qnewsObj.strArticleURL = (String)obj.get('UrlName');
                    qnewsObj.strArticleTitle = (String)obj.get('Title');
                    qnewsObj.lastPublishedDate = (DateTime)obj.get('LastPublishedDate');
                    qnewsObj.strArticleId = (String)obj.get('KnowledgeArticleId');
                    qnewsObj.strArticleType = (String)obj.get('Article_Record_Type_Name__c');
                    qnewsObj.strVersionHistoryParentid = (String)VersionParentMap.get((Id)obj.get('Id'));
                    qnewsObj.strVersionHistoryId = (String)VersionIdMap.get((Id)obj.get('Id'));
                    qnewsObj.strVrsionHistoryVersionId = (String)obj.get('Id');
                }
			}
            
            /*
            for(SObject obj:lst_ArticleKAV){                            
                for(QnewsWrapper qnewsObj:listQnews){                
                    if(qnewsObj.strDataCategoryParentId == obj.get('Id')){
                        qnewsObj.strVersionComments = (String)obj.get('Version_Comments__c');
                        qnewsObj.strArticelVersionNumber = String.valueOf(obj.get('VersionNumber'));
                        qnewsObj.strArticleURL = (String)obj.get('UrlName');
                        qnewsObj.strArticleTitle = (String)obj.get('Title');
                        qnewsObj.blnStateCompliance = (Boolean)obj.get('State_Compliance__c');
                        qnewsObj.lastPublishedDate = (DateTime)obj.get('LastPublishedDate');
                        qnewsObj.strArticleId = (String)obj.get('KnowledgeArticleId');
                        qnewsObj.blnFederalCompliance = (Boolean)obj.get('Federal_Compliance__c');
                        qnewsObj.blnBestPractice = (Boolean)obj.get('Best_Practice__c');
                        qnewsObj.strArticleType = (String)obj.get('ArticleType');
                        
                        qnewsObj.strVersionHistoryParentid = (String)VersionParentMap.get((Id)obj.get('Id'));
                        qnewsObj.strVersionHistoryId = (String)VersionIdMap.get((Id)obj.get('Id'));
                        qnewsObj.strVrsionHistoryVersionId = (String)obj.get('Id');
                    }                    
                }
            }
            */
        }
        
        Set<String> existingQNewsVersionsId = new Set<String>();
        //for(QNews__c obj:[Select Id,Version_History_Version_Id__c from QNews__c]){
        DateTime dt = DateTime.now().addMinutes(65); 
        for(QNews__c obj:[Select Id,Version_History_Version_Id__c from QNews__c where Last_Published__c > :dt ]){
            existingQNewsVersionsId.add(obj.Version_History_Version_Id__c);
        }
        
        List<QNews__c> qnewsToInsert = new List<QNews__c>();
        
        System.debug('--------listQnews-------'+listQnews);
        System.debug('--------existingQNewsVersionsId-------'+existingQNewsVersionsId);
        
        Map<String,String> qnewsVersionIdDataCategoryMap = new Map<String,String>();
        List<QnewsWrapper> listQnewsCopy = listQnews;
        
        for(QnewsWrapper obj:listQnews){
            qnewsVersionIdDataCategoryMap.put(obj.strVrsionHistoryVersionId,obj.strDataCategory);
            system.debug('-------555555-----------------'+ obj.strVrsionHistoryVersionId );
            qnewsMapWithVrsionHistoryVersionIdKey.put(obj.strVrsionHistoryVersionId, obj);   
        }
        
        Map<String,String> finalDataCategoryMap = new Map<String,String>();
        Map<String,String> finalDataCategoryIdMap = new Map<String,String>();
        
        for(String temp:qnewsVersionIdDataCategoryMap.keySet()){
            String strDataCategory='';
            String strDataCategoryId='';
            QnewsWrapper obj = qnewsMapWithVrsionHistoryVersionIdKey.get(temp);
                      
            if(obj != null){
                if(strDataCategory!=null && !strDataCategory.equalsIgnoreCase('') && !strDataCategory.contains(obj.strVrsionHistoryVersionId)){
                    strDataCategory = strDataCategory+','+obj.strDataCategory;
                }else{
                    strDataCategory = obj.strDataCategory;
                }
                if(strDataCategoryId!=null && !strDataCategoryId.equalsIgnoreCase('') && !strDataCategoryId.contains(obj.strDataCategorySelectionId)){
                    strDataCategoryId = strDataCategoryId+','+obj.strDataCategorySelectionId;
                }else{
                    strDataCategoryId = obj.strDataCategorySelectionId;
                }
            }
            finalDataCategoryMap.put(temp,strDataCategory);
            finalDataCategoryIdMap.put(temp,strDataCategoryId);
        }
        system.debug('-----finalDataCategoryMap-------'+finalDataCategoryMap);
        Set<String> temp = new Set<String>(); 
        Set<String> setDataCategories = new Set<String>(); 
        Map<String, String> setDataCategoriesMap = new Map<String, String>();
        String strDataCategories='';
        for(Article_Categories__c obj:[Select Name from Article_Categories__c]){
            setDataCategories.add(obj.Name);
            setDataCategoriesMap.put(obj.Name, obj.Name);
            //strDataCategories = strDataCategories+','+obj.Name;
        } 
        system.debug('-----strDataCategories-------'+strDataCategories);
        Map<String,String[]> DataForSharepoint = new Map<String,String[]>();
        
        for(QnewsWrapper obj:listQnews){
            if(!existingQNewsVersionsId.contains(obj.strVrsionHistoryVersionId)){            
                QNews__c qnewsObj = new QNews__c();
              	//qnewsObj.Data_Category_Selection_Id__c = obj.strDataCategorySelectionId;
                if(finalDataCategoryIdMap!=null && finalDataCategoryIdMap.size()>0)
                    qnewsObj.Data_Category_Selection_Id__c = finalDataCategoryIdMap.get(obj.strVrsionHistoryVersionId);
                qnewsObj.Data_Category_Group__c = obj.strDataCategoryGroupName;
                
                /*String strDataCategory;
                for(QnewsWrapper objj:listQnewsCopy){
                    if(qnewsVersionIdDataCategoryMap.containsKey(objj.strVrsionHistoryVersionId)){
                        if(strDataCategory!=null && !strDataCategory.equalsIgnoreCase('') && !strDataCategory.contains(qnewsVersionIdDataCategoryMap.get(objj.strVrsionHistoryVersionId))){
                            strDataCategory = strDataCategory+','+qnewsVersionIdDataCategoryMap.get(objj.strVrsionHistoryVersionId);
                        }else{
                            strDataCategory = qnewsVersionIdDataCategoryMap.get(objj.strVrsionHistoryVersionId);
                        }
                    }
                }*/
                
                if(finalDataCategoryMap!=null && finalDataCategoryMap.size()>0)
                     qnewsObj.Data_Category__c = finalDataCategoryMap.get(obj.strVrsionHistoryVersionId);
                
                //qnewsObj.Data_Category__c = obj.strDataCategory;
                qnewsObj.Article_ID__c = obj.strArticleId;
                qnewsObj.Article_URL__c = obj.strArticleURL;
                qnewsObj.Article_Title__c = obj.strArticleTitle;
                qnewsObj.Article_Version_Number__c = obj.strArticelVersionNumber;
                qnewsObj.Version_Comments__c = obj.strVersionComments;
                qnewsObj.Last_Published__c = obj.lastPublishedDate;
                qnewsObj.Article_Type__c = obj.strArticleType;
                qnewsObj.Version_History_Id__c = obj.strVersionHistoryId;
                qnewsObj.Version_History_Version_Id__c = obj.strVrsionHistoryVersionId;
                qnewsObj.Version_History_Parent_Id__c = obj.strVersionHistoryParentid;
                qnewsObj.ForSharePointService__c = true;
                String key = setDataCategoriesMap.get(qnewsObj.Data_Category__c);
                
                system.debug('&&&&&&&&&&&&&&&&&&&&777788897&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +qnewsObj.Data_Category__c);
                
                if(key != null && key != ''){
                    system.debug('&&&&&&&&&&&&&&&&&&&&66666699966&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +key);
                    if(qnewsObj.Data_Category__c!=null && qnewsObj.Data_Category__c!='' ){
                        if(!temp.contains(obj.strVrsionHistoryVersionId)){
                            system.debug('898989898989898989898989898989898' +qnewsObj.Last_Published__c);
                            if(((qnewsObj.Last_Published__c).addMinutes(65)) > datetime.now()){ 
                            	qnewsToInsert.add(qnewsObj);
                            	temp.add(obj.strVrsionHistoryVersionId);
                            } 
                        }
                    }
                }
			}
		}
       
        system.debug('-------qnewsToInsert-----------------'+qnewsToInsert);
        system.debug('-------qnewsToInsert----SIZE---------------'+qnewsToInsert.size());
        
        if(qnewsToInsert!=null && qnewsToInsert.size()>0){
        	system.debug('------------------------107'+qnewsToInsert);
            insert qnewsToInsert;
        }
        //return qnewsToInsert;
    }
}