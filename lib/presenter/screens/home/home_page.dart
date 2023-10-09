import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/local/services/hive.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/friends/friends_page.dart';
import 'package:sportper/presenter/screens/game/join/join_page.dart';
import 'package:sportper/presenter/screens/game/mygame/my_game_page.dart';
import 'package:sportper/presenter/screens/game/newgame/new_game_page.dart';
import 'package:sportper/presenter/screens/new_notification/notification_page.dart';
import 'package:sportper/presenter/screens/notification/friend/notification_friend_page.dart';
import 'package:sportper/presenter/screens/post/content/content_page.dart';
import 'package:sportper/presenter/screens/post/feed/feed_page.dart';
import 'package:sportper/presenter/screens/shared/notification_service.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';

import '../../models/home_tab_enum.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'widgets/badge_notification.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc(RepositoryProvider.of(context)),
      child: HomeWidget(),
    );
  }
}

class HomeWidget extends StatefulWidget {
  const HomeWidget({Key? key}) : super(key: key);

  @override
  State<HomeWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomeWidget> {
  HomeTab _tabSelected = HomeTab.feed;
  StreamSubscription<RxBusServiceObject>? _subscription;
  StreamSubscription? streamSubscriptionForeground;
  StreamSubscription? streamSubscriptionBackground;

  //trick
  bool isOpeningChat = false;

  ValueNotifier<bool> _valueNotifier = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _listenerBus();
    BlocProvider.of<HomeBloc>(context).add(HomeEventScheduleGameNotification());
    _listenFcmNotification();
    // fcm
    _valueNotifier.value = HiveService.instance.hasBadge;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _getWidgetBySelectedIndex(),
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
          builder: (context, value, child) =>
              _getTabBar(notificationBadge: value),
          valueListenable: _valueNotifier),
    );
  }

  Widget _getWidgetBySelectedIndex() {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: _initWidgetBySelectedIndex(),
    );
  }

  Widget _initWidgetBySelectedIndex() {
    switch (_tabSelected) {
      case HomeTab.join:
        return JoinPage();
      case HomeTab.friends:
        return FriendsPage();
      case HomeTab.myGames:
        return MyGamePage();
      case HomeTab.notification:
        return NotificationPage();
      case HomeTab.content:
        return ContentPage();
      case HomeTab.feed:
        return FeedPage();
    }
  }

  BottomNavigationBar _getTabBar({bool notificationBadge = false}) {
    return BottomNavigationBar(
      showUnselectedLabels: true,
      showSelectedLabels: true,
      items: [
        _createBottomBar(Strings.feed, ImagePaths.tabFeed, 24),
        _createBottomBar(Strings.content, ImagePaths.tabContent, 24),
        _createBottomBar(Strings.join, ImagePaths.tabJoin, 24),
        _createBottomBar(Strings.friends, ImagePaths.tabFriend, 24),
        _createBottomBar(Strings.myGames, ImagePaths.tabMyGame, 24),
        _createBottomBar(Strings.alert, ImagePaths.tabNotification, 24, hasBadge: notificationBadge),
      ],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      currentIndex: _tabSelected.rawValue,
      selectedItemColor: Theme.of(context).primaryColor,
      onTap: (index) {
        setState(() {
          if (index == HomeTab.notification.rawValue) {
            _removeNotification();
          }
          _tabSelected = HomeTabExt.initRawValue(index);
        });
      },
      unselectedFontSize: 11,
      selectedFontSize: 13,
    );
  }

  BottomNavigationBarItem _createBottomBar(
    String itemTooltip,
    String image,
    double iconSize, {
    bool hasBadge = false,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          ImageIcon(
            AssetImage(image),
            size: iconSize,
          ),
          // Image.asset(
          //   image,
          //   width: iconSize,
          //   height: iconSize,
          // ),
          if (hasBadge)
            Positioned(
                right: -5,
                top: -5,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle
                  ),
                ))
          // if (badgeCount > 0)
          //   Positioned(
          //     right: -7,
          //     top: -7,
          //     child: BadgeNotification(
          //       count: badgeCount,
          //       fontSize: getProportionateScreenWidth(33),
          //       size: getProportionateScreenWidth(55),
          //     ),
          //   ),
        ],
      ),
      label: itemTooltip,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    streamSubscriptionForeground?.cancel();
    streamSubscriptionBackground?.cancel();
    super.dispose();
  }

  void _listenerBus() {
    _subscription = RxBusService().listen((event) {
      switch (event.name) {
        case RxBusName.HOME_SCREEN_CHANGE_TAB:
          var newTab = event.value as HomeTab;
          if (newTab != _tabSelected) {
            _tabSelected = newTab;
            setState(() {});
          }
          break;
        case RxBusName.HANDLE_FCM_NOTIFICATION:
          Map<String, dynamic> data = event.value as Map<String, dynamic>;
          _handleNavigationFcm(data);
          break;
        case RxBusName.OPENING_CHAT:
          isOpeningChat = event.value as bool;
          break;
        default:
          break;
      }
    });
  }

  void _listenFcmNotification() async {
    streamSubscriptionForeground =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message);
      if (!isOpeningChat) {
        _setNotification();
        NotificationService.instance.show(
            message.notification?.title ?? 'Sportper',
            message.notification?.body ?? 'You have a new message',
            message.data);
      }
    });
    // handle background
    streamSubscriptionBackground =
        FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print(message.data);
      _setNotification();
      _handleNavigationFcm(message.data, isForeground: false);
    });

    // handle terminate
    RemoteMessage? message =
        await FirebaseMessaging.instance.getInitialMessage();
    if (message != null) {
      _setNotification();
      _handleNavigationFcm(message.data, isForeground: false);
    }
  }

  _handleNavigationFcm(Map<String, dynamic> data, {isForeground = true}) {
    if (isForeground) {
      Navigator.popUntil(context, ModalRoute.withName(Routes.home));
    }
    String? type = data[NotificationParamsConst.TYPE];
    String? gameId = data[NotificationParamsConst.GAME_ID];
    switch (type) {
      case NotificationTypeConst.FRIEND_NOTIFICATION:
        RxBusService().add(
          RxBusName.HOME_SCREEN_CHANGE_TAB,
          value: HomeTab.notification,
        );
        break;
      case NotificationTypeConst.CHAT_NOTIFICATION:
        RxBusService().add(
          RxBusName.HOME_SCREEN_CHANGE_TAB,
          value: HomeTab.notification,
        );
        if (gameId?.isNotEmpty == true) {
          Navigator.pushNamed(context, Routes.gameDetail, arguments: gameId);
        }
        break;
      case NotificationTypeConst.GAME_NOTIFICATION:
        RxBusService().add(
          RxBusName.HOME_SCREEN_CHANGE_TAB,
          value: HomeTab.notification,
        );
        if (gameId?.isNotEmpty == true) {
          Navigator.pushNamed(context, Routes.gameDetail, arguments: gameId);
        }
        break;
      case NotificationTypeConst.GAME_INVITATION:
        RxBusService().add(
          RxBusName.HOME_SCREEN_CHANGE_TAB,
          value: HomeTab.notification,
        );
        if (gameId?.isNotEmpty == true) {
          Navigator.pushNamed(context, Routes.gameDetail, arguments: gameId);
        }
        break;
      case NotificationTypeConst.GAME_REMOVED:
        RxBusService().add(
          RxBusName.HOME_SCREEN_CHANGE_TAB,
          value: HomeTab.notification,
        );
        break;
    }
  }

  _setNotification() {
    _valueNotifier.value = true;
    HiveService.instance.saveHasBadge(true);
  }


  _removeNotification() {
    _valueNotifier.value = false;
    HiveService.instance.saveHasBadge(false);
  }
}
