class ChatMessage {
  String id;
  String content;
  String senderId;
  DateTime createdAt;
  ChatMessageType type;

  ChatMessage(this.id, this.content, this.createdAt, this.senderId, this.type);
}

enum ChatMessageType {
  TEXT, JOIN
}