global class MyBatchClass implements Database.Batchable<sObject>, Database.Stateful {
    
    String query = 'Select Id From Account';
    global static void startBatch() {
        integer batch_size = 3000;
        MyBatchClass instance = new MyBatchClass ();
        Id BatchJobID = Database.executeBatch(instance ,batch_size); 
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Account> scope){
        
    }
    global void finish(Database.BatchableContext BC){
    
    }
}