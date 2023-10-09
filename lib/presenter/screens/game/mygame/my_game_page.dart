import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/join/widgets/item_game.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:share_plus/share_plus.dart';

import 'bloc/my_game_bloc.dart';
import 'bloc/my_game_event.dart';
import 'bloc/my_game_state.dart';

enum MyGameTab { upcoming, previous, favourite }

class MyGamePage extends StatelessWidget {
  const MyGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => MyGameBloc(
              RepositoryProvider.of(context), RepositoryProvider.of(context))),
    ], child: MyGameWidget());
  }
}

class MyGameWidget extends StatefulWidget {
  const MyGameWidget({Key? key}) : super(key: key);

  @override
  _MyGameWidgetState createState() => _MyGameWidgetState();
}

class _MyGameWidgetState extends State<MyGameWidget> {
  late MyGameBloc bloc;
  StreamSubscription<RxBusServiceObject>? _subscription;


  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(MyGameFetch());
    _listenerNotification();
  }

  void _listenerNotification() {
    _subscription = RxBusService().listen((event) {
      switch (event.name) {
        case RxBusName.CHANGE_FAVOURITE:
          var data = event.value as Pair<String, bool>?;
          if (data != null) {
            bloc.add(MyGameChangeFavouriteFromDetail(data.first, data.second));
          }
          break;
        default:
          break;
      }
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
              padding: EdgeInsets.fromLTRB(24, 15, 24, 20),
              child: Text(
                Strings.myGames,
                style: SportperStyle.boldStyle.copyWith(fontSize: 22),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SportperTabBar<MyGameTab>(
              listTabs: [
                Pair(Strings.upcoming, MyGameTab.upcoming),
                Pair(Strings.previous, MyGameTab.previous),
                Pair(Strings.favourites, MyGameTab.favourite),
              ],
              onChange: (MyGameTab tab) {
                bloc.currentTab = tab;
                bloc.add(MyGameFetch());
              },
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(child: _getMainView())
        ],
      ),
    );
  }

  Widget _getMainView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: BlocConsumer<MyGameBloc, MyGameState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is MyGameFetchFailed) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is MyGameShowLoading) {
              LoadingDialog.show(context);
            } else if (state is MyGameHideLoading) {
              Navigator.pop(context);
            }
          },
          buildWhen: (pre, next) => next is MyGameLoading || next is MyGameFetchSuccessful || next is MyGameFetchEmpty,
          builder: (contextBuilder, state) {
            if (state is MyGameLoading) {
              return LoadingView();
            }
            if (state is MyGameFetchSuccessful) {
              return ListViewLoadMoreAndRefresh(
                onRefresh: () => bloc.add(MyGameFetch()),
                onLoadMore: () => bloc.add(MyGameLoadMore()),
                list: state.listMyGame,
                item: (contextList, index) {
                  return _buildItemListGame(state.listMyGame[index], onTap: () {
                    Navigator.pushNamed(context, Routes.gameDetail,
                        arguments: state.listMyGame[index]!.game.id);
                  });
                },
              );
            }
            if (state is MyGameFetchEmpty) {
              return EmptyView();
            }
            return Container();
          }),
    );
  }

  Widget _buildItemListGame(GameVM? gameVM, {Function()? onTap}) {
    if (gameVM == null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Theme.of(context).primaryColor,
              ),
              height: 23.0,
              width: 23.0,
            ),
          )
        ],
      );
    } else {
      return GameItemWidget(
        vm: gameVM,
        onTap: onTap,
        onTapFavourite: () {
          bloc.add(MyGameChangeFavourite(gameVM.game.id));
        },
        onTapShare: () {
          Share.share(gameVM.game.title);
        },
      );
    }
  }
}
