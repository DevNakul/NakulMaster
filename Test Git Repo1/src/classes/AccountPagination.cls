public with sharing class AccountPagination {
    private final Account acct;  
    String queryString {get;set;}
    // The constructor passes in the standard controller defined
    // in the markup below
    public AccountPagination(ApexPages.StandardSetController controller) {
        init();
        
        this.acct = (Account)controller.getRecord(); 
    }    
    
    public ApexPages.StandardSetController accountRecords {
        get {
            if(accountRecords == null) { 
                queryString = populateRecords();
                accountRecords = new ApexPages.StandardSetController(
                    Database.getQueryLocator(queryString ));
                    //Database.getQueryLocator([SELECT Name FROM Account WHERE Id NOT IN 
                     //   (SELECT AccountId FROM Opportunity WHERE IsClosed = true)]));
            }
            return accountRecords;
        }
        private set;
    }
    public List<Sobject> getAccountPagination() {
        if(lst != null && lst.size() > 0){
            return lst;
        }else
         return (List<Sobject>) accountRecords.getRecords();
    }  
    
    public String searchString{get;set;}
    String ObjectName{get;set;}
    String FieldSetName {get;set;}
    String[] fields = new String[]{};
    public List<SelectOption> soList{get;set;}
    public List<Schema.FieldSetMember> dynamicFields {get;set;} 
    public List<String> fieldsLabel {get;set;}
    public List<String> fieldAPIName {get;set;}
    private transient Schema.Describesobjectresult dsr;
    public List<Sobject> lst{get;set;}
    
    //public ListViewClass(){
     //   init();
        //wrapList = new List<RecordListWrapper>();
     //   populateRecords();
   // }
    
    private void init(){
        ObjectName = 'nakultest__'+ApexPages.currentPage().getParameters().get('object');
        FieldSetName = 'nakultest__'+ApexPages.currentPage().getParameters().get('fldSet');
        system.debug('ObjectName >>>'+ObjectName );
        system.debug('FieldSetName >>>'+FieldSetName );
        Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
        dsr = gdMap.get(ObjectName).getDescribe();
        Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
        
        system.debug('fieldMap  >>>'+fieldMap );
        soList = new List<SelectOption>();
        for(String key : fieldMap.keySet()) {
          soList.add(new SelectOption(key, key.replace('__c', '').replace('_', ' ')));
        }
        
        Map<String, Schema.FieldSet> objectFSMap = dsr.fieldSets.getMap();
        system.debug('objectFSMap >>>'+objectFSMap );
        dynamicFields = objectFSMap.get(FieldSetName).getFields();
        system.debug('dynamicFields >>>'+dynamicFields );
        fieldsLabel = new List<String>();
        fieldAPIName = new List<String>();
        for(Schema.FieldSetMember fld : dynamicFields ){
            fieldsLabel.add(fld.getLabel());
            fieldAPIName.add(fld.getFieldPath());
        }
    }
    
    public String[] getfields () {
        return fields ;
    }
        
    public void setfields (String[] fields ) {
        this.fields = fields ;
    }
    
    //public List<RecordListWrapper> wrapList{get;set;}
    
    private String populateRecords(){
        String qry = 'Select ';
        for(String fld : fieldAPIName){
            qry = qry + fld + ',';
        }
        qry = qry.substring(0,qry.length()-1);
        system.debug('dsr.Name -- '+dsr.Name);
        qry = qry + ' From ' + dsr.Name;
        system.debug('SOQL -- '+qry);
        //lst = Database.query(qry);
        system.debug('lst -- '+lst);
        //for(Sobject s : lst){
        //    RecordListWrapper wrap = new RecordListWrapper(s,fieldAPIName);
        //    wrapList.add(wrap);
       // }
        //system.debug('wrapList -- '+wrapList);
        
        return qry;
    }
    
    public PageReference searchRecords(){
        if(searchString != '' && searchString != null){
            init();
            String fields = '';
            system.debug('searchString -- '+searchString);
            system.debug('dsr.Name -- '+dsr.Name);
            for(String fld : fieldAPIName){
                fields = fields + fld + ',';
            }
            system.debug('fields -- '+fields);
            fields = fields.substring(0,fields.length()-1);
            String qry ='Find \'' + searchString + '*\' IN ';
            system.debug('******  -- ');
            //qry = qry + fields + ' Returning ' + dsr.Name + '(' + fields + ')';
            qry = qry + ' All Fields Returning ' + dsr.Name + '(' + fields + ')';
            System.debug('SOSL -- '+qry);
            List<List<Sobject>> records = Search.query(qry);
            lst = (List<Sobject>) records[0];
            
            System.debug(lst);
        }
        PageReference page = new PageReference ('/apex/ListPage?object='+ObjectName+'&FieldSet='+FieldSetName);
        return page;
    }
  /*  
    public void reset(){
        init();
        wrapList = new List<RecordListWrapper>();
        populateRecords();
    }
    public class RecordListWrapper{
        public Sobject record{get;set;}
        public List<String> columns{get;set;}
        
        public RecordListWrapper(Sobject obj, List<String> cols){
            record = obj;
            columns = cols;
        }
    }*/
}