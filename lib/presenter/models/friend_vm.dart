import 'dart:ui';

import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';

class FriendVM {
  Buddies _friend;

  FriendVM(this._friend);

  Buddies get friend => _friend;

  String get phoneNumber => _friend.phoneNumber.isNotEmpty ? _friend.phoneNumber : Strings.noPhone;

  String get statusText {
    switch (_friend.status) {
      case FriendStatus.not_exist:
        return Strings.notExist;
      case FriendStatus.accepted:
        return Strings.accept;
      case FriendStatus.decline:
        return Strings.decline;
      case FriendStatus.sent_invitation:
        return Strings.sentInvitation;
    }
  }

  Color get colorStatus {
    switch (_friend.status) {
      case FriendStatus.not_exist:
        return ColorUtils.disableText;
      case FriendStatus.accepted:
        return ColorUtils.green;
      case FriendStatus.decline:
        return ColorUtils.red;
      case FriendStatus.sent_invitation:
        return ColorUtils.blueTheme;
    }
  }
}