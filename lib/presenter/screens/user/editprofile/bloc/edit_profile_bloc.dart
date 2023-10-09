import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/storate_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/sportper_user_vm.dart';

import 'edit_profile_event.dart';
import 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  UserRepository userRepository;
  AuthRepository authRepository;
  StorageRepository storageRepository;

  String? lastAvatarLocalPath;
  SportperUserVM currentVM;

  EditProfileBloc(this.userRepository, this.authRepository, this.storageRepository, this.currentVM)
      : super(EditProfileStateInitial());

  @override
  Stream<EditProfileState> mapEventToState(EditProfileEvent event) async* {
    if (event is EditProfileEventSave) {
      yield* mapSave(event.data);
    }
  }

  Stream<EditProfileState> mapSave(Map<String, dynamic> data) async* {
    try {
      yield EditProfileStateShowLoading();
      // check upload image
      Map<String, dynamic> dataNeedChange = Map.from(data);
      if (lastAvatarLocalPath != null) {
        String url = await storageRepository.uploadAvatar(lastAvatarLocalPath!);
        dataNeedChange['avatar'] = url;
      }
      final newUser = await userRepository.updateUser(dataNeedChange);
      yield EditProfileStateHideLoading();
      yield EditProfileStateSuccess(SportperUserVM(newUser!));
    } catch (e) {
      yield EditProfileStateHideLoading();
      yield EditProfileStateFailed(e);
    }
  }
}
