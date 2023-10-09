class RegisterEvent {

}

class RegisterStartRegister extends RegisterEvent {
  final Map<String, dynamic> data;
  RegisterStartRegister(this.data);
}