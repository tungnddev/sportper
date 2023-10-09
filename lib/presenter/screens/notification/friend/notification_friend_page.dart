import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';
import 'widgets/notification_friend_item.dart';

class NotificationFriendPage extends StatelessWidget {
  const NotificationFriendPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => NotificationFriendBloc(
              RepositoryProvider.of(context), RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: NotificationFriendWidget());
  }
}

class NotificationFriendWidget extends StatefulWidget {
  const NotificationFriendWidget({Key? key}) : super(key: key);

  @override
  _NotificationFriendWidgetState createState() =>
      _NotificationFriendWidgetState();
}

class _NotificationFriendWidgetState extends State<NotificationFriendWidget> {
  late NotificationFriendBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(NotificationFriendFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationFriendBloc, NotificationFriendState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is NotificationFriendFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is NotificationFriendShowLoading) {
            LoadingDialog.show(context);
          } else if (state is NotificationFriendHideLoading) {
            Navigator.pop(context);
          } else if (state is NotificationFriendChangeSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.message),
              duration: Duration(seconds: 2),
            ));
          }
        },
        buildWhen: (pre, next) =>
            next is NotificationFriendLoading ||
            next is NotificationFriendFetchSuccessful ||
            next is NotificationFriendFetchEmpty,
        builder: (contextBuilder, state) {
          return _buildMainWidget(state);
        });
  }

  Widget _buildMainWidget(NotificationFriendState state) {
    if (state is NotificationFriendLoading) {
      return LoadingView();
    }
    if (state is NotificationFriendFetchSuccessful) {
      return ListViewLoadMoreAndRefresh(
        onRefresh: () => bloc.add(NotificationFriendFetch()),
        onLoadMore: () => bloc.add(NotificationFriendLoadMore()),
        list: state.listVM,
        item: (contextList, index) {
          return _buildItemListGame(index, state.listVM[index]);
        },
      );
    }
    if (state is NotificationFriendFetchEmpty) {
      return EmptyView();
    }
    return Container();
  }

  Widget _buildItemListGame(int position, NotificationFriendVM? vm) {
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
      return NotificationFriendItems(
        vm: vm,
        onAccept: () => bloc.add(NotificationFriendAcceptItem(vm.friendId)),
        onDecline: () => bloc.add(NotificationFriendDeclineItem(vm.friendId)),
      );
    }
  }
}
