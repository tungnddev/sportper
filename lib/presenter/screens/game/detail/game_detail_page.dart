import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';

import 'chat/game_detail_chat_page.dart';
import 'detailoverview/game_detail_overview_page.dart';
import 'package:sportper/domain/entities/notification.dart' as N;

enum GameDetailTab {
  chat, overview
}

class GameDetailPage extends StatefulWidget {

  final String gameId;
  final N.Notification? notification;

  const GameDetailPage({Key? key, required this.gameId, this.notification}) : super(key: key);

  @override
  _GameDetailPageState createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {

  GameDetailTab currentTab = GameDetailTab.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SportperAppBar(title: Strings.gameDetail,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SportperTabBar<GameDetailTab>(listTabs: [
                  Pair(Strings.overview, GameDetailTab.overview),
                  Pair(Strings.chat, GameDetailTab.chat),
                ], onChange: (GameDetailTab tab) {
                  setState(() {
                    currentTab = tab;
                  });
                },
                ),
              ),
              SizedBox(height: 16,),
              Expanded(child: _getMainView())
            ],
          ),
        ),
      ),
    );
  }

  Widget _getMainView() {
    switch (currentTab) {
      case GameDetailTab.chat:
        return GameDetailChatPage(gameId: widget.gameId,);
      case GameDetailTab.overview:
        return GameDetailOverviewPage(gameID: widget.gameId, notification: widget.notification,);
    }
  }
}
