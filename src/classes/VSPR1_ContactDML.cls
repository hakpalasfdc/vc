/**
 * Class Name: VSPR1_ContactDML
 * @author: Jinky M.N. Salvador
 * Date: 27.MAY.2013
 * Requirement/Project Name: VSP
 * @description: Handles all DML for the Contact object.
 */

public class VSPR1_ContactDML { 

	public static List<Contact> getContactDetails(Set<Id> ids){
		
		List<Contact> contacts = [Select AccountId,VSP_Network_Provider_Count__c,High_Profile_Count__c from Contact where AccountId IN: ids];
		return contacts;		
	} 
}