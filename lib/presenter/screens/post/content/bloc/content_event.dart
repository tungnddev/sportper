class ContentEvent {

}

class ContentFetch extends ContentEvent {
  ContentFetch();
}

class ContentLoadMore extends ContentEvent {
  ContentLoadMore();
}

class ContentChangeFavourite extends ContentEvent {
  String id;
  ContentChangeFavourite(this.id);
}

class ContentChangeFavouriteFromDetail extends ContentEvent {
  String id;
  bool value;
  ContentChangeFavouriteFromDetail(this.id, this.value);
}

class ContentChangeNumLikeFromDetail extends ContentEvent {
  String id;
  int value;
  ContentChangeNumLikeFromDetail(this.id, this.value);
}

class ContentChangeNumCommentsFromDetail extends ContentEvent {
  String id;
  int value;
  ContentChangeNumCommentsFromDetail(this.id, this.value);
}