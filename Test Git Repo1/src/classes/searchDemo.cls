public class searchDemo{
    public string searchTxt{get;set;}
    List<List<Sobject>> record;
    public List<Sobject> records {get;set;}
    public searchDemo(){
    
    }
    
    public PageReference search(){
        String qry = 'Find \''+searchTxt+'*\' IN Name Returning Account(Id,Name)';
        record = Search.query(qry);
        records = (List<Account>)record[0];
        return null;
    }
    
    public List<Account> getrecords(){
        return records ;
    }
}