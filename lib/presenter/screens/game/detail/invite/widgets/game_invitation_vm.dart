import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sportper/domain/entities/buddies.dart';
import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/utils/definded/colors.dart';
import 'package:sportper/utils/definded/strings.dart';

class GameInvitationVM {
  Buddies _buddies;
  GameInvitationStatus? status;

  Buddies get buddies => _buddies;

  bool get isShowButton => status == null;

  String get statusText {
    switch (status) {
      case GameInvitationStatus.pending:
        return Strings.sentInvitation;
      case GameInvitationStatus.accepted:
        return Strings.accept;
      case GameInvitationStatus.decline:
        return Strings.decline;
      case null:
        return '';
    }
  }

  Color get colorStatus {
    switch (status) {
      case GameInvitationStatus.pending:
        return ColorUtils.blueTheme;
      case GameInvitationStatus.accepted:
        return ColorUtils.green;
      case GameInvitationStatus.decline:
        return ColorUtils.red;
      case null:
        return Colors.transparent;
    }
  }

  GameInvitationVM(this._buddies, this.status);
}
