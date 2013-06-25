public class MyPageController7_16 {
  public List<String> fields { get; set; }
  public List<Project__c> records { get; set; }
  public MyPageController7_16() {
    fields = new String[] { 'Id', 'Name', 'CreatedDate' };
    records = [ SELECT Name, CreatedDate FROM Project__c ];  
  } 
}