import 'package:sportper/presenter/models/game_vm.dart';

class JoinState {

}


class JoinInitial extends JoinState {

}

class JoinLoading extends JoinState {
}

class JoinFetchSuccessful extends JoinState {
  final List<GameVM?> listJoins;
  JoinFetchSuccessful({required this.listJoins});
}

class JoinFetchFailed extends JoinState {
  final Object error;
  JoinFetchFailed({required this.error});
}

class JoinFetchEmpty extends JoinState {
}

class JoinShowLoading extends JoinState {

}

class JoinHideLoading extends JoinState {

}


