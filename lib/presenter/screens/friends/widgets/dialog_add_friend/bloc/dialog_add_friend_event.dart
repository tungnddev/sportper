import 'package:sportper/domain/entities/user.dart';

class DialogAddFriendState {

}

class DialogAddFriendInitial extends DialogAddFriendState {

}

class DialogAddFriendLoading extends DialogAddFriendState {

}

class DialogAddFriendLoadSuccess extends DialogAddFriendState {
  List<SportperUser> users;
  DialogAddFriendLoadSuccess(this.users);
}
