class LoginState {
  const LoginState();
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

class LoginSuccessful extends LoginState {

}

class LoginLoading extends LoginState {

}

class LoginHideLoading extends LoginState {

}

class LoginFailMessage extends LoginState {
  String errorText;
  LoginFailMessage(this.errorText);
}

class LoginFail extends LoginState {
  Object error;
  LoginFail(this.error);
}
