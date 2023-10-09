import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_game_vm.dart';

class NotificationGameState {

}


class NotificationGameInitial extends NotificationGameState {

}

class NotificationGameLoading extends NotificationGameState {
}

class NotificationGameFetchSuccessful extends NotificationGameState {
  final List<NotificationGameVM> listVM;
  NotificationGameFetchSuccessful({required this.listVM});
}

class NotificationGameFetchFailed extends NotificationGameState {
  final Object error;
  NotificationGameFetchFailed({required this.error});
}

class NotificationGameFetchEmpty extends NotificationGameState {
}

class NotificationGameShowLoading extends NotificationGameState {

}

class NotificationGameHideLoading extends NotificationGameState {

}


