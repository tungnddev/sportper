import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';

class GameDetailOverviewState {

}


class GameDetailOverviewInitial extends GameDetailOverviewState {

}

class GameDetailOverviewLoading extends GameDetailOverviewState {
}

class GameDetailOverviewFetchSuccessful extends GameDetailOverviewState {
  final GameDetailVM gameVM;
  GameDetailOverviewFetchSuccessful({required this.gameVM});
}

class GameDetailOverviewFetchFailed extends GameDetailOverviewState {
  final Object error;
  GameDetailOverviewFetchFailed({required this.error});
}

class GameDetailShowLoading extends GameDetailOverviewState {

}

class GameDetailHideLoading extends GameDetailOverviewState {

}

class GameDetailJoinSuccessful extends GameDetailOverviewState {

}

class GameDetailDeleteSuccessful extends GameDetailOverviewState {

}

class GameDetailAcceptSuccessful extends GameDetailOverviewState {
  GameDetailVM lastGameVM;
  GameDetailAcceptSuccessful(this.lastGameVM);
}

class GameDetailDeclineSuccessful extends GameDetailOverviewState {

}


