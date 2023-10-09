import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sportper/data/models/chat_message_model.dart';
import 'package:sportper/utils/pair.dart';

class ChatService {
  ChatService._privateConstructor();

  static const String GAMES_COLLECTION = "games";

  static const String CHATS_COLLECTION = "chats";

  static final ChatService instance = ChatService._privateConstructor();

  static final CollectionReference _gamesCollection =
  FirebaseFirestore.instance.collection(GAMES_COLLECTION);

  Future<Pair<List<ChatMessageModel>, Map<String, dynamic>?>> getList(
      int limit, Map<String, dynamic>? lastDocData, String gameId) async {
    var query = _gamesCollection
        .doc(gameId)
        .collection(CHATS_COLLECTION)
        .orderBy('createdAt', descending: true);

    if (lastDocData != null) {
      query = query.startAfter([lastDocData['createdAt']]);
    }

    final snap = await query.limit(limit).get();

    final currentLastElement = snap.docs.isEmpty ? null : snap.docs.last.data();

    final listMatch = snap.docs.map((e) {
      var model = ChatMessageModel.fromJson(e.data());
      model.id = e.id;
      return model;
    }).toList();

    return Pair(listMatch, currentLastElement);
  }

  Future addMessage(String gameId, ChatMessageModel model) async {
    await _gamesCollection.doc(gameId).collection(CHATS_COLLECTION).add(model.toJson());
  }

}