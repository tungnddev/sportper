import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/game_player.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/home_tab_enum.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/game/detail/detailoverview/bloc/state.dart';
import 'package:sportper/presenter/screens/game/join/widgets/avatar_list_widget.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:share_plus/share_plus.dart';

import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';
import 'widgets/friend_with_game_item.dart';

class GameWithWidget extends StatefulWidget {
  const GameWithWidget({Key? key}) : super(key: key);

  @override
  _GameWithWidgetState createState() => _GameWithWidgetState();
}

class _GameWithWidgetState extends State<GameWithWidget> {
  late GameWithBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(GameWithFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameWithBloc, GameWithState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is GameWithFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is GameWithShowLoading) {
            LoadingDialog.show(context);
          } else if (state is GameWithHideLoading) {
            Navigator.pop(context);
          }
        },
        buildWhen: (pre, next) =>
            next is GameWithLoading ||
            next is GameWithFetchSuccessful ||
            next is GameWithFetchEmpty,
        builder: (contextBuilder, state) {
          if (state is GameWithLoading) {
            return LoadingView();
          }
          if (state is GameWithFetchSuccessful) {
            return ListViewLoadMoreAndRefresh(
              onRefresh: () => bloc.add(GameWithFetch()),
              onLoadMore: () => bloc.add(GameWithLoadMore()),
              list: state.listVM,
              item: (contextList, index) {
                return _buildItemListGame(state.listVM[index], onTap: () {});
              },
            );
          }
          if (state is GameWithFetchEmpty) {
            return EmptyView();
          }
          return Container();
        });
  }

  Widget _buildItemListGame(FriendGamesWithVM? vm, {Function()? onTap}) {
    if (vm == null) {
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
      return FriendWithGameItem(
        vm: vm,
        onTap: () {
          Navigator.pushNamed(context, Routes.profile,
              arguments: vm.friendWithGame.user.id);
        },
      );
    }
  }
}
