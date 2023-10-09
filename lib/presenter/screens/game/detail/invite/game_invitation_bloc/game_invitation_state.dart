import 'package:sportper/presenter/screens/game/detail/invite/widgets/game_invitation_vm.dart';

class GameInvitationState {

}


class GameInvitationInitial extends GameInvitationState {

}

class GameInvitationLoading extends GameInvitationState {
}

class GameInvitationFetchSuccessful extends GameInvitationState {
  final List<GameInvitationVM> listGameInvitations;
  GameInvitationFetchSuccessful({required this.listGameInvitations});
}

class GameInvitationFetchFailed extends GameInvitationState {
  final Object error;
  GameInvitationFetchFailed({required this.error});
}

class GameInvitationFetchEmpty extends GameInvitationState {
}

class GameInvitationInviteSuccessful extends GameInvitationState {

}

class GameInvitationShowLoading extends GameInvitationState {}

class GameInvitationHideLoading extends GameInvitationState {

}


