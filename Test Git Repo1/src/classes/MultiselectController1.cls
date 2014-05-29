/*
 * MultiselectController synchronizes the values of the hidden elements to the
 * SelectOption lists.
 */
public with sharing class MultiselectController1 {
    public SelectOption[] selectedPicklistValues { get; set; }
    public SelectOption[] availablePicklistValues { get; set; }
    public Contact contacts {get;set;}
    public String message { get; set; }
    public Sobject dynamicRecord {get;set;}
    public String objectName {get;set;}
    public String multiPickFieldName {get;set;}
    public String picklist;
    String id;
    public MultiselectController1 () {
        id = ApexPages.CurrentPage().getParameters().get('Id');
        //objectName = ApexPages.CurrentPage().getParameters().get('objectAPIName');
        //multiPickFieldName = ApexPages.CurrentPage().getParameters().get('multiPickListFieldAPIName');
        system.debug('id >>'+id );
        //init();
    }
    
    public String getPicklist(){
        system.debug('objectName >>'+objectName );system.debug('multiPickFieldName >>'+multiPickFieldName );
        if(id != null && id != '' && objectName != null && objectName != '' && multiPickFieldName != null && multiPickFieldName != ''){
            String soql = 'Select Id,' + multiPickFieldName + ' From ' +objectName + ' Where Id = \''+id +'\'';
            system.debug('soql >>'+soql );
            try{
            dynamicRecord = Database.query(soql); // dynamic SOQL to get the avail and selected pick list values.
            system.debug('dynamicRecord >>'+dynamicRecord );
            String pickValStr = String.valueOf(dynamicRecord.get(multiPickFieldName)); // fetch multi pick list value
            List<String> pickValList = pickValStr.split(';'); // get the individual values in list
            
            /* Below code is used to fetch all the pick list entries for the sobject*/
            Map<String, Schema.SObjectType> gdMap = Schema.getGlobalDescribe();
            Schema.Describesobjectresult dsr = gdMap.get(ObjectName).getDescribe();
            Map<String, Schema.SObjectField> fieldMap = dsr.fields.getMap();
            Schema.DescribeFieldResult fieldResult = fieldMap.get(multiPickFieldName).getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
            
            selectedPicklistValues = new List<SelectOption>();
            availablePicklistValues = new List<SelectOption>();
        
            for(Schema.PicklistEntry f : ple)
            {
                if(isPickListValueSelected(pickValList , f.getValue())){ // If the pick list entry is in selected list
                    selectedPicklistValues.add(new SelectOption(f.getLabel(), f.getValue()));
                }else{
                   availablePicklistValues.add(new SelectOption(f.getLabel(), f.getValue()));    
                }
            }    
            }catch(Exception e){
                system.debug(e.getMessage());
            }
           
        }
         return '';
    }
    private Boolean isPickListValueSelected(List<String> tempList, String val){
        for(String t : tempList){
            if(t.equals(val)){
                return true;
            }
        }
        return false;
    }
    

    public PageReference save() {
        message = 'Selected ';
        Boolean first = true;
        for ( SelectOption so : selectedPicklistValues ) {
            if (!first) {
                message += ', ';
            }
            message += so.getLabel() + ' (' + so.getValue() + ')';
            first = false;
        }
        
        return null;
    }
    // SelectOption lists for public consumption
   // public SelectOption[] leftOptions { get; set; }
    //public SelectOption[] rightOptions { get; set; }
    
    // Parse &-separated values and labels from value and
    // put them in option
    private void setOptions(SelectOption[] options, String value) {
        options.clear();
        String[] parts = value.split('&');
        for (Integer i=0; i<parts.size()/2; i++) {
            options.add(new SelectOption(EncodingUtil.urlDecode(parts[i*2], 'UTF-8'),
              EncodingUtil.urlDecode(parts[(i*2)+1], 'UTF-8')));
        }
    }
    
    // Backing for hidden text field containing the options from the
    // left list
    public String leftOptionsHidden { get; set {
           leftOptionsHidden = value;
           setOptions(availablePicklistValues, value);
        }
    }
    
    // Backing for hidden text field containing the options from the
    // right list
    public String rightOptionsHidden { get; set {
           rightOptionsHidden = value;
           setOptions(selectedPicklistValues, value);
        }
    }
}