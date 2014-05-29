trigger ClassValidationTrigger on Teacher_Class__c (before insert, before update) {
    boolean isError = false;
    for(Teacher_Class__c tc : trigger.new){
        AggregateResult[] aggresult = [Select Teacher__c, count(Class__c) from Teacher_Class__c Where Teacher__c =: tc.Teacher__c Group by Teacher__c];
        
        for (AggregateResult ar : aggresult )  {
            if(Integer.valueOf(ar.get('expr0')) > 1){
                isError = true;
                break;
            }
        }
        if(isError){
            tc.addError('Each teacher can only be associated with 2 Classes');
        }
    }
}