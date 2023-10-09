class ForgotPasswordEvent {

}

class ForgotPasswordStartForgotPassword extends ForgotPasswordEvent {
  final String email;
  ForgotPasswordStartForgotPassword(this.email);
}