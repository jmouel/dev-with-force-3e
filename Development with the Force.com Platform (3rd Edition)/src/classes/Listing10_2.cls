public class Listing10_2 {
  private static String APP_ID = 'B1tiUc7k';
  public static Result geocode(String location) {
    HttpRequest req = new HttpRequest();
    String query = 'select centroid from geo.places where text="'
      + location + '"';
    String url = 'http://query.yahooapis.com/v1/public/yql?appid='
      + APP_ID + '&q=' + EncodingUtil.urlEncode(query, 'UTF-8')
      + '&format=json';
    req.setEndpoint(url);
    req.setMethod('GET');
    Http http = new Http();
    HTTPResponse res = http.send(req);
    JSONParser parser = JSON.createParser(res.getBody());
    while (parser.nextToken() != null) {
      if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && 
        (parser.getText() == 'centroid')) {
          parser.nextToken();
          return (Result)parser.readValueAs(Result.class);
      }
    }
    return null;
  }
  public class Result {
    public String latitude;
    public String longitude;
    public String asString() {
      return latitude + ', ' + longitude;
    }
  }
}