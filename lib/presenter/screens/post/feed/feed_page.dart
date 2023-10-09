import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/post.dart';
import 'package:sportper/presenter/models/post_vm.dart';
import 'package:sportper/presenter/routes/routes.dart';
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

import 'bloc/feed_bloc.dart';
import 'bloc/feed_event.dart';
import 'bloc/feed_state.dart';
import 'widgets/item_post.dart';

enum FeedTab { explore, friends }

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => FeedBloc(RepositoryProvider.of(context),
              RepositoryProvider.of(context), RepositoryProvider.of(context), RepositoryProvider.of(context))),
    ], child: FeedWidget());
  }
}

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  late FeedBloc bloc;
  StreamSubscription<RxBusServiceObject>? _subscription;

  ValueNotifier<FeedTab> currentTabNotifier = ValueNotifier(FeedTab.explore);

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(FeedFetch());
    _listenerNotification();
  }

  void _listenerNotification() {
    _subscription = RxBusService().listen((event) {
      switch (event.name) {
        case RxBusName.REFRESH_FEED:
          bloc.add(FeedFetch());
          break;
        case RxBusName.CHANGE_LIKE_POST:
          var data = event.value as Pair<String, bool>?;
          if (data != null) {
            bloc.add(FeedChangeFavouriteFromDetail(data.first, data.second));
          }
          break;
        case RxBusName.CHANGE_NUM_LIKE_POST:
          var data = event.value as Pair<String, int>?;
          if (data != null) {
            bloc.add(FeedChangeNumLikeFromDetail(data.first, data.second));
          }
          break;
        case RxBusName.CHANGE_NUM_COMMENT_POST:
          var data = event.value as Pair<String, int>?;
          if (data != null) {
            bloc.add(FeedChangeNumCommentsFromDetail(data.first, data.second));
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
                      Strings.feed,
                      style: SportperStyle.boldStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  ValueListenableBuilder<FeedTab>(
                      valueListenable: currentTabNotifier,
                      builder: (context, value, child) {
                        if (value == FeedTab.explore) {
                          return GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, Routes.addPost, arguments: PostType.feed);
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
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SportperTabBar<FeedTab>(
              listTabs: [
                Pair(Strings.explore, FeedTab.explore),
                Pair(Strings.friends, FeedTab.friends),
              ],
              onChange: (FeedTab tab) {
                currentTabNotifier.value = FeedTab.friends;
                bloc.currentTab = tab;
                bloc.add(FeedFetch());
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
      child: BlocConsumer<FeedBloc, FeedState>(
          bloc: bloc,
          listener: (context, state) {
            if (state is FeedFetchFailed) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is FeedShowLoading) {
              if (state.isShowIndicator) {
                LoadingDialog.show(context);
              } else {
                LoadingDialog.showInvisible(context);
              }
            } else if (state is FeedHideLoading) {
              Navigator.pop(context);
            }
          },
          buildWhen: (pre, next) =>
              next is FeedLoading ||
              next is FeedFetchSuccessful ||
              next is FeedFetchEmpty,
          builder: (contextBuilder, state) {
            if (state is FeedLoading) {
              return LoadingView();
            }
            if (state is FeedFetchSuccessful) {
              return ListViewLoadMoreAndRefresh(
                onRefresh: () => bloc.add(FeedFetch()),
                onLoadMore: () => bloc.add(FeedLoadMore()),
                list: state.listFeeds,
                item: (contextList, index) {
                  return _buildItemListGame(state.listFeeds[index], onTap: () {
                    Navigator.pushNamed(context, Routes.postDetail,
                        arguments: state.listFeeds[index]!.entity.id);
                  });
                },
              );
            }
            if (state is FeedFetchEmpty) {
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
          bloc.add(FeedChangeFavourite(postVM.entity.id));
        },
        onTapComment: onTap,
      );
    }
  }
}
