import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/presenter/screens/friends/buddies/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/game_with/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/dialog_add_friend.dart';
import 'package:sportper/presenter/screens/notification/friend/notification_friend_page.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'chat/notification_chat_page.dart';
import 'game/notification_game_page.dart';

enum NotificationTab { game, chat, friend }

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationPage> {
  NotificationTab currentTab = NotificationTab.game;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 20, left: 24, right: 20, bottom: 20),
              child: Text(
                Strings.alert,
                style: SportperStyle.boldStyle.copyWith(fontSize: 20),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SportperTabBar<NotificationTab>(
                listTabs: [
                  Pair(Strings.games, NotificationTab.game),
                  Pair(Strings.chats, NotificationTab.chat),
                  Pair(Strings.friends, NotificationTab.friend)
                ],
                onChange: (NotificationTab tab) {
                  setState(() {
                    currentTab = tab;
                  });
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Expanded(child: _getMainView())
          ],
        ),
      ),
    );
  }

  Widget _getMainView() {
    switch (currentTab) {
      case NotificationTab.friend:
        return NotificationFriendPage();
      case NotificationTab.chat:
        return NotificationChatPage();
      case NotificationTab.game:
        return NotificationGamePage();
    }
  }
}
