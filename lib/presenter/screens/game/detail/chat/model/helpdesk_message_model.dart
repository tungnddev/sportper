import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/chat_message.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class ChatMessageVM {
  String id;
  String content;
  bool isOwn;
  String sendTime;
  SportperUser? member;
  ChatMessageType chatMessageType;

  ChatMessageVM(
      {required this.id,
      required this.content,
      required this.isOwn,
      required this.sendTime,
      required this.member,
      required this.chatMessageType});

  get displayName {
    return member?.fullName ?? Strings.account;
  }

  factory ChatMessageVM.fromCacheMessage(String content, SportperUser member) {
    return ChatMessageVM(
        id: "",
        content: content,
        isOwn: true,
        sendTime: DateTime.now().toIso8601String(),
        member: member,
        chatMessageType: ChatMessageType.TEXT);
  }
}
