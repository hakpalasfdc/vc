public class VSPR2_UpdateAccountBatch implements Database.Batchable<sObject>{
    public String query = 'SELECT Id From Account';

    public Database.QueryLocator start(Database.BatchableContext BC){
  
        return Database.getQueryLocator(query);
  
    }

    public void execute(Database.BatchableContext BC, List<sObject> scope){

     
//Set<id> accountIds = new Set<id>();
List<Account> accs = new List<Account>();
//List<Contact_Role__c> cRole = new List<Contact_Role__c>();
for(sObject s : scope){
Account acc = (Account)s; 
//accountIds.add(acc.Id);
accs.add(acc);

}
update accs;

//cRole = [select id from Contact_Role__c];

//update cRole;
/*//query all the in a single query
List<Account> accs = new List<Account>();
accs = [select id, Name from Account where id in :accountIds];

if(accs.size() > 0)
update accs;
 */
    }
  public void finish(Database.BatchableContext BC){

}  

}