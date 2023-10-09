class NotificationFriendEvent {

}

class NotificationFriendFetch extends NotificationFriendEvent {
  NotificationFriendFetch();
}

class NotificationFriendLoadMore extends NotificationFriendEvent {
  NotificationFriendLoadMore();
}

class NotificationFriendAcceptItem extends NotificationFriendEvent {
  final String friendId;
  NotificationFriendAcceptItem(this.friendId);
}

class NotificationFriendDeclineItem extends NotificationFriendEvent {
  final String friendId;
  NotificationFriendDeclineItem(this.friendId);
}