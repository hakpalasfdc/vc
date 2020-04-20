global class DSSendtoQueue {
    
    @InvocableMethod
    public static void DSSendtoQueue(List<sobjectsListRequests> requests)
    {   
        System.debug('In Invocable Method');
        ID OBID;
        ID UID;
        String phoneNum;
        Datetime callBackTime;
        //Integer priorityScore;
        //String groupName;
        //Integer groupNumber;


        Integer x;
        for (sobjectsListRequests request : requests)
        {
            OBID = request.OBID;
            UID = request.UID;
            phoneNum = '1234657890'; //request.phoneNum;
            callBackTime = request.callBackTime;
            //priorityScore = request.priorityScore;
            //groupName = request.groupName;
            system.debug('Time = ' + callBackTime);
            //system.debug('Time = ' + callBackTime - 5);

        }
        
        if(callBackTime != Null)
        {
                try
                {
                    DSSendtoBackend RTPQ = new DSSendtoBackend(UID, OBID, phoneNum, callBackTime/*priorityScore, groupNumber*/);
                    ID jobID = System.enqueueJob(RTPQ);
                }
                catch(exception e)
                {
                    System.debug('Failed to enqueue batch job.  Error: ' + e);
                }            
        }
    }
      
    global class sobjectsListRequests
    {
        @InvocableVariable(required=True)
        public Id OBID;
        @InvocableVariable(required=True)
        public Id UID;
        @InvocableVariable(required=False)
        public String phoneNum;
        @InvocableVariable(required=True)
        public Datetime callBackTime;
        
        //@InvocableVariable(required=False)
        //public Integer priorityScore;
        //@InvocableVariable(required=False)
        //public string groupName;
        
    }
}