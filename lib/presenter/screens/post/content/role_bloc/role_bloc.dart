import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/screens/post/content/role_bloc/role_event.dart';
import 'package:sportper/presenter/screens/post/content/role_bloc/role_state.dart';

class RoleBloc extends Bloc<RoleEvent, RoleState> {
  UserRepository repository;

  RoleBloc(this.repository) : super(RoleStateInitial());

  @override
  Stream<RoleState> mapEventToState(RoleEvent event) async* {
    if (event is RoleEventStartLoad) {
      try {
        final user = await repository.getCurrentUser();
        yield RoleStateSuccessful(user?.role == SportperUserRole.admin);
      } catch (e) {}
    }
  }
}
