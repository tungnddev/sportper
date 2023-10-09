import 'package:sportper/domain/entities/notification_friend.dart';

class NotificationFriendVM {
  String avatar;
  String name;
  String address;
  String note;
  String friendId;

  NotificationFriendVM(this.avatar, this.name, this.address, this.note, this.friendId);

  factory NotificationFriendVM.fromEntity(NotificationFriend model) {
    return NotificationFriendVM(model.friend.avatar, model.friend.fullName, model.friend.phoneNumber, '', model.friend.id);
  }
}