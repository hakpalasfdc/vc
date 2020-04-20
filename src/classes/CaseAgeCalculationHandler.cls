/*
   Writen Date : 25th May 2016.
   Related Object : Case.
   Related Case : 9044.
   Description : Calculating age of the Case excluding Holidays and Weekends.
*/
// Test Deployment...MC
public class CaseAgeCalculationHandler {
    public static void CalculateCaseAge(List<Case> caseList){
    System.debug('#### handler class invoked ...');
    Integer noOfHolidays;
    Integer noOfWorkingDays;
    Integer CountWeekendHoliday;
    Integer NoOfWeekends;
    List<Case> caseToUpdateList = new List<Case>();
    System.debug('caseList::'+ caseList);
    
    for(Case c : caseList){
        noOfHolidays =0;
        NoOfWeekends =0;
        CountWeekendHoliday =0;
        if(c.Email_Last_Sent__c != null || c.ClosedDate != null){
            System.debug('Enter 1');
            c.Case_Age_2__c = 0;
            system.debug('============================HOURS'+c.Case_Age_2__c);
            caseToUpdateList.add(c);
        }
        else if(c.ClosedDate == null && c.Email_Last_Sent__c == null){
            System.debug('Enter 2');
            DateTime dT = System.now();
            Date EmailReceived;
            Date TodayDate = date.newinstance(dT.year(), dT.month(), dT.day());
            Datetime ReferEmailReceived;
            system.debug('############Today Date '+TodayDate);
            
            if(c.Email_Last_Received__c == null){
                //c.Email_Last_Received__c = c.CreatedDate;
                ReferEmailReceived = c.CreatedDate;
                EmailReceived = date.newinstance(c.CreatedDate.year(), c.CreatedDate.month(), c.CreatedDate.day());            
            }
            else{
                EmailReceived = date.newinstance(c.Email_Last_Received__c.year(), c.Email_Last_Received__c.month(), c.Email_Last_Received__c.day());
                system.debug('############ Email Received'+EmailReceived);
                ReferEmailReceived = c.Email_Last_Received__c;
            }
            
            If(EmailReceived <= TodayDate){
                noOfHolidays = holidayCount(TodayDate, EmailReceived);
            }
            else{
                noOfHolidays = holidayCount(EmailReceived, TodayDate);
                system.debug('===============HOLIDAY'+noOfHolidays);
            }
            
            If(TodayDate >= c.Email_Last_Received__c){
                NoOfWeekends = daysOff(c.Email_Last_Received__c, TodayDate);
            }
            else{
                NoOfWeekends = daysOff(TodayDate,c.Email_Last_Received__c);
                system.debug('===============WEEKEND Days :'+NoOfWeekends);
            }
            
            CountWeekendHoliday = (NoOfWeekends*24 + noOfHolidays*24);
            System.debug('#### CaseAgeinHours = '+CountWeekendHoliday);
            
            decimal decHours = 0;
            decimal exactHours = 0;
            decHours = ((ReferEmailReceived.getTime() - System.Now().getTime())/(1000*60*60));
            system.debug('--------------Hours'+decHours);
            exactHours = decHours.abs();
            exactHours = exactHours - CountWeekendHoliday;
            c.Case_Age_2__c = Math.ceil(exactHours);
            system.debug('============================HOURS'+exactHours);
            caseToUpdateList.add(c);
        }
    }
        System.debug('#### caseToUpdateList = > '+caseToUpdateList);
        try{
            if(caseToUpdateList.size()>0){
               update caseToUpdateList;
            }
        }catch(System.DMLException e){ System.debug(e.getMessage()); }
    }
    
    // For Calculate Holidays
    public static Integer holidayCount(Date StartDate, Date EndDate){
        List<Holiday> holidays = new List<Holiday>();
        holidays = [Select id, Name, ActivityDate from holiday where ActivityDate>= :EndDate AND ActivityDate<= :StartDate];
        if(holidays.size()>0)return holidays.size();return 0;
    }
    
    // For finding the weekneds days
    public static Integer daysOff(Datetime sdate, Datetime edate){
         Integer i = 0;
         while (sdate < edate) {
             if (sdate.format('E') == 'Sat' | sdate.format('E') == 'Sun'){
                 i = i + 1;
             }
             sdate = sdate.addDays(1);
         }
         return i;
    }
    
}