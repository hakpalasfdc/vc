public class AccountOrderSummaryTest_Helper {
    
    public static HttpResponse labAccountResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
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
        httpResponse.setBody(json);
        return httpResponse;
    }
    
    public static HttpResponse vsponeLensOrdersResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
        String json = '{'+
            '    \"offsetId\": \"765013128\",'+
            '    \"pageSize\": \"20\",'+
            '    \"first\": {'+
            '        \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494\",'+
            '        \"type\": \"application/vnd.vsp.vsponelensorders\",'+
            '        \"rel\": \"urn://vnd.vsp.rels/first\"'+
            '    },'+
            '    \"next\": {'+
            '        \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494&offset=765013128\",'+
            '        \"type\": \"application/vnd.vsp.vsponelensorders\",'+
            '        \"rel\": \"next\"'+
            '    },'+
            '    \"vsponeLensOrders\": ['+
            '        {'+
            '            \"accountName\": \"17494\",'+
            '            \"rxNumber\": \"85091678\",'+
            '            \"invoiceNumber\": \"467797\",'+
            '            \"patientName\": \"SCHULTE, DAVID\",'+
            '            \"labNID\": \"33643\",'+
            '            \"labNumber\": \"961\",'+
            '            \"labName\": \"VSPOne San Diego\",'+
            '            \"labStationStatus\": \"Frame to Come\",'+
            '            \"dateAtStation\": \"2015-05-22\",'+
            '            \"dateEntered\": \"2015-05-22\",'+
            '            \"orderStatus\": \"I\",'+
            '            \"orderType\": \"RX\",'+
            '            \"orderNumber\": \"765780566\",'+
            '            \"guid\": \"A9607FD7-0818-4F95-BD6D-49C3FA516D7D\",'+
            '            \"estimatedShipDate\": \"2015-06-01\",'+
            '            \"vsponeLensOrderDetail\": {'+
            '                \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494&invoice=467797&guid=A9607FD7-0818-4F95-BD6D-49C3FA516D7D\",'+
            '                \"type\": \"application/vnd.vsp.vsponelensorders\",'+
            '                \"rel\": \"urn://vnd.vsp.rels/vsponelensorderdetail\"'+
            '            }'+
            '        },'+
            '        {'+
            '            \"accountName\": \"17494\",'+
            '            \"rxNumber\": \"84549175\",'+
            '            \"invoiceNumber\": \"462225\",'+
            '            \"patientName\": \"REBELO, HELEN\",'+
            '            \"labNID\": \"33643\",'+
            '            \"labNumber\": \"961\",'+
            '            \"labName\": \"VSPOne San Diego\",'+
            '            \"labStationStatus\": \"SHIPPED\",'+
            '            \"dateAtStation\": \"2015-05-19\",'+
            '            \"dateEntered\": \"2015-05-15\",'+
            '            \"orderStatus\": \"S\",'+
            '            \"orderType\": \"RX\",'+
            '            \"orderNumber\": \"765013128\",'+
            '            \"guid\": \"82617586-7E46-48B4-8AB8-F6C10B9715D1\",'+
            '            \"estimatedShipDate\": \"2015-05-19\",'+
            '            \"vsponeLensOrderDetail\": {'+
            '                \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorders?account=17494&invoice=462225&guid=82617586-7E46-48B4-8AB8-F6C10B9715D1\",'+
            '                \"type\": \"application/vnd.vsp.vsponelensorders\",'+
            '                \"rel\": \"urn://vnd.vsp.rels/vsponelensorderdetail\"'+
            '            }'+
            '        }'+
            '    ]'+
            '}';
        httpResponse.setBody(json);
        return httpResponse;
    }
    
    public static HttpResponse vsponeLensOrderDetailResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
        String json = '{'+
            '    \"vsponeLensOrderDetail\": ['+
            '        {'+
            '            \"accountName\": \"17494\",'+
            '            \"rxNumber\": \"81794453\",'+
            '            \"invoiceNumber\": \"451817\",'+
            '            \"patientName\": \"WADDELL, KENNETH\",'+
            '            \"labNID\": \"33643\",'+
            '            \"labNumber\": \"961\",'+
            '            \"labName\": \"VSPOne San Diego\",'+
            '            \"labStationStatus\": \"SHIPPED\",'+
            '            \"dateAtStation\": \"2015-05-06\",'+
            '            \"dateEntered\": \"2015-05-01\",'+
            '            \"actualShipDate\": \"2015-05-06\",'+
            '            \"orderStatus\": \"S\",'+
            '            \"orderType\": \"RX\",'+
            '            \"orderNumber\": \"763521237\",'+
            '            \"guid\": \"3CCDADF4-A0B3-49FF-A0C4-82A9B5DCB4D3\",'+
            '            \"estimatedShipDate\": \"2015-05-06\",'+
            '            \"surfaceIndicator\": \"1\",'+
            '            \"digitalLensIndicator\": \"0\",'+
            '            \"coatingIndicator\": \"0\",'+
            '            \"finishIndicator\": \"1\",'+
            '            \"subcontractType\": \"N\",'+
            '            \"frameName\": \"*TACTIC\",'+
            '            \"frameManufacturer\": \"MODE\",'+
            '            \"vsponeLensOrderHistory\": {'+
            '                \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensorderhistory?guid=3CCDADF4-A0B3-49FF-A0C4-82A9B5DCB4D3\",'+
            '                \"type\": \"application/vnd.vsp.vsponelensorderhistory\",'+
            '                \"rel\": \"urn://vnd.vsp.rels/vsponelensorderhistory\"'+
            '            },'+
            '            \"vsponeLensOrderNotes\": {'+
            '                \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/vsponelensordernotes?guid=3CCDADF4-A0B3-49FF-A0C4-82A9B5DCB4D3&date=2015-05-01\",'+
            '                \"type\": \"application/vnd.vsp.vsponelensordernotes\",'+
            '                \"rel\": \"urn://vnd.vsp.rels/vsponelensordernotes\"'+
            '            },'+
            '            \"labAccount\": {'+
            '                \"href\": \"https://api-sandbox.vspglobal.com:443/lab-vsponelensordersapi-web/labaccounts?account=17494\",'+
            '                \"type\": \"application/vnd.vsp.labaccounts\",'+
            '                \"rel\": \"urn://vnd.vsp.rels/labaccount\"'+
            '            }'+
            '        }'+
            '    ]'+
            '}';
        httpResponse.setBody(json);
        return httpResponse;
    }
    
    public static HttpResponse vsponeLensOrderHistoryResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
        String json = '{'+
            '    \"vsponeLensOrderHistory\": {'+
            '        \"lensOrderLabHistory\": ['+
            '            {'+
            '                \"labOrderNumber\": \"763521237\",'+
            '                \"labInvoice\": \"451817\",'+
            '                \"labNID\": \"33643\",'+
            '                \"labName\": \"VSPOne San Diego\",'+
            '                \"labOrderStatus\": \"S\",'+
            '                \"labStations\": ['+
            '                    {'+
            '                        \"statusDate\": \"2015-06-04T12:10:00.000-07:00\",'+
            '                        \"status\": \"SHIPPED\"'+
            '                    },'+
            '                    {'+
            '                        \"statusDate\": \"2015-06-04T12:10:00.000-07:00\",'+
            '                        \"status\": \"INSPECTION\"'+
            '                    },                    '+
            '                    {'+
            '                        \"statusDate\": \"2015-06-04T12:10:00.000-07:00\",'+
            '                        \"status\": \"ORDER ENTRY\"'+
            '                    }'+
            '                ]'+
            '            }'+
            '        ]'+
            '    }'+
            '}';
        httpResponse.setBody(json);
        return httpResponse;
    }
    
    public static HttpResponse vsponeLensOrderNotesResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
        String json = '{'+
            '    \"receivedDate\": \"2015-05-04\",'+
            '    \"vsponeLensOrderNotes\": ['+
            '        {'+
            '            \"labNID\": \"54032\",'+
            '            \"labName\": \"VSPOne Tampa\",'+
            '            \"labNumber\": \"862\",'+
            '            \"labInvoice\": \"171503\",'+
            '            \"noteSeq\": \"2\",'+
            '            \"jobNote\": \"recvd tint sample / in tray\",'+
            '            \"createdBy\": \"TA\",'+
            '            \"jobNoteTS\": \"2015-05-07T13:35:00.000-07:00\"'+
            '        },'+
            '        {'+
            '            \"labNID\": \"189476\",'+
            '            \"labName\": \"VSP Lab Long Island\",'+
            '            \"labNumber\": \"425\",'+
            '            \"labInvoice\": \"297328\",'+
            '            \"noteSeq\": \"1\",'+
            '            \"jobNote\": \"~SENDING TINT SAMPLE IT IS TO DARK BUT COLOR IS GOOD ONLY NEED 32 PERCENT TRANSMISSION  \",'+
            '            \"createdBy\": \"MI\",'+
            '            \"jobNoteTS\": \"2015-05-04T13:00:00.000-07:00\"'+
            '        }'+
            '    ]'+
            '}';
        httpResponse.setBody(json);
        return httpResponse;
    }
    
    public static HttpResponse redoResponse(){
        HttpResponse httpResponse = new HttpResponse();
        httpResponse.setStatusCode(200);
        
        String json = '{'+
            '    \"orderNumber\": \"1234567\",'+
            '    \"jobGUID\": \"2CF5C689-368D-4430-B20F-3E61F8312EE6\",'+
            '    \"notes\": \"AR Warranty Lens Only Jane Doe JP\",'+
            '    \"requestedGUID\": \"eb3d9816-04df-44dd-9893-3b1421f46ab9\",'+
            '    \"orderDate\": \"2015-05-19T16:35:47.969Z\",'+
            '    \"warranty\": {'+
            '        \"code\": \"REDO\",'+
            '        \"edge\": \"E\",'+
            '        \"frameStatus\": \"N\",'+
            '        \"eyes\": \"B\"'+
            '    },'+
            '    \"status\": \"Successful\",'+
            '    \"description\": \"REDO completed\"'+
            '}';
        httpResponse.setBody(json);
        return httpResponse;
    }
}