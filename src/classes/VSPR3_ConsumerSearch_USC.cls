global class VSPR3_ConsumerSearch_USC {
    public Boolean refresh {get;set;}
    public String param1 { get; set; }
    public String contactId {get;set;}
    public String name { get; set; }
    public String firstname { get; set; }
    public String lastname { get; set; }
    public String midname { get; set; }
    public String relation { get; set; }
    public String divid { get; set; }
    public string classId {get;set;}
    public Boolean include { get; set; }
    public Boolean activeonly { get; set; }
    public Boolean remdob { get; set; }
    public String birthdate { get; set; }
    public String asofdate { get; set; }
    public String dob { get; set; }
    public String email { get; set; }
    public String city { get; set; }
    public String state { get; set; }
    public String last4 { get; set; }
    public Boolean tocase {get;set;}
    public String clientname { get; set; }
    public String clientid { get; set; }
    public String reason { get; set; }
    public String reasondetail { get; set; }
    public Boolean authenticated { get; set; }
    global static String ConsumerId{get;set;} 
    public String classification { get; set; }
    public string ciscoContactId{get;set;}
    public String callerintent { get; set; }
    public Static String callerintentText {get;set;}
    public String ivrcalltype { get; set; }
    public String callertype { get; set; }
    public String ANI {get;set;}
    public String DNIS{get;set;}
    public Case caseobj { get; set; }
    public String calltype { get; set; }
    public String subject { get; set; }
    public String callername { get; set; }
    public String policyid { get; set; }
    public String memberid { get; set; }
    //public List<String> memberIDs { get; set; }
    //public List<String> consumerIDs { get; set; }
    //public List<String> auths { get; set; }
    //public List<String> names { get; set; }
    public String auth { get; set; }
    public String phone { get; set; }
    public String Q { get; set; }
    public string caseId{get;set;}
    public string caseCreationStatus{get;set;}
    public String channel {get;set;}
    public Static String ccpURL {get;set;}
    public string consumerIdCCP {get;set;}
    public string CEP {get;set;}
    public string uscCaseId {get;set;}
    public List<ConsumerSeachResults__c> csResultsList{get;set;}   
    public List<ConsumerSeachResults__c> searchResults{get;set;}
    public List<ConsumerSeachResults__c> csrDel{get; set;}
    public List<Account> Consumers { get; set; }
    public list<wrapcsr> wrapcsrList { get; set; }
    public string asofdateformatted {get; set;}
    public string asofdateformattedCCP {get; set;}
    public string dobformatted {get; set;}
    public string primaryMemberConsumerId {get; set;}
    public Set<string> consumerIdsInList= new Set<String>();
    private String soql {get;set;}
    public boolean isUSC {get;set;}
    public string caseNum {get;set;}
  
    public VSPR3_ConsumerSearch_USC(ApexPages.StandardController controller) { 
        caseobj = (Case)controller.getRecord();
        if(caseobj.Id != null){
            caseobj = [SELECT CallerType__c,Reason__c,Reason_Details__c,Consumer_ID__c,AccountId,PersonAccount__c,RecordTypeId,CaseNumber FROM Case WHERE Id =:caseobj.Id];

            Id uscRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Care').getRecordTypeId();
            if(uscRecTypeId == caseobj.RecordTypeId){
                isUSC = true;
            }
            else{
                isUSC = false;
            }
        }
        else{
            caseobj = new case();
        }
        
        soql = 'select Name__c,firstName__c, lastname__c,divid__c, Relation_to_Member__c, phone__c,effectiveDate__c,effectiveInDateFormat__c ,Consumer_Client_Status__c , coverageCode__c,email__c,dob__c,dob_display__c,dobForSort__c, City__c, State__c, ConsumerID__c, Client_Id__c, Client_Name__c,ConsClientDivIDs__c, strategicAlliance__c, primarymemberconsumerID__c,primaryMemberName__c, populationIndicator__c,TermDate__c from consumerseachresults__c where createdBy__c = '+ '\''+UserInfo.getUserId() +'\''  ;
        String asofdateformatted = System.today()+'';
        asofdateformatted = asofdateformatted.left(10);        
        asofdate=asofdateformatted.mid(5,2)+asofdateformatted.right(2)+asofdateformatted.left(4);
        asofdateFormattedCCP = asofdateformatted.left(4)+asofdateformatted.mid(5,2)+asofdateformatted.right(2);
        
        tocase = true;
        Q='';
        caseobj.callerType__c ='Member'; 
        searchResults = new List<ConsumerSeachResults__c>();
        refresh = false;
    }
    
    @RemoteAction 
    global static String getCCPURL(){
        ccpURL = CC_Portal__c.getValues('Environment').Base_URL__c;
        return ccpURL;
    } 
   
    public class wrapcsr{   
        public ConsumerSeachResults__c ccsr{get;set;}
        public boolean isSelected{get;set;}
         
        public wrapcsr(ConsumerSeachResults__c a){     
            ccsr = a;
            isselected = false;
        }
    }
 
    public void reset() {
        refresh = true;
        memberId = '';
        consumerId='';
        name='';
        clientname='';
        clientid='';
        divid='';
        firstname='';
        lastname='';
        birthdate = '';
        callerintent= '';
        calltype='';
        caseobj.callertype__c='Member';
        caseobj.reason__C='';
        caseobj.Reason_Details__c = '';
        last4='';
        dob='';
        asofdate=null;
        state='';
        city='';
        phone='';
        auth='';
        email='';
        activeonly=false;
        remdob=false;
        include=true;
        String asofdateformatted = System.today()+'';
        asofdateformatted = asofdateformatted.left(10);
        asofdate=asofdateformatted.mid(5,2)+asofdateformatted.right(2)+asofdateformatted.left(4);
        asofdateFormattedCCP = asofdateformatted.left(4)+asofdateformatted.mid(5,2)+asofdateformatted.right(2);
            
        csrDel = database.query(soql);
        System.debug('CLEAR SOQL = '+soql);
        if(csrDel != null && csrDel.size() >0){
			Database.DeleteResult[] DR_Dels = Database.delete(csrDel);
        }
            
        csResultsList = null;
        searchResults.clear();
        wrapcsrList = null;
    }
    
    @RemoteAction    
    global static Pagereference finalReset(){
        string soql = 'select Id from consumerseachresults__c where createdBy__c = '+ '\''+UserInfo.getUserId() +'\''  ;
        List<ConsumerSeachResults__c> csrDel=database.query(soql);
            if(csrDel != null && csrDel.size() >0){
				Database.DeleteResult[] DR_Dels = Database.delete(csrDel);
            }
            
        return null;        
    }
    
    private void APIQf(String s1, String s2) {
       if (!String.isBlank(s1)) {
           s1= s1.trim();
           s2=s2.trim();           
           Q = Q+',"'+s2+'":"'+s1+'"';
       }
    }
 
    public HTTPResponse callAPI(){
        HTTPResponse consumerResp = new HttpResponse();
        String body;
        HTTPResponse Respbody = new HttpResponse();
        Map<String,Object> subscriber;
        Integer responseCode;

        Q = 'CS' + Q;
  	    Respbody  = VspConsumerExpApi.getSFDCConsumers(Q);    
  	    responseCode =   Respbody.getStatusCode();
     	if (responseCode == 200){      
            Map<String,Object> entities = (Map<String,Object>)JSON.deserializeUntyped(Respbody.getbody());
            Map<String,Object> entityResults = (Map<String,Object>)entities.get('entity');
    
            List<Object>consumerResults = (List<Object>)entityResults.get('consumers');
            consumerIdsInList = new Set<String>(); 

            if(consumerResults == null){
                return RespBody;
            }
               
            Integer i=0;
            //Clear out any Results they have saved and start fresh
            csrDel=database.query(soql);

            if(csrDel != null && csrDel.size()>0){
                Database.DeleteResult[] DR_Dels = Database.delete(csrDel);
            }

            List<ConsumerSeachResults__c> csResultsList = new List<ConsumerSeachResults__c>();  //This is where we save the Search results from API
            ConsumerSeachResults__c csResult;        
        
            //create list of Consumers adding fields that are needed later but not needed for display(e.g. divid, consumerId...)
            for(Object mapa:consumerResults){
                subscriber = (Map<String,Object>)mapa;
                Map<String,Object> addressMap = new Map<String,Object>();
                Map<String,Object> depMap = new Map<String,Object>();
                
                csResult = new ConsumerSeachResults__c();
               
                List<Object> addressList = (List<Object>)subscriber.get('addresses');  
                     
                if(addresslist != null){
                   addressMap = (Map<String,Object>)AddressList[0]; 
                                          
                    if(addressMap.get('city') != null)
                    {                         
                       csResult.city__c = (String)addressMap.get('city');
                       }
                    if(addressMap.get('stateCode') != null)
                        {
                            csResult.state__c = (String)addressMap.get('stateCode');                               
                           }
                }
    
                //Now add fields to Consumer Search Results object
                csResult.consumerId__c =(String)subscriber.get('consumerId');
                csResult.PrimaryMemberConsumerId__c =(String)subscriber.get('primaryMemberConsumerId'); 
                csResult.Name__c = (String)subscriber.get('firstName')+' '+ (String)subscriber.get('lastName');
                csResult.Relation_to_Member__c =(String)subscriber.get('relationToMember'); 
                csResult.Client_Name__c = (String)subscriber.get('clientName');
                csResult.consumerId__c =(String)subscriber.get('consumerId');
                csResult.PrimaryMemberConsumerId__c =(String)subscriber.get('primaryMemberConsumerId');                          
                csResult.Client_Id__c = (String)subscriber.get('clientId');
                csResult.expandedId__c = (String)subscriber.get('expandedId');
                csResult.strategicAlliance__c = (String)subscriber.get('strategicalliance'); 
                csResult.populationIndicator__c = (String)subscriber.get('populationindicator'); 
                csResult.firstName__c = (String)subscriber.get('firstName'); 
                csResult.lastName__c = (String)subscriber.get('lastName'); 
                csResult.divid__c = (String)subscriber.get('divId'); 
                csResult.coverageCode__c = (String)subscriber.get('coverageCode'); 
                csResult.ConsClientDivIDs__c = (String)subscriber.get('clientId')+' '+ (String)subscriber.get('divId') ;
                csResult.PrimaryMemberName__c = (String)subscriber.get('firstName')+' '+ (String)subscriber.get('lastName');
                csResult.TermDate__c = (String)subscriber.get('futureTerm');           
                dobFormatted = (String)subscriber.get('dateOfBirth');

                
                if(dobFormatted != null){
                    csResult.dob__c = dobFormatted.mid(4,2)+'/'+dobFormatted.right(2)+'/'+dobformatted.left(4);
                    csResult.dobForSort__c = (String)subscriber.get('dateOfBirth');
                }
                else{
                    csResult.dob__c = '01/01/1901';
                    csResult.dobForSort__c = '19010101';
                }
                csResult.Consumer_Client_Status__c = (String)subscriber.get('consumerStatus')+ '/' + (String)subscriber.get('clientStatus');
                csResult.effectiveDate__c = (String)subscriber.get('effectiveDate');
                  
                //Check to see if there are emails
                if(subscriber.keyset().contains('emails')){ 
                    List<Object> emailList = (List<Object>)subscriber.get('emails');             
                    csResult.email__c = (String)emailList[0]; 
                }
                if(subscriber.keyset().contains('phones')){
                    List<Object> phoneList = (List<Object>)subscriber.get('phones');
                     if(phoneList != null && phoneList.size() >0){
                         Map<String,Object> phoneMap = (Map<String,Object>)phoneList[0]; 
                         string phoneNum = (String)phoneMap.get('number');
                         string phonePrefix = (String)phoneMap.get('prefix');
                         csResult.phone__c = phonePrefix+phoneNum; 
                     }  
                }
                
                csResultsList.add(csresult);
                
				//Need to check Consumer ID in record being added to csResultList to see if the dependent has already been added     
				if(!consumerIdsInList.contains(csResult.consumerId__c)){
					// csResultsList.add(csresult);
					consumerIdsInList.add(csResult.consumerId__c);                              
					i+=1; 
				}    

                //Now look to see if I need to create records for Dependents if htey wnt them
                if(include && subscriber.keyset().contains('dependents')){
                	//Now have to add Dependents for this Member
                 	List<Object> depList = (List<Object>)subscriber.get('dependents');
                 	if(depList != null && depList.size() >0){                      
						for(object dep:depList){  
                        	depMap = (Map<String,Object>)dep;
                            csResult = new ConsumerSeachResults__c();
                            //Now add fields to Consumer Search Results object
                            csResult.name__c = (String)depmap.get('firstName')+' '+ (String)depmap.get('lastName');
                            csResult.Relation_to_Member__c =(String)depMap.get('relationToMember'); 
                            csResult.Client_Name__c = (String)subscriber.get('clientName');
                            csResult.Client_Id__c = (String)subscriber.get('clientId');
                            csResult.expandedId__c = (String)subscriber.get('expandedId');
                            csResult.ConsumerId__c = (String)depMap.get('consumerId');  
                            csResult.strategicAlliance__c = (String)subscriber.get('strategicalliance'); 
                            csResult.populationIndicator__c = (String)subscriber.get('populationindicator'); 
                            csResult.firstName__c = (String)depmap.get('firstName'); 
                            csResult.lastName__c = (String)depmap.get('lastName'); 
                            csResult.divid__c = (String)subscriber.get('divId'); 
                            csResult.coverageCode__c = (String)subscriber.get('coverageCode');
                            csResult.Consumer_Client_Status__c = (String)subscriber.get('consumerStatus')+ '/' + (String)subscriber.get('clientStatus');
                            csResult.effectiveDate__c = (String)subscriber.get('effectiveDate');
                            //csResult.ConsClientDivIDs__c = (String)depMap.get('consumerId') +' '+ (String)subscriber.get('clientId')+' '+ (String)subscriber.get('divId') ;
                            csResult.ConsClientDivIDs__c = (String)subscriber.get('clientId')+' '+ (String)subscriber.get('divId') ;
                            csResult.PrimaryMemberConsumerId__c = (String)subscriber.get('primaryMemberConsumerId');            
                            csResult.PrimaryMemberName__c = (String)subscriber.get('firstName')+' '+ (String)subscriber.get('lastName');
                            csResult.TermDate__c = (String)subscriber.get('futureTerm');
                            dobFormatted = (String)depMap.get('dateOfBirth');
                            
                            if(dobFormatted != null){
                            	csResult.dob__c = dobFormatted.mid(4,2)+'/'+dobFormatted.right(2)+'/'+dobformatted.left(4);
                            	csResult.dobForSort__c = (String)depmap.get('dateOfBirth');
                         	}
                         	else{
                            	csResult.dob__c = '01/01/1901';
                            	csResult.dobForSort__c = '19010101';
                         	}
                            
                         	csResultsList.add(csresult);
                         	if(!consumerIdsInList.contains(csResult.consumerId__c)){
                            	// csResultsList.add(csresult);
                             	consumerIdsInList.add(csResult.consumerId__c);                              
                             	i += 1; 
                         	}    
                     	}
					}
				}
            }  

            Insert csResultsList;
            searchResults = csResultsList;     
        }
              
        return Respbody;
    }

    public PageReference APIsearchRecords() {       
        param1='false';
        String Q1='';
        Q='';
        csResultsList=null;
        searchResults.clear();
        wrapcsrList=null;
        APIQf(lastname, 'lastName');
        APIQf(firstname, 'firstName');       

        if(!(ConsumerId =='')){
            APIQf(ConsumerId ,'consumerId');
        }   
            
        APIQf(auth,'authNumber');
        APIQf(memberId, 'expandedId'); 
        Q1=Q;

        APIQf(clientname, 'clientName');            
        APIQf(Last4, 'last4');
        
        if(dob.length()> 0){
            if(!((dob.length() == 8 && !dob.contains('/'))|| (dob.length()==10 && dob.contains('/')))){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the date as mmddyyyy or mm/dd/yyyy'));
                return null;
            }
        }
        
        //Need to format DOB and As of Date for api call - as of is equivalent of effective date
        if(asofdate!=null){
			asofdateformatted = asofdate.right(4) +'-'+ asofdate.left(2)+'-'+ asofdate.mid(2,2);
            asofdateFormattedCCP = asofdate.right(4)+asofdate.left(2)+asofdate.mid(2,2);
            APIQf(asofdateformatted,'asOfDate ');
            System.debug('### asofdateformattedCCP = '+ asofdateformattedCCP); 

        }
        if(dob!=null){
			if(dob.contains('/')){
				dobformatted = dob.right(4) +dob.left(2)+ dob.mid(3,2);
                if (!(((Integer.valueof(dob.left(2).trim()) < 13)  && (Integer.valueof(dob.mid(3,2).trim()) < 32)))) {
					ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please validate the date as mm/dd/yyyy'));
                   	return null;
                }
            }
            else{
                dobformatted = dob.right(4) +dob.left(2)+ dob.mid(2,2);
            }
            system.debug('### dobformatted = '+ dobformatted);
            APIQf(dobformatted,'dob');
        }
        
        APIQf(state,'state');
        APIQf(city, 'city');
        APIQf(phone,'phone');
        APIQf(email,'email');
        
        if (!include) {
            APIQf('false', 'includeDependents');
        }
        else{
            APIQf('true', 'includeDependents');
        }
        
        if (!activeOnly){
            APIQf('false', 'activeMembersOnly');
        }
        else{
            APIQf('true', 'activeMembersOnly');
        }
        
        System.debug('###remdob = '+ remdob);
        if (!remdob){
           APIQf('false', 'excludeDefaultDob'); 
        }
        else{
            APIQf('true', 'excludeDefaultDob'); 
        }
        
        System.debug('### q = '+Q);    
        if(Q1=='' || String.isBlank(Q1)){  
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter First and Last Name or Auth# or Expanded ID'));
            return null;
        }
        else {
            Q=Q.substring(1);        
            Integer j, i, k;

            HTTPResponse RespBody = callAPI();
			String returnCode = String.valueOf(Respbody.getStatusCode());
            if(returnCode != '200'){   
                String responsebody;
                if(returnCode == '500'){
                    responsebody = 'No results found for your Search Criteria - ensure you entered First and LastName, Auth# or Expanded ID';
                    consumerId='';
                }
                else if(returnCode == '503'){
                    String body = RespBody.getBody();
                    if(body.contains('Read timed out')){
                        responsebody = 'Please try your search again. We are experiencing slow response times.';
                        consumerId = '';
                    }
                    else{
                        responsebody = Respbody.getBody();
                    	consumerId ='';
                    }
                }
                else{
                    responsebody = Respbody.getBody();
                    consumerId ='';
                }
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,responsebody));      
                return null; 
             }
             
            k = searchResults.size();
            if(k==0){  
				if (!refresh){
            		ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'No results found for your Search Criteria - ensure that you entered First and LastName, Auth# or Expanded ID'));
				}
                return null;
             }
             else {     
                  if(wrapcsrList ==null){
                      wrapcsrList =new list<wrapcsr>();
                      for(ConsumerSeachResults__c a:searchResults){
                          wrapcsrList.add(new wrapcsr(a));
                       }
                  }   
             }
        }
        refresh=false;
        if(searchResults.size() >49){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There are more than 50 results - you may want to refine your Search criteria'));    
        }
        consumerId='';
        System.debug('Consumer ID ====' + ConsumerId);
        return null;
    } 
    
    public pageReference updateCase(){
        MemberPlan mp = new MemberPlan();

        if(wrapcsrList == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please search before clicking Attach to Case'));
            return null; 
        }
      
        //Now check if they selected more than one
        Integer i=0;
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                i++;
            }
        }

        if(i==0 || i>1 ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please only select one Consumer before clicking Attach to Case'));
            return null; 
        }   
      
        //Check for CallerName and Type
        if(callername== '' || callertype == '' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must enter a Caller Name and Caller Type before clicking Attach to Case'));
            return null; 
        }
        
        caseCreationStatus = 'failure';
        ccpURL = CC_Portal__c.getValues('Environment').Base_URL__c;
        List<Caller_Intent__c> cicList = Caller_Intent__c.getAll().values();
        for(Caller_Intent__c cic:cicList){
            if(cic.Code__c == callerintent){ 
                callerintentText = cic.Intent_Text__c;
            }
        }
        
        caseobj.Caller_Name__c = callername;
       
        caseId = caseobj.id;
        Integer j=-1; 
        Id cId;
        integer numChecked = 0;
        
        List<String> selConsumers = new List<String>();
        ConsumerSeachResults__c selcsr = new ConsumerSeachResults__c();
           
        i=0;
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                selcsr=wrapcsrRec.ccsr;
                j=i; 
                break;
            }
            else {
                i++;
            }
        }
        //Need to run thru wrapper and count number of checkboxes 
        
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                selcsr=wrapcsrRec.ccsr;
                numChecked+=1;                       
            }   
        }
      
        if((j==-1 || numchecked >1) && param1!='true'){       
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select one record in the search result list.'));
            return null;
        }
        
        //Now we have the selected record in selectedConsumers.  Need to determine if they are already in SF as a PA
        //Need to get ConsumerID from selected Results
        
        consumerId = selcsr.consumerId__c;
        if(consumerId == null || consumerId == ''){
            integer considx = selcsr.ConsClientDivIDs__c.indexOf(' '); 
            consumerId = (selcsr.ConsClientDivIDs__c).left(considx); //Sometimes the ConsumerID gets whacked.....
        }
        Consumers = new List<Account>([SELECT Id, Name, Client_Name__pc, Client_ID__pc, Member_Id__pc, Division_Id__pc,Policy_Id__pc, ConsumerId__c, Member_Type__pc, Birthdate__pc, As_of_Date__pc 
                                       FROM Account
                                       WHERE ConsumerId__c=:consumerId]);    
            
        String mpId;
        Account acct = new Account();
         
        if(Consumers == null || Consumers.size()==0){
            // That means the Consumer was not found in the Person Accounts
            // Need to create them first with the info From Consumer Search and then put that record into Consumers record        
            RecordType personAccountRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Person Account' and SObjectType = 'Account'];
            
            acct = new Account();
            acct.FirstName = selcsr.firstName__c;
            acct.LastName = selcsr.lastName__c;
            acct.RecordType = personAccountRecordType;
            acct.ConsumerID__c = consumerId;
            acct.personEmail = selcsr.email__c;
            acct.Phone = selcsr.phone__c;
            insert acct;
            cId = acct.Id; 
            
            mp = new MemberPlan();
            mp.MemberId = acct.Id;
            mp = addToMP(mp,selcsr);
            mp.Name = 'Created from Search'; //this will be changed to MP-## when saved
            insert mp;
            mpId = mp.Id;
            
            //Get Consumers List again since this is used when one is found or just created,
            Consumers = new List<Account>([SELECT Id, Name, Email__c
                                           FROM Account
                                           WHERE id=:cId]);  
        }
        else{  //Found Consumer using ConsumerID - get the Person AccountId
            cId = Consumers[0].Id;
            
            List<MemberPlan> mpList = new List<MemberPlan>([Select Id, Client_Name__c, Client_ID__c, relation__c,Strategic_Alliance_Code__c,Population_Indicator__c,consumerid__c,Division_Id__c,Coverage__c,asofdate__c
                                                            FROM MemberPlan 
                                                            WHERE memberId =: cid 
                                                            AND Division_ID__c =:selcsr.divid__c
                                                            AND Client_Id__c = :selcsr.client_Id__c]);
            system.debug('mpList.size = '+mpList.size());
            if(mpList!=null && mpList.size()>0){
                mpId = mpList[0].id;
                mp = mpList[0];
                mp.MemberId = cId;
                mp=addToMP(mp,selcsr);
                update mp;
            }
            else{
                mp = new MemberPlan();
                mp.MemberId = cId;
                mp = addToMP(mp,selcsr);        
                mp.Name = 'Created from Search'; //this will be changed to MP-## when saved
                insert mp;
                mpId = mp.Id;
            }   
        }
      
        RecordType contactRecordType =  [SELECT Id FROM RecordType WHERE Name = 'Consumer' and SObjectType = 'Contact'];
        
        Contact pcon = [SELECT id, email,phone, consumer_Id__C, Birthdate__c, Current_Age__c
                        FROM Contact
                        WHERE Accountid =: cId];  
        
        pcon.email = selcsr.email__c;
        pcon.phone = selcsr.phone__c;
        pcon.consumer_Id__c = selcsr.consumerId__c;
        if(selcsr.dob__c != null){
            pcon.BirthDate__c = date.parse(selcsr.dob__c);
            if(selcsr.dob__c != '01/01/1901'){
                
                pcon.Current_Age__c = (date.parse(selcsr.dob__c).daysBetween(date.today()))/365.2425;
            }
            System.debug('### pcon.current_Age__c = '+ pcon.current_Age__c);
        }    
        try{
            update pcon;
        }
        catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was a problem updating the Contact '+ e));
            return null;    
        }
                       
        caseobj.AccountId = cId;
        caseobj.ContactId = pcon.Id;
        caseobj.Client_Id__c = selcsr.client_Id__c;
        caseobj.Consumer_Id__c = selcsr.consumerId__c;            
        caseobj.Member_Plan__c = mpId;
        caseobj.DivisionId__c = selcsr.divId__c;
        caseobj.primaryMemberConsumerId__c = selcsr.primaryMemberConsumerId__c; 
        
        try{ 
            update caseobj;
        }
        catch(exception e) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'There was a problem updating the Case. '+ e));
            return null;    
        }
        
        divId = selcsr.divId__c;
        if(divid == null || divid ==''){
            divid=(selcsr.ConsClientDivIDs__c).right(4) ;
        }
        clientId = selcsr.client_Id__c;
        primaryMemberConsumerId = selcsr.PrimaryMemberConsumerId__c;
     
        if (tocase){         
            caseCreationStatus = 'Success';          
        } 
        
        //Call the @future to set some other fields that come with the Retrieve
        getMPData(mp.Id);
        
        consumerIdCCP = selcsr.ConsumerId__c;
        consumerId='';
        return null;
    }
      
    public PageReference executeUSCSearch(){
        consumerId = caseObj.Consumer_ID__c;
        if(!string.isEmpty(consumerId) && consumerId != '0'){
            APIsearchRecords();    
        }
    
        return null;
    }
   
	public MemberPlan addToMP(MemberPlan mp, ConsumerSeachResults__c selcsr){
    	mp.Client_Name__c = selcsr.client_Name__c;
        mp.Primary_Member__c = selcsr.primaryMemberName__c;
        mp.Client_Id__c = selcsr.client_ID__c;
        mp.relation__c = selcsr.Relation_to_Member__c;
        mp.Strategic_Alliance_Code__c = selcsr.strategicAlliance__c;
        mp.Population_Indicator__c = selcsr.populationIndicator__c;
        mp.consumerId__c = selcsr.consumerId__c;
        mp.Division_Id__c = selcsr.divId__c;
        mp.Coverage__c = selcsr.coverageCode__c;
        mp.primaryMemberConsumerId__c = selcsr.PrimaryMemberConsumerId__c;
       
       	if(selcsr.Consumer_Client_Status__c != null || selcsr.Consumer_Client_Status__c !=''){
            String ClientStatus = selcsr.Consumer_Client_Status__c.substring(selcsr.Consumer_Client_Status__c.indexOf('/')+1,selcsr.Consumer_Client_Status__c.length());
            String memberStatus = selcsr.Consumer_Client_Status__c.substring(0,selcsr.Consumer_Client_Status__c.indexOf('/'));   
            
            if(clientStatus == '' || ClientStatus =='?'){
                mp.ClientStatus__c = 'Inactive';
            }
            else{
                mp.ClientStatus__c = clientStatus;
            }
            
            if(memberStatus == '' || memberStatus == '?'){
                mp.Member_Status__c = 'Inactive';
            }
            else{
                mp.Member_Status__c = memberStatus;
            }
            
        }
        else{
            mp.ClientStatus__c = 'Inactive';   
            mp.Member_Status__c = 'Inactive';
        }
       	mp.asofdate__c = system.today();
       
        if(selcsr.effectiveDate__c != null){
            string effDate = selcsr.effectiveDate__c.mid(5,2)+'/'+selcsr.effectiveDate__c.right(2)+'/'+selcsr.effectiveDate__c.left(4);
            mp.EffectiveFrom = date.parse(effDate); 
        }
        if(selcsr.termDate__c != null){
            string termDate = selcsr.termDate__c.mid(5,2)+'/'+selcsr.termDate__c.right(2)+'/'+selcsr.termDate__c.left(4);
            mp.EffectiveTo = date.parse(termDate); 
        }
       
       	return mp; 
    }
    
    @RemoteAction
    global static string createUSCCase(String contactId,String primaryMemberConsumerId,String clntId,String divId,String classId,String intentCode,String callerEnteredPhone,String ani,String dnis,String channel,String callerType,String callType){
		string caseId;
        Case uscCase = new Case();
        string caseType;
        List<DNIS_Map__mdt> dnisList = [SELECT Case_Type__c,Topic__c FROM DNIS_Map__mdt WHERE DNIS__c =:dnis];
        if(dnisList.size() > 0){
            caseType = dnisList[0].Case_Type__c;
            string topic = dnisList[0].Topic__c;
            string callerintentText;
            string caseTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get(caseType).getRecordTypeId();
            
            List<Caller_Intent__c> cicList = Caller_Intent__c.getAll().values();
            for(Caller_Intent__c cic:cicList){
                if(cic.Code__c == intentCode){ 
                    callerintentText = cic.Intent_Text__c;
                }
            }
    
            uscCase.RecordTypeId = caseTypeId;
            uscCase.Origin = 'Phone';
            uscCase.Status = 'New';
            uscCase.Product__c = topic;
            uscCase.Type = 'Issue';
            uscCase.Priority = 'Medium';
            uscCase.CallerType__c = callerType;
            uscCase.Caller_Intent__c = callerintentText;
            uscCase.Caller_Entered_Phone_Number__c = callerEnteredPhone;
            uscCase.IVR_Caller_Intent__c = intentCode;
            uscCase.IVR_Call_Type__c = callType;
            uscCase.IVR_Client_ID__c = clntId;
            uscCase.IVR_Contact_ID__c = contactId;
            uscCase.IVR_DNIS__c = dnis;
            uscCase.IVR_ANI__c = ani;
            
            if(caseType == 'Customer Care'){
                uscCase.Line_of_Business__c = 'Global Customer Care';
            }
            else{
                uscCase.Line_of_Business__c = 'Retail';
                uscCase.OwnerId = system.UserInfo.getUserId();
                uscCase.Subject = 'Eyeconic phone call';
            }
            
            if(!string.isEmpty(primaryMemberConsumerId)){
                uscCase.IVR_Consumer_ID__c = primaryMemberConsumerId;
                uscCase.Consumer_ID__c = primaryMemberConsumerId;
            }
            
            insert uscCase;
            caseId = uscCase.Id;
        }
        system.debug('USC caseId = '+caseId);
        return caseId;
    }
    
    public pageReference selectConsumer(){
        if(wrapcsrList == null ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please search before clicking CC Portal'));
            return null; 
        }
        Integer consumerCount = 0;
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                consumerCount++;
            }
        }
        if(consumerCount==0 || consumerCount>1 ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please only select one Consumer before clicking CC Portal'));
            return null; 
        }   
      
        if(callername== '' || callertype == '' ){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'You must enter a Caller Name and Caller Type before clicking CC Portal'));
            return null; 
        }
        
        List<String> selConsumers = new List<String>();
        ConsumerSeachResults__c selcsr = new ConsumerSeachResults__c();
        integer wrapCount = 0;
        integer selectedWrap = -1;
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                selcsr = wrapcsrRec.ccsr;
                selectedWrap = wrapCount; 
                break;
            }
            else {
                wrapCount++;
            }
        }

        integer numChecked = 0;   
        for(wrapcsr wrapcsrRec : wrapcsrList) {
            if(wrapcsrRec.isSelected == true) {                      
                selcsr = wrapcsrRec.ccsr;
                numChecked += 1;                       
            }   
        }
      
        if(selectedWrap == -1 || numchecked > 1){       
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select one record in the search result list.'));
            return null;
        }
        ccpURL = CC_Portal__c.getValues('Environment').Base_URL__c;
        consumerId = selcsr.consumerId__c;
        if(consumerId == null || consumerId == ''){
            integer considx = selcsr.ConsClientDivIDs__c.indexOf(' '); 
            consumerId = (selcsr.ConsClientDivIDs__c).left(considx); //Sometimes the ConsumerID gets whacked.....
        }
        divId = selcsr.divId__c;
        if(divid == null || divid ==''){
            divid=(selcsr.ConsClientDivIDs__c).right(4) ;
        }
        clientId = selcsr.client_Id__c;
        primaryMemberConsumerId = selcsr.PrimaryMemberConsumerId__c;
        consumerIdCCP = selcsr.ConsumerId__c;
        caseNum = caseobj.CaseNumber;
        caseCreationStatus = 'Success';
        return null;
    }

    // the current sort direction. defaults to asc
    public String sortDir {
        get{if (sortDir == null) {  sortDir = 'asc'; } return sortDir;} set;
    }
  
    // the current field to sort by defaults to name
    public String sortField {
        get{if (sortField == null) {sortField = 'Name__c'; } return sortField;}set;
    }

    // toggles the sorting of query from asc<-->desc
    public void toggleSort() {
        sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
        runQuery();
    }
    
    public List<SelectOption> getStates() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('',''));
        options.add(new SelectOption('AL','Alabama'));
        options.add(new SelectOption('AK','Alaska'));
        options.add(new SelectOption('AS','American Samoa'));
        options.add(new SelectOption('AZ','Arizona'));
        options.add(new SelectOption('AR','Arkansas'));
        options.add(new SelectOption('UM','Baker Island'));
        options.add(new SelectOption('CA','California'));
        options.add(new SelectOption('CO','Colorado'));
        options.add(new SelectOption('CT','Connecticut'));
        options.add(new SelectOption('DE','Delaware'));
        options.add(new SelectOption('DC','District of Columbia'));
        options.add(new SelectOption('FL','Florida'));
        options.add(new SelectOption('GA','Georgia'));
        options.add(new SelectOption('GU','Guam'));
        options.add(new SelectOption('HI','Hawaii'));
        options.add(new SelectOption('UM','Howland Island'));
        options.add(new SelectOption('ID','Idaho'));
        options.add(new SelectOption('IL','Illinois'));
        options.add(new SelectOption('IN','Indiana'));
        options.add(new SelectOption('IA','Iowa'));
        options.add(new SelectOption('UM','Jarvis Island'));
        options.add(new SelectOption('UM','Johnston Atoll'));
        options.add(new SelectOption('KS','Kansas'));
        options.add(new SelectOption('KY','Kentucky'));
        options.add(new SelectOption('UM','Kingman Reef'));
        options.add(new SelectOption('LA','Louisiana'));
        options.add(new SelectOption('ME','Maine'));
        options.add(new SelectOption('MD','Maryland'));
        options.add(new SelectOption('MA','Massachusetts'));
        options.add(new SelectOption('MI','Michigan'));
        options.add(new SelectOption('UM','Midway Islands'));
        options.add(new SelectOption('MN','Minnesota'));
        options.add(new SelectOption('MS','Mississippi'));
        options.add(new SelectOption('MO','Missouri'));
        options.add(new SelectOption('MT','Montana'));
        options.add(new SelectOption('UM','Navassa Island'));
        options.add(new SelectOption('NE','Nebraska'));
        options.add(new SelectOption('NV','Nevada'));
        options.add(new SelectOption('NH','New Hampshire'));
        options.add(new SelectOption('NJ','New Jersey'));
        options.add(new SelectOption('NM','New Mexico'));
        options.add(new SelectOption('NY','New York'));
        options.add(new SelectOption('NC','North Carolina'));
        options.add(new SelectOption('ND','North Dakota'));
        options.add(new SelectOption('MP','Northern Mariana Islands'));
        options.add(new SelectOption('OH','Ohio'));
        options.add(new SelectOption('OK','Oklahoma'));
        options.add(new SelectOption('OR','Oregon'));
        options.add(new SelectOption('UM','Palmyra Atoll'));
        options.add(new SelectOption('PA','Pennsylvania'));
        options.add(new SelectOption('PR','Puerto Rico'));
        options.add(new SelectOption('RI','Rhode Island'));
        options.add(new SelectOption('SC','South Carolina'));
        options.add(new SelectOption('SD','South Dakota'));
        options.add(new SelectOption('TN','Tennessee'));
        options.add(new SelectOption('TX','Texas'));
        options.add(new SelectOption('VI','U.S. Virgin Islands'));
        options.add(new SelectOption('UT','Utah'));
        options.add(new SelectOption('VT','Vermont'));
        options.add(new SelectOption('VA','Virginia'));
        options.add(new SelectOption('UM','Wake Island'));
        options.add(new SelectOption('WA','Washington'));
        options.add(new SelectOption('WV','West Virginia'));
        options.add(new SelectOption('WI','Wisconsin'));
        options.add(new SelectOption('WY','Wyoming'));
        
        return options;
    } 
    
    public void runQuery() {
        searchResults = Database.query(soql + ' order by ' + sortField + ' ' + sortDir + ' NULLS LAST');
        wrapcsrList =new list<wrapcsr>();
        for(ConsumerSeachResults__c a:searchResults){
            wrapcsrlist.add(new wrapcsr(a));
        }
    } 
    
    @future(callout=true)
    public static void getMPData(Id mpId){
        HTTPResponse consumerResp = new HttpResponse();
        MemberPlan mp;
        String body;
        HTTPResponse Respbody = new HttpResponse();
        mp = [SELECT id, consumerID__C, primaryMemberConsumerId__c,client_Id__c, division_id__c
              FROM MemberPlan
              WHERE id =: mpId]; 

        String Q='"consumerId":"'+mp.consumerID__c+'","primaryMemberConsumerId":"'+mp.primaryMemberConsumerId__c+'","divIds":"'+mp.division_id__c+'","clientIds":"'+ mp.client_Id__c+'"';

        integer responseCode;
        
        Q = 'MP' + Q;
        Respbody  = VspConsumerExpApi.getSFDCConsumers(Q);   
        responseCode = Respbody.getStatusCode();

     	if (responseCode == 200){ 
            Map<String,Object> entities = (Map<String,Object>)JSON.deserializeUntyped(Respbody.getbody());
            Map<String,Object> entityResults = (Map<String,Object>)entities.get('entity');     
            List<Object>consumerResults = (List<Object>)entityResults.get('consumers');
            
            if(consumerResults == null){
            }
            else{   
                Integer i=0;
                Map<String,Object> subscriber;
                
                List<ConsumerSeachResults__c> csResultsList = new List<ConsumerSeachResults__c>();  //This is where we save the Search results from API
                ConsumerSeachResults__c csResult;
                
                for(Object mapa:consumerResults){
                    subscriber = (Map<String,Object>)mapa;   
                    mp.population_Indicator__c = (String)subscriber.get('populationIndicator');
                    mp.Strategic_Alliance_Code__c = (String)subscriber.get('strategicAlliance'); 
                }
                update mp;                
            }
        }        
        else{
            System.debug('### There was a problem accessing ConsumedB to udate the MemberPlan.');           
        }
    }
}