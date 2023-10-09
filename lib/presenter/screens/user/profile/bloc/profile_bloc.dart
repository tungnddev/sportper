import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';
import 'package:sportper/presenter/screens/user/profile/bloc/profile_event.dart';
import 'package:sportper/presenter/screens/user/profile/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  UserRepository userRepository;
  AuthRepository authRepository;
  String? userId;

  ProfileBloc(this.userRepository, this.authRepository, {this.userId})
      : super(ProfileStateInitial());

  @override
  Stream<ProfileState> mapEventToState(ProfileEvent event) async* {
    if (event is ProfileEventStartLoad) {
      yield* mapFetch();
    } else if (event is ProfileEventLogOut) {
      yield* mapLogOut();
    } else if (event is ProfileEventFillNewVM) {
      yield* mapFillNewVM(event.vm);
    }
  }

  Stream<ProfileState> mapFetch() async* {
    try {
      yield ProfileStateLoading();
      final currentAuth = await authRepository.currentUser();
      final SportperUser? user = userId == null
          ? (await userRepository.getCurrentUser())
          : (await userRepository.getUser(userId!));
      if (currentAuth == null || user == null) return;

      yield ProfileStateFetch(SportperUserVM(user), canEdit: user.id == currentAuth.uid);
    } catch (e) {
      yield ProfileStateFailed(e);
    }
  }

  Stream<ProfileState> mapLogOut() async* {
    try {
      yield ProfileStateShowLoading();
      await authRepository.logOut();
      yield ProfileStateHideLoading();
      yield ProfileStateLogOutSuccessful();
    } catch (e) {
      yield ProfileStateHideLoading();
      yield ProfileStateFailed(e);
    }
  }

  Stream<ProfileState> mapFillNewVM(SportperUserVM vm) async* {
    yield ProfileStateFetch(vm, canEdit: true);
  }
}
