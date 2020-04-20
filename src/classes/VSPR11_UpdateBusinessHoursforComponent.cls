public class VSPR11_UpdateBusinessHoursforComponent {
    public string URLForPage {get;set;}

    public VSPR11_UpdateBusinessHoursforComponent(ApexPages.StandardController controller) {
        URLForPage = ApexPages.currentPage().getHeaders().get('Host');
    }

}