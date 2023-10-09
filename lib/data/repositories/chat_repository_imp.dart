import 'package:sportper/data/remote/mapper/chat_mapper.dart';
import 'package:sportper/data/remote/services/chat_service.dart';
import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/domain/repositories/chat_repository.dart';
import 'package:sportper/utils/pair.dart';

class ChatRepositoryImp extends ChatRepository {
  ChatRepositoryImp._privateConstructor();

  static final ChatRepository instance =
      ChatRepositoryImp._privateConstructor();

  ChatMapper mapper = ChatMapper();
  ChatService service = ChatService.instance;

  @override
  Future<Pair<List<ChatMessage>, Map<String, dynamic>?>> getList(
      int limit, Map<String, dynamic>? lastDocData, String gameId) async {
    final result = await service.getList(limit, lastDocData, gameId);
    final listFriendsWithGame =
        result.first.map((e) => mapper.mapMessage(e)).toList();
    return Pair(listFriendsWithGame, result.second);
  }

  @override
  Future sendMessage(String gameId, ChatMessage chatMessage) async {
    await service.addMessage(gameId, mapper.reMapMessage(chatMessage));
  }
}
