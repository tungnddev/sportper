import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_player.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/domain/repositories/game_repository.dart';
import 'package:sportper/domain/repositories/notification_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/domain/request/request_notification_game.dart';
import 'package:sportper/presenter/models/course_vm.dart';
import 'package:sportper/presenter/screens/shared/notification_service.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/definded/const.dart';
import 'package:sportper/utils/definded/game_image.dart';
import 'package:sportper/domain/entities/notification.dart' as N;
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/extensions/date.dart';

import 'new_game_event.dart';
import 'new_game_state.dart';

class NewGameBloc extends Bloc<NewGameEvent, NewGameState> {
  BuildContext context;
  GameRepository gameRepository;
  AuthRepository authRepository;
  UserRepository userRepository;
  NotificationRepository notificationRepository;
  GameInvitationRepository gameInvitationRepository;

  NewGameBloc(
      this.context,
      this.gameRepository,
      this.authRepository,
      this.userRepository,
      this.notificationRepository,
      this.gameInvitationRepository)
      : super(NewGameInitial());

  @override
  Stream<NewGameState> mapEventToState(NewGameEvent event) async* {
    if (event is NewGameStartNewGame) {
      try {
        yield NewGameLoading();
        final isValidHandicap = (event.data['minHandicap'] as int) <= (event.data['maxHandicap'] as int);
        if (!isValidHandicap) {
          yield NewGameHideLoading();
          yield NewGameFailMessage(Strings.invalidHandicap);
          return;
        }
        final newGame = await getNewGameByMap(event.data);
        final id = await gameRepository.createGame(newGame);
        newGame.id = id;
        yield NewGameHideLoading();

        addNotificationGame(newGame);
        addSchedulerLocalNotification(newGame);
        // add notification game as join
        if (event.data['invite'] == true) {
          addInvitationToFriends(newGame);
        }
        yield NewGameSuccessful();
      } catch (error) {
        yield NewGameHideLoading();
        yield (NewGameFail(error));
      }
    }
  }

  Future<Game> getNewGameByMap(Map<String, dynamic> data) async {
    SportperUser? user = await userRepository.getCurrentUser();
    final date = data['date'] as DateTime;
    final time = data['time'] as DateTime;
    final dateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final course = (data['course'] as CourseVM).course;
    return Game(
        '',
        data['gameName'],
        course.clubName,
        GameImageGenerate.get(),
        data['booked'],
        data['tournament'],
        data['type'],
        course,
        data['numPlayers'],
        0,
        [
          GamePlayer(user?.avatar ?? '', user?.id ?? '', user?.fullName ?? '',
              user?.handicap ?? 0, user?.birthday?.age ?? 0)
        ],
        user?.id ?? '',
        DateTime.now(),
        dateTime,
        data['smoke'],
        data['gamble'],
        data['drink'],
        data['minHandicap'],
        data['maxHandicap'],
        GameHost(
            user?.id ?? '',
            user?.fullName ?? '',
            user?.avatar ?? '',
            user?.phoneNumber ?? '',
            user?.handicap ?? 0,
            user?.birthday?.age ?? 0));
  }

  // other thread
  addNotificationGame(Game game) async {
    try {
      final user = await userRepository.getCurrentUser();
      notificationRepository.addNotification(
          user?.id ?? '', N.Notification.fromGame(game));
    } catch (error) {
      print(error);
    }
  }

  // other thread
  addSchedulerLocalNotification(Game game) async {
    try {
      NotificationService.instance.scheduleGameNotification(
          'Sportper',
          'You have ${game.title} game in 10 minutes',
          game.time.subtract(NotificationGameConst.duration),
          game.id);
    } catch (error) {
      print(error);
    }
  }

  addInvitationToFriends(Game game) async {
    try {
      final user = await userRepository.getCurrentUser();
      gameInvitationRepository.createInvitationToAllFriend(
          game, user?.id ?? '', user?.fullName ?? '');
    } catch (error) {
      print(error);
    }
  }
}
