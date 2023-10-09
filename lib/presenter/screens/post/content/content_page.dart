import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/presenter/models/post_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
import 'package:sportper/presenter/screens/post/content/role_bloc/role_bloc.dart';
import 'package:sportper/presenter/screens/post/content/role_bloc/role_state.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/item_post.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/images.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/tab_bar.dart';
import 'package:sportper/utils/widgets/text_style.dart';

import 'bloc/content_bloc.dart';
import 'bloc/content_event.dart';
import 'bloc/content_state.dart';
import 'role_bloc/role_event.dart';

class ContentPage extends StatelessWidget {
  const ContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => ContentBloc(RepositoryProvider.of(context),
              RepositoryProvider.of(context), RepositoryProvider.of(context))),
      BlocProvider(
          create: (context) => RoleBloc(RepositoryProvider.of(context))),
    ], child: ContentWidget());
  }
}

class ContentWidget extends StatefulWidget {
  const ContentWidget({Key? key}) : super(key: key);

  @override
  _ContentWidgetState createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  late ContentBloc bloc;
  StreamSubscription<RxBusServiceObject>? _subscription;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(ContentFetch());
    BlocProvider.of<RoleBloc>(context).add(RoleEventStartLoad());
    _listenerNotification();
  }

  void _listenerNotification() {
    _subscription = RxBusService().listen((event) {
      switch (event.name) {
        case RxBusName.REFRESH_FEED:
          bloc.add(ContentFetch());
          break;
        case RxBusName.CHANGE_LIKE_POST:
          var data = event.value as Pair<String, bool>?;
          if (data != null) {
            bloc.add(ContentChangeFavouriteFromDetail(data.first, data.second));
          }
          break;
        case RxBusName.CHANGE_NUM_LIKE_POST:
          var data = event.value as Pair<String, int>?;
          if (data != null) {
            bloc.add(ContentChangeNumLikeFromDetail(data.first, data.second));
          }
          break;
        case RxBusName.CHANGE_NUM_COMMENT_POST:
          var data = event.value as Pair<String, int>?;
          if (data != null) {
            bloc.add(ContentChangeNumCommentsFromDetail(data.first, data.second));
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
              padding: EdgeInsets.fromLTRB(24, 10, 8, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      Strings.content,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  BlocBuilder<RoleBloc, RoleState>(builder: (context, state) {
                    if (state is RoleStateSuccessful && state.canPostContent) {
                      return GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, Routes.addPost, arguments: PostType.content);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Image.asset(
                            ImagePaths.addFriend,
                            width: 24,
                            height: 24,
                          ),
                        ),
                      );
                    }
                    return SizedBox(
                      width: 56,
                      height: 56,
                    );
                  })
                ],
              )),
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
      child: BlocConsumer<ContentBloc, ContentState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is ContentFetchFailed) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is ContentShowLoading) {
              if (state.isShowIndicator) {
                LoadingDialog.show(context);
              } else {
                LoadingDialog.showInvisible(context);
              }
            } else if (state is ContentHideLoading) {
              Navigator.pop(context);
            }
          },
          buildWhen: (pre, next) =>
              next is ContentLoading ||
              next is ContentFetchSuccessful ||
              next is ContentFetchEmpty,
          builder: (contextBuilder, state) {
            if (state is ContentLoading) {
              return LoadingView();
            }
            if (state is ContentFetchSuccessful) {
              return ListViewLoadMoreAndRefresh(
                onRefresh: () => bloc.add(ContentFetch()),
                onLoadMore: () => bloc.add(ContentLoadMore()),
                list: state.listContents,
                item: (contextList, index) {
                  return _buildItemListGame(state.listContents[index], onTap: () {
                    Navigator.pushNamed(context, Routes.postDetail,
                        arguments: state.listContents[index]!.entity.id);
                  });
                },
              );
            }
            if (state is ContentFetchEmpty) {
              return EmptyView();
            }
            return Container();
          }),
    );
  }

  Widget _buildItemListGame(PostVM? postVM, {Function()? onTap}) {
    if (postVM == null) {
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
      return PostItemWidget(
        vm: postVM,
        onTap: onTap,
        onTapLike: () {
          bloc.add(ContentChangeFavourite(postVM.entity.id));
        },
        onTapComment: onTap,
      );
    }
  }
}
