import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/game_invitation_model.dart';

class GameInvitationService {
  GameInvitationService._privateConstructor();

  static const String INVITATION_COLLECTION = "gameInvitations";

  static final GameInvitationService instance =
      GameInvitationService._privateConstructor();

  static final CollectionReference _invitationCollection =
      FirebaseFirestore.instance.collection(INVITATION_COLLECTION);

  Future<String> create(GameInvitationModel model) async {
    final doc = await _invitationCollection.add(model.toJson());
    return doc.id;
  }

  Future<List<GameInvitationModel>> getList(
      {String? senderId,
      String? receiverId,
      String? gameId,
      String? status,
      String? notEqualStatus}) async {
    var query = _invitationCollection.where('gameStartTime', isGreaterThan: DateTime.now().toUtc().toIso8601String());
    if (senderId != null) {
      query = query.where('senderId', isEqualTo: senderId);
    }
    if (receiverId != null) {
      query = query.where('receiverId', isEqualTo: receiverId);
    }
    if (gameId != null) {
      query = query.where('gameId', isEqualTo: gameId);
    }
    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }
    if (notEqualStatus != null) {
      query = query.where('status', isNotEqualTo: notEqualStatus);
    }
    final result = await query.get();
    return result.docs.map((e) {
      var model =
          GameInvitationModel.fromJson(e.data() as Map<String, dynamic>);
      model.id = e.id;
      return model;
    }).toList();
  }

  Future changeStatus(String id, String status) async {
    await _invitationCollection.doc(id).update({"status": status});
  }

}
