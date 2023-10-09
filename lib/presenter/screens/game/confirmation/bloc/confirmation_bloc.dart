import 'package:bloc/bloc.dart';
import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/chat_repository.dart';
import 'package:sportper/domain/repositories/friend_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/domain/request/request_notification_chat.dart';
import 'package:sportper/domain/request/request_notification_game.dart';
import 'package:sportper/presenter/models/game_detail_vm.dart';
import 'package:sportper/presenter/screens/shared/notification_service.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/strings.dart';

import 'confirmation_event.dart';
import 'confirmation_state.dart';


class ConfirmationBloc
    extends Bloc<ConfirmationEvent, ConfirmationState> {

  GameRepository repository;
  AuthRepository authRepository;
  FriendRepository friendRepository;
  ChatRepository chatRepository;
  UserRepository userRepository;
  NotificationRepository notificationRepository;

  ConfirmationBloc(
      this.repository, this.authRepository, this.friendRepository, this.chatRepository, this.userRepository, this.notificationRepository)
      : super(ConfirmationInitial());

  @override
  Stream<ConfirmationState> mapEventToState(
      ConfirmationEvent event) async* {
    if (event is ConfirmationJoin) {
      yield* mapJoin(event.gameDetailVM);
    }
  }

  Stream<ConfirmationState> mapJoin(GameDetailVM lastGameVM) async* {
    try {
      yield ConfirmationShowLoading();
      String? currentUserId = (await authRepository.currentUser())?.uid;
      List<String> currentJoined = lastGameVM.game.usersJoined.map((e) => e.id).toList();
      if (currentUserId == null || currentJoined.contains(currentUserId)) return;
      await friendRepository.addOtherToUser(currentJoined, currentUserId, lastGameVM.game.time);
      await friendRepository.addUserToOther(currentJoined, currentUserId, lastGameVM.game.time);

      currentJoined.add(currentUserId);
      await repository.joinGame(lastGameVM.game.id, currentJoined);
      yield ConfirmationHideLoading();
      yield ConfirmationJoinSuccessful();

      addJoinMessage(lastGameVM.game.id);
      addNotificationGame(lastGameVM.game);
      addSchedulerLocalNotification(lastGameVM.game);
      addNotificationChatToTheOtherUser(lastGameVM.game);
    } catch (error) {
      yield ConfirmationHideLoading();
      yield ConfirmationFetchFailed(error: error);
    }
  }

  // other thread
  addJoinMessage(String gameId) async {
    try {
      // send message join
      final user = await userRepository.getCurrentUser();
      ChatMessage chatMessage = ChatMessage('', '${user?.fullName ?? Strings.account} ${Strings.joinTheGame}', DateTime.now(),
          user?.id ?? '', ChatMessageType.JOIN);
      chatRepository.sendMessage(gameId, chatMessage);
    } catch (error) {
      print(error);
    }
  }

  // add To Other
  addNotificationChatToTheOtherUser(Game game) async {
    final user = await userRepository.getCurrentUser();
    final listOtherUsers = game.usersJoined.map((e) => e.id).where((element) => element != user?.id).toList();
    notificationRepository.addNotificationChat(listOtherUsers, game.id, Notification.fromChat(game, '${user?.fullName ?? Strings.account} ${Strings.joinTheGame}'));
  }

  // other thread
  addNotificationGame(Game game) async {
    try {
      final user = await userRepository.getCurrentUser();
      notificationRepository.addNotification(user?.id ?? '', Notification.fromGame(game));
    } catch (error) {
      print(error);
    }
  }

  // other thread
  addSchedulerLocalNotification(Game game) async {
    try {
      NotificationService.instance.scheduleGameNotification('Sportper',
          'You have ${game.title} game in 10 minutes', game.time.subtract(NotificationGameConst.duration), game.id);
    } catch (error) {
      print(error);
    }
  }
}
