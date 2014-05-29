public class SearchController{
    List<Opportunity> rec;
    public String searchString{get;set;}
    public SearchController(){
        rec = new List<Opportunity>();
        rec = [Select Id, Name From Opportunity];
         
    }
    
    public List<Opportunity> getRecords(){
        return rec;
    }    
    public PageReference searchRecords(){
        if(searchString != '' && searchString != null){
        String qry ='Find \'' + searchString + '*\' IN ALL Fields Returning Opportunity(Id, Name)';
        List<List<Opportunity>> records = Search.query(qry);
        rec = (List<Opportunity>) records[0];
        
        System.debug(rec);
        }
        return null;
    }
}