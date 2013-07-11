global class Listing9_1 implements Database.Batchable<SObject> {
  global Database.QueryLocator start(Database.BatchableContext context) {
    System.debug('start');
    return Database.getQueryLocator(
      [SELECT Name FROM Project__c ORDER BY Name]);
  }
  global void execute(Database.BatchableContext context,
    List<SObject> scope) {
    System.debug('execute');
    for(SObject rec : scope) {
      Project__c p = (Project__c)rec;
      System.debug('Project: ' + p.Name);
    }
  }
  global void finish(Database.BatchableContext context) {
    System.debug('finish');
  }
}