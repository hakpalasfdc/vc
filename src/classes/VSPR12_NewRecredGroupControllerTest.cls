@isTest
public class VSPR12_NewRecredGroupControllerTest{
        static testMethod void VSPR12_NewRecredGroupControllerTestData(){
        PageReference pageRef = Page.VSPR12_NewRecredGroup;
        test.setCurrentPage(pageRef);
        List<Contact> contactList = new List<Contact>();
        Account acc = new Account();
        acc.name = 'Test Account';
        insert acc;
        for(Integer i=0;i<50;i++){
            Contact con = new Contact();
            con.LastName = 'test contact'+i;
            con.Vision_Care_Network_Provider__c = true;
            con.Next_Recred_Date__c = System.today();
            con.Marketing_Name__c = 'test'+i;
            contactList.add(con);
            System.assert(con.Vision_Care_Network_Provider__c,true);
       }
       //try{
        System.debug('Size==='+contactList.size());
           if(contactList.size()>0){
                insert contactList;
                System.debug('contactList==='+contactList+'Size==='+contactList.size());
              
            }
        //}catch(System.DMLException e){
            //System.debug('Exception Found .. '+e.getMessage());
        //}
       
        Credentialing__c cred  = new Credentialing__c();
       test.startTest(); 
        ApexPages.StandardController sc = new ApexPages.StandardController(Cred);
        VSPR12_NewRecredGroupController obj = new VSPR12_NewRecredGroupController();
        VSPR12_NewRecredGroupController objNew = new VSPR12_NewRecredGroupController();
        
        
        Integer NextRecredMonth = System.today().month();
        Integer NextRecredYear = System.today().year();
        obj.NextRecredMonth = NextRecredMonth;
        obj.listView= true;
        obj.listViewNew= true;
        obj.NextRecredYear = NextRecredYear;
        objNew.NextRecredYear =NextRecredYear;
        objNew.NextRecredMonth = NextRecredMonth;
        List<Contact> listContact = [Select id,Name,LastName,FirstName,Vision_Care_Network_Provider__c,Next_Recred_Date__c from Contact where Vision_Care_Network_Provider__c = True AND (CALENDAR_MONTH(Next_Recred_Date__c)=:NextRecredMonth AND CALENDAR_YEAR(Next_Recred_Date__c)=:NextRecredYear) AND Next_Recred_Date__c!=null];
        List<Contact> listContact1 = [Select id,Name,LastName,FirstName,Vision_Care_Network_Provider__c,Next_Recred_Date__c from Contact where Vision_Care_Network_Provider__c = True AND (CALENDAR_MONTH(Next_Recred_Date__c)=:NextRecredMonth AND CALENDAR_YEAR(Next_Recred_Date__c)=:NextRecredYear) AND Next_Recred_Date__c!=null];
        System.debug('listContact==='+listContact);
        objNew.contactList = listContact1;
        
            obj.contactListNew = new List<VSPR12_NewRecredGroupController.ContactList>();
        obj.doSearch();
        obj.doSearchNew();
            
            for(VSPR12_NewRecredGroupController.ContactList c:obj.contactListNew){
                c.selected=true;
            }
       obj.processSelected();
        
        obj.doSearch();
        obj.contactListNew = obj.doSearchNew();
        obj.processSelected();
        
        objNew.doSearch();
        objNew.contactListNew = obj.doSearchNew();
        //objNew.processSelected();
        
        
        
        test.stopTest();
    }
}