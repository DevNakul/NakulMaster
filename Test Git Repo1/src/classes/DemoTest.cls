@isTest
private class DemoTest{
    
    static testMethod void test1(){
        
        Test.startTest();
        ViewStudents obj = new ViewStudents();
        Test.stopTest();
        //system.assertEquals(true, false);
    }
}