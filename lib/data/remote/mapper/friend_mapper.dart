import 'package:sportper/data/models/buddies_model.dart';
import 'package:sportper/data/models/friend_with_game_model.dart';
import 'package:sportper/data/models/request_add_buddy_model.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/const.dart';

class FriendMapper {
  FriendMapper._privateConstructor();

  static final FriendMapper _instance = FriendMapper._privateConstructor();

  factory FriendMapper() {
    return _instance;
  }

  DateTime _defaultDate = DateTime(1970);

  FriendWithGame mapFriendWithGame(FriendsWithGameModel? model, SportperUser user) {
    return FriendWithGame(
        user,
        DateTime.tryParse(model?.lastPlayDate ?? '')?.toLocal() ??
            _defaultDate);
  }

  // FriendsWithGameModel reMapFriendWithGame(String userId, DateTime lastDate, {bool isIncludeId = false} ) {
  //   return FriendsWithGameModel(
  //     id: isIncludeId ? userId : null,
  //     lastPlayDate: lastDate.toUtc().toIso8601String()
  //   );
  // }

  Buddies mapNotExistBuddies(BuddiesModel? model) {
    return Buddies(
        model?.id ?? '',
        model?.avatar ?? '',
        model?.phoneNumber ?? '',
        model?.fullName ?? '',
        mapStatus(model?.status),
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate);
  }

  Buddies mapExistBuddies(BuddiesModel? model, SportperUser? user) {
    return Buddies(
        model?.id ?? '',
        user?.avatar ?? '',
        user?.phoneNumber ?? '',
        model?.fullName ?? '',
        mapStatus(model?.status),
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate);
  }

  FriendStatus mapStatus(String? status) {
    switch (status) {
      case FriendStatusConst.NOT_EXIST:
        return FriendStatus.not_exist;
      case FriendStatusConst.ACCEPTED:
        return FriendStatus.accepted;
      case FriendStatusConst.DECLINE:
        return FriendStatus.decline;
      case FriendStatusConst.SENT_INVITATION:
        return FriendStatus.sent_invitation;
      default:
        return FriendStatus.not_exist;
    }
  }

  RequestAddBuddyModel mapToRequestAddBuddy(Buddies buddies) {
    if (buddies.status == FriendStatus.not_exist) {
      return RequestAddBuddyModel(
          status: buddies.status.raw(),
          fullName: buddies.fullName,
          phoneNumber: buddies.phoneNumber,
          avatar: buddies.avatar,
          createdAt: buddies.createdAt.toUtc().toIso8601String()
      );
    } else {
      return RequestAddBuddyModel(
          createdAt: buddies.createdAt.toUtc().toIso8601String(),
          fullName: buddies.fullName,
          status: buddies.status.raw()
      );
    }
  }
}
