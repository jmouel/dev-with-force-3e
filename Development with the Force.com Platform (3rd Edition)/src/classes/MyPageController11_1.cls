public with sharing class MyPageController11_1 {
  public Boolean started { get; set; }
  private static final String TOPIC_NAME = 'TimecardUpdates';
  public MyPageController11_1() {
    started = 1 == [ SELECT count() FROM PushTopic
      WHERE Name = :TOPIC_NAME ];
  }
  public PageReference stop() {
    PushTopic p = [ SELECT Id from PushTopic
      WHERE Name = :TOPIC_NAME LIMIT 1];
    if (p != null) {
      delete p;
    }
    started = false;
    return null;
  }
  public PageReference start() {
    PushTopic p = new PushTopic();
    p.Name = TOPIC_NAME;
    p.Query = 'SELECT Id, Name, Status__c FROM Timecard__c';
    p.ApiVersion = 28.0;
    p.NotifyForOperations = 'All';
    p.NotifyForFields = 'Referenced';
    insert p;
    started = true;
    return null;
  }
}