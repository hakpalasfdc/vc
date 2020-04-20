public with sharing class VSPR12_NewRecredGroupController{

    public  Integer NextRecredMonth{get;set;}
    public  Integer NextRecredYear{get;set;}
    public  boolean listView{get;set;}
    public  boolean listViewNew{get;set;}
    public  List<Contact> contactList{get;set;}
    public  List<ContactList> contactListNew{get;set;}
    public integer count{get;set;}
   /* private  Integer pageSize = 20;// Keep the track of no of records per page
    private Integer counter = 0; // keeps the track of the records to Display 
    public integer total_size; // Total size in the list
    */
    // Test Start ...
        public  List<Contact> contactList1{get;set;}
        public  List<ContactList> contactListNew1{get;set;}
    //Test End
    
    public VSPR12_NewRecredGroupController(ApexPages.StandardSetController controller) {
        listViewNew= false;
    }
     public VSPR12_NewRecredGroupController(){
         //contactListNew = new List<ContactList>();
         contactListNew1 = new List<ContactList>();
     }
public void doSearch(){
        //listView=true;
        doSearchNew();
        contactList = [Select id,Name,LastName,FirstName,Vision_Care_Network_Provider__c,Next_Recred_Date__c from Contact where Vision_Care_Network_Provider__c = True AND (CALENDAR_MONTH(Next_Recred_Date__c)=:NextRecredMonth AND CALENDAR_YEAR(Next_Recred_Date__c)=:NextRecredYear) AND Next_Recred_Date__c!=null];
             if(contactList.size()>0){
                    listView=true;
                    contactListNew = new List<ContactList>();
                    for(Contact c : contactList){
                       contactListNew.add(new ContactList(c));
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Record Found.'));
                    listView=false;
                }
               //return contactListNew;
           }
public List<ContactList> doSearchNew(){
        //listView=true;
        //counter = 0;
        contactList1 = [Select id,Name,LastName,FirstName,Vision_Care_Network_Provider__c,Next_Recred_Date__c from Contact where Vision_Care_Network_Provider__c = True AND (CALENDAR_MONTH(Next_Recred_Date__c)=:NextRecredMonth AND CALENDAR_YEAR(Next_Recred_Date__c)=:NextRecredYear) AND Next_Recred_Date__c!=null];
             if(contactList1.size()>0){
                    listView=true;
                    contactListNew1 = new List<ContactList>();
                    for(Contact c : contactList1){
                       contactListNew1.add(new ContactList(c));
                       count = contactList1.size();
                       ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,contactList1.size()+'  '+'contacts have a matching Next Recred Date'));
                    }
                }else{
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'No Record Found.'));
                    listView=false;
                }
               return contactListNew1;
           }        

public PageReference processSelected(){
        List<Contact> SelectedContact = new List<Contact>();
        List<Credentialing__c> CredentialingTobeInserted = new List<Credentialing__c>();
        //doSearchTest();
        System.debug('1');
        if(contactListNew1.size()>0){
             for(ContactList conList : contactListNew1){
               if(conList.selected){
                    SelectedContact.add(conList.con);
                    //System.debug('##### SelectedContact ==='+SelectedContact+' Size '+SelectedContact.size());
                }
              }
        }
       if(SelectedContact.size()>0){
             //System.debug('##### SelectedContact ==='+SelectedContact+' Size '+SelectedContact.size());
             for(Contact con : SelectedContact){
                 Credentialing__c Credentialing  = new Credentialing__c();
                 //System.debug('##### Contact ==='+'   '+con);
                 Credentialing.Provider_Name__c = con.id;
                 Credentialing.Credentialing_Type__c = 'Recredentialing';
                 Credentialing.Credentialing_Instance_Status__c = 'Open';
                 CredentialingTobeInserted.add(Credentialing);
             }try{
                 if(CredentialingTobeInserted.size()>0){
                     insert CredentialingTobeInserted;
                    }
                 }catch(System.DMLException e){
                     String error = e.getMessage();ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,error));
                     System.debug('Exception Found ...'+e);
                 }
        }else{
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please Select one or more Contact'));
    }
        if(SelectedContact.size()>0){
            Schema.DescribeSObjectResult destination = Credentialing__c.SObjectType.getDescribe();
            PageReference pageRef = new PageReference('/' + destination.getKeyPrefix() );
            pageRef.setRedirect(true);
            return pageRef;
        }else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Please select at least one Contact'));
            return null;
        }
        
    } 
    
//This is our wrapper/container class. A container class is a class, 
  public class ContactList {
        public Contact con {get; set;}
        public Boolean selected {get; set;}
        public ContactList(Contact c) {
            con = c;
            selected = true;
        }
    }
}