class FeedEvent {

}

class FeedFetch extends FeedEvent {
  FeedFetch();
}

class FeedLoadMore extends FeedEvent {
  FeedLoadMore();
}

class FeedChangeFavourite extends FeedEvent {
  String id;
  FeedChangeFavourite(this.id);
}

class FeedChangeFavouriteFromDetail extends FeedEvent {
  String id;
  bool value;
  FeedChangeFavouriteFromDetail(this.id, this.value);
}

class FeedChangeNumLikeFromDetail extends FeedEvent {
  String id;
  int value;
  FeedChangeNumLikeFromDetail(this.id, this.value);
}

class FeedChangeNumCommentsFromDetail extends FeedEvent {
  String id;
  int value;
  FeedChangeNumCommentsFromDetail(this.id, this.value);
}