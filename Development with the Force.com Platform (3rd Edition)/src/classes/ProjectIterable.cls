global class ProjectIterable
  implements Iterator<Project__c>, Iterable<Project__c> {
  List<Project__c> projects { get; set; }
  Integer i;
  public ProjectIterable() { 
    projects = [SELECT Name FROM Project__c ORDER BY Name ];
    i = 0; 
  }
  global Boolean hasNext() {
    if (i >= projects.size()) {
      return false;
    } else {
      return true; 
    }
  } 
  global Project__c next() {
    i++;
    return projects[i-1]; 
  }
  global Iterator<Project__c> Iterator() {
    return this;
  }
}