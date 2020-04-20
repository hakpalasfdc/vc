public class VSPAPILoadRunner {
    
    public Static Long vspAPIResponseTime(String URL, Integer iterations) {
        Long total = 0;
        Integer totalCallouts = 0;
        for (Integer i = 0, j = 0; i < iterations; i++) {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            Long now = DateTime.now().getTime();
            req.setEndpoint(URL);
            req.setMethod('GET');
            HttpResponse res = http.send(req);
            Long elapsed = DateTime.now().getTime() - now;
            Integer iteration = i+1;
            system.debug('ElapsedTime'+iteration+'='+elapsed);
            total = total + elapsed;
            totalCallouts++;
        }
        system.debug('total='+total);
        system.debug('totalCalouts='+totalCallouts);
        return total;
    }
}