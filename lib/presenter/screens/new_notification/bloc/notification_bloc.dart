import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';

import 'notification_event.dart';
import 'notification_state.dart';
import 'package:collection/collection.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  static const int LIMIT = 20;
  List<NotificationVM?> currentListNotification = [];
  late bool canLoadMore;

  NotificationRepository repository;
  FriendRepository _friendRepository;
  AuthRepository _authRepository;

  Map<String, dynamic>? lastDocData;

  NotificationBloc(
      this.repository, this._friendRepository, this._authRepository)
      : super(NotificationInitial());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    if (event is NotificationFetch) {
      currentListNotification = [];
      lastDocData = null;
      canLoadMore = true;
      yield NotificationLoading();
      yield* fetchGame();
    } else if (event is NotificationLoadMore) {
      if (!canLoadMore) return;
      currentListNotification.add(null);
      yield NotificationFetchSuccessful(listVM: currentListNotification);
      yield* fetchGame(isLoadMore: true);
    } else if (event is NotificationAcceptItem) {
      yield* mapAcceptFriend(event.id, event.friendId);
    } else if (event is NotificationDeclineItem) {
      yield* mapDeclineFriend(event.id, event.friendId);
    }
  }

  Stream<NotificationState> fetchGame({bool isLoadMore = false}) async* {
    try {
      final data = await repository.getNotifications(LIMIT, lastDocData);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore) {
        currentListNotification.removeLast();
      }
      currentListNotification
          .addAll(data.first.map((e) => NotificationVM(e)).toList());
      if (currentListNotification.isEmpty) {
        yield NotificationFetchEmpty();
      } else {
        yield NotificationFetchSuccessful(
          listVM: currentListNotification,
        );
      }
    } catch (error) {
      yield NotificationFetchFailed(error: error);
    }
  }

  Stream<NotificationState> mapAcceptFriend(String id, String friendId) async* {
    try {
      yield NotificationShowLoading();

      String uid = (await _authRepository.currentUser())?.uid ?? '';

      await repository.acceptStatusNotificationFriend(id);
      await _friendRepository.changeStatusFriend(
          friendId, uid, FriendStatusConst.ACCEPTED);
      // await _friendRepository.addBuddies(
      //     Buddies(friendId, '', '', '', FriendStatus.accepted, DateTime.now()));
      yield NotificationHideLoading();
      yield NotificationChangeSuccessful(Strings.acceptFriendSuccessfully);
      final selectNotification = currentListNotification
          .firstWhereOrNull((element) => element?.entity.id == id);
      if (selectNotification != null) {
        selectNotification.entity.friendStatus =
            NotificationFriendStatus.accepted;
        selectNotification.entity.subTitle = Strings.friendAlreadyAccept;
      }

      if (currentListNotification.isEmpty) {
        yield NotificationFetchEmpty();
      } else {
        yield NotificationFetchSuccessful(
          listVM: currentListNotification,
        );
      }
    } catch (e) {
      yield NotificationHideLoading();
      yield NotificationFetchFailed(error: e);
    }
  }

  Stream<NotificationState> mapDeclineFriend(
      String id, String friendId) async* {
    try {
      yield NotificationShowLoading();

      String uid = (await _authRepository.currentUser())?.uid ?? '';

      await repository.declineStatusNotificationFriend(id);
      await _friendRepository.changeStatusFriend(
          friendId, uid, FriendStatusConst.DECLINE);
      yield NotificationHideLoading();
      yield NotificationChangeSuccessful(Strings.declineFriendSuccessfully);

      final selectNotification = currentListNotification
          .firstWhereOrNull((element) => element?.entity.id == id);
      if (selectNotification != null) {
        selectNotification.entity.friendStatus =
            NotificationFriendStatus.decline;
        selectNotification.entity.subTitle = Strings.friendAlreadyDecline;
      }

      if (currentListNotification.isEmpty) {
        yield NotificationFetchEmpty();
      } else {
        yield NotificationFetchSuccessful(
          listVM: currentListNotification,
        );
      }
    } catch (e) {
      yield NotificationHideLoading();
      yield NotificationFetchFailed(error: e);
    }
  }
}
