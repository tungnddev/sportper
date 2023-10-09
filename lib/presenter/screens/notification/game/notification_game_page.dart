import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_game_vm.dart';
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
import 'widgets/notification_game_item.dart';

class NotificationGamePage extends StatelessWidget {
  const NotificationGamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) =>
              NotificationGameBloc(RepositoryProvider.of(context), RepositoryProvider.of(context)))
    ], child: NotificationGameWidget());
  }
}

class NotificationGameWidget extends StatefulWidget {
  const NotificationGameWidget({Key? key}) : super(key: key);

  @override
  _NotificationGameWidgetState createState() =>
      _NotificationGameWidgetState();
}

class _NotificationGameWidgetState extends State<NotificationGameWidget> {
  late NotificationGameBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(NotificationGameFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationGameBloc, NotificationGameState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is NotificationGameFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is NotificationGameShowLoading) {
            LoadingDialog.show(context);
          } else if (state is NotificationGameHideLoading) {
            Navigator.pop(context);
          }
        },
        buildWhen: (pre, next) =>
            next is NotificationGameLoading ||
            next is NotificationGameFetchSuccessful ||
            next is NotificationGameFetchEmpty,
        builder: (contextBuilder, state) {
          return _buildMainWidget(state);
        });
  }

  Widget _buildMainWidget(NotificationGameState state) {
    if (state is NotificationGameLoading) {
      return LoadingView();
    }
    if (state is NotificationGameFetchSuccessful) {
      return ListView.builder(
        itemCount: state.listVM.length,
        itemBuilder: (contextList, index) {
          return _buildItemListGame(index, state.listVM[index]);
        },
      );
    }
    if (state is NotificationGameFetchEmpty) {
      return EmptyView();
    }
    return Container();
  }

  Widget _buildItemListGame(int position, NotificationGameVM? vm) {
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
      return NotificationGameItems(
        vm: vm,
        onTap: (String id, String? invitationId) async {
          // await Navigator.pushNamed(context, Routes.gameDetail, arguments: {'gameId': id, 'notification': vm});
          // bloc.add(NotificationGameFetch());
        },
      );
    }
  }
}
