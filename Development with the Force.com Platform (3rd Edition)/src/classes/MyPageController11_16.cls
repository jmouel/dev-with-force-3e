public class MyPageController11_16 {
  public String editBody { get; set; }
  public String editClassId { get; set; }
  public String containerId { get; set; }
  public String requestId { get; set; }
  public String log { get; set; }
  public List<ApexClass> getClasses() {
    return [ SELECT Id, Name, IsValid FROM ApexClass
      ORDER BY Name ];
  }
  public PageReference edit() {
    editBody = [ SELECT Body FROM ApexClass
      WHERE Id = :editClassId LIMIT 1 ][0].Body;
    return null;
  }
  public PageReference save() {
    log = '';
    // Create MetadataContainer
    HttpRequest req = newRequest('/sobjects/MetadataContainer',
      'POST');
    Map<String, Object> args = new Map<String, Object>();
    args.put('Name', 'ClassContainer');
    String result = sendRequest(req, args);
    containerId = null;
    try {
      containerId = getResultId(result);
    } catch (Exception e) {
      log += result;
      return null;
    }
    // Create ApexClassMember
    req = newRequest('/sobjects/ApexClassMember',
      'POST');
    args = new Map<String, Object>();
    args.put('ContentEntityId', editClassId);
    args.put('Body', editBody);
    args.put('MetadataContainerId', containerId);
    log += sendRequest(req, args);
    // Create ContainerAsyncRequest
    req = newRequest('/sobjects/ContainerAsyncRequest', 'POST');
    args = new Map<String, Object>();
    args.put('IsCheckOnly', 'false');
    args.put('MetadataContainerId', containerId);
    result = sendRequest(req, args);
    log += result;
    requestId = getResultId(result);
    return null;
  }
  public PageReference reset() {
    cleanup(containerId);
    editClassId = '';
    requestId = '';
    containerId = '';
    log = '';
    editBody = '';
    return null;
  }
  public PageReference refresh() {
    String soql = 'SELECT Id, State, CompilerErrors, ErrorMsg FROM ' +
      'ContainerAsyncRequest where id = \'' + requestId + '\'';
    HttpRequest req = newRequest('/query/?q=' + 
      EncodingUtil.urlEncode(soql, 'UTF-8'),
      'GET');
    log = sendRequest(req, null);
    return null;
  }
  public static void cleanup(String containerId) {
    sendRequest(newRequest('/sobjects/MetadataContainer/' + containerId,
      'DELETE'), null);
  }
  private static HttpRequest newRequest(String toolingPath,
    String method) {
    HttpRequest req = new HttpRequest();
    req.setHeader('Authorization',
      'Bearer ' + UserInfo.getSessionID());
    req.setHeader('Content-Type', 'application/json');
    req.setHeader('X-PrettyPrint' , '1');
    req.setEndpoint(getInstanceUrl() +
      '/services/data/v28.0/tooling' + toolingPath);
    req.setMethod(method);
    return req;
  }
  private static String sendRequest(HttpRequest req,
    Map<String, Object> args) {
    Http h = new Http();
    if (args != null) {
      req.setBody(Json.serialize(args));
    }
    HttpResponse res = h.send(req);
    return res.getBody();
  }
  private static String getInstanceUrl() {
    String url = System.URL.getSalesforceBaseUrl()
      .toExternalForm();
    url = url.replace('visual.force', 'salesforce');
    url = url.replace('c.', '');
    return url;
  }
  private static Id getResultId(String body) {
    Map<String, Object> result = (Map<String, Object>)
      JSON.deserializeUntyped(body);
    return (Id)result.get('id');
  }
}