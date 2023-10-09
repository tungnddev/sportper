import 'package:sportper/data/models/chat_message_model.dart';
import 'package:sportper/domain/entities/chat_message.dart';

class ChatMapper {
  ChatMapper._privateConstructor();

  static final ChatMapper _instance = ChatMapper._privateConstructor();

  factory ChatMapper() {
    return _instance;
  }

  ChatMessage mapMessage(ChatMessageModel? model) {
    return ChatMessage(
        model?.id ?? '',
        model?.content ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? DateTime(1970),
        model?.senderId ?? '',
        mapType(model?.type));
  }

  ChatMessageModel reMapMessage(ChatMessage model, {bool isIncludeId = false}) {
    return ChatMessageModel(
        isIncludeId ? model.id : null,
        model.content,
        model.createdAt.toUtc().toIso8601String(),
        model.senderId,
        remapType(model.type));
  }

  ChatMessageType mapType(String? type) {
    switch (type) {
      case 'TEXT':
        return ChatMessageType.TEXT;
      case 'JOIN':
        return ChatMessageType.JOIN;
    }
    return ChatMessageType.TEXT;
  }

  String remapType(ChatMessageType type) {
    switch (type) {
      case ChatMessageType.TEXT:
        return 'TEXT';
      case ChatMessageType.JOIN:
        return 'JOIN';
    }
  }
}
