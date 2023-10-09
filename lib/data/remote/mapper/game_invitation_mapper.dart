import 'package:sportper/data/models/game_invitation_model.dart';
import 'package:sportper/domain/entities/game_invitation.dart';
import 'package:sportper/utils/definded/const.dart';

class GameInvitationMapper {
  GameInvitationMapper._privateConstructor();

  static final GameInvitationMapper _instance =
      GameInvitationMapper._privateConstructor();

  factory GameInvitationMapper() {
    return _instance;
  }

  DateTime _defaultDate = DateTime(1970);

  GameInvitation mapInvitation(GameInvitationModel? model) {
    return GameInvitation(
        model?.id ?? '',
        model?.gameId ?? '',
        model?.gameTitle ?? '',
        model?.gameImage ?? '',
        DateTime.tryParse(model?.gameStartTime ?? '')?.toLocal() ??
            _defaultDate,
        model?.senderId ?? '',
        model?.receiverId ?? '',
        DateTime.tryParse(model?.createdAt ?? '')?.toLocal() ?? _defaultDate,
        mapStatus(model?.status),
        model?.content ?? '');
  }

  GameInvitationModel reMapInvitation(GameInvitation model,
      {bool isIncludeId = false}) {
    return GameInvitationModel(
        isIncludeId ? model.id : null,
        model.gameId,
        model.gameTitle,
        model.gameImage,
        model.gameStartTime.toUtc().toIso8601String(),
        model.senderId,
        model.receiverId,
        model.createdAt.toUtc().toIso8601String(),
        remapStatus(model.status),
        model.content);
  }

  GameInvitationStatus mapStatus(String? status) {
    switch (status) {
      case GameInvitationStatusConst.ACCEPTED:
        return GameInvitationStatus.accepted;
      case GameInvitationStatusConst.DECLINE:
        return GameInvitationStatus.decline;
    }
    return GameInvitationStatus.pending;
  }

  String remapStatus(GameInvitationStatus status) {
    switch (status) {
      case GameInvitationStatus.pending:
        return GameInvitationStatusConst.PENDING;
      case GameInvitationStatus.accepted:
        return GameInvitationStatusConst.ACCEPTED;
      case GameInvitationStatus.decline:
        return GameInvitationStatusConst.DECLINE;
    }
  }
}
