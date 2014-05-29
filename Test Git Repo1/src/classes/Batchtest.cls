@IsTest(SeeAllData=true)
Private class Batchtest{
    static testMethod void test1(){
        Test.startTest();
        MyBatchClass captureBatch = new MyBatchClass ();
        
        MyBatchClass.startBatch();
        Test.StopTest();
    }
}