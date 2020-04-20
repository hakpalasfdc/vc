@isTest
public class VSP_CTI_Controller_Test {
    
    static testmethod void runJob(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';');
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    static testmethod void runJobMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    
    static testmethod void runJobMultCon1EyeConMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
        Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Phone = '701-890-8016';
        insert conConsumer2;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';' + conConsumer2.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    static testmethod void runJobMultCon1EyeConNonMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
        Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Phone = '701-890-8016';
        insert conConsumer2;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';' + conConsumer2.Id + ';');
        objCtrl.senderNum = '7018908017';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    static testmethod void runJobMultCon2EyeConNonMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
        Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Eyeconic_Primary_Phone__c = '701-890-8016';
        insert conConsumer2;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';' + conConsumer2.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    static testmethod void runJobMultCon0EyeConNonMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Phone = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
        Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Phone = '701-890-8016';
        insert conConsumer2;
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';' + conConsumer2.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
    static testmethod void runJobCon0EyeConNonMatchPhone(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Phone = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
 /*       Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Phone = '701-890-8016';
        insert conConsumer2;*/
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
        objCtrl.conIdList = String.valueOf(conConsumer.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
        static testmethod void runJobArraySize0(){
        Id accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Account').getRecordTypeId();
        Id conRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Consumer').getRecordTypeId();
        
        DVIWebService__c dviWeb = new DVIWebService__c();
        dviWeb.Name = 'DVI Values';
        
        insert dviWeb;
        
        
        ////Insert Account
        Account busAcc = new Account();
        busAcc.Name = 'VSP Consumer';
        busAcc.RecordTypeId = accRecordTypeId;
        insert busAcc;
        
        ////Insert Contact
        Contact conConsumer = new Contact();
        conConsumer.FirstName = 'FName';
        conConsumer.LastName = 'LName';
        conConsumer.RecordTypeId = conRecordTypeId;
        conConsumer.AccountId = busAcc.Id;
        conConsumer.Phone = '701-890-8016';
        insert conConsumer;
        
        ////Insert Contact
 /*       Contact conConsumer2 = new Contact();
        conConsumer2.FirstName = 'FName';
        conConsumer2.LastName = 'LName';
        conConsumer2.RecordTypeId = conRecordTypeId;
        conConsumer2.AccountId = busAcc.Id;
        conConsumer2.Phone = '701-890-8016';
        insert conConsumer2;*/
        
        system.debug('conConsumer Id ' + conConsumer.Id);
        Test.startTest();
        VSP_CTI_Controller objCtrl = new VSP_CTI_Controller();
       // objCtrl.conIdList = String.valueOf(conConsumer.Id + ';');
        objCtrl.senderNum = '7018908016';
        objCtrl.VSP_CTI_Controller();
        Test.stopTest();
    }
}