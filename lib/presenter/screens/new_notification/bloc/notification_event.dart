class NotificationEvent {

}

class NotificationFetch extends NotificationEvent {
  NotificationFetch();
}

class NotificationLoadMore extends NotificationEvent {
  NotificationLoadMore();
}

class NotificationAcceptItem extends NotificationEvent {
  final String id;
  final String friendId;
  NotificationAcceptItem(this.id, this.friendId);
}

class NotificationDeclineItem extends NotificationEvent {
  final String id;
  final String friendId;

  NotificationDeclineItem(this.id, this.friendId);
}