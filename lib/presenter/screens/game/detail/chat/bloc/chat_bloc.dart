import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:sportper/data/models/chat_message_model.dart';
import 'package:sportper/data/remote/mapper/chat_mapper.dart';
import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/chat_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/domain/request/request_notification_chat.dart';
import 'package:sportper/presenter/screens/game/detail/chat/model/helpdesk_message_model.dart';
import 'package:intl/intl.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  static const int LIMIT = 15;
  ChatRepository repository;
  GameRepository gameRepository;
  UserRepository userRepository;
  NotificationRepository notificationRepository;
  String gameId;

  ChatBloc(
      {required this.gameId,
      required this.repository,
      required this.gameRepository,
      required this.userRepository,
      required this.notificationRepository})
      : super(ChatInitial());

  List<ChatMessageVM?> messages = [];
  var members = SplayTreeMap<String, SportperUser>();
  bool canLoadMore = false;
  Map<String, dynamic>? lastDocData;
  SportperUser? cacheUser;
  late Game lastGame;

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if (event is ChatLoad) {
      yield ChatLoading();
      if (members.isEmpty) {
        try {
          cacheUser = await userRepository.getCurrentUser();
          lastGame = await gameRepository.getGameDetail(gameId);
          List<SportperUser> listMembers = await userRepository
              .getUsers(lastGame.usersJoined.map((e) => e.id).toList());
          listMembers.forEach((element) {
            members[element.id] = element;
          });
          messages = [];
          lastDocData = null;
          canLoadMore = true;
          yield* fetchMessage(isTheFirstTime: true);
        } catch (error) {
          yield ChatLoadError(error: error);
        }
      }
    } else if (event is ChatLoadMore) {
      if (!canLoadMore) return;
      messages.insert(0, null);
      yield ChatLoadSuccessful(messages: messages, mustScrollToEnd: false);
      yield* fetchMessage(isLoadMore: true);
    } else if (event is ChatAddNewMessageParse) {
      yield* mapEventAddNewMessageParse(event.id, event.data);
    } else if (event is ChatSendMessage) {
      yield* mapEventSendMessageText(event.content);
    } else if (event is ChatRefreshMessage) {
      yield ChatLoadSuccessful(messages: messages, mustScrollToEnd: false);
    }
  }

  Stream<ChatState> fetchMessage(
      {bool isLoadMore = false, bool isTheFirstTime = false}) async* {
    try {
      final data = await repository.getList(LIMIT, lastDocData, gameId);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore && messages.first == null) {
        messages.removeAt(0);
      }
      messages.insertAll(
          0,
          data.first.reversed.map((e) => ChatMessageVM(
              id: e.id,
              content: e.content,
              isOwn: e.senderId == cacheUser?.id,
              sendTime: DateFormat.yMd().format(e.createdAt),
              member: members[e.senderId],
              chatMessageType: e.type)));
      yield ChatLoadSuccessful(messages: messages, mustScrollToEnd: false);
      // if (messages.isEmpty) {
      //   yield ChatLoadEmpty();
      // } else {
      //
      // }
      if (isTheFirstTime) {
        yield ChatStartListen();
      }
    } catch (error) {
      yield ChatLoadError(error: error);
    }
  }

  Stream<ChatState> mapEventAddNewMessageParse(
      String id, Map<String, dynamic> data) async* {
    try {
      var model = ChatMessageModel.fromJson(data);
      model.id = id;

      if (messages.isNotEmpty && messages.last?.id == id) {
        return;
      }
      if (model.senderId == cacheUser?.id) {
        return;
      }

      var entity = ChatMapper().mapMessage(model);

      if (entity.type == ChatMessageType.JOIN) {
        final newUser = await userRepository.getUser(entity.senderId);
        if (newUser != null) {
          members[entity.senderId] = newUser;
        }
      }

      final vm = ChatMessageVM(
          id: entity.id,
          content: entity.content,
          isOwn: entity.senderId == cacheUser?.id,
          sendTime: DateFormat.yMd().format(entity.createdAt),
          member: members[entity.senderId],
          chatMessageType: entity.type);

      messages.add(vm);
      yield ChatLoadSuccessful(messages: messages, mustScrollToEnd: true);
    } catch (error) {
      print(error);
    }
  }

  Stream<ChatState> mapEventSendMessageText(String content) async* {
    try {
      var cacheMessageText =
          ChatMessageVM.fromCacheMessage(content, cacheUser!);
      messages.add(cacheMessageText);
      yield ChatLoadSuccessful(messages: messages, mustScrollToEnd: true);

      //
      ChatMessage chatMessage = ChatMessage('', content, DateTime.now(),
          cacheUser?.id ?? '1', ChatMessageType.TEXT);
      await repository.sendMessage(gameId, chatMessage);

      // add notification chat type into another user in the game
      addNotificationChatToTheOtherUser(content);
    } catch (error) {
      print(error);
    }
  }

  bool canChat() {
    return lastGame.usersJoined.map((e) => e.id).contains(cacheUser?.id);
  }

  addNotificationChatToTheOtherUser(String message) {
    final listOtherUsers = lastGame.usersJoined.map((e) => e.id).where((element) => element != cacheUser?.id).toList();
    notificationRepository.addNotificationChat(listOtherUsers, gameId, Notification.fromChat(lastGame, message));
  }

}
