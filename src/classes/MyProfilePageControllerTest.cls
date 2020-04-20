/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MyProfilePageControllerTest {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        MyProfilePageController obj=new MyProfilePageController();
        obj.getIsEdit();
        obj.edit();
        obj.getuser();
        obj.save();
        obj.changepassword();
        obj.cancel();
        
        Contact c = new Contact();
            c.title='hlkjhj';
        c.firstname = 'u.firstname';
        c.lastname = 'u.lastname';
        c.email = 'u.email';
        c.phone = 'u.phone';
        c.mobilephone = 'u.mobilephone';
        c.fax = 'u.fax';
        c.mailingstreet = 'u.street';
        c.mailingcity = 'u.cit';
        c.mailingstate = 'u.state';
        c.mailingpostalcode = 'u.postalcode';
        c.mailingcountry = 'u.country';
        MyProfilePageController.setContactFields(c,new user());
    }
    
    
}