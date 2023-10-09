import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/buddies.dart';
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
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/pair.dart';

import 'event.dart';
import 'state.dart';

class NotificationFriendBloc
    extends Bloc<NotificationFriendEvent, NotificationFriendState> {
  static const int LIMIT = 20;
  List<NotificationFriendVM?> currentListNotificationFriend = [];
  late bool canLoadMore;

  NotificationRepository repository;
  FriendRepository _friendRepository;
  AuthRepository _authRepository;

  Map<String, dynamic>? lastDocData;

  NotificationFriendBloc(
      this.repository, this._friendRepository, this._authRepository)
      : super(NotificationFriendInitial());

  @override
  Stream<NotificationFriendState> mapEventToState(
      NotificationFriendEvent event) async* {
    if (event is NotificationFriendFetch) {
      currentListNotificationFriend = [];
      lastDocData = null;
      canLoadMore = true;
      yield NotificationFriendLoading();
      yield* fetchGame();
    } else if (event is NotificationFriendLoadMore) {
      if (!canLoadMore) return;
      currentListNotificationFriend.add(null);
      yield NotificationFriendFetchSuccessful(
          listVM: currentListNotificationFriend);
      yield* fetchGame(isLoadMore: true);
    } else if (event is NotificationFriendAcceptItem) {
      yield* mapAcceptFriend(event.friendId);
    } else if (event is NotificationFriendDeclineItem) {
      yield* mapDeclineFriend(event.friendId);
    }
  }

  Stream<NotificationFriendState> fetchGame({bool isLoadMore = false}) async* {
    try {
      final data = await repository.getNotificationFriends(LIMIT, lastDocData);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore) {
        currentListNotificationFriend.removeLast();
      }
      currentListNotificationFriend.addAll(
          data.first.map((e) => NotificationFriendVM.fromEntity(e)).toList());
      if (currentListNotificationFriend.isEmpty) {
        yield NotificationFriendFetchEmpty();
      } else {
        yield NotificationFriendFetchSuccessful(
          listVM: currentListNotificationFriend,
        );
      }
    } catch (error) {
      yield NotificationFriendFetchFailed(error: error);
    }
  }

  Stream<NotificationFriendState> mapAcceptFriend(String friendId) async* {
    try {
      yield NotificationFriendShowLoading();

      String uid = (await _authRepository.currentUser())?.uid ?? '';

      await repository.changeStatusNotificationFriend(
          friendId, NotificationFriendStatusConst.ACCEPTED);
      await _friendRepository.changeStatusFriend(
          friendId, uid, FriendStatusConst.ACCEPTED);
      // await _friendRepository.addBuddies(
      //     Buddies(friendId, '', '', '', FriendStatus.accepted, DateTime.now()));
      yield NotificationFriendHideLoading();
      yield NotificationFriendChangeSuccessful(
          Strings.acceptFriendSuccessfully);
      currentListNotificationFriend
          .removeWhere((element) => element?.friendId == friendId);

      if (currentListNotificationFriend.isEmpty) {
        yield NotificationFriendFetchEmpty();
      } else {
        yield NotificationFriendFetchSuccessful(
          listVM: currentListNotificationFriend,
        );
      }
    } catch (e) {
      yield NotificationFriendHideLoading();
      yield NotificationFriendFetchFailed(error: e);
    }
  }

  Stream<NotificationFriendState> mapDeclineFriend(String friendId) async* {
    try {
      yield NotificationFriendShowLoading();

      String uid = (await _authRepository.currentUser())?.uid ?? '';

      await repository.changeStatusNotificationFriend(
          friendId, NotificationFriendStatusConst.DECLINE);
      await _friendRepository.changeStatusFriend(
          friendId, uid, FriendStatusConst.DECLINE);
      yield NotificationFriendHideLoading();
      yield NotificationFriendChangeSuccessful(
          Strings.declineFriendSuccessfully);

      currentListNotificationFriend
          .removeWhere((element) => element?.friendId == friendId);
      if (currentListNotificationFriend.isEmpty) {
        yield NotificationFriendFetchEmpty();
      } else {
        yield NotificationFriendFetchSuccessful(
          listVM: currentListNotificationFriend,
        );
      }
    } catch (e) {
      yield NotificationFriendHideLoading();
      yield NotificationFriendFetchFailed(error: e);
    }
  }
}
