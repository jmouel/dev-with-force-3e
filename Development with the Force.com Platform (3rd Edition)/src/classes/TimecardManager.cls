public with sharing class TimecardManager {
  public class TimecardException extends Exception {}
  public static void handleTimecardChange(List<Timecard__c> oldTimecards,
    List<Timecard__c> newTimecards) {
    Set<ID> contactIds = new Set<ID>();
    for (Timecard__c timecard : newTimecards) {
      contactIds.add(timecard.Contact__c);
    }
    List<Assignment__c> assignments = [ select Id, Start_Date__c,
      End_Date__c, Contact__c from Assignment__c
      where Contact__c in :contactIds ];
    if (assignments.size() == 0) {
      throw new TimecardException('No assignments');
    }
    Boolean hasAssignment;
    for (Timecard__c timecard : newTimecards) {
      hasAssignment = false;
      for (Assignment__c assignment : assignments) {
        if (assignment.Contact__c == timecard.Contact__c &&
          timecard.Week_Ending__c - 6 >= assignment.Start_Date__c &&
          timecard.Week_Ending__c <= assignment.End_Date__c) {
            hasAssignment = true;
            break;
        }
      }
      if (!hasAssignment) {
        timecard.addError('No assignment for contact ' + 
          timecard.Contact__c + ', week ending ' + 
          timecard.Week_Ending__c);
      }
    }
  }
}