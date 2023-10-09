import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_chat_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';
import 'widgets/notification_chat_item.dart';

class NotificationChatPage extends StatelessWidget {
  const NotificationChatPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) =>
              NotificationChatBloc(RepositoryProvider.of(context)))
    ], child: NotificationChatWidget());
  }
}

class NotificationChatWidget extends StatefulWidget {
  const NotificationChatWidget({Key? key}) : super(key: key);

  @override
  _NotificationChatWidgetState createState() =>
      _NotificationChatWidgetState();
}

class _NotificationChatWidgetState extends State<NotificationChatWidget> {
  late NotificationChatBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(NotificationChatFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationChatBloc, NotificationChatState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is NotificationChatFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is NotificationChatShowLoading) {
            LoadingDialog.show(context);
          } else if (state is NotificationChatHideLoading) {
            Navigator.pop(context);
          }
        },
        buildWhen: (pre, next) =>
            next is NotificationChatLoading ||
            next is NotificationChatFetchSuccessful ||
            next is NotificationChatFetchEmpty,
        builder: (contextBuilder, state) {
          return _buildMainWidget(state);
        });
  }

  Widget _buildMainWidget(NotificationChatState state) {
    if (state is NotificationChatLoading) {
      return LoadingView();
    }
    if (state is NotificationChatFetchSuccessful) {
      return ListViewLoadMoreAndRefresh(
        onRefresh: () => bloc.add(NotificationChatFetch()),
        onLoadMore: () => bloc.add(NotificationChatLoadMore()),
        list: state.listVM,
        item: (contextList, index) {
          return _buildItemListGame(index, state.listVM[index]);
        },
      );
    }
    if (state is NotificationChatFetchEmpty) {
      return EmptyView();
    }
    return Container();
  }

  Widget _buildItemListGame(int position, NotificationChatVM? vm) {
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
      return NotificationChatItems(
        vm: vm,
        onTap: (String id) {
          Navigator.pushNamed(context, Routes.gameDetail, arguments: id);
        },
      );
    }
  }
}
