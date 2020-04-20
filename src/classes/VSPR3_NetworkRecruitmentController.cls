public with sharing class VSPR3_NetworkRecruitmentController {

  ApexPages.StandardController setStanCon;
    Id ContactRoleId;
  public String dateOfBirth;
  public String AccountName;
  public String ContactCAQH;
  public String ContactDegree;
  public Datetime ContactBirthdate;
       
  public String AccountPhysicalStreet;
  public String AccountPhysicalCity;
  public String AccountPhysicalState;
  public String AccountPhysicalZip;
  public String AccountEmail;
  public String AccountPhone;
  public String AccountFax;
  public String ContactName;
  public String ContactNames;

    public VSPR3_NetworkRecruitmentController(ApexPages.StandardController stdcontroller) {
    this.setStanCon = stdcontroller;
    ContactRoleID = ApexPages.currentPage().getParameters().get('cRoleid');
    dateOfBirth = ApexPages.currentPage().getParameters().get('dob');
    
    }


  public PageReference getRawDetails() {  
       
  Contact_Role__c cRole = [Select Id,Name,Name_of_Account__c,
                                    Name_of_Contact__c,
                                    Name_of_Physical_City__c,
                                    Name_of_Physical_State__c,
                                    Name_of_Physical_Street__c,
                                    Name_of_Physical_Zip__c,
                                    Email_of_Account__c,
                                    Fax_of_Account__c,
                                    CAQH_ID_of_Contact__c,
                                    Degree_on_Contact__c,
                                    Phone_of_Account__c,
                                    Type__c,
                                    Contact__c,
                                    Contact__r.Birthdate
                         from Contact_Role__c where Id =: ContactRoleID ];
    

        
        if (ContactRoleId <> null) {
        
            if(cRole.Name_of_Account__c <> null){
                AccountName = cRole.Name_of_Account__c;
            }
            else{
                AccountName ='';
            }
            if(cRole.CAQH_ID_of_Contact__c <> null){
                ContactCAQH= cRole.CAQH_ID_of_Contact__c;
            }
            else{
                ContactCAQH='';
            }
            if(cRole.Degree_on_Contact__c <> null){
                ContactDegree= cRole.Degree_on_Contact__c;
            }
            else{
                ContactDegree='';
            }
            
            Contact con = [Select Birthdate__c from Contact where id = :cRole.Contact__c];
            Date conBirthdate = con.Birthdate__c;
            
            if(conBirthdate <> null){
                
                ContactBirthdate= conBirthdate;
                
            }
            else{
                //ContactBirthdate=date.valueOf(ApexPages.currentPage().getParameters().get('dob'));
                //ContactBirthdate=null;
            }
            if(cRole.Name_of_Physical_Street__c <> null){
                AccountPhysicalStreet= cRole.Name_of_Physical_Street__c;
            }
            else{
                AccountPhysicalStreet='';
            }
            if(cRole.Name_of_Physical_City__c <> null){
                AccountPhysicalCity= cRole.Name_of_Physical_City__c;
            }
            else{
                AccountPhysicalCity='';
            }
            if(cRole.Name_of_Physical_State__c <> null){
                AccountPhysicalState= cRole.Name_of_Physical_State__c;
            }
            else{
                AccountPhysicalState='';
            }
            if(cRole.Name_of_Physical_Zip__c <> null){
                AccountPhysicalZip= cRole.Name_of_Physical_Zip__c;
            }
            else{
                AccountPhysicalZip='';
            }
            if(cRole.Email_of_Account__c <> null){
                AccountEmail= cRole.Email_of_Account__c;
            }
            else{
                AccountEmail='';
            } 
            if(cRole.Phone_of_Account__c <> null){
                AccountPhone= cRole.Phone_of_Account__c;
            }
            else{
                AccountPhone='';
            }
            if(cRole.Fax_of_Account__c <> null){
                AccountFax= cRole.Fax_of_Account__c;
            }
            else{
                AccountFax='';
            }
            if(cRole.Name_of_Contact__c <> null){
                ContactName= cRole.Name_of_Contact__c;
            }
            else{
                ContactName='';
            } 
            
      //additional      
            if(cRole.Contact__c <> null){
                ContactNames= cRole.Contact__c;
            }
            else{
                ContactNames='';
            }

           if(ApexPages.currentPage().getParameters().get('dob') == ''){
           return new PageReference('/a0h/e?00NJ00000013rMZ=' + AccountName  +
                                    '&00NJ00000013chD=' + ContactCAQH + 
                                    '&00NJ00000013ch8=' + ContactDegree +                  
                                    '&00NJ00000013r3m=' + AccountPhysicalStreet +
                                    '&00NJ00000013r2j=' + AccountPhysicalCity +
                                    '&00NJ00000013r3c=' + AccountPhysicalState +
                                    '&00NJ00000013r3w=' + AccountPhysicalZip +
                                    '&00NJ00000013r38=' + AccountEmail +
                                    '&00NJ00000013r3N=' + AccountPhone +
                                    '&00NJ00000013r3D=' + AccountFax +
                                    '&00NJ00000013rMe=' + ContactName +
                                   // + '&CF00NJ00000013UKG=' + ContactName + '&CF00NJ00000013UKG_lkid='+ cRole.Contact__c +
                                    + '&CF00NJ00000013r46=' + cRole.Type__c + '&CF00NJ00000013r46_lkid=' + cRole.Id );
           }
           else {
           
           // 2013-09-01 00:00:00
           
           date dateBirth= date.parse(dateOfBirth);
           Integer day = dateBirth.day();
           Integer month = dateBirth.month();
           Integer year = dateBirth.year();
           
           DateTime myDate = dateTime.newinstance(year,month,day);
           String newDate = myDate.format('MM/dd/yyyy');
           //system.assertEquals(newDate,'aaa' );
           
           return new PageReference('/a0h/e?00NJ00000013rMZ=' + AccountName  +
                                    '&00NJ00000013chD=' + ContactCAQH + 
                                    '&00NJ00000013ch8=' + ContactDegree +
                                    //'&00NJ00000013chI=' + date.valueOf(dateOfBirth) +
                                    '&00NJ00000013chI=' + newDate +
                                    '&00NJ00000013r3m=' + AccountPhysicalStreet +
                                    '&00NJ00000013r2j=' + AccountPhysicalCity +
                                    '&00NJ00000013r3c=' + AccountPhysicalState +
                                    '&00NJ00000013r3w=' + AccountPhysicalZip +
                                    '&00NJ00000013r38=' + AccountEmail +
                                    '&00NJ00000013r3N=' + AccountPhone +
                                    '&00NJ00000013r3D=' + AccountFax +
                                    '&00NJ00000013rMe=' + ContactName +
                                   // + '&CF00NJ00000013UKG=' + ContactName + '&CF00NJ00000013UKG_lkid='+ cRole.Contact__c +
                                    + '&CF00NJ00000013r46=' + cRole.Type__c  + '&CF00NJ00000013r46_lkid=' + cRole.Id );
           }
           }      
       else {
           return new PageReference ('/home/home.jsp');
       }
    }
}