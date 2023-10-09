import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/data/remote/exception/exception_handler.dart';
import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/widgets/empty.dart';
import 'package:sportper/utils/widgets/list_view.dart';
import 'package:sportper/utils/widgets/loading_view.dart';
import 'package:sportper/utils/widgets/text_style.dart';
import 'package:intl/intl.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/chat_event.dart';
import 'bloc/chat_state.dart';
import 'model/helpdesk_message_model.dart';
import 'widget/chat_input_widget.dart';
import 'widget/message_join_widget.dart';
import 'widget/message_text_left.dart';
import 'widget/message_text_right.dart';

class GameDetailChatPage extends StatelessWidget {
  final String gameId;

  GameDetailChatPage({required this.gameId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ChatBloc(
              gameId: gameId,
              repository: RepositoryProvider.of(context),
              gameRepository: RepositoryProvider.of(context),
              userRepository: RepositoryProvider.of(context),
              notificationRepository: RepositoryProvider.of(context)),
        )
      ],
      child: ChatWidget(
        gameId: gameId,
      ),
    );
  }
}

class ChatWidget extends StatefulWidget {
  final String gameId;

  ChatWidget({required this.gameId});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<ChatWidget> {
  StreamSubscription<QuerySnapshot>? _streamSub;

  late ChatBloc messageBloc;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messageBloc = BlocProvider.of<ChatBloc>(context)..add(ChatLoad());
    RxBusService().add(RxBusName.OPENING_CHAT, value: true);
  }

  @override
  void dispose() {
    _streamSub?.cancel();
    RxBusService().add(RxBusName.OPENING_CHAT, value: false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<ChatBloc, ChatState>(
          bloc: messageBloc,
          listener: (context, state) {
            if (state is ChatLoadError) {
              AppExceptionHandle.handle(context, state.error);
            } else if (state is ChatLoadSuccessful) {
              if (state.mustScrollToEnd) {
                // scroll to end message
                WidgetsBinding.instance?.addPostFrameCallback((_) {
                  _scrollController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 10),
                  );
                });
              }
            } else if (state is ChatStartListen) {
              if (_streamSub != null) return;
              final _usersStream = FirebaseFirestore.instance
                  .collection('games')
                  .doc(widget.gameId)
                  .collection('chats')
                  .orderBy('createdAt', descending: true)
                  .limit(1)
                  .snapshots();
              _streamSub = _usersStream.listen((event) {
                final data = event.docs;
                if (data.isNotEmpty) {
                  messageBloc.add(ChatAddNewMessageParse(
                      data: data[0].data(), id: data[0].id));
                }
              });
            }
          },
          buildWhen: (context, state) =>
              state is ChatLoading ||
              state is ChatLoadEmpty ||
              state is ChatLoadSuccessful,
          builder: (context, stateMessage) =>
              _buildMainChatWidget(stateMessage)),
    );
  }

  Widget _buildMainChatWidget(ChatState state) {
    if (state is ChatLoadEmpty) {
      return EmptyView();
    } else if (state is ChatLoadSuccessful) {
      // trick
      List<ChatMessageVM?> listToShow = state.messages.reversed.toList();
      return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Column(
          children: [
            Expanded(
              child: state.messages.isEmpty
                  ? EmptyView()
                  : ListViewLoadMore(
                      onLoadMore: () => messageBloc.add(ChatLoadMore()),
                      item: (item, index) => _buildItemList(listToShow, index),
                      list: listToShow,
                      isReverse: true,
                      scrollController: _scrollController,
                    ),
            ),
            messageBloc.canChat()
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 24),
                    child: ChatInputWidget(
                        onSendText: (text) => sendMessage(text.trim())),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Text(
                      Strings.requiredJoinToChat,
                      style: SportperStyle.boldStyle.copyWith(
                          fontSize: 18, color: ColorUtils.disableText),
                    ),
                  )
          ],
        ),
      );
    } else if (state is ChatLoading) {
      return LoadingView();
    }
    return Container();
  }

  Widget _buildItemList(List<ChatMessageVM?> messages, int index) {
    ChatMessageVM? message = messages[index];
    return message == null
        ? Row(
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
          )
        : Padding(
            padding: EdgeInsets.only(
                left: 20, right: 20, bottom: index == 0 ? 10 : 0),
            child: _buildItemChat(messages, index));
  }

  Widget _buildItemChat(List<ChatMessageVM?> messages, int index) {
    ChatMessageVM message = messages[index]!;
    switch (message.chatMessageType) {
      case ChatMessageType.JOIN:
        return MessageJoinWidget(content: message.content);
      case ChatMessageType.TEXT:
        return message.isOwn
            ? MessageTextRight(
                message: message,
              )
            : MessageTextLeft(
                message: message,
              );
    }
  }

  void sendMessage(String content) {
    messageBloc.add(ChatSendMessage(content: content));
  }
}
