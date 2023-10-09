import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/friend_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';

import 'bloc/bloc.dart';
import 'bloc/event.dart';
import 'bloc/state.dart';
import 'widgets/buddies_item.dart';


class BuddiesFriendWidget extends StatefulWidget {
  const BuddiesFriendWidget({Key? key}) : super(key: key);

  @override
  _BuddiesFriendWidgetState createState() =>
      _BuddiesFriendWidgetState();
}

class _BuddiesFriendWidgetState extends State<BuddiesFriendWidget> {
  late BuddiesBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(BuddiesFetch());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BuddiesBloc, BuddiesState>(
        bloc: bloc,
        listener: (context, state) {
          if (state is BuddiesFetchFailed) {
            AppExceptionHandle.handle(context, state.error);
          } else if (state is BuddiesShowLoading) {
            LoadingDialog.show(context);
          } else if (state is BuddiesHideLoading) {
            Navigator.pop(context);
          } else if (state is BuddiesAddBuddiesSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(Strings.addFriendSuccessful),
              duration: Duration(seconds: 2),
            ));
            bloc = BlocProvider.of(context)..add(BuddiesFetch());
          } else if (state is BuddiesDeleteBuddiesSuccessful) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(Strings.deleteFriendSuccessful),
              duration: Duration(seconds: 2),
            ));
            bloc = BlocProvider.of(context)..add(BuddiesFetch());
          }
        },
        buildWhen: (pre, next) => next is BuddiesLoading || next is BuddiesFetchSuccessful || next is BuddiesFetchEmpty,
        builder: (contextBuilder, state) {
          if (state is BuddiesLoading) {
            return LoadingView();
          }
          if (state is BuddiesFetchSuccessful) {
            return ListViewLoadMoreAndRefresh(
              onRefresh: () => bloc.add(BuddiesFetch()),
              onLoadMore: () => bloc.add(BuddiesLoadMore()),
              list: state.listVM,
              item: (contextList, index) {
                return _buildItemListGame(state.listVM[index],
                    onTap: () {
                    });
              },
            );
          }
          if (state is BuddiesFetchEmpty) {
            return EmptyView();
          }
          return Container();
        }
    );
  }



  Widget _buildItemListGame(FriendVM? vm, {Function()? onTap}) {
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
      return BuddiesItem(
        vm: vm,
        onTap: (String id) {
          Navigator.pushNamed(context, Routes.profile, arguments: id);
        },
        onDelete: (String id) {
          bloc.add(BuddiesDeleteFriend(id));
        },
      );
    }
  }
}


