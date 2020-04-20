public class VSP_CTI_Controller {
    
    
    public String conIdValue{get; set;}
    public String Call_Intent{get; set;}
    public String caseId{get; set;}
    public String caseNum{get; set;}
    public String IVRDNIS{get; set;}
    public String IVRConId{get; set;}
    public List<String> Arraylist{get;set;}
    public String conIdList{get;set;}
    public String senderNum {get;set;}
    public List<Contact> conLst {get;set;}
    public List<Contact> conLstNonEye {get;set;}
    public String processNum {get;set;}
    public String conFirstLast {get;set;}
    
    
    
    public void VSP_CTI_Controller(){
        //  conIdValue = 'TestId';
        //  String conIdValue = Apexpages.currentPage().getParameters().get('conIdValue');
        if (conIdList != null){
            Arraylist = conIdList.split(';');
        }
        system.debug('FIND THIS conIdList ' + conIdList);
        system.debug('FIND THIS Arraylist ' + Arraylist);
        ///New Case Create///
        if(conIdList != null && conIdList != ''){
            try{
                String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
                String conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
                conLstNonEye = [SELECT Id, Eyeconic_Primary_Phone__c, FirstName, LastName FROM Contact WHERE Id IN :Arraylist AND RecordTypeId = :conRecordTypeId ORDER BY LastModifiedDate DESC];
                conLst = [SELECT Id, Eyeconic_Primary_Phone__c, FirstName, LastName FROM Contact WHERE Id IN :Arraylist AND Eyeconic_Primary_Phone__c != null AND RecordTypeId = :conRecordTypeId ORDER BY LastModifiedDate DESC];
                system.debug('conLst ' + conLst);
                if(conLst.size() == 1){
                    
                    if(Arraylist.size() == 1){
                        
                        for(Contact cLst :conLst){
                            String tphone = cLst.Eyeconic_Primary_Phone__c.replaceAll('\\D','');
                            system.debug('tphone ' + tphone);
                            system.debug('senderNum ' + senderNum);
                            if(tphone == senderNum){
                                
                               
                                // String[] Fields = Call_Intent.split(';');
                                //Integer LastValue = Fields.size() - 1;
                                Case newCase = new Case(
                                    RecordTypeId = caseRecordTypeId,
                                    Subject = 'Eyeconic phone call',
                                    Description = 'Eyeconic phone call',
                                    Line_of_Business__c = 'Retail',
                                    Case_Priority__c = 'Medium',
                                    Origin = 'Phone',
                                    Type = 'Issue',
                                    Status = 'New',
                                    Product__c = 'Eyeconic USC',
                                    Auto_Assign__c = false,
                                    IVR_DNIS__c = IVRDNIS,
                                    IVR_Contact_ID__c = IVRConId,
                                    //  IVR_Caller_Intent__c = Fields[LastValue],
                                    ContactId = cLst.Id);
                                insert newCase; 
                                caseId = newCase.Id;
                                conIdValue = cLst.Id;
                                newCase = [select Id, CaseNumber from Case where Id = :caseId];
                                caseNum = newCase.CaseNumber;
                                conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                                processNum = 'found1EyeconCaseOutFocus';
                                system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue);
                                return;
                                //   system.debug('FIND THIS ' + conIdValue +' Call_Intent '+ Call_Intent + ' Case Num ' + caseNum + ' Array Size' + LastValue );
                            }
                            else{
                                
                                // String[] Fields = Call_Intent.split(';');
                                //Integer LastValue = Fields.size() - 1;
                                Case newCase = new Case(
                                    RecordTypeId = caseRecordTypeId,
                                    Subject = 'Eyeconic phone call',
                                    Description = 'Eyeconic phone call',
                                    Line_of_Business__c = 'Retail',
                                    Case_Priority__c = 'Medium',
                                    Origin = 'Phone',
                                    Type = 'Issue',
                                    Status = 'New',
                                    Product__c = 'Eyeconic USC',
                                    Auto_Assign__c = false,
                                    IVR_DNIS__c = IVRDNIS,
                                    IVR_Contact_ID__c = IVRConId);
                                //  IVR_Caller_Intent__c = Fields[LastValue],
                                // ContactId = cLst.Id);
                                insert newCase; 
                                caseId = newCase.Id;
                                conIdValue = cLst.Id;
                                newCase = [select Id, CaseNumber from Case where Id = :caseId];
                                caseNum = newCase.CaseNumber;
                                conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                                processNum = 'found1EyeconCaseOutFocus';
                                system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue);                            
                                return;
                                
                            }
                        }
                    }
                    else if(Arraylist.size() > 1){
                        
                        for(Contact cLst :conLst){
                            String tphone = cLst.Eyeconic_Primary_Phone__c.replaceAll('\\D','');
                            system.debug('tphone ' + tphone);
                            system.debug('senderNum ' + senderNum);
                            if(tphone == senderNum){
                                
                                // String[] Fields = Call_Intent.split(';');
                                //Integer LastValue = Fields.size() - 1;
                                Case newCase = new Case(
                                    RecordTypeId = caseRecordTypeId,
                                    Subject = 'Eyeconic phone call',
                                    Description = 'Eyeconic phone call',
                                    Line_of_Business__c = 'Retail',
                                    Case_Priority__c = 'Medium',
                                    Origin = 'Phone',
                                    Type = 'Issue',
                                    Status = 'New',
                                    Product__c = 'Eyeconic USC',
                                    Auto_Assign__c = false,
                                    IVR_DNIS__c = IVRDNIS,
                                    IVR_Contact_ID__c = IVRConId,
                                    //  IVR_Caller_Intent__c = Fields[LastValue],
                                    ContactId = cLst.Id);
                                insert newCase; 
                                caseId = newCase.Id;
                                conIdValue = cLst.Id;
                                newCase = [select Id, CaseNumber from Case where Id = :caseId];
                                caseNum = newCase.CaseNumber;
                                conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                                processNum = 'Multifound1EyeconCaseOutFocus';
                                system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue);
                                return;
                                //   system.debug('FIND THIS ' + conIdValue +' Call_Intent '+ Call_Intent + ' Case Num ' + caseNum + ' Array Size' + LastValue );
                            }
                            else{
                                
                                // String[] Fields = Call_Intent.split(';');
                                //Integer LastValue = Fields.size() - 1;
                                Case newCase = new Case(
                                    RecordTypeId = caseRecordTypeId,
                                    Subject = 'Eyeconic phone call',
                                    Description = 'Eyeconic phone call',
                                    Line_of_Business__c = 'Retail',
                                    Case_Priority__c = 'Medium',
                                    Origin = 'Phone',
                                    Type = 'Issue',
                                    Status = 'New',
                                    Product__c = 'Eyeconic USC',
                                    Auto_Assign__c = false,
                                    IVR_DNIS__c = IVRDNIS,
                                    IVR_Contact_ID__c = IVRConId);
                                //  IVR_Caller_Intent__c = Fields[LastValue],
                                // ContactId = cLst.Id);
                                insert newCase; 
                                caseId = newCase.Id;
                                conIdValue = cLst.Id;
                                newCase = [select Id, CaseNumber from Case where Id = :caseId];
                                caseNum = newCase.CaseNumber;
                                conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                                processNum = 'Multifound1EyeconCaseOutFocus';
                                system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue);                            
                                return;
                                
                            }
                        }
                        
                    }
                }
                else if(conLst.size() > 1){
                    
                    // String[] Fields = Call_Intent.split(';');
                    //Integer LastValue = Fields.size() - 1;
                    Case newCase = new Case(
                        RecordTypeId = caseRecordTypeId,
                        Subject = 'Eyeconic phone call',
                        Description = 'Eyeconic phone call',
                        Line_of_Business__c = 'Retail',
                        Case_Priority__c = 'Medium',
                        Origin = 'Phone',
                        Type = 'Issue',
                        Status = 'New',
                        Product__c = 'Eyeconic USC',
                        Auto_Assign__c = false,
                        IVR_DNIS__c = IVRDNIS,
                        IVR_Contact_ID__c = IVRConId);
                    //  IVR_Caller_Intent__c = Fields[LastValue],
                    // ContactId = cLst.Id);
                    insert newCase; 
                    caseId = newCase.Id;
                    //  conIdValue = cLst.Id;
                    newCase = [select Id, CaseNumber from Case where Id = :caseId];
                    caseNum = newCase.CaseNumber;
                    // conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                    processNum = 'MultifoundMultiEyeconCaseOutFocus';
                    system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue + 'ConLst size '+ conLst.size() + ' Array size ' + Arraylist.size());                            
                    return;
                    
                }
                
                
                else if(conLst.isEmpty()){///count is 0
                    if(Arraylist.size() == 1){
                        
                        for(Contact cLst :conLstNonEye){

                            // String[] Fields = Call_Intent.split(';');
                            //Integer LastValue = Fields.size() - 1;
                            Case newCase = new Case(
                                RecordTypeId = caseRecordTypeId,
                                Subject = 'Eyeconic phone call',
                                Description = 'Eyeconic phone call',
                                Line_of_Business__c = 'Retail',
                                Case_Priority__c = 'Medium',
                                Origin = 'Phone',
                                Type = 'Issue',
                                Status = 'New',
                                Product__c = 'Eyeconic USC',
                                Auto_Assign__c = false,
                                IVR_DNIS__c = IVRDNIS,
                                IVR_Contact_ID__c = IVRConId);
                            //  IVR_Caller_Intent__c = Fields[LastValue],
                            // ContactId = cLst.Id);
                            insert newCase; 
                            caseId = newCase.Id;
                            conIdValue = cLst.Id;
                            newCase = [select Id, CaseNumber from Case where Id = :caseId];
                            caseNum = newCase.CaseNumber;
                            conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                            processNum = 'found1conCaseOutFocus';
                            system.debug('ProcessNum ' + processNum + ' ConId ' + conIdValue + 'ConLst size '+ conLst.size() + ' Array size ' + Arraylist.size());                            
                            return;
                        }
                    }
                    else{
                        
                        // String[] Fields = Call_Intent.split(';');
                        //Integer LastValue = Fields.size() - 1;
                        Case newCase = new Case(
                            RecordTypeId = caseRecordTypeId,
                            Subject = 'Eyeconic phone call',
                            Description = 'Eyeconic phone call',
                            Line_of_Business__c = 'Retail',
                            Case_Priority__c = 'Medium',
                            Origin = 'Phone',
                            Type = 'Issue',
                            Status = 'New',
                            Product__c = 'Eyeconic USC',
                            Auto_Assign__c = false,
                            IVR_DNIS__c = IVRDNIS,
                            IVR_Contact_ID__c = IVRConId);
                        //  IVR_Caller_Intent__c = Fields[LastValue],
                        // ContactId = cLst.Id);
                        insert newCase; 
                        caseId = newCase.Id;
                        // conIdValue = cLst.Id;
                        newCase = [select Id, CaseNumber from Case where Id = :caseId];
                        caseNum = newCase.CaseNumber;
                        // conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                        processNum = 'foundMulticonCaseInFocus';  ///multiple contacts no eye phone numbers
                        system.debug('ProcessNum ' + processNum + 'ConLst size '+ conLst.size() + ' Array size ' + Arraylist.size());                            
                        return;
                    }
                }
            }///end Try
            catch(Exception e){
                System.debug('ERROR:' + e); 
            }
        }
        else{////array size is 0
            try{
                
                String caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Eyeconic').getRecordTypeId();
                // String[] Fields = Call_Intent.split(';');
                //Integer LastValue = Fields.size() - 1;
                Case newCase = new Case(
                    RecordTypeId = caseRecordTypeId,
                    Subject = 'Eyeconic phone call',
                    Description = 'Eyeconic phone call',
                    Line_of_Business__c = 'Retail',
                    Case_Priority__c = 'Medium',
                    Origin = 'Phone',
                    Type = 'Issue',
                    Status = 'New',
                    Product__c = 'Eyeconic USC',
                    Auto_Assign__c = false,
                    IVR_DNIS__c = IVRDNIS,
                    IVR_Contact_ID__c = IVRConId);
                //  IVR_Caller_Intent__c = Fields[LastValue],
                // ContactId = cLst.Id);
                insert newCase; 
                caseId = newCase.Id;
                // conIdValue = cLst.Id;
                newCase = [select Id, CaseNumber from Case where Id = :caseId];
                caseNum = newCase.CaseNumber;
                // conFirstLast = cLst.FirstName + ' ' + cLst.LastName;
                processNum = 'found0conCaseInFocus';  ///no contacts
                system.debug('ProcessNum ' + processNum + 'No Contacts found');                            
                return;                
            }
            catch(Exception e){
                System.debug('ERROR:' + e); 
            }
        }
    }
    
}