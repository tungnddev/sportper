import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/game/detail/invite/widgets/game_invitation_vm.dart';

import 'game_invitation_event.dart';
import 'game_invitation_state.dart';
import 'package:collection/collection.dart';

class GameInvitationBloc
    extends Bloc<GameInvitationEvent, GameInvitationState> {
  List<GameInvitationVM> currentListGameInvitation = [];

  GameInvitationRepository repository;
  FriendRepository friendRepository;
  UserRepository userRepository;
  NotificationRepository notificationRepository;

  Game game;

  GameInvitationBloc(
      this.repository, this.friendRepository, this.game, this.userRepository, this.notificationRepository)
      : super(GameInvitationInitial());

  @override
  Stream<GameInvitationState> mapEventToState(
      GameInvitationEvent event) async* {
    if (event is GameInvitationFetch) {
      currentListGameInvitation = [];
      yield GameInvitationLoading();
      yield* fetchGameInvitation();
    } else if (event is GameInvitationSend) {
      try {
        yield GameInvitationShowLoading();
        final currentUser = await userRepository.getCurrentUser();
        final invitation = GameInvitation.fromGame(game,
            currentUser?.id ?? '', event.buddyId, currentUser?.fullName ?? '');
        final id = await repository.createInvitation(invitation);
        if (currentListGameInvitation[event.position].status == null) {
          currentListGameInvitation[event.position].status =
              GameInvitationStatus.pending;
        }
        yield GameInvitationHideLoading();
        yield GameInvitationFetchSuccessful(
            listGameInvitations: currentListGameInvitation);
        yield GameInvitationInviteSuccessful();

        // add notification
        addNotification(id, invitation, currentUser?.fullName ?? '');
      } catch (error) {
        yield GameInvitationHideLoading();
        yield GameInvitationFetchFailed(error: error);
      }
    }
  }

  Stream<GameInvitationState> fetchGameInvitation() async* {
    try {
      final listBuddies = await friendRepository.getBuddiesExist();
      final currentInvitation = await repository.getListByGameId(game.id);
      currentListGameInvitation = listBuddies.map((e) {
        final status = currentInvitation
            .firstWhereOrNull((element) => element.receiverId == e.id)
            ?.status;
        return GameInvitationVM(e, status);
      }).toList();
      yield GameInvitationFetchSuccessful(
          listGameInvitations: currentListGameInvitation);
    } catch (error) {
      yield GameInvitationFetchFailed(error: error);
    }
  }

  addNotification(String invitationId, GameInvitation invitation, String senderName) {
    notificationRepository.addNotification(invitation.receiverId, Notification.fromInvitation(invitationId, invitation, senderName));
  }
}
