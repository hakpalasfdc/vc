trigger AddressRelationshipTrigger on Address_Relationship__c (after delete, after insert, after update) {

//	try {
		
		if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate || trigger.isDelete)){
			//system.debug('>>>Enter trigger');
			//VSPR1_AddressBL(trigger.new,trigger.old,trigger.newMap,trigger.isDelete,trigger.isInsert);
			//system.assertEquals(1, 999);
			VSPR1_AddressRelationshipBL UpdateAccountAddress = new VSPR1_AddressRelationshipBL(trigger.new,trigger.old,trigger.newMap,trigger.isDelete,trigger.isInsert);
		}					    
//	} catch (Exception e) {
//  		System.debug(e.getMessage());  
//	}

}