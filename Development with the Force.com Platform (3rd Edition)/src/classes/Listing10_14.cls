@RestResource(urlMapping='/Listing10_14/*')
global with sharing class Listing10_14 {
  @HttpGet
  global static Project__c doGet() {
    RestRequest req = RestContext.request;
    String projectId = req.requestURI.substring(
      req.requestURI.lastIndexOf('/')+1);
    Project__c result = [SELECT Id, Name, Status__c, Owner.Name
      FROM Project__c WHERE Id = :projectId];
    return result;
  }
}