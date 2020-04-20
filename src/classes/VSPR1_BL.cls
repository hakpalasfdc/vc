public class VSPR1_BL {
	
	private Contact oContact;
	
    public VSPR1_BL(ApexPages.StandardController controller) {
		this.oContact = (Contact)controller.getRecord();
    }

    public PageReference doRedirect() 
    {
        PageReference ref = new PageReference('/apex/VSPR1_Relocate?cid=' + oContact.id);
        return ref;
    } 
}