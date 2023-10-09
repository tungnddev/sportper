class RegisterState {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterSuccessful extends RegisterState {

}

class RegisterLoading extends RegisterState {

}

class RegisterHideLoading extends RegisterState {

}

class RegisterFailMessage extends RegisterState {
  String errorText;
  RegisterFailMessage(this.errorText);
}

class RegisterFail extends RegisterState {
  Object error;
  RegisterFail(this.error);
}
