import 'package:sportper/domain/entities/game.dart';
import 'package:sportper/domain/entities/game_invitation.dart';

abstract class GameInvitationRepository {
  Future<List<GameInvitation>> getListPending();
  Future<List<GameInvitation>> getListByGameId(String gameId);
  Future changeStatus(String id, String status);
  Future<String> createInvitation(GameInvitation model);
  Future createInvitationToAllFriend(Game game, String senderId, String senderName);
}