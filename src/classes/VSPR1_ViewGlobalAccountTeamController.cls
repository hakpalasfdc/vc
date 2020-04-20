public class VSPR1_ViewGlobalAccountTeamController {
    
    public Account oAccount;
    public Account myAccount = new Account();
    public Map<String, String> gat  {get;set;}
    public List<User> altairRepsList {get; set;}
    public List<User> marchonRepsList {get; set;}
    public List<User> allureRepsList {get; set;}
    public List<DataWrapper> altairRepsWrapperList {get; set;}
    public List<DataWrapper> marchonRepsWrapperList {get; set;}
    
    public String allureDMName{get;set;}
    public String allureDMEmail{get;set;}
    public String allureDMPhone{get;set;}
    
    public String marchonDMName{get;set;}
    public String marchonDMEmail{get;set;}
    public String marchonDMPhone{get;set;}
    
    public String altairRMName{get;set;}
    public String altairRMEmail{get;set;}
    public String altairRMPhone{get;set;}
    
    public List<String> ListofFields  {get;set;}
    public Map<String, List<String>> gatFinal {get;set;}
    
    private List<String> GatCodes = new List<String>();
    private String tempString;
    private String partString;
    public List<User> UserDetails {get;set;}
    
    public VSPR1_ViewGlobalAccountTeamController(ApexPages.StandardController controller) {
        this.oAccount = (Account)controller.getRecord();
        UserDetails = new List<User>();
        ListofFields = new List<String>(); 
        gat = new Map<String,String>();
        gatFinal = new Map <String, List<String>>();
        List<String> FieldName = new List<String>();
        altairRepsList = new List<User>();
        marchonRepsList = new List<User>();
        altairRepsWrapperList = new List<DataWrapper>();
        marchonRepsWrapperList = new List<DataWrapper>();
        
        Initialize();
        getUsers();        
    }
    
    @TestVisible private void Initialize() {
        myAccount  = [SELECT Allure_Rep__c, Altair_Standard__c, Optics_Contact_Lens_Consultant__c, 
                      Marchon_Optical__c, MDM_Account_Keys__c, MDM_Location_Keys__c,
                      Ophthalmic_Business_Consultant__c,
                      VC_EDS_NA__c,Global_Business_Development_Manager__c, Eyefinity_Inside_Sales__c,VC_Relationship_Manager__c, Global_Business_Development_Partner__c,
                      Eyefinity_Outside_Sales__c, Marchon_DMs__c, GBD_Relationship_Manager__c, GBD_Relationship_Partner__c,Optics_Wholesale__c
                      from Account  where id = :this.oAccount.id];
        
        system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% myAccount   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' + myAccount.Marchon_DMs__c);
        
        List<Account_Rep_Assignment__c> accRepList = [SELECT Marketing_Group_Description__c, District_Manager__c, Sales_Org__c,Sales_Rep__c  FROM Account_Rep_Assignment__c WHERE Account_ID__c = :this.oAccount.id ORDER BY Sales_Rep__c,Marketing_Group_Description__c];                                    
        
        system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% accRepList %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' + accRepList );
        
        
        List<Account_Rep_Assignment__c> marchonDMRepList = [SELECT Marketing_Group_Description__c, District_Manager__c, Sales_Org__c,Sales_Rep__c, Sold_To_MDM_Account_Key__c, Sold_To_MDM_Location_Key__c FROM Account_Rep_Assignment__c WHERE Account_ID__c = :this.oAccount.id AND Sold_To_MDM_Account_Key__c = :myAccount.MDM_Account_Keys__c AND Sold_To_MDM_Location_Key__c = :myAccount.MDM_Location_Keys__c AND Sales_Org__c = :'2010'];
        List<Account_Rep_Assignment__c> altairRMRepList = [SELECT Marketing_Group_Description__c, District_Manager__c, Sales_Org__c,Sales_Rep__c, Sold_To_MDM_Account_Key__c, Sold_To_MDM_Location_Key__c FROM Account_Rep_Assignment__c WHERE Account_ID__c = :this.oAccount.id AND Marketing_Group_Code__c = :'ALT'];
        List<Account_Rep_Assignment__c> allureRepsList = [SELECT Marketing_Group_Description__c, District_Manager__c, Sales_Org__c,Sales_Rep__c, Sold_To_MDM_Account_Key__c, Sold_To_MDM_Location_Key__c FROM Account_Rep_Assignment__c WHERE Account_ID__c = :this.oAccount.id AND Sales_Org__c = :'2050'];
        
        Boolean flag3 = true;
        
        for(Account_Rep_Assignment__c allureRMRep : allureRepsList){
            
            if(flag3 == true){
                
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& TEST  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                
                List<User> temp = [Select Name, Email, Phone, Allure_SAP_Number__c From User Where Allure_SAP_Number__c =: allureRMRep.District_Manager__c];
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& temp &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +temp);
                
                if(temp.size() > 0){
                    allureDMName = temp[0].Name;
                    system.debug('####################  altairRM 1 #####################################' +temp[0].name);
                    
                    allureDMEmail = temp[0].Email;
                    system.debug('####################  altairRM 2 #####################################' +temp[0].email);
                    
                    allureDMPhone = temp[0].Phone;  
                    system.debug('####################  altairRM 3 #####################################' +temp[0].phone);
                }
                flag3 = false;
                
            }
        }        
        
        system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% allureRepsList   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' + allureRepsList );
        
        
        
        
        Boolean flag2 = true;
        
        for(Account_Rep_Assignment__c altairRMRep : altairRMRepList){
            
            if(flag2 == true){
                
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& TEST  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                
                List<User> temp = [Select Name, Email, Phone, Altair_SAP_Number__c From User Where Altair_SAP_Number__c =: altairRMRep.District_Manager__c];
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& temp &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +temp);
                
                if(temp.size() > 0){
                    altairRMName = temp[0].Name;
                    system.debug('####################  altairRM 1 #####################################' +temp[0].name);
                    
                    altairRMEmail = temp[0].Email;
                    system.debug('####################  altairRM 2 #####################################' +temp[0].email);
                    
                    altairRMPhone = temp[0].Phone;  
                    system.debug('####################  altairRM 3 #####################################' +temp[0].phone);
                }
                flag2 = false;
                
            }
        }        
        
        system.debug('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% marchonDMRepList   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%' + marchonDMRepList );
        
        Boolean flag = true;
        
        for(Account_Rep_Assignment__c marchonDMRep : marchonDMRepList){
            
            if(flag == true){
                
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& TEST  &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
                
                List<User> temp = [Select Name, Email, Phone, Marchon_SAP_Number__c From User Where Marchon_SAP_Number__c =: marchonDMRep.District_Manager__c];
                
                system.debug('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& temp &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&' +temp);
                
                if(temp.size() > 0){
                    marchonDMName = temp[0].Name;
                    system.debug('####################  marchonDM 1 #####################################' +temp[0].name);
                    
                    marchonDMEmail = temp[0].Email;
                    system.debug('####################  marchonDM 2 #####################################' +temp[0].email);
                    
                    marchonDMPhone = temp[0].Phone;  
                    system.debug('####################  marchonDM 3 #####################################' +temp[0].phone);
                }
                flag = false;
                
            }
        }
        
        
        Set<String> sapNumberSet = new Set<String>();
        Map<String, User> userMap = new Map<String, User>();
        
        
        
        for(Account_Rep_Assignment__c accRep : accRepList)  {
            sapNumberSet.add(accRep.Sales_Rep__c);
            
        }
        for( User u : [Select Name, Email, Phone, Altair_SAP_Number__c,Marchon_SAP_Number__c, Allure_SAP_Number__c From User Where Altair_SAP_Number__c IN: sapNumberSet OR Marchon_SAP_Number__c IN: sapNumberSet]) {
            userMap.put(u.Altair_SAP_Number__c, u);
            userMap.put(u.Marchon_SAP_Number__c, u);
            userMap.put(u.Allure_SAP_Number__c, u);
        }
        
        Set<String> uniqueStr = new Set<String>();
        Set<String> uniqueNameForAltairStr = new Set<String>();
        Set<String> uniqueNameForMarchonStr = new Set<String>();
        
        
        
        for(Account_Rep_Assignment__c accRep : accRepList)  {
            system.debug('--------------------------------accRep'+accRep);
            system.debug('--------------------------------accRep.Sales_Org__c'+accRep.Sales_Org__c);
            
            User tempUser = userMap.get(accRep.Sales_Rep__c);
            
            if(tempUser != null) {
                String str = tempUser.Name+accRep.Marketing_Group_Description__c;
                if(!uniqueStr.contains(str)) {
                    DataWrapper dw = new DataWrapper(tempUser.Name, tempUser.Email, tempUser.Phone, accRep.Marketing_Group_Description__c);
                    
                    if(accRep.Sales_Org__c == '2110') {
                        if(uniqueNameForAltairStr.contains(tempUser.Name)) {
                            dw.Name = '';
                            dw.Email = '';
                            dw.Phone = '';
                        } else {
                            uniqueNameForAltairStr.add(tempUser.Name);
                        }
                        altairRepsWrapperList.add(dw);
                        uniqueStr.add(str);
                    }
                    if(accRep.Sales_Org__c == '2010') {
                        if(uniqueNameForMarchonStr.contains(tempUser.Name)) {
                            dw.Name = '';
                            dw.Email = '';
                            dw.Phone = '';
                        } else {
                            uniqueNameForMarchonStr.add(tempUser.Name);
                        }
                        marchonRepsWrapperList.add(dw);
                        uniqueStr.add(str);
                    }
                }
            }
        }
        
    }
    
    public void getUsers() {
        
        gat.put('Altair Prospect Rep',myAccount.Altair_Standard__c);
        gat.put('Ophthalmic Business Consultant',myAccount.Ophthalmic_Business_Consultant__c);
        gat.put('Optics Contact Lens Consultant',myAccount.Optics_Contact_Lens_Consultant__c);
        gat.put('Marchon Prospect Rep',myAccount.Marchon_Optical__c);
        gat.put('Provider Solutions Network Specialist',myAccount.VC_EDS_NA__c);
        gat.put('Global Business Development Manager',myAccount.Global_Business_Development_Manager__c);
        gat.put('Eyefinity Inside Sales',myAccount.Eyefinity_Inside_Sales__c);
        gat.put('Eyefinity Outside Sales',myAccount.Eyefinity_Outside_Sales__c);
        gat.put('Optics Business Development Manager',myAccount.Optics_Wholesale__c);
        gat.put('Provider Solutions Relationship Manager', myAccount.VC_Relationship_Manager__c);
        gat.put('Global Business Development Boundary',myAccount.Global_Business_Development_Partner__c);
        gat.put('GBD Relationship Manager',myAccount.GBD_Relationship_Manager__c);  
        gat.put('GBD Relationship Partner',myAccount.GBD_Relationship_Partner__c);
        gat.put('Allure Sales',myAccount.Allure_Rep__c);
        
        ListofFields.add('Ophthalmic Business Consultant');
        ListofFields.add('Provider Solutions Network Specialist');
        ListofFields.add('Optics Contact Lens Consultant');
        ListofFields.add('Global Business Development Manager');
        ListofFields.add('Eyefinity Inside Sales');
        ListofFields.add('Optics Business Development Manager');
        ListofFields.add('Eyefinity Outside Sales');
        ListofFields.add('Altair Prospect Rep');
        ListofFields.add('Marchon Prospect Rep');
        ListofFields.add('Provider Solutions Relationship Manager');
        ListofFields.add('Global Business Development Boundary');
        ListofFields.add('GBD Relationship Manager');
        ListofFields.add('GBD Relationship Partner');
        ListofFields.add('Allure Sales');
        
        for (String codeName : gat.values()) {
            GatCodes.add(codeName);
        }
        UserDetails = [Select Name, Email, Phone, MarketingID__c, MarketingID2__c from User where ((MarketingID__c in :GatCodes AND MarketingID__c != null)
                                                                                                   OR (MarketingID2__c in :GatCodes AND MarketingID2__c != null)) order by createddate asc  ];
        
        Map<String,User> myMap = new Map<String,User>();
        for(User u : UserDetails){  
            myMap.put(u.MarketingID__c,u);
        }
        UserDetails.clear();
        for(User u : myMap.values()){
            UserDetails.add(u);        
        }
        
        
        for (String item : gat.keyset()){
            partString = '';
            tempString = gat.get(item);
            for(User UserItem : UserDetails){                
                if(tempString != null){
                    if (tempString == UserItem.MarketingID__c || tempString == UserItem.MarketingID2__c) {
                        // partString = partString + UserItem.Name + ',' + useritem.Email + ',' + useritem.Phone;                       
                        partString = partString + UserItem.Name + ',' + useritem.Email+ ',';
                        if(useritem.Phone==null){
                            partString = partString + ' ';
                        }
                        else{
                            partString = partString + useritem.Phone;
                        }                       
                    }   
                }
            }            
            if (partString == '') {
                partString = ' , , ';
            }
            gatFinal.put(item , partString.split(','));
        }
    }
    
    public class DataWrapper {
        //public User u {get; set;}
        public String name {get; set;}
        public String email {get; set;}
        public String phone {get; set;}
        public String mgDesc {get; set;}
        public DataWrapper(String nm, String em, String ph, String mgd) {
            name = nm;
            email = em;
            phone = ph;
            mgDesc = mgd;
        }
    }
}