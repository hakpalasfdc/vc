public class AlertNotificationListController {
    public static final String Alert_Author_Permission_Set='Alert_Author_Permission_Set';
	public static final String PRIMARY_MEMBER_INDICATOR='M';
	public static final String PRIMARY_MEMBER='\'PrimaryMember\'';
	public static final String DEPENDENT='\'Dependent\'';
	
    @AuraEnabled
    public static List<Alerts_and_Notification__c> getAlertList(String recordId){
        List<Alerts_and_Notification__c> alertList = new List<Alerts_and_Notification__c>();
        //Fetch case record for accountid
        Case caseRecord ;
        //To store all status from Member plan
        Set<String> statusSet = new Set<String>();
        //To store all Division from Member plan
        String divisionId ;
		//To store all Division from Member plan
        String clientId ;
        //To store all Alert Ids
        Set<Id> alertIdSet = new Set<Id>();
        //to store the remove alert ids for the case
        Set<Id> removeAlertIdSet = new Set<Id>();
        String consumerString='\'\'';
		String memberstatusString;
        system.debug('recordId = '+recordId);
        List<Case> caseList = new List<Case>();
        List<MemberPlan> mPlans = new List<MemberPlan>();
        List<Alert_ID_Criteria__c> alertCriteria = new List<Alert_ID_Criteria__c>();
        caseList = [select AccountId,IVR_Call_Type__c,(SELECT Id, Alerts_and_Notifications__c, Case__c from CaseAlertJunction__r),Account.Member_Status__c,Account.Consumer__c, Division__c,Member_Plan__c from Case where Id =: recordId];
        
        //for(Case record : [select AccountId,IVR_Call_Type__c,(SELECT Id, Alerts_and_Notifications__c, Case__c from CaseAlertJunction__r),Account.Member_Status__c,Account.Consumer__c, Division__c,Member_Plan__c from Case where Id=:recordId ]){
        for(Case record: caseList){
            caseRecord = record;
            for(CaseAlertJunctionObject__c objRec : record.CaseAlertJunction__r)
                removeAlertIdSet.add(objRec.Alerts_and_Notifications__c);
        }
        
        if(caseRecord.AccountId != null){
            if(caseRecord.Account.Member_Status__c!=null)
                statusSet.add(caseRecord.Account.Member_Status__c);
        }
        
        mplans = [select Client_ID__c,Member_Status__c,Division_ID__c,MemberId,Relation__c,Member.Member_Status__c,Member.Consumer__c,ClientStatus__c from MemberPlan where Id =: caseRecord.Member_Plan__c];
        if(caseRecord.Member_Plan__c != null){
            for(MemberPlan mPlan: mplans){
				
				//Collect Client Id
				if(!String.isEmpty(mPlan.Client_ID__c))
					clientId = mPlan.Client_ID__c;
				
				//Collect Division Id
				if(!String.isEmpty(mPlan.Division_ID__c))
					divisionId=mPlan.Division_ID__c;
				
				//Collect Relation Id for checking with Alert's Consumer
				if(!String.isEmpty(mPlan.Relation__c)){
					if(mPlan.Relation__c == PRIMARY_MEMBER_INDICATOR)
						consumerString =PRIMARY_MEMBER;
					else
						consumerString = DEPENDENT;
				}
				memberstatusString = mPlan.Member_Status__c !=null ? mPlan.Member_Status__c: '';
            }
        }
        
        System.debug('clientId:'+clientId+' divisionId:'+divisionId);
		System.debug('consumerString:'+consumerString+' statusString:'+memberstatusString);
        System.debug('caseRecord.IVR_Call_Type__c:'+caseRecord.IVR_Call_Type__c);
        
        alertCriteria = [SELECT Id, Alert__c, DivisionID__c, ClientID__c FROM Alert_ID_Criteria__c where DivisionID__c=:divisionId OR ClientID__c=:clientId];
		for(Alert_ID_Criteria__c crt: alertCriteria){
			if(!removeAlertIdSet.contains(crt.Alert__c))
				alertIdSet.add(crt.Alert__c);
		}
		
        //Build new strings to store values to use as one string for the Database query
        String baseSQL = 'SELECT Id, Name, Alert_Message__c, Alert_Begins__c, Status__c,' 
                         + 'Alert_Ends__c, Member_Status__c, Alert_Description__c, Call_Type__c, Consumer__c, '
						 + '(SELECT Id, DivisionID__c, ClientID__c, Alert__c FROM Alert_ID_Criterion__r) '
                         + 'FROM Alerts_and_Notification__c WHERE ';
        String callType = '';
        String memStat = '';
        String alertStatus ='Published';
        String endSQL = 'Order By Priority__c,CreatedDate LIMIT 50000';
        String query = '';
        Boolean isValidQuery= false;
        
        if(recordId!=null){
            //Check the case record and build the SQL query string based on it.
            baseSQL += 'Status__c =:alertStatus AND (';
            if(!removeAlertIdSet.isEmpty()){
                baseSQL += 'Id NOT IN: removeAlertIdSet AND (';
                System.debug('baseSQL1: ' + baseSQL);
                isValidQuery =true;
            }
			if(!alertIdSet.isEmpty()){
                baseSQL += 'Id IN: alertIdSet  OR ( ';
                System.debug('baseSQL1: ' + baseSQL);
                isValidQuery =true;
            }

            callType = caseRecord.IVR_Call_Type__c!=null ? caseRecord.IVR_Call_Type__c : '' ;
            baseSQL += 'Call_Type__c INCLUDES (' + '\''+ callType + '\'' + ') AND ';
            System.debug('baseSQL1: ' + baseSQL);
            isValidQuery =true;

            memStat = memberstatusString;
            baseSQL += 'Member_Status__c INCLUDES (' + '\'' + memStat + '\''  + ') AND ';
            System.debug('baseSQL2: ' + baseSQL);
            isValidQuery =true;

            consumerString = consumerString!=null ? consumerString: '';
            baseSQL += 'Consumer__c INCLUDES ('  + consumerString  + ') AND ';
            System.debug('baseSQL3: ' + baseSQL);
            isValidQuery =true;

            if(baseSQL.endsWith(' AND (')){
                baseSQL = query = baseSQL.removeEnd(' AND (');
            }else if(baseSQL.endsWith(' OR (')){
                baseSQL = query = baseSQL.removeEnd(' OR (')+')';
            }else if(baseSQL.endsWith(' AND ')){
                baseSQL = query = baseSQL.removeEnd(' AND ');
				if(!alertIdSet.isEmpty())
					baseSQL+=')';
				if(!removeAlertIdSet.isEmpty())
					baseSQL+=')';
                baseSQL = query = baseSQL+')';
            }else if(baseSQL.endsWith(' OR ')){
                baseSQL = query = baseSQL.removeEnd(' OR ');
				if(!alertIdSet.isEmpty())
					baseSQL+=')';
				if(!removeAlertIdSet.isEmpty())
					baseSQL+=')';
                baseSQL = query = baseSQL+')';
            }
            
            baseSQL = baseSQL + ' ' + endSQL ;
            System.debug('baseSQL4: ' + baseSQL);
            if(isValidQuery)
                for(Alerts_and_Notification__c alert: Database.query(baseSQL)){
					alertList.add(alert);
                }
        }    
        System.debug('alertList:'+alertList.size());
        return alertList; 
    }
    
	//To display the configured Client id and divisioin id on matching criteria
    @AuraEnabled
    public static String getClientAndDivisionIds(Id recordId){
        String result='';
        String result2='';
        for(Alert_ID_Criteria__c record:[SELECT Id, Alert__c, DivisionID__c,ClientID__c FROM Alert_ID_Criteria__c where Alert__c=:recordId]){
            if(!String.isEmpty(record.ClientID__c))
                result+=record.ClientID__c+';';
			if(!String.isEmpty(record.DivisionID__c))
				result2+=record.DivisionID__c+';';
        }
        result=result.removeEnd(';')+'$$$'+result2.removeEnd(';');
        return result;
    }
    
	//Remove the alerts when clicked on remove button
    @AuraEnabled
    public static List<Alerts_and_Notification__c> removeAlerts(Id alertId,Id recordId){
        insert new CaseAlertJunctionObject__c(Alerts_and_Notifications__c=alertId, Case__c =recordId);
        return getAlertList(recordId);
    }
    
	//To check the current user is an author user or not
    @AuraEnabled
	public static Boolean isAuthorUser(){
        Integer count=[SELECT count() FROM PermissionSetAssignment WHERE AssigneeId = :Userinfo.getUserId() AND PermissionSet.Name = :Alert_Author_Permission_Set ];
        return count>0;
    }
}