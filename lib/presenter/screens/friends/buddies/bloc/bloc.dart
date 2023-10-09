import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/domain/request/request_notification_friends.dart';
import 'package:sportper/presenter/models/friend_vm.dart';

import 'event.dart';
import 'state.dart';

class BuddiesBloc extends Bloc<BuddiesEvent, BuddiesState> {
  static const int LIMIT = 20;
  List<FriendVM?> currentListBuddies = [];
  late bool canLoadMore;

  FriendRepository repository;
  UserRepository _userRepository;
  NotificationRepository notificationRepository;

  Map<String, dynamic>? lastDocData;

  BuddiesBloc(
      this.repository, this._userRepository, this.notificationRepository)
      : super(BuddiesInitial());

  @override
  Stream<BuddiesState> mapEventToState(BuddiesEvent event) async* {
    if (event is BuddiesFetch) {
      currentListBuddies = [];
      lastDocData = null;
      canLoadMore = true;
      yield BuddiesLoading();
      yield* fetchGame();
    } else if (event is BuddiesLoadMore) {
      if (!canLoadMore) return;
      currentListBuddies.add(null);
      yield BuddiesFetchSuccessful(listVM: currentListBuddies);
      yield* fetchGame(isLoadMore: true);
    } else if (event is BuddiesAddNewFriend) {
      try {
        yield BuddiesShowLoading();
        final user = await _userRepository.getUserByPhone(event.phone);
        final buddies = user == null
            ? Buddies(
                '',
                'https://huyhoanhotel.com/wp-content/uploads/2016/05/765-default-avatar.png',
                event.phone,
                event.name,
                FriendStatus.not_exist,
                DateTime.now())
            : Buddies(user.id, '', '', event.name, FriendStatus.sent_invitation,
                DateTime.now());

        if (user != null) {
          final isBuddyExist = await repository.isBuddyExist(user.id);
          if (isBuddyExist) return;
        }
        await repository.addBuddies(buddies);
        yield BuddiesHideLoading();
        yield BuddiesAddBuddiesSuccessful();

        // add notification
        final currentUser = await _userRepository.getCurrentUser();
        if (user != null) {
          addNotification(currentUser!, user.id);
        }
      } catch (e) {
        yield BuddiesHideLoading();
        yield BuddiesFetchFailed(error: e);
      }
    } else if (event is BuddiesDeleteFriend) {
      try {
        yield BuddiesShowLoading();
        await repository.remoteBuddies(event.id);
        yield BuddiesHideLoading();
        yield BuddiesDeleteBuddiesSuccessful();
      } catch (e) {
        yield BuddiesHideLoading();
        yield BuddiesFetchFailed(error: e);
      }
    }
  }

  Stream<BuddiesState> fetchGame({bool isLoadMore = false}) async* {
    try {
      List<Buddies> friendFetch = [];

      final data = await repository.getBuddies(LIMIT, lastDocData);
      lastDocData = data.second;
      canLoadMore = data.first.length >= LIMIT;
      if (isLoadMore) {
        currentListBuddies.removeLast();
      }
      currentListBuddies.addAll(data.first.map((e) => FriendVM(e)).toList());
      if (currentListBuddies.isEmpty) {
        yield BuddiesFetchEmpty();
      } else {
        yield BuddiesFetchSuccessful(
          listVM: currentListBuddies,
        );
      }
    } catch (error) {
      yield BuddiesFetchFailed(error: error);
    }
  }

  addNotification(SportperUser currentUser, String friendId) {
    try {
      notificationRepository.addNotification(friendId, Notification.fromFriendRequest(currentUser));
    } catch (e) {

    }
  }
}
