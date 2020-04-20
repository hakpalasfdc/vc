/**
 * Class Name: VSPR1_AddressRelationshipBL
 * @author: Marvin B. Gatchalian
 * Date: 18.JUNE.2013
 * Requirement/Project Name: VSP
 * @description: Handles all Business Logic for the Address Relationship Custom object.
 */

public with sharing class VSPR1_AddressRelationshipBL { 

	//Map<id,Address__c> AddressMap = new Map<id,Address__c>();		
	Set<Id> addressIds = new Set<ID>();
	Set<Id> accountIds = new Set<ID>();
	
		public VSPR1_AddressRelationshipBL(List<Address_Relationship__c> newTrigger, List<Address_Relationship__c> oldTrigger, Map<id,Address_Relationship__c> TriggerMap, Boolean isDelete, Boolean isInsert){
			
			//AddressMap = TriggerMap;
			if (isDelete) {
				for(Address_Relationship__c Address : oldTrigger){
					addressIds.add(Address.address__c);
					accountIds.add(Address.Account__c);
 				}
			}
			else if (!isDelete) {
				for(Address_Relationship__c Address : newTrigger){
					addressIds.add(Address.address__c);
					accountIds.add(Address.Account__c);
 				}
 				
			}
			//system.assertEquals(accountIds, null);
 			VSPR1_FindCorrectAddress.findAddress(accountIds);		

		} 
		
	
}