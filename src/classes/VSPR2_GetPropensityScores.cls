global class VSPR2_GetPropensityScores{
    @InvocableMethod
    public static List<Results> getPropensityScores(List<Requests> requests){
        String body;
        Integer responseCode;
        HTTPResponse Respbody = new HttpResponse();
        List<Results> resultsList = new List<Results>();
        
        List<PropensityScores__c> pScores = [SELECT Id, Case__c, Classification__c, Code__c, Confidence__c, ConsumerId__c, Name, PersonAccount__c, Priority__c, Reason__c,Time_Span_Begin__c,Time_Span_End__c
                                            FROM PropensityScores__c WHERE Case__c =: requests[0].caseIdSB];
        
        
        if(pScores.isEmpty()){ //if there are no scores associated with this case, call out to Consumer db and get scores
            Case caseRec = [SELECT id, accountId, member_Plan__c, consumer_Id__c, ContactId
                            FROM Case WHERE id =: requests[0].caseIdSB]; 
    
            MemberPlan mp = [SELECT ID, ConsumerId__c, Division_Id__c, Client_Id__c, PrimarymemberConsumerId__c
                             FROM MemberPlan WHERE id =: caseRec.member_Plan__c];
        
            ID personAcctId = caseRec.accountId;
            String jsonString='{"consumerId":"'+caseRec.consumer_ID__c+'","primaryMemberConsumerId":"'+mp.primaryMemberConsumerId__c+'","divIds":"'+mp.division_id__c+'","clientIds":"'+ mp.client_Id__c+'"}';
            
            HTTPResponse memResp = new HttpResponse();
            jsonString = 'PS'+jsonString;
            System.debug('jsonString ==='+jsonString);
            Respbody  = VspConsumerExpApi.getSFDCConsumers(jsonString);    
            List<PropensityScores__c> propList = new List<PropensityScores__c>();
            SYSTEM.DEBUG('API Return Body = '+ Respbody.getbody());
            responseCode =   Respbody.getStatusCode();

			if (responseCode == 200){   
				Map<String,Object> entities = (Map<String,Object>)JSON.deserializeUntyped(Respbody.getbody());
               
                Map<String,Object> entityResults = (Map<String,Object>)entities.get('entity');     
                List<Object>consumerResults = (List<Object>)entityResults.get('consumers');
                
                if(consumerResults != null){
                	Integer i=0;
                    Map<String,Object> subscriber;
                    
                    List<ConsumerSeachResults__c> csResultsList = new List<ConsumerSeachResults__c>();  //This is where we save the Search results from API
                    ConsumerSeachResults__c csResult;
                    
                    for(Object consumer:consumerResults){
                        subscriber = (Map<String,Object>)consumer;
                        
                        if(subscriber.keyset().contains('propensityScores')){
                            List<Object> propListAPI = (List<Object>)subscriber.get('propensityScores');                  
                            PropensityScores__c propRec = new PropensityScores__c();
                            Map<String,Object> propMap = new Map<String,Object>();
                            for(object p:propListAPI){  
                                propMap = (Map<String,Object>)p;
                                propRec = new PropensityScores__c();
                                propRec.consumerId__c = ''+ propMap.get('consumerId');
                                propRec.code__c = (String)propMap.get('code');
                                propRec.priority__c = ''+ propMap.get('priority');
                                propRec.classification__c = (String)propMap.get('classification');
                                propRec.confidence__c = (String)propMap.get('confidence');
                                propRec.reason__c = (String)propMap.get('reason');
                                propRec.PersonAccount__c = personAcctId;
                                propRec.Case__c = requests[0].caseIdSB;
                                propList.add(propRec);
                            }
                        }
                    }
                    
                    if(propList != null && propList.size() >0){
                        insert propList;
                        
                        List<PropensityScores__c> propSearch = [SELECT Case__c,Channel__c,Classification__c,Code__c,Confidence__c,ConsumerId__c,Id,Name,Offer_To__c,
                                                                PersonAccount__c,Priority__c,Propensity_Priority__c,Reason__c,Time_Span_Begin__c,Time_Span_End__c
                                                                FROM PropensityScores__c WHERE Case__c =: requests[0].caseIdSB];
                        
                        if(!propSearch.isEmpty()){
                            Results curResult = new Results();
                            for(PropensityScores__c pss: propSearch){ 
                                if(pss.Code__c == 'IP'){
                                    if(pss.Priority__c == '1'){
                                    	pss.Propensity_Priority__c = 'High';
                                    }else if(pss.Priority__c == '2')
                                        pss.Propensity_Priority__c = 'Medium';
                                    else{
                                        pss.Propensity_Priority__c = 'Low';
                                    }
                                    curResult.IPCode = 'IP';
                                    curResult.IPClassification = pss.Classification__c;
                                    curResult.IPConfidence = pss.Confidence__c;
                                    curResult.IPReason = pss.Reason__c;
                                    curResult.IPPriority = pss.Priority__c;
                                }
                                if(pss.Code__c == 'OON'){
                                    if(pss.Priority__c == '1'){
                                    	pss.Propensity_Priority__c = 'High';
                                    }else if(pss.Priority__c == '2')
                                        pss.Propensity_Priority__c = 'Medium';
                                    else{
                                        pss.Propensity_Priority__c = 'Low';
                                    }
                                    curResult.OONCode = 'OON';
                                    curResult.OONClassification = pss.Classification__c;
                                    curResult.OONConfidence = pss.Confidence__c;
                                    curResult.OONReason = pss.Reason__c;
                                    curResult.OONPriority = pss.Priority__c;
                                }
                            }
                            update propSearch;
                            resultsList.add(curResult);
                        }
                    }
                }
            }
        }
        else{ //scores exist on the case
            Results curResult = new Results();
            for(PropensityScores__c pScore:pScores){
                if(pScore.Code__c == 'IP'){
                    curResult.IPCode = 'IP';
                    curResult.IPClassification = pScore.Classification__c;
                    curResult.IPConfidence = pScore.Confidence__c;
                    curResult.IPReason = pScore.Reason__c;
                    curResult.IPPriority = pScore.Priority__c;
                }

                if(pScore.Code__c == 'OON'){
                    curResult.OONCode = 'OON';
                    curResult.OONClassification = pScore.Classification__c;
                    curResult.OONConfidence = pScore.Confidence__c;
                    curResult.OONReason = pScore.Reason__c;
                    curResult.OONPriority = pScore.Priority__c;
                }
            }
            resultsList.add(curResult);
        }
        
        if(!resultsList.isEmpty()){
            return resultsList;
        }
        else{
            Results curResult = new Results();
            curResult.propensityScoreFieldIP = 'No Offer';
            curResult.propensityScoreFieldOON = 'No Offer';
            resultsList.add(curResult);
            return resultsList;
        }
    }
    
    global class Requests{
        @InvocableVariable
        global String caseIdSB;
    }
    
    global class Results{
        @InvocableVariable
        global String propensityScoreFieldIP;
        @InvocableVariable
        global String IPCode;
        @InvocableVariable
        global String IPClassification;
        @InvocableVariable
        global String IPConfidence;
        @InvocableVariable
        global String IPReason;
        @InvocableVariable
        global String IPPriority;
        @InvocableVariable
        global String propensityScoreFieldOON;
        @InvocableVariable
        global String OONCode;
        @InvocableVariable
        global String OONClassification;
        @InvocableVariable
        global String OONConfidence;
        @InvocableVariable
        global String OONReason;
        @InvocableVariable
        global String OONPriority;
    }
}