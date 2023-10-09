class ForgotPasswordState {
  const ForgotPasswordState();
}

class ForgotPasswordInitial extends ForgotPasswordState {
  const ForgotPasswordInitial();
}

class ForgotPasswordSuccessful extends ForgotPasswordState {

}

class ForgotPasswordLoading extends ForgotPasswordState {

}

class ForgotPasswordHideLoading extends ForgotPasswordState {

}

class ForgotPasswordFailMessage extends ForgotPasswordState {
  String errorText;
  ForgotPasswordFailMessage(this.errorText);
}

class ForgotPasswordFail extends ForgotPasswordState {
  Object error;
  ForgotPasswordFail(this.error);
}
