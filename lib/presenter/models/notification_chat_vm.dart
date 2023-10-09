import 'package:sportper/domain/entities/notification_chat.dart';
import 'package:intl/intl.dart';

class NotificationChatVM {
  NotificationChat _chat;

  NotificationChatVM(this._chat);

  NotificationChat get data => _chat;

  String get date => DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(_chat.createdAt);
}