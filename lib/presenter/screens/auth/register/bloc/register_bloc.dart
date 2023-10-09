import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/login_vm.dart';
import 'package:sportper/utils/definded/avatars.dart';
import 'package:sportper/utils/definded/strings.dart';
import 'package:sportper/utils/extensions/extensions.dart';

import 'register_event.dart';
import 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  BuildContext context;
  AuthRepository authRepository;
  UserRepository userRepository;

  RegisterBloc(this.context, this.authRepository, this.userRepository)
      : super(RegisterInitial());

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is RegisterStartRegister) {
      try {
        yield RegisterLoading();
        final isValidUser =
            await userRepository.isValidUsername(event.data['username']);
        if (!isValidUser) {
          yield RegisterHideLoading();
          yield RegisterFailMessage(Strings.usernameExist);
          return;
        }

        final isValidPhone =
        await userRepository.isValidPhone(event.data['phoneNumber']);
        if (!isValidPhone) {
          yield RegisterHideLoading();
          yield RegisterFailMessage(Strings.phoneExist);
          return;
        }

        final firebaseUser = await authRepository.createUserWithEmail(
            event.data['email'], event.data['password']);
        if (firebaseUser == null) {
          yield RegisterHideLoading();
          yield RegisterFailMessage('No user found for that email.');
          return;
        }
        final newSportperUser = await getNewUserByEmail(event.data);
        await userRepository.addUser(firebaseUser.uid, newSportperUser);
        yield RegisterHideLoading();
        yield RegisterSuccessful();
      } catch (error) {
        yield RegisterHideLoading();
        yield (RegisterFail(error));
      }
    }
  }

  Future<void> updateNewConfig(String id) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await userRepository.updateFcmToken(id, token);
  }

  Future<SportperUser> getNewUserByEmail(Map<String, dynamic> data) async {
    String? token = await FirebaseMessaging.instance.getToken();
    return SportperUser(
        '',
        data['username'],
        data['fullName'],
        data['phoneNumber'],
        data['zipCode'],
        data['aboutMe'],
        token ?? '',
        false,
        false,
        false,
        false,
        [],
        SignInMethod.email,
        DateTime.now().toUtc().toIso8601String(),
        AvatarGenerate.get(),
        [],
        null,
        0,
        null,
        SportperUserRole.user);
  }
}
