import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/models/game_vm.dart';
import 'package:sportper/presenter/screens/shared/rx_bus_service.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/pair.dart';

import 'event.dart';
import 'state.dart';

class GameDetailOverviewBloc
    extends Bloc<GameDetailOverviewEvent, GameDetailOverviewState> {
  GameDetailVM? lastGameVM;

  GameRepository repository;
  UserRepository userRepository;
  AuthRepository authRepository;
  GameInvitationRepository gameInvitationRepository;
  NotificationRepository notificationRepository;

  final String gameId;
  final Notification? notification;

  GameDetailOverviewBloc(
      this.repository,
      this.gameId,
      this.userRepository,
      this.authRepository,
      this.notification,
      this.gameInvitationRepository,
      this.notificationRepository)
      : super(GameDetailOverviewInitial());

  @override
  Stream<GameDetailOverviewState> mapEventToState(
      GameDetailOverviewEvent event) async* {
    if (event is GameDetailOverviewFetch) {
      yield GameDetailOverviewLoading();
      yield* fetchGame();
    } else if (event is GameDetailJoin) {
      yield* mapJoin();
    } else if (event is GameDetailOverviewChangeFavourite) {
      yield* changeFavourite(event.id);
    } else if (event is GameDetailOverviewAccept) {
      try {
        await gameInvitationRepository.changeStatus(
            notification!.gameInvitationId!,
            GameInvitationStatusConst.ACCEPTED);
        await notificationRepository
            .acceptNotificationInvitation(notification?.id ?? '');
        yield GameDetailAcceptSuccessful(lastGameVM!);
      } catch (error) {
        yield GameDetailOverviewFetchFailed(error: error);
      }
    } else if (event is GameDetailOverviewDecline) {
      try {
        await gameInvitationRepository.changeStatus(
            notification!.gameInvitationId!, GameInvitationStatusConst.DECLINE);
        await notificationRepository
            .declineNotificationInvitation(notification?.id ?? '');
        yield GameDetailDeclineSuccessful();
      } catch (error) {
        yield GameDetailOverviewFetchFailed(error: error);
      }
    } else if (event is GameDetailOverviewDeletePlayer) {
      yield* mapDelete(event.userId);
    }
  }

  Stream<GameDetailOverviewState> fetchGame() async* {
    try {
      final currentUser = await userRepository.getCurrentUser();
      final userAuth = await authRepository.currentUser();

      final data = await repository.getGameDetail(gameId);
      final alreadyJoined =
          data.usersJoined.map((e) => e.id).contains(userAuth?.uid ?? "");
      final canJoin = (data.numPlayers - data.usersJoined.length) > 0 &&
          !alreadyJoined &&
          data.time.isAfter(DateTime.now()) &&
          notification?.gameInvitationId == null;
      final canInvite = (data.numPlayers - data.usersJoined.length) > 0 &&
          alreadyJoined &&
          data.time.isAfter(DateTime.now());
      final showActions = notification?.gameInvitationId != null &&
          !alreadyJoined &&
          notification?.invitationStatus == GameInvitationStatus.pending &&
          data.time.isAfter(DateTime.now());

      if (notification?.invitationStatus == GameInvitationStatus.pending &&
          alreadyJoined) {
        await gameInvitationRepository.changeStatus(
            notification!.gameInvitationId!, GameInvitationStatusConst.DECLINE);
        await notificationRepository
            .declineNotificationInvitation(notification?.id ?? '');
      }

      final players = data.usersJoined.map((e) => PlayerVM(
          e, data.createdBy == userAuth?.uid && e.id != userAuth?.uid)).toList();

      lastGameVM = GameDetailVM(data,
          isFavourite: (currentUser?.favourites ?? []).contains(data.id),
          canJoin: canJoin,
          canInvite: canInvite,
          showActions: showActions,
          playerVMs: players);
      yield GameDetailOverviewFetchSuccessful(
        gameVM: lastGameVM!,
      );
    } catch (error) {
      yield GameDetailOverviewFetchFailed(error: error);
    }
  }

  Stream<GameDetailOverviewState> mapJoin() async* {
    try {
      yield GameDetailShowLoading();
      String? currentUserId = (await authRepository.currentUser())?.uid;
      List<String> currentJoined =
          lastGameVM!.game.usersJoined.map((e) => e.id).toList();
      if (currentUserId == null || currentJoined.contains(currentUserId))
        return;
      currentJoined.add(currentUserId);
      await repository.joinGame(lastGameVM!.game.id, currentJoined);
      yield GameDetailHideLoading();
      yield GameDetailJoinSuccessful();
    } catch (error) {
      yield GameDetailHideLoading();
      yield GameDetailOverviewFetchFailed(error: error);
    }
  }

  Stream<GameDetailOverviewState> mapDelete(String user) async* {
    try {
      yield GameDetailShowLoading();
      List<String> currentJoined =
      lastGameVM!.game.usersJoined.map((e) => e.id).toList();
      if (!currentJoined.contains(user))
        return;
      currentJoined.remove(user);
      await repository.joinGame(lastGameVM!.game.id, currentJoined);
      lastGameVM!.playerVMs.removeWhere((element) => element.entity.id == user);
      yield GameDetailOverviewFetchSuccessful(
        gameVM: lastGameVM!,
      );
      yield GameDetailHideLoading();
      yield GameDetailDeleteSuccessful();

      addNotificationDelete(user);
    } catch (error) {
      yield GameDetailHideLoading();
      yield GameDetailOverviewFetchFailed(error: error);
    }
  }

  Stream<GameDetailOverviewState> changeFavourite(String id) async* {
    try {
      if (lastGameVM == null) return;
      yield GameDetailShowLoading();
      bool? result = lastGameVM!.isFavourite
          ? (await userRepository.removeFromFavourite(id))
          : (await userRepository.addToFavourite(id));
      if (result != null) {
        lastGameVM!.isFavourite = result;
        RxBusService().add(RxBusName.CHANGE_FAVOURITE, value: Pair(id, result));
        yield GameDetailHideLoading();
        yield GameDetailOverviewFetchSuccessful(
          gameVM: lastGameVM!,
        );
      }
    } catch (error) {
      yield GameDetailHideLoading();
      yield GameDetailOverviewFetchFailed(error: error);
    }
  }

  addNotificationDelete(String userId) {
    notificationRepository.addNotification(userId, Notification.fromGameRemove(lastGameVM!.game));
  }
}
