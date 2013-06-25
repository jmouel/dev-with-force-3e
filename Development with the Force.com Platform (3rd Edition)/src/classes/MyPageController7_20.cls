public with sharing class MyPageController7_20 {
  @RemoteAction
  public static List<Project__c> load() {
    return [SELECT Name, Location__c, CreatedDate
      FROM Project__c ];
  }
}