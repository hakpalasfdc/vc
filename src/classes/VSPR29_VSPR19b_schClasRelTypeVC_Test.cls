//Test class to test VSPR19b_schClassRelTypesVisionCare
@isTest
private class VSPR29_VSPR19b_schClasRelTypeVC_Test {
    private static testMethod void chClassRelTypesVisionCareTest(){
        test.startTest();
        VSPR19b_schClassRelTypesVisionCare rtvc = new VSPR19b_schClassRelTypesVisionCare();
        String cronExp = '0 0 23 * * ?';
        String jobId = System.schedule('TestJob', cronExp, rtvc);
        rtvc.execute(null);
        test.stopTest();
    }
}