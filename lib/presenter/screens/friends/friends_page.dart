import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/presenter/screens/friends/buddies/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/game_with/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/bloc/dialog_add_friend_bloc.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/dialog_add_friend.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'buddies/bloc/event.dart';
import 'buddies/my_game_page.dart';
import 'game_with/friend_with_game_page.dart';

enum FriendsTab { buddies, gameWith }

class FriendsPage extends StatelessWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => GameWithBloc(
                RepositoryProvider.of(context),
              )),
      BlocProvider(
        create: (context) => BuddiesBloc(RepositoryProvider.of(context),
            RepositoryProvider.of(context), RepositoryProvider.of(context)),
      ),
    ], child: FriendsWidget());
  }
}

class FriendsWidget extends StatefulWidget {
  const FriendsWidget({Key? key}) : super(key: key);

  @override
  _FriendsWidgetState createState() => _FriendsWidgetState();
}

class _FriendsWidgetState extends State<FriendsWidget> {
  FriendsTab currentTab = FriendsTab.buddies;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 24, right: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      Strings.friends,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  currentTab == FriendsTab.buddies
                      ? GestureDetector(
                          onTap: () async {
                            final result = await showGeneralDialog(
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context)
                                  .modalBarrierDismissLabel,
                              context: context,
                              pageBuilder: (_, __, ___) => GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Material(
                                    color: Colors.transparent,
                                    // titlePadding: EdgeInsets.zero,
                                    // contentPadding: EdgeInsets.zero,
                                    // insetPadding: EdgeInsets.zero,
                                    child: GestureDetector(
                                        onTap: () {},
                                        child: DialogAddFriend())),
                              ),
                            );
                            if (result != null &&
                                result is Pair<String, String>) {
                              BlocProvider.of<BuddiesBloc>(context).add(
                                  BuddiesAddNewFriend(
                                      result.first, result.second));
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Image.asset(
                              ImagePaths.addFriend,
                              width: 24,
                              height: 24,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 56,
                          height: 56,
                        )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: SportperTabBar<FriendsTab>(
                listTabs: [
                  Pair(Strings.buddies, FriendsTab.buddies),
                  Pair(Strings.gameWith, FriendsTab.gameWith),
                ],
                onChange: (FriendsTab tab) {
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
      case FriendsTab.buddies:
        return BuddiesFriendWidget();
      case FriendsTab.gameWith:
        return GameWithWidget();
    }
  }
}
