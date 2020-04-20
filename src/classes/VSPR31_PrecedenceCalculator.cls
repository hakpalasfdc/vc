public with sharing class VSPR31_PrecedenceCalculator {
    public static Map<Id, String> calculatePracticeAgreement(Map<Id, Account> accountMap, Map<Id, Set<String>> pracAccountAgreement, Map<String, Integer> precedence){
        Map<Id, String> mapper = new Map<Id, String>();
        
        for(Account a: accountMap.values()){
            if(pracAccountAgreement.containsKey(a.Id) && !pracAccountAgreement.get(a.Id).isEmpty()){
                mapper.put(a.id, calculate(new List<String>(pracAccountAgreement.get(a.Id)), precedence));
            }else{
                mapper.put(a.id, null);
            }
        }

        return mapper;
    }

    public static String calculate(List<String> s, Map<String, Integer> precedence){
        String agreement = '';
        if(s.size()>1){
            agreement = s.get(0);
            Integer max = precedence.get(agreement);
            for(Integer i=1;i<s.size();i++){
                if(max>precedence.get(s.get(i))){
                    agreement = s.get(i);
                    max = precedence.get(agreement);
                }
            }
        }else{
            agreement = s.get(0);
        }
        return agreement;
    }
}