public class VSPR16_GetConsumerID{
    
    @future(callout=true)
    public static void getConsumerID2(Set<Id> caseIds){
        String vspMember;
        String complaint;
        
        String memberFirstName;
        String memberLastName;
        String senderFirstName;
        String senderLastName;
        String lastFourSSNORmemberID;
        String memberDOB;
        String memberEmail;
        Boolean vspMemberContact = false;
        String consumerID = '';
        String clientId = ' ';
        String clientName = ' ';
        String relation = ' ';
        String divId = ' ';
        String dateDOB = '';
        String monthDOB = '';
        String yearDOB = ''; 
        String classId;
        String webServiceURL = DVIWebService__c.getInstance('DVI Values').DVI_Web_Service__c;
        String tokenHeader = DVIWebService__c.getInstance('DVI Values').DVI_Token_Header__c;
        Account personAssociatedToCase = new Account();
        Map<String,Case> newPersonMap = new Map<String,Case>();
        List<Account> existingPersons = new List<Account>();
        Id perAcctRecTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Person Account'].Id;
        List<Case> casesToUpdate = new List<Case>();
        List<Account> accountsToUpdate = new List<Account>();
        List<MemberPlan> memberPlansToUpdate = new List<MemberPlan>();
        List<Account> personsToInsert = new List<Account>();
        
        for(Id i:caseIds){
            Case newCase = [Select Id, Description, Origin, contactid, Notes__c, SuppliedEmail, SuppliedName, RecordType.Name from Case where Id =:i];
            System.debug('USC ==== '+newCase.RecordType.Name + newCase.Description);
            if(newCase.Origin == 'Email'){
                if((newCase.RecordType.Name == 'Eyeconic') && (newCase.SuppliedEmail != '' || newCase.SuppliedEmail != null) && (newCase.SuppliedName != '' || newCase.SuppliedName != null)){
                    String eFirstName = newCase.SuppliedName.substring(0,newCase.SuppliedName.indexOf(' '));
                    String eLastName = newCase.SuppliedName.substring(newCase.SuppliedName.indexOf(' ')+1);
                    System.debug('USC ==== INSIDE EMAIL' + eFirstName +eLastName );
                    if(newCase.contactid != null){
                        personAssociatedToCase = Database.Query('Select PersonEmail, RecordType.Name from Account where PersonContactId=\''+newCase.contactid+'\' LIMIT 1');                     
                        
                        //if the person account associated with the case does not have an email address, update it.
                        if(personAssociatedToCase.Id != null){
                            if(personAssociatedToCase.recordType.Name == 'Person Account'){
                                if(personAssociatedToCase.PersonEmail == '' || personAssociatedToCase.PersonEmail == null){
                                    personAssociatedToCase.PersonEmail = newCase.SuppliedEmail;
                                    accountsToUpdate.add(personAssociatedToCase);
                                }
                            }
                        }
                    }
                    else{
                        System.debug('USC EYE ==== CONTACT BLANK');
                        List<List<SObject>> matchOnEmailLst = [FIND :newCase.SuppliedEmail IN ALL FIELDS RETURNING Account(PersonEmail,PersonContactId,ConsumerID__c WHERE RecordTypeId = :perAcctRecTypeId)];
                        if(!matchOnEmailLst.isEmpty()){
                            existingPersons = (List<Account>)matchOnEmailLst[0];
                        }
                        System.debug('USC EYE ===='+ newCase.SuppliedEmail); 
                        if(existingPersons.size() == 1){
                            if(existingPersons[0].PersonEmail == '' || existingPersons[0].PersonEmail == null){
                                existingPersons[0].PersonEmail = newCase.SuppliedEmail;
                                accountsToUpdate.add(existingPersons[0]);
                            }
                            System.debug('ContactId =====' + existingPersons[0].PersonContactId);
                            System.debug('ConsumerID =====' + existingPersons[0].ConsumerID__c);
                            newCase.ContactId = existingPersons[0].PersonContactId; //associate the person account to the case
                            newCase.Consumer_ID__c = existingPersons[0].ConsumerID__c;
                            casesToUpdate.add(newCase);
                        }
                        //AB commented out based on a discussion with Melinda. The new personal account will be created after a manual search on the consumer search page
                        /*   if(existingPersons.size() == 0){
                            System.debug('USC ==== NEW ACCOUNT');
                            Account newPerson = new Account();
                            newPerson.FirstName = eFirstName;
                            newPerson.LastName = eLastName;
                            newPerson.PersonEmail = newCase.SuppliedEmail;
                            newPerson.RecordTypeId = perAcctRecTypeId;
                            newPersonMap.put(newCase.SuppliedEmail,newCase);
                            personsToInsert.add(newPerson);
                            } */
                    }
                }
            }
            System.debug('USC ==== '+newCase.RecordType.Name + newCase.Description);
            if((newCase.RecordType.Name == 'Customer Care') && (newCase.Description != '' && newCase.Description != null)){
                // if((newCase.RecordType.Name == 'USC') && (newCase.Description != '' || newCase.Description != null)){
                if(newCase.Description.indexof('VSP Member:') != -1){
                    String test = newCase.Description.substringAfter('VSP Member:');
                    System.debug('USC ==== CUSTOMER CARE ' + test);
                    //Unix systems can use \n, windows use \r\n
                    if(test.startsWith('\r\n'))
                        test = test.replaceFirst('\r\n', '');
                    if(test.startsWith('\n'))
                        test = test.replaceFirst('\n', '');
                    
                    if(test.startsWith(' '))
                        test = test.replaceFirst(' ', '');
                    
                    if(test.indexOf('\n') != -1)
                        vspMember = (test.substringBefore('\n')).trim();
                    if(test.indexOf('\r\n') != -1)
                        vspMember = (test.substringBefore('\r\n')).trim();
                    
                    System.debug('vspMember: ' + vspMember);
                    if(vspMember != null && vspMember != ''){
                        if(vspMember.equalsIgnoreCase('No')){
                            vspMemberContact = true;
                        }
                        if(vspMember.equalsIgnoreCase('No')){
                            vspMemberContact = false;
                        }   
                    }
                }
                
                if(newCase.Description.indexof('Is this a complaint?') != -1){
                    String test2 = newCase.Description.substringAfter('Is this a complaint?');
                    //Unix systems can use \n, windows use \r\n
                    if(test2.startsWith('\n'))
                        test2 = test2.replaceFirst('\n', '');
                    if(test2.startsWith('\r\n'))
                        test2 = test2.replaceFirst('\r\n', '');
                    
                    if(test2.startsWith(' '))
                        test2 = test2.replaceFirst(' ', '');
                    
                    if(test2.indexOf('\n') != -1)
                        complaint = (test2.substringBefore('\n')).trim();
                    if(test2.indexOf('\r\n') != -1)
                        complaint = (test2.substringBefore('\r\n')).trim();
                }
 
                if(newCase.Description.indexof('Last Four of SSN or Member ID:') != -1){
                    String ssnORMemberID = newCase.Description.substringAfter('Last Four of SSN or Member ID:');
                    //Unix systems can use \n, windows use \r\n
                    if(ssnORMemberID.startsWith('\n'))
                        ssnORMemberID = ssnORMemberID.replaceFirst('\n', '');
                    if(ssnORMemberID.startsWith('\r\n'))
                        ssnORMemberID = ssnORMemberID.replaceFirst('\r\n', '');
                    
                    if(ssnORMemberID.startsWith(' '))
                        ssnORMemberID = ssnORMemberID.replaceFirst(' ', '');
                    
                    if(ssnORMemberID.indexOf('\n') != -1)
                        lastFourSSNORmemberID = (ssnORMemberID.substringBefore('\n')).trim();
                    if(ssnORMemberID.indexOf('\r\n') != -1)
                        lastFourSSNORmemberID = (ssnORMemberID.substringBefore('\r\n')).trim();
                    System.debug('lstFourSSNORmemberId: ' + lastFourSSNORmemberID);
                }

                if(newCase.Description.indexof('E-mail Address:') != -1){
                    String email = newCase.Description.substringAfter('E-mail Address:');
                    //Unix systems can use \n, windows use \r\n
                    if(email.startsWith('\n'))
                        email = email.replaceFirst('\n', '');
                    if(email.startsWith('\r\n'))
                        email = email.replaceFirst('\r\n', '');
                    
                    if(email.startsWith(' '))
                        email = email.replaceFirst(' ', '');
                    
                    if(email.indexOf('\n') != -1)
                        memberEmail = (email.substringBefore('\n')).trim();
                    if(email.indexOf('\r\n') != -1)
                        memberEmail = (email.substringBefore('\r\n')).trim();
                    System.debug('USC ==== CUSTOMER CARE Email from Description' + memberEmail );
                    //memberEmail = 'moabecker@gmail.com';
                    //memberEmail = memberEmail.substring(0,memberEmail.length()-1);
                    if(memberEmail.contains('<')){
                        memberEmail = memberEmail.substring(0,memberEmail.indexOf('<'));
                    }
                    else{
                        memberEmail = memberEmail.substring(0,memberEmail.length());  
                    }
                    
                    System.debug('USC ==== CUSTOMER CARE Email from Description: ' + memberEmail );
                }
 
                if(newCase.Description.indexof('Date of Birth:') != -1){
                    String DOB = newCase.Description.substringAfter('Date of Birth:');
                    //Unix systems can use \n, windows use \r\n
                    if(DOB.startsWith('\n'))
                        DOB = DOB.replaceFirst('\n', '');
                    if(DOB.startsWith('\r\n'))
                        DOB = DOB.replaceFirst('\r\n', '');
                    
                    if(DOB.startsWith(' '))
                        DOB = DOB.replaceFirst(' ', '');
                    
                    if(DOB.indexOf('\n') != -1)
                        memberDOB = (DOB.substringBefore('\n')).trim();
                    if(DOB.indexOf('\r\n') != -1)
                        memberDOB = (DOB.substringBefore('\r\n')).trim();
                    
                    System.debug('USC ==== CUSTOMER CARE DOB: ' + memberDOB );
                }
                
                if(newCase.Description.indexof('Member Name:') != -1){
                    String memberName = newCase.Description.substringAfter('Member Name:');
                    System.debug('memberName: ' + memberName);
                    //Unix systems can use \n, windows use \r\n
                    if(memberName.startsWith('\n'))
                        memberName = memberName.replaceFirst('\n', '');
                    if(memberName.startsWith('\r\n'))
                        memberName = memberName.replaceFirst('\r\n', '');
                    
                    if(memberName.startsWith(' '))
                        memberName = memberName.replaceFirst(' ', '');
                    
                    if(memberName.indexOf('\n') != -1)
                        memberName = (memberName.substringBefore('\n')).trim();
                    if(memberName.indexOf('\r\n') != -1)
                        memberName = (memberName.substringBefore('\r\n')).trim();
                    
                    memberFirstName = memberName.substring(0,memberName.indexOf(' '));
                    memberLastName = memberName.substring(memberName.indexOf(' ')+1);
                    System.debug('USC ==== CUSTOMER CARE Member Name: ' + memberFirstName + memberLastName );
                }

                if(newCase.Description.indexof('Sender Name:') != -1){
                    String senderName = newCase.Description.substringAfter('Sender Name:');
                    //Unix systems can use \n, windows use \r\n
                    if(senderName.startsWith('\r\n'))
                        senderName = senderName.replaceFirst('\r\n', '');
                    if(senderName.startsWith(' '))
                        senderName = senderName.replaceFirst(' ', '');
                    if(senderName.indexOf('\r\n') != -1)
                        senderName = (senderName.substringBefore('\r\n')).trim();
                    
                    senderFirstName = senderName.substring(0,senderName.indexOf(' '));
                    senderLastName = senderName.substring(senderName.indexOf(' ')+1);
                    System.debug('USC ==== CUSTOMER CARE Sender Name: ' + senderFirstName + senderLastName );
                }
            }
            
            if(vspMember != null){
                if(vspMember.equalsIgnoreCase('Yes') && complaint.equalsIgnoreCase('No')){
                    
                    String queryParams = 'firstname=' + memberFirstName + '&lastname=' + memberLastName + '&policyid=' + lastFourSSNORmemberID + '&dateofbirth=' + memberDOB;
                    HttpRequest oauthReq = new HttpRequest(); 
                    String access_token='';
                    
                    //URL for the OAuth to get the Access Token goes here
                    oauthReq.setEndpoint(webServiceURL + '/as/token.oauth2?grant_type=client_credentials&scope=write:vc.member%20member_view');  
                    oauthReq.setMethod('POST');
                    String authorizationHeader = 'Basic '+ tokenHeader; 
                    oauthReq.setHeader('Accept', 'application/json'); 
                    oauthReq.setHeader('Authorization', authorizationHeader); 
                    oauthReq.setTimeout(2 * 60 * 1000);
                    
                    Http oauthHttp = new Http(); 
                    HTTPResponse oauthResp = oauthHttp.send(oauthReq); 
                    String oauthRespJSON=oauthResp.getBody();
                    JSONParser parser=JSON.createParser(oauthRespJSON);
                    while(parser.nextToken()!=null){
                        if((parser.getCurrentToken()==JSONToken.FIELD_NAME)&&(parser.getText()=='access_token')){
                            parser.nextToken();
                            access_token+=parser.getText();
                        }
                    }
                    String memHeaders = 'Bearer ' + access_token;
                    String consumerIDEndPoint = webServiceURL + '/memberpolicy-web/memberpolicies?' + queryParams;
                    HttpRequest memReq = new HttpRequest(); 
                    memReq.setEndpoint(consumerIDEndPoint); 
                    memReq.setMethod('GET');
                    memReq.setHeader('Accept','application/json');
                    memReq.setHeader('Authorization', memHeaders); 
                    
                    Http memHttp = new Http(); 
                    HTTPResponse memResp = new HttpResponse();
                    memResp = memHttp.send(memReq);                    
                    
                    if (memResp.getStatusCode()==200){ 
                        
                        List<Object> mapDeserializeMemData = (List<Object>)JSON.deserializeUntyped(memResp.getBody());
                        
                        if(mapDeserializeMemData != null && mapDeserializeMemData.size() == 1){
                            Object memData = (Object)mapDeserializeMemData[0];
                            String memDataSer = JSON.serialize(memData);
                            Map<String, Object> memDataDeser = (Map<String, Object>)JSON.deserializeUntyped(memDataSer);
                            List<Object> memberships = (List<Object>)memDataDeser.get('memberships');
                            Object memberships1 = (Object)memberships[0];
                            String member = JSON.serialize(memberships1);
                            Map<String, Object> getConsumerID = (Map<String, Object>)JSON.deserializeUntyped(member);
                            consumerID = (String)getConsumerID.get('consumerId');
                        }
                        
                        if(consumerID != null && consumerID != ''){
                            String memEmail = memberEmail;
                            String consID = consumerID;
                            Integer[] lst = new Integer[]{1,2,3,4,5,6,7,8,9,10};
                                
                                for(Integer x : lst){
                                    if(consID.length() < 10){
                                        consID = '0' + consID;
                                    }
                                }
                            
                            HttpRequest postEmailReq = new HttpRequest(); 
                            String postEmailEndPoint = webServiceURL + '/memberpolicy-web/consumers/' + consID + '/consumeremails?email=' + memEmail;
                            postEmailReq.setEndpoint(postEmailEndPoint); 
                            postEmailReq.setMethod('PUT');
                            postEmailReq.setHeader('Accept','application/json');
                            String postEmailHeaders = 'Bearer ' + access_token; 
                            postEmailReq.setHeader('Authorization', postEmailHeaders); 
                            
                            Http postEmailHttp = new Http(); 
                            HTTPResponse postEmailResp = new HttpResponse();
                            postEmailResp = postEmailHttp.send(postEmailReq);   
                        }
                    }
                }
                
                if(newCase.contactid != null){
                    personAssociatedToCase = Database.Query('Select PersonEmail,Client_ID__pc,Division_Id__pc,Consumer_ID__pc,RecordType.Name,D2C_Contact__pc from Account where PersonContactId=\''+newCase.contactid+'\' LIMIT 1');
                    
                    if(personAssociatedToCase.Id != null){
                        Boolean updateAccount = false;
                        if(personAssociatedToCase.recordType.Name == 'Person Account'){
                            if(personAssociatedToCase.D2C_Contact__pc == false && consumerID != null && consumerID != ''){
                                updateAccount = true;
                                MemberPlan memberPln = [SELECT consumerid__c FROM MemberPlan WHERE 
                                                        Division_ID__c =: personAssociatedToCase.Division_Id__pc AND Client_Id__c =: personAssociatedToCase.Client_ID__pc AND ConsumerId__c =: personAssociatedToCase.Consumer_ID__pc];
                                memberPln.ConsumerId__c = consumerID; 
                                memberPlansToUpdate.add(memberPln);
                                personAssociatedToCase.Consumer_ID__pc = consumerID;
                            }
                            if(personAssociatedToCase.PersonEmail == '' || (personAssociatedToCase.PersonEmail != memberEmail)){
                                personAssociatedToCase.PersonEmail = memberEmail;
                                updateAccount = true;
                            }
                            if(updateAccount){
                                accountsToUpdate.add(personAssociatedToCase);
                            }
                        }
                    }
                }
                else{
                    //Since no person account was associated with the case, search for person based on the email address in the case description
                    System.debug('USC CUSROMER CARE ==== CONTACT BLANK');
                    List<List<Sobject>> matchOnEmailLst = [FIND :memberEmail IN ALL FIELDS RETURNING Account(Client_ID__pc,Division_Id__pc,PersonEmail,PersonContactId,D2C_Contact__pc,ConsumerID__c,Consumer_ID__pc WHERE RecordTypeId = :perAcctRecTypeId)];
                    if(!matchOnEmailLst.isEmpty()){
                        existingPersons = (List<Account>)matchOnEmailLst[0];
                    }
                    System.debug('MatchOnEmailListSize : ' + existingPersons.size());
                    //We found the person in the salesforce db. Update their consumerId
                    if(existingPersons.size() == 1){
                        System.debug('USC CUSROMER CARE ==== existingPersons found == '+ existingPersons[0].Consumer_ID__pc+ existingPersons[0].ConsumerID__c);
                        Boolean updateAccount = false;
                        if(existingPersons[0].D2C_Contact__pc == false && consumerID != null && consumerID != ''){                            
                            updateAccount = true;
                            MemberPlan memberPln = [SELECT consumerid__c FROM MemberPlan WHERE 
                                                    Division_ID__c =: existingPersons[0].Division_Id__pc AND Client_ID__c =: existingPersons[0].Client_ID__pc AND ConsumerId__c =: existingPersons[0].Consumer_ID__pc];
                            memberPln.ConsumerId__c = consumerId;
                            memberPlansToUpdate.add(memberPln);
                            existingPersons[0].Consumer_ID__pc = consumerID;
                        }
                        if(existingPersons[0].PersonEmail == '' || existingPersons[0].PersonEmail != memberEmail){
                            existingPersons[0].PersonEmail = memberEmail;
                            updateAccount = true;
                        }
                        
                        if(updateAccount){
                            accountsToUpdate.add(existingPersons[0]);
                        }
                        System.debug('USC CUSROMER CARE ==== case update == '+  existingPersons[0].PersonContactId+consumerID);
                        newCase.ContactId = existingPersons[0].PersonContactId;
                        newCase.Consumer_ID__c = existingPersons[0].ConsumerID__c;
                        casesToUpdate.add(newCase);
                    }
                    //AB commented out based on a discussion with Melinda. The new personal account will be created after a manual search on the consumer search page
                    /*  if(existingPersons.size() == 0){
                        Account newPerson = new Account();
                        newPerson.FirstName = memberFirstName;
                        newPerson.LastName = memberLastName;
                        newPerson.PersonEmail = memberEmail;
                        newPerson.RecordTypeId = perAcctRecTypeId;
                        newPersonMap.put(memberEmail,newCase);
                        personsToInsert.add(newPerson);
                        }*/
                }
            }  
        }
        if(accountsToUpdate.size() > 0){
            update accountsToUpdate;    
        }
        
        if(memberPlansToUpdate.size() > 0){
            update memberPlansToUpdate;
        }
        
        List<String> newPersonEmailList = new List<String>(newPersonMap.keySet());
        if(newPersonEmailList.size() >0){
            insert personsToInsert;
            List<Account> newPersonList = new List<Account>();
            newPersonList = [SELECT PersonEmail,PersonContactId FROM Account WHERE PersonEmail IN: newPersonEmailList];
            
            for(Account acc:newPersonList){
                newPersonMap.get(acc.PersonEmail).ContactId = acc.PersonContactId;
                casesToUpdate.add(newPersonMap.get(acc.PersonEmail));
            }
        }
        
        if(casesToUpdate.size() > 0){
            update casesToUpdate;
        }
    }
}