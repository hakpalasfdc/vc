@isTest
public class VSPR2_PreChatCaseContactUpdate_Test {
	@isTest
    public static void newChatCase(){
        String personId = TestDataFactory.createPersonAccount('testLast');
        String personContactId = [SELECT PersonContactId FROM Account WHERE Id =: personId].PersonContactId;
        TestDataFactory.setDVISettings();

        Case newCase = new Case();
        newCase.Origin = 'Chat';
        newCase.RecordTypeId = '0120B000000t8xa';
        insert newCase;
        
        newCase = [SELECT AccountId,ContactId FROM Case WHERE Id =: newCase.Id];
        newCase.AccountId = personId;
        update newCase;
        
        newCase = [SELECT ContactId FROM Case WHERE Id =: newCase.Id];
        system.assertEquals(personContactId, newCase.ContactId);
    }
}