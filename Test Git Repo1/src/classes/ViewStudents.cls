public class ViewStudents{
    public String classes{get;set;}
    List<Class__c> clsList;
    public List<Student__c> stdList{get;set;}
    
    public List<SelectOption> getItems() {
        List<SelectOption> options = new List<SelectOption>();
        
        for(Class__c c: clsList){
            options.add(new SelectOption(c.Id ,c.Name));
        }
        
        return options;
    }
               
    public ViewStudents(){
        clsList = new List<Class__c>();
        clsList = [Select Id, Name From Class__c];
    }
    
    public PageReference showStudents(){
        stdList = new List<Student__c>();
        system.debug('@@ classes '+classes );
        stdList = [Select Id, Name, First_Name__c, Last_Name__c, Grade_Level__c from Student__c Where FKClass__c =: classes ];
        return null;
    }

}