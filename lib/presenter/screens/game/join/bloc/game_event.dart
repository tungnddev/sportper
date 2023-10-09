class JoinEvent {

}

class JoinFetch extends JoinEvent {
  final String keyword;
  JoinFetch({required this.keyword});
}

class JoinRefresh extends JoinEvent {
  JoinRefresh();
}

class JoinLoadMore extends JoinEvent {
  JoinLoadMore();
}

class JoinChangeFavourite extends JoinEvent {
  String id;
  JoinChangeFavourite(this.id);
}

class JoinChangeFavouriteFromDetail extends JoinEvent {
  String id;
  bool value;
  JoinChangeFavouriteFromDetail(this.id, this.value);
}