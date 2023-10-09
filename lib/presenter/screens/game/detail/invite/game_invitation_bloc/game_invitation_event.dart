class GameInvitationEvent {

}

class GameInvitationFetch extends GameInvitationEvent {
  GameInvitationFetch();
}

class GameInvitationSend extends GameInvitationEvent {
  final int position;
  final String buddyId;
  GameInvitationSend(this.position, this.buddyId);
}