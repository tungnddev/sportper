import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/friend_with_game.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/friends_game_with_vm.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/models/notification_friend_vm.dart';
import 'package:sportper/presenter/models/notification_game_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/pair.dart';

import 'event.dart';
import 'state.dart';

class NotificationGameBloc
    extends Bloc<NotificationGameEvent, NotificationGameState> {
  List<NotificationGameVM> currentListNotificationGame = [];

  NotificationRepository repository;
  GameInvitationRepository invitationRepository;

  NotificationGameBloc(this.repository, this.invitationRepository) : super(NotificationGameInitial());

  @override
  Stream<NotificationGameState> mapEventToState(
      NotificationGameEvent event) async* {
    if (event is NotificationGameFetch) {
      currentListNotificationGame = [];
      yield NotificationGameLoading();
      yield* fetchGame();
    }
  }

  Stream<NotificationGameState> fetchGame() async* {
    try {
      final data = await repository.getAllNotificationGames();
      final invites = await invitationRepository.getListPending();
      currentListNotificationGame
          .addAll(data.map((e) => NotificationGameVM.fromNotification(e)).toList());
      currentListNotificationGame
          .addAll(invites.map((e) => NotificationGameVM.fromInvitation(e)).toList());
      if (currentListNotificationGame.isEmpty) {
        yield NotificationGameFetchEmpty();
      } else {
        yield NotificationGameFetchSuccessful(
          listVM: currentListNotificationGame,
        );
      }
    } catch (error) {
      yield NotificationGameFetchFailed(error: error);
    }
  }
}
