import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_chat_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/pair.dart';

import 'event.dart';
import 'state.dart';

class NotificationChatBloc extends Bloc<NotificationChatEvent, NotificationChatState> {
  static const int LIMIT = 20;
  List<NotificationChatVM?> currentListNotificationChat = [];
  late bool canLoadMore;

  NotificationRepository repository;

  Map<String, dynamic>? lastDocData;

  NotificationChatBloc(this.repository) : super(NotificationChatInitial());

  @override
  Stream<NotificationChatState> mapEventToState(NotificationChatEvent event) async* {
    if (event is NotificationChatFetch) {
      currentListNotificationChat = [];
      lastDocData = null;
      canLoadMore = true;
      yield NotificationChatLoading();
      yield* fetchGame();
    } else if (event is NotificationChatLoadMore) {
      if (!canLoadMore) return;
      currentListNotificationChat.add(null);
      yield NotificationChatFetchSuccessful(listVM: currentListNotificationChat);
      yield* fetchGame(isLoadMore: true);
    } else if (event is NotificationChatAcceptItem) {
      currentListNotificationChat.removeAt(event.position);
      yield NotificationChatFetchSuccessful(listVM: currentListNotificationChat);
    }
  }

  Stream<NotificationChatState> fetchGame({bool isLoadMore = false}) async* {
    try {
      final data = await repository.getNotificationChats(LIMIT, lastDocData);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore) {
        currentListNotificationChat.removeLast();
      }
      currentListNotificationChat
          .addAll(data.first.map((e) => NotificationChatVM(e)).toList());
      if (currentListNotificationChat.isEmpty) {
        yield NotificationChatFetchEmpty();
      } else {
        yield NotificationChatFetchSuccessful(
          listVM: currentListNotificationChat,
        );
      }
    } catch (error) {
      yield NotificationChatFetchFailed(error: error);
    }
  }
}
