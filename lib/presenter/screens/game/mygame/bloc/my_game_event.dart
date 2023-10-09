import '../my_game_page.dart';

class MyGameEvent {

}

class MyGameFetch extends MyGameEvent {
  MyGameFetch();
}

// class MyGameRefresh extends MyGameEvent {
//   MyGameRefresh();
// }

class MyGameLoadMore extends MyGameEvent {
  MyGameLoadMore();
}

class MyGameChangeFavourite extends MyGameEvent {
  String id;
  MyGameChangeFavourite(this.id);
}

class MyGameChangeFavouriteFromDetail extends MyGameEvent {
  String id;
  bool value;
  MyGameChangeFavouriteFromDetail(this.id, this.value);
}