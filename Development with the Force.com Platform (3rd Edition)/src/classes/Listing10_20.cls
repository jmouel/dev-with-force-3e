global class Listing10_20 {
  webservice static ID createProject(String name) {
    Project__c proj = new Project__c(Name = name);
    insert proj;
    return proj.Id;
  }
}