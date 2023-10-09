import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportper/domain/entities/signIn_method.dart';
import 'package:sportper/domain/entities/user.dart';
import 'package:sportper/domain/repositories/auth_repository.dart';
import 'package:sportper/domain/repositories/user_repository.dart';
import 'package:sportper/utils/extensions/extensions.dart';

import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

class ForgotPasswordBloc extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  BuildContext context;
  AuthRepository authRepository;
  UserRepository userRepository;
  ForgotPasswordBloc(this.context, this.authRepository, this.userRepository) : super(ForgotPasswordInitial());


  @override
  Stream<ForgotPasswordState> mapEventToState(ForgotPasswordEvent event) async* {
    if (event is ForgotPasswordStartForgotPassword) {
      try {
        yield ForgotPasswordLoading();
        await authRepository.resetPassword(event.email);
        yield ForgotPasswordHideLoading();
        yield ForgotPasswordSuccessful();
      } catch (error) {
        yield ForgotPasswordHideLoading();
        yield(ForgotPasswordFail(error));
      }
    }
  }
}