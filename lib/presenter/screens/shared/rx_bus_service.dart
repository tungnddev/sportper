import 'dart:async';
import 'package:flutter/cupertino.dart';

class RxBusName {
  static const HOME_SCREEN_CHANGE_TAB = 'HOME_SCREEN_CHANGE_TAB';
  static const NEW_NOTIFICATION = 'NEW_NOTIFICATION';
  static const NEED_TO_RELOAD_NOTIFICATION = 'NEED_TO_RELOAD_NOTIFICATION';
  static const CHANGE_FAVOURITE = 'CHANGE_FAVOURITE';
  static const HANDLE_FCM_NOTIFICATION = 'HANDLE_FCM_NOTIFICATION';
  static const OPENING_CHAT = 'OPENING_CHAT';
  static const REFRESH_FEED = 'REFRESH_FEED';
  static const CHANGE_LIKE_POST = 'CHANGE_LIKE_POST';
  static const CHANGE_NUM_LIKE_POST = 'CHANGE_NUM_LIKE_POST';
  static const CHANGE_NUM_COMMENT_POST = 'CHANGE_NUM_COMMENT_POST';
}

class RxBusService {
  static final RxBusService _shared = RxBusService._internal();

  RxBusService._internal();

  factory RxBusService() {
    return _shared;
  }

  final StreamController<RxBusServiceObject> _controller =
      StreamController<RxBusServiceObject>.broadcast();

  void add(String name, {dynamic value}) {
    _controller.add(
      RxBusServiceObject(
        name: name,
        value: value,
      ),
    );
  }

  StreamSubscription<RxBusServiceObject> listen(
      void Function(RxBusServiceObject) event) {
    return _controller.stream.listen(event);
  }
}

class RxBusServiceObject {
  final String name;
  final dynamic value;

  RxBusServiceObject({
    required this.name,
    required this.value,
  });
}
