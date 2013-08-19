public with sharing class MobileTimecardController {
  @RemoteAction
  public static List<Timecard__c> load() {
    Contact c = currentResource();
    if (c == null) {
      return null;
    }
    Date currentWeekEnding = 
      Date.today().toStartOfWeek().addDays(6);
    // Create a current week's timecard for each assignment
    for (Assignment__c a : [ SELECT Project__c
      FROM Assignment__c WHERE Contact__c = :c.Id 
      AND Status__c = 'Scheduled'
      AND Start_Date__c < :currentWeekEnding
      AND End_Date__c >= :currentWeekEnding
      ]) {
      if ([ SELECT Id FROM Timecard__c
        WHERE Contact__c = :c.Id
        AND Week_Ending__c = :currentWeekEnding
        AND Project__c = :a.Project__c
        LIMIT 1].size() == 0) {
      insert new Timecard__c(Project__c = a.Project__c,
        Week_Ending__c = currentWeekEnding,
        Contact__c = c.Id);
      }
    }
    List<Timecard__c> timecards = [ SELECT Project__r.Name,
      Week_Ending__c, Status__c,
      Monday_Hours__c, Tuesday_Hours__c, Wednesday_Hours__c,
      Thursday_Hours__c, Friday_Hours__c
      FROM Timecard__c
      WHERE Contact__c = :c.Id
      ORDER BY Week_Ending__c DESC
      LIMIT 5 ];
    return timecards;
  }
  private static Contact currentResource() {
    List<Contact> contacts =
      [ SELECT Id, Name FROM Contact
        WHERE User__c = :UserInfo.getUserId() ];
    if (contacts != null && contacts.size() == 1) {
      return contacts.get(0);
    }
    return null;
  }
  @RemoteAction
  public static void save(Timecard__c timecard) {
    update timecard;
  }
}