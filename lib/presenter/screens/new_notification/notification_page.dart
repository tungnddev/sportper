import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/presenter/models/notification_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/friends/buddies/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/game_with/bloc/bloc.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/dialog_add_friend.dart';
import 'package:sportper/presenter/screens/new_notification/bloc/notification_bloc.dart';
import 'package:sportper/presenter/screens/new_notification/widgets/game_invitation_item.dart';
import 'package:sportper/presenter/screens/new_notification/widgets/notification_friend_item.dart';
import 'package:sportper/presenter/screens/notification/friend/notification_friend_page.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import '../notification/chat/notification_chat_page.dart';
import '../notification/game/notification_game_page.dart';
import 'bloc/notification_event.dart';
import 'bloc/notification_state.dart';
import 'widgets/game_removed_item.dart';
import 'widgets/notification_chat_item.dart';
import 'widgets/notification_game_item.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => NotificationBloc(RepositoryProvider.of(context),
              RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: NotificationWidget());
  }
}

class NotificationWidget extends StatefulWidget {
  const NotificationWidget({Key? key}) : super(key: key);

  @override
  _NotificationWidgetState createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<NotificationWidget> {
  late NotificationBloc bloc;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bloc = BlocProvider.of(context)..add(NotificationFetch());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlocConsumer<NotificationBloc, NotificationState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is NotificationFetchFailed) {
                AppExceptionHandle.handle(context, state.error);
              } else if (state is NotificationShowLoading) {
                LoadingDialog.show(context);
              } else if (state is NotificationHideLoading) {
                Navigator.pop(context);
              } else if (state is NotificationChangeSuccessful) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.message),
                  duration: Duration(seconds: 2),
                ));
              }
            },
            buildWhen: (pre, next) =>
                next is NotificationLoading ||
                next is NotificationFetchSuccessful ||
                next is NotificationFetchEmpty,
            builder: (contextBuilder, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: 20, left: 24, right: 20, bottom: 20),
                    child: Text(
                      Strings.alert,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  Expanded(child: _buildMainWidget(state))
                ],
              );
            }));
  }

  Widget _buildMainWidget(NotificationState state) {
    if (state is NotificationLoading) {
      return LoadingView();
    }
    if (state is NotificationFetchSuccessful) {
      return ListViewLoadMoreAndRefresh(
        onRefresh: () => bloc.add(NotificationFetch()),
        onLoadMore: () => bloc.add(NotificationLoadMore()),
        list: state.listVM,
        item: (contextList, index) {
          return _buildItemListGame(index, state.listVM[index]);
        },
      );
    }
    if (state is NotificationFetchEmpty) {
      return EmptyView();
    }
    return Container();
  }

  Widget _buildItemListGame(int position, NotificationVM? vm) {
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
      switch (vm.entity.type) {
        case NotificationType.friendNotification:
          return NotificationFriendItem(
            vm: vm,
            onAccept: () =>
                bloc.add(NotificationAcceptItem(vm.entity.id,  vm.entity.friendId ?? '')),
            onDecline: () =>
                bloc.add(NotificationDeclineItem(vm.entity.id, vm.entity.friendId ?? '')),
          );
        case NotificationType.chatNotification:
          return NotificationChatItem(
            vm: vm,
            onTap: (String id) async {
              await Navigator.pushNamed(context, Routes.gameDetail,
                  arguments: id);
              bloc.add(NotificationFetch());
            },
          );
        case NotificationType.gameNotification:
          return NotificationGameItem(
              vm: NotificationGameVM(vm.entity),
              onTap: (String id) async {
                await Navigator.pushNamed(context, Routes.gameDetail,
                    arguments: id);
                bloc.add(NotificationFetch());
              });
        case NotificationType.gameInvitation:
          return GameInvitationItem(
            vm: vm,
            onTap: (String id, String? invitationId) async {
              await Navigator.pushNamed(context, Routes.gameDetail,
                  arguments: {'gameId': id, 'notification': vm.entity});
              bloc.add(NotificationFetch());
            },
          );
        case NotificationType.gameRemoved:
          return GameRemovedItem(
            vm: vm,
            onTap: (String id) async {

            },
          );
      }
    }
  }
}
