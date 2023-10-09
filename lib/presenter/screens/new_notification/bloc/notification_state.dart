import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_vm.dart';

class NotificationState {

}


class NotificationInitial extends NotificationState {

}

class NotificationLoading extends NotificationState {
}

class NotificationFetchSuccessful extends NotificationState {
  final List<NotificationVM?> listVM;
  NotificationFetchSuccessful({required this.listVM});
}

class NotificationFetchFailed extends NotificationState {
  final Object error;
  NotificationFetchFailed({required this.error});
}

class NotificationFetchEmpty extends NotificationState {
}

class NotificationShowLoading extends NotificationState {

}

class NotificationHideLoading extends NotificationState {

}

class NotificationChangeSuccessful extends NotificationState {
  String message;
  NotificationChangeSuccessful(this.message);
}


