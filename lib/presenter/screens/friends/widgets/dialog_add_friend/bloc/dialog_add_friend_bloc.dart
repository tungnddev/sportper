import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/bloc/dialog_add_friend_event.dart';
import 'package:sportper/presenter/screens/friends/widgets/dialog_add_friend/bloc/dialog_add_friend_state.dart';

class DialogAddFriendBloc
    extends Bloc<DialogAddFriendEvent, DialogAddFriendState> {

  final UserRepository userRepository;

  DialogAddFriendBloc(this.userRepository) : super(DialogAddFriendInitial());

  @override
  Stream<DialogAddFriendState> mapEventToState(DialogAddFriendEvent event) async* {
    if (event is DialogAddFriendStartLoad) {
      try {
        yield DialogAddFriendLoading();
        final users = await userRepository.getAllUser();
        final currentUser = await userRepository.getCurrentUser();
        users.removeWhere((element) => element.id == currentUser?.id);
        yield DialogAddFriendLoadSuccess(users);
      } catch (e) {
        yield DialogAddFriendLoadSuccess([]);
      }
    }
  }
}
