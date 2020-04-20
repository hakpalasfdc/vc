/**
* Class Name: Testvspresourcelinks
* @author: Eagle Creek    
* Date: 25.OCT.2018
* Requirement/Project Name: VSPGlobalSales
* @description: Test class for the retrievel of custom settings value for vspresourcelinks.
*/

@isTest
public class Testvspresourcelinks {
   static testmethod void Testvspresourcelinks()
    {
      vspresourcelinks vs1 = new vspresourcelinks();
      System.debug(vs1.vsplinks);
       
    }

}