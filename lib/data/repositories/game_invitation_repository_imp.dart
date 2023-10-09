import 'package:sportper/data/remote/mapper/game_invitation_mapper.dart';
import 'package:sportper/data/remote/mapper/notification_mapper.dart';
import 'package:sportper/data/remote/services/auth_service.dart';
import 'package:sportper/data/remote/services/game_inivitation_service.dart';
import 'package:sportper/data/remote/services/notification_service.dart';
import 'package:sportper/data/remote/services/user_service.dart';
import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/game_invitation_repository.dart';
import 'package:sportper/utils/definded/const.dart';

class GameInvitationRepositoryImp extends GameInvitationRepository {
  GameInvitationRepositoryImp._privateConstructor();

  static final GameInvitationRepository instance =
      GameInvitationRepositoryImp._privateConstructor();

  GameInvitationMapper mapper = GameInvitationMapper();
  NotificationMapper notificationMapper = NotificationMapper();
  GameInvitationService service = GameInvitationService.instance;
  NotificationService notificationService = NotificationService.instance;
  AuthService _authService = AuthService.instance;
  UserService _userService = UserService.instance;

  @override
  Future changeStatus(String id, String status) async {
    return service.changeStatus(id, status);
  }

  @override
  Future<List<GameInvitation>> getListByGameId(String gameId) async {
    final String userId = (await _authService.currentUser())?.uid ?? '';
    return service
        .getList(senderId: userId, gameId: gameId)
        .then((value) => value.map((e) => mapper.mapInvitation(e)).toList());
  }

  @override
  Future<List<GameInvitation>> getListPending() async {
    final String userId = (await _authService.currentUser())?.uid ?? '';
    return service
        .getList(receiverId: userId, status: GameInvitationStatusConst.PENDING)
        .then((value) => value.map((e) => mapper.mapInvitation(e)).toList());
  }

  @override
  Future<String> createInvitation(GameInvitation model) {
    return service.create(mapper.reMapInvitation(model));
  }

  @override
  Future createInvitationToAllFriend(Game game, String senderId, String senderName) async {
    final listUser = await _userService.getAllBuddiesExist(senderId);
    listUser.forEach((element) async {
      try {
        if (element.id != null)  {
          GameInvitation model = (GameInvitation.fromGame(game, senderId, element.id!, senderName));
          final id = await createInvitation(model);
          final notification = Notification.fromInvitation(id, model, senderName);
          await notificationService.addNotification(element.id!, notificationMapper.reMapNotification(notification));
        }
      } catch (e) {

      }
    });
  }
}
