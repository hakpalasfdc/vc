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
@isTest
                        
global class VSPR9_MockHttpResponseGenerator implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Accept','application/json');
        
        String json = '{'+
            '    \"labAccount\": {'+
            '        \"accountNumber\": \"17494\",'+
            '        \"salesTerritory\": \"6003\",'+
            '        \"brandTerritory\": \"B207\",'+
            '        \"accountLab\": \"SVP\",'+
            '        \"accountName\": \"MILLERDAWN\",'+
            '        \"accountAddress\": \"12966 MAIN ST\",'+
            '        \"accountCity\": \"GARDEN GROVE\",'+
            '        \"accountState\": \"CA\",'+
            '        \"accountZip\": \"92840\",'+
            '        \"accountPhone\": \"714-530-5720\",'+
            '        \"accountFax\": \"714-530-1465\",'+
            '        \"efanNumber\": \"9000007062\"'+
            '    },'+
            '    \"shipMethods\": ['+
            '        {'+
            '            \"labNumber\": \"961\",'+
            '            \"labNID\": \"33643\",'+
            '            \"labName\": \"VSPOne San Diego\",'+
            '            \"shipMethodCode\": \"DIO\",'+
            '            \"shipMethodDesc\": \"Deliver-It\"'+
            '        },'+
            '        {'+
            '            \"labNumber\": \"425\",'+
            '            \"labNID\": \"189476\",'+
            '            \"labName\": \"VSP Lab Long Island\",'+
            '            \"shipMethodCode\": \"U43\",'+
            '            \"shipMethodDesc\": \"UPS Next Day Air Saver\"'+
            '        },'+
            '        {'+
            '            \"labNumber\": \"999\",'+
            '            \"labNID\": \"4923\",'+
            '            \"labName\": \"VSPOne Sacramento\",'+
            '            \"shipMethodCode\": \"SOU\",'+
            '            \"shipMethodDesc\": \"UNITY Courier (Southern California)\"'+
            '        },'+
            '        {'+
            '            \"labNumber\": \"199\",'+
            '            \"labNID\": \"53297\",'+
            '            \"labName\": \"VSPONE Columbus\",'+
            '            \"shipMethodCode\": \"U07\",'+
            '            \"shipMethodDesc\": \"UPS 2nd Day\"'+
            '        }'+
            '    ],'+
            '    \"vsponeLensOrders\": {'+
            '        \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494\",'+
            '        \"type\": \"application/vnd.vsp.vsponelensorders\",'+
            '        \"rel\": \"urn://vnd.vsp.rels/vsponelensorders\"'+
            '    }'+
            '}';

        res.setBody(json);
        res.setStatusCode(200);
        return res;
    }
}