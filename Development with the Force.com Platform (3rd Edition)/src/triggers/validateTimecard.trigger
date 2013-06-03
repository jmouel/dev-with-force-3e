trigger validateTimecard on Timecard__c (before insert, before update) {
  TimecardManager.handleTimecardChange(Trigger.old, Trigger.new);
}