//Apex Class called by the AccountTrigger
//Used for calculating Contract Type on the Business Acccount.
public class VSPR31_BusAccContractTypeCalculation {

    private static Id businessRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
    private static Id practiceRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Practice Account').getRecordTypeId();
    //private static String practiceException;
    private static final Date todayDate = System.today();

    public void ContractTypeCalculationBeforeInsert(List<Account> acc){

        Set<Id> accountIdSet = new Set<Id>();
        List<Account> accountList = new List<Account>(); //To get the list of practice accounts;
        Map<Id, String> practiceExceptionMap = new Map<Id, String>();


        for(Account a: acc){

            if(businessRecordTypeID == a.recordTypeID && a.ParentId != null){ //Added condition to check that the business account created has parentId
                
                accountIdSet.add(a.ParentId);
                //calculator(a);
                
            }else{
                a.Contract_Type__c = null;
            }
        }

        accountList = [Select id, Vision_Care_Practice_Exception__c from Account where recordTypeID = :practiceRecordTypeID and id in :accountIdSet and Vision_Care_Good_Standing__c = true];

        if(accountList.size()>0){
            for(Account a: accountList){
                practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);
            }

            for(Account a: acc){
                if(practiceExceptionMap.containsKey(a.ParentId)){
                    calculator(a, practiceExceptionMap.get(a.ParentId));    
                }else{
                    a.Contract_Type__c = null;
                }
            }
        }

    } 

    public void ContractTypeCalculationBeforeUpdate(list<Account> newAccountList, Map<Id, Account> oldAccountMap){

        Set<id> practiceAccountSet = new Set<Id>();
        Set<id> practiceIdSet = new Set<Id>();
        Set<id> businessIdSet = new Set<Id>();
        List<Account> businessAccountList = new List<Account>();
        List<Account> businessPracticeAccountList = new List<Account>();
        List<Account> practiceAccountList = new List<Account>();
        Map<Id, String> practiceExceptionMap = new Map<Id, String>();

        for(Account a: newAccountList){

            //below if statement updated by Vikhyat. Updated to include conditions for Non Vc Exception fields on the Business account level.
            if(a.Location_Type__c == oldAccountMap.get(a.id).Location_Type__c && a.Vision_Care_Good_Standing__c == oldAccountMap.get(a.id).Vision_Care_Good_Standing__c && 
                a.Parent_Company__c == oldAccountMap.get(a.id).Parent_Company__c && a.Provider_Category__c == oldAccountMap.get(a.id).Provider_Category__c && 
                a.Vision_Care_Location_Exception__c == oldAccountMap.get(a.id).Vision_Care_Location_Exception__c && a.ParentId == oldAccountMap.get(a.id).ParentId && 
                a.recordTypeId == businessRecordTypeID && oldAccountMap.get(a.id).recordTypeId == businessRecordTypeID && a.Non_VC_Exception__c == oldAccountMap.get(a.id). Non_VC_Exception__c &&
                a.Vision_Care_Effective_Date__c == oldAccountMap.get(a.id).Vision_Care_Effective_Date__c && a.Vision_Care_End_Date__c == oldAccountMap.get(a.id).Vision_Care_End_Date__c){
                //This condition checks if Location type, good standing, provider category, parent company, VC location Exception on the updated business account matches the values of the old business acoount record
                continue;
            }else if(a.recordTypeId == practiceRecordTypeID && oldAccountMap.get(a.id).recordTypeID == practiceRecordTypeID && 
                a.Vision_Care_Practice_Exception__c == oldAccountMap.get(a.id).Vision_Care_Practice_Exception__c && 
                a.Vision_Care_Good_Standing__c == oldAccountMap.get(a.id).Vision_Care_Good_Standing__c){
                //This condition runs when a Practice account is updated and Vision Care practice exception value is same as the old record in the updated record.
                //Also the practice account is still in good standing.
                continue;
            }else if(a.recordTypeId == practiceRecordTypeID && oldAccountMap.get(a.id).recordTypeId == practiceRecordTypeID && 
                (oldAccountMap.get(a.id).Vision_Care_Practice_Exception__c != a.Vision_Care_Practice_Exception__c || 
                    a.Vision_Care_Good_Standing__c != oldAccountMap.get(a.id).Vision_Care_Good_Standing__c)){
                //This condition checks if either Vision Care Practice Exception value or Vision Care Good Standing value on the Practice Account is updated.
                //In such a scenario we have to re-calculate the value of the contract type on business accounts associted to the practice.
                if(a.Vision_Care_Good_Standing__c == true){
                    practiceAccountSet.add(a.id);
                    practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);    
                }else{
                    practiceAccountSet.add(a.id);
                }
                /*practiceAccountSet.add(a.id);
                practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);*/
                //practiceIdSet.add(a.id);
            }
            //Below else if condition updated by Vikhyat on 08/26/2019. Updated to include conditions for Non VC Exception field on the Business Account level.
            else if(a.recordTypeId == businessRecordTypeID && oldAccountMap.get(a.id).recordTypeId == businessRecordTypeID && a.Vision_Care_Good_Standing__c == true && 
                (a.Location_Type__c != oldAccountMap.get(a.id).Location_Type__c || a.Provider_Category__c != oldAccountMap.get(a.id).Provider_Category__c || 
                    a.Parent_Company__c != oldAccountMap.get(a.id).Parent_Company__c || a.Vision_Care_Location_Exception__c != oldAccountMap.get(a.id).Vision_Care_Location_Exception__c || 
                    a.Non_VC_Exception__c != oldAccountMap.get(a.id).Non_VC_Exception__c || a.Vision_Care_Effective_Date__c != oldAccountMap.get(a.id).Vision_Care_Effective_Date__c || 
                    a.Vision_Care_End_Date__c != oldAccountMap.get(a.id).Vision_Care_End_Date__c)){
                //This condition checks if any field used for calculation of contract type on the business account gets updated.
                //If ParentId is missing, then the contract type == null else we will we will re-calculate contract type taking the updated values in consideration. 
                if(a.ParentId != null){
                    practiceIdSet.add(a.ParentId);
                    businessAccountList.add(a);
                }else{
                    a.Contract_Type__c = null;
                }
            }else if(a.recordTypeID == businessRecordTypeID && oldAccountMap.get(a.id).recordTypeID == businessRecordTypeID && a.Vision_Care_Good_Standing__c == true && 
                (a.ParentId != null || a.ParentId != oldAccountMap.get(a.id).parentId)){
                //Condition when business account is now associated to a practice.
                //In this scenario we need to calculate the contract type for the business account.
                practiceIdSet.add(a.ParentId);
                businessAccountList.add(a);
            }else if((a.recordTypeId == businessRecordTypeID && a.ParentId == null && oldAccountMap.get(a.id).parentId != null && 
                oldAccountMap.get(a.id).recordTypeId == businessRecordTypeID) || 
                (a.recordTypeId == practiceRecordTypeID && oldAccountMap.get(a.id).recordTypeId == businessRecordTypeID)){
                /* Conditions checked: -
                        1. When parentID is removed from the updated business account record.
                        2. When a business account gets converted to a practice account.

                    When either of the above mentioned conditions meet, contract type == null
                */
                a.Contract_Type__c = null;
            }else if(a.recordtypeId == businessRecordTypeID && oldAccountMap.get(a.id).recordtypeId == practiceRecordTypeID){
                if(a.ParentId != null){
                    practiceIdSet.add(a.ParentId);
                    businessAccountList.add(a);
                    businessIdSet.add(a.id);
                }else{
                    businessIdSet.add(a.id);
                    a.Contract_Type__c = null;
                }
            }else{
                a.Contract_Type__c = null;
            }
        }

        //Below query commented out by Vikhyat on 08/07/2019
        /*businessPracticeAccountList = [Select id, ParentId, Vision_Care_Good_Standing__c, Location_Type__c, Provider_Category__c, Parent_Company__c, Vision_Care_Location_Exception__c from Account 
        where recordTypeID = :businessRecordTypeID and (ParentId in :practiceAccountSet or ParentId in :businessIdSet)];*/
        //Part commented out by Vikhyat on 08/07/2019 ends here.

        practiceAccountList = [Select id, Vision_Care_Practice_Exception__c from Account where recordTypeID = :practiceRecordTypeID and id in :practiceIdSet and 
        Vision_Care_Good_Standing__c = true];

        if(practiceAccountList.size()>0){
            for(Account a: practiceAccountList){
                if(!practiceExceptionMap.containsKey(a.id)){
                    practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);
                }
            }
        }

        if(businessAccountList.size()>0){
            for(Account a: businessAccountList){
                if(practiceExceptionMap.containsKey(a.ParentId)){
                    calculator(a, practiceExceptionMap.get(a.ParentId));    
                }else{
                    a.Contract_Type__c = null;
                }
            }
        }

        //Below part commented out by Vikhyat on 08/07/2019
        /*if(businessPracticeAccountList.size()>0){
            for(Account a: businessPracticeAccountList){
                if(businessIdSet.contains(a.ParentId)){
                    a.Contract_Type__c = null;
                }else{
                    if(practiceExceptionMap.containsKey(a.ParentId)){
                        calculator(a, practiceExceptionMap.get(a.ParentId));
                    }else{
                        a.Contract_Type__c = null;
                    }
                }
            }
            update businessPracticeAccountList;
        }*/
        //Part commented by Vikhyat on 08/07/2019 ends here.

    }

    //Added by Vikhyat on 08/07/2019

    public void ContractTypeCalculationAfterUpdate(list<Account> newAccountList, Map<Id, Account> oldAccountMap){
        Set<id> practiceAccountSet = new Set<Id>();
        Set<id> practiceIdSet = new Set<Id>();
        Set<id> businessIdSet = new Set<Id>();
        List<Account> businessAccountList = new List<Account>();
        List<Account> businessPracticeAccountList = new List<Account>();
        List<Account> practiceAccountList = new List<Account>();
        Map<Id, String> practiceExceptionMap = new Map<Id, String>();

        for(Account a: newAccountList){
            if(a.recordTypeId == practiceRecordTypeID && oldAccountMap.get(a.id).recordTypeId == practiceRecordTypeID && 
                (oldAccountMap.get(a.id).Vision_Care_Practice_Exception__c != a.Vision_Care_Practice_Exception__c || 
                    a.Vision_Care_Good_Standing__c != oldAccountMap.get(a.id).Vision_Care_Good_Standing__c)){
                //This condition checks if either Vision Care Practice Exception value or Vision Care Good Standing value on the Practice Account is updated.
                //In such a scenario we have to re-calculate the value of the contract type on business accounts associted to the practice.
                if(a.Vision_Care_Good_Standing__c == true){
                    practiceAccountSet.add(a.id);
                    practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);    
                }else{
                    practiceAccountSet.add(a.id);
                }
                /*practiceAccountSet.add(a.id);
                practiceExceptionMap.put(a.id, a.Vision_Care_Practice_Exception__c);*/
                //practiceIdSet.add(a.id);
            }else if(a.recordtypeId == businessRecordTypeID && oldAccountMap.get(a.id).recordtypeId == practiceRecordTypeID){
                businessIdSet.add(a.id);
            }
        }

        //Below query updated by Vikhyat on 08/26/2019. Updated to include the VC and Non VC Exception fields while extracting Business Account records.
        //if(/*businessIdSet.size()>0 || practiceAccountSet.size()>0*/ !Test.isRunningTest()){
        businessPracticeAccountList = [Select id, ParentId, Vision_Care_Good_Standing__c, Location_Type__c, Provider_Category__c, Parent_Company__c, Vision_Care_Location_Exception__c, Vision_Care_Effective_Date__c,
        Non_VC_Exception__c, Vision_Care_End_Date__c from Account where recordTypeID = :businessRecordTypeID and (ParentId in :practiceAccountSet or ParentId in :businessIdSet)];
        //}


        if(businessPracticeAccountList.size()>0){
            for(Account a: businessPracticeAccountList){
                if(businessIdSet.contains(a.ParentId)){
                    a.Contract_Type__c = null;
                }else{
                    if(practiceExceptionMap.containsKey(a.ParentId)){
                        calculator(a, practiceExceptionMap.get(a.ParentId));
                    }else{
                        a.Contract_Type__c = null;
                    }
                }
            }
            update businessPracticeAccountList;
        }


    }



    public void calculator(Account a, String practiceException){

        //Below part added by Vikhyat on 08/27/2019
        Date endDate;
        if(a.Vision_Care_End_Date__c == null){
            endDate = System.today();
        }else{
            endDate = a.Vision_Care_End_Date__c;
        }
        //part added by vikhyat on 08/27/2019 ends here.

        //below if statement updated by Vikhyat on 08/26/2019. Updated to include conditions to check for conditions related to VC and Non VC Exception fields on Business Account level.
        if(a.Location_Type__c == 'A - Affiliate Provider Location' && a.Vision_Care_Good_Standing__c == true && (!(todayDate.daysBetween(a.Vision_Care_Effective_Date__c) * todayDate.daysBetween(/*a.Vision_Care_End_Date__c*/endDate) > 0) || a.Non_VC_Exception__c == true)){
            if(a.Provider_Category__c == 'AOP - Approved OON Provider'){
                if(a.Parent_Company__c != null){
                    a.Contract_Type__c = 'AOP';
                    }else{
                        if(a.Vision_Care_Location_Exception__c == null && (practiceException == null || practiceException != null)){
                            a.Contract_Type__c = 'AOP';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }
                    }else if(a.Provider_Category__c == 'OFPCS - Pearle Vision Corp Sublease Holder' || a.Provider_Category__c == 'PEARL - License Operator Pearle Vision' ||
                        a.Provider_Category__c == 'PVCO - Corp Managed Pearle Vision'){
                        if(a.Parent_Company__c == 'PERL - Pearle Vision Location'){ //Conditions when parent company is PERL - Pearle Vision Location
                            if((a.Vision_Care_Location_Exception__c != null && practiceException == null) || (a.Vision_Care_Location_Exception__c == null && 
                                practiceException != null && practiceException != 'EFTX - No EFT') || (a.Vision_Care_Location_Exception__c == null && practiceException == null)){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                            }else if(a.Parent_Company__c != 'PERL - Pearle Vision Location' && a.Parent_Company__c != null){ //Condition to check when it is any parent company other than PERL
                            if(a.Vision_Care_Location_Exception__c == null && practiceException == null){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else{ //Condition when parent company is null
                            if((a.Vision_Care_Location_Exception__c == null && practiceException == null) || (a.Vision_Care_Location_Exception__c != null && 
                                practiceException != null)){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }
                    }else if(a.Provider_Category__c == 'OFPLS - Pearle Vision L.O Sublease Holder'){
                        if(a.Parent_Company__c == 'PERL - Pearle Vision Location'){
                            if((a.Vision_Care_Location_Exception__c != null && practiceException == null) || (a.Vision_Care_Location_Exception__c == null && 
                                practiceException != null && practiceException != 'EFTX - No EFT') || (a.Vision_Care_Location_Exception__c == null && practiceException == null)){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if((a.Parent_Company__c != 'PERL - Pearle Vision Location' && a.Parent_Company__c != null) || a.Parent_Company__c == null){
                            if(a.Vision_Care_Location_Exception__c == null && practiceException == null){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }
                    }else if(a.Provider_Category__c == null){
                        if(/*a.Parent_Company__c == 'COHN - Cohen\'s Fashion Optical' || */a.Parent_Company__c == 'COST - Costco Location' /*|| a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location'*/){
                                a.Contract_Type__c = 'Affiliate';
                       }else if(a.Parent_Company__c == 'COHN - Cohen\'s Fashion Optical' || a.Parent_Company__c == 'CVS - CVS Location' || a.Parent_Company__c == 'FEGV - For Eyes Grand Vision' || a.Parent_Company__c == 'OPTX - Optyx Location' || 
                            a.Parent_Company__c == 'RXOP - Rx Optical Location' || a.Parent_Company__c == 'SHOP - Shopko Location' || a.Parent_Company__c == 'WALM - Walmart Location' ||
                            a.Parent_Company__c == 'WVIS - Wisconsin Vision Location'){
                            a.Contract_Type__c = 'Affiliate';
                            }/*else if(a.Parent_Company__c == 'COHN - Cohen\'s Fashion Optical'){
                                if((a.Vision_Care_Location_Exception__c != null || a.Vision_Care_Location_Exception__c == null) && practiceException == null){
                                    a.Contract_Type__c = 'Affiliate';
                                }
                                else{
                                   a.Contract_Type__c = null; 
                                }                                
                        }*/else if(a.Parent_Company__c == null && ((a.Vision_Care_Location_Exception__c == null && practiceException == null) || (a.Vision_Care_Location_Exception__c != null && 
                            practiceException != null))){
                            a.Contract_Type__c = 'Affiliate';
                        }else if(a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location'){
                            //else if condition added by Vikhyat to cover the visionworks conditions for 10/04/2019.
                            a.Contract_Type__c = 'Visionworks';
                        }
                        else{ //Condition when Provider Category is other than the scenrios listed above.
                            a.Contract_Type__c = null;
                        }
                    }
                }
                //below if statement updated by Vikhyat on 08/26/2019. Updated to include conditions to check for conditions related to VC and Non VC Exception fields on Business Account level.
                else if(a.Location_Type__c == 'F - Laser Vision Correction (LVC)' && a.Vision_Care_Good_Standing__c == true && (!(todayDate.daysBetween(a.Vision_Care_Effective_Date__c) * todayDate.daysBetween(/*a.Vision_Care_End_Date__c*/endDate) > 0) || a.Non_VC_Exception__c == true)){
                    if(a.Provider_Category__c!=null){
                        if(a.Parent_Company__c == null && a.Vision_Care_Location_Exception__c == null && practiceException == null){
                            a.Contract_Type__c = 'Not Supported';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else{
                        if(a.Parent_Company__c != null){
                            if(a.Vision_Care_Location_Exception__c == null && practiceException == null){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else{
                            a.Contract_Type__c = 'LVC';
                        }
                    }
                }
                //below if statement updated by Vikhyat on 08/26/2019. Updated to include conditions to check for conditions related to VC and Non VC Exception fields on Business Account level.
                else if(a.Location_Type__c == 'M - VSP Member Location' && a.Vision_Care_Good_Standing__c == true && (!(todayDate.daysBetween(a.Vision_Care_Effective_Date__c) * todayDate.daysBetween(/*a.Vision_Care_End_Date__c*/endDate) > 0) || a.Non_VC_Exception__c == true)){
                    if(a.Provider_Category__c == null){
                        if(a.Parent_Company__c == null){
                            if(a.Vision_Care_Location_Exception__c == null){
                                if(practiceException != null && practiceException != 'EFTX - No EFT'){
                                    a.Contract_Type__c = 'Net Dev Excluded';
                                }else{
                                    a.Contract_Type__c = 'Independent';
                                }
                            }else if(a.Vision_Care_Location_Exception__c == 'AGT - Agreement Non-Compliance' || a.Vision_Care_Location_Exception__c == 'CTG - Group Agreement'){
                                a.Contract_Type__c = 'Net Dev Purchasing Requirement';                               
                            }else if(a.Vision_Care_Location_Exception__c == 'COFR - Does not Maintain 200 Frames' || a.Vision_Care_Location_Exception__c == 'DRS - Not all doctors are VSP Providers' || 
                                a.Vision_Care_Location_Exception__c == 'DSP - Does not Dispense Glasses' || a.Vision_Care_Location_Exception__c == 'FQH - FQHC Center' || 
                                a.Vision_Care_Location_Exception__c == 'HRSA - Office Hours Exception' || a.Vision_Care_Location_Exception__c == 'IHSC - Indian Health Clinic'){
                                a.Contract_Type__c = 'Net Dev Excluded';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'AEHG- Acuity Eyecare Holding Group' || a.Parent_Company__c == 'CLRK - Clarkson Eyecare Location' || a.Parent_Company__c == 'GRRA - Grand Rapids Ophthalmology' || 
                            a.Parent_Company__c == 'MEDR - MyEyeDr. Location' || a.Parent_Company__c == 'PRIT - Pritchett Eye Care Location' || a.Parent_Company__c == 'TECP - Total Eyecare Partners'){
                            if(a.Vision_Care_Location_Exception__c == null && practiceException == 'EFTX - No EFT'){
                                a.Contract_Type__c = null;
                            }else{
                                a.Contract_Type__c = 'Not Supported';
                            }
                        }else if(a.Parent_Company__c == 'COHN - Cohen\'s Fashion Optical' || a.Parent_Company__c == 'COST - Costco Location' || a.Parent_Company__c == 'CVS - CVS Location' || 
                            a.Parent_Company__c == 'FEGV - For Eyes Grand Vision' || a.Parent_Company__c == 'OPTX - Optyx Location' || a.Parent_Company__c == 'SHOP - Shopko Location' || 
                            a.Parent_Company__c == 'WALM - Walmart Location' || a.Parent_Company__c == 'WVIS - Wisconsin Vision Location'){
                            if((a.Vision_Care_Location_Exception__c == null && practiceException == null) || (a.Vision_Care_Location_Exception__c != null && practiceException != null)){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(/*a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location' ||*/ a.Parent_Company__c == 'RXOP - Rx Optical Location'){
                            if(a.Vision_Care_Location_Exception__c == null && (practiceException == null || practiceException == 'EFTX - No EFT')){
                                a.Contract_Type__c = 'Independent';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location'){
                            //else if condition added by work to cover for visionworks scenarios of 10/04/2019.
                            a.Contract_Type__c = 'Visionworks';
                        }else if(a.Parent_Company__c == 'OCNB - Near-site Clinic Location, VSP'){
                            if(a.Vision_Care_Location_Exception__c == 'SITE - On-site Clinic'){
                                a.Contract_Type__c = 'Near Site';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'OCSI - Onsite Clinic Location, VSP'){
                            if(a.Vision_Care_Location_Exception__c == 'SITE - On-site Clinic'){
                                a.Contract_Type__c = 'Onsite';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'PERL - Pearle Vision Location'){
                            if(a.Vision_Care_Location_Exception__c == null && practiceException == null){
                                a.Contract_Type__c = 'Pearle Vision LO';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'POP - Pop-Up Clinic Location, VSP'){
                            if(a.Vision_Care_Location_Exception__c == 'SITE - On-site Clinic'){
                                a.Contract_Type__c = 'Pop Up';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'CAT2 - Non-Standard Ownership Model'){
                        if(a.Parent_Company__c == 'AEHG- Acuity Eyecare Holding Group' || a.Parent_Company__c == 'CLRK - Clarkson Eyecare Location' || a.Parent_Company__c == 'GRRA - Grand Rapids Ophthalmology' || 
                            a.Parent_Company__c == 'MEDR - MyEyeDr. Location' || a.Parent_Company__c == 'PRIT - Pritchett Eye Care Location' || a.Parent_Company__c == 'TECP - Total Eyecare Partners' || 
                            a.Parent_Company__c == 'TOTV - Total Vision Inc' || a.Parent_Company__c == 'ESP - Eyecare Service Partners'){
                            a.Contract_Type__c = 'CAT2';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'OFPCS - Pearle Vision Corp Sublease Holder' || a.Provider_Category__c == 'PVCO - Corp Managed Pearle Vision'){
                        if(a.Parent_Company__c == null){
                            if((a.Vision_Care_Location_Exception__c == null && (practiceException == null || practiceException != null)) || 
                                (a.Vision_Care_Location_Exception__c != null && practiceException == null)){
                                a.Contract_Type__c = 'Pearle Vision CO';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'PERL - Pearle Vision Location'){
                            a.Contract_Type__c = 'Pearle Vision CO';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'OFPLS - Pearle Vision L.O Sublease Holder' || a.Provider_Category__c == 'PEARL - License Operator Pearle Vision'){
                        if(a.Parent_Company__c == null){
                            if((a.Vision_Care_Location_Exception__c == null && (practiceException == null || practiceException != null)) || 
                                (a.Vision_Care_Location_Exception__c != null && practiceException == null)){
                                a.Contract_Type__c = 'Pearle Vision LO';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'PERL - Pearle Vision Location'){
                            a.Contract_Type__c = 'Pearle Vision LO';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'RETL - VSP Retail'){
                        if(a.Parent_Company__c == null){
                            a.Contract_Type__c = 'VSP Retail';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'SCHLS - Optometric School or University'){
                        if(a.Parent_Company__c == null){
                            a.Contract_Type__c = 'School';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'VNTR - VSP Ventures'){
                        if(a.Parent_Company__c == 'VNTR - VSP Ventures' || a.Parent_Company__c == 'JVNTR - Joint Ventures'){
                            a.Contract_Type__c = 'VSP Ventures';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else{
                        if((a.Parent_Company__c == 'OCNB - Near-site Clinic Location, VSP' || a.Parent_Company__c == 'OCSI - Onsite Clinic Location, VSP' || 
                            a.Parent_Company__c == 'POP - Pop-Up Clinic Location, VSP') && a.Vision_Care_Location_Exception__c == 'SITE - On-site Clinic' && 
                            (practiceException == null || practiceException != null)){
                            a.Contract_Type__c = 'Not Supported';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }
                }
                //below if statement updated by Vikhyat on 08/26/2019. Updated to include conditions to check for conditions related to VC and Non VC Exception fields on Business Account level.
                else if(a.Location_Type__c == 'X - Client Authorized Location (GAP)' && a.Vision_Care_Good_Standing__c == true && (!(todayDate.daysBetween(a.Vision_Care_Effective_Date__c) * todayDate.daysBetween(/*a.Vision_Care_End_Date__c*/endDate) > 0) || a.Non_VC_Exception__c == true)){
                    if(a.Provider_Category__c == null){
                        if(a.Parent_Company__c == null || a.Parent_Company__c == 'OPTX - Optyx Location'){
                            a.Contract_Type__c = 'GAP';
                        }else if(a.Parent_Company__c == 'COHN - Cohen\'s Fashion Optical' && a.Vision_Care_Location_Exception__c != null && practiceException != null){
                            a.Contract_Type__c = 'Not Supported';
                        }else if(a.Parent_Company__c == 'COST - Costco Location' || a.Parent_Company__c == 'CVS - CVS Location' /*|| a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location'*/ || 
                            a.Parent_Company__c == 'OPTX - Optyx Location' || a.Parent_Company__c == 'RXOP - Rx Optical Location' || a.Parent_Company__c == 'SHOP - Shopko Location' || 
                            a.Parent_Company__c == 'WALM - Walmart Location' || a.Parent_Company__c == 'WVIS - Wisconsin Vision Location'){
                            if((a.Vision_Care_Location_Exception__c == null && practiceException == null) || (a.Vision_Care_Location_Exception__c != null && 
                                practiceException != null)){
                                a.Contract_Type__c = 'Not Supported';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'ECCA - ECCA or Visionworks Location'){
                            //else if condition added to include visionworks scenarios of 10/04/2019.
                            a.Contract_Type__c = 'Visionworks';
                        }else if(a.Parent_Company__c == 'FEGV - For Eyes Grand Vision'){
                            if((a.Vision_Care_Location_Exception__c == null && practiceException == null) || (a.Vision_Care_Location_Exception__c != null && 
                                practiceException != null)){
                                a.Contract_Type__c = 'GAP';
                            }else{
                                a.Contract_Type__c = null;
                            }
                        }else if(a.Parent_Company__c == 'PERL - Pearle Vision Location' && a.Vision_Care_Location_Exception__c == null && practiceException == null){
                            a.Contract_Type__c = 'GAP';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'AOP - Approved OON Provider'){
                        if((a.Parent_Company__c == null || a.Parent_Company__c != null) && a.Vision_Care_Location_Exception__c == null && practiceException == null){
                            a.Contract_Type__c = 'AOP';
                        }else if(a.Parent_Company__c != null && a.Vision_Care_Location_Exception__c != null && (practiceException == null ||
                            practiceException != null)){
                            a.Contract_Type__c = 'AOP';
                        }else{
                            a.Contract_Type__c = null;
                        }
                    }else if(a.Provider_Category__c == 'OFPCS - Pearle Vision Corp Sublease Holder' || a.Provider_Category__c == 'OFPLS - Pearle Vision L.O Sublease Holder' || 
                        a.Provider_Category__c == 'PEARL - License Operator Pearle Vision' || a.Provider_Category__c == 'PVCO - Corp Managed Pearle Vision'){
                        if(a.Parent_Company__c == null || a.Parent_Company__c == 'PERL - Pearle Vision Location'){
                            a.Contract_Type__c = 'GAP';
                        }
                    }else{
                        a.Contract_Type__c = null;
                    }
                    }else{
                    a.Contract_Type__c = null;
                }
    }
}