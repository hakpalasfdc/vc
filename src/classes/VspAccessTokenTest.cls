@isTest(SeeAllData=false)
public class VspAccessTokenTest {
    public static testmethod void testVspAccessToken() {  
     VspAccessToken tk = new VspAccessToken();
     tk.access_token='ABC';
     tk.token_type='primary';
     tk.expires_in = 1799; 
     System.assertEquals(tk.access_token , 'ABC');
     System.assertEquals(tk.token_type , 'primary'); 
     System.assertEquals(tk.expires_in , 1799);
    }

}