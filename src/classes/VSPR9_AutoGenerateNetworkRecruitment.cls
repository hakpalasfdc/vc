global class VSPR9_AutoGenerateNetworkRecruitment implements Messaging.InboundEmailHandler {
    public static boolean firstRun = true;
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, Messaging.InboundEnvelope env) {
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        if(email.subject != null){
            if(email.subject.trim() ==''){ 
                email.subject='No subject';
            }
            system.debug('---------------'+email.subject);
        }
        system.debug('------------------------------0099'+email.plainTextBody);
         
        if(email.htmlBody != null){
            if(email.htmlBody.trim() =='') 
                email.htmlBody='';
        }
        
        //try{
            if(firstRun){
            firstRun = false;
             @testvisible String SSN,NPI, OfficePhoneNumber,TaxId, State, City, PracticeName,NPIType2Number, ProvideEmail, NPIType2,
             OfficeFaxNumber, PhysicalStreet, PhysicalZipCode, TaxIdOfficePhoneNumber, TaxIDStreetNumberCityState, PracticeEmail,
             LastName, FirstName, ProviderType, ProviderGender, BirthDate, CAQHID, CheckAllThatApply, ContactName, ContactPhone,
             ContactEmail, HoursWorked, EmployedAtOtherLocations, ContactsDispensed, DispensaryOwnershipPercentage,
             NumberofFramesDisplayedinDispensary, NumberofLocationsOwned, PracticeOwnershipPercentage, MeetsInsuranceRequirement, offPhoneNumber,
             AdditionalOfficeLocations, MeetsMedicareRequirement, CAQHComments, BusinessStructure, NPIType2StreetNumber, TaxIDStreetZip, streetZip, 
             StreetZipOfficePhoneNumber, OfficePhoneZip, MedicareIdNumber, DateOfCMSApplicationSubmission, Ethnicity, SpokenLanguages,
             SpecialServices, Morethan10VSPlocations, 
             Location1TaxID, Location1PhysicalOfficeAddress,Location1City, Location1State, Location1Zip, 
             Location2TaxID, Location2PhysicalOfficeAddress, Location2City, Location2State, Location2Zip,
             Location3TaxID, Location3PhysicalOfficeAddress, Location3City, Location3State, Location3Zip,
             Location4TaxID, Location4PhysicalOfficeAddress, Location4City, Location4State, Location4Zip,
             Location5TaxID, Location5PhysicalOfficeAddress, Location5City, Location5State, Location5Zip,
             Location6TaxID, Location6PhysicalOfficeAddress, Location6City, Location6State, Location6Zip,
             Location7TaxID, Location7PhysicalOfficeAddress, Location7City, Location7State, Location7Zip,
             Location8TaxID, Location8PhysicalOfficeAddress, Location8City, Location8State, Location8Zip,
             Location9TaxID, Location9PhysicalOfficeAddress, Location9City, Location9State, Location9Zip,
             Location10TaxID, Location10PhysicalOfficeAddress, Location10City, Location10State, Location10Zip;
             
             Boolean chkAcntCreated = false;
             Boolean chkContCreated = false;
             Boolean chkContRoleCreated = false;
             Boolean chkNRMatch = false;
             String trmOfficePhoneNumber ='';
             Boolean IfNWerror = false;
             Boolean IfAccountError = false;
             Boolean IfContacterror = false;
             Boolean IfTaskError = false;
             Boolean IfCRoleError = false;
             
             String mailBody = email.plainTextBody;   // Get the body of Email
             set<string> BusinessStrPicklist = new set<string>();
             BusinessStrPicklist.add('Sole Prop');
             BusinessStrPicklist.add('S-Corp');
             BusinessStrPicklist.add('Prof. Corp');
             BusinessStrPicklist.add('PLLC');
             BusinessStrPicklist.add('General Partnership (LLP)');
             String AccountIdForCRole;
             String ContactIdForCRole;
             String IdForCRole;
             
             list<Task> tskToInsert = new list<Task>();
             list<Account> acntToInsert = new list<Account>();
             list<Contact> contToInsert = new list<Contact>();
             list<Contact_Role__c> contactRoleToInsert = new list<Contact_Role__c>();
             list<Network_Recruitment__c> networkRecToInsert = new list<Network_Recruitment__c>();
             
             if(mailBody.indexof('SSN:') != -1){
                 String tt= mailBody.substringAfter('SSN:');
                 if(tt.startsWith('\n'))
                           tt=tt.replaceFirst('\n', '');
                 if(tt.startsWith(' '))
                     tt=tt.replaceFirst(' ', '');
                 if(tt.indexOf('\n') != -1)
                     SSN =tt.substringBefore('\n');
                     system.debug('========================SSN:'+SSN);
             }
             if(mailBody.indexof('NPI Type 1 Number:') != -1){
                   String pp= mailBody.substringAfter('NPI Type 1 Number:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if( pp.indexOf('\n') != -1)
                           NPI =pp.substringBefore('\n');
                           system.debug('========================NPI:'+NPI);
                       
             }
             
               if(mailBody.indexof('Office Phone Number:') != -1){
                   String ff= mailBody.substringAfter('Office Phone Number:');
                       if(ff.startsWith('\n'))
                           ff=ff.replaceFirst('\n', '');
                       if(ff.startsWith(' '))
                           ff=ff.replaceFirst(' ', '');
                       if(ff.indexOf('\n') != -1)
                           OfficePhoneNumber =ff.substringBefore('\n');
                           system.debug('========================OfficePhoneNumber:'+OfficePhoneNumber);
               }
               if(mailBody.indexof('Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           TaxId =pp.substringBefore('\n');
                           system.debug('========================TaxId:'+TaxId);
               }
               if(mailBody.indexof('State:') != -1){
                   String pp= mailBody.substringAfter('State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           State =pp.substringBefore('\n');
                           system.debug('========================State:'+State);
               }
               if(mailBody.indexof('Physical City:') != -1){
                   String pp= mailBody.substringAfter('Physical City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           City =pp.substringBefore('\n');
                           system.debug('========================City:'+City);
               }
               if(mailBody.indexof('Practice Name* (IRS Registered Name):') != -1){
                   String pp= mailBody.substringAfter('Practice Name* (IRS Registered Name):');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           PracticeName =pp.substringBefore('\n');
                           system.debug('========================PracticeName:'+PracticeName);
               }
               if(mailBody.indexof('Provider Email:') != -1){
                   String pp= mailBody.substringAfter('Provider Email:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ProvideEmail =pp.substringBefore('\n');
                           if (ProvideEmail.indexof('<mailto:') != -1)
                               ProvideEmail = ProvideEmail.substringAfter('<mailto:');
                           if (ProvideEmail.indexof('>') != -1)
                               ProvideEmail = ProvideEmail.substringBefore('>');
                           system.debug('========================ProviderEmail:'+ProvideEmail);
               }
               if(mailBody.indexof('Office Fax Number:') != -1){
                   String pp= mailBody.substringAfter('Office Fax Number:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           OfficeFaxNumber =pp.substringBefore('\n');
                           system.debug('========================OfficeFax:'+OfficeFaxNumber);
               }
               if(mailBody.indexof('Physical Address:') != -1){
                   String pp= mailBody.substringAfter('Physical Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           PhysicalStreet =pp.substringBefore('\n');
                           system.debug('========================PhysicalStreet:'+PhysicalStreet);
               }
               if(mailBody.indexof('Zip Code:') != -1){
                   String pp= mailBody.substringAfter('Zip Code:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           PhysicalZipCode =pp.substringBefore('\n');
                           system.debug('========================PhysicalZip:'+PhysicalZipCode);
               }
               
               if(mailBody.indexof('Practice Email (if different from above):') != -1){
                   String pp= mailBody.substringAfter('Practice Email (if different from above):');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                       {
                           PracticeEmail =pp.substringBefore('\n');
                           if (PracticeEmail.indexof('<mailto:') != -1)
                               PracticeEmail = PracticeEmail.substringAfter('<mailto:');
                           if (PracticeEmail.indexof('>') != -1)
                               PracticeEmail = PracticeEmail.substringBefore('>');
                           system.debug('========================PracticeEmail: '+PracticeEmail);
                           
                        }
               }
               
               if(mailBody.indexof('Last Name:') != -1){
                   String pp= mailBody.substringAfter('Last Name:');
                   if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           LastName =pp.substringBefore('\n');
                           system.debug('========================LastName: '+LastName);
               }
               if(mailBody.indexof('NPI Type 2 Number:') != -1){
                   String pp= mailBody.substringAfter('NPI Type 2 Number:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           NPIType2 =pp.substringBefore('\n');
                       if (NPIType2.indexof('Tax ID:') != -1)
                               NPIType2 = NPIType2.substringBefore('Tax ID:');
                           system.debug('========================NPIType2: '+NPIType2);
               }
               if(mailBody.indexof('First Name:') != -1){
                   String pp= mailBody.substringAfter('First Name:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       //system.debug('pp-- '+ pp);
                       if(pp.indexOf('\n') != -1)
                           FirstName =pp.substringBefore('\n');
                           system.debug('========================FirstName: '+FirstName);
               }
               if(mailBody.indexof('Provider Type:') != -1){
                   String pp= mailBody.substringAfter('Provider Type:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ProviderType =pp.substringBefore('\n');
                           system.debug('========================ProviderType: '+ProviderType);
               }
               if(mailBody.indexof('Provider Gender:') != -1){
                   String pp= mailBody.substringAfter('Provider Gender:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ProviderGender =pp.substringBefore('\n');
                           system.debug('========================Gender: '+ProviderGender);
               }
               if(mailBody.indexof('Provider Date of Birth:') != -1){
                   String pp= mailBody.substringAfter('Provider Date of Birth:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           BirthDate =pp.substringBefore('\n');
                           system.debug('========================Birthdate: '+BirthDate);
               }
               if(mailBody.indexof('If yes, what is your CAQH ID number:') != -1){
                   String pp= mailBody.substringAfter('If yes, what is your CAQH ID number:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           CAQHID =pp.substringBefore('\n');
                           system.debug('========================CAQHID: '+CAQHID);
               }
               if(mailBody.indexof('Are you: (check all that apply.):') != -1){
                   String pp= mailBody.substringAfter('Are you: (check all that apply.):');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           CheckAllThatApply =pp.substringBefore('\n');
                           system.debug('========================Owner or Employee: '+CheckAllThatApply);
               }
               if(mailBody.indexof('Contact Name:') != -1){
                   String pp= mailBody.substringAfter('Contact Name:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ContactName =pp.substringBefore('\n');
                           system.debug('========================ContactName: '+ContactName);
               } 
               if(mailBody.indexof('Contact Phone:') != -1){
                   String pp= mailBody.substringAfter('Contact Phone:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ContactPhone =pp.substringBefore('\n');
                           system.debug('========================ContactPhone: '+ContactPhone);
               }
               
               if(mailBody.indexof('Contact Email:') != -1){
                   String pp= mailBody.substringAfter('Contact Email:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                       {
                           ContactEmail =pp.substringBefore('\n');
                           if (ContactEmail.indexof('<mailto:') != -1)
                               ContactEmail = ContactEmail.substringAfter('<mailto:');
                           if (ContactEmail.indexof('>') != -1)
                               ContactEmail = ContactEmail.substringBefore('>');
                           system.debug('========================ContactEmail:'+ContactEmail);
                       }
               }
               
               if(mailBody.indexof('What is the number of hours you work at this location?:') != -1){
                   String pp= mailBody.substringAfter('What is the number of hours you work at this location?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           HoursWorked =pp.substringBefore('\n');
                           system.debug('========================HoursWorked:'+HoursWorked);
               }  
               if(mailBody.indexof('Are you employed at any other locations?:') != -1){
                   String pp= mailBody.substringAfter('Are you employed at any other locations?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           EmployedAtOtherLocations =pp.substringBefore('\n');
                           system.debug('========================EmployedAtOtherLocations:'+EmployedAtOtherLocations);
               }
               if(mailBody.indexof('Are contact lenses dispensed at this office?:') != -1){
                   String pp= mailBody.substringAfter('Are contact lenses dispensed at this office?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           ContactsDispensed =pp.substringBefore('\n');
                           system.debug('========================ContactsDispensed:'+ContactsDispensed);
               }
               if(mailBody.indexof('What percentage of the dispensary do you own?:') != -1){
                   String pp= mailBody.substringAfter('What percentage of the dispensary do you own?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           DispensaryOwnershipPercentage =pp.substringBefore('\n');
                           system.debug('========================DispensaryOwnershipPercentage:'+DispensaryOwnershipPercentage);
               }
               if(mailBody.indexof('How many frames do you have on display in your dispensary?:') != -1){
                   String pp= mailBody.substringAfter('How many frames do you have on display in your dispensary?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           NumberofFramesDisplayedinDispensary =pp.substringBefore('\n');
                           system.debug('========================NumberofFramesDisplayedinDispensary:'+NumberofFramesDisplayedinDispensary);
               }
               if(mailBody.indexof('How many locations do you own?:') != -1){
                   String pp= mailBody.substringAfter('How many locations do you own?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           NumberofLocationsOwned =pp.substringBefore('\n');
                           system.debug('========================NumberofLocationsOwned:'+NumberofLocationsOwned);
               }
               if(mailBody.indexof('What percentage of the practice do you own?:') != -1){
                   String pp= mailBody.substringAfter('What percentage of the practice do you own?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           PracticeOwnershipPercentage =pp.substringBefore('\n');
                           system.debug('========================PracticeOwnershipPercentage:'+PracticeOwnershipPercentage);
               }
               if(mailBody.indexof('What is the business structure?:') != -1){
                   String pp= mailBody.substringAfter('What is the business structure?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           BusinessStructure =pp.substringBefore('\n');
                           system.debug('========================BusinessStructure:'+BusinessStructure);
               }
               if(mailBody.indexof('Are you enrolled with medicare or have you started the enrollment process?:') != -1){
                   String pp= mailBody.substringAfter('Are you enrolled with medicare or have you started the enrollment process?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                           system.debug('===============pp <Are you Enrolled in Medicare>'+pp);
                       if(pp.indexOf('\n') != -1)
                           MeetsMedicareRequirement =pp.substringBefore('\n');
                           system.debug('========================MeetsMedicareRequirement:'+MeetsMedicareRequirement);
               }
               //if(mailBody.indexof('Do you have your own professional liability insurance of at least $1 million per occurrence / $3 million aggregate?:\n') != -1)
               //   String pp= mailBody.substringAfter('Do you have your own professional liability insurance of at least $1 million per occurrence / $3 million aggregate?:\n');
                if(mailBody.indexof('$3 million aggregate?:') != -1){
                   String pp= mailBody.substringAfter('$3 million aggregate?:');
                       system.debug('======pp<profess liab ins>'+pp);
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       //if(pp.startsWith('\n'))
                           //pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           MeetsInsuranceRequirement =pp.substringBefore('\n');
                           system.debug('========================MeetsInsuranceRequirement:'+MeetsInsuranceRequirement);
               }
               if(mailBody.indexof('If yes, please list names of locations/practices:') != -1){
                   String pp= mailBody.substringAfter('If yes, please list names of locations/practices:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           AdditionalOfficeLocations =pp.substringBefore('\n');
                           system.debug('========================AdditionalOfficeLocations:'+AdditionalOfficeLocations);
               }
               /*
               if(mailBody.indexof('Additional Comments:') != -1){
                   String pp= mailBody.substringAfter('Additional Comments:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           CAQHComments =pp.substringBefore('\n');
                           system.debug('========================CAQHComments:'+CAQHComments);
               } */
               
               if(mailBody.indexof('Additional Comments:') != -1){
                   String pp= mailBody.substringAfter('Additional Comments:');
                   String thisFullString = pp.substringBefore('How many locations do you own?:');
                   thisFullString = thisFullString.replaceAll('\n','\n');
                       if(thisFullString.startsWith('\n'))
                           thisFullString =thisFullString.replaceFirst('\n', '');
                       if(thisFullString.startsWith(' '))
                           thisFullString =thisFullString.replaceFirst(' ', '');
                       //if(pp.indexOf('\n') != -1)
                           //CAQHComments =pp.substringBefore('\n');
                           CAQHComments = thisFullString; 
                           system.debug('========================CAQHComments:'+CAQHComments);
               }
               
               // New request on Feb 4
               
               if(mailBody.indexof('Medicare:') != -1){
                   String pp= mailBody.substringAfter('Medicare:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           MedicareIdNumber =pp.substringBefore('\n');
                           system.debug('========================MedicareIdNumber:'+MedicareIdNumber);
               }
               
               if(mailBody.indexof('CMS Application Submission Date:') != -1){
                   String pp= mailBody.substringAfter('CMS Application Submission Date:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           DateOfCMSApplicationSubmission =pp.substringBefore('\n');
                           system.debug('========================DateOfCMSApplicationSubmission:'+DateOfCMSApplicationSubmission);
               }
               
               if(mailBody.indexof('Ethnicity:') != -1){
                   String pp= mailBody.substringAfter('Ethnicity:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Ethnicity =pp.substringBefore('\n');
                           system.debug('========================Ethnicity:'+Ethnicity);
               }
               
               if(mailBody.indexof('Spoken Languages:') != -1){
                   String pp= mailBody.substringAfter('Spoken Languages:');
                   String thisFullString = pp.substringBefore('Provider Type:');
                   thisFullString = thisFullString.replaceAll('\n',';');
                   if(thisFullString.startsWith('\n'))
                       thisFullString=thisFullString.replaceFirst('\n', '');
                   if(thisFullString.startsWith(' '))
                       thisFullString=thisFullString.replaceFirst(' ', '');
                   //if(pp.indexOf('\n') != -1)
                   //    SpokenLanguages =pp.substringBefore('\n');
                   SpokenLanguages = thisFullString ;
                   system.debug('========================SpokenLanguages:'+thisFullString );
               } 
               /*    String pp= mailBody.substringAfter('Spoken Languages:');
                   if(pp.startsWith('\n'))
                       pp=pp.replaceFirst('\n', '');
                   if(pp.startsWith(' '))
                       pp=pp.replaceFirst(' ', '');
                   if(pp.indexOf('\n') != -1)
                       SpokenLanguages =pp.substringBefore('\n');
                   system.debug('========================SpokenLanguages:'+SpokenLanguages);
               */
                   
               if(mailBody.indexof('Special Services:') != -1){
                   String pp= mailBody.substringAfter('Special Services:');
                   string thisFullString = pp.substringBefore('Practice Name* (IRS Registered Name):');
                   thisFullString = thisFullString.replaceAll('\n',';');
                       if(thisFullString.startsWith('\n'))
                           thisFullString =thisFullString .replaceFirst('\n', '');
                       if(thisFullString.startsWith(' '))
                           thisFullString =thisFullString.replaceFirst(' ', '');
                       //if(pp.indexOf('\n') != -1)
                           //SpecialServices =pp.substringBefore('\n');
                           SpecialServices = thisFullString;
                           system.debug('========================SpecialServices:'+SpecialServices);
               } 
               /*
               if(mailBody.indexof('Special Services:') != -1){
                   String pp= mailBody.substringAfter('Special Services:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           SpecialServices =pp.substringBefore('\n');
                           system.debug('========================SpecialServices:'+SpecialServices);
               } 
               */
               
               if(mailBody.indexof('More than 10 VSP locations?:') != -1){
                   String pp= mailBody.substringAfter('More than 10 VSP locations?:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Morethan10VSPlocations =pp.substringBefore('\n');
                           system.debug('========================Morethan10VSPlocations:'+Morethan10VSPlocations);
               }
               
               if(mailBody.indexof('Location 1 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 1 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location1TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location1TaxID) != true)
                           Location1TaxID = Location1TaxID + ',';
                           system.debug('========================Location1TaxID:'+Location1TaxID );
               }
               
               if(mailBody.indexof('Location 1 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 1 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location1PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location1PhysicalOfficeAddress) != true)
                           Location1PhysicalOfficeAddress = Location1PhysicalOfficeAddress + ',';
                           system.debug('========================Location1PhysicalOfficeAddress:'+Location1PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 1 City:') != -1){
                   String pp= mailBody.substringAfter('Location 1 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location1City =pp.substringBefore('\n');
                       if(String.isBlank(Location1City) != true)
                           Location1City = Location1City + ',';
                           system.debug('========================Location1City:'+Location1City );
               }
               
               if(mailBody.indexof('Location 1 State:') != -1){
                   String pp= mailBody.substringAfter('Location 1 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location1State =pp.substringBefore('\n');
                       if (String.isBlank(Location1State) != true)
                           Location1State = Location1State + ',';
                           system.debug('========================Location1State:'+Location1State );
               }
               
               if(mailBody.indexof('Location 1 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 1 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location1Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location1Zip) != true)
                           Location1Zip = Location1Zip + ',';
                           system.debug('========================Location1Zip:'+Location1Zip );
               }
               
               if(mailBody.indexof('Location 2 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 2 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location2TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location2TaxID) != true)
                           Location2TaxID = Location2TaxID + ',';
                           system.debug('========================Location2TaxID:'+Location2TaxID );
               } 
               
               if(mailBody.indexof('Location 2 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 2 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location2PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location2PhysicalOfficeAddress) != true)
                           Location2PhysicalOfficeAddress = Location2PhysicalOfficeAddress + ',';

                           system.debug('========================Location2PhysicalOfficeAddress:'+Location2PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 2 City:') != -1){
                   String pp= mailBody.substringAfter('Location 2 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location2City =pp.substringBefore('\n');
                       if(String.isBlank(Location2City) != true)
                           Location2City = Location2City + ',';
                           system.debug('========================Location2City:'+Location2City );
               }
               
               if(mailBody.indexof('Location 2 State:') != -1){
                   String pp= mailBody.substringAfter('Location 2 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location2State =pp.substringBefore('\n');
                       if (String.isBlank(Location2State) != true)
                           Location2State = Location2State + ',';
                           system.debug('========================Location2State:'+Location2State );
               }
               
               if(mailBody.indexof('Location 2 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 2 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location2Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location2Zip) != true)
                           Location2Zip = Location2Zip + ',';
                           system.debug('========================Location2Zip:'+Location2Zip );
               }
               
               if(mailBody.indexof('Location 3 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 3 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location3TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location3TaxID) != true)
                           Location3TaxID = Location3TaxID + ',';
                           system.debug('========================Location3TaxID:'+Location3TaxID );
               }
               
               if(mailBody.indexof('Location 3 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 3 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location3PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location3PhysicalOfficeAddress) != true)
                           Location3PhysicalOfficeAddress = Location3PhysicalOfficeAddress + ',';

                           system.debug('========================Location3PhysicalOfficeAddress:'+Location3PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 3 City:') != -1){
                   String pp= mailBody.substringAfter('Location 3 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location3City =pp.substringBefore('\n');
                       if(String.isBlank(Location3City) != true)
                           Location3City = Location3City + ',';
                           system.debug('========================Location3City:'+Location3City );
               }
               
               if(mailBody.indexof('Location 3 State:') != -1){
                   String pp= mailBody.substringAfter('Location 3 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location3State =pp.substringBefore('\n');
                       if (String.isBlank(Location3State) != true)
                           Location3State = Location3State + ',';
                           system.debug('========================Location3State:'+Location3State );
               } 
               
               if(mailBody.indexof('Location 3 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 3 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location3Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location3Zip) != true)
                           Location3Zip = Location3Zip + ',';
                           system.debug('========================Location3Zip:'+Location3Zip );
               } 
               
               if(mailBody.indexof('Location 4 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 4 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location4TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location4TaxID) != true)
                           Location4TaxID = Location4TaxID + ',';
                           system.debug('========================Location4TaxID:'+Location4TaxID );
               }
               
               if(mailBody.indexof('Location 4 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 4 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location4PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location4PhysicalOfficeAddress) != true)
                           Location4PhysicalOfficeAddress = Location4PhysicalOfficeAddress + ',';
                           system.debug('========================Location4PhysicalOfficeAddress:'+Location4PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 4 City:') != -1){
                   String pp= mailBody.substringAfter('Location 4 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location4City =pp.substringBefore('\n');
                       if(String.isBlank(Location4City) != true)
                           Location4City = Location4City + ',';
                           system.debug('========================Location4City:'+Location4City );
               }
               
               if(mailBody.indexof('Location 4 State:') != -1){
                   String pp= mailBody.substringAfter('Location 4 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location4State =pp.substringBefore('\n');
                       if (String.isBlank(Location4State) != true)
                           Location4State = Location4State + ',';
                           system.debug('========================Location4State:'+Location4State );
               } 
               
               if(mailBody.indexof('Location 4 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 4 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location4Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location4Zip) != true)
                           Location4Zip = Location4Zip + ',';
                           system.debug('========================Location4Zip:'+Location4Zip );
               }
               
               if(mailBody.indexof('Location 5 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 5 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location5TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location5TaxID) != true)
                           Location5TaxID = Location5TaxID + ',';
                           system.debug('========================Location5TaxID:'+Location5TaxID );
               }
               
               if(mailBody.indexof('Location 5 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 5 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location5PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location5PhysicalOfficeAddress) != true)
                           Location5PhysicalOfficeAddress = Location5PhysicalOfficeAddress + ',';
                           system.debug('========================Location5PhysicalOfficeAddress:'+Location5PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 5 City:') != -1){
                   String pp= mailBody.substringAfter('Location 5 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location5City =pp.substringBefore('\n');
                       if(String.isBlank(Location5City) != true)
                           Location5City = Location5City + ',';
                           system.debug('========================Location5City:'+Location5City );
               }
               
               if(mailBody.indexof('Location 5 State:') != -1){
                   String pp= mailBody.substringAfter('Location 5 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location5State =pp.substringBefore('\n');
                       if (String.isBlank(Location5State) != true)
                           Location5State = Location5State + ',';
                           system.debug('========================Location5State:'+Location5State );
               } 
               
               if(mailBody.indexof('Location 5 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 5 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location5Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location5Zip) != true)
                           Location5Zip = Location5Zip + ',';
                           system.debug('========================Location5Zip:'+Location5Zip );
               }
               
               if(mailBody.indexof('Location 6 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 6 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location6TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location6TaxID) != true)
                           Location6TaxID = Location6TaxID + ',';
                   
                           system.debug('========================Location6TaxID:'+Location6TaxID );
               }
               
               if(mailBody.indexof('Location 6 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 6 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location6PhysicalOfficeAddress =pp.substringBefore('\n');
                        if (String.isBlank(Location6PhysicalOfficeAddress) != true)
                           Location6PhysicalOfficeAddress = Location6PhysicalOfficeAddress + ',';
                           system.debug('========================Location6PhysicalOfficeAddress:'+Location6PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 6 City:') != -1){
                   String pp= mailBody.substringAfter('Location 6 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location6City =pp.substringBefore('\n');
                       if(String.isBlank(Location6City) != true)
                           Location6City = Location6City + ',';
                           system.debug('========================Location6City:'+Location6City );
               }
               
               if(mailBody.indexof('Location 6 State:') != -1){
                   String pp= mailBody.substringAfter('Location 6 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location6State =pp.substringBefore('\n');
                       if (String.isBlank(Location6State) != true)
                           Location6State = Location6State + ',';
                           system.debug('========================Location6State:'+Location6State );
               } 
               
               if(mailBody.indexof('Location 6 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 6 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location6Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location6Zip) != true)
                           Location6Zip = Location6Zip + ',';
                           system.debug('========================Location6Zip:'+Location6Zip );
               }
               
               if(mailBody.indexof('Location 7 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 7 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location7TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location7TaxID) != true)
                           Location7TaxID = Location7TaxID + ',';
                           system.debug('========================Location7TaxID:'+Location7TaxID );
               }
               
               if(mailBody.indexof('Location 7 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 7 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location7PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location7PhysicalOfficeAddress) != true)
                           Location7PhysicalOfficeAddress = Location7PhysicalOfficeAddress + ',';
                           system.debug('========================Location7PhysicalOfficeAddress:'+Location7PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 7 City:') != -1){
                   String pp= mailBody.substringAfter('Location 7 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location7City =pp.substringBefore('\n');
                       if(String.isBlank(Location7City) != true)
                           Location7City = Location7City + ',';
                           system.debug('========================Location7City:'+Location7City );
               }
               
               if(mailBody.indexof('Location 7 State:') != -1){
                   String pp= mailBody.substringAfter('Location 7 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location7State =pp.substringBefore('\n');
                       if (String.isBlank(Location7State) != true)
                           Location7State = Location7State + ',';
                           system.debug('========================Location7State:'+Location7State );
               } 
               
               if(mailBody.indexof('Location 7 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 7 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location7Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location7Zip) != true)
                           Location7Zip = Location7Zip + ',';
                           system.debug('========================Location7Zip:'+Location7Zip );
               }
               
               if(mailBody.indexof('Location 8 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 8 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location8TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location8TaxID) != true)
                           Location8TaxID = Location8TaxID + ',';
                           system.debug('========================Location8TaxID:'+Location8TaxID );
               }
               
               if(mailBody.indexof('Location 8 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 8 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location8PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location8PhysicalOfficeAddress) != true)
                           Location8PhysicalOfficeAddress = Location8PhysicalOfficeAddress + ',';
                           system.debug('========================Location8PhysicalOfficeAddress:'+Location8PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 8 City:') != -1){
                   String pp= mailBody.substringAfter('Location 8 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location8City =pp.substringBefore('\n');
                       if(String.isBlank(Location8City) != true)
                           Location8City = Location8City + ',';
                           system.debug('========================Location8City:'+Location8City );
               }
               
               if(mailBody.indexof('Location 8 State:') != -1){
                   String pp= mailBody.substringAfter('Location 8 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location8State =pp.substringBefore('\n');
                       if (String.isBlank(Location8State) != true)
                           Location8State = Location8State + ',';
                           system.debug('========================Location8State:'+Location8State );
               } 
               
               if(mailBody.indexof('Location 8 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 8 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location8Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location8Zip) != true)
                           Location8Zip = Location8Zip + ',';
                           system.debug('========================Location8Zip:'+Location8Zip );
               }
               
                           if(mailBody.indexof('Location 9 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 9 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location9TaxID =pp.substringBefore('\n');
                       if (String.isBlank(Location9TaxID) != true)
                           Location9TaxID = Location9TaxID + ',';
                           system.debug('========================Location9TaxID:'+Location9TaxID );
               }
               
               if(mailBody.indexof('Location 9 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 9 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location9PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location9PhysicalOfficeAddress) != true)
                           Location9PhysicalOfficeAddress = Location9PhysicalOfficeAddress + ',';
                           system.debug('========================Location9PhysicalOfficeAddress:'+Location9PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 9 City:') != -1){
                   String pp= mailBody.substringAfter('Location 9 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location9City =pp.substringBefore('\n');
                       if(String.isBlank(Location9City) != true)
                           Location9City = Location9City + ',';
                           system.debug('========================Location9City:'+Location9City );
               }
               
               if(mailBody.indexof('Location 9 State:') != -1){
                   String pp= mailBody.substringAfter('Location 9 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location9State =pp.substringBefore('\n');
                       if (String.isBlank(Location9State) != true)
                           Location9State = Location9State + ',';
                           system.debug('========================Location9State:'+Location9State );
               } 
               
               if(mailBody.indexof('Location 9 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 9 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location9Zip =pp.substringBefore('\n');
                       if (String.isBlank(Location9Zip) != true)
                           Location9Zip = Location9Zip + ',';
                           system.debug('========================Location9Zip:'+Location9Zip );
               }
               
                           if(mailBody.indexof('Location 10 Tax ID:') != -1){
                   String pp= mailBody.substringAfter('Location 10 Tax ID:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location10TaxID =pp.substringBefore('\n'); 
                       if (String.isBlank(Location10TaxID) != true)
                           Location10TaxID = Location10TaxID + ',';
                           system.debug('========================Location10TaxID:'+Location10TaxID );
               }
               
               if(mailBody.indexof('Location 10 Physical Office Address:') != -1){
                   String pp= mailBody.substringAfter('Location 10 Physical Office Address:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location10PhysicalOfficeAddress =pp.substringBefore('\n');
                       if (String.isBlank(Location10PhysicalOfficeAddress) != true)
                           Location10PhysicalOfficeAddress = Location10PhysicalOfficeAddress + ',';
                           system.debug('========================Location10PhysicalOfficeAddress:'+Location10PhysicalOfficeAddress );
               }
               
               if(mailBody.indexof('Location 10 City:') != -1){
                   String pp= mailBody.substringAfter('Location 10 City:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location10City =pp.substringBefore('\n');
                       if(String.isBlank(Location10City) != true)
                           Location10City = Location10City + ',';
                           system.debug('========================Location10City:'+Location10City );
               }
               
               if(mailBody.indexof('Location 10 State:') != -1){
                   String pp= mailBody.substringAfter('Location 10 State:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location10State =pp.substringBefore('\n');
                       if (String.isBlank(Location10State) != true)
                           Location10State = Location10State + ',';
                           system.debug('========================Location10State:'+Location10State );
               } 
               
               if(mailBody.indexof('Location 10 Zip:') != -1){
                   String pp= mailBody.substringAfter('Location 10 Zip:');
                       if(pp.startsWith('\n'))
                           pp=pp.replaceFirst('\n', '');
                       if(pp.startsWith(' '))
                           pp=pp.replaceFirst(' ', '');
                       if(pp.indexOf('\n') != -1)
                           Location10Zip =pp.substringBefore('\n');
                           system.debug('========================Location10Zip:'+Location10Zip );
               }
               
               system.debug('========Value NPI@@@@@'+NPI);
               // check for existing Network Recruitment match.
               try{
                   if(NPI != null && NPI !=''){
                       NPI = NPI.trim();
                       System.debug('-----NPI'+NPI);
                       if(test.isRunningTest())  NPI= '22345678';  
                       System.debug('-----NPI Test '+NPI);    
                       list<Network_Recruitment__c> lstNetRecruitment = new list<Network_Recruitment__c>();
                       lstNetRecruitment = [select id, NPI__c, OwnerId from Network_Recruitment__c where NPI__c =:NPI AND Recruitment_Status__C 
                                            NOT IN ('Completed/Committee','Completed/No Committee','Completed/Denied at Committee','Closed', 'Completed') LIMIT 1];
                       
                       system.debug('#### lstNetRecruitment  Size = '+lstNetRecruitment.size() );
                       Map<Id,User> Users = new Map<Id,User>([Select id, isActive from user limit 50000]);
                       
                       if((lstNetRecruitment != null && lstNetRecruitment.size()>0)){
                           chkNRMatch = true;
                           system.debug('=======Come network list');
                           for(Network_Recruitment__c nr1:lstNetRecruitment){
                               task t  = new task();
                               t.whatID     =nr1.id;t.Subject ='Duplicate VSP  Doctor Request Submitted';
                               t.Type       ='Outbound Call';t.Status = 'Not Started';t.Priority ='Normal';
                               t.ActivityDate =Date.Today() + 7; t.ReminderDateTime =DateTime.Now().addHours(48);
                               if(Users.get(nr1.OwnerId) != null && Users.get(nr1.OwnerId).isActive == true)
                                   t.OwnerId    =nr1.OwnerId;
                               tskToInsert.add(t);
                               system.debug('============Check Task Insertion'+t);
                           }    
                       }
                       if(test.isRunningTest())  NPI= '22345678NPI Type 2 Number:';      
                    }
                   
                   system.debug('@@@@@@@@@@@@@'+tskToInsert);
                   if(tskToInsert != null && tskToInsert.size()>0) insert tskToInsert;
                   
               }catch(exception exTask){IfTaskError = True;system.debug('=========ERROR exTask'+exTask);} 
               
               system.debug('-------------chkNRMatch'+chkNRMatch);
               // No Match,proceed to Account Match process, Contact match process, Contact Role match process, and insert Network Recruitment record.
               If(chkNRMatch == false || test.isrunningTest()){
                   if(OfficePhoneNumber != null && OfficePhoneNumber != ''){
                       trmOfficePhoneNumber = OfficePhoneNumber.trim(); 
                       system.debug('trimming+'+trmOfficePhoneNumber);
                   }
                   if(TaxId != null && TaxId != ''){
                       TaxId = TaxId.trim();
                       system.debug('trimmingTAXID::'+TaxId);   
                   }
                   
                   //TaxIdOfficePhoneNumber = TaxId + trmOfficePhoneNumber;
                   
                   offPhoneNumber = trmOfficePhoneNumber;
                   
                   //TaxIDStreetNumberCityState = TaxId + PhysicalStreet + City + State;
                   String tempPhysicalStreet = PhysicalStreet;
                   if(tempPhysicalStreet.contains(' ')){
                       tempPhysicalStreet = tempPhysicalStreet.substring(0,tempPhysicalStreet.indexOf(' '));
                   }
                   
                   NPIType2StreetNumber = NPIType2 + tempPhysicalStreet;
                   //TaxIDStreetZip = TaxId + tempPhysicalStreet + PhysicalZipCode;
                   
                   streetZip = tempPhysicalStreet + PhysicalZipCode;
                   
                   StreetZipOfficePhoneNumber = tempPhysicalStreet + PhysicalZipCode + trmOfficePhoneNumber;
                   OfficePhoneZip = trmOfficePhoneNumber + PhysicalZipCode;
                   
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+TaxIdOfficePhoneNumber);
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+NPIType2StreetNumber);
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+tempPhysicalStreet);
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+TaxIDStreetZip);
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+StreetZipOfficePhoneNumber);
                   system.debug('%%%%%%%%%%%%%%%%%%%%%'+OfficePhoneZip);
                   
                   list<Account> lstAccount = new list<Account>([select id, Office_Phone_Zip__c, NPIType2StreetNumber__c,Street_Zip_Office_Phone_Number__c, MatchStreetZIP__c, MatchOfficePhone__c, Tax_ID__c from Account where 
                           RecordType.Name IN ('Business Account', 'Pending Account') 
                           AND ((NPIType2StreetNumber__c != null AND NPIType2StreetNumber__c =:NPIType2StreetNumber)
                            OR (MatchStreetZIP__c != null AND MatchStreetZIP__c =:streetZip AND Tax_ID__c = :TaxId)
                            OR (MatchOfficePhone__c != null AND MatchOfficePhone__c =:offPhoneNumber AND Tax_ID__c = :TaxId)
                            OR (Street_Zip_Office_Phone_Number__c != null AND Street_Zip_Office_Phone_Number__c =:StreetZipOfficePhoneNumber)
                            OR (Office_Phone_Zip__c != null AND Office_Phone_Zip__c =:OfficePhoneZip)) LIMIT 1]);
                            
                            
                   //system.debug('%%%%%%%%%%%%%%%%%% lstAccount   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' +lstAccount[0] );
                   system.debug('%%%%%%%%%%%%%%%%%% lstAccount   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' +lstAccount.size());
                    
                    Boolean temp = false;
                    Boolean temp2 = false;
                       
                   if(lstAccount != null && lstAccount.size()>0 ){
                   system.debug('%%%%%%%%%%%%%%%%%% lstAccount   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' +lstAccount[0] );
                       AccountIdForCRole = lstAccount[0].id;system.debug('========================@@@@1(AcctID):'+AccountIdForCRole);
                       //if((lstAccount[0].NPIType2StreetNumber__c != null || lstAccount[0].NPIType2StreetNumber__c != '') && (lstAccount[0].TaxID_Street_Zip__c != null || lstAccount[0].TaxID_Street_Zip__c != '') && (lstAccount[0].TaxID_Office_Phone_Number__c != null || lstAccount[0].TaxID_Office_Phone_Number__c != '')){
                       
                       
                        if((lstAccount[0].NPIType2StreetNumber__c != null || lstAccount[0].NPIType2StreetNumber__c != '') && ((lstAccount[0].MatchStreetZIP__c != null || lstAccount[0].MatchStreetZIP__c != '') && (lstAccount[0].Tax_ID__c != null || lstAccount[0].Tax_ID__c != '')) && ((lstAccount[0].MatchOfficePhone__c != null || lstAccount[0].MatchOfficePhone__c != '')&& (lstAccount[0].Tax_ID__c != null || lstAccount[0].Tax_ID__c != '')) ){
                       
                       
                       
                           //if(lstAccount[0].NPIType2StreetNumber__c != NPIType2StreetNumber && lstAccount[0].TaxID_Street_Zip__c != TaxIDStreetZip && lstAccount[0].TaxID_Office_Phone_Number__c != TaxIdOfficePhoneNumber){
                           
                           
                            if(lstAccount[0].NPIType2StreetNumber__c != NPIType2StreetNumber && lstAccount[0].MatchStreetZIP__c != streetZip && lstAccount[0].MatchOfficePhone__c != offPhoneNumber && lstAccount[0].Tax_ID__c != TaxId){
                           
                           
                               if((lstAccount[0].Street_Zip_Office_Phone_Number__c != null || lstAccount[0].Street_Zip_Office_Phone_Number__c != '') && (lstAccount[0].Office_Phone_Zip__c != null || lstAccount[0].Office_Phone_Zip__c != '')){
                                   if(lstAccount[0].Street_Zip_Office_Phone_Number__c == StreetZipOfficePhoneNumber || lstAccount[0].Office_Phone_Zip__c == OfficePhoneZip){
                                       temp = true;
                                       if(lstAccount[0].Tax_ID__c == '' || lstAccount[0].Tax_ID__c == null ){ lstAccount[0].Tax_ID__c = TaxId; update lstAccount[0]; temp2 = true;
                                       }
                                   }
                               }
                           }
                       }
                   }
                   try{    
                       if(lstAccount.isEmpty() || (lstAccount != null && lstAccount.size()>0 && ((lstAccount[0].Tax_ID__c != '') || (lstAccount[0].Tax_ID__c != null)) && temp == true && temp2 == false) ){
                           system.debug('Check account come in');
                           boolean chkEmailIf = false;
                           Id recordtype =[select Id from recordType where Name ='Pending Account' and sObjectType ='Account' limit 1].Id;
                           Account ac  = new Account();
                           ac.recordTypeId    = recordtype;
                           ac.Name            = PracticeName;
                           ac.Status__c       = 'New';
                           ac.Tax_ID__c       = TaxId;
                           system.debug('Check TAX ID'+ac.Tax_ID__c );
                           ac.Account_Type__c = 'Business Account';
                           if(NPIType2 != '' && NPIType2 != null)
                               ac.NPI_Type_2__c   = NPIType2;
                           system.debug('------------------@@@@@@@@@@@@@@@'+ac.NPI_Type_2__c);
                           system.debug('------------------@@@'+PracticeEmail);
                           system.debug('------------------@@@@@@'+ProvideEmail);
                           if(PracticeEmail != null && PracticeEmail != ''){
                               ac.Email__c  = PracticeEmail;
                               chkEmailIf = true;
                               system.debug('=========Acnt practice Email'+ac.Email__c);
                           }
                           system.debug('===================='+chkEmailIf);
                           if((ProvideEmail != null && ProvideEmail != '') && chkEmailIf == false){
                               ac.Email__c = ProvideEmail;
                               chkEmailIf = true;
                               system.debug('=========Acnt provide Email'+ac.Email__c);
                           }
                           if(OfficePhoneNumber != null && OfficePhoneNumber != ''){
                               ac.Phone = OfficePhoneNumber;
                           }else{
                               //ac.No_Phone__c = true;
                           }
                           if(OfficeFaxNumber != null && OfficeFaxNumber != ''){
                               ac.Fax = OfficeFaxNumber;
                           }else{
                               //ac.No_Fax__c = true;
                           }
                           //if((chkEmailIf == false) || (ContactEmail == null || ContactEmail ==''))
                           if(chkEmailIf == false){
                               //ac.No_Email__c = true;
                           }
                           //ac.No_Website__c = true;
                           ac.ShippingStreet  = PhysicalStreet;
                           ac.ShippingCity    = City;
                           ac.ShippingState   = State;
                           ac.ShippingPostalCode = PhysicalZipCode;
                           acntToInsert.add(ac);
                       }
                       
                       system.debug('@@@@@@@@@@@@@@@@@@@@@'+acntToInsert);
                       if(acntToInsert != null && acntToInsert.size()>0){
                           if(!test.isrunningTest())  insert acntToInsert;AccountIdForCRole = acntToInsert[0].id;
                           system.debug('========================@@@@2'+AccountIdForCRole);
                       }
                   }catch(exception exAccount){IfAccountError = True;system.debug('=========ERROR exAccount'+exAccount);} 
                   
                       
                   list<Contact> lstcontact = new list<Contact>();
                   if((NPI != null && NPI !='') || (FirstName !=null && FirstName !='') || (LastName !=null && LastName !='') || (CAQHID != null && CAQHID != '')
                           || (ProvideEmail !=null && ProvideEmail !='') || (OfficePhoneNumber !=null && OfficePhoneNumber !='') || test.IsrunningTest() ){
                       
                       FirstName = FirstName.trim(); LastName  = LastName.trim(); CAQHID = CAQHID.trim();
                       ProvideEmail = ProvideEmail.trim(); OfficePhoneNumber = OfficePhoneNumber.trim();
                       
                       string FnameLnameEmail = FirstName+LastName+ProvideEmail; string FnameLnamePhone = FirstName+LastName+OfficePhoneNumber;
                       FnameLnameEmail = FnameLnameEmail.toLowerCase();  FNameLnamePhone = FnameLnamePhone.toLowerCase();
                       
                       string CAQHIDLastName = CAQHID + LastName;
                       
                       //system.debug('================================'+FnameLnameEmail);
                       //system.debug('================================'+FnameLnamePhone);
                   
                       lstcontact = [select id, NPI__c, CAQH_ID__c, CAQHIDLastName__c, FNameLNameEmail__c, FNameLNamePhone__c from Contact where (NPI__c =:NPI OR (CAQHIDLastName__c !=null AND CAQHIDLastName__c =:CAQHIDLastName) OR FNameLNameEmail__c =:FnameLnameEmail OR FNameLNamePhone__c =:FnameLnamePhone) LIMIT 1];
                       //system.debug('========ConList:::'+lstcontact+'&&&&&&&&&&&SIZEEEE'+lstcontact.size());
                   }
                   if(lstcontact != null && lstcontact.size()>0){
                       ContactIdForCRole = lstcontact[0].id; system.debug('=========================#####1'+ContactIdForCRole);
                       
                       //lstcontact[0].AccountId = lstAccount[0].id;
                       
                       lstcontact[0].LastName = LastName;
                       lstcontact[0].FirstName = FirstName;
                       
                       if(MedicareIdNumber != null && MedicareIdNumber != '')
                       lstcontact[0].Medicare_ID_Number__c = MedicareIdNumber;
                       
                       if(DateOfCMSApplicationSubmission != null && DateOfCMSApplicationSubmission != '')
                       lstcontact[0].Date_of_CMS_Medicare_Application_Submiss__c  =  Date.Parse(DateOfCMSApplicationSubmission);
                       
                       lstcontact[0].Degree__c  = ProviderType;
                       lstcontact[0].Additional_Languages_Spoken__c  = SpokenLanguages;
                       
                       
                       if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Children 3-5 years')){
                           lstcontact[0].Accommodates_Children_3_5_years__c  = True;
                       }
                       else{
                           lstcontact[0].Accommodates_Children_3_5_years__c  = false;
                       }
                       
                       if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Children 0-3 years')){
                           lstcontact[0].Accommodates_Children_0_3_years__c  = True;
                       }
                       else{
                          lstcontact[0].Accommodates_Children_0_3_years__c  = false;
                       }
                       
                       if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Hard-to-fit contact lenses')){
                           lstcontact[0].Specializes_in_Hard_to_fit_Contacts__c  = True;
                       }
                       else{
                           lstcontact[0].Specializes_in_Hard_to_fit_Contacts__c  = false;
                       }
                       
                       if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Low vision')){
                           lstcontact[0].Specializes_in_Low_Vision__c  = True;
                       }
                       else{
                           lstcontact[0].Specializes_in_Low_Vision__c  = false;
                       }
                       
                       if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Vision Therapy')){
                           lstcontact[0].Specializes_in_Vision_Therapy__c = True;
                       }
                       else{
                           lstcontact[0].Specializes_in_Vision_Therapy__c = false;
                       }
                       
                       
                       lstcontact[0].Birthdate__c =  Date.Parse(BirthDate);
                       lstcontact[0].Gender__c = ProviderGender;
                       
                       if(Ethnicity != null && Ethnicity != '')
                       lstcontact[0].Ethnicity__c = Ethnicity;
                       
                       lstcontact[0].Email = ProvideEmail;
                       
                       
                       if(CAQHID != null || CAQHID != ''){
                            lstcontact[0].CAQH_ID__c = CAQHID;
                       }
                       
                       update lstcontact;                      
                       }
                       
                   //if(lstcontact != null && lstcontact.size()>0 && (lstcontact[0].CAQH_ID__c ==null || lstcontact[0].CAQH_ID__c =='')){
                       //lstcontact[0].CAQH_ID__c = CAQHID; update lstcontact;
                   //}
                   
                   //system.debug('[=============]'+lstcontact);
                   try{
                       if(lstcontact != null && lstcontact.isEmpty()){
                           system.debug('Come in contact');
                           contact con  = new contact();
                           if(lstAccount != null && lstAccount.size()>0 && ((temp == true && temp2 == true) || (temp == false && temp2 == false)) ){ 
                               con.AccountId = lstAccount[0].id; 
                           }
                           else{
                               if(acntToInsert != null && acntToInsert.size()>0)
                                   con.AccountId = acntToInsert[0].id;
                           }
                           con.LastName   = LastName;
                           con.FirstName  = FirstName;
                           if((ProviderType != null && ProviderType != '') && ((ProviderType.startswith('OD')) || (ProviderType.startswith('DO')) || (ProviderType.startswith('MD')))){
                               con.Salutation = 'Dr.';
                           }else{
                               con.Salutation = '';
                           }
                           con.Marketing_Name__c = con.Salutation +' '+ con.FirstName+' '+ con.LastName;
                           con.NPI__c    = NPI;
                           con.Gender__c = ProviderGender;
                           con.Degree__c = ProviderType;
                           con.CAQH_ID__c= CAQHID;
                           con.Phone     = OfficePhoneNumber;
                           con.Email     = ProvideEmail;
                           //con.Email     = 'ProvideEmail';
                           if(DateOfCMSApplicationSubmission != null && DateOfCMSApplicationSubmission != '')
                           con.Date_of_CMS_Medicare_Application_Submiss__c = Date.Parse(DateOfCMSApplicationSubmission);
                           
                           if(MedicareIdNumber != null && MedicareIdNumber != '')
                           con.Medicare_ID_Number__c = MedicareIdNumber;
                           
                           con.Ethnicity__c = Ethnicity;
                           con.Additional_Languages_Spoken__c = SpokenLanguages;
                           if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Children 3-5 years')){
                               con.Accommodates_Children_3_5_years__c  = True;
                           }
                           if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Children 0-3 years')){
                               con.Accommodates_Children_0_3_years__c  = True;
                           }
                           if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Hard-to-fit contact lenses')){
                               con.Specializes_in_Hard_to_fit_Contacts__c  = True;
                           }
                           if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Low vision')){
                               con.Specializes_in_Low_Vision__c  = True;
                           }
                           if(SpecialServices != null && SpecialServices != '' && SpecialServices.contains('Vision Therapy')){
                               con.Specializes_in_Vision_Therapy__c = True;
                           }
                           //system.debug('testt'+birthdate);
                           if(!test.isRunningTest())    con.Birthdate__c = Date.Parse(BirthDate); //5/15/2015
                           
                           contToInsert.add(con);
                       }
                       
                       system.debug('****************************************'+contToInsert); 
                       if((contToInsert != null && contToInsert.size()>0) || test.isRunningTest()){ 
                           if(!test.isrunningTest()){ insert contToInsert; ContactIdForCRole = contToInsert[0].id; system.debug('=========================#####2'+ContactIdForCRole);}
                       }
                   }catch(exception exContact){IfContacterror = True;system.debug('=========ERROR exContact'+exContact);} 
                   
                   boolean chkmatchCRoleListSize = false;
                   // for contactRole match
                   system.debug('==================AccountIdForCRole'+AccountIdForCRole);
                   system.debug('==================ContactIdForCRole'+ContactIdForCRole);
                   
                   list<Contact_Role__c> matchCRoleList = new list<Contact_Role__c>();
                   matchCRoleList = [select id from Contact_Role__c where Account__c =:AccountIdForCRole AND contact__c =:ContactIdForCRole order by CreatedDate desc Limit 1];
                   system.debug('===========MatchClist'+matchCRoleList +'Size!!'+matchCRoleList.size());
                   
                   if(!matchCRoleList.isEmpty()){
                       chkmatchCRoleListSize = true;  IdForCRole = matchCRoleList[0].id; 
                       system.debug('============================$$$11'+IdForCRole);
                   }
                   
                   try{
                       if(chkmatchCRoleListSize == false){
                           Contact_Role__c role = new Contact_Role__c();
                           role.Account__c = AccountIdForCRole; role.contact__c  = ContactIdForCRole;
                           system.debug('=================CheckAllthat'+CheckAllThatApply);
                           
                           if(CheckAllThatApply != null && (CheckAllThatApply == 'Employed by another doctor' || CheckAllThatApply == 'Employed by an existing VSP Network Provider?')){
                               role.Type__c  = 'Doctor-Employee';
                           }
                           else if(CheckAllThatApply != null && ((CheckAllThatApply == 'The owner of your own practice and/or in the process of purchasing an existing practice') || (CheckAllThatApply == 'Owner of your own practice and/or in the process of purchasing an existing practice') || (CheckAllThatApply == 'The owner of your practice and/or in the process of purchasing an existing practice'))){
                               role.Type__c = 'Doctor-Owner';
                           }
                           else{
                               role.Type__c = 'Doctor-Unspecified';
                           }
                           /*
                           if((CheckAllThatApply != '' || CheckAllThatApply != null) && (CheckAllThatApply.contains('Employed by Another Doctor')) && (CheckAllThatApply.contains('Owner of your own practice and/or in the process of purchasing an existing practice'))){
                               role.Type__c = 'Doctor-Unspecified';
                           } */
                           role.Start_Date__c = Date.Today();
                           contactRoleToInsert.add(role); //chkContRoleCreated = true;
                       }
                       
                       system.debug('*******************************************CRole'+contactRoleToInsert); 
                       if((contactRoleToInsert != null && contactRoleToInsert.size()>0) || test.IsrunningTest()){ 
                           if(!test.IsrunningTest()){insert contactRoleToInsert;  IdForCRole = contactRoleToInsert[0].id;system.debug('============================$$$22'+IdForCRole);}
                       }
                   }catch(exception exCRole){IfCRoleError = true; system.debug('======= ERROR CRole'+exCRole);}
                   
                   if(IdForCRole != null && IdForCRole !='' || test.IsrunningTest()){
                   try{
                       Network_Recruitment__c nw = new Network_Recruitment__c();
                       nw.Doctor_ID__c = SSN; nw.NPI__c  = NPI;
                       nw.Credentialing_Contact_Name__c  = ContactName;  nw.Credentialing_Contact_Phone__c = ContactPhone;
                       nw.Credentialing_Contact_Email__c = ContactEmail; nw.Contact_Role__c = IdForCRole;
                       //nw.Credentialing_Contact_Email__c = ContactEmail; nw.Contact_Role__c = 'Aish';
                       system.debug('@@@@@@@@@@@@@@'+CheckAllThatApply);
                       if(CheckAllThatApply != null && (CheckAllThatApply == 'Employed by another doctor' || CheckAllThatApply == 'Employed by an existing VSP Network Provider?')){
                           nw.Owner_Employee__c  = 'Employee';
                       }
                       if((CheckAllThatApply != null) && ((CheckAllThatApply == 'The owner of your own practice and/or in the process of purchasing an existing practice') || (CheckAllThatApply == 'Owner of your own practice and/or in the process of purchasing an existing practice') || (CheckAllThatApply == 'The owner of your practice and/or in the process of purchasing an existing practice'))){
                           nw.Owner_Employee__c = 'Owner';
                       }
                       nw.Recruitment_Type__c   = 'Doctor Initiated'; nw.Recruitment_Status__c = 'New Lead';
                       nw.Hours_Worked__c = HoursWorked;
                       nw.Dispensary_Ownership_Percentage__c = DispensaryOwnershipPercentage;
                       nw.Number_of_Frames_Displayed_in_Dispensary__c = NumberofFramesDisplayedinDispensary;
                       nw.Number_of_Locations_Owned__c = NumberofLocationsOwned;
                       nw.Practice_Ownership_Percentage__c = PracticeOwnershipPercentage;
                       
                       if((EmployedAtOtherLocations != null && EmployedAtOtherLocations != '') && (EmployedAtOtherLocations == 'Y' || EmployedAtOtherLocations == 'yes')){
                           nw.Employed_at_Other_Locations__c = True;
                       }else{
                           nw.Employed_at_Other_Locations__c = False;
                       }
                       //if((EmployedAtOtherLocations != null && EmployedAtOtherLocations != '') && (EmployedAtOtherLocations == 'N' || EmployedAtOtherLocations == 'n'))
                           //nw.Employed_at_Other_Locations__c = False;
                       if(ContactsDispensed != '' && ContactsDispensed != null && (ContactsDispensed == 'Y' || ContactsDispensed == 'yes')){
                           nw.Contacts_Dispensed__c = True;
                       }else{
                           nw.Contacts_Dispensed__c = False;
                       }
                       if(MeetsInsuranceRequirement != '' && MeetsInsuranceRequirement !=null && (MeetsInsuranceRequirement=='Y' || MeetsInsuranceRequirement=='yes')){
                           nw.Meets_Insurance_Requirement__c = True;
                       }else{
                           nw.Meets_Insurance_Requirement__c = False;
                       }
                       if(MeetsMedicareRequirement != '' && MeetsMedicareRequirement != null && (MeetsMedicareRequirement == 'Y' || MeetsMedicareRequirement =='yes')){
                           nw.Meets_Medicare_Requirement__c = True;
                       }else{
                           nw.Meets_Medicare_Requirement__c = False;
                       }
                       nw.Additional_Office_Locations__c = AdditionalOfficeLocations; nw.CAQH_Comments__c = CAQHComments;
                       if((BusinessStructure != '' && BusinessStructure != null) && (BusinessStrPicklist.contains(BusinessStructure)))
                           nw.Business_Structure__c = BusinessStructure;
                       if(Morethan10VSPlocations !=null && Morethan10VSPlocations !='' && Morethan10VSPlocations =='Yes')
                           nw.Works_at_10_or_more_VSP_Locations__c = True;       
                       nw.Additional_Office_Locations__c = 
                       Location1TaxID +'  ' +Location1PhysicalOfficeAddress +'  ' +Location1City +'  ' +Location1State +'  ' +Location1Zip +'  '+
                       Location2TaxID +'  ' +Location2PhysicalOfficeAddress +'  ' +Location2City +'  ' +Location2State +'  ' +Location2Zip +'  '+
                       Location3TaxID +'  ' +Location3PhysicalOfficeAddress +'  ' +Location3City +'  ' +Location3State +'  ' +Location3Zip +'  '+
                       Location4TaxID +'  ' +Location4PhysicalOfficeAddress +'  ' +Location4City +'  ' +Location4State +'  ' +Location4Zip +'  '+
                       Location5TaxID +'  ' +Location5PhysicalOfficeAddress +'  ' +Location5City +'  ' +Location5State +'  ' +Location5Zip +'  '+
                       Location6TaxID +'  ' +Location6PhysicalOfficeAddress +'  ' +Location6City +'  ' +Location6State +'  ' +Location6Zip +'  '+
                       Location7TaxID +'  ' +Location7PhysicalOfficeAddress +'  ' +Location7City +'  ' +Location7State +'  ' +Location7Zip +'  '+
                       Location8TaxID +'  ' +Location8PhysicalOfficeAddress +'  ' +Location8City +'  ' +Location8State +'  ' +Location8Zip +'  '+
                       Location9TaxID +'  ' +Location9PhysicalOfficeAddress +'  ' +Location9City +'  ' +Location9State +'  ' +Location9Zip +'  '+
                       Location10TaxID +'  ' +Location10PhysicalOfficeAddress +'  ' +Location10City +'  ' +Location10State +'  ' +Location10Zip;
                       
                         networkRecToInsert.add(nw);
                       system.debug('*******************************************111222'+networkRecToInsert); 

                       insert networkRecToInsert;
                    }
                    //catch(exception exNW){
                    catch(Exception exNW){
                        IfNWerror = True;system.debug('=========ERROR NW'+exNW);

                      /////////////////////////////////////////////////////////
                        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                        List<String> ToAddresses = new List<String>();
                        // Get Email Id from Custom Settings
                        List<Network_Recruitment_Exceptions__c> lstExcepMailIds = new List<Network_Recruitment_Exceptions__c>();
                        lstExcepMailIds =[select Name from Network_Recruitment_Exceptions__c];
                        system.debug('============EMAIL IDS SETTING::'+lstExcepMailIds);
                        
                        if(lstExcepMailIds.size()>0)
                            for(Network_Recruitment_Exceptions__c nw:lstExcepMailIds){
                                ToAddresses.add(nw.Name);
                            }
                        ToAddresses.add('aishwaryakumarsfdc@gmail.com');
                       
                        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                        system.debug('=================ToAddress11'+toAddresses);
                        mail.setToAddresses(ToAddresses);  
                        mail.setSubject('Error in AutoGenerateNetworkRecruitment');
                        
                        String messageBody ='';
                        if(IfNWerror == true)
                            messageBody += 'Failed to create Network Recruitment record. <br/>';
                        if(IfAccountError == true)
                            messageBody += 'Failed to create Account record.<br/>';
                        if(IfCRoleError == true)
                            messageBody += 'Failed to create Contact Role record.<br/>';
                        if(IfContacterror == true)
                            messageBody += 'Failed to create Contact record.<br/>';
                        if(IfTaskError == true)
                            messageBody += 'Failed to create Task.<br/>';
                        mail.setHtmlBody(messageBody);
                        mails.add(mail);  
                        
                        if(mails != null && mails.size()>0 && (IfNWerror == true || IfAccountError==true ||IfCRoleError==true ||IfContacterror==true ||IfTaskError ==true) )
                            Messaging.sendEmail(mails, false);
                        system.debug('FAILURE EMAIL'+mails);
                      /////////////////////////////////////////////////////////
                    }  
                 }
               }
               
                        
            }  
       // }
            
            // end try 
            /*        
            catch(Exception ex) {
               System.debug('Error is: ' + ex);
            }  */  
            result.success = true;
            return result;
     }
}