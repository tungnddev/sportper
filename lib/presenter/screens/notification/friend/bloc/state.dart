import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';

class NotificationFriendState {

}


class NotificationFriendInitial extends NotificationFriendState {

}

class NotificationFriendLoading extends NotificationFriendState {
}

class NotificationFriendFetchSuccessful extends NotificationFriendState {
  final List<NotificationFriendVM?> listVM;
  NotificationFriendFetchSuccessful({required this.listVM});
}

class NotificationFriendFetchFailed extends NotificationFriendState {
  final Object error;
  NotificationFriendFetchFailed({required this.error});
}

class NotificationFriendFetchEmpty extends NotificationFriendState {
}

class NotificationFriendShowLoading extends NotificationFriendState {

}

class NotificationFriendHideLoading extends NotificationFriendState {

}

class NotificationFriendChangeSuccessful extends NotificationFriendState {
  String message;
  NotificationFriendChangeSuccessful(this.message);
}


