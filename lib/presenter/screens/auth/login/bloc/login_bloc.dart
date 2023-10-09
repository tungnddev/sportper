import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/presenter/models/login_vm.dart';
import 'package:sportper/utils/extensions/extensions.dart';

import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  BuildContext context;
  AuthRepository authRepository;
  UserRepository userRepository;
  LoginBloc(this.context, this.authRepository, this.userRepository) : super(LoginInitial());


  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is LoginStartLogin) {
      try {
        yield LoginLoading();
        final firebaseUser = await authRepository.loginWithEmail(event.email, event.password);
        if (firebaseUser == null) {
          yield LoginHideLoading();
          yield LoginFailMessage('No user found for that email.');
          return;
        }
        await updateNewConfig(firebaseUser.uid);
        yield LoginHideLoading();
        yield LoginSuccessful();
      } catch (error) {
        yield LoginHideLoading();
        yield(LoginFail(error));
      }
    }
  }

  Future<void> updateNewConfig(String id) async {
    String? token = await FirebaseMessaging.instance.getToken();
    if (token == null) return;
    await userRepository.updateFcmToken(id, token);
  }
}