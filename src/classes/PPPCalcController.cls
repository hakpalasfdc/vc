public class PPPCalcController {

    @auraenabled
    public static string getcopytocase(string tab, string label, string value, string exam, string lens, string frame, string other, string recordId){
        String detail;
        Case CC = [select id, comments from Case where Id =: recordId];    
        if (tab=='1') {
            tab='Glasses';
            detail = 'Exam:' + exam +'\n' + 'Lens:' + lens +'\n'+ 'Frame:'+ frame + '\n' + 'Other:' + other;
        }
        if (tab=='2') {
            tab='Glasses-Total Copay';
            detail = 'Exam:' + exam +'\n' + 'Lens:' + lens +'\n'+ 'Frame:'+ frame + '\n' + 'Other:' + other;
        }
        if (tab=='3') {
            tab='Contacts-Allowance Combined';
            detail = 'Exam:' + exam +'\n' + 'ECL Materials:' + other + '\n';
        }
        if (tab=='4') {
            tab='Contacts-Exams, Fees with Material Allowance';
            detail = 'Exam:' + exam +'\n' + 'CL Exam:' + lens +'\n' + 'ECL Materials:' + other;
        }
        if (tab=='5') {
            tab='Contacts-Recipts Combined';
            detail = 'Exam:' + exam;
        }
        if (tab=='6') {
            tab='Contacts-Covered or Necessary';
            detail = 'Exam:' + exam + '\n' + 'Covered CL:' + lens;
        }
        String calcResults = 'VSP Provider PPP Reimbursement'+'\n'+ tab +'\n' + label + '\n' +
                             'Total Reimbursement Amount is:'+ value +'\n' + detail + '\n';                               

        CC.comments = calcResults;
        update CC;
        return 'Success';
    }
        
 }