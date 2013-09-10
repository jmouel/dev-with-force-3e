public class MyPageController7_18 {
  public SObject record { get; set; }
  public String selectedObject { get; set; }
  public List<SelectOption> getAvailableObjects() {
    List<SelectOption> options = new List<SelectOption>();
    options.add(new SelectOption('Project__c', 'Project'));
    options.add(new SelectOption('Timecard__c', 'Timecard'));
    options.add(new SelectOption('Contact', 'Contact'));
    return options;
  }
  public PageReference refresh() {
    Schema.SObjectType targetType =
      Schema.getGlobalDescribe().get(selectedObject);
    Map<String, Schema.SobjectField> fields = 
      targetType.getDescribe().fields.getMap();
    List<String> queryFields = new List<String>();
    for (String s : fields.keySet()) {
        if (fields.get(s).getDescribe().isAccessible()) { 
          queryFields.add(s);
        }
    }
    String soql = 'SELECT ';
    for (String s : queryFields) {
      soql += s + ', ';
    }
    soql = soql.substring(0, soql.length() - 2);
    soql += ' FROM ' + selectedObject;
    soql += ' ORDER BY LastModifiedDate DESC LIMIT 1';
    try {
      record = Database.query(soql);
    } catch (QueryException e) {}
  	return null;
  }	
  public Component.Apex.Detail getComponent() {
  	Component.Apex.Detail result =
  	  new Component.Apex.Detail();
  	result.expressions.subject = '{!record.Id}';
  	result.title = false;
  	result.relatedList = false;
  	return result;
  }
}