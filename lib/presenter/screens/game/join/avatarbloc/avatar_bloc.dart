import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_event.dart';
import 'package:sportper/presenter/screens/game/join/avatarbloc/avatar_state.dart';

class AvatarBloc extends Bloc<AvatarEvent, AvatarState> {

  UserRepository _repository;

  AvatarBloc(this._repository) : super(AvatarStateInitial());

  @override
  Stream<AvatarState> mapEventToState(AvatarEvent event) async* {
    if (event is AvatarEventLoad) {
      final currentUser = await _repository.getCurrentUser();
      if (currentUser == null) return;
      yield AvatarStateSuccessful(currentUser.avatar);
    }
  }
}