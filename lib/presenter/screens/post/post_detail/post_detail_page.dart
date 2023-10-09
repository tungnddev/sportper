import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/presenter/models/current_reply_vm.dart';
import 'package:sportper/presenter/models/post_detail_vm.dart';
import 'package:sportper/presenter/screens/post/feed/widgets/post_detail_header.dart';
import 'package:sportper/presenter/screens/post/post_detail/input_comment_bloc/input_comment_bloc.dart';
import 'package:sportper/presenter/screens/post/post_detail/widgets/comment_widget.dart';
import 'package:sportper/presenter/screens/post/post_detail/widgets/input_comment.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/size_config.dart';
import 'package:sportper/utils/widgets/sportper_app_bar.dart';
import 'package:sportper/utils/widgets/loading_dialog.dart';
import 'package:sportper/utils/widgets/loading_view.dart';

import 'bloc/post_detail_bloc.dart';
import 'bloc/post_detail_event.dart';
import 'bloc/post_detail_state.dart';
import 'widgets/reply_note_text.dart';
import 'widgets/reply_widget.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;

  const PostDetailPage({Key? key, required this.postId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(
          create: (context) => PostDetailBloc(
                RepositoryProvider.of(context),
                postId,
                RepositoryProvider.of(context),
                RepositoryProvider.of(context),
              )),
      BlocProvider(
          create: (context) => InputCommentBloc(
                RepositoryProvider.of(context),
              ))
    ], child: PostDetailWidget());
  }
}

class PostDetailWidget extends StatefulWidget {
  const PostDetailWidget({Key? key}) : super(key: key);

  @override
  _PostDetailWidgetState createState() => _PostDetailWidgetState();
}

class _PostDetailWidgetState extends State<PostDetailWidget> {
  late PostDetailBloc bloc;
  FocusNode _commentFocus = FocusNode();
  ValueNotifier<CurrentReplyVM?> currentReply = ValueNotifier(null);
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of(context)..add(PostDetailInitData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocConsumer<PostDetailBloc, PostDetailState>(
            bloc: bloc,
            listener: (BuildContext context, state) {
              if (state is PostDetailFetchFailed) {
                AppExceptionHandle.handle(context, state.error);
              } else if (state is PostDetailShowLoading) {
                if (state.isShowIndicator) {
                  LoadingDialog.show(context);
                } else {
                  LoadingDialog.showInvisible(context);
                }
              } else if (state is PostDetailHideLoading) {
                Navigator.pop(context);
              } else if (state is PostDetailAddCommentSuccessful) {
                currentReply.value = null;
                _scrollToListPosition();
              }
            },
            buildWhen: (pre, next) =>
                next is PostDetailLoading || next is PostDetailFetchSuccessful,
            builder: (context, state) {
              if (state is PostDetailLoading) {
                return LoadingView();
              }
              if (state is PostDetailFetchSuccessful) {
                PostDetailVM vm = state.vm;
                return Column(
                  children: [
                    SportperAppBar(
                      title: Strings.post,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        child: GestureDetector(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            currentReply.value = null;
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PostDetailHeader(
                                vm: vm,
                                onTapLike: () => bloc.add(
                                    PostDetailChangeFavourite(vm.entity.id)),
                                onTapComment: () {
                                  currentReply.value = null;
                                  _commentFocus.requestFocus();
                                },
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: vm.comments
                                      .map((e) => CommentWidget(
                                            vm: e,
                                            onTapLike: () => bloc.add(
                                              PostDetailLikeComment(
                                                  commentId: e.entity.id,
                                                  postId: vm.entity.id),
                                            ),
                                            onTapReply: () {
                                              currentReply.value =
                                                  CurrentReplyVM(e.entity.id,
                                                      e.entity.user.fullName);
                                              _commentFocus.requestFocus();
                                            },
                                            onTapLikeReply: (String replyId) {
                                              bloc.add(
                                                PostDetailLikeReply(
                                                    commentId: e.entity.id,
                                                    replyId: replyId,
                                                    postId: vm.entity.id),
                                              );
                                            },
                                          ))
                                      .toList(),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ValueListenableBuilder<CurrentReplyVM?>(
                        valueListenable: currentReply,
                        builder: (context, value, child) {
                          if (value != null) {
                            return ReplyNoteText(
                                userName: value.userName,
                                clearReply: () => currentReply.value = null);
                          }
                          return SizedBox();
                        }),
                    InputComment(
                      textFocus: _commentFocus,
                      onSend: (String text, String? image) {
                        bloc.add(PostDetailAddComment(
                            commentText: text,
                            image: image,
                            currentReplyVM: currentReply.value));
                        currentReply.value = null;
                      },
                      bloc: BlocProvider.of<InputCommentBloc>(context),
                    )
                  ],
                );
              }
              return Container();
            }),
      ),
    );
  }

  _scrollToListPosition() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 10),
      );
    });
  }
}
