import 'package:sportper/presenter/models/game_vm.dart';

class MyGameState {

}


class MyGameInitial extends MyGameState {

}

class MyGameLoading extends MyGameState {
}

class MyGameFetchSuccessful extends MyGameState {
  final List<GameVM?> listMyGame;
  MyGameFetchSuccessful({required this.listMyGame});
}

class MyGameFetchFailed extends MyGameState {
  final Object error;
  MyGameFetchFailed({required this.error});
}

class MyGameFetchEmpty extends MyGameState {
}

class MyGameShowLoading extends MyGameState {

}

class MyGameHideLoading extends MyGameState {

}


