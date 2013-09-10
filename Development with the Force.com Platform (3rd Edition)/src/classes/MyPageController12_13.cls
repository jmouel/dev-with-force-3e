public with sharing class MyPageController12_13 {
  public List<ConnectApi.FeedItem> getFeedItems() {
    return ConnectApi.ChatterFeeds.getFeedItemsFromFeed(null,
      ConnectApi.FeedType.Record, 'me').items;
  }
}