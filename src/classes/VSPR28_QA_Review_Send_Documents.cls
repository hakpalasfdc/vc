public class VSPR28_QA_Review_Send_Documents {
    //Apex properties or variables
    public Id QA_Id { get; set; }
    public QA_Review__c QA_Review { get; set; }
    public QA_Patient_Review__c QA_Pat_Review { get; set; }
    public String providerName{get;set;}
    public String auditEmail{get;set;}
    
    //constructor to get the record
    public VSPR28_QA_Review_Send_Documents(ApexPages.StandardController controller) {
        QA_Review =  (QA_Review__c)controller.getRecord();
        QA_Id = QA_Review.Id;
        System.debug('The QA Review record: ' + QA_Review);
    }
    
    //Method that can is called from the Visual Force page action attribute
    public PageReference QueryPatientRecords() {
        //build your code logic here
        PageReference pageRef = new PageReference('/'+QA_Id);
        pageRef.setRedirect(true);
        if(QA_Id != null){
            system.debug('*****entered VSP_QA_Review_Update_Button ****');
            Map<Integer,QA_Patient_Review__c> mapQAPatients = new Map<Integer, QA_Patient_Review__c>();
            Integer incNumb = 1;
            List<QA_Review__c> lstQA = [Select Id, Provider_Name__c, Audit_Email__c from QA_Review__c WHERE Id = :QA_Id];
            providerName = lstQA[0].Provider_Name__c;
            auditEmail = lstQA[0].Audit_Email__c;

            List<QA_Review__c> addtoList = new List <QA_Review__c>();
            List<QA_Patient_Review__c> lstPatRec = [SELECT Patient_First_Name__c, Patient_Last_Name__c, Patient_Age__c, Date_of_Service__c, Authorization_Number__c FROM QA_Patient_Review__c WHERE QA_Review_Number__c = :QA_Id Order by CreatedDate LIMIT 10];

            if(!lstPatRec.isEmpty()){
                for(QA_Patient_Review__c pr :lstPatRec ){
                    mapQAPatients.put(incNumb, pr);
                    incNumb ++;
                }
                for(QA_Review__c QA :lstQA){
                    for(Integer mpPatRec :mapQAPatients.keySet()){
                        if(mpPatRec == 1){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_1__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_1__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_1__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_1__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 2){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_2__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_2__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_2__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_2__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 3){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_3__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_3__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_3__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_3__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 4){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_4__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_4__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_4__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_4__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 5){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_5__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_5__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_5__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_5__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 6){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_6__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_6__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_6__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_6__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 7){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_7__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_7__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_7__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_7__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 8){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_8__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_8__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_8__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_8__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 9){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_9__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_9__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_9__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_9__c = QA_Pat_Review.Authorization_Number__c;
                        }
                        else if(mpPatRec == 10){
                            QA_Pat_Review = mapQAPatients.get(mpPatRec);
                            QA.QA_Patient_Name_10__c = QA_Pat_Review.Patient_First_Name__c + ' ' + QA_Pat_Review.Patient_Last_Name__c;
                            QA.QA_Patient_Age_10__c = QA_Pat_Review.Patient_Age__c;
                            QA.QA_Patient_Date_of_Service_10__c = QA_Pat_Review.Date_of_Service__c;
                            QA.QA_Patient_Claim_Number_10__c = QA_Pat_Review.Authorization_Number__c;
                        }
                    }
                    addtoList.add(QA);
                }
                if(!addtoList.isEmpty()){
                    update addtoList;
                }
                System.debug('The QA Patient Map: ' + mapQAPatients);
            }
        }
        Contact c = [Select Id,Name from Contact where Id =:providerName];
        String Name = c.Name; 
        String firstName = Name.substring(0,Name.indexOf(' ')); 
        String lastName = Name.substring(Name.indexOf(' ')+1); 
        String CRL = 'Email~'+auditEmail+';FirstName~'+firstName+';LastName~'+lastName+';Role~Provider~;RoutingOrder~;AccessCode~;RecipientNote~;SignNow~,LoadDefaultContacts~1'; 
        return new PageReference('/apex/dsfs__DocuSign_CreateEnvelope?DSEID=0&SourceID='+QA_Id+'&CRL='+CRL); //Returns to the case page
    }
}