global class Listing9_6
  implements Database.Batchable<Project__c> {
  global Iterable<Project__c> start(Database.BatchableContext context) {
    System.debug('start');
    return new ProjectIterable();
  }
  global void execute(Database.BatchableContext context,
    List<Project__c> scope) {
    System.debug('execute');
    for(Project__c rec : scope) {
      System.debug('Project: ' + rec.Name);
    }
  }
  global void finish(Database.BatchableContext context) {
    System.debug('finish');
  }
}