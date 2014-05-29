public with sharing class MultiselectExampleController {

    public SelectOption[] selectedPicklistValues { get; set; }
    public SelectOption[] availablePicklistValues { get; set; }
    public Contact contacts {get;set;}
    public String message { get; set; }
    public Sobject dynamicRecord {get;set;}

    public MultiselectExampleController() {
        String id = ApexPages.CurrentPage().getParameters().get('Id');
        String objectName = ApexPages.CurrentPage().getParameters().get('objectAPIName');
        String multiPickFieldName = ApexPages.CurrentPage().getParameters().get('multiPickListFieldAPIName');
        
        if(id != null && id != '' && objectName != null && objectName != '' && multiPickFieldName != null && multiPickFieldName != ''){
            String soql = 'Select Id,' + multiPickFieldName + ' From ' +objectName + ' Where Id = \''+id +'\'';
            try{
                dynamicRecord = Database.query(soql); // dynamic SOQL to get the avail and selected pick list values.
            
                String pickValStr = String.valueOf(dynamicRecord.get(multiPickFieldName)); // fetch multi pick list value
                List<String> pickValList = new List<String>();
                if(pickValStr != null && pickValStr != ''){
                    pickValList = pickValStr.split(';'); // get the individual values in list
                }
                
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
}