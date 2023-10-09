import 'package:sportper/domain/entities/notification.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class NotificationVM {
  Notification entity;

  NotificationVM(this.entity);

  String get date =>
      DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(entity.createdAt);
}

class NotificationGameVM extends NotificationVM {
  NotificationGameVM(Notification entity) : super(entity);

  String get subTitle {
    if (entity.gameStartTime == null) return '';
    return entity.gameStartTime!.isAfter(DateTime.now())
        ? '${Strings.startAt}: ${DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(entity.gameStartTime!)}'
        : Strings.thisGameAlreadyStarted;
  }
}

