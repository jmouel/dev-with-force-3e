global class Listing9_4
  implements Database.Batchable<SObject>, Database.Stateful {
  Integer count = 0;
  global Database.QueryLocator start(Database.BatchableContext context) {
    System.debug('start: ' + count);
    return Database.getQueryLocator(
      [SELECT Name FROM Project__c ORDER BY Name]);
  }
  global void execute(Database.BatchableContext context,
    List<SObject> scope) {
    System.debug('execute: ' + count);
    for(SObject rec : scope) {
      Project__c p = (Project__c)rec;
      System.debug('Project ' + count + ': ' + p.Name);
      count++;
    }
  }
  global void finish(Database.BatchableContext context) {
    System.debug('finish: ' + count);
  }
}