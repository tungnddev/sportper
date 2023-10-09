import 'chat_bloc.dart';

class ChatEvent{}

class ChatLoad extends ChatEvent {
  ChatLoad();
}

class ChatLoadMore extends ChatEvent{}

class ChatAddNewMessageParse extends ChatEvent{
  final Map<String, dynamic> data;
  final String id;
  ChatAddNewMessageParse({required this.data, required this.id});
}

class ChatSendMessage extends ChatEvent {
  final String content;
  ChatSendMessage({required this.content});
}

class ChatRefreshMessage extends ChatEvent {
}
