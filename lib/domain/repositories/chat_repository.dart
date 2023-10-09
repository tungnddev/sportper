import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/utils/pair.dart';

abstract class ChatRepository {
  Future<Pair<List<ChatMessage>, Map<String, dynamic>?>> getList(
      int limit, Map<String, dynamic>? lastDocData, String gameId);
  Future sendMessage(String gameId, ChatMessage chatMessage);
}