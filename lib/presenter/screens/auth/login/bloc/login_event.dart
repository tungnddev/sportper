class LoginEvent {

}

class LoginStartLogin extends LoginEvent {
  final String email;
  final String password;
  LoginStartLogin(this.email, this.password);
}