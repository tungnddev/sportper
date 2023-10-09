import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_chat_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';

class NotificationChatState {

}


class NotificationChatInitial extends NotificationChatState {

}

class NotificationChatLoading extends NotificationChatState {
}

class NotificationChatFetchSuccessful extends NotificationChatState {
  final List<NotificationChatVM?> listVM;
  NotificationChatFetchSuccessful({required this.listVM});
}

class NotificationChatFetchFailed extends NotificationChatState {
  final Object error;
  NotificationChatFetchFailed({required this.error});
}

class NotificationChatFetchEmpty extends NotificationChatState {
}

class NotificationChatShowLoading extends NotificationChatState {

}

class NotificationChatHideLoading extends NotificationChatState {

}


