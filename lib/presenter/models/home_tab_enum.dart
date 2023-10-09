import 'package:flutter/cupertino.dart';

enum HomeTab { feed, content, join, friends, myGames, notification }

extension HomeTabExt on HomeTab {
  static HomeTab initRawValue(int rawValue) {
    switch (rawValue) {
      case 0:
        return HomeTab.feed;
      case 1:
        return HomeTab.content;
      case 2:
        return HomeTab.join;
      case 3:
        return HomeTab.friends;
      case 4:
        return HomeTab.myGames;
      case 5:
        return HomeTab.notification;
      default:
        return HomeTab.feed;
    }
  }

  int get rawValue {
    switch (this) {
      case HomeTab.feed:
        return 0;
      case HomeTab.content:
        return 1;
      case HomeTab.join:
        return 2;
      case HomeTab.friends:
        return 3;
      case HomeTab.myGames:
        return 4;
      case HomeTab.notification:
        return 5;
    }
  }
}
