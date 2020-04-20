public class Mask9DigitHandler{

    /*
    public static void methodMask9DigitDescription(List<Case> cList){
        
        for(Case c:cList){
        
            if(c.Description <> null){
            
                String updatedStr='';
              
                List<String> strList = c.Description.split(' ');
                
                for(String s :strList){
                    
                    if(String.isNotBlank(s)){
                        if(s.contains('\n')){
                            
                            List<String> strList1 = new List<String>();
                            strList1 = s.split('\n');
                            Integer cn = 1;
                            for(String s1:strList1){
                                
                                if(String.isNotBlank(s1)){
                                    System.debug('s1========'+s1);
                 
                                    String str = s1.replace('-','');
                                   
                                    str = str.replace('\r','');
                                
                                    str=str.escapeJava();
                                  
                                 //  string userInput = 'a\u200Bb\u200Cc\u200Dd\uFEFFe';
                                    if(str.contains('u200B')){
                                        System.debug('str123======'+str);
                                        str=str.substring(6,(str.length()));
                                    //    str=str.replace('\u200B','');
                                    }
                                    
                                    str=string.valueof(str);
                                    System.debug('str======'+str);
                                    if(String.isNotBlank(str)){
                                        System.debug('Str===='+str.length());
                                        if(str.substring(0,1).isNumeric() && !str.contains('/')){
                                        String str1 ='';
                                        Integer count = 0;
                                        String cLast = str.right(1);
                                        System.debug('Last Character ==========='+cLast);
                                        
                                            if(cLast.isNumeric() == false){
                                                System.debug('Last Character is not numeric : '+cLast);
                                                if(str.length() == 10){
                
                                                    for(Integer i=0;i<s1.length();i++){
                                                        
                                                        if(s1.substring(i,i+1).isNumeric() && count<5){
                                                            str1 += 'X';
                                                            count++;
                                                        }
                                                        else{
                                                            str1 += s1.substring(i,i+1);
                                                        }
                                                      
                                                    }
                                                    if(cn<strList1.size()){
                                                        updatedStr += str1 + '\r\n';
                                                        cn++;
                                                        System.debug('entering 1==========');
                                                    }
                                                    else{
                                                        updatedStr += str1 + ' ';
                                                        System.debug('entering 1else==========');
                                                    }
                                                      
                                          
                                                }
                                                else{
                                                    if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                        System.debug('entering 2==========');
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                        System.debug('entering 2 else==========');
                                                    }
                                                }
                                            }
                                            else{
                                                System.debug('Not contain .===='+str.length());
                                                if(str.length() == 9 ){
                                                    System.debug('');
                                                    for(Integer i=0;i<s1.length();i++){
                                                        
                                                        if(s1.substring(i,i+1).isNumeric() && count<5){
                                                            str1 += 'X';
                                                            count++;
                                                        }
                                                        else{
                                                            str1 += s1.substring(i,i+1);
                                                        }
                                                      System.debug('Final str1===='+str1);
                                                    }
                                                    if(cn<strList1.size()){
                                                        updatedStr += str1 + '\r\n';
                                                        cn++;
                                                    }
                                                    else{
                                                        updatedStr += str1 + ' ';
                                                    }   
                                                }
                                                else{
                                                    if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                    }
                                                }
                                            }  
                                        }
                                        
                                        else{
                                            if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                      System.debug('entering 3==========');
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                        System.debug('entering 3 else==========');
                                                    } 
                                        }
                                    }
                                    else{  
                                        updatedStr += str + '\n';
                                    }
                                     
                                        
                                    }
                                else{
                                    updatedStr += '\r\n';
                                    cn++;
                                    System.debug('blank=========');
                                }
                            }
                        }
                        else{
                            if(s.substring(0,1).isNumeric() && !s.contains('/')){
             
                                String str = s.replace('-','');
                                System.debug('str======'+str);
                                String str1 ='';
                                Integer count = 0;
                                String cLast = s.right(1);
                                System.debug('Last Character ============'+cLast);
                                
                                if(cLast.isNumeric()== false){
                                    System.debug('Last Character is not numeric : '+cLast);
                                    if(str.length() == 10){
        
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }
                                else{
                                    if(str.length() == 9){
                                      
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }   
                            }
                            else{
                                updatedStr += s + ' ';
                            }
                        }
                    }
                    else{
                        updatedStr += s + ' ';
                    }          
                }
                c.Description = updatedStr; 
            }
        }
    }
    */
    
    public static void methodMask9DigitSubject(List<Case> cList){
        
        for(Case c:cList){
        
            if(c.Subject <> null){
            
                String updatedStr='';
                List<String> strList = c.Subject.split(' ');
                
                for(String s :strList){
                    
                    if(String.isNotBlank(s)){
            
                            if(s.substring(0,1).isNumeric() && !s.contains('/')){
             
                                String str = s.replace('-','');
                                System.debug('str======'+str);
                                String str1 ='';
                                Integer count = 0;
                                String cLast = s.right(1);
                                System.debug('Last Character ==========='+cLast);
                                
                                if(cLast.isNumeric() == false){
                                    System.debug('Last Character is not Numeric : '+cLast);
                                    if(str.length() == 10){
        
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }
                                else{
                                    if(str.length() == 9){
                                      
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }   
                            }
                            else{
                                updatedStr += s + ' ';
                            }
                    }
                    else{
                        updatedStr += s + ' ';
                    }          
                }
                c.Subject = updatedStr; 
            }
        }
    }
    
    /*
    public static void methodMask9DigitBody(List<EmailMessage> eList){
        
        for(EmailMessage e:eList){
        
            if(e.TextBody <> null){
            
                String updatedStr='';
              
                List<String> strList = e.TextBody.split(' ');
                
                for(String s :strList){
                    
                    if(String.isNotBlank(s)){
                        if(s.contains('\n')){
                            
                            List<String> strList1 = new List<String>();
                            strList1 = s.split('\n');
                            Integer cn = 1;
                            for(String s1:strList1){
                                
                                if(String.isNotBlank(s1)){
                                    System.debug('s1========'+s1);
                 
                                    String str = s1.replace('-','');
                                   
                                    str = str.replace('\r','');
                                
                                    str=str.escapeJava();
                                  
                                 //  string userInput = 'a\u200Bb\u200Cc\u200Dd\uFEFFe';
                                    if(str.contains('u200B')){
                                        System.debug('str123======'+str);
                                        str=str.substring(6,(str.length()));
                                    //    str=str.replace('\u200B','');
                                    }
                                    
                                    str=string.valueof(str);
                                    System.debug('str======'+str);
                                    if(String.isNotBlank(str)){
                                        System.debug('Str===='+str.length());
                                        if(str.substring(0,1).isNumeric() && !str.contains('/')){
                                        String str1 ='';
                                        Integer count = 0;
                                        string cLast = str.right(1);
                                        System.debug('Last Character ================='+cLast);
                                        
                                            if(cLast.isNumeric() == false){
                                                System.debug('Last Character is not numeric: ' +cLast);
                                                if(str.length() == 10){
                
                                                    for(Integer i=0;i<s1.length();i++){
                                                        
                                                        if(s1.substring(i,i+1).isNumeric() && count<5){
                                                            str1 += 'X';
                                                            count++;
                                                        }
                                                        else{
                                                            str1 += s1.substring(i,i+1);
                                                        }
                                                      
                                                    }
                                                    if(cn<strList1.size()){
                                                        updatedStr += str1 + '\r\n';
                                                        cn++;
                                                        System.debug('entering 1==========');
                                                    }
                                                    else{
                                                        updatedStr += str1 + ' ';
                                                        System.debug('entering 1else==========');
                                                    }
                                                      
                                          
                                                }
                                                else{
                                                    if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                        System.debug('entering 2==========');
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                        System.debug('entering 2 else==========');
                                                    }
                                                }
                                            }
                                            else{
                                                System.debug('Not contain .===='+str.length());
                                                if(str.length() == 9 ){
                                                    System.debug('');
                                                    for(Integer i=0;i<s1.length();i++){
                                                        
                                                        if(s1.substring(i,i+1).isNumeric() && count<5){
                                                            str1 += 'X';
                                                            count++;
                                                        }
                                                        else{
                                                            str1 += s1.substring(i,i+1);
                                                        }
                                                      System.debug('Final str1===='+str1);
                                                    }
                                                    if(cn<strList1.size()){
                                                        updatedStr += str1 + '\r\n';
                                                        cn++;
                                                    }
                                                    else{
                                                        updatedStr += str1 + ' ';
                                                    }   
                                                }
                                                else{
                                                    if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                    }
                                                }
                                            }  
                                        }
                                        
                                        else{
                                            if(cn<strList1.size()){
                                                        updatedStr += s1 + '\r\n';
                                                        cn++;
                                                      System.debug('entering 3==========');
                                                    }
                                                    else{
                                                        updatedStr += s1 + ' ';
                                                        System.debug('entering 3 else==========');
                                                    } 
                                        }
                                    }
                                    else{  
                                        updatedStr += str + '\n';
                                    }
                                     
                                        
                                    }
                                else{
                                    updatedStr += '\r\n';
                                    cn++;
                                    System.debug('blank=========');
                                }
                            }
                        }
                        else{
                            if(s.substring(0,1).isNumeric() && !s.contains('/')){
             
                                String str = s.replace('-','');
                                System.debug('str======'+str);
                                String str1 ='';
                                Integer count = 0;
                                String cLast = s.right(1);
                                System.debug('Last Character ==========='+cLast);
                                
                                if(cLast.isNumeric() == false){
                                    System.debug('Last Character is not numeric : '+cLast);
                                    if(str.length() == 10){
        
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }
                                else{
                                    if(str.length() == 9){
                                      
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }   
                            }
                            else{
                                updatedStr += s + ' ';
                            }
                        }
                    }
                    else{
                        updatedStr += s + ' ';
                    }          
                }
                e.TextBody = updatedStr; 
            }
        }
    }
    */
    
    public static void methodMask9DigitEmailSubject(List<EmailMessage> eList){
        
        for(EmailMessage e:eList){
        
            if(e.Subject <> null){
            
                String updatedStr='';
                List<String> strList = e.Subject.split(' ');
                
                for(String s :strList){
                    
                    if(String.isNotBlank(s)){
            
                            if(s.substring(0,1).isNumeric() && !s.contains('/')){
             
                                String str = s.replace('-','');
                                System.debug('str======'+str);
                                String str1 ='';
                                Integer count = 0;
                                String cLast = s.right(1); 
                                System.debug('last character ============='+cLast);
                                
                                if(cLast.isNumeric() == false){
                                    System.debug('Last Character is non-numeric : '+cLast);
                                    if(str.length() == 10){
        
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }
                                else{
                                    if(str.length() == 9){
                                      
                                        for(Integer i=0;i<s.length();i++){
                                            
                                            if(s.substring(i,i+1).isNumeric() && count<5){
                                                str1 += 'X';
                                                count++;
                                            }
                                            else{
                                                str1 += s.substring(i,i+1);
                                            }
                                          
                                        }
                                        updatedStr += str1 + ' ';   
                                    }
                                    else{
                                        updatedStr += s + ' ';
                                    }
                                }   
                            }
                            else{
                                updatedStr += s + ' ';
                            }
                    }
                    else{
                        updatedStr += s + ' ';
                    }          
                }
                e.Subject = updatedStr; 
            }
        }
    }
}