import '../model/helpdesk_message_model.dart';

abstract class ChatState {}

class ChatInitial extends ChatState{
}

class ChatLoading extends ChatState{
}

class ChatLoadEmpty extends ChatState{
}

class ChatLoadSuccessful extends ChatState {
  final List<ChatMessageVM?> messages;
  final bool mustScrollToEnd;
  ChatLoadSuccessful({required this.messages, this.mustScrollToEnd = true});
}

class ChatLoadError extends ChatState{
  final Object error;
  ChatLoadError({required this.error});
}

class ChatSendMessageError extends ChatState{
  final Object error;
  ChatSendMessageError({required this.error});
}

class ChatStartListen extends ChatState {

}

