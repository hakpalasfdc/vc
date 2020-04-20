Public class CreateDateTime{
    public static DateTime CreateDateFromPicklist(String mydate){
        Integer hour;
        Integer minute;
        System.debug('--------mydate'+mydate);
        if(mydate.contains('PM')){
            List<String> temp = mydate.substring(0,4).split(':');
            temp[0] = temp[0].trim();
            hour = Integer.valueOf(temp[0])==12?Integer.valueOf(temp[0]):+Integer.valueOf(temp[0])+12;
            System.debug('--------hour2'+hour );
            minute = Integer.valueOf(temp[1]); 
            System.debug('--------minute2'+minute );
         }
         else{
            List<String> temp = mydate.substring(0,4).split(':');
            temp[0] = temp[0].trim();
            hour = Integer.valueOf(temp[0]);
            System.debug('--------hour1'+hour );
            minute = Integer.valueOf(temp[1]);  
            System.debug('--------minute1'+minute );
        }
        
        DateTime dt = DateTime.newInstanceGMT(2015,11,1,hour,minute,0);    
        return dt; 
    }
}