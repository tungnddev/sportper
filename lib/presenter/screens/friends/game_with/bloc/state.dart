import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';

class GameWithState {

}


class GameWithInitial extends GameWithState {

}

class GameWithLoading extends GameWithState {
}

class GameWithFetchSuccessful extends GameWithState {
  final List<FriendGamesWithVM?> listVM;
  GameWithFetchSuccessful({required this.listVM});
}

class GameWithFetchFailed extends GameWithState {
  final Object error;
  GameWithFetchFailed({required this.error});
}

class GameWithFetchEmpty extends GameWithState {
}

class GameWithShowLoading extends GameWithState {

}

class GameWithHideLoading extends GameWithState {

}


