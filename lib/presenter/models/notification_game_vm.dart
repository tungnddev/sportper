import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/domain/entities/notification_game.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:intl/intl.dart';

class NotificationGameVM {
  String title;
  String subTitle;
  String image;
  String gameId;
  String? inviteId;
  NotificationGameVMType type;

  NotificationGameVM(
      this.title, this.subTitle, this.image, this.gameId, this.type, {this.inviteId});

  factory NotificationGameVM.fromNotification(NotificationGame _game) {
    final subTitle = _game.gameStartTime.isAfter(DateTime.now())
        ? '${Strings.startAt}: ${DateFormat('EEEE, dd MMM yyyy, hh:mm a', 'en').format(_game.gameStartTime)}'
        : Strings.thisGameAlreadyStarted;
    return NotificationGameVM(_game.title, subTitle, _game.image, _game.gameId,
        NotificationGameVMType.upcoming);
  }

  factory NotificationGameVM.fromInvitation(GameInvitation _game) {
    return NotificationGameVM(_game.gameTitle, _game.content, _game.gameImage, _game.gameId,
        NotificationGameVMType.invite, inviteId: _game.id);
  }
}

enum NotificationGameVMType { upcoming, invite }
