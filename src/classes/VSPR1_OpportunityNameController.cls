public with sharing class VSPR1_OpportunityNameController {


    ApexPages.StandardController setCon;
    Id accountId;
    Id recordType;
    string ContactRoleId;
    //Opportunity opportunity;
    public VSPR1_OpportunityNameController(ApexPages.StandardController controller) {
        this.setCon = controller;
        accountId = ApexPages.currentPage().getParameters().get('accid');
        recordType = ApexPages.currentPage().getParameters().get('RecordType');
        //ContactRoleId = ApexPages.currentPage().getParameters().get('CF00N0B000005UPct_lkid');
        string BasicUrl = ApexPages.currentPage().getURL();
        list < String > SplitUrlList = new list < String > ();
        if (basicUrl != null && basicUrl != '')
            SplitUrlList = BasicUrl.split('&');
        string accId = '';
        if (SplitUrlList != null && SplitUrlList.size() > 0) {
            for (String ValidId: SplitUrlList) {
                if (ValidId.contains('_lkid')) {
                    ContactRoleId = ValidId.substringAfter('=');

                }
            }
        }
        system.debug(ContactRoleId + '%%%%%%%%%%');


    }
    public PageReference getRecDetails() {
        list < Contact_Role__c > ConRole = new List < Contact_Role__c > ();
        if (ContactRoleId != null && ContactRoleId != '')
            conRole = [select id, name, Account__r.name from Contact_Role__c where id =: ContactRoleId];
        String query = '';
        if (accountId <> null) {

            if (recordType == null) {
                if (conRole.size() > 0) {
                    return new PageReference('/006/e?retURL=%2F' + accountId + '&opp4=' + conRole[0].Account__r.name + '&CF00N0B000005UPct=' + conRole[0].name + '&accid=' + accountId + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');

                } else {
                   return new PageReference('/006/e?retURL=%2F' + accountId + '&accid=' + accountId + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');
                }
            } else {
                if (conRole.size() > 0) {
                    return new PageReference('/006/e?retURL=%2F' + accountId + '&opp4=' + conRole[0].Account__r.name + '&CF00N0B000005UPct=' + conRole[0].name + '&accid=' + accountId + '&RecordType=' + recordType + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');

                } else {
                    return new PageReference('/006/e?retURL=%2F' + accountId + '&accid=' + accountId + '&RecordType=' + recordType + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');
                }
            }
        } else {

            if (recordType == null) {
                if (conRole.size() > 0) {
                    return new PageReference('/006/e?retURL=%2F' + '&opp4=' + conRole[0].Account__r.name + '&CF00N0B000005UPct=' + conRole[0].name + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');

                } else {

                    return new PageReference('/006/e?retURL=%2F' + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');
                }
            } else {
                if (conRole.size() > 0) {
                    return new PageReference('/006/e?retURL=%2F' + '&opp4=' + conRole[0].Account__r.name + '&CF00N0B000005UPct=' + conRole[0].name + '&RecordType=' + recordType + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');

                } else {
                    return new PageReference('/006/e?retURL=%2F' + '&RecordType=' + recordType + '&opp3=Auto Generated&nooverride=1&retURL=/006/o' + '&opp11=Prospect&nooverride=1&retURL=/006/o');
                }
            }


        }
    }
}