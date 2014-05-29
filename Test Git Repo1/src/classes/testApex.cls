public class testApex{
public Integer count {get;set;}
public Integer count1 {get;set;}
    public testApex(){count =0;count1=0;}
    public Component.Apex.OutputText getOutText(){
        Component.Apex.OutputText o = new Component.Apex.OutputText();
        o.value = 'Hello';
        
        return o;
    } 

    public String selectedvalue{get;set;}
    public SelectOption getTest(){
        return new SelectOption('D', 'D');
    }    
    public List<SelectOption> getAvailableValues(){
        List<SelectOption> avail = new List<SelectOption>();
        avail.add(new SelectOption('A', 'A1'));
        avail.add(new SelectOption('B', 'B1'));
        avail.add(new SelectOption('C', 'C1'));
        
        return avail;
    }
    
     
    public PageReference incrementCounter() {
        count++;
        return null;
    }
    public PageReference incrementCounter1() {
        count1++;
        return null;
    }                    
   
}