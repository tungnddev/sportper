class TypeConst {
  static const FOOT_BALL = 'FOOT_BALL';
  static const BADMINTON = 'BADMINTON';
  static const TENNIS = 'TENNIS';
  static const GOLF = 'GOLF';
  static const VOLLEYBALL = 'VOLLEYBALL';
  static const BASKETBALL = 'BASKETBALL';
}

class FriendStatusConst {
  static const NOT_EXIST = 'NOT_EXIST';
  static const ACCEPTED = 'ACCEPTED';
  static const DECLINE = 'DECLINE';
  static const SENT_INVITATION = 'SENT_INVITATION';
}

class NotificationFriendStatusConst {
  static const PENDING = 'PENDING';
  static const ACCEPTED = 'ACCEPTED';
  static const DECLINE = 'DECLINE';
}

class NotificationGameConst {
  static const duration = const Duration(minutes: 10);
  static const TYPE_UPCOMING = 'UPCOMING';
  static const TYPE_INVITED = 'INVITED';
}

class NotificationTypeConst {
  static const CHAT_NOTIFICATION = 'CHAT_NOTIFICATION';
  static const FRIEND_NOTIFICATION = 'FRIEND_NOTIFICATION';
  static const GAME_NOTIFICATION = 'GAME_NOTIFICATION';
  static const GAME_INVITATION = 'GAME_INVITATION';
  static const GAME_REMOVED = 'GAME_REMOVED';
}

class NotificationParamsConst {
  static const GAME_ID = 'gameId';
  static const TYPE = 'type';
}

class GameInvitationStatusConst {
  static const PENDING = 'PENDING';
  static const ACCEPTED = 'ACCEPTED';
  static const DECLINE = 'DECLINE';
}

class PostTypeConst {
  static const FEED = 'FEED';
  static const CONTENT = 'CONTENT';
}