/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest(SeeAllData=true)
private class VSPR9_AccountOrderSummaryController_Test {
    public static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        VSPR9_AccountOrderSummaryController obj = new VSPR9_AccountOrderSummaryController ();
        Test.setCurrentPageReference(new PageReference('Page.VSPR7_OrderSummary')); 
        System.currentPageReference().getParameters().put('optickey', '70570');
        
        
         obj.redoSubmission = false;
        obj.strFrameStatus = 'Lenses Only';
        obj.strFrameStatus = 'Frame to Come';
        obj.strFrameStatus = 'Uncut';
        obj.strLensSelected = 'Both Lenses';
        obj.strLensSelected = 'Right Only';
        obj.strLensSelected = 'Left Only';
        obj.strRedoDescription = 'abc';
        obj.redoEdge = 'N';
        obj.strFrameStatusVal = 'L';
        obj.strEyes = 'R';
        obj.strEdge = 'N';
        
        obj.serviceException = '';
        obj.vspLensorderDetailsUrl = 'https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494&invoice=451817&guid=3CCDADF4-A0B3-49FF-A0C4-82A9B5DCB4D3';
        
        VSPR9_AccountOrderSummaryController.VSPR9_OrderHistoryWrapper ohw = new VSPR9_AccountOrderSummaryController.VSPR9_OrderHistoryWrapper();
        ohw.labOrderNumber = '763521237';
        ohw.labInvoice = '451817';
        ohw.labNID = '33643';
        
        VSPR9_AccountOrderSummaryController.Stations st = new VSPR9_AccountOrderSummaryController.Stations();
        st.statusDate = '5/28/2015';
        st.status = 'abc';
        st.labName = 'vspone sacramento';
        
        System.currentPageReference().getParameters().put('url', 'https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494&invoice=451817&guid=3CCDADF4-A0B3-49FF-A0C4-82A9B5DCB4D3&accountNumber=17494');
        
        //Test.setMock(HttpCalloutMock.class, obj);
        //obj.getAccessToken();
        Test.setMock(HttpCalloutMock.class, new VSPR9_MockHttpResponseGenerator());
        
        obj.getFrameStatusValues();
        obj.getLensValues();
        obj.closePopup();
        obj.showpopup();
        
        obj.getShipMethodDetails();
        obj.getAccountOrderSummaryDetails();
        obj.getOrderDetails();
        obj.getOrderHistory();
        obj.getSortDirection();
        
        
       
        
        
        obj.strEdgeFrameStatusInfo = 'Uncut';
        obj.strLenses = 'Both Lenses';
        obj.redoStatus = 'Unresolved';
        obj.strAccountNumber = '17494';
        obj.strInvoiceNumber = '582043';
        obj.strlabNID = '33643';
               
        obj.submitRedoDetails();
        
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.SortData();
        obj.setSortDirection('ASC');
        obj.SortData();
        
        obj.sortExpression = 'patientname';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'rxnumber';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'labname';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'entereddate';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'location';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'locationatdate';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'estimatedshipdate';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.sortExpression = 'shipdate';
        obj.SortData();
        obj.setSortDirection('DESC');
        obj.SortData();
        
        obj.nextPage();
        obj.nextPage();
        obj.previousPage();
        obj.previousPage();
        
        obj.searchOnPatientName= 'herzberg';
        obj.searchOnInvoiceNumber = '';
        obj.searchOnRxNumber = '';
        obj.searchOrderDetails();
        
        obj.searchOnInvoiceNumber = '117511';
        obj.searchOnPatientName= '';
        obj.searchOnInvoiceNumber = '';
        obj.searchOrderDetails();
        
        obj.searchOnRxNumber = '65315207';
        obj.searchOnPatientName= 'herzberg';
        obj.searchOrderDetails();
        
        obj.searchOnPatientName= 'herzberg';
        obj.searchOnRxNumber = '';
        obj.searchOrderDetails();
        
        obj.searchOnPatientName= '';
        obj.searchOnRxNumber = '65315207';
        obj.searchOrderDetails();
        
        obj.searchOnPatientName= '';
        obj.searchOnRxNumber = '';
        obj.searchOrderDetails();
        
        obj.clearSearchDetails();
        
        obj.searchOnRxNumber = '65315207';
        obj.searchOnPatientName= 'herzberg';
        obj.searchOnInvoiceNumber = '117511';
        obj.getorderDetails();
        
        VSPR9_OrderDetailWrapper odw = new VSPR9_OrderDetailWrapper();
        odw.accountName = '17494';
        odw.rxNumber = '81794453';
        odw.invoiceNumber = '451817';
        odw.patientName = 'WADDELL, KENNETH';
        odw.labNID = '33643';
        odw.labNumber = '961';
        odw.orderStatus = 'S';
        odw.orderType ='RX';
        odw.dateEntered = '2015-05-01';
        odw.breakage = 'SHIPPED';
        odw.frameName = 'TACTIC';
        odw.frameManufacturer = 'MODE';
        
        odw.shipMethod = 'U01';
        odw.shipDesc = 'UPS Next Day Air';
        odw.trackNumber = '1Z8264370141845740';
        odw.trackURL = 'http://wwwapps.ups.com/WebTracking/track?track=yes&trackNums=1Z8264370141845740';
        odw.redoInvoiceNumber = '12345';
        odw.redoDVITime = '2015-05-01';
        
        VSPR9_OrderDetailWrapper.Details details = new VSPR9_OrderDetailWrapper.Details();
        
        VSPR9_OrderNotesWrapper onw = new VSPR9_OrderNotesWrapper();
        onw.labNID = '54032';
        onw.labName = 'VSPOne Tampa';
        onw.labNumber = '862';
        onw.labInvoice = '171503';
        onw.noteSeq = '2';
        onw.jobNote = 'recvd tint sample / in tray';
        onw.createdBy = 'SC';
        onw.jobNoteTS = '2015-05-07T13:35:00.000-07:00';
        
        VSPR9_ShippingMethodDetailsWrapper smdw = new VSPR9_ShippingMethodDetailsWrapper();
        smdw.labNumber = '961';
        smdw.labNID = '33643';
        smdw.labName = 'VSPOne San Diego';
        smdw.shipMethodCode = 'DIO';
        smdw.shipMethodDesc = 'Deliver-It';
        
        obj.setDefaultSationListValues();
        obj.sortExpression = '';
        obj.getSortDirection();
        
        RecordType rt = [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' and Name='Business Account' LIMIT 1];
        Account accountObj = new Account();
        accountObj.RecordTypeId = rt.Id;
        accountObj.Name = 'Test Account';
        accountObj.Optics_Key__c = '0000070570,0000070571';
        insert accountObj;
        
        obj.lstOrderSummaryDetails = new List<VSPR9_OrderSummariesWrapper>();
        obj.getAccountOrderSummaryDetails();
        
        obj.lstOrderSummaryDetails = new List<VSPR9_OrderSummariesWrapper>();
        obj.nextPage(); 
        
        
        obj.webServiceURL = '';
        obj.serviceException = 'Error';
        obj.orderDetailsEndPoint = '';
        obj.getShipMethodDetails(); 
        CalloutException e;
        obj.HandleException(e);
        
        obj.webServiceURL = '';
        obj.serviceException = '';
        obj.orderDetailsEndPoint = '';
        obj.getShipMethodDetails(); 
        obj.HandleException(e);
        
    }
}