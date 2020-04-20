public with sharing class VSPR28_CalculateFinalScoreExtension{
    ApexPages.StandardController setCon;
    Id QAReviewId; 
    Decimal medicalPointsPossible=0, medicalPointsEarned=0; 
    Decimal overallCompliancePercentage = 0; 
    String reviewResult;
    public VSPR28_CalculateFinalScoreExtension(ApexPages.StandardController controller){
        this.setCon = controller;
        QAReviewId = ApexPages.currentPage().getParameters().get('Id');
    }
    
    public PageReference getRecDetails() {
        List<QA_Patient_Review__c> lstQAPR = [Select Id, Name, Patient_Review_Status__c, Patient_Possible_Points__c, Patient_Total_Points__c from QA_Patient_Review__c where Patient_Review_Status__c = 'Complete' and QA_Review_Number__r.Id = :QAReviewId];
        for(QA_Patient_Review__c q : lstQAPR){
            if(q.Patient_Review_Status__c == 'Complete'){
                medicalPointsPossible = medicalPointsPossible + q.Patient_Possible_Points__c;
                medicalPointsEarned = medicalPointsEarned + q.Patient_Total_Points__c; 
            }
        }
        if(medicalPointsEarned != 0){
            overallCompliancePercentage = (medicalPointsEarned/medicalPointsPossible)*100;
        }
        if(overallCompliancePercentage >= 80){
            reviewResult = 'Pass'; 
        }
        else{
            reviewResult = 'Fail';
        }
        QA_Review__c qa = [Select Id, Medical_Points_Possible__c, Contact_Role__c, Vision_Care_Location_Key__c, Medical_Points_Earned__c, Overall_Compliance_Percentage__c, Review_Results__c from QA_Review__c where Id = :QAReviewId];
        system.debug('+++++++++++' +qa);
        qa.Medical_Points_Possible__c = medicalPointsPossible;
        qa.Medical_Points_Earned__c = medicalPointsEarned;
        qa.Overall_Compliance_Percentage__c = overallCompliancePercentage;
        qa.Review_Results__c = reviewResult;
        update qa; 
        system.debug('+++++++++++' +qa);
        return new PageReference('/' + QAReviewId);
    }
}