trigger CreateObjectA on Opportunity (before update, after insert) {
    if(trigger.isInsert || trigger.IsUpdate){
        List<ObjectA__c> inserList = new List<ObjectA__c>();
        for(Opportunity opp : trigger.new){
            ObjectA__c obj = new ObjectA__c();
            obj.Opp_Name__c = opp.Name;
            obj.Opp_Probability__c = opp.Probability;
            obj.Opp_Stage__c = opp.StageName;
            obj.Is_Opp_Private__c = opp.IsPrivate;
            obj.Opp_Ammount__c = opp.Amount;
            obj.Opportunity__c = opp.Id;
            inserList.add(obj);
        }
        
        if(inserList.size() > 0){
            try{
                insert inserList ;
            }Catch(Exception e){}
        }       
    }
}