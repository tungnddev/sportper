import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/app/app.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/presenter/models/friend_vm.dart';
import 'package:sportper/presenter/screens/game/detail/invite/widgets/game_invitation_vm.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/button.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/images.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'game_invitation_bloc/game_invitation_bloc.dart';
import 'game_invitation_bloc/game_invitation_event.dart';
import 'game_invitation_bloc/game_invitation_state.dart';

class GameInvitationPage extends StatelessWidget {
  final Game game;

  const GameInvitationPage({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => GameInvitationBloc(
                  RepositoryProvider.of(context),
                  RepositoryProvider.of(context),
                  game,
                  RepositoryProvider.of(context),
                  RepositoryProvider.of(context)))
        ],
        child: GameInvitationFriendWidget(
          game: game,
        ));
  }
}

class GameInvitationFriendWidget extends StatefulWidget {
  final Game game;

  const GameInvitationFriendWidget({Key? key, required this.game})
      : super(key: key);

  @override
  _GameInvitationFriendWidgetState createState() =>
      _GameInvitationFriendWidgetState();
}

class _GameInvitationFriendWidgetState
    extends State<GameInvitationFriendWidget> {
  late GameInvitationBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(GameInvitationFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameInvitationBloc, GameInvitationState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is GameInvitationFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is GameInvitationShowLoading) {
            LoadingDialog.show(context);
          } else if (state is GameInvitationHideLoading) {
            Navigator.pop(context);
          } else if (state is GameInvitationInviteSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(Strings.sendInviteSuccessful),
              duration: Duration(seconds: 2),
            ));
          }
        },
        buildWhen: (pre, next) =>
            next is GameInvitationLoading ||
            next is GameInvitationFetchSuccessful ||
            next is GameInvitationFetchEmpty,
        builder: (contextBuilder, state) {
          return Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SportperAppBar(
                    title: Strings.sendInviteToFriends,
                  ),
                  Expanded(child: _buildMainWidget(state))
                ],
              ),
            ),
          );
        });
  }

  Widget _buildMainWidget(GameInvitationState state) {
    if (state is GameInvitationLoading) {
      return LoadingView();
    }
    if (state is GameInvitationFetchSuccessful) {
      return ListView.builder(
        itemCount: state.listGameInvitations.length,
        itemBuilder: (contextList, index) {
          return _buildItemListGame(index, state.listGameInvitations[index]);
        },
      );
    }
    if (state is GameInvitationFetchEmpty) {
      return EmptyView();
    }
    return Container();
  }

  Widget _buildItemListGame(int index, GameInvitationVM vm) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AvatarCircle(size: 64, url: vm.buddies.avatar),
          SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  vm.buddies.fullName,
                  style: SportperStyle.boldStyle,
                ),
                SizedBox(
                  height: 2,
                ),
                Text(
                  vm.buddies.phoneNumber,
                  style: SportperStyle.baseStyle
                      .copyWith(color: Color(0xFF7B7B7B), fontSize: 13),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 6,
          ),
          vm.isShowButton
              ? CupertinoButton(
                  onPressed: () {
                    bloc.add(GameInvitationSend(index, vm.buddies.id));
                  },
                  child: Text(
                    Strings.sentInvitation,
                    style: SportperStyle.semiBoldStyle
                        .copyWith(color: Colors.white, fontSize: 13),
                  ),
                  color: Theme.of(context).primaryColor,
                  padding:
                      EdgeInsets.only(top: 0, bottom: 0, left: 13, right: 13),
                  minSize: 40,
                  borderRadius: BorderRadius.circular(8),
                )
              : Text(
                  vm.statusText,
                  style: SportperStyle.baseStyle
                      .copyWith(color: vm.colorStatus, fontSize: 14),
                )
        ],
      ),
    );
  }
}
