import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/const.dart';

class Buddies {
  String avatar;
  String id;
  String fullName;
  FriendStatus status;
  String phoneNumber;
  DateTime createdAt;

  Buddies(this.id, this.avatar, this.phoneNumber, this.fullName, this.status, this.createdAt);
}

enum FriendStatus {
  not_exist, accepted, decline, sent_invitation
}

extension Convert on FriendStatus {
  String raw() {
    switch (this) {
      case FriendStatus.not_exist:
        return FriendStatusConst.NOT_EXIST;
      case FriendStatus.accepted:
        return FriendStatusConst.ACCEPTED;
      case FriendStatus.decline:
        return FriendStatusConst.DECLINE;
      case FriendStatus.sent_invitation:
        return FriendStatusConst.SENT_INVITATION;
    }
  }
}