class NotificationChatEvent {

}

class NotificationChatFetch extends NotificationChatEvent {
  NotificationChatFetch();
}

class NotificationChatLoadMore extends NotificationChatEvent {
  NotificationChatLoadMore();
}

class NotificationChatAcceptItem extends NotificationChatEvent {
  final int position;
  NotificationChatAcceptItem(this.position);
}