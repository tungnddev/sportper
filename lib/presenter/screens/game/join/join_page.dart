import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/filter_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_bloc.dart';
import 'package:sportper/presenter/screens/game/join/bloc/game_bloc.dart';
import 'package:sportper/presenter/screens/game/join/bloc/game_event.dart';
import 'package:sportper/presenter/screens/game/join/bloc/game_state.dart';
import 'package:sportper/presenter/screens/game/newgame/coursebloc/course_event.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:share_plus/share_plus.dart';

import 'widgets/avatar_widget.dart';
import 'widgets/item_game.dart';
import 'widgets/join_search.dart';

class JoinPage extends StatelessWidget {
  const JoinPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => JoinBloc(
              RepositoryProvider.of(context), RepositoryProvider.of(context))),
      BlocProvider(
          create: (context) => AvatarBloc(RepositoryProvider.of(context)))
    ], child: JoinWidget());
  }
}

class JoinWidget extends StatefulWidget {
  const JoinWidget({Key? key}) : super(key: key);

  @override
  _JoinWidgetState createState() => _JoinWidgetState();
}

class _JoinWidgetState extends State<JoinWidget> {
  late JoinBloc bloc;
  StreamSubscription<RxBusServiceObject>? _subscription;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(JoinFetch(keyword: ""));
    _listenerNotification();
  }

  void _listenerNotification() {
    _subscription = RxBusService().listen((event) {
      switch (event.name) {
        case RxBusName.CHANGE_FAVOURITE:
          var data = event.value as Pair<String, bool>?;
          if (data != null) {
            bloc.add(JoinChangeFavouriteFromDetail(data.first, data.second));
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
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Strings.findTheMostExciting,
                    style: SportperStyle.baseStyle.copyWith(fontSize: 22),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    Strings.gameToPlay,
                    style: SportperStyle.boldStyle.copyWith(fontSize: 22),
                  )
                ],
              )),
              SizedBox(
                width: 10,
              ),
              AvatarWidget(
                onTap: () {
                  Navigator.pushNamed(context, Routes.profile);
                },
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          JoinSearchView(
            onChange: (text) {
              bloc.add(JoinFetch(keyword: text.trim()));
            },
            onTapFilter: () async {
              var lastFilter = await Navigator.pushNamed(
                  context, Routes.filterGame,
                  arguments: bloc.currentFilter);
              if (lastFilter != null && lastFilter is FilterGameVM) {
                bloc.currentFilter = lastFilter;
                bloc.add(JoinRefresh());
              }
            },
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  Strings.joinGames,
                  style: SportperStyle.boldStyle.copyWith(fontSize: 22),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              GestureDetector(
                onTap: () async {
                  Navigator.pushNamed(context, Routes.newGame);
                },
                child: Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 16, top: 16),
                  child: Image.asset(
                    ImagePaths.addFriend,
                    width: 24,
                    height: 24,
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: getProportionateScreenHeight(30),
          ),
          Expanded(
            child: BlocConsumer<JoinBloc, JoinState>(
                bloc: bloc,
                listener: (context, state) {
                  if (state is JoinFetchFailed) {
                    AppExceptionHandle.handle(context, state.error);
                  } else if (state is JoinShowLoading) {
                    LoadingDialog.show(context);
                  } else if (state is JoinHideLoading) {
                    Navigator.pop(context);
                  }
                },
                buildWhen: (pre, next) =>
                    next is JoinLoading ||
                    next is JoinFetchSuccessful ||
                    next is JoinFetchEmpty,
                builder: (contextBuilder, state) {
                  if (state is JoinLoading) {
                    return LoadingView();
                  }
                  if (state is JoinFetchSuccessful) {
                    return ListViewLoadMoreAndRefresh(
                      onRefresh: () => bloc.add(JoinRefresh()),
                      onLoadMore: () => bloc.add(JoinLoadMore()),
                      list: state.listJoins,
                      item: (contextList, index) {
                        return _buildItemListGame(state.listJoins[index],
                            onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.pushNamed(context, Routes.gameDetail,
                              arguments: state.listJoins[index]!.game.id);
                        });
                      },
                    );
                  }
                  if (state is JoinFetchEmpty) {
                    return EmptyView();
                  }
                  return Container();
                }),
          ),
        ],
      ),
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
          bloc.add(JoinChangeFavourite(gameVM.game.id));
        },
        onTapShare: () {
          Share.share(gameVM.game.title);
        },
      );
    }
  }
}
