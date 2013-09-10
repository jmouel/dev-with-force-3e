@IsTest(SeeAllData=true)
public with sharing class Listing9_7 {
  public static testmethod void testBatch() {
    Test.startTest();
    Listing9_1 batch = new Listing9_1();
    ID jobId = Database.executeBatch(batch);
    Test.stopTest();
  }
}